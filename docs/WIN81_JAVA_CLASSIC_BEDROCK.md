# Java 经典版启动器中的基岩版：Windows 8.1 兼容方案

本页记录中国版《我的世界》**Java 经典版启动器中的基岩版**在 **Windows 8.1 x64** 上的实机兼容情况。

> [!IMPORTANT]
> 本方案与基岩互通版当前使用的 Windows 8.1 Launcher Login Bridge 属于同一类思路，但这里针对的是 **Java 经典版启动器创建的 `Minecraft.Windows.exe`**。请不要把两套 IFEO Bridge 同时安装。

## 当前状态

当前 Release Candidate：**v1.0.0-RC1**

已实机验证：

- ✅ Windows 8.1 x64；
- ✅ `Minecraft.Windows.exe 1.21.120.0`；
- ✅ 可以从 Java 经典版启动器正常启动；
- ✅ 可以进入游戏主界面；
- ✅ 可以进入世界；
- ✅ 单人存档可正常游玩；
- ✅ 非局域网联机可正常进入；
- ⚠️ 本地 / 局域网联机目前不可用。

### 已知限制：本地 / 局域网联机

当前实机测试中：

- 无法加入同一局域网内其他玩家开放的本地房间；
- 其他玩家也无法加入本机开放的本地房间。

目前暂不继续修改这一部分，以优先保持已经验证正常的启动、单人存档、进入世界和非局域网联机功能。

## 兼容原理

该客户端在 Windows 8.1 上直接启动时，最初会先遇到较新的 API Set 合同缺失，例如：

```text
api-ms-win-core-heap-l2-1-0.dll
api-ms-win-core-libraryloader-l1-2-1.dll
```

继续补同名转发 DLL 后，会进入：

```text
0xC0000481 / STATUS_APISET_NOT_HOSTED
```

这说明问题并不只是磁盘上缺少 DLL，而是 Windows 8.1 的 **API Set v4 映射**本身没有为新版客户端所需合同提供可用宿主。

本方案因此不修改 `Minecraft.Windows.exe`，而是通过 **IFEO Debugger Bridge** 接管 Java 经典版启动器创建的游戏进程：

```text
Java 经典版启动器
→ 创建 Minecraft.Windows.exe
→ IFEO Bridge 接管
→ 挂起创建原版 Minecraft.Windows.exe
→ 为该进程重建私有 Windows 8.1 ApiSet v4 映射
→ 原样转交启动器参数
→ 恢复 Minecraft.Windows.exe 执行
```

私有 ApiSetMap 只存在于当前 Minecraft 进程中，游戏退出后随进程释放；不修改 `System32`。

## 与基岩互通版 Win8.1 Bridge 的差异

Java 经典版当前实测构建 **1.21.120.0** 在只使用私有 ApiSet v4 映射的情况下已经可以进入世界，因此 RC1 暂时**不修改 `WinPixEventRuntime.dll`，也不安装 `W81KERN.dll`**。

基岩互通版现有正式 Win8.1 Bridge 还额外处理了 `WinPixEventRuntime.dll` 对 `SetThreadDescription` 的依赖，两者不要直接混用。

## 安装前准备

1. 使用 Windows 8.1 x64；
2. 确保 `Minecraft.Windows.exe` 为原版文件；
3. 如果早期测试时手动加入过以下 DLL，请先移走：

```text
api-ms-win-core-heap-l2-1-0.dll
api-ms-win-core-libraryloader-l1-2-1.dll
api-ms-win-core-synch-l1-2-1.dll
api-ms-win-core-synch-ansi-l1-1-0.dll
api-ms-win-core-kernel32-legacy-l1-1-2.dll
```

4. 如果机器上已经安装了基岩互通版或其他工具针对 `Minecraft.Windows.exe` 的 IFEO Debugger，请先卸载/停用，避免冲突。

## 安装与使用

1. 将 RC1 压缩包完整解压到 `Minecraft.Windows.exe` 所在目录；
2. 运行 `install_bridge.cmd`；
3. 同意管理员权限；
4. 可运行 `check_bridge.cmd` 检查状态；
5. 之后仍然从 **Java 经典版启动器**正常启动基岩版。

不建议直接双击 `Minecraft.Windows.exe` 作为日常启动方式。该版本依赖 Java 经典版启动器提供的启动参数/环境；直接启动只适合作为兼容性诊断。

## 工具

- `install_bridge.cmd`：安装并编译 Bridge；
- `check_bridge.cmd`：检查系统、游戏、IFEO 和 Bridge 状态；
- `collect_diagnostics.cmd`：收集诊断日志；
- `uninstall_bridge.cmd`：安全移除本方案设置的 IFEO Debugger。

## 隐私说明

Bridge 会把 Java 经典版启动器原本传给 Minecraft 的参数**原样转交**，但日志只记录参数数量，不记录参数具体内容。

请不要公开包含账号、Token、Cookie、手机号、邮箱等敏感信息的其他启动器日志或截图。

## 游戏更新后的处理

RC1 已实机验证版本为 `1.21.120.0`，但 Bridge **不使用固定 EXE 大小、SHA-256 或版本白名单**。

游戏更新后可以先直接继续测试。如果后续版本新增新的 Windows 10 / 11 独占 API，或者启动链发生变化，则需要继续适配，而不是简单重复安装旧版本。
