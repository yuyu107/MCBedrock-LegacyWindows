# 版本与升级

本项目已经从早期的单客户端独立 Bridge 逐步迁移到多客户端共用的 Universal Bridge 架构，因此旧版升级时需要区分自己曾经安装过什么。

## 当前 Release 状态

截至目前：
- **当前 Pre-release： [v3.0.0-rc1](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0-rc1)**；
- 最新稳定正式 Release 仍为 **v2.0.1**；
- v2.0.1 是 Windows 8.1 基岩互通版的历史正式 Launcher Login Bridge；
- v3.0.0-rc1 是项目迁移到统一 Release 结构后的第一个候选版本，包含 Universal Bridge Core 0.4.3；
- v3.0.0-rc1 同时提供 Windows 8.1 基岩互通版与 Java 经典版启动器中的基岩版附件。

v3.0.0-rc1 附件：

```text
Win81_BedrockInterop_v2.1.0-RC1_Core0.4.3.zip
Win81_JavaClassic_v1.0.0-RC2_Core0.4.3.zip
```

历史 v2.0.1 不重命名、不删除。

## 从 Windows 8.1 旧 Bridge 升级

如果以前已经使用过本项目的 Windows 8.1 Bridge，通常不需要为了升级先运行旧版卸载器。

当前安装器可识别本项目已知旧 Bridge，包括：

```text
Win81MinecraftBridge.exe
Win81JavaClassicBridge.exe
Win81UniversalBridge.exe
```

建议步骤：

1. 关闭所有 Minecraft 实例；
2. 从 [v3.0.0-rc1 Pre-release](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0-rc1) 下载对应客户端附件；
3. 将附件完整解压到当前 `Minecraft.Windows.exe` 所在目录；
4. 运行新包中的 `install_bridge.cmd`；
5. 如果同机使用两种客户端，在两个游戏目录分别运行各自的新安装脚本；
6. 完成后运行 `check_bridge.cmd` 检查共享 Core 与已注册目标；
7. 后续卸载请使用**当前新包**中的 `uninstall_bridge.cmd`。

## 各旧方案的迁移

### 基岩互通版 v2.0.1

可以直接安装 v3.0.0-rc1 中新的 Universal Bridge 方案。安装器会把旧独立 Bridge IFEO 迁移到共享 Universal Bridge。

通常不需要为了升级先恢复 WinPix。

### Java Classic 旧独立 RC

可以直接安装 v3.0.0-rc1 中的 Java Classic Universal Bridge 附件。旧 `Win81JavaClassicBridge.exe` IFEO 会被迁移。

### Universal Bridge 0.4.x 早期共存测试版

可以直接升级。早期曾使用：

```text
Mode = interop
```

Core 0.4.3 仍把它识别为基岩互通版兼容别名；重新安装新版附件后会写成正式模式：

```text
Mode = bedrock-interop
```

## 早期手工 ApiSet 测试用户

如果曾经手动向游戏目录复制过 `api-ms-win-*` 测试 DLL，应先清理那些早期手工测试文件，再安装当前 Bridge，避免旧文件干扰当前私有 ApiSet 映射逻辑。

## 游戏移动位置后

Universal Bridge 根据 `Minecraft.Windows.exe` 的完整路径注册。如果游戏被移动到新目录，需要在新的游戏目录重新运行对应的 `install_bridge.cmd`。

## 发烧游戏下载器版本独立维护

FeverGames-LegacyWindows-Downloader 是独立项目，有自己的版本号和 Release。目前正式版为 v1.3.1。

它不会作为 MCBedrock-LegacyWindows 的 Release 附件重复打包。

详见 [发烧游戏下载兼容](FeverGames-Downloader)。

## 统一 Release 结构

项目级 Release 现在按系统和客户端区分附件，例如：

```text
Win81_BedrockInterop_v2.1.0-RC1_Core0.4.3.zip
Win81_JavaClassic_v1.0.0-RC2_Core0.4.3.zip
```

Tag 则统一归入项目版本，例如：

```text
v3.0.0-rc1
```

后续新的系统或客户端附件会继续加入同一个项目级 Release 结构中，而不是重新按客户端建立独立 Tag。
