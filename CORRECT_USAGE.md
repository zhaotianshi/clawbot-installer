# ✅ 正确的使用方法

## 🚫 常见错误

很多人会直接在 Termux 主环境运行安装命令，这是**错误的**！

```bash
# ❌ 错误 - 在 Termux 主环境运行
$ curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
# 这样会失败！
```

## ✅ 正确步骤

### 完整流程图

```
Termux 主环境
    ↓
安装 proot-distro
    ↓
安装 Ubuntu
    ↓
登录 Ubuntu ← 【在这里运行安装脚本】
    ↓
运行安装脚本
    ↓
完成！
```

### 详细步骤

#### 第 1 步：在 Termux 主环境准备
```bash
# 打开 Termux 后，你在主环境
# 提示符通常是: $

pkg update && pkg upgrade -y
pkg install proot-distro
proot-distro install ubuntu
```

#### 第 2 步：登录 Ubuntu
```bash
# 这一步很关键！
proot-distro login ubuntu

# 登录后，提示符会变成: root@localhost:~#
# 这表示你已经在 Ubuntu 环境中了
```

#### 第 3 步：运行安装脚本
```bash
# 现在在 Ubuntu 环境中，可以运行安装脚本了
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

## 🎯 如何判断你在哪个环境？

### Termux 主环境
```bash
$ whoami
u0_a123  # 或类似的用户名

$ pwd
/data/data/com.termux/files/home
```

### Ubuntu 环境（proot）
```bash
root@localhost:~# whoami
root

root@localhost:~# pwd
/root
```

## 📋 完整命令清单（复制粘贴）

### 首次安装（从零开始）

```bash
# === 在 Termux 主环境执行 ===
pkg update && pkg upgrade -y
pkg install proot-distro
proot-distro install ubuntu

# === 登录 Ubuntu ===
proot-distro login ubuntu

# === 现在在 Ubuntu 中，运行安装脚本 ===
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash

# === 安装完成后，配置 OpenClaw ===
openclaw onboard

# === 启动服务 ===
openclaw gateway --verbose
```

### 已经安装过 Ubuntu

```bash
# === 直接登录 Ubuntu ===
proot-distro login ubuntu

# === 运行安装脚本 ===
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

## 🔄 环境切换

### 从 Termux 进入 Ubuntu
```bash
proot-distro login ubuntu
```

### 从 Ubuntu 退出到 Termux
```bash
exit
# 或按 Ctrl+D
```

### 在新的 Termux 会话中进入 Ubuntu
```bash
# 打开新的 Termux 会话（下拉通知栏 → New Session）
proot-distro login ubuntu
```

## ⚠️ 常见问题

### Q1: 为什么必须在 Ubuntu 中运行？
A: 因为安装脚本需要：
- apt 包管理器（Termux 用的是 pkg）
- 标准的 Linux 环境
- Node.js 的 deb 包（Termux 的包不兼容）

### Q2: 我怎么知道脚本在哪个环境运行？
A: 看提示符：
- `$` = Termux 主环境
- `root@localhost:~#` = Ubuntu 环境

### Q3: 我在 Termux 运行了脚本，失败了怎么办？
A: 没关系，退出后重新来：
```bash
# 如果在 Ubuntu 中，先退出
exit

# 重新登录 Ubuntu
proot-distro login ubuntu

# 再次运行脚本
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

### Q4: 每次都要登录 Ubuntu 吗？
A: 是的，每次打开新的 Termux 会话都需要：
```bash
proot-distro login ubuntu
```

你可以创建快捷方式：
```bash
# 在 Termux 主环境创建别名
echo "alias ubuntu='proot-distro login ubuntu'" >> ~/.bashrc
source ~/.bashrc

# 以后只需输入
ubuntu
```

## 📱 手机操作提示

### 复制粘贴
1. 长按命令文本
2. 选择"复制"
3. 在 Termux 中长按屏幕
4. 选择"粘贴"

### 多个命令
可以一次复制多行命令，Termux 会自动逐行执行。

### 特殊按键
- 音量下 + Q = 显示额外按键
- 音量下 + C = Ctrl+C（停止程序）
- 音量下 + D = Ctrl+D（退出）

## ✨ 总结

记住这个流程：

1. **Termux 主环境** → 安装 proot-distro 和 Ubuntu
2. **登录 Ubuntu** → `proot-distro login ubuntu`
3. **在 Ubuntu 中** → 运行安装脚本
4. **完成** → 配置和使用 OpenClaw

---

**关键点：安装脚本必须在 Ubuntu 环境中运行！** ⚠️
