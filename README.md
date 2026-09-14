# 中国版《我的世界》基岩客户端旧版 Windows 兼容

用于整理和维护中国版《我的世界》不同基岩客户端在 **Windows 7 / Windows 8.x** 上的兼容方案。

> [!IMPORTANT]
> 本项目为社区兼容项目，与 Microsoft、Mojang、网易、发烧游戏（FeverGames）无官方关联。
> 游戏、启动器或发烧游戏平台更新后，都可能引入新的兼容问题。

> [!TIP]
> **当前正式版本：[v3.0.0](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0)**  
> 已于 **2026-09-14** 正式发布。Windows 8.1 x64 正式附件为 `Win81_BedrockInterop_v2.1.1_Core0.4.3.zip` 与 `Win81_JavaClassic_v1.0.1_Core0.4.3.zip`，两个客户端共用 Universal Bridge Core 0.4.3。

## 不知道该用哪个？从这里开始

先确认你的 **Windows 版本** 和 **使用的客户端**：

| 系统 | 客户端 / 问题 | 当前方案 | 直接入口 |
|---|---|---|---|
| **Windows 7 SP1 x64** | Java 经典版启动器中的基岩版 | VxKex / VxKex NEXT + `XINPUT1_3.dll` | [Win7 三种客户端完整说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 7 SP1 x64** | 基岩互通版：游戏本体无法运行 | VxKex / VxKex NEXT + `XINPUT1_3.dll` | [Win7 三种客户端完整说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 7 SP1 x64** | 基岩互通版：发烧游戏无法正常下载 | FeverGames Legacy Windows Downloader | [独立项目](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader) |
| **Windows 7 SP1 x64** | 开发者版本 | VxKex + `XINPUT1_3.dll` + 禁用游戏目录自带 `dbghelp.dll` | [Win7 三种客户端完整说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 8.1 x64** | 基岩互通版 | Universal Bridge `bedrock-interop` 模式 | [使用说明](clients/bedrock-interoperability/win81/) · [下载 v3.0.0](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0) |
| **Windows 8.1 x64** | Java 经典版启动器中的基岩版 | Universal Bridge `java-classic` 模式 | [使用说明](clients/java-classic-bedrock/win81/) · [下载 v3.0.0](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0) |
| **Windows 8.0** | 各客户端 | ⚠️ 尚未完整适配 | 暂无正式方案 |
| **Windows 10 / 11** | 新版客户端 | 通常不需要本项目 | 优先使用官方环境 |

> [!TIP]
> **Windows 7 基岩互通版有两个不同问题：**
> 1. 发烧游戏平台能不能把游戏下载下来；
> 2. 下载完成后的 `Minecraft.Windows.exe` 能不能在 Win7 上运行。
>
> 下载问题用 [FeverGames-LegacyWindows-Downloader](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader)，游戏运行问题看 [Win7 三种客户端说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md)。两者不要混为一套补丁。

## Windows 8.1 正式版

项目正式版：[**v3.0.0 — MCBedrock-LegacyWindows**](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0)。

附件：

- [Win81_BedrockInterop_v2.1.1_Core0.4.3.zip](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/download/v3.0.0/Win81_BedrockInterop_v2.1.1_Core0.4.3.zip)
- [Win81_JavaClassic_v1.0.1_Core0.4.3.zip](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/download/v3.0.0/Win81_JavaClassic_v1.0.1_Core0.4.3.zip)

仓库内的详细说明见 [docs/releases/v3.0.0.md](docs/releases/v3.0.0.md)。正式包已经把普通用户入口整理为中文名称，技术文件收进 `_core`，不再把大量英文脚本直接放在根目录。

## 当前实测状态

| 客户端 | Windows 7 SP1 x64 | Windows 8.1 x64 |
|---|---|---|
| **基岩互通版** | ✅ 可运行并进入世界；发烧游戏下载链也有独立兼容方案 | ✅ 可通过发烧游戏启动、登录并进入世界 |
| **Java 经典版启动器中的基岩版** | ✅ 可运行并进入世界 | ✅ 可启动并进入世界；单人和非局域网联机正常 |
| **开发者版本** | ✅ 可运行并进入世界 | ⏳ 当前仓库暂无正式方案 |

Windows 7 三种客户端都需要注意 `XINPUT1_3.dll`；开发者版本还需要处理游戏目录自带的 `dbghelp.dll`。具体步骤不要只看上表，请进入对应说明页。

## Windows 8.1 多客户端共存

当前 **Universal Bridge Core 0.4.3** 已完成实机验证：基岩互通版与 Java Classic 可以在同一台 Windows 8.1 x64 机器上同时注册，并分别正常启动、进入世界。

```text
Minecraft.Windows.exe
        ↓
Universal IFEO Bridge
        ↓
按完整路径分流
        ├─ bedrock-interop
        └─ java-classic
```

两个客户端共享：

```text
C:\ProgramData\MCBedrock-LegacyWindows\Win81UniversalBridge\Win81UniversalBridge.exe
```

## 360 安全软件兼容

本项目安装 Universal Bridge 时需要写入 Windows 的 IFEO `Debugger`。360 会把这个动作识别为“修改映像劫持”。

已实测：

- 360 自我保护开启时，安装器可能在写入 `Debugger` 时被拒绝；
- 仅退出 360 主界面不能解除这一拦截；
- 暂时关闭 360 的**自我保护**后，可以继续安装；
- 360 提示“有程序正在修改映像劫持”时，确认操作来自本项目后选择**允许**；
- **安装完成后可以重新开启 360 自我保护，已实测不影响后续正常运行**；
- 启动游戏时如果 360 再提示 `Win81UniversalBridge.exe` / Minecraft 正在进行“可疑操作”，确认路径正确后选择**允许**即可继续。

因此正常情况下不需要卸载 360。安装器也会在 IFEO 写入被拒绝时给出针对 360 自我保护的明确提示。

## 从旧版升级

以前使用过本项目 Windows 8.1 Bridge 的用户通常不需要先卸载旧版。关闭 Minecraft 后，完整解压对应正式包并运行新的 `安装兼容方案.cmd` 即可。

- 基岩互通版历史 `v2.0.1` 可以直接升级到 `v2.1.1`；
- 旧 Java Classic RC 可以直接迁移到 `v1.0.1`；
- Universal Bridge 0.4.x 测试版可以直接升级；
- 如果希望基岩互通版和 Java Classic 两边都继续使用，需要在两个游戏目录分别运行一次各自正式包的 `安装兼容方案.cmd`；
- 升级后如需卸载，请使用**当前正式包**里的 `卸载兼容方案.cmd`，不要再运行旧版卸载脚本。

完整升级说明见 [v3.0.0 正式版说明](docs/releases/v3.0.0.md)。

## 问题反馈

反馈问题时，建议至少说明：

- Windows 具体版本；
- 使用的是 **基岩互通版 / Java 经典版启动器中的基岩版 / 开发者版本** 中的哪一种；
- Minecraft 版本或构建；
- 第一个出现的报错；
- 是否能够进入主菜单、进入世界；
- 如果是发烧游戏下载问题，同时说明 FeverGames 版本和下载器版本。

请不要公开账号、手机号、邮箱、Token、Cookie 或其他登录凭据。

## 其它文档

- [GitHub Release v3.0.0](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0)
- [v3.0.0 正式版说明](docs/releases/v3.0.0.md)
- [v3.0.0-RC1 历史候选版说明](docs/releases/v3.0.0-rc1.md)
- [更新日志](CHANGELOG.md)
- [免责声明](DISCLAIMER.md)
- [安全说明](SECURITY.md)
- [Release / Tag 规则](docs/RELEASE_TAGS.md)

<details>
<summary><strong>开发者：仓库目录结构</strong></summary>

```text
clients/
├─ bedrock-interoperability/
│  └─ win81/              # 基岩互通版 Windows 8.1
└─ java-classic-bedrock/
   └─ win81/              # Java 经典版启动器中的基岩版 Windows 8.1

shared/
└─ win81-universal-bridge/ # 多客户端共用的 Windows 8.1 IFEO Bridge

docs/
├─ WIN7_CHINA_BEDROCK_VARIANTS.md
├─ RELEASE_TAGS.md
└─ releases/
```

</details>

<details>
<summary><strong>开发者：Release 结构说明</strong></summary>

项目采用整个项目统一 Release 的结构，Tag 使用：

```text
vX.Y.Z
vX.Y.Z-rcN
```

同一个 Release 可以包含多个系统、多个客户端附件。`v3.0.0` 已于 2026-09-14 正式发布，是这一结构下首个正式版；历史 `v3.0.0-rc1` 和 `v2.0.1` 保持原样，不重命名、不删除。

详细规则见 [docs/RELEASE_TAGS.md](docs/RELEASE_TAGS.md)。

</details>

---

本仓库自行编写的内容按 [MIT License](LICENSE) 发布；第三方软件、组件、商标及资源仍归各自权利人所有。
