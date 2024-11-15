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

# 函数来更新配置文件
update_ssh_config() {
    local file="$1"
    sed -i "s/^#*PasswordAuthentication .*/PasswordAuthentication no/" "$file"
    sed -i "s/^#*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/" "$file"
    sed -i "s/^#*UsePAM .*/UsePAM no/" "$file"
    sed -i "s/^#*PermitRootLogin .*/PermitRootLogin prohibit-password/" "$file"
    sed -i "s/^#*PubkeyAuthentication .*/PubkeyAuthentication yes/" "$file"
}

# 更新主配置文件
update_ssh_config "/etc/ssh/sshd_config"

# 获取主配置文件所在目录
BASE_DIR=$(dirname "/etc/ssh/sshd_config")

# 从主配置文件中查找包含的配置文件
INCLUDE_FILES=$(grep -E "^Include" /etc/ssh/sshd_config | awk '{print $2}')

# 更新所有包含的配置文件
for pattern in $INCLUDE_FILES; do
    # 转换相对路径为绝对路径
    if [[ "$pattern" != /* ]]; then
        pattern="$BASE_DIR/$pattern"
    fi
    for conf_file in $pattern; do
        if [ -f "$conf_file" ]; then
            update_ssh_config "$conf_file"
        fi
    done
done

# 创建~/.ssh目录并设置权限
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# 检查并添加公钥到authorized_keys文件
AUTHORIZED_KEYS="/root/.ssh/authorized_keys"
if ! grep -Fxq "$PUBLIC_KEY" "$AUTHORIZED_KEYS"; then
    echo "$PUBLIC_KEY" >> "$AUTHORIZED_KEYS"
    chmod 600 "$AUTHORIZED_KEYS"
    echo "公钥已添加到 authorized_keys 文件。"
else
    echo "公钥已存在于 authorized_keys 文件中。"
fi

# 重启SSH服务
echo "正在重新启动 SSH 服务..."
systemctl restart sshd

echo "SSH 配置已完成。root 仅允许基于密钥的登录."
