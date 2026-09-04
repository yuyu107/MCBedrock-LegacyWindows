# 更新日志

## v2.0.1

当前 Windows 8.1 正式兼容版本。

### 修复

- 修复从 v1.9.x / v2.0 升级时，旧 IFEO Debugger 指向游戏根目录 `Win81MinecraftBridge.exe`，导致新版安装器拒绝继续的问题；
- 安装器现在可以识别本项目已知旧路径，并自动迁移到 `bridge_files\Win81MinecraftBridge.exe`；
- 仍然不会覆盖来自其他工具的未知 IFEO Debugger；
- `check_bridge.cmd` 可以识别旧路径并提示迁移状态；
- `uninstall_bridge.cmd` 可以安全清理本项目当前和已知旧版 IFEO 配置。

## v2.0

首个整理为正式版的 Windows 8.1 Launcher Login Bridge。

### 功能

- 保留 FeverGamesLauncher 的扫码、手机号和邮箱登录；
- 保留启动器正常的游戏更新流程；
- 不绑定固定 Minecraft 版本、文件大小或 SHA-256；
- 将 Bridge 源文件和 `W81KERN.dll` 整理到 `bridge_files`；
- 增加 `check_bridge.cmd`；
- 增加安全的 WinPix 恢复逻辑；
- Bridge 日志不记录启动器认证参数内容。

## 早期测试里程碑

- **v1.9.2**：修复 `W81KERN.dll` 重复覆盖问题；首次实机验证 FeverGamesLauncher 登录后可以正常进入游戏；
- **v1.8**：验证游戏内置登录模块可在 Win8.1 下正常进入游戏，但无法使用扫码/手机号登录，因此未作为最终主方案；
- **v1.1.x**：完成 Windows 8.1 API Set v4 缺失合同和未托管合同的兼容处理；
- **早期测试**：确认 Windows 7 可使用 VxKex 运行，并需要 `XINPUT1_3.dll`。
