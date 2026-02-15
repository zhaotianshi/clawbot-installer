# 📱 快速开始指南

## 一、准备工作（5分钟）

### 1. 安装 Termux
- 打开浏览器访问：https://f-droid.org/
- 下载并安装 F-Droid
- 在 F-Droid 中搜索 "Termux" 并安装

### 2. 安装 Ubuntu
打开 Termux，复制粘贴以下命令：

```bash
pkg update && pkg upgrade -y
```

```bash
pkg install proot-distro
```

```bash
proot-distro install ubuntu
```

```bash
proot-distro login ubuntu
```

## 二、一键安装（3分钟）

在 Ubuntu 环境中，复制粘贴：

```bash
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

等待安装完成即可！

## 三、首次配置（2分钟）

### 1. 运行设置向导
```bash
openclaw onboard
```

按提示操作：
- 输入 Gemini API Key（从 https://makersuite.google.com/app/apikey 获取）
- 选择 Gateway Bind：选 `127.0.0.1`

### 2. 启动服务
```bash
openclaw gateway --verbose
```

### 3. 访问控制台
- 打开手机浏览器
- 访问：http://127.0.0.1:18789

### 4. 获取登录令牌
打开新的 Termux 窗口：
```bash
proot-distro login ubuntu
```

```bash
cat ~/.openclaw/openclaw.json
```

复制 token 并登录！

## 四、保持运行

在 Termux 主界面（不是 Ubuntu）运行：
```bash
termux-wake-lock
```

同时在手机设置中：
- 设置 → 应用 → Termux → 电池 → 禁用优化

## 常用命令

```bash
# 启动服务
openclaw gateway --verbose

# 查看版本
openclaw --version

# 查看配置
cat ~/.openclaw/openclaw.json

# 重新配置
openclaw onboard
```

## 遇到问题？

查看完整文档：https://github.com/zhaotianshi/clawbot-installer

---

**提示**：所有命令都可以直接复制粘贴到 Termux 中运行！
