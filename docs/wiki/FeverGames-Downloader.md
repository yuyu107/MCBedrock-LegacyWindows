# 发烧游戏下载兼容

本页解决的是 **Windows 7 下发烧游戏平台“游戏下载链”兼容问题**，不是 `Minecraft.Windows.exe` 游戏本体运行问题。

独立项目：

<https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader>

当前正式版：**v1.3.1**

下载：

<https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader/releases/tag/v1.3.1>

## 它解决什么？

典型情况是：
- 发烧游戏本身能够打开；
- 账号登录没有问题；
- 但在 Windows 7 上游戏下载流程无法正常继续，或新版下载后端与旧系统不兼容。

这时使用 FeverGames-LegacyWindows-Downloader。

如果游戏已经完整下载，但点击开始游戏后 `Minecraft.Windows.exe` 闪退、报缺少入口或无法进入世界，则应看 [[Windows 7 总指南|Windows-7]]。

## v1.3.1 当前验证范围

已验证：
- Windows 7 SP1 x64；
- FeverGames `1.18.42.12`；
- FeverGames `1.18.42.14 / layout A`；
- FeverGames `1.18.42.14 / layout B`；
- `1.18.42.14 / layout B` 前端补丁位置 `5/5` 精确匹配；
- Win7 兼容 `downloadIPC.exe` 替换成功；
- 自定义 FeverGames 安装目录，例如 `D:\FeverGames`；
- 自定义 7-Zip 安装目录，例如 `D:\7-Zip`；
- Windows 7 / PowerShell 2.0 自定义路径保存；
- 一键安装 UAC 流程；
- 《我的世界》基岩互通版完整下载；
- 下载完成后继续启动并进入世界。

## 为什么同一个 1.18.42.14 还分 layout A / B？

实测确认，同一个 `1.18.42.14` 文件夹版本号可能对应不同的 `FeverGamesInstaller.exe` 二进制布局。

因此 v1.3.1 不再只根据版本号盲目套补丁，而是要求目标位置全部匹配后才选择对应 Patch profile。

如果状态检查正常，可能看到类似：

```text
Patch profile: 1.18.42.14 / layout B
Frontend patch count: 5/5
downloadIPC.exe = managed Win7 replacement
rollback backup = COMPLETE
RESULT=READY_FOR_WIN7_FEVERGAMES_DOWNLOAD
```

## 常用入口

Release 包中提供中文入口：

```text
01_一键安装.cmd
02_检查状态.cmd
03_恢复官方文件.cmd
04_收集诊断.cmd
使用说明.txt
core\
```

普通用户优先运行 `01_一键安装.cmd`，完成后可运行 `02_检查状态.cmd` 查看结果。

## 下载仍然很慢或断断续续怎么办？

先区分两件事：
- “完全无法建立下载链 / 前端不兼容”属于补丁解决范围；
- “能下载但速度慢、每几十 MB 停几分钟、偶尔提示网络连接问题”还可能与网络线路、CDN、加速器、连接稳定性等有关。

遇到后者不要只根据“速度慢”判断补丁失败，建议先运行状态检查并收集诊断。

## 反馈时提供

- Windows 版本；
- FeverGames 版本；
- Patch profile；
- Frontend patch count；
- 下载器版本；
- 是否使用自定义安装路径；
- 是否可以开始下载；
- 具体错误或停顿表现。

不要上传账号、Token、Cookie、手机号、邮箱或认证参数。
