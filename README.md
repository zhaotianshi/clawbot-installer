# OpenClaw on Termux Setup Guide

Complete guide to run OpenClaw on Android using Termux and connect from your laptop.

---

## 🛠️ Step 1: Prepare Termux

```bash
pkg update && pkg upgrade -y
```

---

## 📦 Step 2: Install Required Packages

```bash
pkg install -y git nodejs openssh tmux nano wget curl build-essential python proot
```

---

## 🔐 Step 3: SSH Preparation (on Android)

Start SSH daemon:
```bash
sshd
```

Set password:
```bash
passwd
```

Get your username:
```bash
whoami
```

Get your IP address:
```bash
ifconfig
```

---

## 💻 Step 4: Connect from Laptop

```bash
ssh {user}@{android_ip} -p 8022
```

Example:
```bash
ssh u0_a276@192.168.1.60 -p 8022
```

---

## 🤖 Step 5: Install OpenClaw

```bash
npm i -g openclaw
```

---

## 🚀 Step 6: Onboard OpenClaw

Enter chroot environment:
```bash
termux-chroot
```

Run onboarding:
```bash
openclaw onboard
```

---

## 🧵 Step 7: Prepare Persistent Session

Prevent device sleep:
```bash
termux-wake-lock
```

Create tmux session:
```bash
tmux new -s openclaw
```

Inside the tmux session, enter chroot and start gateway:
```bash
termux-chroot
```

```bash
openclaw gateway --verbose
```

---

## 📊 Step 8: Get Dashboard Info

```bash
openclaw dashboard
```

---

## 🌐 Step 9: SSH Port Forwarding (from Laptop)

```bash
ssh -L 18789:127.0.0.1:18789 -L 18790:127.0.0.1:18790 {user}@{android_ip} -p 8022
```

---

## 📝 Notes

- Replace `{user}` with your actual username from `whoami`
- Replace `{android_ip}` with your actual IP address from `ifconfig`
- Default SSH port for Termux is `8022`
- Use `Ctrl+B` then `D` to detach from tmux session
- Use `tmux attach -t openclaw` to reattach to the session
