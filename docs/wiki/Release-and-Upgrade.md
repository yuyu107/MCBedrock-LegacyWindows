# 版本与升级

本项目已经从早期的单客户端独立 Bridge 迁移到多客户端共用的 Universal Bridge 架构，因此旧版升级时需要区分自己曾经安装过什么。

## 当前 Release 状态

当前正式版：

- **[v3.0.0](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0)**；
- Universal Bridge Core：**0.4.3**；
- 基岩互通版包：`Win81_BedrockInterop_v2.1.1_Core0.4.3.zip`；
- Java Classic 包：`Win81_JavaClassic_v1.0.1_Core0.4.3.zip`。

历史版本：

- `v3.0.0-rc1`：首个统一 Release 候选版；
- `v2.0.1`：Windows 8.1 基岩互通版旧独立 Launcher Login Bridge 正式版。

历史 Release 和 Tag 保持原样，不重命名、不删除。

## 从 Windows 8.1 旧 Bridge 升级

如果以前已经使用过本项目的 Windows 8.1 Bridge，通常不需要先运行旧版卸载器。

当前安装器可识别本项目已知旧 Bridge，包括：

```text
Win81MinecraftBridge.exe
Win81JavaClassicBridge.exe
Win81UniversalBridge.exe
```

建议步骤：

1. 关闭所有 Minecraft 实例；
2. 从 [v3.0.0](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v3.0.0) 下载对应客户端附件；
3. 将附件完整解压到当前 `Minecraft.Windows.exe` 所在目录；
4. 运行新包中的 `安装兼容方案.cmd`；
5. 如果同机使用两种客户端，在两个游戏目录分别运行各自的安装脚本；
6. 完成后运行 `检查兼容状态.cmd` 查看共享 Core 与已注册目标；
7. 后续卸载请使用**当前正式包**中的 `卸载兼容方案.cmd`。

## 各旧方案的迁移

### 基岩互通版 v2.0.1

可以直接安装 v3.0.0 中的基岩互通版正式包。安装器会把旧独立 Bridge IFEO 迁移到共享 Universal Bridge。

通常不需要为了升级先恢复 WinPix。

### Java Classic 旧独立 RC

可以直接安装 v3.0.0 中的 Java Classic 正式包。旧 `Win81JavaClassicBridge.exe` IFEO 会被迁移。

### Universal Bridge 0.4.x 早期共存测试版

可以直接升级。早期曾使用：

```text
Mode = interop
```

Core 0.4.3 仍把它识别为基岩互通版兼容别名；重新安装当前正式包后会写成正式模式：

```text
Mode = bedrock-interop
```

## 已经使用基岩互通版 v2.0.1，现在新增 Java Classic

可以直接在 Java Classic 的 `Minecraft.Windows.exe` 所在目录安装当前 Java Classic 正式包。

如果之后不再使用原来的基岩互通版，做到这里即可。

如果希望**基岩互通版和 Java Classic 两边都继续使用**，还需要在原基岩互通版目录安装当前基岩互通版正式包并运行一次 `安装兼容方案.cmd`，把该路径注册为 `bedrock-interop`。

## 360 安全软件

如果安装时在 Universal Bridge 自检完成后出现“拒绝访问 / 尝试执行未经授权的操作”，并安装了 360，可尝试：

1. 暂时关闭 360 的**自我保护**；
2. 重新运行 `安装兼容方案.cmd`；
3. 360 提示“修改映像劫持”时，确认操作来自本项目后选择**允许**。

**安装完成后可以重新开启 360 自我保护，已实测不影响后续正常运行。**

启动游戏时如果 360 再提示 `Win81UniversalBridge.exe` / Minecraft 存在可疑操作，确认路径正确后选择允许即可。

## 早期手工 ApiSet 测试用户

如果曾经手动向游戏目录复制过 `api-ms-win-*` 测试 DLL，应先清理这些早期测试文件，再安装当前 Bridge，避免旧文件干扰当前私有 ApiSet 映射逻辑。

## 游戏移动位置后

Universal Bridge 根据 `Minecraft.Windows.exe` 的完整路径注册。如果游戏被移动到新目录，需要在新的游戏目录重新运行对应的 `安装兼容方案.cmd`。

## 发烧游戏下载器版本独立维护

FeverGames-LegacyWindows-Downloader 是独立项目，有自己的版本号和 Release，不作为 MCBedrock-LegacyWindows 的附件重复打包。

详见 [[发烧游戏下载兼容|FeverGames-Downloader]]。

## 统一 Release 结构

项目级 Tag 使用：

```text
vX.Y.Z
vX.Y.Z-rcN
```

客户端和系统通过附件名区分。当前 v3.0.0 例如：

```text
Win81_BedrockInterop_v2.1.1_Core0.4.3.zip
Win81_JavaClassic_v1.0.1_Core0.4.3.zip
```

后续新的系统或客户端附件继续加入项目级 Release，不再为每个客户端建立独立 Tag。
