# Windows 8.1 总指南

当前 Windows 8.1 x64 主要维护两种中国版基岩客户端：

- 基岩互通版；
- Java 经典版启动器中的基岩版。

两者当前主分支共用 **Universal Bridge Core 0.4.3**，可以在同一台机器上同时注册。

## 基岩互通版

历史正式版本：**v2.0.1 Launcher Login Bridge**。

当前 `main` 使用 Universal Bridge，并把当前游戏完整路径注册为：

```text
Mode = bedrock-interop
```

已验证：
- 可从发烧游戏启动器正常启动；
- 扫码、手机号、邮箱登录保留；
- 可进入游戏和世界；
- 平台原有更新流程保留；
- 不绑定固定 `Minecraft.Windows.exe` 文件大小或 SHA-256；
- 可与 Java Classic 同时注册。

历史正式 Release：

<https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v2.0.1>

当前目录说明：

<https://github.com/yuyu107/MCBedrock-LegacyWindows/tree/main/clients/bedrock-interoperability/win81>

## Java 经典版启动器中的基岩版

当前主分支注册模式：

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

当前目录说明：

<https://github.com/yuyu107/MCBedrock-LegacyWindows/tree/main/clients/java-classic-bedrock/win81>

## Universal Bridge 是什么？

Windows 8.1 下，两种客户端最终都运行名为：

```text
Minecraft.Windows.exe
```

如果分别使用两个机器级 IFEO Debugger，会产生冲突。因此当前架构只保留一个共享 Universal Bridge，再根据 `Minecraft.Windows.exe` 的**完整路径**选择对应模式。

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

Universal Bridge 的分流依赖游戏 EXE 的完整路径。如果安装后移动了游戏目录，应在新的 `Minecraft.Windows.exe` 所在目录重新运行对应的 `install_bridge.cmd`。

## 升级旧 Bridge

如果以前使用过 `Win81MinecraftBridge.exe`、`Win81JavaClassicBridge.exe` 或早期 Universal Bridge 测试版，请查看 [[版本与升级|Release-and-Upgrade]]。

遇到启动失败则查看 [[常见报错排查|Troubleshooting]]。
