# 中国版《我的世界》基岩客户端旧版 Windows 兼容

用于整理和维护中国版《我的世界》不同基岩客户端在 **Windows 7 / Windows 8.x** 上的兼容方案。

> [!IMPORTANT]
> 本项目为社区兼容项目，与 Microsoft、Mojang、网易、发烧游戏（FeverGames）无官方关联。

> [!TIP]
> **当前正式版本：[v3.0.0](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0)**  
> 当前正式版主要提供 Windows 8.1 x64 的基岩互通版与 Java 经典版基岩客户端兼容包。

## 兼容情况

| 系统 | 客户端 / 问题 | 当前方案 | 说明 |
|---|---|---|---|
| **Windows 7 SP1 x64** | Java 经典版启动器中的基岩版 | VxKex / VxKex NEXT + `XINPUT1_3.dll` | [查看说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 7 SP1 x64** | 基岩互通版 | VxKex / VxKex NEXT + `XINPUT1_3.dll` | [查看说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 7 SP1 x64** | 发烧游戏无法正常下载 | FeverGames Legacy Windows Downloader v1.3.6 | [v1.3.6 Release](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader/releases/tag/v1.3.6) |
| **Windows 7 SP1 x64** | 开发者版本 | VxKex + `XINPUT1_3.dll` + 禁用游戏目录自带 `dbghelp.dll` | [查看说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 8.1 x64** | 基岩互通版 | Universal Bridge `bedrock-interop` | [使用说明](clients/bedrock-interoperability/win81/) |
| **Windows 8.1 x64** | Java 经典版启动器中的基岩版 | Universal Bridge `java-classic` | [使用说明](clients/java-classic-bedrock/win81/) |
| **Windows 8.0** | 各客户端 | ⚠️ 尚未完整适配 | 暂无正式方案 |

## Windows 8.1 正式版

[v3.0.0 — MCBedrock-LegacyWindows](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0)

附件：

- `Win81_BedrockInterop_v2.1.1_Core0.4.3.zip`
- `Win81_JavaClassic_v1.0.1_Core0.4.3.zip`

两个客户端共用 **Universal Bridge Core 0.4.3**，已实机验证可以在同一台 Windows 8.1 x64 机器上同时注册并正常启动、进入世界。

> Java Classic 当前已知限制：本地 / 局域网联机不可用；单人和非局域网联机正常。

安装、升级、360 安全软件提示、SHA-256 与其它注意事项请直接查看 [v3.0.0 Release](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0) 或 [详细发布说明](docs/releases/v3.0.0.md)。

## 文档

- [Windows 7 三种客户端说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md)
- [基岩互通版 Windows 8.1](clients/bedrock-interoperability/win81/)
- [Java Classic Windows 8.1](clients/java-classic-bedrock/win81/)
- [Universal Bridge Core](shared/win81-universal-bridge/)
- [更新日志](CHANGELOG.md)
- [Release / Tag 规则](docs/RELEASE_TAGS.md)
- [安全说明](SECURITY.md)
- [免责声明](DISCLAIMER.md)

## 问题反馈

反馈时建议说明 Windows 版本、所用客户端、Minecraft 版本以及最先出现的报错。请不要公开账号、手机号、邮箱、Token、Cookie 或其他登录凭据。

---

本仓库自行编写的内容按 [MIT License](LICENSE) 发布；第三方软件、组件、商标及资源仍归各自权利人所有。
