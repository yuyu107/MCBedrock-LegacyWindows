# Java 经典版启动器中的基岩版 — Windows 8.1

历史 RC：**v1.0.0-RC1**。当前主分支使用 **Universal Bridge Core 0.4.3** 共存架构；其兼容核心基于已完成同机实测的 0.4.2。

本方案用于让 Java 经典版启动器中的基岩版继续在 **Windows 8.1 x64** 上运行。

## 已实机验证

- `Minecraft.Windows.exe 1.21.120.0`；
- 可从 Java 经典版启动器正常启动；
- 可进入游戏主界面和世界；
- 单人存档正常；
- 非局域网联机正常；
- 与基岩互通版同时注册到 Universal Bridge 后，两种客户端均可正常启动并进入世界。

### 已知限制

- ⚠️ 本地 / 局域网联机目前不可用：无法加入同一局域网内其他玩家开放的本地房间，其他玩家也无法加入本机开放的本地房间。
- 当前暂不继续修改这一部分，以优先保持已经验证正常的启动、单人和非局域网联机功能。

## 当前兼容方式

安装器把当前 `Minecraft.Windows.exe` 的完整路径注册为：

```text
Mode = java-classic
```

机器上只保留一个共享 Universal IFEO Bridge。Java Classic 启动时只应用已验证的私有 Windows 8.1 ApiSet v4 映射，不进行 `bedrock-interop` 专用的 WinPix 处理。启动器参数仍原样转交，日志不记录其具体内容。

直接双击 `Minecraft.Windows.exe` 只适合作为诊断；日常仍应从 Java 经典版启动器启动。

## 安装

1. 确保 `Minecraft.Windows.exe` 为原版文件；
2. 移除早期测试时手动加入的 `api-ms-win-*` 测试 DLL；
3. 将 Release 压缩包完整解压到 `Minecraft.Windows.exe` 所在目录；
4. 运行 `install_bridge.cmd`；
5. 之后继续从 Java 经典版启动器正常启动。

如果同一台机器也安装了基岩互通版，可以直接在互通版目录再运行它自己的 `install_bridge.cmd`，无需先卸载 Java Classic。

## 工具

- `install_bridge.cmd`：安装共享核心并注册当前路径为 `java-classic`；
- `check_bridge.cmd`：查看共享核心、当前路径及其它已注册客户端；
- `collect_diagnostics.cmd`：生成 Java Classic 诊断信息；
- `uninstall_bridge.cmd`：只注销当前 Java Classic 路径；
- `bridge_files/Win81JavaClassicBridge.cs`：保留 RC1 旧独立 Bridge 源码，供历史参考。

> Release 包会额外包含 `shared/` 目录，其中是 Universal Bridge Core 0.4.3 的共享安装脚本、源码和预编译 `W81KERN.dll`。
