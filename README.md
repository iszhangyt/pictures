# 必要更新操作(Debian/Ubuntu)

```
apt update -y
```

```
apt install -y curl socat wget
```

```
sudo apt upgrade
```

**注意：**如果是centos系统，则分别运行yum update -y和yum install -y curl socat wget

# 安装x-ui

```
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
```

或

```
bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/956bf85bbac978d56c0e319c5fac2d6db7df9564/install.sh) 0.3.4.4
```

# 证书申请（开TLS提升安全性必备）

**安装Acme**

```
curl https://get.acme.sh | sh
```

**“你的邮箱”改成你的邮箱地址**

```
~/.acme.sh/acme.sh --register-account -m 你的邮箱
```

**“你的域名”改成你前面解析好的域名**

```
~/.acme.sh/acme.sh --issue -d 你的域名 --standalone
```

# BBR加速

**四合一 BBR Plus / 原版BBR / 魔改BBR一键脚本（Centos 7, Debian 8/9, Ubuntu 16/18 测试通过）**

```
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
```

# 设置nginx反代

**安装ngnix**

```
sudo apt install -y curl gnupg2 ca-certificates lsb-release
```

```
sudo apt install -y nginx
```

**启动niginx服务**

```
sudo systemctl start nginx
```

**niginx运行状态确定**

```
sudo systemctl status nginx
```

**停止niginx服务**

```
sudo systemctl stop nginx
```

**重载niginx服务**

```
sudo systemctl restart nginx
```

**niginx配置文件**

```
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
   server {
   listen 443 ssl;
   listen [::]:443 ssl;

   server_name x-ui.xiui.top;  #你的域名
   ssl_certificate       /root/.acme.sh/x-ui.xiui.top_ecc/x-ui.xiui.top.cer; 
   ssl_certificate_key   /root/.acme.sh/x-ui.xiui.top_ecc/x-ui.xiui.top.key;
   ssl_session_timeout 1d;
   ssl_session_cache shared:MozSSL:10m;
   ssl_session_tickets off;

   ssl_protocols         TLSv1.2 TLSv1.3;
   ssl_ciphers           ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
   ssl_prefer_server_ciphers off;
    
    location / {
        proxy_pass https://www.bing.com; #伪装网址
        proxy_ssl_server_name on;
        proxy_redirect off;
        sub_filter_once off;
        sub_filter "www.bing.com" $server_name;
        proxy_set_header Host "www.bing.com";
        proxy_set_header Referer $http_referer;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header User-Agent $http_user_agent;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header Accept-Encoding "";
        proxy_set_header Accept-Language "zh-CN";
    }
    
    location /86ae09ed {  #自己的路径
       proxy_redirect off;
       proxy_pass http://127.0.0.1:47100; #自己的端口
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "upgrade";
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   }

    location ^~/X-ui/ { #x-ui面板路径
       proxy_pass http://127.0.0.1:10001/X-ui/; #x-ui面板端口
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  
    }
   }

   server {
     listen 80;
     server_name x-ui.xiui.top;    #你的域名
     rewrite ^(.*)$ https://${server_name}$1 permanent;
   }
}

```

