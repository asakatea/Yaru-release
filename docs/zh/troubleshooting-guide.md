# 常见问题与排错

## 模块定位与适用人群
本指南用于在最短时间内定位和解决 Yaru 使用问题，适合普通用户与开发协作者的日常排障。

## 入口路径
- 文档首页：`/docs`
- 排错文档：`/docs/troubleshooting-guide`
- 设置入口：`/settings`
- 健康检查接口（开发者）：`/api/health`

## 功能总览
| 场景 | 典型问题 | 优先级 |
|---|---|---|
| 同步问题 | 数据未更新、冲突覆盖、离线后不同步 | 高 |
| 快捷键问题 | 组合键无响应、编辑快捷键冲突 | 中 |
| 权限问题 | Studio 或团队管理入口不可见 | 高 |
| 搜索问题 | 搜不到内容、结果不完整、跳转异常 | 中 |
| AI 问题 | 模型不可用、拍题失败、总结失败 | 高 |
| Web/WASM 构建问题 | `flutter build web --wasm` 失败 | 高 |

## 典型任务流程
1. 当你遇到问题时，先确认“网络 + 登录状态”。
2. 再在 `设置` 中检查对应模块配置（同步/AI/语言/隐私）。
3. 用最小路径复现一次（只做一条操作链，记录结果）。
4. 若仍失败，记录路由、时间、错误提示并提交反馈。

## 高级用法与效率技巧
- 把问题先归类为“配置问题”或“功能问题”，可明显缩短排障时间。
- 快捷键问题优先检查焦点位置与输入法占用，而不是先重装应用。
- 搜索问题先缩小关键词范围（模块名 -> 页面名 -> 资源名）再逐步扩展。

> [提示] 遇到 AI 失败时，先切换备用模型做对照测试，可快速判断是模型问题还是输入问题。

## 权限/角色/前置条件
- Studio 访问依赖角色（donor/contributor/admin/owner/content_admin）。
- 团队管理动作依赖团队内角色权限。
- 自动化与同步场景可能受 token 权限范围限制。

## 常见问题与排错
### 1. 同步失败怎么办？
- 检查网络与存储配置。
- 检查冲突策略是否符合预期。
- 在多端场景下手动触发一次同步并比对时间戳。

### 2. 快捷键没反应怎么办？
- 确认光标在可编辑区域。
- 检查输入法或系统是否占用了快捷键。
- 尝试切换到默认快捷键组合后重试。

### 3. 为什么进不了 Studio？
- 账号角色不满足时入口会受限。
- 用户管理与审核页需要管理员级权限。

### 4. 搜索结果不准确怎么办？
- 先用更精确关键词（资源名/模块名）重试。
- 切换到目标模块页内搜索做交叉验证。

### 5. AI 功能不可用怎么办？
- 在设置中检查 provider、模型、API Key。
- 拍题与视频总结先确认输入内容可解析且网络稳定。

### 6. 已知开发中项
- Learning Review / Study Plan / Study Notes 仍为开发中页面。
- Extensions 浮窗设置、Captures 转卡片/转笔记仍在开发。
- Privacy “清除数据”尚未接入完整清理流程。

### 7. `flutter build web --wasm` 失败怎么办？
- 若报错涉及 `dart:html` / `universal_html`：
  1. 检查 Flutter 业务代码是否直接引入了 `dart:html` 或 `package:universal_html/*`。
  2. 检查 Web 条件导入是否统一为 `if (dart.library.js_interop)`。
  3. 若镜像源异常（如 `pub.flutter-io.cn` 返回 502），改用官方源执行：

```bash
cd Monorepo/apps/Flutter
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter pub get
PUB_HOSTED_URL=https://pub.dev FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com flutter build web --wasm
```

- 基线文档：`Monorepo/apps/Flutter/WASM_COMPATIBILITY.md`。

## 相关模块联动
- 排错 -> `设置中心指南`：先做配置层排查。
- 排错 -> `普通用户手册`：回到标准使用路径验证流程。
- 排错 -> `开发者手册`：需要定位接口或结构问题时继续深入。
