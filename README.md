# 中国版《我的世界》基岩客户端旧版 Windows 兼容

用于整理和维护中国版《我的世界》不同基岩客户端在 **Windows 7 / Windows 8.x** 上的兼容方案。

> [!IMPORTANT]
> 本项目为社区兼容项目，与 Microsoft、Mojang、网易、发烧游戏（FeverGames）无官方关联。
> 游戏、启动器或发烧游戏平台更新后，都可能引入新的兼容问题。

## 不知道该用哪个？从这里开始

先确认你的 **Windows 版本** 和 **使用的客户端**：

| 系统 | 客户端 / 问题 | 当前方案 | 直接入口 |
|---|---|---|---|
| **Windows 7 SP1 x64** | Java 经典版启动器中的基岩版 | VxKex / VxKex NEXT + `XINPUT1_3.dll` | [Win7 三种客户端完整说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 7 SP1 x64** | 基岩互通版：游戏本体无法运行 | VxKex / VxKex NEXT + `XINPUT1_3.dll` | [Win7 三种客户端完整说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 7 SP1 x64** | 基岩互通版：发烧游戏无法正常下载 | FeverGames Legacy Windows Downloader **v1.3.1** | [下载 v1.3.1](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader/releases/tag/v1.3.1) |
| **Windows 7 SP1 x64** | 开发者版本 | VxKex + `XINPUT1_3.dll` + 禁用游戏目录自带 `dbghelp.dll` | [Win7 三种客户端完整说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md) |
| **Windows 8.1 x64** | 基岩互通版 | Launcher Login / Universal Bridge | [使用说明](clients/bedrock-interoperability/win81/) · [正式版 v2.0.1](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v2.0.1) |
| **Windows 8.1 x64** | Java 经典版启动器中的基岩版 | Universal Bridge `java-classic` 模式 | [使用说明](clients/java-classic-bedrock/win81/) |
| **Windows 8.0** | 各客户端 | ⚠️ 尚未完整适配 | 暂无正式方案 |
| **Windows 10 / 11** | 新版客户端 | 通常不需要本项目 | 优先使用官方环境 |

> [!TIP]
> **Windows 7 基岩互通版有两个不同问题：**
> 1. 发烧游戏平台能不能把游戏下载下来；
> 2. 下载完成后的 `Minecraft.Windows.exe` 能不能在 Win7 上运行。
>
> 下载问题用 [FeverGames-LegacyWindows-Downloader](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader)，游戏运行问题看 [Win7 三种客户端说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md)。两者不要混为一套补丁。

## 常用下载 / 文档入口

### Windows 7

- **三种中国版基岩客户端运行兼容：** [Windows 7 实测与安装说明](docs/WIN7_CHINA_BEDROCK_VARIANTS.md)
- **发烧游戏下载兼容：** [FeverGames Legacy Windows Downloader v1.3.1](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader/releases/tag/v1.3.1)

当前 FeverGames 下载器 v1.3.1 已在 Windows 7 SP1 x64 上验证 `1.18.42.14 / layout B`，可以完成《我的世界》基岩互通版完整下载，并继续启动、进入世界。

### Windows 8.1

- **基岩互通版：** [方案说明](clients/bedrock-interoperability/win81/) · [当前正式 Release v2.0.1](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v2.0.1)
- **Java 经典版启动器中的基岩版：** [方案说明](clients/java-classic-bedrock/win81/)
- **Universal Bridge Core：** [共享底层说明](shared/win81-universal-bridge/)

> [!NOTE]
> GitHub 当前最新**正式** Release 仍为 **v2.0.1**，它是 Windows 8.1 基岩互通版的历史正式版本。
> 仓库 `main` 已继续开发 Universal Bridge 多客户端共存方案；新的项目级统一 Release 尚未替代 v2.0.1 正式版。

## 当前实测状态

| 客户端 | Windows 7 SP1 x64 | Windows 8.1 x64 |
|---|---|---|
| **基岩互通版** | ✅ 可运行并进入世界；发烧游戏下载链也有独立兼容方案 | ✅ 可通过 Bridge 启动、登录并进入世界 |
| **Java 经典版启动器中的基岩版** | ✅ 可运行并进入世界 | ✅ 可启动并进入世界；单人和非局域网联机正常 |
| **开发者版本** | ✅ 可运行并进入世界 | ⏳ 当前仓库暂无正式方案 |

Windows 7 三种客户端都需要注意 `XINPUT1_3.dll`；开发者版本还需要处理游戏目录自带的 `dbghelp.dll`。具体步骤不要只看上表，请进入对应说明页。

## Windows 8.1 多客户端共存

当前 `main` 中的 **Universal Bridge Core 0.4.3** 已完成实机验证：基岩互通版与 Java Classic 可以在同一台 Windows 8.1 x64 机器上同时注册，并分别正常启动、进入世界。

```text
Minecraft.Windows.exe
        ↓
Universal IFEO Bridge
        ↓
按完整路径分流
        ├─ bedrock-interop
        └─ java-classic
```

如果你只是普通用户，不需要手动配置 Core；请直接进入上面的对应客户端说明。

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

- [更新日志](CHANGELOG.md)
- [免责声明](DISCLAIMER.md)
- [安全说明](SECURITY.md)
- [Release / Tag 规则](docs/RELEASE_TAGS.md)
- [v3.0.0-RC1 计划说明](docs/releases/v3.0.0-rc1.md)

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

项目正在从早期“按客户端分别发布”迁移到“整个项目统一 Release”。未来 Tag 统一使用：

```text
vX.Y.Z
vX.Y.Z-rcN
```

同一个 Release 可以包含多个系统、多个客户端附件。历史 Tag `v2.0.1` 保持原样，不重命名、不删除。

详细规则见 [docs/RELEASE_TAGS.md](docs/RELEASE_TAGS.md)。

</details>

---

本仓库自行编写的内容按 [MIT License](LICENSE) 发布；第三方软件、组件、商标及资源仍归各自权利人所有。
