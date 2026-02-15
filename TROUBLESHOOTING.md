# 🔧 故障排除指南

## npm 安装失败问题

### 常见错误类型

#### 1. 权限错误
```
Error: EACCES: permission denied
```

**解决方案：**
```bash
# 方法 1: 使用 --unsafe-perm
npm install -g openclaw@latest --unsafe-perm

# 方法 2: 修改 npm 全局目录
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
npm install -g openclaw@latest
```

#### 2. 网络超时
```
Error: network timeout
Error: ETIMEDOUT
```

**解决方案：**
```bash
# 方法 1: 增加超时时间
npm config set fetch-timeout 60000
npm config set fetch-retries 5
npm install -g openclaw@latest

# 方法 2: 使用镜像源
# 中国大陆用户推荐使用淘宝镜像
npm config set registry https://registry.npmmirror.com
npm install -g openclaw@latest

# 其他可用镜像源：
# 腾讯云镜像
npm config set registry https://mirrors.cloud.tencent.com/npm/

# 华为云镜像
npm config set registry https://repo.huaweicloud.com/repository/npm/

# 恢复官方源
npm config set registry https://registry.npmjs.org
```

**镜像源对比：**
| 镜像源 | 地址 | 适用地区 | 速度 |
|--------|------|----------|------|
| npm 官方 | https://registry.npmjs.org | 全球 | 国外快 |
| 淘宝镜像 | https://registry.npmmirror.com | 中国 | 国内最快 |
| 腾讯云 | https://mirrors.cloud.tencent.com/npm/ | 中国 | 国内快 |
| 华为云 | https://repo.huaweicloud.com/repository/npm/ | 中国 | 国内快 |

#### 3. 磁盘空间不足
```
Error: ENOSPC: no space left on device
```

**解决方案：**
```bash
# 检查磁盘空间
df -h

# 清理 npm 缓存
npm cache clean --force

# 清理 apt 缓存
apt clean
apt autoremove -y

# 检查 Termux 存储空间
# 在 Termux 主环境运行
du -sh ~/.npm
```

#### 4. Node.js 版本不兼容
```
Error: engine "node" is incompatible
```

**解决方案：**
```bash
# 检查 Node.js 版本
node -v

# 如果版本太旧，重新安装
apt remove nodejs npm -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs

# 验证版本
node -v  # 应该是 v20.x 或更高
npm -v
```

#### 5. 依赖编译失败
```
Error: gyp ERR! build error
Error: node-gyp rebuild failed
```

**解决方案：**
```bash
# 安装编译工具
apt update
apt install -y build-essential python3 make g++

# 重新尝试安装
npm install -g openclaw@latest --build-from-source
```

#### 6. 网络接口错误（Android 特有）
```
Error: getaddrinfo ENOTFOUND
Error: os.networkInterfaces is not a function
```

**解决方案：**
```bash
# 确保 hijack.js 已创建
cat <<'EOF' > /root/hijack.js
const os = require('os');
os.networkInterfaces = () => ({});
EOF

# 设置环境变量
export NODE_OPTIONS="-r /root/hijack.js"

# 添加到 bashrc
echo 'export NODE_OPTIONS="-r /root/hijack.js"' >> ~/.bashrc
source ~/.bashrc

# 重新安装
npm install -g openclaw@latest
```

## 完整的诊断流程

### 步骤 1: 检查基础环境

```bash
# 检查是否在 Ubuntu 环境
whoami  # 应该显示 root

# 检查 Node.js
node -v  # 应该是 v18+ 或 v20+
npm -v   # 应该是 9+ 或 10+

# 检查网络
ping -c 3 registry.npmjs.org

# 检查磁盘空间
df -h /
```

### 步骤 2: 清理环境

```bash
# 清理 npm 缓存
npm cache clean --force

# 清理旧的安装
npm uninstall -g openclaw 2>/dev/null || true

# 清理系统缓存
apt clean
apt autoremove -y
```

### 步骤 3: 配置 npm

```bash
# 设置超时和重试
npm config set fetch-timeout 60000
npm config set fetch-retries 5

# 如果在中国，使用镜像
npm config set registry https://registry.npmmirror.com

# 设置日志级别（调试用）
npm config set loglevel verbose
```

### 步骤 4: 尝试安装

```bash
# 基础安装
npm install -g openclaw@latest

# 如果失败，尝试带参数
npm install -g openclaw@latest --unsafe-perm

# 如果还失败，尝试从源码编译
npm install -g openclaw@latest --build-from-source

# 如果依然失败，尝试指定版本
npm install -g openclaw@1.0.0  # 替换为实际版本号
```

### 步骤 5: 验证安装

```bash
# 检查是否安装成功
which openclaw
openclaw --version

# 如果找不到命令，检查 PATH
echo $PATH
ls -la ~/.npm-global/bin/  # 或 /usr/local/bin/
```

## 手动安装方法（最后手段）

如果 npm 安装始终失败，可以尝试手动安装：

```bash
# 方法 1: 使用 npx（不需要全局安装）
npx openclaw@latest onboard
npx openclaw@latest gateway --verbose

# 方法 2: 克隆源码安装
git clone https://github.com/openclaw/openclaw.git
cd openclaw
npm install
npm link

# 方法 3: 下载预编译版本（如果有）
# 查看 OpenClaw 的 GitHub Releases 页面
```

## 日志收集

如果需要报告问题，收集以下信息：

```bash
# 系统信息
uname -a
cat /etc/os-release

# Node.js 信息
node -v
npm -v
npm config list

# 磁盘空间
df -h

# 内存信息
free -h

# 完整的错误日志
npm install -g openclaw@latest --loglevel verbose 2>&1 | tee npm-error.log
```

## 特定错误解决方案

### Error: Cannot find module 'XXX'

```bash
# 清理并重新安装
npm cache clean --force
rm -rf ~/.npm
npm install -g openclaw@latest
```

### Error: CERT_UNTRUSTED

```bash
# 临时禁用 SSL 验证（不推荐，仅用于测试）
npm config set strict-ssl false
npm install -g openclaw@latest
npm config set strict-ssl true
```

### Error: Maximum call stack size exceeded

```bash
# 增加 Node.js 内存限制
export NODE_OPTIONS="--max-old-space-size=4096 -r /root/hijack.js"
npm install -g openclaw@latest
```

### Error: EEXIST: file already exists

```bash
# 强制覆盖安装
npm install -g openclaw@latest --force
```

## 预防措施

### 1. 保持系统更新
```bash
apt update && apt upgrade -y
```

### 2. 定期清理缓存
```bash
npm cache clean --force
apt clean
```

### 3. 使用稳定的网络
- 使用 WiFi 而不是移动数据
- 避免在网络不稳定时安装

### 4. 确保足够的存储空间
- 至少保留 500MB 可用空间
- 定期清理不需要的文件

## 获取帮助

如果以上方法都无法解决问题：

1. **查看 OpenClaw 文档**
   - https://openclaw.ai/docs

2. **提交 Issue**
   - https://github.com/zhaotianshi/clawbot-installer/issues
   - 包含完整的错误日志
   - 说明你的环境信息

3. **社区求助**
   - Termux 社区
   - OpenClaw Discord/Telegram

## 快速参考

### npm 镜像源配置

**查看当前源：**
```bash
npm config get registry
```

**切换到淘宝镜像（中国用户推荐）：**
```bash
npm config set registry https://registry.npmmirror.com
```

**切换到腾讯云镜像：**
```bash
npm config set registry https://mirrors.cloud.tencent.com/npm/
```

**切换到华为云镜像：**
```bash
npm config set registry https://repo.huaweicloud.com/repository/npm/
```

**恢复官方源：**
```bash
npm config set registry https://registry.npmjs.org
```

**临时使用镜像（不改变配置）：**
```bash
npm install -g openclaw@latest --registry=https://registry.npmmirror.com
```

### 最常用的解决方案

```bash
# 1. 清理并重试
npm cache clean --force
npm install -g openclaw@latest --unsafe-perm

# 2. 使用镜像（中国用户）
npm config set registry https://registry.npmmirror.com
npm install -g openclaw@latest

# 3. 修复网络接口
export NODE_OPTIONS="-r /root/hijack.js"
npm install -g openclaw@latest

# 4. 增加超时
npm config set fetch-timeout 60000
npm install -g openclaw@latest

# 5. 使用 npx（不需要全局安装）
npx openclaw@latest --version
```

---

**记住**：大多数 npm 安装问题都可以通过清理缓存、检查网络和使用正确的参数来解决！
