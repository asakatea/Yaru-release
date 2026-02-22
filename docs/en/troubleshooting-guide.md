# Troubleshooting Guide

## Scope
Use this guide for fast diagnosis of common Yaru issues across login, sync, content loading, and AI features.

## Fast triage checklist
1. Confirm app version and account state.
2. Check network availability and backend reachability.
3. Reproduce once with minimal actions.
4. Capture route/module and error message.

## Common issue groups
- Authentication/session expiration
- Missing or stale content
- Locale/translation mismatch
- AI provider or gateway errors
- Performance regressions on heavy pages
- Flutter Web/WASM build failures

## Recommended order of checks
1. Session + permissions
2. Network + API reachability
3. Feature-specific config
4. Data consistency/cache refresh

## Escalation data to include
- Time and timezone
- Platform/device and app version
- Route path and operation
- Error code/message screenshot
- Steps to reproduce

## WebAssembly build failures (critical)
If `flutter build web --wasm` fails with `dart:html` / `universal_html` errors:

1. Confirm no direct app imports of `dart:html` or `package:universal_html/*`.
2. Confirm web conditional imports use `if (dart.library.js_interop)`.
3. Run build with official pub source if mirror is unstable:

```bash
cd Monorepo/apps/Flutter
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter pub get
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter build web --wasm
```

4. Verify baseline: `Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`.

## Related docs
- `settings-guide`
- `developer-guide`
- `user-guide`
