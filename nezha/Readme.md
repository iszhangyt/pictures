#### 修改哪吒探针agent版本并禁用更新
```

```
#### 哪吒探针禁用Agent自动更新命令  
```
sed -i '/^ExecStart=/ {/"--disable-auto-update"/! s/$/ "--disable-auto-update"/}' /etc/systemd/system/nezha-agent.service && systemctl daemon-reload
```

