# FeverGames 下载器系统环境要求

本页说明的是 **FeverGames-LegacyWindows-Downloader** 的安装器运行环境要求。

这属于发烧游戏平台下载链兼容问题，不是 `Minecraft.Windows.exe` 游戏本体运行兼容问题。

## 基本要求

建议使用接近原版的 **Windows 7 SP1 x64**。

FeverGames 下载器安装、状态检查、恢复和诊断脚本需要：

- `cmd.exe`：运行 Release 包中的 `.cmd` 入口；
- `powershell.exe`：执行安装、状态检查、恢复和诊断脚本；
- .NET Framework 2.0 / 3.5 / 4.x 中至少一个可用的 C# 编译器 `csc.exe`；
- 管理员权限；
- 7-Zip 或 Windows 7 可用的 `zstd.exe`；
- 基本注册表、文件系统和进程查询能力。

## 精简版 Windows 7

如果系统是深度精简版、Ghost 版或魔改版，可能已经删除或破坏：

- PowerShell；
- .NET Framework / C# 编译器；
- UAC 提权；
- 注册表查询；
- WMI / 进程查询；
- PATH / 环境变量。

这种环境下，即使补丁逻辑本身没有问题，安装器也可能无法启动、无法提权、无法编译替代 downloader 或无法完成状态检查。

## 常见错误

### 缺少 PowerShell

```text
'powershell.exe' 不是内部或外部命令，也不是可运行的程序或批处理文件。
```

这表示系统中没有可用的 PowerShell，或者 PowerShell 所在路径被精简 / 破坏。当前安装器无法继续。

### 缺少 .NET C# 编译器

```text
No compatible .NET C# compiler was found (2.0/3.5/4.x).
```

这表示系统中没有找到可用的 `csc.exe`。

FeverGames-LegacyWindows-Downloader 需要在目标机器上编译 Windows 7 可运行的替代 `downloadIPC.exe`，因此需要系统保留 .NET Framework 2.0 / 3.5 / 4.x 的 C# 编译器。

### 旧 CMD 包解析错误

```text
锘緻echo off
powershell.exe -> hell.exe
echo -> ho
goto -> to
```

这是旧 Release 包 `.cmd` 文件编码 / 换行不兼容 Windows 7 `cmd.exe` 的表现。请删除旧解压目录，重新下载 v1.3.3 或更新版本。

## 结论

FeverGames 下载器兼容方案不是“所有 Win7 精简版都保证可用”。

推荐环境是接近原版的 Windows 7 SP1 x64。如果系统缺少 PowerShell 或 .NET C# 编译器，请先恢复系统组件，或换用更完整的 Windows 7 环境。

相关项目：<https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader>
