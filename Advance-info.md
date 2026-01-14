## 1. Air‑gapped installation & Repositories (MariaDB)

- FileCloud hỗ trợ triển khai trong môi trường **air-gapped** (không kết nối Internet), bao gồm bản cài đặt offline, repo nội bộ và giấy phép on-premises. Ngoài white paper hướng dẫn chi tiết, bạn có thể thiết lập **filecloudlabs local repository** để cài đặt. [FileCloud+4FileCloud+4FileCloud+4](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)[FileCloud](https://www.filecloud.com/deploy-filecloud-in-an-air-gapped-network/?utm_source=chatgpt.com)
- **MariaDB** bạn cần cài đặt riêng qua các repo MariaDB chính thức do FileCloud không phụ thuộc MySQL nữa. Ví dụ trên Ubuntu 22.04 dùng repo để cài MongoDB và FileCloud từ `filecloudlabs.com`. MariaDB dùng nếu bạn muốn, nhưng FileCloud sử dụng **MongoDB 6+** trực tiếp. [FileCloud](https://www.filecloud.com/supportdocs/fcdoc/latest/server/filecloud-administrator-guide/installing-filecloud-server/installation/direct-installation/installation-of-filecloud-on-linux-using-the-repository?utm_source=chatgpt.com)

---

## 2. Automation (tự động di chuyển file, DLP)

- FileCloud có các module tích hợp cho **DLP, Content Disarm & Reconstruction (CDR)** và **SIEM** để xử lý khi file được upload (đưa vào thư mục đặc thù, phân loại, quét virus, luật DLP…). Bạn cần bật các Integrations tương ứng trong Admin Portal. [FileCloud](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)[FileCloud](https://www.filecloud.com/deploy-filecloud-in-an-air-gapped-network/?utm_source=chatgpt.com)
- Không có tool migration tự động từ Nextcloud; nhưng có thể dùng **seeding tool** hoặc **ServerSync** cho dữ liệu từ SMB/NFS share. [FileCloud](https://www.filecloud.com/blog/2022/04/migrating-storage-between-regions/?utm_source=chatgpt.com)

---

## 3. Migration dữ liệu từ Nextcloud

- Nextcloud lưu dữ liệu dưới dạng DB và folder, nên bạn cần:
    1. Export dữ liệu từ Nextcloud thành folder (qua desktop client hoặc rsync).
    2. Sử dụng `seed.php` để import vào FileCloud (khi storage path và permissions đã chuẩn).
    3. Hoặc dùng ServerSync nếu dữ liệu đang ở dạng SMB/NFS. [Slashdot+15FileCloud+15Reddit+15](https://www.filecloud.com/blog/2022/04/migrating-storage-between-regions/?utm_source=chatgpt.com)[FileCloud+1FileCloud+1](https://www.filecloud.com/supportdocs/fcdoc/latest/server/filecloud-administrator-guide/filecloud-site-maintenance/backing-up-and-restoring-filecloud-server/migrating-filecloud-server-to-another-server?utm_source=chatgpt.com)

---

## 4. Hiệu năng khi có 3 cấp folder, ~5000 folder (mỗi nhánh 5–10 thư mục)

- FileCloud dùng MongoDB để lưu metadata và index file theo từng folder. Việc list thư mục số lượng lớn có thể chậm, phụ thuộc số lượng file, cấu hình indexing (Solr hoặc search) và loại ổ lưu trữ. Không có khảo sát cụ thể nhưng nên thử tải trước. [FileCloud](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)

---

## 5. Chạy trên Kubernetes?

- FileCloud cung cấp bản **Docker** và hỗ trợ chạy microservices (app node, DB riêng...)—vẫn có thể chạy trên **Kubernetes (K8s)**, tương thích với triển khai HA. [FileCloud](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)[FileCloud](https://www.filecloud.com/supportdocs/fcdoc/latest/server/filecloud-administrator-guide/installing-filecloud-server/installation?utm_source=chatgpt.com)

---

## 6. Collaboration (chỉnh sửa chung, comment...)

- FileCloud hỗ trợ collaboration: chia sẻ link, document workflow, tích hợp Office Online (DocConverter), preview, và metadata classification. Cho phép thao tác cùng nhau, theo dõi version, bình luận và chỉnh sửa via web. [FileCloud](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)

---

## 7. Client‑side sync metadata vs file

- FileCloud Sync client đồng bộ **cả file lẫn metadata (permissions, shares, comments)**; client Drive sync chỉ metadata đến khi request file. Không chỉ metadata, cần dữ liệu thực tế vào folder Sync. [FileCloud](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)

---

## 8. Backup database & file data

- FileCloud khuyến nghị backup gồm:
    - **MongoDB dump** (`mongodump`) +
    - **Managed Storage copy hoặc NFS/SMB snapshot**.
    - Khi migrate server cần mongodump + restore, copy file storage. [Facebook+14FileCloud+14FileCloud+14](https://www.filecloud.com/supportdocs/fcdoc/latest/server/filecloud-administrator-guide/filecloud-site-maintenance/backing-up-and-restoring-filecloud-server/migrating-filecloud-server-to-another-server?utm_source=chatgpt.com)

## 9. Branch‑to‑branch, multi‑site offline sync

- FileCloud hỗ trợ module **ServerLink** để đồng bộ giữa site (ví dụ chi nhánh với chi nhánh hoặc về HQ), ngay cả khi Internet không ổn định. Dữ liệu có thể plan sync nội bộ, schedule đồng bộ, có thể offline rồi sync khi có kết nối. [FileCloud](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)

---

## 10. License hết hạn & renew

- License FileCloud đăng ký qua Admin Portal; khi hết license, site sẽ bị giới hạn tính năng. Để renew bạn tải lại file license và cài trong portal. Admin phải nhập lại license mặc định. (Tài liệu không nêu chi tiết độ downtime) [FileCloud](https://www.filecloud.com/supportdocs/fcdoc/latest/server/filecloud-administrator-guide/installing-filecloud-server?utm_source=chatgpt.com)[FileCloud](https://www.filecloud.com/supportdocs/fcdoc/latest/server?utm_source=chatgpt.com)

---

## 11. Multi‑DC, multi‑tenant, nhiều portal, flow người dùng

- FileCloud hỗ trợ **multi-tenancy**: cấu hình nhiều site/site group, mỗi tenant có portal riêng. Với architecture multi‑DC, bạn có thể dùng ServerLink và module chính sách storage để phân phối người dùng. Người dùng đăng nhập từng portal, flow riêng biệt. [FileCloud](https://www.filecloud.com/owncloud-vs-nextcloud-why-filecloud-is-a-better-alternative/?utm_source=chatgpt.com)

---

## 12. PCI‑DSS encryption, certificate, certifile

- FileCloud hỗ trợ **Storage Encryption** với backup key và tích hợp SSL. Bạn có thể bật encryption khi cấu hình Managed Storage. FileCloud yêu cầu **certificate** SSL cài trên web server để mã hóa dữ liệu. Về PCI‑DSS, cần hỏi thêm vì whitepaper có cung cấp integration chi tiết

[install trên win ](https://www.notion.so/install-tr-n-win-2450fa8d6cfb80cfa03be5fa6e63b336?pvs=21)