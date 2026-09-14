# Release / Tag 规则

本仓库同时维护多种中国版《我的世界》基岩客户端与多个 Windows 版本的兼容方案。源码统一保存在 `main`，客户端和系统通过目录及 Release 附件区分；GitHub Release 按整个项目统一发布，不再为每个客户端分别创建 Release / Tag。

## 项目级 Tag

正式版：

```text
vX.Y.Z
```

候选 / 预发布版：

```text
vX.Y.Z-rcN
```

例如：

```text
v3.0.0-rc1
v3.0.0
v3.1.0
```

同一个 Release 可以同时包含多个系统、多个客户端的附件。用户进入最新 Release 后，根据自己的“系统 → 客户端”选择对应压缩包即可。

## 附件命名

客户端和系统信息放在附件名中，而不是 Tag 中。当前 v3.0.0 正式版例如：

```text
Win81_BedrockInterop_v2.1.1_Core0.4.3.zip
Win81_JavaClassic_v1.0.1_Core0.4.3.zip
```

未来还可以继续加入：

```text
Win81_Developer_v1.0.0.zip
Win7_BedrockInterop_...
Win7_JavaClassic_...
Win7_Developer_...
```

附件中的组件版本可以独立演进，不要求所有客户端在同一次项目 Release 中使用相同组件版本。

## Release 组织方式

Release 说明优先按“系统 → 客户端”组织，例如：

```text
Windows 8.1 x64
├─ 基岩互通版
├─ Java 经典版启动器中的基岩版
└─ 开发者版本

Windows 7 x64
├─ 基岩互通版
├─ Java 经典版启动器中的基岩版
└─ 开发者版本
```

某个客户端或系统在该版本没有新附件时，可以继续引用上一版已验证方案，不需要为了保持列表完整而重复打包。

## 版本号原则

- `PATCH`：现有方案的小修复、安装器/文档/打包修正；
- `MINOR`：新增兼容能力、客户端或系统方案，同时保持整体升级路径；
- `MAJOR`：项目发布结构或兼容架构发生较大变化。

本项目从“单客户端 Release”迁移到“多客户端、多系统统一 Release”，因此以 **`v3.0.0`** 作为这一阶段首个正式版。

客户端包版本独立维护。例如 v3.0.0 中：

```text
基岩互通版包：v2.1.1
Java Classic 包：v1.0.1
Universal Bridge Core：0.4.3
```

## 历史 Tag

以下历史 Tag 保持原样，不重命名、不删除：

```text
v2.0.1
v3.0.0-rc1
```

此前文档中规划过以下客户端级 Tag：

```text
interop-win81-*
bedrock-interop-win81-*
java-classic-win81-*
developer-win81-*
```

这些前缀不再用于当前项目级 Release；客户端名称改由附件名表达。
