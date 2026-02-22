# 編輯器指南

## 模組定位
編輯器是 Yaru 的核心內容生產界面，適合整理筆記、題解、公式與結構化學習內容。

## 入口路徑
- 筆記編輯頁
- Studio 相關編輯頁
- 內嵌編輯器場景

## 關鍵實作基線（2026-02-17，Web/WASM）
- `flutter build web --wasm` 為必須支持的構建路徑。
- 編輯器接入必須統一經由 `Monorepo/packages/editor`。
- 目前編輯器底層為 `appflowy_editor_wasm`（WASM 相容實作）。
- Flutter 程式碼禁止直接使用 `dart:html` 與 `package:universal_html/*`。
- Web 條件導入統一使用 `if (dart.library.js_interop)`。
- 詳細基線請見：`Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`。

## 核心能力
- 區塊式編輯與富文本
- 常見區塊的斜線插入
- Callout / Toggle / Math / Flashcard / YNS 區塊
- YFM 匯入與匯出

## YFM 支援
Yaru 目前同時支援舊版 YFM 與 directive 風格 YFM。完整語法請見架構文檔中的 YFM 規範。

## 典型流程
1. 先完成段落與標題骨架。
2. 插入數學、提醒與折疊區塊。
3. 將重點句轉為閃卡。
4. 匯出或同步到其他模組。

## 效率建議
- 每個區塊儘量只承載一個概念。
- 先穩定結構，再做樣式細節。
- 跨編輯器搬運內容時先驗證 YFM。

## 排錯
- 區塊渲染不一致：檢查區塊屬性與版本。
- 匯入後格式扁平：確認 YFM 屬性是否保留。
- 無法轉閃卡：確認區塊已寫入卡片中繼資料。

## 相關文檔
- `notes-guide`
- `memory-guide`
- `developer-guide`
- `troubleshooting-guide`
