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
- 当前正式包会把共享 Bridge 安装到：

```text
C:\ProgramData\MCBedrock-LegacyWindows\Win81UniversalBridge\Win81UniversalBridge.exe
```

- 不再使用本项目时，建议运行当前正式包中的 `卸载兼容方案.cmd` 移除相关配置；
- 卸载器只删除本项目已知配置，不会擅自清除其他工具设置的 Debugger。

## 安全软件提示

IFEO `Debugger` 本身属于高敏感系统机制，因此安全软件可能把本项目的安装与启动行为标记为“映像劫持”或“可疑操作”。

360 已有实机验证：

- 自我保护开启时，可能阻止安装器写入 `Minecraft.Windows.exe\Debugger`；
- 暂时关闭 360 自我保护后可继续安装；
- 360 提示“有程序正在修改映像劫持”时，应先确认程序路径属于本项目，再选择允许；
- **安装完成后可以重新开启 360 自我保护，已实测不影响后续正常运行**；
- 启动游戏时如果 360 提示 `Win81UniversalBridge.exe` / Minecraft 正在执行“可疑操作”，同样应先核对程序路径，再决定是否允许。

不要为了安装本项目去修改整个注册表分支的 ACL、夺取系统键所有权，或永久关闭安全软件保护。优先使用安全软件自身的临时放行 / 自我保护开关。

## 日志与反馈

提交 Issue 时，请优先提供：

- `检查兼容状态.cmd` 的输出；
- `C:\ProgramData\MCBedrock-LegacyWindows\Win81UniversalBridge\win81_universal_bridge.log`（如果存在）；
- Windows 的第一个错误提示；
- APPCRASH 的故障模块与异常代码。

请在上传前确认截图和日志中不包含账号、手机号、邮箱、Token、Cookie 或其他个人信息。
