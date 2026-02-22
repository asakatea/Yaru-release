# 常見問題與排錯

## 使用範圍
本指南用於快速定位 Yaru 的常見問題：登入、同步、內容載入與 AI 功能異常。

## 快速排查清單
1. 確認應用版本與帳號狀態。
2. 確認網路與後端可達。
3. 用最小步驟重現一次問題。
4. 記錄路徑、模組與錯誤訊息。

## 常見問題分組
- 登入與會話過期
- 內容缺失或過舊
- 語系與翻譯不一致
- AI provider/閘道錯誤
- 重頁面性能退化
- Web/WASM 構建失敗

## 建議檢查順序
1. 會話與權限
2. 網路與 API 可達性
3. 模組配置
4. 數據一致性與快取刷新

## 升級支援前請準備
- 發生時間與時區
- 平台/裝置與版本
- 路由路徑與操作步驟
- 錯誤碼或截圖
- 可重現步驟

## `flutter build web --wasm` 失敗處理（關鍵）
若錯誤包含 `dart:html` / `universal_html`：

1. 檢查 Flutter 業務程式碼是否直接導入 `dart:html` 或 `package:universal_html/*`。
2. 檢查 Web 條件導入是否統一為 `if (dart.library.js_interop)`。
3. 若鏡像源不穩（例如 `pub.flutter-io.cn` 回傳 502），改用官方源：

```bash
cd Monorepo/apps/Flutter
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter pub get
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter build web --wasm
```

4. 參照基線文檔：`Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`。

## 相關文檔
- `settings-guide`
- `developer-guide`
- `user-guide`
