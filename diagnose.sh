#!/bin/bash

# OpenClaw 安装诊断脚本
# 用于排查安装问题

echo "=========================================="
echo "  OpenClaw 安装诊断工具"
echo "=========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warn() {
    echo -e "${YELLOW}!${NC} $1"
}

# 1. 检查环境
echo "1. 检查运行环境"
echo "---"
if [ "$EUID" -eq 0 ] || [ -d "/data/data/com.termux" ]; then
    check_pass "在 proot 或 root 环境中"
else
    check_warn "可能不在正确的环境中"
fi

CURRENT_USER=$(whoami)
echo "   当前用户: $CURRENT_USER"

CURRENT_DIR=$(pwd)
echo "   当前目录: $CURRENT_DIR"
echo ""

# 2. 检查磁盘空间
echo "2. 检查磁盘空间"
echo "---"
AVAILABLE=$(df -h / | tail -1 | awk '{print $4}')
AVAILABLE_KB=$(df / | tail -1 | awk '{print $4}')

echo "   可用空间: $AVAILABLE"

if [ "$AVAILABLE_KB" -gt 524288 ]; then
    check_pass "磁盘空间充足（>512MB）"
elif [ "$AVAILABLE_KB" -gt 262144 ]; then
    check_warn "磁盘空间较少（>256MB）"
else
    check_fail "磁盘空间不足（<256MB）"
    echo "   建议: 清理空间或扩展存储"
fi
echo ""

# 3. 检查网络
echo "3. 检查网络连接"
echo "---"
if ping -c 1 registry.npmjs.org &> /dev/null; then
    check_pass "可以访问 npm 官方源"
else
    check_fail "无法访问 npm 官方源"
    echo "   建议: 检查网络连接或使用镜像"
fi

if ping -c 1 registry.npmmirror.com &> /dev/null; then
    check_pass "可以访问 npm 国内镜像"
else
    check_warn "无法访问 npm 国内镜像"
fi
echo ""

# 4. 检查 Node.js
echo "4. 检查 Node.js"
echo "---"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    check_pass "Node.js 已安装: $NODE_VERSION"
    
    # 检查版本
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" -ge 18 ]; then
        check_pass "Node.js 版本符合要求（>=18）"
    else
        check_warn "Node.js 版本较旧（建议 >=18）"
    fi
else
    check_fail "Node.js 未安装"
    echo "   建议: 运行安装脚本"
fi
echo ""

# 5. 检查 npm
echo "5. 检查 npm"
echo "---"
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    check_pass "npm 已安装: $NPM_VERSION"
    
    # 检查 npm 配置
    NPM_REGISTRY=$(npm config get registry)
    echo "   npm 源: $NPM_REGISTRY"
    
    NPM_TIMEOUT=$(npm config get fetch-timeout)
    echo "   超时设置: ${NPM_TIMEOUT}ms"
    
    # 检查缓存
    NPM_CACHE=$(npm config get cache)
    if [ -d "$NPM_CACHE" ]; then
        CACHE_SIZE=$(du -sh "$NPM_CACHE" 2>/dev/null | cut -f1)
        echo "   缓存大小: $CACHE_SIZE"
    fi
else
    check_fail "npm 未安装"
fi
echo ""

# 6. 检查 OpenClaw
echo "6. 检查 OpenClaw"
echo "---"
if command -v openclaw &> /dev/null; then
    OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
    check_pass "OpenClaw 已安装: $OPENCLAW_VERSION"
    
    OPENCLAW_PATH=$(which openclaw)
    echo "   安装路径: $OPENCLAW_PATH"
    
    if [ -d ~/.openclaw ]; then
        check_pass "配置目录存在"
        if [ -f ~/.openclaw/openclaw.json ]; then
            check_pass "配置文件存在"
        else
            check_warn "配置文件不存在（需要运行 openclaw onboard）"
        fi
    else
        check_warn "配置目录不存在"
    fi
else
    check_fail "OpenClaw 未安装"
    echo "   建议: 运行安装脚本"
fi
echo ""

# 7. 检查网络接口修复
echo "7. 检查网络接口修复"
echo "---"
if [ -f /root/hijack.js ]; then
    check_pass "hijack.js 文件存在"
else
    check_fail "hijack.js 文件不存在"
    echo "   建议: 运行安装脚本或手动创建"
fi

if grep -q "NODE_OPTIONS.*hijack.js" ~/.bashrc 2>/dev/null; then
    check_pass "环境变量已配置"
else
    check_warn "环境变量未配置"
    echo "   建议: 添加到 ~/.bashrc"
fi

if [ -n "$NODE_OPTIONS" ]; then
    echo "   当前 NODE_OPTIONS: $NODE_OPTIONS"
else
    check_warn "NODE_OPTIONS 未设置"
fi
echo ""

# 8. 系统信息
echo "8. 系统信息"
echo "---"
if [ -f /etc/os-release ]; then
    OS_NAME=$(grep "^NAME=" /etc/os-release | cut -d'"' -f2)
    OS_VERSION=$(grep "^VERSION=" /etc/os-release | cut -d'"' -f2)
    echo "   系统: $OS_NAME $OS_VERSION"
fi

KERNEL=$(uname -r)
echo "   内核: $KERNEL"

ARCH=$(uname -m)
echo "   架构: $ARCH"
echo ""

# 9. 建议
echo "=========================================="
echo "  诊断建议"
echo "=========================================="
echo ""

ISSUES=0

if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装"
    echo "   解决: 运行安装脚本"
    echo ""
    ISSUES=$((ISSUES+1))
fi

if ! command -v openclaw &> /dev/null; then
    echo "❌ OpenClaw 未安装"
    echo "   解决: npm install -g openclaw@latest --unsafe-perm"
    echo ""
    ISSUES=$((ISSUES+1))
fi

if [ "$AVAILABLE_KB" -lt 262144 ]; then
    echo "⚠️  磁盘空间不足"
    echo "   解决: 清理缓存 (npm cache clean --force; apt clean)"
    echo ""
    ISSUES=$((ISSUES+1))
fi

if ! ping -c 1 registry.npmjs.org &> /dev/null; then
    echo "⚠️  网络连接问题"
    echo "   解决: 检查网络或使用镜像"
    echo "   npm config set registry https://registry.npmmirror.com"
    echo ""
    ISSUES=$((ISSUES+1))
fi

if [ ! -f /root/hijack.js ]; then
    echo "⚠️  网络接口修复未应用"
    echo "   解决: 创建 hijack.js 文件"
    echo ""
    ISSUES=$((ISSUES+1))
fi

if [ $ISSUES -eq 0 ]; then
    echo "✅ 未发现明显问题！"
    echo ""
    if ! command -v openclaw &> /dev/null; then
        echo "如果安装仍然失败，请查看详细故障排除指南："
    else
        echo "如果遇到运行问题，请查看详细故障排除指南："
    fi
    echo "https://github.com/zhaotianshi/clawbot-installer/blob/main/TROUBLESHOOTING.md"
else
    echo "发现 $ISSUES 个问题，请按照上述建议解决。"
    echo ""
    echo "详细故障排除指南："
    echo "https://github.com/zhaotianshi/clawbot-installer/blob/main/TROUBLESHOOTING.md"
fi

echo ""
echo "=========================================="
