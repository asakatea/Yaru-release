 # AGENT.md

  Last updated: 2026-03-08

  ## Objective

  This repository is the public release surface for Yaru.

  When working in `ProjectYaru/Yaru-release`, the agent is expected to:
  - orchestrate release builds from the source repository,
  - build Windows, Android, Web, and Linux artifacts in parallel when possible,
  - package Windows with Inno Setup,
  - package Linux with AppImage tooling,
  - publish assets and update manifests in this repository,
  - push Web artifacts to `ProjectYaru/Yaru-VerWeb`,
  - write user-friendly changelogs from recent commits and PRs,
  - verify that public download/update/deploy paths are actually working.

  This repository is not the main source tree. The actual app build must be performed from the Yaru source repository,
  usually `ProjectYaru/Yaru`.

  ## Scope

  This repository is responsible for:
  - GitHub Releases
  - release-facing documentation
  - `latest.json`
  - `yaru-latest.json`
  - `yaru-<version>-history.json`
  - release notes and changelog text quality
  - public release metadata correctness

  This repository is not responsible for application feature development itself.

  ## Source Repository Assumption

  Unless the user says otherwise, assume the source repository is a sibling or separately cloned working tree of
  `ProjectYaru/Yaru`.

  The build root is expected to be:

  - `ProjectYaru/Yaru/Monorepo/apps/Flutter`

  If the source repo is missing, stop and say the release cannot be built from `Yaru-release` alone.

  ## Manual Release Rule

  For real release work, do not hide the process behind one-click scripts unless the user explicitly asks for that.

  The default expectation is:
  - run the build commands manually,
  - package artifacts manually,
  - upload manually,
  - verify manually.

  Automation helpers are allowed only when the user explicitly asks for them or when they are already the accepted
  project standard.

  ## Release Branching Rule For This Repo

  This repository is a release/distribution surface.

  If the task is a real release publication for `Yaru-release`, direct commit and push to `main` is allowed when needed
  to publish:
  - manifest updates,
  - README/docs fixes,
  - release metadata fixes.

  For non-release documentation or maintenance changes, normal PR flow is still preferred.

  ## Required Tools

  ### Windows host
  The Windows release machine should have:
  - Git
  - GitHub CLI (`gh`)
  - Flutter SDK
  - Android SDK
  - Visual Studio with Desktop C++ workload
  - Inno Setup 6 (`ISCC.exe`)
  - PowerShell
  - Rust / Cargo if the Flutter project requires Rust-side generation or Web/WASM support
  - any project-required Flutter/Rust generators already installed

  ### Arch Linux WSL
  The Linux build environment should have:
  - `flutter`
  - `clang`
  - `cmake`
  - `ninja`
  - `pkgconf`
  - `gtk3`
  - `patchelf`
  - `desktop-file-utils`
  - `squashfs-tools`
  - `fuse2`
  - `tar`
  - `zip`
  - `git`
  - `curl`
  - `appimagetool` or a verified local copy such as `~/.local/bin/appimagetool`

  ## Official Build Matrix

  Run all Flutter builds from the source repo path:
  - `ProjectYaru/Yaru/Monorepo/apps/Flutter`

  ### Windows host builds

  #### Android
  ```powershell
  flutter build apk --release --obfuscate --split-debug-info=build/android/symbols --tree-shake-icons --split-per-abi
  --target-platform android-arm,android-arm64,android-x64
  ```

  #### Windows
  ```powershell
  flutter build windows --release --obfuscate --split-debug-info=build/windows/symbols --tree-shake-icons
  ```

  #### Web (WASM)
  ```powershell
  flutter build web --wasm
  ```

  ### Arch Linux WSL build

  #### Linux
  ```bash
  flutter build linux --release --obfuscate --split-debug-info=build/linux/symbols --tree-shake-icons
  ```

  ## Parallel Build Policy

  The default release expectation is parallel execution.

  If the machine is healthy enough, start these four build lanes at the same time:

  1. Android build on Windows
  2. Windows desktop build on Windows
  3. Web WASM build on Windows
  4. Linux desktop build inside Arch Linux WSL

  Only serialize builds if:
  - memory pressure becomes unstable,
  - disk IO becomes a bottleneck,
  - toolchain locks or generator conflicts make parallel builds unreliable.

  Do not claim the release is “parallelized” if everything was actually run one by one.

  ## Recommended Parallel Execution Order

  ### Lane A: Android
  Run from Windows in the Flutter source directory:
  ```powershell
  flutter build apk --release --obfuscate --split-debug-info=build/android/symbols --tree-shake-icons --split-per-abi
  --target-platform android-arm,android-arm64,android-x64
  ```

  Expected raw outputs usually include:
  - `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
  - `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
  - `build/app/outputs/flutter-apk/app-x86_64-release.apk`

  ### Lane B: Windows desktop
  Run from Windows in the Flutter source directory:
  ```powershell
  flutter build windows --release --obfuscate --split-debug-info=build/windows/symbols --tree-shake-icons
  ```

  Expected raw output usually includes:
  - `build/windows/x64/runner/Release/`

  ### Lane C: Web WASM
  Run from Windows in the Flutter source directory:
  ```powershell
  flutter build web --wasm
  ```

  Expected raw output usually includes:
  - `build/web/`

  ### Lane D: Linux desktop in Arch Linux WSL
  Run inside Arch Linux WSL in the Flutter source directory:
  ```bash
  flutter build linux --release --obfuscate --split-debug-info=build/linux/symbols --tree-shake-icons
  ```

  Expected raw output usually includes:
  - `build/linux/x64/release/bundle/`

  ## Packaging Rules

  ## Windows Packaging

  Windows release publication normally produces:
  - one installer EXE
  - one portable ZIP

  ### Portable ZIP
  Package the built Windows release directory into:
  - `yaru-<version>-windows-x64-portable.zip`

  The ZIP should contain the built Windows app files from:
  - `build/windows/x64/runner/Release/`

  ### Inno Setup installer
  Windows installer packaging must use Inno Setup.

  Do not handwave “the EXE installer exists”; explicitly invoke the Inno Setup compiler.

  Expected packaging tool:
  - `ISCC.exe`
  - usually from `C:\Program Files (x86)\Inno Setup 6\ISCC.exe`

  Expected packaging input:
  - a verified `.iss` script, such as `win.iss`

  Expected packaging output:
  - `yaru-<version>-windows-x64-setup.exe`

  Example invocation:
  ```powershell
  & "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" "C:\path\to\win.iss"
  ```

  If the `.iss` script supports release macros, pass the version/output values that the template expects.

  The agent must verify:
  - the installer was rebuilt from the current Windows build output,
  - the produced filename matches the release naming convention,
  - the EXE is the actual Inno Setup output, not a renamed placeholder.

  ## Android Packaging

  Rename or copy the APK outputs to stable release names:

  - `yaru-<version>-android-arm64-v8a.apk`
  - `yaru-<version>-android-armeabi-v7a.apk`
  - `yaru-<version>-android-x86_64.apk`

  Do not upload raw `app-*.apk` names to the release unless the project explicitly wants that.

  ## Linux Packaging

  Linux release publication normally produces:
  - one `tar.gz`
  - one `AppImage`

  ### tar.gz
  Archive the Linux bundle directory into:
  - `yaru-<version>-linux-x64.tar.gz`

  The tarball should be created from:
  - `build/linux/x64/release/bundle/`

  ### AppImage
  Linux desktop release packaging must use AppImage tooling.

  Do not stop at the raw Flutter Linux bundle if the release asks for AppImage.

  Expected packaging tool:
  - `appimagetool`

  Expected final output:
  - `yaru-<version>-linux-x64.AppImage`

  The agent must:
  1. prepare an `AppDir`,
  2. place the Linux bundle into the AppDir,
  3. provide `AppRun`,
  4. provide a `.desktop` file,
  5. provide an icon,
  6. mark required files executable,
  7. invoke `appimagetool`,
  8. verify the `.AppImage` file was actually produced.

  Example invocation shape:
  ```bash
  ~/.local/bin/appimagetool <AppDir> yaru-<version>-linux-x64.AppImage
  ```

  If the source repo already contains a known AppImage template or packaging assets, reuse them instead of inventing a
  new layout.

  If no AppImage packaging assets exist, the agent must say so explicitly and build them carefully instead of pretending
  the raw Linux bundle is already an AppImage.

  ## Web Publication

  The Web/WASM artifact is not uploaded as a normal desktop/mobile binary.

  The expected publication flow is:
  1. build the Web artifact from the source repo,
  2. push the built web output to `ProjectYaru/Yaru-VerWeb`,
  3. verify that the push triggered actual deployment,
  4. confirm the public endpoint is serving the new build.

  Do not say “web published” unless the push and deploy path were both verified.

  ## Release Asset Naming Convention

  Use the following stable asset names:

  - `yaru-<version>-windows-x64-setup.exe`
  - `yaru-<version>-windows-x64-portable.zip`
  - `yaru-<version>-android-arm64-v8a.apk`
  - `yaru-<version>-android-armeabi-v7a.apk`
  - `yaru-<version>-android-x86_64.apk`
  - `yaru-<version>-linux-x64.AppImage`
  - `yaru-<version>-linux-x64.tar.gz`
  - `latest.json`
  - `yaru-latest.json`
  - `yaru-<version>-history.json`

  Do not mix old naming schemes and new naming schemes within the same release.

  ## Manifest Update Rules

  For every real release, update:
  - `latest.json`
  - `yaru-latest.json`
  - `yaru-<version>-history.json`

  These files should be consistent with the actual uploaded assets.

  At minimum they should correctly describe:
  - `version`
  - `build_number`
  - `release_date`
  - `min_supported_version`
  - per-platform URLs
  - per-platform SHA-256 values
  - per-platform sizes
  - `release_notes_url`
  - bilingual changelog entries when the project expects bilingual release notes

  Do not upload manifests before verifying the final asset names and checksums.

  ## Changelog Policy

  The changelog must be written from actual recent work, not from guesswork.

  The source set must include:
  - root repository commits
  - relevant submodule commits
  - relevant PRs
  - release-relevant deploy/web/docs repositories if they changed during this release cycle

  The comparison range should be based on:
  - the previous release tag, or
  - the previous release timestamp

  Write the changelog in a user-friendly structure:
  - summarize what changed for users first,
  - group changes into themes,
  - keep raw commit lists as a detailed source section if needed,
  - do not expose only internal implementation jargon.

  Preferred themes:
  - learning flow improvements
  - editor/studio/library fixes
  - backend stability
  - accessibility
  - branding/site updates
  - release/deployment pipeline improvements

  If the release surface is bilingual, the release notes should also be bilingual.

  ## Release Text Quality Rules

  All user-facing text in this repo must be UTF-8 clean.

  Before finishing release work, explicitly inspect:
  - `README.md`
  - `README_en.md`
  - `README_zh.md`
  - `latest.json`
  - release bodies on GitHub Releases

  Watch for mojibake markers such as:
  - `鈿`
  - `銈`
  - `锟`
  - `Ã`
  - `Â`
  - unexpected bursts of `?` inside Chinese text

  Do not trust default Windows terminal rendering alone.
  Use UTF-8 aware inspection before declaring text clean.

  ## GitHub Release Publishing

  For a real release, the agent should:

  1. create or update the GitHub Release in `ProjectYaru/Yaru-release`,
  2. upload all packaged assets,
  3. upload the final manifests,
  4. write or replace the release body,
  5. verify the release asset list,
  6. verify the release notes body,
  7. verify that the release’s `latest.json` download is correct.

  Typical `gh` usage may include:
  ```powershell
  gh release create <version> --repo ProjectYaru/Yaru-release --title <version> --notes-file <release-notes-file>
  gh release upload <version> <files...> --repo ProjectYaru/Yaru-release --clobber
  gh release edit <version> --repo ProjectYaru/Yaru-release --notes-file <release-notes-file>
  ```

  Do not mark release publishing complete until the uploaded asset list matches the manifests.

  ## Web Deploy Publication

  If Web is part of the release:

  1. publish the built web artifact to `ProjectYaru/Yaru-VerWeb`,
  2. push to the remote repository,
  3. verify whether the environment is truly push-to-deploy,
  4. inspect the public web endpoint or the VPS/container route serving it,
  5. only then report success.

  ## Verification Checklist

  The release is not complete until all of the following are checked:

  - Windows EXE exists and was produced by Inno Setup
  - Windows ZIP exists and opens correctly
  - all three Android APKs exist
  - Linux `tar.gz` exists
  - Linux `AppImage` exists and was produced by `appimagetool`
  - Web build was pushed to `ProjectYaru/Yaru-VerWeb`
  - GitHub Release body is readable and correct
  - release assets match the manifest URLs
  - `latest.json` is valid from the release asset URL
  - `https://update.asaka.moe/latest.json` is valid and current
  - release-facing docs have no mojibake
  - release notes have no mojibake
  - public web deployment is serving the expected build

  ## Recommended User-Facing Package Guidance

  Use these defaults unless the product strategy changes:

  - Windows users should usually download the installer EXE first.
  - Portable ZIP is for users who explicitly want no installer.
  - Most Android users should download `arm64-v8a`.
  - `armeabi-v7a` is mainly for older 32-bit Android devices.
  - `x86_64` is mainly for emulators or the small number of x86 Android devices.
  - Linux desktop users should usually prefer `AppImage`.
  - `tar.gz` is for users who prefer manual extraction or custom packaging.
  - Users who do not want installation can use the Web/WASM build.

  ## Failure Handling

  If any one of these fails, do not claim the release is done:
  - build failed,
  - packaging failed,
  - Inno Setup was not actually invoked,
  - AppImage was not actually produced with AppImage tooling,
  - manifests do not match uploaded assets,
  - changelog was not derived from real commits/PRs,
  - Web push succeeded but deploy was not verified,
  - release text still contains mojibake.

  Be explicit about what succeeded, what failed, and what remains to be done.
