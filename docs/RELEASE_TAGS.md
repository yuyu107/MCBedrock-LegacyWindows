# Release Tag 命名规则

本仓库同时维护多种中国版《我的世界》基岩客户端兼容方案。源码统一保存在 `main` 分支，通过目录区分客户端；GitHub Release 通过 Tag 前缀区分适用对象。

## 推荐格式

```text
bedrock-interop-win81-vX.Y.Z
bedrock-interop-win81-vX.Y.Z-rcN
java-classic-win81-vX.Y.Z
java-classic-win81-vX.Y.Z-rcN
developer-win81-vX.Y.Z
```

当前约定：

- `bedrock-interop-*`：基岩互通版；
- `java-classic-*`：Java 经典版启动器中的基岩版；
- `developer-*`：开发者版本；
- `win81`：Windows 8.1 x64；
- `rcN`：Release Candidate / Pre-release。

## 历史 Tag

已经发布的 `v2.0.1` 保持原样，不重命名、不删除，以避免历史 Release 链接失效。

此前文档曾计划使用 `interop-win81-*`，但该前缀尚未用于正式新 Release。为避免 `interop` 含义过于抽象，后续统一使用 `bedrock-interop-win81-*`。

例如：

```text
bedrock-interop-win81-v2.1.0-rc1
bedrock-interop-win81-v2.1.0
java-classic-win81-v1.0.0-rc2
java-classic-win81-v1.0.0
```
