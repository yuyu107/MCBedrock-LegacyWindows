# 中国版《我的世界》基岩客户端旧版 Windows 兼容

本仓库用于记录和维护中国版《我的世界》不同基岩客户端在旧版 Windows 上的兼容方案。由于**基岩互通版、Java 经典版启动器中的基岩版、开发者版本**在启动链、附带组件和兼容需求上并不完全相同，项目统一维护在 `main`，并通过文件夹分类。

> [!IMPORTANT]
> 本项目为社区兼容项目，与 Microsoft、Mojang、网易、发烧游戏（FeverGames）无官方关联。游戏或启动器更新后可能引入新的兼容问题。

## 目录结构

```text
clients/
├─ bedrock-interoperability/
│  └─ win81/              # 基岩互通版 Windows 8.1
└─ java-classic-bedrock/
   └─ win81/              # Java 经典版启动器中的基岩版 Windows 8.1

shared/
└─ win81-universal-bridge/ # 多客户端共用的 Windows 8.1 IFEO Bridge
```

### 当前入口

- [基岩互通版 — Windows 8.1](clients/bedrock-interoperability/win81/)
- [Java 经典版启动器中的基岩版 — Windows 8.1](clients/java-classic-bedrock/win81/)
- [Windows 8.1 Universal Bridge Core](shared/win81-universal-bridge/)
- [中国版三种基岩客户端 Windows 7 实测情况](docs/WIN7_CHINA_BEDROCK_VARIANTS.md)

## 当前实测状态

| 客户端 | 系统 | 状态 | 说明 |
|---|---|---|---|
| 基岩互通版 | Windows 8.1 x64 | ✅ | Universal Bridge `bedrock-interop` 模式；可正常登录、进入游戏和世界 |
| Java 经典版启动器中的基岩版 | Windows 8.1 x64 | ✅ | Universal Bridge `java-classic` 模式；可启动并进入世界；单人和非局域网联机正常；局域网联机目前不可用 |
| Java 经典版启动器中的基岩版 | Windows 7 SP1 x64 | ✅ | VxKex / VxKex NEXT + `XINPUT1_3.dll` |
| 基岩互通版 | Windows 7 SP1 x64 | ✅ | VxKex / VxKex NEXT + `XINPUT1_3.dll` |
| 开发者版本 | Windows 7 SP1 x64 | ✅ | VxKex + `XINPUT1_3.dll` + 禁用游戏目录自带 `dbghelp.dll` |

## Windows 8.1 多客户端共存

**Universal Bridge Core 0.4.3 已完成完整候选包实机验证。** Java Classic 与基岩互通版可以同时安装、同时注册，并分别正常启动和进入世界。

```text
Minecraft.Windows.exe
        ↓
唯一的 Universal IFEO Bridge
        ↓
完整路径分流
        ├─ java-classic
        └─ bedrock-interop
```

旧测试版曾使用 `Mode = interop`。Core 0.4.3 仍会把它作为兼容别名识别；新安装统一写入 `Mode = bedrock-interop`。

因此不再需要为了切换 Java Classic / 基岩互通版反复卸载 IFEO。卸载其中一个方案只注销它自己的完整路径；只要仍有其它客户端注册，共享 IFEO 就会保留。

## 统一 Release

从下一阶段开始，GitHub Release 按**整个项目**统一发布，不再为不同客户端分别创建 Release。Tag 采用：

```text
vX.Y.Z
vX.Y.Z-rcN
```

同一个 Release 可以同时包含 Windows 7、Windows 8.1 以及未来其它系统的多个客户端附件。客户端和系统通过附件名区分，例如：

```text
Win81_BedrockInterop_v2.1.0-RC1_Core0.4.3.zip
Win81_JavaClassic_v1.0.0-RC2_Core0.4.3.zip
Win81_Developer_v1.0.0.zip
```

本项目从单客户端 Release 结构迁移到多客户端、多系统统一 Release，下一阶段计划从 **`v3.0.0-rc1`** 开始。完整规则见 [docs/RELEASE_TAGS.md](docs/RELEASE_TAGS.md)。

历史 Tag `v2.0.1` 保持原样，不重命名、不删除。

## Windows 7 发烧游戏下载兼容

发烧游戏平台在 Windows 7 上的下载链兼容已拆分到独立仓库：[FeverGames-LegacyWindows-Downloader](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader)。

## 通用文档

- [免责声明](DISCLAIMER.md)
- [安全说明](SECURITY.md)
- [更新日志](CHANGELOG.md)
- [Release / Tag 规则](docs/RELEASE_TAGS.md)

本仓库自行编写的内容按 [MIT License](LICENSE) 发布；第三方软件、组件、商标及资源仍归各自权利人所有。
