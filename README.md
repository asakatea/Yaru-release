# Yaru Release Repository

Yaru is closed-source software. This repository is the public release surface for Yaru installers, update metadata, issue tracking, and user-facing documentation. In the main Yaru monorepo it is also used as the `Monorepo/distribution/release` submodule.

## Language Entry

- English: [`README_en.md`](./README_en.md)
- 绠€浣撲腑鏂? [`README_zh.md`](./README_zh.md)

## What This Repository Contains

- **GitHub Releases** for downloadable installers and packages
- **`latest.json`** for in-app update checks and release metadata
- **Issues** for bug reports, feature requests, and release feedback
- **`docs/`** for user-oriented documentation in multiple languages
- **Release maintenance helpers** such as `.github/workflows/auto-update-latest-json.yml` and `scripts/update-latest-json.sh`

## Key Links

- Releases: <https://github.com/ProjectYaru/Yaru-release/releases>
- Issues: <https://github.com/ProjectYaru/Yaru-release/issues>
- Download landing page: <https://yaru.asaka.moe/download>
- English docs: [`docs/en/`](./docs/en/)
- 绠€浣撲腑鏂囨枃妗? [`docs/zh/`](./docs/zh/)
- 绻侀珨涓枃鏂囨獢: [`docs/zh_Hant/`](./docs/zh_Hant/)

## Relationship to the Main Release Pipeline

The main Yaru monorepo owns the primary publish workflow. That workflow builds multi-platform artifacts, uploads them to the GitHub Release in this repository, merges and validates `latest.json`, and only after a successful validation performs a GET request to <https://yaru.asaka.moe/download> to warm the public download entry page.

This repository keeps its own `auto-update-latest-json` workflow as a recovery and resync utility. It is useful when `latest.json` needs to be regenerated from the latest published GitHub Release, but it is not the authoritative signal for 鈥渁 new version has just finished publishing鈥?

## Source of Truth and Sync Expectations

- **GitHub Releases** and **`latest.json`** are the authoritative sources for shipped binaries and update metadata.
- The landing page at <https://yaru.asaka.moe/download> is the public product entry point, but its displayed download buttons or release summary may be maintained separately from `latest.json`.
- If the landing page and the release assets differ temporarily, check the GitHub Release and `latest.json` first.

