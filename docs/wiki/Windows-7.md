# Windows 7 总指南

本页用于快速处理中国版《我的世界》基岩客户端在 **Windows 7 SP1 x64** 上的运行问题。

## 先准备什么？

目前三种已验证的中国版基岩客户端都需要系统中存在并能够正常使用：

```text
XINPUT1_3.dll
```

建议通过微软旧版 DirectX 运行库补齐，不要从来源不明的 DLL 下载站单独下载文件。

VxKex 相关下载见：[[VxKex / VxKex NEXT|VxKex]]。

## 按客户端选择方案

### Java 经典版启动器中的基岩版

1. 确认系统为 Windows 7 SP1 x64；
2. 确认 `XINPUT1_3.dll` 可用；
3. 找到真正运行的 `Minecraft.Windows.exe`；
4. 为它启用 VxKex / VxKex NEXT；
5. **不要勾选“报告其他版本”**；
6. 回到原启动器正常启动游戏。

当前已实机验证可以启动并进入世界。

### 基岩互通版

1. 确认 `XINPUT1_3.dll` 可用；
2. 为 `Minecraft.Windows.exe` 启用较新的 VxKex / VxKex NEXT；
3. 从正常启动链启动游戏；
4. 如果问题发生在“下载游戏”阶段，而不是打开 `Minecraft.Windows.exe` 阶段，请改看 [[发烧游戏下载兼容|FeverGames-Downloader]]。

当前已实机验证可以启动并进入世界。

### 开发者版本

除 `XINPUT1_3.dll` 和 VxKex 外，还需要检查游戏目录自带的：

```text
dbghelp.dll
```

如果出现：

```text
无法定位程序输入点 dbgcore.MiniDumpWriteDump 于动态链接库 dbghelp.dll 上
```

先关闭游戏，把游戏目录中的 `dbghelp.dll` 改名为：

```text
dbghelp.dll.bak
```

然后继续保持 `Minecraft.Windows.exe` 启用 VxKex，再启动游戏。

不要替换 `System32` 中的 `dbghelp.dll`，也不要从网上随意下载 `dbgcore.dll` 覆盖系统文件。

## VxKex 应该加在哪个程序上？

原则上是加在**最终真正运行的 `Minecraft.Windows.exe`** 上，而不是随便给启动器本身开启。

如果你不知道实际 EXE 在哪里，可以：
- 从启动器的“打开目录 / 浏览本地文件”之类入口找；
- 在任务管理器里观察游戏启动后的进程位置；
- 根据客户端文档中的典型路径确认。

## 启动后仍然闪退怎么办？

先记住**第一个报错**，不要一上来就复制一堆 DLL。

建议记录：
- Windows 具体版本；
- 客户端类型；
- Minecraft 版本；
- VxKex / VxKex NEXT 版本；
- `XINPUT1_3.dll` 是否正常；
- 是否存在游戏目录自带 `dbghelp.dll` / `dbgcore.dll`；
- 能否创建窗口、进入主菜单、进入世界。

然后查看 [[常见报错排查|Troubleshooting]]。
