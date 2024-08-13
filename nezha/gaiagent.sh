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
enco "修改nezha-agent.service文件,关闭自动更新"
sed -i '/^ExecStart=/ {
  /--disable-auto-update/! s/$/ --disable-auto-update/
  /--disable-force-update/! s/$/ --disable-force-update/
}' /etc/systemd/system/nezha-agent.service
# 重新加载 systemd 守护进程
enco "重新加载 systemd 守护进程"
systemctl daemon-reload

# 删除下载的脚本
rm -f "$SCRIPT_FILE"
