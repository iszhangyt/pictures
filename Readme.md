# 在linux服务器配置clash代理

```bash
#下载Linux版Clash.zip
解压
unzip clash.zip
cd clash
# 重命名
mv clash-linux-amd64-v1.10.0 clash
#在这一步需要新建一个proxy.yaml文件在当前文件夹下，并将代理的终端配置文件复制到proxy.yaml中。如果你曾使用过windows的clash，可以点击Profiles，右键edit配置文件，然后就可以复制内容了。
chmod +x ./clash
./clash -f proxy.yaml -d . #使用proxy.yaml启动代理
# 复制clash 到/usr/bin/文件夹(这样在终端任何位置执行 clash 即可启动)
sudo mv clash /usr/bin/

clash 默认会在 ~/.config/clash 目录下生成两个配置文件 config.yaml 和 Country.mmdb
在其他平台获取可用的 config.yaml 配置文件后，可替换原来 ~/.config/clash 目录下的配置文件，也可以在运行clash时，使用 -f 指定配置文件，示例：clash -f config.yaml (运行clash并指定配置文件为./config.yaml)
```

\# 创建clash.service文件，并编辑该文件

```
sudo vim /etc/systemd/system/clash.service
```

\# 粘贴以下内容

```
[Unit]
Description=clash
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/clash -f /root/.config/clash/config.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```
# 依次执行如下命令(reload: 刷新守护进程, enable: 开启自启动, start: 启动, status: 查看状态)
sudo systemctl daemon-reload
sudo systemctl enable clash
sudo systemctl start clash
sudo systemctl status clash
```
