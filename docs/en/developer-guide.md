# Developer Guide

## Audience and scope
This guide is for frontend/backend engineers and content maintainers working on Yaru docs and module integrations.

## Docs system architecture
- Registry: `Monorepo/apps/backend/worker/src/content/docs/index.ts`
- Public routes: `Monorepo/apps/backend/worker/src/routes/docs.ts`
- Studio docs overrides: `Monorepo/apps/backend/worker/src/routes/studio-docs.ts`
- Content files: `src/content/docs/{en,zh,zh_Hant}/*.md`

## Critical Flutter Web/WASM baseline (2026-02-17)
- `flutter build web --wasm` is a required supported build path.
- Do not use `dart:html` or `package:universal_html/*` in Flutter app code.
- Use `if (dart.library.js_interop)` for web conditional imports.
- Consume editor APIs through `Monorepo/packages/editor` only (current backend: `appflowy_editor_wasm`).
- Browser download behavior must go through `web_download_stub.dart` / `web_download_web.dart`.
- Baseline doc: `Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`.

Recommended fallback when mirror source is unstable:

```bash
cd Monorepo/apps/Flutter
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter pub get
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter build web --wasm
```

## Rules for adding/updating docs
1. Keep slug parity across all locales.
2. Add/update metadata and body mappings in `index.ts`.
3. Preserve stable API schema for docs endpoints.
4. Bump `CONTENT_VERSION` when content structure changes.

## Validation commands
```bash
cd Monorepo
corepack pnpm --filter yaru-api typecheck
corepack pnpm --filter yaru-api test
```

Docs consistency is covered by specs under `src/content/docs/*.spec.ts`.

## Implementation notes
- Static markdown is embedded at module init for Worker compatibility.
- zh locale supports optional published override merge from `docs_overrides`.
- DB failure must not break static docs reads (fallback behavior).

## Troubleshooting
- 404 article: check slug mapping and locale parity.
- Wrong sort/grouping: check `sortOrder`, `category`, and metadata arrays.
- Body missing: verify imports and `bodies` record entries.

## Related docs
- `studio-guide`
- `settings-guide`
- `troubleshooting-guide`
- `editor-guide`
