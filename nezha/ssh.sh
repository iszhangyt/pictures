#!/bin/bash

# 确保脚本以root用户身份运行
if [ "$(id -u)" != "0" ]; then
   echo "此脚本必须以 root 身份运行" 1>&2
   exit 1
fi

# 检查是否提供了公钥
if [ -z "$1" ]; then
    echo "用法：$0 '你的公钥'"
    exit 1
fi

# 从参数中获取公钥
PUBLIC_KEY="$1"

# 简单检查公钥是否符合基本格式要求
if ! echo "$PUBLIC_KEY" | grep -Eq "^ssh-(rsa|dss|ed25519|ecdsa-sha2-nistp(256|384|521)) "; then
    echo "公钥格式无效. 请确保密钥开头为 'ssh-rsa', 'ssh-dss', 'ssh-ed25519', 或 'ecdsa-sha2-nistp...'"
    exit 1
fi

# 禁用密码验证，启用密钥验证，并限制root用户仅允许通过密钥登录
SSHD_CONFIG="/etc/ssh/sshd_config"

sed -i "s/^#*PasswordAuthentication .*/PasswordAuthentication no/" $SSHD_CONFIG
sed -i "s/^#*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/" $SSHD_CONFIG
sed -i "s/^#*UsePAM .*/UsePAM no/" $SSHD_CONFIG
sed -i "s/^#*PermitRootLogin .*/PermitRootLogin prohibit-password/" $SSHD_CONFIG
sed -i "s/^#*PubkeyAuthentication .*/PubkeyAuthentication yes/" $SSHD_CONFIG

# 创建~/.ssh目录并设置权限
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# 将公钥添加到authorized_keys文件
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# 重启SSH服务
echo "正在重新启动 SSH 服务..."
systemctl restart sshd

echo "SSH 配置已完成。root 仅允许基于密钥的登录."
