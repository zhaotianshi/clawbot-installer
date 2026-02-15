# 🚀 部署到 GitHub 指南

## 步骤 1: 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 仓库名称：`clawbot-installer`
3. 描述：`🤖 OpenClaw one-click installer for Android/Termux`
4. 选择 Public（公开）
5. 不要勾选任何初始化选项
6. 点击 "Create repository"

## 步骤 2: 推送代码

在项目目录中运行以下命令：

```bash
cd clawbot-installer

# 初始化 Git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "🎉 Initial release: OpenClaw one-click installer"

# 添加远程仓库（替换 zhaotianshi）
git remote add origin https://github.com/zhaotianshi/clawbot-installer.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

## 步骤 3: 更新 README 中的链接

在 GitHub 仓库创建后，替换以下文件中的 `zhaotianshi`：

- `README.md`
- `README_EN.md`
- `QUICK_START.md`
- `install.sh`

替换为你的实际 GitHub 用户名，然后：

```bash
git add .
git commit -m "📝 Update repository links"
git push
```

## 步骤 4: 添加仓库描述和标签

在 GitHub 仓库页面：

1. 点击右上角的 ⚙️ Settings
2. 在 About 部分添加：
   - Description: `🤖 OpenClaw one-click installer for Android/Termux - Deploy AI agent on your phone in 3 minutes`
   - Website: 留空或填写相关链接
   - Topics: `android`, `termux`, `openclaw`, `ai-agent`, `automation`, `installer`, `proot`, `ubuntu`

## 步骤 5: 测试安装脚本

在手机上测试：

```bash
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

确保脚本可以正常下载和运行。

## 步骤 6: 创建 Release（可选）

1. 在 GitHub 仓库页面点击 "Releases"
2. 点击 "Create a new release"
3. Tag version: `v1.0.0`
4. Release title: `🎉 v1.0.0 - Initial Release`
5. 描述：
   ```
   ## 🚀 首次发布
   
   ### 特性
   - ✨ 一键安装 OpenClaw
   - 🔧 自动修复 Android 网络问题
   - 📝 完整的中英文文档
   - 💡 详细的故障排除指南
   
   ### 安装
   ```bash
   curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
   ```
   
   ### 文档
   - [中文文档](README.md)
   - [English Docs](README_EN.md)
   - [快速开始](QUICK_START.md)
   ```
6. 点击 "Publish release"

## 完成！

你的项目现在已经公开，任何人都可以使用：

```bash
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

## 后续维护

### 更新脚本
```bash
# 修改文件后
git add .
git commit -m "描述你的更改"
git push
```

### 查看使用情况
- GitHub 会显示仓库的 Star、Fork 和 Clone 数量
- 可以在 Insights → Traffic 查看访问统计

### 处理 Issues
- 及时回复用户的问题
- 修复 bug 并发布新版本
