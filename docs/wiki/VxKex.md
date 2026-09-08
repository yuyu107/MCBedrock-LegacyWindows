# VxKex / VxKex NEXT

VxKex 系列用于扩展旧版 Windows 对较新程序所需 API 的兼容能力。本项目在 Windows 7 方案中会用到 VxKex / VxKex NEXT。

## 下载地址

### VxKex

- GitHub：<https://github.com/i486/VxKex>
- Releases：<https://github.com/i486/VxKex/releases>

### VxKex NEXT

- GitHub：<https://github.com/YuZhouRen86/VxKex-NEXT>
- Releases：<https://github.com/YuZhouRen86/VxKex-NEXT/releases>

建议直接从 GitHub Releases 下载正常 Release 构建，不建议使用来源不明的“绿色版”“整合版”或网盘二次打包。

## 本项目里怎么用？

Windows 7 下通常需要对最终真正运行的：

```text
Minecraft.Windows.exe
```

启用 VxKex / VxKex NEXT。

对于 Java 经典版启动器中的基岩版，**不要勾选“报告其他版本”**。

启用后仍然应该从原来的启动器正常启动游戏。直接双击 `Minecraft.Windows.exe` 可以用于排查，但不一定能代表完整启动链是否正常。

## VxKex 和 VxKex NEXT 选哪个？

本项目的兼容结论会同时写作 VxKex / VxKex NEXT，是因为不同阶段、不同客户端构建的兼容情况可能不同。

不要仅因为名字里有 `NEXT` 就假定它对所有程序都一定更合适。更稳妥的方式是：

1. 优先参考本项目对应客户端页面的当前实测结论；
2. 使用项目官方 GitHub Release；
3. 如果一个版本出现异常，再记录具体版本和错误进行对比；
4. 不要同时叠加大量未知兼容补丁，否则很难定位问题。

## 常见误区

### 给错 EXE 开启兼容

只给启动器开启 VxKex，但真正报错的是 `Minecraft.Windows.exe`，通常不能解决游戏本体依赖问题。

### 勾选“报告其他版本”

本项目对 Java 经典版启动器中的基岩版明确建议不要勾选这一项，以免额外改变程序看到的系统版本信息。

### 随意复制 DLL

VxKex 不能替代所有运行库依赖。例如目前三种 Win7 方案都仍需要 `XINPUT1_3.dll`。缺少运行库时应补齐对应官方运行库，而不是到 DLL 下载站逐个复制。

## 遇到问题时需要提供什么？

至少记录：
- 使用 VxKex 还是 VxKex NEXT；
- 具体版本；
- 对哪个 EXE 开启；
- 勾选了哪些选项；
- Windows 版本；
- Minecraft 客户端类型和版本；
- 第一个错误信息。

继续：[[Windows 7 总指南|Windows-7]] · [[常见报错排查|Troubleshooting]]
