#!/bin/bash

# 定义下载脚本的URL
SCRIPT_URL="https://raw.githubusercontent.com/iszhangyt/pictures/main/nezha/gai.sh"

# 定义下载后保存的文件路径为当前路径
SCRIPT_FILE="./gai.sh"

# 下载脚本
echo "下载$@版本agent"
curl -o "$SCRIPT_FILE" "$SCRIPT_URL"

# 为下载的脚本添加可执行权限
chmod +x "$SCRIPT_FILE"

# 执行下载的脚本
echo "替换agent版本为：$@"
"$SCRIPT_FILE" "$@"

# 执行sed命令来修改nezha-agent.service文件
echo "修改nezha-agent.service文件,关闭自动更新"
sed -i '/^ExecStart=/ {
  /--disable-auto-update/! s/$/ --disable-auto-update/
  /--disable-force-update/! s/$/ --disable-force-update/
  /--disable-command-execute/! s/$/ --disable-command-execute/
  s/"--disable-auto-update"/--disable-auto-update/
  s/"--disable-force-update"/--disable-force-update/
  s/"--disable-command-execute"/--disable-command-execute/
}' /etc/systemd/system/nezha-agent.service
# 重新加载 systemd 守护进程
echo "重新加载 systemd 守护进程"
sudo systemctl daemon-reload

# 重启agent
echo "重启agent"
sudo systemctl restart nezha-agent

# 删除下载的脚本
rm -f "$SCRIPT_FILE"
