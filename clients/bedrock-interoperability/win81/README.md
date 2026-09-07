# 基岩互通版 — Windows 8.1

本目录保存中国版《我的世界》**基岩互通版**在 Windows 8.1 x64 上的兼容方案。

历史正式版本：**v2.0.1 Launcher Login Bridge**。当前主分支使用 **Universal Bridge Core 0.4.3** 共存架构，并已通过完整候选包实机验证。

## 已验证

- 可通过发烧游戏（FeverGames）启动器正常启动；
- 支持扫码、手机号、邮箱登录；
- 可进入游戏和世界；
- 保留平台原有登录和更新流程；
- 不绑定固定 `Minecraft.Windows.exe` 大小或 SHA-256；
- 与 Java 经典版启动器中的基岩版**同时注册**后，两边均已实机验证可以正常启动并进入世界。

## 当前兼容方式

安装器不再为基岩互通版单独占用 IFEO。它会把当前 `Minecraft.Windows.exe` 的完整路径注册为：

```text
Mode = bedrock-interop
```

所有已注册客户端共用 `C:\ProgramData\MCBedrock-LegacyWindows\Win81UniversalBridge\Win81UniversalBridge.exe`。Universal Bridge 根据目标完整路径选择基岩互通版逻辑，并继续处理私有 ApiSet v4 与 `WinPixEventRuntime.dll` / `W81KERN.dll` 兼容。

旧共存测试版曾使用 `Mode = interop`。Core 0.4.3 仍能识别这个旧值；重新安装本方案后会自动写成 `bedrock-interop`。

## 共存

Java Classic 和基岩互通版可以同时安装兼容方案，不需要在两者之间手工卸载/切换 IFEO。卸载本目录方案时只注销当前基岩互通版路径；如果 Java Classic 仍然注册，共享 IFEO 会继续保留。

## 文件

- `install_bridge.cmd`：安装 Universal Bridge 并注册当前路径为 `bedrock-interop`；
- `check_bridge.cmd`：查看共享核心版本、所有注册目标与日志；
- `uninstall_bridge.cmd`：只注销当前基岩互通版路径；
- `restore_winpix.cmd`：如有需要，单独恢复 WinPix 修改；
- `bridge_files/`：保留 v2.0.1 时代的旧 Bridge 源码，供历史参考；
- `RELEASE_v2.0.1.md`：历史 v2.0.1 发布说明。

面向普通用户的统一项目 Release 会把本方案作为单独附件提供，例如：

```text
Win81_BedrockInterop_v2.1.0-RC1_Core0.4.3.zip
```

GitHub Tag 不再使用客户端专属前缀，而与其它系统/客户端一起归入项目级 `vX.Y.Z[-rcN]` Release。
