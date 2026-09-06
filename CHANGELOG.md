# 更新日志

## 2026-09-06 — 仓库结构调整与 Java 经典版 Win8.1 RC1

- 仓库改为统一使用 `main` 分支维护不同客户端方案；
- 新增 `clients/`，按“客户端 → 系统”分类；
- 将现有基岩互通版 Windows 8.1 Bridge 移入 `clients/bedrock-interoperability/win81/`；
- 新增 Java 经典版启动器中的基岩版 Windows 8.1 RC1 目录；
- Release Tag 后续使用客户端前缀区分，历史 `v2.0.1` 保持不变；
- Java 经典版 Win8.1 已实机验证 `Minecraft.Windows.exe 1.21.120.0` 可从启动器正常启动并进入世界；单人和非局域网联机正常；本地/局域网联机暂列为已知限制。

## v2.0.1 — 基岩互通版 Windows 8.1

当前基岩互通版 Windows 8.1 正式兼容版本。

### 修复

- 修复从 v1.9.x / v2.0 升级时，旧 IFEO Debugger 指向游戏根目录 `Win81MinecraftBridge.exe`，导致新版安装器拒绝继续的问题；
- 安装器可以识别本项目已知旧路径，并自动迁移到 `bridge_files\\Win81MinecraftBridge.exe`；
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
