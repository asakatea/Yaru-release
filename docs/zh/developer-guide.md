# 开发者手册

## 模块定位与适用人群
本手册面向前端/后端开发者、内容工程维护者与技术支持人员，重点说明 Yaru 文档系统与模块协作方式。

## 关键路径
- 文档索引：`Monorepo/apps/backend/worker/src/content/docs/index.ts`
- 公共 docs 路由：`Monorepo/apps/backend/worker/src/routes/docs.ts`
- Studio 覆写路由：`Monorepo/apps/backend/worker/src/routes/studio-docs.ts`
- 三语正文目录：`Monorepo/apps/backend/worker/src/content/docs/{en,zh,zh_Hant}`

## 关键变更：Flutter Web/WASM 基线（2026-02-17）
- `flutter build web --wasm` 已作为必须支持的构建路径。
- Flutter 代码中禁止直接使用 `dart:html` 和 `package:universal_html/*`。
- Web 条件导入统一使用 `if (dart.library.js_interop)`。
- 编辑器能力统一通过 `Monorepo/packages/editor` 暴露（当前底层为 `appflowy_editor_wasm`）。
- 浏览器下载能力统一走 `web_download_stub.dart` / `web_download_web.dart`。
- 详细基线文档：`Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`。

当镜像源不稳定（例如 `pub.flutter-io.cn` 502）时，使用：

```bash
cd Monorepo/apps/Flutter
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter pub get
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter build web --wasm
```

## 功能总览
| 能力 | 说明 | 状态 |
|---|---|---|
| 元数据注册 | `articlesMeta` 维护 title/category/icon/sortOrder/updatedAt | 已可用 |
| 三语正文映射 | `bodies` 保证每个 slug 在三语可解析 | 已可用 |
| locale 归一化 | `zh_Hant/zh-Hant/zh-TW` 等别名统一解析 | 已可用 |
| docs API | `GET /api/docs/articles` 与 `GET /api/docs/articles/:slug` | 已可用 |
| zh 覆写合并 | 通过 `docs_overrides` 合并已发布内容 | 已可用 |
| 一致性测试 | slug 对齐、body 完整、alias 校验 | 已可用 |

## 典型任务流程
1. 新增或修改文档时，先更新三语 metadata。
2. 同步更新三语 markdown 文件与 `bodies` 映射。
3. 如新增 icon key，同步 Flutter 端图标映射。
4. 结构级文档变更后递增 `CONTENT_VERSION`。
5. 执行 `typecheck + test`，验证 docs 一致性。

## 工程约束与注意事项
- docs API 需保持 schema 稳定，避免破坏前端读取逻辑。
- markdown 以静态内嵌方式加载，确保 Worker 运行期无文件系统依赖。
- DB 异常时 docs 读取必须回退静态内容，不能影响公共访问。
- 阅读器基于 `flutter_markdown`，Mermaid/TikZ 默认按代码展示，不承诺图形渲染。

## 常见问题与排错
- 文档 404：检查三语 slug 是否齐全、`bodies` 是否缺项。
- 顺序异常：检查 `sortOrder` 是否重复或不连续。
- 某语种正文为空：检查 import 与映射键名是否一致。
- 首页分组缺文档：检查 `category` 与前端分组逻辑。

## 相关模块联动
- 开发者手册 -> `创作工作室指南`：理解角色权限与发布流程。
- 开发者手册 -> `设置中心指南`：配置项如何影响运行行为。
- 开发者手册 -> `常见问题与排错`：从用户现象回溯实现链路。
