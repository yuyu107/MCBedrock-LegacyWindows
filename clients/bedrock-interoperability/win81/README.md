# 基岩互通版 — Windows 8.1

本目录保存中国版《我的世界》**基岩互通版**在 Windows 8.1 x64 上的兼容方案。

当前正式版本：**v2.0.1 Launcher Login Bridge**。

## 已验证

- 可通过发烧游戏（FeverGames）启动器正常启动；
- 支持扫码、手机号、邮箱登录；
- 可进入游戏和世界；
- 保留平台原有登录和更新流程；
- 不绑定固定 `Minecraft.Windows.exe` 大小或 SHA-256。

## 主要处理

- 为 Minecraft 进程补充 Windows 8.1 API Set v4 映射；
- 修复缺失/未托管的 API Set 合同；
- 处理 `WinPixEventRuntime.dll` 对 `SetThreadDescription` 的依赖；
- 使用 IFEO Bridge 接管平台创建的 `Minecraft.Windows.exe`；
- 不修改 `System32`。

## 文件

- `install_bridge.cmd`：安装；
- `check_bridge.cmd`：状态检查；
- `uninstall_bridge.cmd`：卸载 IFEO Bridge；
- `restore_winpix.cmd`：恢复 WinPix 修改；
- `show_bridge_log.cmd`：查看 Bridge 日志；
- `bridge_files/`：Bridge 与 W81KERN 源码；
- `RELEASE_v2.0.1.md`：v2.0.1 发布说明。

> [!WARNING]
> 本方案会设置针对映像名 `Minecraft.Windows.exe` 的机器级 IFEO Debugger。不要与 Java 经典版或其他同名进程的 IFEO Bridge 同时安装。
