apt clean cache
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
rm -rf /etc/apt/sources.list.d/mongodb-org-6.0.list

apt update -y
apt install -y mongodb-org=7.0.24 mongodb-org-database=7.0.24 mongodb-org-server=7.0.24 mongodb-org-mongos=7.0.24 mongodb-org-tools=7.0.24 --allow-downgrades
apt-mark hold mongodb-org mongodb-org-database mongodb-org-server mongodb-org-mongos mongodb-org-tools
curl -fsSL https://repo.filecloudlabs.com/static/pgp/filecloud.asc | sudo gpg -o /usr/share/keyrings/filecloud.gpg --dearmor
echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/filecloud.gpg ] https://repo.filecloudlabs.com/apt/ubuntu jammy/filecloud/23.253 main" | sudo tee /etc/apt/sources.list.d/filecloud.list
apt update -y
apt install -y apache2 pigz
apt install -y php8.4 php8.4-bcmath php8.4-cli php8.4-igbinary php8.4-common php8.4-curl php8.4-gd php8.4-gmp php8.4-imap php8.4-intl php8.4-ldap php8.4-mbstring php8.4-memcache php8.4-memcached php8.4-mongodb php8.4-opcache php8.4-readline php8.4-soap php8.4-xml php8.4-xsl php8.4-zip php8.4-sqlite3 php-json libapache2-mod-security2 
ACCEPT_EULA=Y apt install filecloud -y