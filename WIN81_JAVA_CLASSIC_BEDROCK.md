# Java 经典版启动器中的基岩版：Windows 8.1

Windows 8.1 x64 的 Java 经典版基岩版兼容方案现已进入 **v1.0.0-RC1** 测试阶段。

当前实机验证结果：

- ✅ 可从 Java 经典版启动器正常启动；
- ✅ `Minecraft.Windows.exe 1.21.120.0` 可进入游戏与世界；
- ✅ 单人存档正常；
- ✅ 非局域网联机正常；
- ⚠️ 本地 / 局域网联机目前不可用。

完整原理、安装方式、已知限制和卸载说明见：

[docs/WIN81_JAVA_CLASSIC_BEDROCK.md](docs/WIN81_JAVA_CLASSIC_BEDROCK.md)

> [!WARNING]
> 该方案通过 IFEO 按映像名接管 `Minecraft.Windows.exe`。不要与基岩互通版或其他针对同一映像名的 IFEO Bridge 同时安装。
