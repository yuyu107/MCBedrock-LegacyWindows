# FAQ

## 这个项目是做什么的？

用于记录和维护中国版《我的世界》不同基岩客户端在旧版 Windows 上的兼容方案，当前重点包括 Windows 7 SP1 x64 与 Windows 8.1 x64。

## Windows 10 / 11 需要这些补丁吗？

通常不需要。Windows 10 / 11 优先使用官方环境，本项目主要解决旧系统兼容问题。

## Windows 8.0 能用 Windows 8.1 的 Bridge 吗？

目前不能保证。Windows 8.0 与 Windows 8.1 的内核、API Set 和系统组件并不完全相同，当前 Windows 8.1 Bridge 不应直接视为 Win8.0 正式方案。

## Windows 7 为什么既要 FeverGames Downloader，又要 VxKex？

因为它们解决两个不同问题：
- FeverGames Downloader：解决**发烧游戏平台下载游戏**；
- VxKex / VxKex NEXT：解决**下载后的 Minecraft.Windows.exe 在 Win7 上运行**。

详见 [[发烧游戏下载兼容|FeverGames-Downloader]] 和 [[Windows 7 总指南|Windows-7]]。

## VxKex 和 VxKex NEXT 都要装吗？

不是。它们是不同的兼容实现/维护分支，不是要求同时叠加使用。优先按照当前实测方案选择其中一种。

详见 [[VxKex / VxKex NEXT|VxKex]]。

## 为什么还需要 XINPUT1_3.dll？

因为目前三种已验证的 Win7 中国版基岩客户端都仍依赖这部分旧版 DirectX 运行库。VxKex 并不会自动补齐所有第三方/运行库依赖。

## 可以直接从 DLL 网站下载 XINPUT1_3.dll 吗？

不建议。优先安装微软旧版 DirectX 运行库，避免使用来源不明的单 DLL 文件。

## 开发者版本为什么要改名 dbghelp.dll？

实测中开发者版本自带的 `dbghelp.dll` 会在 Win7 上触发 `dbgcore.MiniDumpWriteDump` 入口兼容问题。当前已验证方案是把游戏目录中的该 DLL 改名保留，让程序不再优先加载这份不兼容副本。

不要因此替换 Windows `System32` 中的系统 DLL。

## Windows 8.1 的两个客户端可以同时装吗？

可以。当前 Universal Bridge Core 0.4.3 已实机验证基岩互通版和 Java Classic 可以同时注册，并分别正常启动和进入世界。

## 为什么 Java Classic Win8.1 的局域网联机不行？

这是当前已知限制。现阶段已优先保持启动、单人和非局域网联机功能稳定，局域网联机尚未解决。

## 游戏更新后兼容方案会不会失效？

有可能。项目不会保证未来所有版本持续兼容。游戏、启动器、发烧游戏平台和 VxKex 更新都可能改变结果。

普通小更新后可以先尝试继续使用；若出现新错误，应记录新的第一个报错并重新排查。

## 为什么首页不放所有技术细节？

首页主要用于快速导航。更完整的安装、原理、升级和错误说明放在 Wiki，避免新用户第一次进入仓库就被大量开发信息淹没。

## 我反馈问题时最少要写什么？

至少说明：
- Windows 版本；
- 哪一种客户端；
- Minecraft 版本；
- 第一个错误；
- 是否能进入主菜单 / 世界；
- 使用的 VxKex 或下载器版本（如果相关）。

不要公开账号、Token、Cookie、手机号、邮箱等隐私信息。
