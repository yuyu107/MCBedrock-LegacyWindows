# Windows 8.1 Universal Bridge（共存测试）

此目录用于解决多种中国版基岩客户端同时存在时，`Minecraft.Windows.exe` 的机器级 IFEO Debugger 只能指向一个 Bridge 的冲突。

当前阶段：**coexistence test v0.4**。在共存机制完成实机验证前，不替换 `clients/` 下两套已经验证成功的正式/RC 安装器。

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

使用相同的私有 ApiSet v4 映射，并保持基岩互通版已验证方案中的 WinPix / W81KERN 兼容处理方向。

### 未注册路径

如果 IFEO 捕获到一个没有注册的 `Minecraft.Windows.exe` 完整路径，Universal Bridge 只做透明转发，不应用 ApiSet / WinPix 兼容修改，避免误伤其他同名客户端。

## v0.4：先验证共享 EXE 真的完成升级

实机日志曾出现一个重要现象：测试包已经迭代到 v0.3，但 `C:\ProgramData\MCBedrock-LegacyWindows\Win81UniversalBridge\win81_universal_bridge.log` 的实际运行头部仍然显示 `coexistence test v0.1`，并且失败的 Interop 启动没有留下任何 `interop` 路由记录。

因此 v0.4 不继续盲目修改 Interop 本身，而首先强化共享 Bridge 的升级与自检：

1. 编译到临时 `Win81UniversalBridge.v0.4.new.exe`；
2. 用 `--version` 验证临时 EXE 必须明确返回 v0.4；
3. 如果旧 Universal Bridge 仍在运行，则拒绝强制覆盖并提示先关闭 Minecraft / 重启；
4. 保存上一份共享 EXE 为 `Win81UniversalBridge.previous.exe`；
5. 安装后再次执行 `--version`；
6. 验证 IFEO Debugger 确实指向共享 EXE；
7. 保留其它已注册目标；
8. 归档旧日志，避免旧 v0.1 日志与新测试结果混在一起。

只有确认 `check_registered_targets.cmd` 显示共享 EXE 自检版本为 v0.4 后，后续 Interop 失败日志才可以视为 v0.4 的真实结果。

## 测试包

测试包提供：

- `register_java_classic.cmd`
- `register_interop.cmd`
- `check_registered_targets.cmd`
- `unregister_this_target.cmd`

同一测试包可分别放到两个游戏目录中注册对应模式。卸载某一个目标时，只删除当前完整路径的注册；只有没有任何目标剩余时，才移除共享 IFEO。

## 后续

共存测试通过后，再把 Java Classic 与 Interop 的正式安装器改为注册到该共享 Bridge，并把 Interop 的 WinPix/W81KERN 安装流程正式迁入共享组件。