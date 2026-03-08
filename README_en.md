**鈿狅笍 Notice: Yaru is closed-source software. This repository is only for releases, update metadata, issue tracking, and user-facing documentation.**

# Yaru

Yaru (from Japanese "銈勩倠", meaning "to do") is an all-in-one learning workbench designed around a complete loop: **Input 鈫?Consolidation 鈫?Output 鈫?Feedback**.

## Repository Scope

This repository is the public release surface for Yaru. It is mainly used for:

1. **Releases**: downloadable installers and packages for each platform
2. **Update metadata**: `latest.json` consumed by update flows and release tooling
3. **Issues**: bug reports, feature requests, and release feedback
4. **Docs**: user-facing guides under `docs/`

In the main Yaru monorepo, this repository is also used as the `Monorepo/distribution/release` submodule.

## Download Entry Points

- GitHub Releases: <https://github.com/ProjectYaru/Yaru-release/releases>
- Product download page: <https://yaru.asaka.moe/download>

Use GitHub Releases when you need the raw published assets directly. Use the landing page when you want the public-facing download entry from the Yaru website.

## Update Mechanism

Yaru release metadata is centered around `latest.json`:

- `latest.json` records the current released version, release date, minimum supported version, and per-platform download URLs/checksums.
- The main publish workflow in the Yaru monorepo builds artifacts, uploads them to the GitHub Release in this repository, merges platform data into `latest.json`, and verifies the uploaded manifest from the Release download URL.
- After the Release assets and remote `latest.json` are verified, the publish workflow performs a GET request to <https://yaru.asaka.moe/download> so the public download page is visited/warmed as part of the successful release path.

Important: this page visit does **not** by itself rewrite the landing page's button data source. If the website still shows placeholder links or stale release information, that is a separate website-data issue rather than a release upload failure.

## Release Flow Overview for Maintainers

1. Build artifacts for supported platforms in the main Yaru monorepo.
2. Publish or update the GitHub Release in `ProjectYaru/Yaru-release`.
3. Upload installers/packages and generate merged `latest.json`.
4. Verify `latest.json` from the Release download URL.
5. Ping <https://yaru.asaka.moe/download> with a GET request after verification succeeds.
6. If needed, use this repository's `auto-update-latest-json` workflow to resync `latest.json` from the latest published GitHub Release.

## Key Files

- `latest.json`: canonical public update manifest stored in this repository
- `.github/workflows/auto-update-latest-json.yml`: local workflow that can regenerate `latest.json` from the latest GitHub Release on schedule, on release publish, or manually
- `scripts/update-latest-json.sh`: helper script used by the workflow above to query the GitHub Releases API and rewrite `latest.json`
- `docs/`: user-oriented documentation shipped alongside the release repository

## Quick Links

- Releases: <https://github.com/ProjectYaru/Yaru-release/releases>
- Issues: <https://github.com/ProjectYaru/Yaru-release/issues>
- Download landing page: <https://yaru.asaka.moe/download>
- English docs: [`docs/en/`](./docs/en/)
- Chinese docs (Simplified): [`docs/zh/`](./docs/zh/)
- Chinese docs (Traditional): [`docs/zh_Hant/`](./docs/zh_Hant/)

## Sync Expectations and Troubleshooting

- If a GitHub Release is already published but the landing page still looks unchanged for a short period, first verify the Release assets and `latest.json` before assuming the publish failed.
- If `latest.json` is missing platform entries or points to incorrect assets, inspect the main publish workflow logs and the generated Release assets first.
- If the landing page itself still shows placeholder buttons or static release text, check the website implementation separately. That content is not automatically rewritten just by publishing a new Release.

## Why Yaru

Many tools are great, but usually cover only one phase:

- Input is easy, but moving into consolidation/output is fragmented
- Flashcards work, but card creation is expensive and context is often lost
- Note systems are powerful, but users can get trapped in system-building
- Cross-device workflows are often broken, especially on mobile

Yaru connects these phases into one continuous learning workflow.

## Core Modules

- **馃摉 Learn**: roadmap-based interactive learning (Brilliant / Math Academy style)
- **馃摎 Library**: supports PDF / EPUB / MOBI / AZW3 / Markdown / HTML
- **馃 Memory**: spaced repetition + active recall
- **鉁嶏笍 Create**: block editor for structured content
- **馃З Extensions**: planned browser extension, RSS, and video-summary import
- **馃摑 Notes / Problem Bank / Community**: in progress

## Highlights

- Material You design, clean and ad-free
- Cross-platform: Android / Windows / Linux / macOS / Web
- Unified learning + memory workflow with less import/export overhead
- Context-preserving flow to reduce fragmented knowledge

## Screenshots

### Desktop

| Home | Learn |
|---|---|
| ![Desktop Homepage](pics/desktop/en/homepage.png) | ![Desktop Study](pics/desktop/en/study.png) |

| Library | Memory |
|---|---|
| ![Desktop Library](pics/desktop/en/library.png) | ![Desktop Memory](pics/desktop/en/memoryhub.png) |

| Create | Mine |
|---|---|
| ![Desktop Create](pics/desktop/en/cr.png) | ![Desktop Mine](pics/desktop/en/mine.png) |

### Mobile

| Home | Learn |
|---|---|
| ![Mobile Homepage](pics/mobile/en/mainpage.png) | ![Mobile Study](pics/mobile/en/study_page.png) |

| Library | Memory |
|---|---|
| ![Mobile Library](pics/mobile/en/library.png) | ![Mobile Memory](pics/mobile/en/memory_hub.png) |

| Note Blocks Editor | Mine |
|---|---|
| ![Mobile Note Blocks Editor](pics/mobile/en/note_blocks_editor.png) | ![Mobile Mine](pics/mobile/en/mine.png) |

## Language Versions

- Chinese: [`README_zh.md`](./README_zh.md)
- English: [`README_en.md`](./README_en.md)

