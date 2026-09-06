# Java 经典版启动器中的基岩版 — Windows 8.1

当前版本：**v1.0.0-RC1**。

本方案用于让 Java 经典版启动器中的基岩版继续在 **Windows 8.1 x64** 上运行。

## 已实机验证

- `Minecraft.Windows.exe 1.21.120.0`；
- 可从 Java 经典版启动器正常启动；
- 可进入游戏主界面和世界；
- 单人存档正常；
- 非局域网联机正常。

### 已知限制

- ⚠️ 本地 / 局域网联机目前不可用：无法加入同一局域网内其他玩家开放的本地房间，其他玩家也无法加入本机开放的本地房间。
- RC1 暂不继续修改这一部分，以优先保持已经验证正常的启动、单人和非局域网联机功能。

## 兼容方式

本方案不修改 `Minecraft.Windows.exe`，也不修改 Java 经典版启动器。它通过 IFEO 接管启动器创建的 `Minecraft.Windows.exe`，在目标进程真正执行前，为该进程建立私有 **Windows 8.1 ApiSet v4** 兼容映射，并将启动器原本的参数原样转交。

直接双击 `Minecraft.Windows.exe` 只适合作为诊断，因为该版本实际运行仍依赖 Java 经典版启动器提供的启动参数/环境。

## 安装

1. 确保 `Minecraft.Windows.exe` 为原版文件；
2. 移除早期测试时手动加入的 `api-ms-win-*` 测试 DLL；
3. 将 Release 压缩包完整解压到 `Minecraft.Windows.exe` 所在目录；
4. 运行 `install_bridge.cmd` 并同意管理员权限；
5. 之后继续从 Java 经典版启动器正常启动基岩版。

## 工具

- `install_bridge.cmd`：安装并编译 Bridge；
- `check_bridge.cmd`：检查状态；
- `collect_diagnostics.cmd`：生成诊断 ZIP；
- `uninstall_bridge.cmd`：安全移除本方案设置的 IFEO Debugger；
- `bridge_files/Win81JavaClassicBridge.cs`：Bridge 源码。

## 注意事项

IFEO 是按映像名 `Minecraft.Windows.exe` 生效的机器级设置，因此不要和基岩互通版 Win8.1 Bridge 或其他同名程序的 IFEO 兼容工具同时安装。切换方案前应先运行当前方案的卸载脚本。

当前实机验证版本为 `1.21.120.0`，但 Bridge 不使用固定 EXE 大小、SHA-256 或版本白名单。游戏更新后可以先继续测试；如果新增 Windows 10/11 独占 API，则需要继续适配。
