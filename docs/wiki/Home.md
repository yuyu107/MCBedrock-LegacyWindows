# MCBedrock-LegacyWindows Wiki

这里用于集中整理中国版《我的世界》基岩客户端在旧版 Windows 上的兼容资料。

如果你只是来解决问题，不需要先了解项目结构，按下面顺序选择即可。

## 我该看哪一页？

| 你的情况 | 入口 |
|---|---|
| Windows 7，不确定自己是哪一种中国版基岩客户端 | [客户端与版本区别](Client-Variants) |
| Windows 7，游戏本体打不开 / 闪退 / 报缺少入口 | [Windows 7 总指南](Windows-7) |
| Windows 7，需要下载或安装 VxKex | [VxKex / VxKex NEXT](VxKex) |
| Windows 7，发烧游戏能登录但游戏下载失败 | [发烧游戏下载兼容](FeverGames-Downloader) |
| Windows 8.1，基岩互通版或 Java 经典版中的基岩版无法启动 | [Windows 8.1 总指南](Windows-8.1) |
| 已经装过旧补丁，不确定如何升级 | [版本与升级](Release-and-Upgrade) |
| 遇到错误但不知道属于哪一类 | [常见报错排查](Troubleshooting) |
| 想先看常见问题 | [FAQ](FAQ) |

## 当前实测结论

### Windows 7 SP1 x64

- Java 经典版启动器中的基岩版：可通过 VxKex / VxKex NEXT + `XINPUT1_3.dll` 运行并进入世界。
- 基岩互通版：可通过 VxKex / VxKex NEXT + `XINPUT1_3.dll` 运行并进入世界。
- 开发者版本：除 VxKex 与 `XINPUT1_3.dll` 外，还需要禁用游戏目录自带的 `dbghelp.dll`，已验证可进入世界。
- 发烧游戏平台下载链：由独立项目 FeverGames-LegacyWindows-Downloader 维护，当前建议使用 v1.3.3。

### Windows 8.1 x64

- 基岩互通版：Launcher Login / Universal Bridge 方案已验证可登录、启动并进入世界。
- Java 经典版启动器中的基岩版：Universal Bridge `java-classic` 模式已验证可启动并进入世界；单人与非局域网联机正常，局域网联机目前有已知限制。

## 两类问题不要混淆

Windows 7 基岩互通版经常同时涉及两个完全不同的兼容层：

1. **发烧游戏平台下载链**：负责“能不能把游戏下载下来”；
2. **Minecraft.Windows.exe 运行兼容**：负责“下载完成后游戏能不能启动”。

下载问题看 [发烧游戏下载兼容](FeverGames-Downloader)；游戏运行问题看 [Windows 7 总指南](Windows-7)。

## 安全提醒

- 不要从来源不明的 DLL 下载站获取 `XINPUT1_3.dll`、`dbghelp.dll` 或 `dbgcore.dll`。
- VxKex / VxKex NEXT 建议直接从项目 GitHub Releases 下载。
- 不要为了兼容问题随意替换 `System32` 中的系统 DLL。
- 反馈问题时不要公开账号、手机号、邮箱、Token、Cookie 或启动器认证参数。

本项目为社区兼容项目，与 Microsoft、Mojang、网易、发烧游戏（FeverGames）无官方关联。
