# Windows 8.1 Universal Bridge（共存测试）

此目录用于解决多种中国版基岩客户端同时存在时，`Minecraft.Windows.exe` 的机器级 IFEO Debugger 只能指向一个 Bridge 的冲突。

当前阶段：**coexistence test v0.1**。在共存机制完成实机验证前，不替换 `clients/` 下两套已经验证成功的正式/RC 安装器。

## 设计

系统只安装一个共享 IFEO：

```text
Minecraft.Windows.exe
→ Win81UniversalBridge.exe
→ 按目标 Minecraft.Windows.exe 的完整路径查找注册模式
```

目标注册保存在：

```text
HKLM\SOFTWARE\MCBedrock-LegacyWindows\Win81UniversalBridge\Targets\<path-sha256>
```

每一项至少包含：

- `Path`：目标 `Minecraft.Windows.exe` 完整路径；
- `Mode`：`java-classic` 或 `interop`。

路径哈希使用规范化完整路径的小写 UTF-8 SHA-256，仅用于注册表子键命名；Bridge 仍会再次比较保存的完整路径，避免误匹配。

## 模式

### `java-classic`

使用已经实机验证的私有 Windows 8.1 ApiSet v4 映射，不修改 WinPix。

### `interop`

使用相同 ApiSet v4 映射。coexistence test v0.1 暂时复用基岩互通版 v2.0.1 已经完成的 WinPix/W81KERN 状态，不在共享 Bridge 内重新修补 WinPix。

### 未注册路径

如果 IFEO 捕获到一个没有注册的 `Minecraft.Windows.exe` 完整路径，Universal Bridge 只做透明转发，不应用 ApiSet 或 WinPix 兼容修改，避免误伤其他同名客户端。

## 测试包

测试包提供：

- `register_java_classic.cmd`
- `register_interop.cmd`
- `check_registered_targets.cmd`
- `unregister_this_target.cmd`

同一测试包可分别放到两个游戏目录中注册对应模式。卸载某一个目标时，只删除当前完整路径的注册；只有没有任何目标剩余时，才移除共享 IFEO。

## 后续

共存测试通过后，再把 Java Classic 与 Interop 的正式安装器改为注册到该共享 Bridge，并把 Interop 的 WinPix/W81KERN 安装流程正式迁入共享组件。
