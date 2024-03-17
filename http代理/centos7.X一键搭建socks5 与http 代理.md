## centos7.X一键搭建socks5 与http 代理

* * *

各种代理是很常用的，那么如何可以在服务器快速搭建自己的socks5代理与http代理呢。

* * *

### 1.一键搭建命令

代码如下：

```auto
sudo wget https://ap-guangzhou-1257892306.cos.ap-guangzhou.myqcloud.com/asi/httpsocks5.sh && sh httpsocks5.sh
```

安装好后默认是

sosks5 端口为59395 帐号为 asi 密码为 asihacker

http代理端口为 59394

下面把shell脚本代码贴出来～～～

需要修改帐号密码的可以自己修改一下～  
可能的坑  
1.centos 8 可能不行～～～  
2.安全组 防火墙 注意检查～～～

```shell
#!/bin/bash
install_http() {
  yum install -y squid #安装http代理
  cat <<EOF >/etc/squid/squid.conf
#
# Recommended minimum configuration:
#
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1

# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing
# should be allowed
acl localnet src 10.0.0.0/8	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT

#
# Recommended minimum Access Permission configuration:
#
# Only allow cachemgr access from localhost
http_access allow manager localhost
http_access deny manager

# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost

#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
#http_access allow localhost

# And finally deny all other access to this proxy
#http_access deny all
http_access allow all

# Squid normally listens to port 3128
#http_port 3128
http_port 59394
via off
forwarded_for delete

# We recommend you to use at least the following line.
hierarchy_stoplist cgi-bin ?

# Uncomment and adjust the following to add a disk cache directory.
#cache_dir ufs /var/spool/squid 100 16 256

# Leave coredumps in the first cache dir
coredump_dir /var/spool/squid

# Add any of your own refresh_pattern entries above these.
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320
EOF
  systemctl start squid          #开启squid
  systemctl restart squid          #开启squid
  systemctl enable squid.service #设置开机自动启动
}
install_socks5() {
  wget --no-check-certificate https://raw.github.com/Lozy/danted/master/install.sh -O install_proxy.sh
  bash install_proxy.sh --port=59395 --user=asi --passwd=asihacker
}
install_http
install_socks5

```

* * *

## 总结

麻烦来个一键三连！！！！！