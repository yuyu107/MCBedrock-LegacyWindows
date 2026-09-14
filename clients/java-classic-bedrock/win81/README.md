# Java 经典版启动器中的基岩版 — Windows 8.1

本方案用于让 Java 经典版启动器中的基岩版继续在 **Windows 8.1 x64** 上运行。

当前正式包：**v1.0.1**，使用 **Universal Bridge Core 0.4.3**。历史 RC `v1.0.0-RC1` 保留作为早期独立 Bridge 参考。

## 已实机验证

- `Minecraft.Windows.exe 1.21.120.0`；
- 可从 Java 经典版启动器正常启动；
- 可进入游戏主界面和世界；
- 单人存档正常；
- 非局域网联机正常；
- 与基岩互通版同时注册到 Universal Bridge 后，两种客户端均可正常启动并进入世界。

### 已知限制

- ⚠️ 本地 / 局域网联机目前不可用：无法加入同一局域网内其他玩家开放的本地房间，其他玩家也无法加入本机开放的本地房间。
- 当前暂不继续修改这一部分，以优先保持已经验证正常的启动、单人和非局域网联机功能。

## 当前兼容方式

安装器把当前 `Minecraft.Windows.exe` 的完整路径注册为：

```text
Mode = java-classic
```

机器上只保留一个共享 Universal IFEO Bridge。Java Classic 启动时只应用已验证的私有 Windows 8.1 ApiSet v4 映射，不进行 `bedrock-interop` 专用的 WinPix 处理。启动器参数仍原样转交，日志不记录其具体内容。

直接双击 `Minecraft.Windows.exe` 只适合作为诊断；日常仍应从 Java 经典版启动器启动。

## 安装

正式 Release 附件：

```text
Win81_JavaClassic_v1.0.1_Core0.4.3.zip
```

1. 确保 `Minecraft.Windows.exe` 为原版文件；
2. 移除早期测试时手动加入的 `api-ms-win-*` 测试 DLL；
3. 将压缩包完整解压到 `Minecraft.Windows.exe` 所在目录；
4. 运行 `安装兼容方案.cmd`；
5. 之后继续从 Java 经典版启动器正常启动。

正式包根目录使用中文入口；技术文件统一放在 `_core`，普通用户不需要单独运行或移动其中的文件。

## 360 安全软件兼容

本项目安装 Universal Bridge 时需要写入 Windows 的 IFEO `Debugger`。360 会把该行为识别为“修改映像劫持”。

已实测：

- 360 自我保护开启时，安装器可能在写入 `Debugger` 时提示“拒绝访问 / 尝试执行未经授权的操作”；
- 仅退出 360 主界面不能解除阻止；
- 暂时关闭 360 的**自我保护**后，可以继续安装；
- 360 提示“有程序正在修改映像劫持”时，确认操作来自本项目后选择**允许**，即可完成安装；
- **安装完成后可以重新开启 360 自我保护，已实测不影响后续正常运行**；
- 启动游戏时如果 360 再提示 `Win81UniversalBridge.exe` / Minecraft 正在进行“可疑操作”，确认路径正确后选择**允许**即可继续。

因此正常情况下不需要卸载 360。正式包安装器在 IFEO `Debugger` 写入被拒绝时也会给出针对 360 自我保护的明确提示。

## 从旧版或 v2.0.1 互通版迁移

- Java Classic 旧独立 RC 可以直接安装 v1.0.1 正式包迁移到共享 Universal Bridge；
- 如果原来使用的是基岩互通版 v2.0.1，现在只想改用 Java Classic，可以直接在 Java Classic 目录安装本正式包；
- 如果希望基岩互通版和 Java Classic 两边都继续使用，还需要在原基岩互通版目录安装它对应的 v2.1.1 正式包并运行一次 `安装兼容方案.cmd`。

如果同一台机器也安装了基岩互通版，无需在两者之间手工卸载/切换 IFEO。

## 工具

正式包中普通用户主要使用：

- `安装兼容方案.cmd`：安装共享核心并注册当前路径为 `java-classic`；
- `检查兼容状态.cmd`：查看共享核心、当前路径及其它已注册客户端；
- `卸载兼容方案.cmd`：只注销当前 Java Classic 路径；
- `高级工具/生成诊断包.cmd`：遇到异常时生成诊断信息。

源码仓库中的 `bridge_files/Win81JavaClassicBridge.cs` 保留早期独立 Bridge 源码，主要用于历史参考。
