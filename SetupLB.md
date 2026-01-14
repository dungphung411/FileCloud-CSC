# cấu hình phía LB
## 1. Cài Nginx

```bash
sudo apt update
sudo apt install nginx -y
```

---

## 2. Tạo file cấu hình mới cho FileCloud

Tạo file tại `/etc/nginx/sites-available/filecloud-lb`

```bash
sudo nano /etc/nginx/sites-available/filecloud-lb
```

Và dán nội dung sau:

```
log_format upstreamlog '$remote_addr - $remote_user [$time_local] '
                      '"$request" $status $body_bytes_sent '
                      '"$http_referer" "$http_user_agent" '
                      'upstream: $upstream_addr '
                      'request_time: $request_time '
                      'upstream_response_time: $upstream_response_time '
                      'host: $host';

upstream filecloud_backend {
    server 10.200.3.64:80;
    server 10.200.3.65:80;
    server 10.200.3.66:80;
}

server {
    listen 80;
    server_name _;

    access_log /var/log/nginx/filecloud_access.log upstreamlog;

    location / {
        proxy_pass http://filecloud_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /nginx_status {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}

```

---

## 3. Kích hoạt site

```bash
sudo ln -s /etc/nginx/sites-available/filecloud-lb /etc/nginx/sites-enabled/

```

Tắt cấu hình default nếu chưa tắt:

```bash
bash
CopyEdit
sudo rm /etc/nginx/sites-enabled/default

```

---

## 4. Kiểm tra & khởi động lại Nginx

```bash
bash
CopyEdit
sudo nginx -t
sudo systemctl reload nginx

```

---

1. Kiểm tra

```bash
bash
CopyEdit
curl http://localhost
tail -f /var/log/nginx/filecloud_access.log

```