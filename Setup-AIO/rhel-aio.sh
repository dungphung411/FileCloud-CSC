yum clean all
dnf module disable httpd -y
dnf module disable php -y

rm -rf /etc/yum.repos.d/filecloud*

cat <<EOF > /etc/yum.repos.d/filecloud-23.253.repo
[filecloud-23.253]
name=FileCloud 23.253
baseurl=https://repo.filecloudlabs.com/yum/redhat/$releasever/filecloud/23.253/x86_64/
gpgcheck=1
priority=1
enabled=1
gpgkey=https://repo.filecloudlabs.com/static/pgp/filecloud.asc
module_hotfixes=true
EOF

cat <<EOF > /etc/yum.repos.d/mongodb-org-7.0.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF

yum update -y --allowerasing
yum install yum-utils -y
yum-config-manager --enable mongodb-org-7.0
yum-config-manager --enable filecloud-23.253
yum install mongodb-org-7.0.24 mongodb-org-database-7.0.24 mongodb-org-server-7.0.24 mongodb-org-mongos-7.0.24 mongodb-org-tools-7.0.24 -y
ACCEPT_EULA=Y dnf install filecloud -y