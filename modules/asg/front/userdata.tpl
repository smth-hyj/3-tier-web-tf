#!/bin/bash
yum -y update
yum -y install httpd
systemctl enable --now httpd
systemctl restart httpd
cat <<EOF>/var/www/html/index.html
<h1> THIS IS WEB SERVER 1 </h1>
EOF