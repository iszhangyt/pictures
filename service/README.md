## 在linux服务器配置mihomo
下载二进制可执行文件 releases,解压
```
tar -zxvf filename.tar.gz
或
gunzip filename.gz
```
**将下载的二进制可执行文件重名名为 mihomo 并移动到 /usr/local/bin/**
重命名
```
mv 文件名 mihomo
```
赋予可执行权限
```
chmod +x ./mihomo
```
**以守护进程的方式，运行 mihomo**

使用以下命令将 Clash 二进制文件复制到 /usr/local/bin, 配置文件复制到 /etc/mihomo:
```
mv mihomo /usr/local/bin
mkdir /etc/mihomo
wget https://raw.githubusercontent.com/iszhangyt/pictures/clash/%E6%9C%8D%E5%8A%A1%E5%99%A8/config.yaml
mv config.yaml /etc/mihomo
```

创建 systemd 配置文件 
```
vim /etc/systemd/system/mihomo.service
```
```
[Unit]
Description=mihomo Daemon, Another Clash Kernel.
After=network.target NetworkManager.service systemd-networkd.service iwd.service

[Service]
Type=simple
LimitNPROC=500
LimitNOFILE=1000000
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH CAP_DAC_OVERRIDE
Restart=always
ExecStartPre=/usr/bin/sleep 1s
ExecStart=/usr/local/bin/mihomo -d /etc/mihomo
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
```

使用以下命令重新加载 systemd:
```
systemctl daemon-reload
```
启用 mihomo 开机自启服务：
```
systemctl enable mihomo
```
使用以下命令立即启动 mihomo:
```
systemctl start mihomo
```
使用以下命令使 mihomo 重新加载：
```
systemctl reload mihomo
```
使用以下命令停止 mihomo：
```
systemctl stop mihomo
```
使用以下命令检查 mihomo 的运行状况：
```
systemctl status mihomo
```
使用以下命令检查 mihomo 的运行日志：
```
journalctl -u mihomo -o cat -e
```
或
```
journalctl -u mihomo -o cat -f
```
