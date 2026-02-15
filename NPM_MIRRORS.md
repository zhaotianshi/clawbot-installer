# 🌍 npm 镜像源配置指南

## 什么是 npm 镜像源？

npm 镜像源是 npm 官方仓库的镜像副本，可以加速包的下载，特别是在网络不稳定或访问官方源较慢的地区。

## 📋 可用镜像源列表

### 官方源
| 名称 | 地址 | 适用地区 | 特点 |
|------|------|----------|------|
| npm 官方 | `https://registry.npmjs.org` | 全球 | 最新、最全，国外速度快 |

### 中国镜像
| 名称 | 地址 | 适用地区 | 特点 |
|------|------|----------|------|
| 淘宝镜像 (npmmirror) | `https://registry.npmmirror.com` | 中国大陆 | 最快、最稳定，推荐 ⭐ |
| 腾讯云镜像 | `https://mirrors.cloud.tencent.com/npm/` | 中国大陆 | 稳定、速度快 |
| 华为云镜像 | `https://repo.huaweicloud.com/repository/npm/` | 中国大陆 | 稳定 |
| 中科大镜像 | `https://npmreg.proxy.ustclug.org/` | 中国大陆 | 教育网友好 |

### 其他地区镜像
| 名称 | 地址 | 适用地区 | 特点 |
|------|------|----------|------|
| Cloudflare | `https://registry.npmjs.cf` | 全球 | CDN 加速 |
| jsDelivr | `https://registry.npmjs.eu.org` | 欧洲 | 欧洲用户友好 |

## 🔧 配置方法

### 方法 1: 永久配置（推荐）

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

**验证配置：**
```bash
npm config get registry
```

### 方法 2: 临时使用（不改变配置）

```bash
# 临时使用淘宝镜像安装
npm install -g openclaw@latest --registry=https://registry.npmmirror.com

# 临时使用腾讯云镜像
npm install -g openclaw@latest --registry=https://mirrors.cloud.tencent.com/npm/
```

### 方法 3: 使用 .npmrc 文件

在项目目录或用户目录创建 `.npmrc` 文件：

```bash
# 创建用户级配置
cat > ~/.npmrc << EOF
registry=https://registry.npmmirror.com
fetch-timeout=60000
fetch-retries=5
EOF
```

## 🎯 推荐配置

### 中国大陆用户

**推荐使用淘宝镜像（npmmirror）：**
```bash
npm config set registry https://registry.npmmirror.com
npm config set fetch-timeout 60000
npm config set fetch-retries 5
```

**为什么选择淘宝镜像？**
- ✅ 同步频率高（10 分钟一次）
- ✅ 稳定性好
- ✅ 速度最快
- ✅ 支持完善

### 国外用户

**使用官方源即可：**
```bash
npm config set registry https://registry.npmjs.org
npm config set fetch-timeout 60000
npm config set fetch-retries 5
```

### 企业用户

可以考虑：
- 腾讯云镜像（有企业支持）
- 华为云镜像（有企业支持）
- 自建私有镜像

## 🔍 测试镜像速度

### 手动测试

```bash
# 测试淘宝镜像
time curl -I https://registry.npmmirror.com

# 测试腾讯云镜像
time curl -I https://mirrors.cloud.tencent.com/npm/

# 测试官方源
time curl -I https://registry.npmjs.org
```

### 使用工具测试

```bash
# 安装测试工具
npm install -g npm-registry-benchmark

# 运行测试
npm-registry-benchmark
```

## 📊 镜像源对比

### 同步延迟
| 镜像源 | 同步频率 | 延迟 |
|--------|----------|------|
| 淘宝镜像 | 10 分钟 | 极低 |
| 腾讯云 | 30 分钟 | 低 |
| 华为云 | 1 小时 | 中等 |

### 速度对比（中国大陆）
| 镜像源 | 下载速度 | 稳定性 |
|--------|----------|--------|
| 淘宝镜像 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 腾讯云 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 华为云 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 官方源 | ⭐⭐ | ⭐⭐⭐ |

## 🛠️ 常见问题

### Q1: 镜像源会影响包的安全性吗？
A: 不会。镜像源只是复制官方源的内容，不会修改包。但建议使用知名的镜像源。

### Q2: 可以同时配置多个镜像源吗？
A: npm 只能配置一个默认源，但可以为特定包配置不同的源：
```bash
npm config set @myorg:registry https://custom-registry.com
```

### Q3: 镜像源的包是最新的吗？
A: 镜像源会定期同步官方源，淘宝镜像每 10 分钟同步一次，基本可以认为是最新的。

### Q4: 如何查看所有 npm 配置？
```bash
npm config list
npm config list -l  # 查看所有配置（包括默认值）
```

### Q5: 如何删除镜像源配置？
```bash
npm config delete registry
# 或直接恢复官方源
npm config set registry https://registry.npmjs.org
```

### Q6: 镜像源配置文件在哪里？
```bash
# 用户级配置
~/.npmrc

# 全局配置
/etc/npmrc

# 项目级配置
项目目录/.npmrc
```

## 🚀 最佳实践

### 1. 根据地区选择镜像

```bash
# 中国大陆
npm config set registry https://registry.npmmirror.com

# 其他地区
npm config set registry https://registry.npmjs.org
```

### 2. 配置超时和重试

```bash
npm config set fetch-timeout 60000
npm config set fetch-retries 5
```

### 3. 使用临时镜像而不是永久配置

```bash
# 推荐：临时使用，不影响全局配置
npm install -g openclaw@latest --registry=https://registry.npmmirror.com
```

### 4. 定期检查镜像源状态

```bash
# 检查当前源
npm config get registry

# 测试连接
curl -I $(npm config get registry)
```

### 5. 为不同项目使用不同镜像

在项目目录创建 `.npmrc`：
```bash
registry=https://registry.npmmirror.com
```

## 📝 快速命令参考

```bash
# 查看当前源
npm config get registry

# 切换到淘宝镜像
npm config set registry https://registry.npmmirror.com

# 切换到官方源
npm config set registry https://registry.npmjs.org

# 临时使用镜像
npm install <package> --registry=https://registry.npmmirror.com

# 查看所有配置
npm config list

# 删除镜像配置
npm config delete registry

# 测试镜像速度
time curl -I https://registry.npmmirror.com
```

## 🔗 相关链接

- [淘宝 npm 镜像](https://npmmirror.com/)
- [腾讯云 npm 镜像](https://mirrors.cloud.tencent.com/)
- [华为云 npm 镜像](https://mirrors.huaweicloud.com/)
- [npm 官方文档](https://docs.npmjs.com/)

---

**推荐配置（中国用户）：**
```bash
npm config set registry https://registry.npmmirror.com
npm config set fetch-timeout 60000
npm config set fetch-retries 5
```
