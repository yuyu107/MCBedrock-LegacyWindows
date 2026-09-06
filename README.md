# 中国版《我的世界》基岩客户端旧版 Windows 兼容

本仓库用于记录和维护中国版《我的世界》不同基岩客户端在旧版 Windows 上的兼容方案。由于**基岩互通版、Java 经典版启动器中的基岩版、开发者版本**在启动链、附带组件和兼容需求上并不完全相同，项目现在统一放在 `main` 分支中，并通过文件夹分类。

> [!IMPORTANT]
> 本项目为社区兼容项目，与 Microsoft、Mojang、网易、发烧游戏（FeverGames）无官方关联。游戏或启动器更新后可能引入新的兼容问题。

## 目录结构

```text
clients/
├─ bedrock-interoperability/
│  └─ win81/              # 基岩互通版 Windows 8.1
└─ java-classic-bedrock/
   └─ win81/              # Java 经典版启动器中的基岩版 Windows 8.1
```

### 当前入口

- [基岩互通版 — Windows 8.1](clients/bedrock-interoperability/win81/)
- [Java 经典版启动器中的基岩版 — Windows 8.1](clients/java-classic-bedrock/win81/)
- [中国版三种基岩客户端 Windows 7 实测情况](docs/WIN7_CHINA_BEDROCK_VARIANTS.md)

## 当前实测状态

| 客户端 | 系统 | 状态 | 说明 |
|---|---|---|---|
| 基岩互通版 | Windows 8.1 x64 | ✅ | Launcher Login Bridge；可正常登录、进入游戏和世界 |
| Java 经典版启动器中的基岩版 | Windows 8.1 x64 | ✅ / RC1 | 可启动并进入世界；单人和非局域网联机正常；局域网联机目前不可用 |
| Java 经典版启动器中的基岩版 | Windows 7 SP1 x64 | ✅ | VxKex / VxKex NEXT + `XINPUT1_3.dll` |
| 基岩互通版 | Windows 7 SP1 x64 | ✅ | VxKex / VxKex NEXT + `XINPUT1_3.dll` |
| 开发者版本 | Windows 7 SP1 x64 | ✅ | VxKex + `XINPUT1_3.dll` + 禁用游戏目录自带 `dbghelp.dll` |

## Release / Tag 区分

源码统一维护在 `main`，Release 用 Tag 前缀区分适用客户端。完整规则见 [docs/RELEASE_TAGS.md](docs/RELEASE_TAGS.md)。

推荐格式：

```text
interop-win81-vX.Y.Z
java-classic-win81-vX.Y.Z[-rcN]
developer-win81-vX.Y.Z
```

已经存在的历史 Tag `v2.0.1` 保持原样，不做重命名；从后续 Release 开始使用带客户端前缀的 Tag。

## Windows 7 发烧游戏下载兼容

发烧游戏平台在 Windows 7 上的下载链兼容已经拆分到独立仓库：

- [FeverGames-LegacyWindows-Downloader](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader)

## IFEO Bridge 注意事项

Windows 8.1 的两个 Bridge 方案都会按映像名 `Minecraft.Windows.exe` 设置机器级 IFEO Debugger。因此**同一时间只应安装其中一个方案**。切换客户端前，应先运行当前方案目录中的卸载脚本。

## 通用文档

- [免责声明](DISCLAIMER.md)
- [安全说明](SECURITY.md)
- [更新日志](CHANGELOG.md)
- [Release Tag 规则](docs/RELEASE_TAGS.md)

本仓库自行编写的内容按 [MIT License](LICENSE) 发布；第三方软件、组件、商标及资源仍归各自权利人所有。
