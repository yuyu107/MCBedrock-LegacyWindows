# 安全与隐私说明

本项目通过 Windows Image File Execution Options（IFEO）接管 `Minecraft.Windows.exe` 的启动过程，为 Windows 8.1 建立仅作用于游戏进程的兼容环境。

## 账号与登录

- 本项目不自行实现网易/FeverGames 账号登录协议；
- 不收集账号密码；
- 不保存扫码、手机号或邮箱登录凭据；
- FeverGamesLauncher 传给 Minecraft 的认证/启动参数只做原样转交；
- Bridge 日志不会记录这些认证参数的具体内容。

## 系统改动

- 本项目不会修改 `System32`；
- Windows 8.1 方案会设置针对 `Minecraft.Windows.exe` 的机器级 IFEO Debugger；
- 不再使用本项目时，建议运行 `uninstall_bridge.cmd` 移除该配置；
- 卸载器只删除本项目已知配置，不会擅自清除其他工具设置的 Debugger。

## 日志与反馈

提交 Issue 时，请优先提供：

- `bridge_files\win81_launcher_bridge.log`
- Windows 的第一个错误提示
- APPCRASH 的故障模块与异常代码

请在上传前确认截图和日志中不包含账号、手机号、邮箱、Token、Cookie 或其他个人信息。
