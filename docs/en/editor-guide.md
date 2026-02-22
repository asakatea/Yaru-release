# Editor Guide

## Audience and scope
The editor is Yaru's core writing surface for notes, explanations, and structured learning content.

## Entry paths
- Notes editor
- Studio/editor-related pages
- Embedded editor areas in content workflows

## Implementation baseline (2026-02-17, Web/WASM)
- WebAssembly build is a required path: `flutter build web --wasm`.
- Editor integration must go through `Monorepo/packages/editor`.
- Current editor backend is `appflowy_editor_wasm` (WASM-compatible).
- Flutter app code must not directly use `dart:html` or `package:universal_html/*`.
- Web conditional imports must use `if (dart.library.js_interop)`.
- Detailed baseline: `Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`.

## Core capabilities
- Block-based writing and rich text editing
- Slash-style insertion for common block types
- Callout, toggle, math, flashcard, and YNS blocks
- YFM import/export support

## YFM support
Yaru supports both legacy YFM and directive-style YFM syntax. See architecture docs for parser details and compatibility notes.

## Typical workflow
1. Draft content in paragraph/heading blocks.
2. Add math/callout/toggle blocks where needed.
3. Convert key statements into flashcards.
4. Export or sync content to downstream modules.

## Practical tips
- Keep one concept per block for easier reuse.
- Use headings for stable structure before styling details.
- Validate YFM when moving content between editors.

## Troubleshooting
- Block rendering mismatch: verify block attributes and app version.
- Imported markdown looks flat: check whether YFM attributes were preserved.
- Flashcard conversion missing: ensure card metadata exists on the block.

## Related docs
- `notes-guide`
- `memory-guide`
- `developer-guide`
- `troubleshooting-guide`
