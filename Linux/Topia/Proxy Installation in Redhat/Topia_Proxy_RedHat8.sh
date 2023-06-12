#!/bin/sh

#PROXY_USER=admin
#PROXY_PASS=Passw0rd
#PROXY_PORT=3128

# Clear the repository index caches
yum clean all

# Update the operating system
yum update -y

# Install httpd-tools to get htpasswd
yum install httpd-tools -y

# Create the htpasswd file
#htpasswd -c -b /etc/squid/passwords $PROXY_USER $PROXY_PASS

# Install squid
yum install squid -y

# Backup the original squid config
cp /etc/squid/squid.conf /etc/squid/squid.conf.bak

# Create a SSL_DB search for ssl_crtd in case of error.... 
openssl req -new -newkey rsa:2048 -days 5000 -nodes -x509 -keyout /etc/squid/selfCA.pem -out /etc/squid/selfCA.pem -subj "/C=US"
mkdir -p /var/spool/
/usr/lib64/squid/security_file_certgen -c -s /var/spool/squid3_ssldb -M 100MB
chown -R squid:squid /var/spool/squid3_ssldb

# Set up the squid config
cat << EOF > /etc/squid/squid.conf
acl dontbump ssl::server_name_regex ^.+\.vicarius\.cloud$
acl step1 at_step SslBump1
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
http_access allow all
http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=100MB cert=/etc/squid/selfCA.pem
sslcrtd_program /usr/lib64/squid/security_file_certgen -s /var/spool/squid3_ssldb -M 100MB
sslcrtd_children 5
ssl_bump peek step1
ssl_bump splice dontbump
ssl_bump bump !dontbump all
minimum_object_size 1 MB
maximum_object_size 2 GB
cache_dir ufs /var/spool/squid 5024 16 256
coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .               1440    50%     4320
minimum_expiry_time 3600 seconds
collapsed_forwarding on
max_filedescriptors 65536
EOF

# Set squid to start on boot
systemctl enable squid.service

# Start squid
systemctl start squid.service

# Allow squid access from anywhere

#firewall-cmd --zone=public --add-port=$PROXY_PORT/tcp --permanent

# Reload rules
#firewall-cmd --reload

#list all files in cache squid
#find /var/spool/squid -type f | xargs -i{} head -1 {} | grep -oa "http.*"