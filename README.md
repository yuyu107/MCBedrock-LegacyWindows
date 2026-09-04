# 《我的世界》基岩互通版旧版 Windows 兼容修复

本项目用于恢复新版《我的世界》**基岩互通版**在 Windows 7 / Windows 8.x 上的运行能力。

该客户端过去曾能够在 Windows 7 / 8.x 上正常运行，但从 **2026 年 2 月开始的新版本**起，旧版 Windows 不再能够直接正常启动。本项目因此针对不同系统提供兼容方案，让仍在使用旧版 Windows 的玩家可以继续运行新版客户端。

> [!IMPORTANT]
> 本项目为社区兼容项目，与 Microsoft、Mojang、网易/FeverGames 无官方关联。
> 游戏与启动器更新后可能引入新的兼容问题，因此无法保证所有未来版本都无需调整。

## 当前状态

| 系统 | 状态 | 当前方案 |
|---|---|---|
| Windows 7 x64 | ✅ 已验证可运行 | 使用 VxKex，并确保系统中存在 `XINPUT1_3.dll` |
| Windows 8.1 x64 | ✅ 已验证可运行 | 使用本项目提供的兼容 Bridge |
| Windows 8.0 | ⚠️ 尚未完整验证 | 理论上可能需要与 Win8.1 不同的适配，请以实机结果为准 |

目前 Windows 8.1 方案已实机验证：

- 可以正常通过 FeverGamesLauncher 启动游戏；
- 支持扫码登录；
- 支持手机号登录；
- 支持邮箱登录；
- 可以正常进入游戏；
- 可以正常进入世界；
- 已适配同一游戏版本的多个不同构建；
- 不通过固定 EXE 大小或 SHA-256 白名单限制版本。

## Windows 7

Windows 7 当前不需要安装本项目的 Win8.1 Bridge。

已验证的方式是：

1. 使用 **Windows 7 SP1 x64**；
2. 为 `Minecraft.Windows.exe` 启用 **VxKex / VxKex NEXT**；
3. 不需要勾选“报告其他 Windows 版本”之类的系统版本伪装选项；
4. 确保系统中存在 `XINPUT1_3.dll`。

如果缺少 `XINPUT1_3.dll`，建议通过微软旧版 DirectX 运行库补齐，而不是从不明 DLL 下载站单独下载文件。

## Windows 8.1

Windows 8.1 无法直接照搬 Windows 7 的扩展内核方案，因此本项目为其提供独立兼容方式。

当前正式方案通过 **Launcher Login Bridge** 接管 FeverGamesLauncher 创建的 `Minecraft.Windows.exe`，在游戏真正执行前为该进程建立所需的兼容环境。

### 主要处理内容

- 修复 Windows 8.1 缺失的部分 **API Set v4** 合同；
- 修复部分已存在但未托管的 API Set 映射；
- 处理 `WinPixEventRuntime.dll` 对 Windows 10 API `SetThreadDescription` 的依赖；
- 保留 FeverGamesLauncher 原有登录与更新流程；
- 启动器传给 Minecraft 的认证/启动参数只做原样转交，不写入 Bridge 日志；
- 不修改 `System32`；
- 不要求固定 Minecraft EXE 版本、大小或 SHA-256。

## Windows 8.1 安装方法

1. 从 Releases 下载最新正式版；
2. 将压缩包**完整解压到 `Minecraft.Windows.exe` 所在目录**；
3. 运行 `install_bridge.cmd`；
4. 同意管理员权限；
5. 可运行 `check_bridge.cmd` 检查安装状态；
6. 之后正常打开 FeverGamesLauncher 登录并点击“开始游戏”即可。

安装成功后，不需要再手动运行单独的兼容启动器。

### 游戏更新后需要重新安装吗？

通常**不需要**。

Bridge 的设计不绑定 `Minecraft.Windows.exe` 的固定版本、文件大小或 SHA-256。游戏小版本更新后，可以先直接从 FeverGamesLauncher 正常启动。

如果游戏更新替换了 `WinPixEventRuntime.dll`，Bridge 会在后续启动时重新检查并按需处理。

以下情况建议重新运行 `install_bridge.cmd`：

- 重装了游戏；
- 移动了游戏目录；
- Bridge 文件被删除；
- `check_bridge.cmd` 显示 IFEO Bridge 未正确安装；
- 其他程序修改了 `Minecraft.Windows.exe` 的 IFEO 配置。

如果未来游戏新增了更多 Windows 10 / 11 独占 API，则可能需要发布新的兼容版本，而不是简单重新安装旧版补丁。

## 登录方式

Windows 8.1 正式方案保留 FeverGamesLauncher，因此当前可以继续使用：

- ✅ 扫码登录
- ✅ 手机号登录
- ✅ 邮箱登录

此前曾测试过替换 `netease.data` 后直接使用游戏内置登录模块的方案，虽然可以进入游戏，但无法使用扫码和手机号登录，因此目前不作为正式主方案。

## 常用文件

| 文件 | 用途 |
|---|---|
| `install_bridge.cmd` | 安装或更新 Windows 8.1 兼容 Bridge |
| `check_bridge.cmd` | 检查 Bridge、IFEO 和 WinPix 状态 |
| `open_fevergames.cmd` | 打开 FeverGames 对应游戏入口 |
| `show_bridge_log.cmd` | 查看 Bridge 日志 |
| `uninstall_bridge.cmd` | 卸载本项目安装的 IFEO Bridge |
| `restore_winpix.cmd` | 在可确认匹配时恢复原版 `WinPixEventRuntime.dll` |

## 卸载

如果不再需要兼容 Bridge：

1. 关闭 Minecraft；
2. 关闭/停止 FeverGamesLauncher 正在进行的游戏启动流程；
3. 运行 `uninstall_bridge.cmd`；
4. 如需恢复 WinPix，再运行 `restore_winpix.cmd`。

卸载脚本只会移除本项目已知的 IFEO Bridge 配置。如果检测到其他程序设置的 Debugger，不会擅自删除。

## 隐私与安全

- 本项目**不自行实现账号登录协议**；
- 不收集账号密码；
- 不保存扫码、手机号、邮箱登录凭据；
- FeverGamesLauncher 传给 Minecraft 的认证参数不会写入 Bridge 日志；
- 本项目不会修改 `System32`；
- IFEO 属于机器级配置，不再使用时建议执行卸载脚本。

## 问题反馈

如果遇到无法启动、闪退或游戏更新后失效，建议在 Issue 中附上：

- Windows 具体版本；
- Minecraft 版本号；
- 游戏是否刚更新；
- `bridge_files\win81_launcher_bridge.log`；
- 第一个 Windows 报错；
- 如有 APPCRASH，请附故障模块名称和异常代码。

请不要公开包含账号、手机号、邮箱、Token、Cookie 等隐私信息的日志或截图。

## 当前版本

Windows 8.1 正式兼容包：**v2.0.1 Release**

详见 [CHANGELOG.md](CHANGELOG.md)。
