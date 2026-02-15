# 🤖 OpenClaw 一键安装脚本

在 Android 手机上快速部署 OpenClaw AI 代理的自动化安装脚本。

## 📱 适用环境

- Android 手机（推荐 Android 10 及以上）
- Termux + Ubuntu (proot-distro)
- 稳定的网络连接

## 🚀 快速开始

### 前置准备

1. **安装 Termux**（必须从 F-Droid 安装，不要用 Play Store 版本）
   - 访问 [F-Droid.org](https://f-droid.org/)
   - 搜索并安装 Termux

2. **在 Termux 中安装 Ubuntu**
   ```bash
   pkg update && pkg upgrade -y
   pkg install proot-distro
   proot-distro install ubuntu
   proot-distro login ubuntu
   ```

### 一键安装

**重要：必须在 Ubuntu 环境中运行，不是 Termux 主环境！**

```bash
# 先登录 Ubuntu
proot-distro login ubuntu

# 然后运行安装脚本
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

或者下载后运行：

```bash
curl -O https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh
bash install.sh
```

## 📋 安装内容

脚本会自动完成以下操作：

1. ✅ 更新系统包
2. ✅ 安装 curl 和 git
3. ✅ 安装最新版 Node.js LTS
4. ✅ 安装 OpenClaw
5. ✅ 修复 Android 网络接口问题
6. ✅ 配置环境变量

## 🎯 安装后操作

### 1. 运行设置向导

```bash
openclaw onboard
```

**重要提示**：当提示选择 Gateway Bind 时，选择 `127.0.0.1 (Loopback)`

### 2. 启动 OpenClaw 网关

```bash
openclaw gateway --verbose
```

### 3. 访问 Web 控制台

在手机浏览器中打开：
```
http://127.0.0.1:18789
```

### 4. 获取登录令牌

打开新的 Termux 会话，运行：
```bash
proot-distro login ubuntu
cat ~/.openclaw/openclaw.json
```

复制 token 并粘贴到控制台登录页面。

## 🔧 常见问题

### Q1: 安装失败，提示 "command not found"
**解决方案**：
- 确保你在 Ubuntu 环境中（运行 `proot-distro login ubuntu`）
- 不要在 Termux 主环境中运行安装脚本

### Q2: Node.js 安装失败
**解决方案**：
```bash
# 手动清理并重新安装
apt remove nodejs npm -y
apt autoremove -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs
```

### Q3: OpenClaw 无法启动，提示网络错误
**解决方案**：
- 确保已运行 hijack.js 修复脚本
- 重新加载环境变量：`source ~/.bashrc`
- 重启 Ubuntu：退出后重新 `proot-distro login ubuntu`

### Q4: Termux 自动休眠，OpenClaw 停止运行
**解决方案**：
```bash
# 在 Termux 主环境中运行（不是 Ubuntu）
termux-wake-lock
```

同时在 Android 设置中：
1. 设置 → 应用 → Termux
2. 电池 → 禁用电池优化
3. 保持手机充电状态

### Q5: 无法访问 http://127.0.0.1:18789
**解决方案**：
- 确保 OpenClaw gateway 正在运行
- 检查是否有错误信息
- 尝试重启网关：`Ctrl+C` 停止，然后重新运行

### Q6: 提示 "Gemini API key" 错误
**解决方案**：
- 访问 [Google AI Studio](https://makersuite.google.com/app/apikey)
- 创建或获取 API key
- 在 onboard 过程中正确输入

### Q7: 安装过程中断或失败
**解决方案**：
```bash
# 清理并重新开始
apt update
apt clean
apt autoremove -y
# 重新运行安装脚本
```

### Q8: 想要卸载 OpenClaw
**解决方案**：
```bash
npm uninstall -g openclaw
rm -rf ~/.openclaw
```

## 💡 使用技巧

### 保持 24/7 运行

1. 使用 `termux-wake-lock` 防止休眠
2. 禁用 Termux 的电池优化
3. 保持设备充电
4. 使用稳定的 WiFi 连接

### 常用命令

```bash
# 检查 OpenClaw 版本
openclaw --version

# 查看配置
cat ~/.openclaw/openclaw.json

# 重启网关
# 先 Ctrl+C 停止，然后：
openclaw gateway --verbose

# 查看日志
openclaw gateway --verbose --debug
```

### Agent 控制命令

在 Web 控制台中：
- `/status` - 检查代理状态
- `/think high` - 启用深度推理模式
- `/reset` - 清除内存并重启会话

## 🔒 安全建议

- ⚠️ 不要公开分享你的 API keys
- ⚠️ 不要分享你的 gateway token
- ⚠️ 建议使用独立的 Google 账号获取 AI keys
- ⚠️ 定期更新 OpenClaw 和系统包

## 📚 更多资源

- [OpenClaw 官方文档](https://openclaw.ai)
- [原始安装指南](https://github.com/AbuZar-Ansarii/Clawbot)
- [Termux Wiki](https://wiki.termux.com/)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

---

**注意**：本脚本基于 [AbuZar-Ansarii/Clawbot](https://github.com/AbuZar-Ansarii/Clawbot) 项目整理，感谢原作者的贡献。
