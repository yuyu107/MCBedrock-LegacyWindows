# Windows 8.1 Universal Bridge Core

此目录保存 Windows 8.1 下多个中国版基岩客户端共用的 IFEO Bridge。

当前已实机验证核心版本：**0.4.2**。

2026-09-06 已在同一台 Windows 8.1 x64 机器上验证：

- Java 经典版启动器中的基岩版注册为 `java-classic` 后可正常启动并进入世界；
- 基岩互通版注册为 `interop` 后可正常从发烧游戏启动器启动并进入世界；
- 两种客户端可以同时注册，共用一个 `Minecraft.Windows.exe` IFEO Debugger；
- Bridge 按 `Minecraft.Windows.exe` 的**完整路径**分流，不再依赖“同一时间只能安装一个 Bridge”。

## 工作方式

```text
Minecraft.Windows.exe
        ↓
机器级唯一 Universal IFEO Bridge
        ↓
按完整 EXE 路径查注册表
        ├─ java-classic → 私有 Windows 8.1 ApiSet v4
        ├─ interop      → ApiSet v4 + WinPix/W81KERN 兼容
        └─ 未注册路径   → 透明转发，不套兼容模式
```

目标保存在：

```text
HKLM\SOFTWARE\MCBedrock-LegacyWindows\Win81UniversalBridge\Targets\<path-sha256>
```

每个目标记录 `Path`、`Mode` 和 `RegisteredBy`。路径哈希只用于注册表子键命名，Bridge 仍会比较完整路径。

## 文件

- `Win81UniversalBridge.cs`：已验证的 Universal Bridge 0.4.2 源码；
- `register_target.ps1`：通用目标安装/注册逻辑；
- `unregister_target.ps1`：按完整路径注销单个客户端；
- `check_bridge.ps1`：检查共享 IFEO、核心版本和所有注册目标；
- `W81KERN.c` / `W81KERN.def`：Interop 的 `SetThreadDescription` 兼容 shim 源码。

> [!NOTE]
> 源码仓库不直接提交预编译 `W81KERN.dll`。面向普通用户的 Release 包会包含已经构建并实机验证的 `W81KERN.dll`。

## 卸载规则

卸载某一种客户端的兼容方案时只删除该完整路径对应的目标。若仍有其它目标注册，Universal IFEO 保留；只有最后一个目标注销后，才移除本项目设置的 Universal IFEO Debugger。
