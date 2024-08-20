#### 修改哪吒探针agent版本为v0.18.5并禁用更新
```
curl -sSL https://raw.githubusercontent.com/iszhangyt/pictures/main/nezha/gaiagent.sh | sudo bash -s -- v0.18.5
```
#### 哪吒探针禁用Agent自动更新命令  
```
sed -i '/^ExecStart=/ {
  /--disable-auto-update/! s/$/ --disable-auto-update/
  /--disable-force-update/! s/$/ --disable-force-update/
  s/"--disable-auto-update"/--disable-auto-update/
  s/"--disable-force-update"/--disable-force-update/
}' /etc/systemd/system/nezha-agent.service && systemctl daemon-reload
```
#### 服务器使用密钥登录
```
curl -sSL https://raw.githubusercontent.com/iszhangyt/pictures/main/nezha/ssh.sh | sudo bash -s -- '公钥'
```
