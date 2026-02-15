# 🤖 OpenClaw One-Click Installer

Automated installation script for deploying OpenClaw AI agent on Android phones.

## 📱 Requirements

- Android phone (Android 10+ recommended)
- Termux + Ubuntu (proot-distro)
- Stable internet connection

## 🚀 Quick Start

### Prerequisites

1. **Install Termux** (Must install from F-Droid, NOT Play Store)
   - Visit [F-Droid.org](https://f-droid.org/)
   - Search and install Termux

2. **Install Ubuntu in Termux**
   ```bash
   pkg update && pkg upgrade -y
   pkg install proot-distro
   proot-distro install ubuntu
   proot-distro login ubuntu
   ```

### One-Click Installation

**Important: Must run in Ubuntu environment, NOT in Termux main shell!**

```bash
# First, login to Ubuntu
proot-distro login ubuntu

# Then run the installation script
curl -fsSL https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh | bash
```

Or download and run:

```bash
curl -O https://raw.githubusercontent.com/zhaotianshi/clawbot-installer/main/install.sh
bash install.sh
```

## 📋 What Gets Installed

The script automatically:

1. ✅ Updates system packages
2. ✅ Installs curl and git
3. ✅ Installs latest Node.js LTS
4. ✅ Installs OpenClaw
5. ✅ Fixes Android network interface issues
6. ✅ Configures environment variables

## 🎯 Post-Installation

### 1. Run Setup Wizard

```bash
openclaw onboard
```

**Important**: When prompted for Gateway Bind, select `127.0.0.1 (Loopback)`

### 2. Start OpenClaw Gateway

```bash
openclaw gateway --verbose
```

### 3. Access Web Dashboard

Open in your mobile browser:
```
http://127.0.0.1:18789
```

### 4. Get Login Token

Open new Termux session and run:
```bash
proot-distro login ubuntu
cat ~/.openclaw/openclaw.json
```

Copy the token and paste it into the dashboard login page.

## 🔧 Troubleshooting

### Q1: Installation fails with "command not found"
**Solution**:
- Make sure you're in Ubuntu environment (`proot-distro login ubuntu`)
- Don't run the script in Termux main environment

### Q2: Node.js installation fails
**Solution**:
```bash
# Manually clean and reinstall
apt remove nodejs npm -y
apt autoremove -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs
```

### Q3: OpenClaw won't start, network error
**Solution**:
- Ensure hijack.js fix is applied
- Reload environment: `source ~/.bashrc`
- Restart Ubuntu: exit and re-login

### Q4: Termux sleeps, OpenClaw stops
**Solution**:
```bash
# Run in Termux main environment (not Ubuntu)
termux-wake-lock
```

Also in Android Settings:
1. Settings → Apps → Termux
2. Battery → Disable optimization
3. Keep device plugged in

### Q5: Cannot access http://127.0.0.1:18789
**Solution**:
- Ensure OpenClaw gateway is running
- Check for error messages
- Try restarting gateway

### Q6: "Gemini API key" error
**Solution**:
- Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
- Create or get API key
- Enter correctly during onboard

### Q7: npm installation fails
**Solution**:
```bash
# Clean cache
npm cache clean --force

# Use --unsafe-perm
npm install -g openclaw@latest --unsafe-perm

# Use mirror (for China users)
npm config set registry https://registry.npmmirror.com
npm install -g openclaw@latest
```

**Detailed troubleshooting guide**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## 💡 Tips

### Keep Running 24/7

1. Use `termux-wake-lock` to prevent sleep
2. Disable battery optimization for Termux
3. Keep device charging
4. Use stable WiFi

### Useful Commands

```bash
# Check OpenClaw version
openclaw --version

# View configuration
cat ~/.openclaw/openclaw.json

# Restart gateway
# First Ctrl+C to stop, then:
openclaw gateway --verbose
```

### Agent Commands

In web dashboard:
- `/status` - Check agent health
- `/think high` - Enable deep reasoning
- `/reset` - Clear memory and restart

## 🔒 Security

- ⚠️ Never share your API keys
- ⚠️ Never share your gateway token
- ⚠️ Use separate Google account for AI keys
- ⚠️ Regularly update OpenClaw and system

## 📚 Resources

- [OpenClaw Official Docs](https://openclaw.ai)
- [Original Guide](https://github.com/AbuZar-Ansarii/Clawbot)
- [Termux Wiki](https://wiki.termux.com/)

## 🤝 Contributing

Issues and Pull Requests are welcome!

## 📄 License

MIT License

---

**Note**: This script is based on [AbuZar-Ansarii/Clawbot](https://github.com/AbuZar-Ansarii/Clawbot). Thanks to the original author.
