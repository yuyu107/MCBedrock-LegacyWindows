# Java Classic Bedrock Win8.1 Changelog

## v1.0.1

- 作为 MCBedrock-LegacyWindows **v3.0.0** 正式版中的 Java Classic Windows 8.1 附件发布；
- 统一使用 **Universal Bridge Core 0.4.3**；
- 可与基岩互通版同时注册并共存；
- 正式包根目录改用中文入口，技术文件收进 `_core`；
- 安装器增加 IFEO `Debugger` 写入阶段提示；
- 补充 360 安全软件兼容诊断：自我保护可能阻止 IFEO 写入；关闭自我保护并允许“修改映像劫持”提示后可完成安装；
- 安装完成后可重新开启 360 自我保护，已实测不影响后续运行；
- 保留单人、非局域网联机正常的验证结果；
- 本地 / 局域网联机仍为已知限制。

正式附件：

```text
Win81_JavaClassic_v1.0.1_Core0.4.3.zip
```

## v1.0.0-RC1

- 基于已实机成功的私有 ApiSet v4 进程映射方案；
- 不修改 `Minecraft.Windows.exe`；
- 不修改 Java 经典版启动器；
- 增加 Windows 8.1 x64 与 PE 架构检查；
- 增加安装状态检查、安全卸载和诊断 ZIP；
- 检测早期逐个补充的 ApiSet 测试 DLL；
- 当前构建无需互通版使用的 WinPix/W81KERN 修改即可进入世界；
- 已验证单人和非局域网联机正常；
- 本地/局域网联机暂列为已知限制。
