# 開發者手冊

## 適用人群
本手冊面向前後端工程師與內容維護者，說明 Yaru 文檔系統與模組協作邊界。

## 文檔系統結構
- 索引註冊：`Monorepo/apps/backend/worker/src/content/docs/index.ts`
- 公開路由：`Monorepo/apps/backend/worker/src/routes/docs.ts`
- Studio 覆寫：`Monorepo/apps/backend/worker/src/routes/studio-docs.ts`
- 三語正文：`src/content/docs/{en,zh,zh_Hant}/*.md`

## 關鍵變更：Flutter Web/WASM 基線（2026-02-17）
- `flutter build web --wasm` 已列為必須支持的構建路徑。
- Flutter 程式碼禁止直接使用 `dart:html` 與 `package:universal_html/*`。
- Web 條件導入統一使用 `if (dart.library.js_interop)`。
- 編輯器能力只能經由 `Monorepo/packages/editor` 使用（目前底層為 `appflowy_editor_wasm`）。
- 瀏覽器下載能力統一走 `web_download_stub.dart` / `web_download_web.dart`。
- 詳細基線說明：`Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`。

當鏡像源不穩定（例如 `pub.flutter-io.cn` 502）時，使用：

```bash
cd Monorepo/apps/Flutter
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter pub get
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter build web --wasm
```

## 新增/更新文檔規則
1. 三語 slug 必須對齊。
2. 同步更新 `index.ts` metadata 與正文映射。
3. docs API schema 保持穩定。
4. 文檔結構變更時提升 `CONTENT_VERSION`。

## 驗證命令
```bash
cd Monorepo
corepack pnpm --filter yaru-api typecheck
corepack pnpm --filter yaru-api test
```

文檔一致性測試位於 `src/content/docs/*.spec.ts`。

## 實作要點
- markdown 在 Worker 啟動時靜態載入，避免執行期檔案系統依賴。
- `zh` 語系可合併 `docs_overrides` 已發布覆寫。
- DB 異常不能中斷公開文檔讀取，必須回退到靜態內容。

## 排錯
- 文章 404：先檢查 slug 與語系對齊。
- 排序/分組異常：檢查 `sortOrder`、`category` 與 metadata。
- 正文缺失：檢查 import 與 `bodies` 映射。

## 相關文檔
- `studio-guide`
- `settings-guide`
- `troubleshooting-guide`
