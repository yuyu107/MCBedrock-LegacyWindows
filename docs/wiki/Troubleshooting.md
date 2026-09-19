# 常见报错排查

本页按“错误发生在哪个阶段”排查。先确定问题属于**下载、启动器、游戏进程、进入世界**中的哪一步，不要一次叠加多个补丁。

## 1. 发烧游戏能打开，但游戏下载失败

如果问题发生在下载阶段，而 `Minecraft.Windows.exe` 还没有真正启动，请看：

[[发烧游戏下载兼容|FeverGames-Downloader]]

当前建议使用 FeverGames Legacy Windows Downloader 的最新正式版（当前为 v1.3.4）。v1.3.4 已增加 FeverGames `1.18.43.22 / layout A` 支持，并完成 Windows 7 实机完整下载与进入游戏验证。先运行下载器的状态检查，不要把网络慢、CDN 波动和前端补丁未生效混为一谈。

### 下载器安装阶段常见错误

如果看到：

```text
'powershell.exe' 不是内部或外部命令，也不是可运行的程序或批处理文件。
```

说明系统中没有可用的 PowerShell，或 PowerShell 路径已被精简 / 破坏。当前下载器安装器无法继续运行。

如果看到：

```text
No compatible .NET C# compiler was found (2.0/3.5/4.x).
```

说明系统中没有找到可用的 .NET C# 编译器 `csc.exe`。请先恢复 / 安装 .NET Framework 组件，或换用更完整的 Windows 7 SP1 x64 环境。

## 2. 点击开始游戏后没有窗口 / 立即闪退

Windows 7：

- 确认系统为 Win7 SP1 x64；
- 确认 `XINPUT1_3.dll` 可用；
- 确认 VxKex / VxKex NEXT 是对真正的 `Minecraft.Windows.exe` 开启；
- Java Classic 方案不要勾选“报告其他版本”；
- 记录第一个 Windows 错误窗口。

详见 [[Windows 7 总指南|Windows-7]]。

Windows 8.1：

- 优先使用 [v3.0.0 正式版](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0)；
- 确认对应正式包已完整解压到 `Minecraft.Windows.exe` 所在目录；
- 运行 `检查兼容状态.cmd`；
- 如果游戏目录移动过，在新目录重新运行 `安装兼容方案.cmd`；
- 如果曾装过旧 Bridge，查看 [[版本与升级|Release-and-Upgrade]]。

## 3. Win8.1 安装器提示“拒绝访问 / 尝试执行未经授权的操作”

如果安装器已经完成 Universal Bridge 编译和版本自检，但随后在写入 IFEO `Debugger` 时失败，并且系统安装了 360：

1. 暂时关闭 360 的**自我保护**；
2. 重新运行 `安装兼容方案.cmd`；
3. 360 提示“有程序正在修改映像劫持”时，确认操作来自本项目后选择**允许**。

仅退出 360 主界面可能无效。

**安装完成后可以重新开启 360 自我保护，已实测不影响后续正常运行。**

启动游戏时如果 360 再提示 `Win81UniversalBridge.exe` / Minecraft 正在进行可疑操作，确认路径正确后选择允许即可。

## 4. 报 `XINPUT1_3.dll` 缺失

目前三种已验证 Win7 中国版基岩客户端都需要 `XINPUT1_3.dll`。

建议安装微软旧版 DirectX 运行库补齐，不要从随机 DLL 下载站单独复制文件。

## 5. 报 `dbgcore.MiniDumpWriteDump` / `dbghelp.dll`

如果是开发者版本，并出现类似：

```text
无法定位程序输入点 dbgcore.MiniDumpWriteDump 于动态链接库 dbghelp.dll 上
```

检查 `Minecraft.Windows.exe` 同目录是否存在游戏自带的：

```text
dbghelp.dll
```

当前已验证方案是将它改名保留，例如：

```text
dbghelp.dll.bak
```

然后继续通过 VxKex 启动。

不要替换 `System32` 中的 DLL。

## 6. Win8.1 Bridge 安装过，但后来失效

常见原因：

- 游戏目录被移动；
- Bridge 文件被删除；
- 其它工具改写了 `Minecraft.Windows.exe` 的 IFEO；
- 升级过程中仍残留早期手工测试 DLL；
- 使用了旧安装包中的卸载脚本处理新方案。

建议：

1. 关闭所有 Minecraft 实例；
2. 在当前游戏目录运行正式包中的 `检查兼容状态.cmd`；
3. 如路径已变化，重新运行 `安装兼容方案.cmd`；
4. 卸载时使用**当前正式包**内的 `卸载兼容方案.cmd`。

## 7. Java Classic Win8.1 能进游戏但局域网联机不行

这是当前已知限制之一。现阶段已验证：

- 单人正常；
- 非局域网联机正常；
- 本地 / 局域网联机目前不可用。

因此如果只有局域网功能异常，而启动和其它联机正常，不应直接判断 Bridge 整体失效。

## 8. 基岩互通版关闭后进程还在

基岩互通版关闭游戏窗口后，`Minecraft.Windows.exe` 有时会继续进行一段时间的退出收尾和磁盘 I/O。

当前实测等待后会自行正常退出，因此不建议立即强制结束进程。只有在持续数分钟仍不退出、或者情况明显恶化时，再作为异常排查。

## 9. 发烧游戏下载很慢、几十 MB 停一下

如果已经能正常开始下载，但表现为：

- 下载几十 MB 后停几分钟；
- 之后又继续；
- 偶尔提示网络连接问题；

还需要考虑网络线路、CDN、加速器和连接稳定性。先确认 FeverGames Downloader 的状态检查正常，再单独排网络问题。

## 反馈问题的最低信息

请尽量一次提供：

- Windows 版本；
- 是否为精简版 / Ghost 版 / 魔改版；
- 客户端类型；
- Minecraft 版本 / 构建；
- VxKex / VxKex NEXT 及版本（如使用）；
- FeverGames 与下载器版本（如属于下载问题）；
- 第一个错误窗口；
- 是否能创建游戏窗口；
- 是否能进入主菜单；
- 是否能进入世界。

不要公开账号、手机号、邮箱、Token、Cookie 或认证参数。
