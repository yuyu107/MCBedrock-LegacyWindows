# 基岩互通版 — Windows 8.1

本目录保存中国版《我的世界》**基岩互通版**在 Windows 8.1 x64 上的兼容方案。

当前正式包：**v2.1.1**，使用 **Universal Bridge Core 0.4.3**。历史正式版本 `v2.0.1` 为旧独立 Launcher Login Bridge。

## 已验证

- 可通过发烧游戏（FeverGames）启动器正常启动；
- 支持扫码、手机号、邮箱登录；
- 可进入游戏和世界；
- 保留平台原有登录和更新流程；
- 不绑定固定 `Minecraft.Windows.exe` 大小或 SHA-256；
- 与 Java 经典版启动器中的基岩版同时注册后，两边均可正常启动并进入世界。

## 当前兼容方式

安装器会把当前 `Minecraft.Windows.exe` 的完整路径注册为：

```text
Mode = bedrock-interop
```

所有已注册客户端共用：

```text
C:\ProgramData\MCBedrock-LegacyWindows\Win81UniversalBridge\Win81UniversalBridge.exe
```

Universal Bridge 根据目标完整路径选择基岩互通版逻辑，并处理私有 ApiSet v4 与 `WinPixEventRuntime.dll` / `W81KERN.dll` 兼容。

旧共存测试版曾使用 `Mode = interop`。Core 0.4.3 仍能识别该旧值；重新安装正式包后会写成 `bedrock-interop`。

## 安装

正式 Release 附件：

```text
Win81_BedrockInterop_v2.1.1_Core0.4.3.zip
```

1. 将压缩包完整解压到 `Minecraft.Windows.exe` 所在目录；
2. 运行 `安装兼容方案.cmd`；
3. 安装完成后继续从发烧游戏正常启动。

正式包根目录使用中文入口；技术文件统一放在 `_core`，普通用户不需要单独运行或移动其中的文件。

## 安装路径说明

本方案按当前 `Minecraft.Windows.exe` 的**完整路径**注册和分流，不依赖发烧游戏固定默认安装目录，因此设计上支持其它盘符和自定义文件夹。

当前尚未把“更换盘符 / 含空格目录 / 中文目录”作为独立项目完成实机验证。如果安装后又移动了游戏位置，需要在新位置重新运行 `安装兼容方案.cmd`。

## 360 安全软件兼容

本项目安装时需要写入：

```text
HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe\Debugger
```

360 会把该行为识别为“修改映像劫持”。已实测：

- 360 自我保护开启时，安装器可能在写入 `Debugger` 时出现“拒绝访问 / 尝试执行未经授权的操作”；
- 仅退出 360 主界面不能解除阻止；
- 暂时关闭 360 的**自我保护**后，可以继续安装；
- 360 提示“有程序正在修改映像劫持”时，确认操作来自本项目后选择**允许**，即可完成安装；
- **安装完成后可以重新开启 360 自我保护，已实测不影响后续正常运行**；
- 启动游戏时如果 360 再提示 `Win81UniversalBridge.exe` / Minecraft 正在进行“可疑操作”，确认路径正确后选择**允许**即可继续。

因此正常情况下不需要卸载 360。正式包安装器在 IFEO `Debugger` 写入被拒绝时也会给出针对 360 自我保护的明确提示。

## 从 v2.0.1 升级

通常不需要先卸载旧版，也不需要为了升级而先恢复 WinPix。关闭 Minecraft 后，直接完整解压 v2.1.1 正式包并运行 `安装兼容方案.cmd` 即可。

如果同一台机器还要继续使用 Java Classic，请在 Java Classic 的 `Minecraft.Windows.exe` 所在目录也安装它对应的正式包，并运行一次 `安装兼容方案.cmd`。

## 共存

Java Classic 和基岩互通版可以同时安装兼容方案，不需要在两者之间手工卸载/切换 IFEO。卸载本目录方案时只注销当前基岩互通版路径；如果 Java Classic 仍然注册，共享 IFEO 会继续保留。

## 历史文件

源码仓库中的 `bridge_files/` 和 `RELEASE_v2.0.1.md` 保留旧独立 Bridge 时代的实现与发布说明，主要用于历史参考。普通用户应使用当前项目 Release 中的正式包。
