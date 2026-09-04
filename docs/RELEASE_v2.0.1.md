# v2.0.1 — Windows 8.1 首个正式兼容版本

这是本项目针对《我的世界》基岩互通版 Windows 8.1 的首个正式发布版本。

## 已验证功能

- Windows 8.1 x64 下可以正常通过 FeverGamesLauncher 启动游戏；
- 支持扫码登录；
- 支持手机号登录；
- 支持邮箱登录；
- 可以正常进入游戏和世界；
- 保留 FeverGamesLauncher 原有的登录与游戏更新流程；
- 不绑定固定 `Minecraft.Windows.exe` 文件大小或 SHA-256，可适应同版本的不同构建及部分后续小更新。

## 主要兼容处理

- 为 Minecraft 进程建立经过补充的 Windows 8.1 API Set v4 映射；
- 补充 Win8.1 缺失的 API Set 合同，并修复未托管条目；
- 处理 `WinPixEventRuntime.dll` 对 `SetThreadDescription` 的依赖；
- 使用 IFEO Bridge 接管 FeverGamesLauncher 启动的 `Minecraft.Windows.exe`，并原样转交启动器认证参数；
- 不修改 `System32`；
- Bridge 日志不会记录认证参数的具体内容。

## v2.0.1 修复

- 修复从早期 v1.9.x / v2.0 测试版本升级时，旧 IFEO 路径导致安装器拒绝安装的问题；
- 可以自动识别并迁移旧的根目录 `Win81MinecraftBridge.exe` 路径到 `bridge_files\Win81MinecraftBridge.exe`；
- 如果检测到 IFEO Debugger 来自其他工具，仍会拒绝擅自覆盖。

## 安装方法

1. 下载 `MCBedrock_Win81_LauncherLoginBridge_v2.0.1_Release.zip`；
2. 完整解压到 `Minecraft.Windows.exe` 所在目录；
3. 运行 `install_bridge.cmd`；
4. 可运行 `check_bridge.cmd` 检查状态；
5. 正常打开 FeverGamesLauncher，登录后点击“开始游戏”。

通常游戏小版本更新后不需要重新安装。若游戏更新引入新的 Windows 10/11 独占 API，则可能需要等待本项目更新兼容方案。

## 下载包校验

`MCBedrock_Win81_LauncherLoginBridge_v2.0.1_Release.zip`

SHA-256：

```text
58B5A5B90386EF28D5BCEA590A3ACB4F84FEDD7D06BD24B3B1B1E698C68E2C8D
```

## 说明

本项目为社区兼容项目，与 Microsoft、Mojang、网易/FeverGames 无官方关联。
