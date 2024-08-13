#!/bin/bash

# 检测系统架构
architecture=$(uname -m)

echo "系统架构: $architecture"

# 根据系统架构执行相应的命令
case $architecture in
    x86_64)
        echo "检测到AMD架构，下载并安装nezha-agent..."
        wget https://github.com/nezhahq/agent/releases/download/v0.18.5/nezha-agent_linux_amd64.zip \
        && unzip nezha-agent_linux_amd64.zip \
        && rm nezha-agent_linux_amd64.zip \
        && mv nezha-agent /opt/nezha/agent/nezha-agent \
        && systemctl restart nezha-agent
        ;;
    arm64|aarch64)
        echo "检测到ARM64架构，下载并安装nezha-agent..."
        wget https://github.com/nezhahq/agent/releases/download/v0.18.5/nezha-agent_linux_arm64.zip \
        && unzip nezha-agent_linux_arm64.zip \
        && rm nezha-agent_linux_arm64.zip \
        && mv nezha-agent /opt/nezha/agent/nezha-agent \
        && systemctl restart nezha-agent
        ;;
    *)
        echo "未知或不支持的系统架构: $architecture"
        ;;
esac
