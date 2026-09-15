# Windows 8.1 总指南

当前 Windows 8.1 x64 正式维护两种中国版基岩客户端：

- 基岩互通版；
- Java 经典版启动器中的基岩版。

当前正式项目版本为 **v3.0.0**，两种客户端共用 **Universal Bridge Core 0.4.3**，可以在同一台机器上同时注册。

正式 Release：

<https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0>

## 基岩互通版

当前正式包：

```text
Win81_BedrockInterop_v2.1.1_Core0.4.3.zip
```

安装后将当前游戏完整路径注册为：

```text
Mode = bedrock-interop
```

已验证：

- 可从发烧游戏启动器正常启动；
- 扫码、手机号、邮箱登录流程保留；
- 可进入游戏和世界；
- 平台原有登录和更新流程保留；
- 不绑定固定 `Minecraft.Windows.exe` 文件大小或 SHA-256；
- 可与 Java Classic 同时注册。

历史 `v2.0.1` 为旧独立 Launcher Login Bridge，现已由 v3.0.0 中的 Universal Bridge 正式方案接替。

## Java 经典版启动器中的基岩版

当前正式包：

```text
Win81_JavaClassic_v1.0.1_Core0.4.3.zip
```

安装后注册模式：

```text
Mode = java-classic
```

已验证：

- `Minecraft.Windows.exe 1.21.120.0`；
- 可从 Java 经典版启动器正常启动；
- 可进入主界面和世界；
- 单人正常；
- 非局域网联机正常；
- 可与基岩互通版同时注册。

已知限制：

- 本地 / 局域网联机目前不可用。

## 安装方法

1. 下载与自己客户端对应的 v3.0.0 附件；
2. 将压缩包完整解压到 `Minecraft.Windows.exe` 所在目录；
3. 双击 `安装兼容方案.cmd`；
4. 安装完成后继续从原来的启动器正常启动游戏。

安装后可运行 `检查兼容状态.cmd` 查看 Core 版本和当前注册路径。

## 360 安全软件

Universal Bridge 安装时需要写入 Windows 的 IFEO `Debugger`。360 会把这个动作识别为“修改映像劫持”。

已实测：

- 360 自我保护开启时，安装器可能提示“拒绝访问 / 尝试执行未经授权的操作”；
- 仅退出 360 主界面不能解除阻止；
- 暂时关闭 360 的**自我保护**后，可重新运行安装器；
- 360 提示“有程序正在修改映像劫持”时，确认来自本项目后选择**允许**；
- **安装完成后可以重新开启自我保护，已实测不影响后续正常运行**；
- 启动游戏时如果再次提示 `Win81UniversalBridge.exe` / Minecraft 存在可疑操作，确认路径正确后选择允许即可。

正常情况下不需要卸载 360。

## Universal Bridge 是什么？

Windows 8.1 下，两种客户端最终都运行名为：

```text
Minecraft.Windows.exe
```

当前架构只保留一个共享 Universal Bridge，再根据 `Minecraft.Windows.exe` 的**完整路径**选择对应模式：

```text
Minecraft.Windows.exe
        ↓
Universal IFEO Bridge
        ↓
完整路径分流
        ├─ bedrock-interop
        └─ java-classic
```

共享核心位置：

```text
C:\ProgramData\MCBedrock-LegacyWindows\Win81UniversalBridge\Win81UniversalBridge.exe
```

## 可以同时安装两种客户端吗？

可以。当前已经实机验证基岩互通版与 Java Classic 同时注册后，两边均能正常启动并进入世界。

卸载其中一个客户端的兼容方案时，只注销它自己的完整路径；只要另一个客户端仍然注册，共享 IFEO 就会保留。

## 游戏移动目录后怎么办？

Universal Bridge 的分流依赖游戏 EXE 的完整路径。如果安装后移动了游戏目录，应在新的 `Minecraft.Windows.exe` 所在目录重新运行 `安装兼容方案.cmd`。

## 升级旧 Bridge

如果以前使用过 `Win81MinecraftBridge.exe`、`Win81JavaClassicBridge.exe`、基岩互通版 v2.0.1 或早期 Universal Bridge 测试版，请查看 [[版本与升级|Release-and-Upgrade]]。

遇到启动失败则查看 [[常见报错排查|Troubleshooting]]。
