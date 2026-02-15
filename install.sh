#!/bin/bash

# OpenClaw 自动安装脚本
# 适用于 Termux + Ubuntu (proot-distro)
# 项目地址: https://github.com/zhaotianshi/clawbot-installer

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# 显示欢迎信息
echo ""
echo "=========================================="
echo "  OpenClaw 自动安装脚本"
echo "=========================================="
echo ""

# 检查磁盘空间
AVAILABLE_SPACE=$(df / | tail -1 | awk '{print $4}')
if [ "$AVAILABLE_SPACE" -lt 524288 ]; then  # 小于 512MB
    print_warning "磁盘空间可能不足（可用: $(df -h / | tail -1 | awk '{print $4}')）"
    print_warning "建议至少有 500MB 可用空间"
    read -p "是否继续? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 检查是否在正确的环境中
if [ ! -f "/etc/os-release" ]; then
    print_error "无法检测操作系统信息"
    exit 1
fi

# 检查是否有 root 权限或在 proot 环境中
if [ "$EUID" -ne 0 ] && [ ! -d "/data/data/com.termux" ]; then
    print_warning "建议在 Termux 的 Ubuntu (proot-distro) 环境中运行此脚本"
    read -p "是否继续? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 步骤 1: 更新系统
print_info "步骤 1/8: 更新系统包..."
apt update && apt upgrade -y
print_success "系统更新完成"

# 步骤 2: 安装基础工具
print_info "步骤 2/8: 安装 curl 和 git..."
apt install -y curl git
print_success "基础工具安装完成"

# 步骤 3: 检查并安装 Node.js
print_info "步骤 3/8: 检查 Node.js..."

if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    print_warning "检测到已安装 Node.js $NODE_VERSION"
    read -p "是否重新安装最新版本? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        apt remove -y nodejs npm || true
        apt autoremove -y
    else
        print_info "跳过 Node.js 安装"
    fi
fi

if ! command -v node &> /dev/null; then
    print_info "安装最新版 Node.js LTS..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt install -y nodejs
    print_success "Node.js 安装完成"
fi

# 验证安装
NODE_VERSION=$(node -v)
NPM_VERSION=$(npm -v)
print_success "Node.js 版本: $NODE_VERSION"
print_success "npm 版本: $NPM_VERSION"

# 步骤 4: 安装 OpenClaw
print_info "步骤 4/8: 安装 OpenClaw..."

if command -v openclaw &> /dev/null; then
    OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
    print_warning "检测到已安装 OpenClaw $OPENCLAW_VERSION"
    read -p "是否重新安装? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm uninstall -g openclaw || true
    else
        print_info "跳过 OpenClaw 安装"
    fi
fi

if ! command -v openclaw &> /dev/null; then
    print_info "正在安装 OpenClaw（可能需要几分钟）..."
    
    # 配置 npm 以提高成功率
    npm config set fetch-timeout 60000
    npm config set fetch-retries 5
    
    # 尝试多种安装方法
    INSTALL_SUCCESS=false
    
    # 方法 1: 标准安装
    print_info "尝试方法 1: 标准安装..."
    if npm install -g openclaw@latest 2>/dev/null; then
        INSTALL_SUCCESS=true
        print_success "OpenClaw 安装完成"
    else
        print_warning "方法 1 失败，尝试其他方法..."
        
        # 方法 2: 使用 --unsafe-perm
        print_info "尝试方法 2: 使用 --unsafe-perm..."
        if npm install -g openclaw@latest --unsafe-perm 2>/dev/null; then
            INSTALL_SUCCESS=true
            print_success "OpenClaw 安装完成"
        else
            print_warning "方法 2 失败，尝试其他方法..."
            
            # 方法 3: 清理缓存后重试
            print_info "尝试方法 3: 清理缓存后重试..."
            npm cache clean --force 2>/dev/null
            if npm install -g openclaw@latest --unsafe-perm 2>/dev/null; then
                INSTALL_SUCCESS=true
                print_success "OpenClaw 安装完成"
            else
                print_warning "方法 3 失败，尝试使用镜像..."
                
                # 方法 4: 使用国内镜像（适合中国用户）
                print_info "尝试方法 4: 使用 npm 镜像..."
                npm config set registry https://registry.npmmirror.com
                if npm install -g openclaw@latest --unsafe-perm 2>/dev/null; then
                    INSTALL_SUCCESS=true
                    print_success "OpenClaw 安装完成"
                    # 恢复官方源
                    npm config set registry https://registry.npmjs.org
                else
                    npm config set registry https://registry.npmjs.org
                    print_error "所有安装方法都失败了"
                fi
            fi
        fi
    fi
    
    if [ "$INSTALL_SUCCESS" = false ]; then
        print_error "OpenClaw 安装失败"
        echo ""
        echo "可能的原因："
        echo "1. 网络连接不稳定"
        echo "2. 磁盘空间不足"
        echo "3. npm 配置问题"
        echo ""
        echo "请尝试："
        echo "1. 检查网络连接"
        echo "2. 运行: df -h 检查磁盘空间"
        echo "3. 查看故障排除指南:"
        echo "   https://github.com/zhaotianshi/clawbot-installer/blob/main/TROUBLESHOOTING.md"
        echo ""
        echo "手动安装命令："
        echo "  npm cache clean --force"
        echo "  npm install -g openclaw@latest --unsafe-perm"
        echo ""
        exit 1
    fi
fi

# 验证 OpenClaw 安装
if command -v openclaw &> /dev/null; then
    OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
    print_success "OpenClaw 版本: $OPENCLAW_VERSION"
else
    print_error "OpenClaw 安装验证失败"
    echo "请查看故障排除指南: https://github.com/zhaotianshi/clawbot-installer/blob/main/TROUBLESHOOTING.md"
    exit 1
fi

# 步骤 5: 修复 Android 网络接口错误
print_info "步骤 5/8: 修复 Android 网络接口问题..."

mkdir -p /root
cat <<'EOF' > /root/hijack.js
const os = require('os');
os.networkInterfaces = () => ({});
EOF

print_success "网络接口修复脚本已创建"

# 步骤 6: 配置环境变量
print_info "步骤 6/8: 配置环境变量..."

if ! grep -q "NODE_OPTIONS.*hijack.js" ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo '# OpenClaw 网络接口修复' >> ~/.bashrc
    echo 'export NODE_OPTIONS="-r /root/hijack.js"' >> ~/.bashrc
    print_success "环境变量已添加到 ~/.bashrc"
else
    print_info "环境变量已存在，跳过"
fi

# 加载环境变量
export NODE_OPTIONS="-r /root/hijack.js"
print_success "环境变量已加载"

# 步骤 7: 创建快速启动脚本
print_info "步骤 7/8: 创建快速启动脚本..."

cat <<'EOF' > /root/start-openclaw.sh
#!/bin/bash
export NODE_OPTIONS="-r /root/hijack.js"
openclaw gateway --verbose
EOF

chmod +x /root/start-openclaw.sh
print_success "启动脚本已创建: /root/start-openclaw.sh"

# 步骤 8: 完成
print_info "步骤 8/8: 清理..."
apt autoremove -y
apt clean

echo ""
echo "=========================================="
echo -e "${GREEN}  安装完成！${NC}"
echo "=========================================="
echo ""
echo "📋 下一步操作："
echo ""
echo "1️⃣  运行设置向导（首次使用）："
echo "   ${BLUE}openclaw onboard${NC}"
echo "   提示: 选择 Gateway Bind 时选择 127.0.0.1"
echo ""
echo "2️⃣  启动 OpenClaw 网关："
echo "   ${BLUE}openclaw gateway --verbose${NC}"
echo "   或使用快捷脚本: ${BLUE}bash /root/start-openclaw.sh${NC}"
echo ""
echo "3️⃣  访问 Web 控制台："
echo "   在手机浏览器打开: ${BLUE}http://127.0.0.1:18789${NC}"
echo ""
echo "4️⃣  获取登录令牌："
echo "   ${BLUE}cat ~/.openclaw/openclaw.json${NC}"
echo ""
echo "💡 实用提示："
echo "   • 防止休眠: 在 Termux 主环境运行 ${BLUE}termux-wake-lock${NC}"
echo "   • 查看版本: ${BLUE}openclaw --version${NC}"
echo "   • 查看配置: ${BLUE}cat ~/.openclaw/openclaw.json${NC}"
echo ""
echo "📚 遇到问题？查看文档："
echo "   https://github.com/zhaotianshi/clawbot-installer"
echo ""
echo "=========================================="
