# Cài đặt MongoDB trên 3 node 
## Cài lên các VM
#### Ubuntu

```
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

sudo apt-get update
sudo apt-get install -y mongodb-org

```

#### Redhat
```
cat <<EOF | sudo tee /etc/yum.repos.d/mongodb-org-8.0.repo
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOF

sudo yum install -y mongodb-org
```

## Cấu hình Cluster MongoDB

Bạn có thể thiết lập ip cho file cấu hình MongoDB tuy nhiên nên sử dụng FQDN để thiết lập trong file cấu hình ( có thể sử dụng DNS)

Ở đây chúng ta sử dụng cách đơn giản hơn là thực hiện edit file `/etc/hosts` 

```bash
vi /etc/hosts
10.200.3.61 mongodb-node1  mongodb-node1.csc-jsc.local
10.200.3.62 mongodb-node2  mongodb-node2.csc-jsc.local
10.200.3.63 mongodb-node3  mongodb-node3.csc-jsc.local
```

Chỉnh sửa thông tin nội dung trong file config tại đường dẫn `/etc/mongod.conf`  - Thưcj hiện trên cả 3 node

```bash
net:
  port: 27017
  bindIp: mongodb-node1.csc-jsc.local  # Thay đổi tương ứng cho mongodb-node2, mongodb-node3

replication:
  replSetName: rs0
```

| Cấu hình | Tác dụng chính |
| --- | --- |
| `port: 27017` | Đặt cổng MongoDB sử dụng |
| `bindIp` | Chỉ định địa chỉ MongoDB cho phép lắng nghe kết nối |
| `replSetName` | Bật replica set và đặt tên cụm đồng bộ dữ liệu |

Khởi động lại dịch vụ MogoDB

```bash
sudo systemctl restart mongod
```