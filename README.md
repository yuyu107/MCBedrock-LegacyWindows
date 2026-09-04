# 《我的世界》基岩互通版旧版 Windows 兼容修复

本项目用于恢复新版《我的世界》**基岩互通版**在 Windows 7 / Windows 8.x 上的运行能力。Windows 7 下 FeverGames 的下载兼容方案已拆分到独立仓库维护。

该客户端过去曾能够在 Windows 7 / 8.x 上正常运行，但从 **2026 年 2 月开始的新版本**起，旧版 Windows 不再能够直接正常启动。后续 FeverGames 的新下载后端也对 Windows 7 引入了新的兼容问题，因此现在将“客户端运行兼容”和“FeverGames 下载兼容”分开维护。

> [!IMPORTANT]
> 本项目为社区兼容项目，与 Microsoft、Mojang、网易/FeverGames 无官方关联。
> 游戏与启动器更新后可能引入新的兼容问题，因此无法保证所有未来版本都无需调整。
>
> 使用本项目前，请阅读 [免责声明](DISCLAIMER.md)。账号处罚、封禁、数据损失及其他使用风险由使用者自行评估和承担。

## 下载

### Windows 8.1

当前正式兼容版本：**v2.0.1 - Windows 8.1 Launcher Login Bridge**

[前往 GitHub Releases 下载 v2.0.1](https://github.com/yuyu107/MCBedrock-LegacyWindows/releases/tag/v2.0.1)

### Windows 7：FeverGames 下载修复

当前实验性整合包：**FeverGames Win7 Bedrock Zero-Start Fix v1.2**

- [FeverGames-LegacyWindows-Downloader：完整说明与源码](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader)

该包用于 **FeverGames 1.18.42.12**，可从官方/重装后的平台状态开始一次完成前端系统版本修补和 Win7 兼容 `downloadIPC.exe` 替换。

> [!WARNING]
> Windows 7、Windows 8.0 与 Windows 8.1 的系统内核、API Set 映射及可用系统 API 存在差异，因此不要把 Windows 8.1 Bridge 与 Windows 7 FeverGames 下载补丁混用。

## 当前状态

| 系统 | 状态 | 当前方案 |
|---|---|---|
| Windows 7 SP1 x64 | ✅ 客户端可运行；✅ FeverGames 下载链已完成端到端实机验证 | 游戏使用 VxKex，并确保 `XINPUT1_3.dll` 存在；FeverGames 1.18.42.12 可使用 Zero-Start v1.2 |
| Windows 8.1 x64 | ✅ 已验证可运行 | 使用本项目提供的 Launcher Login Bridge |
| Windows 8.0 | ⚠️ 尚未完整验证 | 可能需要与 Win8.1 不同的适配，请以实机结果为准 |

## Windows 7

### 游戏客户端运行

已验证方式：

1. 使用 **Windows 7 SP1 x64**；
2. 为 `Minecraft.Windows.exe` 启用 **VxKex / VxKex NEXT**；
3. 不需要勾选“报告其他 Windows 版本”之类的系统版本伪装选项；
4. 确保系统中存在 `XINPUT1_3.dll`。

如果缺少 `XINPUT1_3.dll`，建议通过微软旧版 DirectX 运行库补齐，而不是从不明 DLL 下载站单独下载文件。

### FeverGames 下载兼容

此前 Windows 7 上即使绕过 FeverGames 前端的系统版本限制，当前原版 `downloadIPC.exe` 仍会在非常早的 Go runtime 初始化阶段崩溃，典型表现为：

```text
Exception 0xc0000005
PC=0x0
runtime.asmstdcall(...)
```

分析确认当前下载器使用 Go 1.23.x，并会动态调用 Windows 8 起才提供的 `ProcessPrng` 路径。因此单纯伪装系统版本无法解决下载器本体在 Win7 上的早期崩溃。

本项目后续实现了一个 Win7 兼容替代下载器，并完整复现 FeverGames 所需的下载与 IPC 链路：

```text
FeverGames
→ ZMTP / ZMQ
→ Manifest API
→ Manifest
→ Index
→ AES-CTR
→ Zstd
→ Chunk
→ SumBuf 重组
→ MD5 校验
→ FeverGames 实时进度 / 暂停 / 恢复 / 完成
```

### 已实机验证

在 Windows 7 SP1 x64 上已经完成：

- FeverGames ZMTP / ZMQ 握手；
- 官方 Manifest API 请求；
- 动态 `targetVersion`；
- AES-CTR 解密；
- Zstd 解压；
- Protobuf `SumHead` / `SumChunk` / `SumBuf` 动态解析；
- Chunk 下载与断点复用；
- 文件重组与逐文件 MD5 校验；
- FeverGames 下载百分比和速度实际上涨；
- heartbeat；
- 暂停 / 恢复；
- 3130 / 3130 文件完成；
- 下载进度达到 100%。

测试过程中 FeverGames 后续下发了不同于早期研究版本的新 `targetVersion`，替代下载器仍能动态获取对应 Manifest 并完成下载，因此 **Minecraft 游戏内容版本不是写死的**。

### Zero-Start v1.2

独立仓库 [FeverGames-LegacyWindows-Downloader](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader) 提供从 0 开始的一键整合修补脚本。

主要内容：

- 自动寻找 FeverGames 安装目录；
- 自动申请管理员权限；
- 检查平台是否已退出；
- 对 `FeverGamesInstaller.exe` 做精确字节校验后再修补；
- 创建原版回滚备份；
- 编译 Win7 兼容 `.NET downloadIPC.exe`；
- 自动替换并做安装后验证；
- 提供状态检查、恢复原版、诊断收集和缓存清理脚本；
- 不写出 PRIVATE Manifest API response；
- 不记录 deviceId、uid、sig、secKey 等私密参数。

当前前端二进制补丁只验证于：

```text
FeverGames 1.18.42.12
```

如果 FeverGames 本体更新导致二进制位置变化，安装器会因为目标字节不匹配而拒绝修改，而不是盲目写入。

详细说明与脚本见：[FeverGames-LegacyWindows-Downloader](https://github.com/yuyu107/FeverGames-LegacyWindows-Downloader)

## Windows 8.1

Windows 8.1 无法直接照搬 Windows 7 的扩展内核方案，因此本项目为其提供独立兼容方式。

当前正式方案通过 **Launcher Login Bridge** 接管 FeverGamesLauncher 创建的 `Minecraft.Windows.exe`，在游戏真正执行前为该进程建立所需的兼容环境。

### 已验证

- 可以正常通过 FeverGamesLauncher 启动游戏；
- 支持扫码登录；
- 支持手机号登录；
- 支持邮箱登录；
- 可以正常进入游戏；
- 可以正常进入世界；
- 已适配同一游戏版本的多个不同构建；
- 不通过固定 EXE 大小或 SHA-256 白名单限制版本。

### 主要处理内容

- 修复 Windows 8.1 缺失的部分 **API Set v4** 合同；
- 修复部分已存在但未托管的 API Set 映射；
- 处理 `WinPixEventRuntime.dll` 对 Windows 10 API `SetThreadDescription` 的依赖；
- 保留 FeverGamesLauncher 原有登录与更新流程；
- 启动器传给 Minecraft 的认证/启动参数只做原样转交，不写入 Bridge 日志；
- 不修改 `System32`；
- 不要求固定 Minecraft EXE 版本、大小或 SHA-256。

### Windows 8.1 安装方法

1. 从 Releases 下载最新正式版；
2. 将压缩包**完整解压到 `Minecraft.Windows.exe` 所在目录**；
3. 运行 `install_bridge.cmd`；
4. 同意管理员权限；
5. 可运行 `check_bridge.cmd` 检查安装状态；
6. 之后正常打开 FeverGamesLauncher 登录并点击“开始游戏”即可。

安装成功后，不需要再手动运行单独的兼容启动器。

### 游戏更新后需要重新安装吗？

通常**不需要**。

Bridge 的设计不绑定 `Minecraft.Windows.exe` 的固定版本、文件大小或 SHA-256。游戏小版本更新后，可以先直接从 FeverGamesLauncher 正常启动。

如果游戏更新替换了 `WinPixEventRuntime.dll`，Bridge 会在后续启动时重新检查并按需处理。

以下情况建议重新运行 `install_bridge.cmd`：

- 重装了游戏；
- 移动了游戏目录；
- Bridge 文件被删除；
- `check_bridge.cmd` 显示 IFEO Bridge 未正确安装；
- 其他程序修改了 `Minecraft.Windows.exe` 的 IFEO 配置。

如果未来游戏新增了更多 Windows 10 / 11 独占 API，则可能需要发布新的兼容版本，而不是简单重新安装旧版补丁。

## 登录方式

Windows 8.1 正式方案保留 FeverGamesLauncher，因此当前可以继续使用：

- ✅ 扫码登录
- ✅ 手机号登录
- ✅ 邮箱登录

此前曾测试过替换 `netease.data` 后直接使用游戏内置登录模块的方案，虽然可以进入游戏，但无法使用扫码和手机号登录，因此目前不作为正式主方案。

## 隐私与安全

- 本项目**不自行实现账号登录协议**；
- 不收集账号密码；
- 不保存扫码、手机号、邮箱登录凭据；
- FeverGamesLauncher 传给 Minecraft 的认证参数不会写入 Bridge 日志；
- Windows 7 替代下载器不会把 PRIVATE Manifest API response 写入磁盘；
- Windows 7 诊断脚本不会收集 AES key、deviceId、uid、sig 或 secKey；
- 本项目不会修改 `System32`。

## 问题反馈

如果遇到问题，建议在 Issue 中附上：

- Windows 具体版本；
- FeverGames 版本；
- Minecraft / `targetVersion`；
- 是否刚更新平台或游戏；
- 对应方案的日志；
- 第一个 Windows 报错；
- 如有 APPCRASH，请附故障模块名称和异常代码。

Windows 7 FeverGames 修补包可以运行：

```text
04_Collect_Diagnostics.cmd
```

生成不包含上述私密字段的诊断目录。

请不要公开包含账号、手机号、邮箱、Token、Cookie 等隐私信息的日志或截图。

## 免责声明

使用本项目可能存在兼容性、账号风控、封禁、数据异常或其他不可预见风险。本项目不以绕过封禁、反作弊、风控或其他安全机制为目的，也不保证任何账号不会受到处罚。

在使用前请阅读完整的 [免责声明](DISCLAIMER.md)。

## 许可证

本项目自行编写的源代码、脚本及文档采用 [MIT License](LICENSE) 开源。

MIT License **仅适用于本仓库中由本项目自行编写的内容**。Minecraft、Windows、FeverGamesLauncher 以及其他第三方软件、商标、组件和相关资源的权利归各自权利人所有，不因本仓库采用 MIT License 而改变其授权状态。

## 当前版本

- Windows 8.1 正式兼容包：**v2.0.1 Release**
- Windows 7 FeverGames 下载修补：**Zero-Start v1.2（当前针对 FeverGames 1.18.42.12）**

详见 [CHANGELOG.md](CHANGELOG.md)。
