# 客户端与版本区别

中国版《我的世界》目前至少需要把下面几种基岩客户端分开看待。它们最终运行的虽然都是基岩版，但启动链、附带组件和兼容要求并不完全相同。

## 1. 基岩互通版

通常通过发烧游戏（FeverGames）平台下载和启动。

特点：
- Windows 7 下既可能遇到**发烧游戏下载链**问题，也可能遇到**Minecraft.Windows.exe 游戏运行**问题；
- Windows 8.1 下当前使用 Launcher Login / Universal Bridge 方案；
- 不应把“下载失败”和“游戏无法启动”当成同一种错误。

对应文档：
- [[Windows 7 总指南|Windows-7]]
- [[发烧游戏下载兼容|FeverGames-Downloader]]
- [[Windows 8.1 总指南|Windows-8.1]]

## 2. Java 经典版启动器中的基岩版

该版本由 Java 经典版启动器负责启动，但最终运行的仍是 `Minecraft.Windows.exe`。

当前实测：
- Windows 7 SP1 x64：VxKex / VxKex NEXT + `XINPUT1_3.dll`，可进入世界；
- Windows 8.1 x64：Universal Bridge `java-classic` 模式，可启动并进入世界；单人与非局域网联机正常，局域网联机目前存在已知限制。

Windows 7 下实际游戏文件常见于类似：

```text
X:\MCLDownload\MinecraftBENeteasePath\x64_mc\Minecraft.Windows.exe
```

盘符和上级目录可能因实际安装位置不同而变化。

## 3. 开发者版本

开发者版本包含更多调试相关组件，因此不能完全照搬普通基岩客户端的处理方式。

Windows 7 当前已验证需要：

```text
XINPUT1_3.dll
+
VxKex / VxKex NEXT
+
禁用游戏目录自带 dbghelp.dll
```

如果只启用 VxKex，可能出现：

```text
无法定位程序输入点 dbgcore.MiniDumpWriteDump 于动态链接库 dbghelp.dll 上
```

当前已验证的处理方式是把游戏目录内的 `dbghelp.dll` 改名为例如 `dbghelp.dll.bak`，而不是替换系统 DLL。

## 怎么判断自己是哪一种？

可以先看你平时从哪里点“开始游戏”：

- 从发烧游戏平台启动：大概率是**基岩互通版**；
- 从 Java 经典版启动器内进入基岩版：属于**Java 经典版启动器中的基岩版**；
- 明确下载的是开发者/开发测试构建：属于**开发者版本**。

如果仍然不确定，反馈问题时可以附上：
- 启动器主界面截图；
- `Minecraft.Windows.exe` 所在目录路径；
- 游戏版本号；
- 第一个报错窗口。

不要上传包含账号、Token、Cookie 等隐私信息的文件。
