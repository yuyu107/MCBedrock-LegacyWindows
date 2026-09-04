# Windows 8.1 Bridge 源码说明

此目录保存 Windows 8.1 兼容 Bridge 的主要源码。

- `Win81ApiSetLauncher.cs`：创建挂起的 Minecraft 进程，并为该进程建立兼容的 Windows 8.1 API Set v4 映射。
- `Win81MinecraftBridgeMain.cs`：IFEO Bridge 入口、启动器参数转交、WinPix 兼容处理与日志逻辑。
- `W81KERN.c` / `W81KERN.def`：`WinPixEventRuntime.dll` 使用的最小 Kernel32 兼容 shim 源码与导出表。

## 关于 W81KERN.dll

源码仓库不直接分发预编译的 `W81KERN.dll`。面向普通用户、已经实机验证过的预编译版本会包含在 GitHub Releases 的正式压缩包中。

安装脚本面向正式 Release 包使用，因此会检查 `bridge_files\W81KERN.dll` 是否存在。

`W81KERN` 的行为很简单：WinPix 所需的现有 Kernel32 API 通过 `.def` 转发到系统 `KERNEL32.dll`；Windows 8.1 缺少的 `SetThreadDescription` 则由 `W81KERN.c` 提供一个返回 `S_OK` 的兼容实现。
