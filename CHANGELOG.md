# 更新日志

## 2026-09-07 — 统一项目 Release 规划与 Core 0.4.3 完整验证

- GitHub Release 从按客户端分别发布，调整为整个项目统一发布；
- 后续 Tag 统一使用 `vX.Y.Z` / `vX.Y.Z-rcN`；
- Windows 版本与客户端类型改由 Release 附件名和 Release 说明区分；
- 同一个 Release 可以同时包含 Windows 7、Windows 8.1 以及未来其它系统的基岩互通版、Java Classic、开发者版本等附件；
- 历史 Tag `v2.0.1` 保持不变；
- 计划从 `v3.0.0-rc1` 开始采用新的项目级 Release 结构；
- Universal Bridge Core 0.4.3 已通过完整候选包实机验证：基岩互通版与 Java Classic 均可安装、启动并进入世界，且可以同时注册共存。

## 2026-09-06 — Universal Bridge Core 0.4.3 模式命名整理

- 将基岩互通版的正式内部模式名从 `interop` 调整为更明确的 `bedrock-interop`；
- 新安装统一写入 `Mode = bedrock-interop`；
- 旧共存测试留下的 `Mode = interop` 仍可被 Core 0.4.3 识别，并按 `bedrock-interop` 处理；
- `check_bridge.ps1` 会把旧值明确标为兼容别名；
- 历史正式 Tag `v2.0.1` 保持不变。

## 2026-09-06 — Universal Bridge Core 0.4.2 同机共存验证

- 新增共享 `shared/win81-universal-bridge/` 底层；
- 解决 Java Classic 与基岩互通版都使用 `Minecraft.Windows.exe`、无法同时拥有两个机器级 IFEO Debugger 的冲突；
- Universal Bridge 按 `Minecraft.Windows.exe` 完整路径注册和分流；
- `java-classic` 模式继续使用已验证的私有 Windows 8.1 ApiSet v4 映射；
- 基岩互通版模式同时使用 ApiSet v4 与 WinPix/W81KERN 兼容处理；
- 已在同一台 Windows 8.1 x64 机器上实机验证 Java Classic 与基岩互通版同时注册后，两边均可正常启动并进入世界；
- 卸载单个客户端时只注销该完整路径；最后一个目标注销后才移除共享 IFEO；
- Java Classic 的局域网联机限制保持不变。

## 2026-09-06 — 仓库结构调整与 Java 经典版 Win8.1 RC1

- 仓库改为统一使用 `main` 分支维护不同客户端方案；
- 新增 `clients/`，按“客户端 → 系统”分类；
- 将现有基岩互通版 Windows 8.1 Bridge 移入 `clients/bedrock-interoperability/win81/`；
- 新增 Java 经典版启动器中的基岩版 Windows 8.1 RC1 目录；
- Java 经典版 Win8.1 已实机验证 `Minecraft.Windows.exe 1.21.120.0` 可从启动器正常启动并进入世界；单人和非局域网联机正常；本地/局域网联机暂列为已知限制。

## v2.0.1 — 基岩互通版 Windows 8.1

当前基岩互通版 Windows 8.1 历史正式兼容版本。

### 修复

- 修复从 v1.9.x / v2.0 升级时，旧 IFEO Debugger 指向游戏根目录 `Win81MinecraftBridge.exe`，导致新版安装器拒绝继续的问题；
- 安装器可以识别本项目已知旧路径，并自动迁移到 `bridge_files\Win81MinecraftBridge.exe`；
- 不会覆盖来自其他工具的未知 IFEO Debugger；
- `check_bridge.cmd` 可以识别旧路径并提示迁移状态；
- `uninstall_bridge.cmd` 可以安全清理本项目当前和已知旧版 IFEO 配置。

## v2.0

首个整理为正式版的基岩互通版 Windows 8.1 Launcher Login Bridge。

### 功能

- 保留 FeverGamesLauncher 的扫码、手机号和邮箱登录；
- 保留启动器正常的游戏更新流程；
- 不绑定固定 Minecraft 版本、文件大小或 SHA-256；
- 增加 `check_bridge.cmd`；
- 增加安全的 WinPix 恢复逻辑；
- Bridge 日志不记录启动器认证参数内容。

## 早期测试里程碑

- **v1.9.2**：修复 `W81KERN.dll` 重复覆盖问题；首次实机验证 FeverGamesLauncher 登录后可以正常进入游戏；
- **v1.8**：验证游戏内置登录模块可在 Win8.1 下正常进入游戏，但无法使用扫码/手机号登录，因此未作为最终主方案；
- **v1.1.x**：完成 Windows 8.1 API Set v4 缺失合同和未托管合同的兼容处理；
- **早期测试**：确认 Windows 7 可使用 VxKex 运行，并需要 `XINPUT1_3.dll`。
