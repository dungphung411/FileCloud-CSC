# Cài đặt File Cloud Server High Availibility
## Điều kiện
### A. Xác định số user & pattern sử dụng

- **Tổng số user**: bao gồm user thường và user có hoạt động sync.
- **Tần suất tương tác**: trung bình một user thực hiện bao nhiêu request mỗi ngày?
- **Ứng dụng sử dụng**: Browser, Drive Sync, Mobile Sync — mỗi loại có đặc thù khác nhau về call/sec


#### * Tính Requests-per-Second (RPS) mỗi user

```
RPS_user = (Inter_per_day × Calls_per_inter) / 86400 + Sync_rate_per_user

```
- **Inter_per_day**: số lần tương tác trung bình mỗi user/ngày
- **Calls_per_inter**: số API call/lần tương tác
- **Sync_rate_per_user**: số request/giây khi sync (ví dụ sync mỗi 30 s → 1/30 ≈ 0.0333; đôi khi có 2.5 devices/user → sync_rate = devices × (1 / sync_interval))

#### * Tính tổng RPS của toàn hệ thống

```
Total_RPS = User_count × RPS_user
```

#### * Tính số Web/App nodes cần thiết

Mỗi node (8 vCPU, 32 GB RAM) có thể xử lý ~125 RPS ([FileCloud Sizing Guide][mongodb.com+11filecloud.com+11reddit.com+11](https://www.filecloud.com/supportdocs/display/cloud/FileCloud%2BSizing%2BGuide?utm_source=chatgpt.com)):

```
Web_nodes = ceil(Total_RPS / 125)
```

### B. Thông tin port mở

| Cổng | Giao thức | Tên/Tư - Diễn | Mục đích | Phạm vi |
|------|-----------|---------------|----------|---------|
| 80   | TCP       | Web Client HTTP (Web app) | HTTP từ External/LAN | External/LAN |
| 443  | TCP       | Web Client HTTPS (LoadBalancer/Web) | HTTPS từ External/LAN | External/LAN |
| 389  | LDAP/TCP  | LDAP (AD) - LoadBalancer/Web (AD) | LDAP từ External/LAN | External/LAN |
| 636  | TCP       | Web App - LDAP (SSL/TLS) | LDAP SSL/TLS từ Internal | Internal |
| 27017| TCP/DB    | MongoDB - Web App | MongoDB Internal | Internal |
| 11211| TCP (UDP) | Web App - Memcached | Cache & NTFS cache (HA) | Internal |
| 8089 | TCP       | Web App - Solr | Tìm kiếm nội dung | Internal |
| 3389 | TCP       | Admin -> Server (SSH) | Quản trị từ Internal/External | Internal/External |
| 445  | TCP       | Windows -> FileCloud Server | Chia sẻ file Windows | Internal/External |

### C. Yêu cầu
- Cấu hình cụm MongoDB 3 node (Storage)
- Cấu hình Memcache - Solr 
- Cấu hình App File Cloud 

