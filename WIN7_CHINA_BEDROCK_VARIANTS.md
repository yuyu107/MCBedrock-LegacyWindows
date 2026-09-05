# 中国版《我的世界》基岩客户端在 Windows 7 上的兼容情况

本页记录中国版《我的世界》目前几种不同基岩客户端在 **Windows 7 SP1 x64** 上使用 VxKex / VxKex NEXT 的实机兼容情况。

这些客户端虽然最终运行的都是基岩版，但分发方式、启动链和随包组件并不完全相同，因此应当分别测试，不应把某一种客户端的修复方法无条件套用到另外一种。

> [!IMPORTANT]
> 以下结论来自实际机器测试，并不表示所有未来版本都一定保持相同兼容性。游戏、启动器或 VxKex 更新后，都可能改变结果。

## 所有方案的共同前置条件

无论使用以下哪一种中国版基岩客户端，Windows 7 下都需要确保系统中存在并能够正常使用：

```text
XINPUT1_3.dll
```

也就是说，`XINPUT1_3.dll` **不是仅“基岩互通版”需要的组件，而是目前三种已验证 Win7 方案的共同依赖**。

如果系统缺少 `XINPUT1_3.dll`，建议安装微软旧版 DirectX 运行库补齐，而不是从来源不明的 DLL 下载站单独下载文件。

## 当前实测概览

| 客户端 | Windows 7 状态 | 当前已验证方案 |
|---|---|---|
| Java 经典版启动器中的基岩版 | ✅ 可运行并进入世界 | `XINPUT1_3.dll` + 为 `Minecraft.Windows.exe` 启用 VxKex / VxKex NEXT |
| 基岩互通版 | ✅ 可运行并进入世界 | `XINPUT1_3.dll` + 较新的 VxKex / VxKex NEXT；按本仓库 Windows 7 方案配置 |
| 开发者版本 | ✅ 可运行并进入世界 | `XINPUT1_3.dll` + VxKex，并将游戏目录自带的 `dbghelp.dll` 改名/禁用 |

三种客户端目前都已经实机验证到**能够正常启动并进入世界**，并非只验证到出现窗口或进入主菜单。

## 1. Java 经典版启动器中的基岩版

这是三种客户端中**最早发现能够通过 VxKex 在 Windows 7 上继续运行**的一种。

已验证的基本方式为：

1. 使用 Windows 7 SP1 x64，并确保 `XINPUT1_3.dll` 可用；
2. 找到实际运行的 `Minecraft.Windows.exe`；
3. 为该程序启用 **VxKex / VxKex NEXT**；
4. 通过原启动器正常启动游戏。

实机已经验证该方案可以正常完成启动并进入世界。

在早期测试中，这一版本比“基岩互通版”更早能够依靠 VxKex 在 Windows 7 上运行。

## 2. 基岩互通版

基岩互通版早期在 Windows 7 上仍存在额外兼容问题；随着 VxKex / VxKex NEXT 后续更新，目前已经能够在 Windows 7 上运行。

本仓库原本主要针对这一分发版本记录 Windows 7 / Windows 8.x 的兼容方案。

Windows 7 下目前仍建议：

1. 使用 Windows 7 SP1 x64；
2. 确保系统具备游戏所需的旧版 DirectX 组件，尤其是 `XINPUT1_3.dll`；
3. 为 `Minecraft.Windows.exe` 启用 VxKex / VxKex NEXT；
4. 不要从不明 DLL 下载站随意补系统组件。

实机已经验证该方案可以正常完成启动并进入世界。

FeverGames 平台本身的 Windows 7 下载兼容问题由独立仓库 **FeverGames-LegacyWindows-Downloader** 维护。

## 3. 开发者版本

开发者版本的包体中包含比普通客户端更多的文件和调试相关组件。

在 Windows 7 上需要先确保 `XINPUT1_3.dll` 可用，再为 `Minecraft.Windows.exe` 启用 VxKex。

仅完成这些基础条件后，曾出现以下错误：

```text
Minecraft.Windows.exe - 无法找到入口

无法定位程序输入点 dbgcore.MiniDumpWriteDump 于动态链接库 dbghelp.dll 上。
```

### 原因定位

实机测试确认，该错误与开发者版本游戏目录中**自带的 `dbghelp.dll`** 有关。

当程序优先加载这一随包 `dbghelp.dll` 时，会在 Windows 7 上遇到 `dbgcore.MiniDumpWriteDump` 入口兼容问题。

### 已验证修复方式

不要删除文件，先将 `Minecraft.Windows.exe` 同目录下的：

```text
dbghelp.dll
```

改名为例如：

```text
dbghelp.dll.bak
```

然后继续保持 `Minecraft.Windows.exe` 启用了 VxKex，并确保 `XINPUT1_3.dll` 可用，再启动游戏。

### 实机结果

完成上述处理后已经验证：

- ✅ `Minecraft.Windows.exe` 成功创建游戏窗口；
- ✅ 游戏正常完成启动；
- ✅ 可以正常进入世界。

因此当前测试构建中，开发者版本在 Windows 7 上需要的处理可概括为：

```text
XINPUT1_3.dll
+
VxKex / VxKex NEXT
+
禁用游戏目录自带 dbghelp.dll
```

> [!WARNING]
> 不建议把网上来源不明的 `dbgcore.dll` / `dbghelp.dll` 复制到游戏目录，也不要为了这个问题替换 `System32` 中的系统 DLL。
>
> 当前已经验证的方案只是**改名保留游戏自带的 `dbghelp.dll`**，让程序不再优先使用这一不兼容副本；如需恢复，可将 `.bak` 文件名改回原名。

## 为什么三种客户端要分别记录？

三者虽然都属于中国版基岩客户端，但可能具有不同的：

- 启动器与启动链；
- 附带 DLL / 运行库；
- 版本更新节奏；
- 文件校验方式；
- VxKex 所需兼容处理。

因此“某一个版本能用 VxKex 运行”并不能自动证明另外两个版本无需额外处理。

本次开发者版本的 `dbghelp.dll` 就是一个实际例子：基岩版本体已经能够在 VxKex 环境下继续执行，但随包的新版调试组件会先在 Windows 7 上触发入口错误。

另一方面，`XINPUT1_3.dll` 则是目前三种 Win7 方案共同需要满足的基础依赖，不应只在某一种客户端的说明中出现。

目前三种客户端均已经实机验证能够进入世界，因此这里记录的是实际可游玩到世界内的结果，而不是只记录启动器或主菜单阶段。

## 反馈兼容结果

如果后续版本再次出现启动问题，建议记录：

- Windows 具体版本；
- 使用的是哪一种中国版客户端；
- Minecraft 版本/构建；
- VxKex / VxKex NEXT 版本；
- `XINPUT1_3.dll` 是否存在且可正常加载；
- 第一个出现的 Windows 错误；
- 是否存在游戏目录自带的 `dbghelp.dll` / `dbgcore.dll`；
- 是否能够创建窗口、进入主菜单和进入世界。

请不要公开账号、Token、Cookie、手机号、邮箱等隐私信息。
