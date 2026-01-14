# cài onlyoffice air graped

## 1.  Tải các gói phụ thuộc cần thiết

- Trên máy có internet thực hiện cấu hình như sau

```bash
curl -fsSL https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE | sudo gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg
# Thêm repo
echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
# Cập nhật
sudo apt-get update
```

- tải các phụ thuộc cần thiết

```bash
 sudo apt-get --downloa
      onlyoffice-documentserver-de     postgresql     redis-server     rabbitmq-server     nginx-extras     libstdc++6     libcurl4     libxml2     fonts-dejavu     fonts-liberation     ttf-mscorefonts-installer     fonts-crosextra-carlito     fonts-takao-gothic     fonts-opensymbol
```

- copy dữ liệu để chuyển vào máy airgarped

```bash
mkdir -p ~/onlyoffice-debs
cp /var/cache/apt/archives/*.deb ~/onlyoffice-debs/
scp -r ~/onlyoffice-debs/* trucnv@10.200.3.27:/home/trucnv/onlyoffice-debs
```

## 2. Cài đặt Postgresql

- chạy các gói cài

```bash
cd /onlyoffice-debs/
sudo dpkg -i libjson-perl_*.deb
sudo dpkg -i ssl-cert_*.deb
sudo dpkg -i libllvm14_*.deb
sudo dpkg -i postgresql-common_*.deb postgresql-14_*.deb
sudo dpkg -i libpq5_*.deb
sudo dpkg -i postgresql-client-common_*.deb
sudo dpkg -i postgresql-client-14_*.deb
sudo dpkg -i postgresql-common_*.deb postgresql-14_*.deb
sudo systemctl enable --now postgresql

```

- Chạy câu lệnh để cấu hình onlyoffice

```bash
sudo -i -u postgres psql -c "CREATE USER onlyoffice WITH PASSWORD 'onlyoffice';"
sudo -i -u postgres psql -c "CREATE DATABASE onlyoffice OWNER onlyoffice;"
```

## 3. Cài Redis

- Cài cặp gcc-base + libatomic trước

```bash
sudo dpkg -i gcc-12-base_*.deb
sudo dpkg -i libatomic1_*.deb
```

- Cài các thư viện phụ trợ khác

```bash
sudo dpkg -i libjemalloc2_*.deb
sudo dpkg -i liblua5.1-0_*.deb
sudo dpkg -i liblzf1_*.deb
sudo dpkg -i lua-bitop_*.deb
sudo dpkg -i lua-cjson_*.deb
```

- Cài redis-tools và redis-server

```bash
sudo dpkg -i redis-tools_*.deb
sudo dpkg -i redis-server_*.deb
```

- Kích hoạt dịch vụ Redis

```bash
sudo systemctl enable --now redis-server
```

## 4. Cài **RabbitMQ**

- Cài các gói phụ thuộc

```bash
#Cốt lõi: erlang-base trước
sudo dpkg -i erlang-base_*.deb

# 1.2) Nhóm lõi không phụ thuộc ftp/snmp
sudo dpkg -i \
  erlang-asn1_*.deb \
  erlang-crypto_*.deb \
  erlang-public-key_*.deb \
  erlang-ssl_*.deb \
  erlang-runtime-tools_*.deb \
  erlang-tools_*.deb \
  erlang-syntax-tools_*.deb \
  erlang-parsetools_*.deb \
  erlang-xmerl_*.deb \
  erlang-eldap_*.deb \
  erlang-mnesia_*.deb

# 1.3) Cho inets: cần ftp/tftp trước
sudo dpkg -i erlang-ftp_*.deb erlang-tftp_*.deb
sudo dpkg -i erlang-inets_*.deb

# 1.4) Cho os-mon: cần snmp trước
sudo dpkg -i erlang-snmp_*.deb
sudo dpkg -i erlang-os-mon_*.deb
```

- **Cài RabbitMQ server (offline)**

```bash
# 2.1) Cài socat (RabbitMQ dùng cho một số tính năng/cluster)
sudo dpkg -i socat_*.deb

# 2.2) Cài RabbitMQ
sudo dpkg -i rabbitmq-server_*.deb

```

## 5. Cài nginx

- Cài gói nền trước (GeoIP + GD dependencies)

```bash
# GeoIP
sudo dpkg -i libgeoip1_*.deb

# Dependencies cho libgd3
sudo dpkg -i libdeflate0_*.deb
sudo dpkg -i libjbig0_*.deb
sudo dpkg -i libjpeg-turbo8_*.deb
sudo dpkg -i libjpeg8_*.deb
sudo dpkg -i libtiff5_*.deb
sudo dpkg -i libwebp7_*.deb
sudo dpkg -i libxpm4_*.deb
```

- Cài đầy đủ **fonts**

```bash
sudo dpkg -i fonts-dejavu-core_*.deb
sudo dpkg -i fonts-liberation_*.deb
sudo dpkg -i fonts-liberation2_*.deb
sudo dpkg -i fonts-croscore_*.deb
sudo dpkg -i fonts-freefont-otf_*.deb
sudo dpkg -i fonts-freefont-ttf_*.deb
sudo dpkg -i fonts-urw-base35_*.deb
sudo dpkg -i fonts-texgyre_*.deb
```

- Cài `fontconfig-config` và `libfontconfig1`

```bash
sudo dpkg -i fontconfig-config_*.deb
sudo dpkg -i libfontconfig1_*.deb
```

- Cài `libgd3` (giờ đã đủ dependency)

```bash
sudo dpkg -i libgd3_*.deb
#neu loi thi chay 
sudo dpkg -i libtiff5_*.deb
#chay lai lenh dau
```

- Cài `nginx-common` và toàn bộ module

```bash
sudo dpkg -i nginx-common_*.deb
sudo dpkg -i libnginx-mod-*.deb
```

- Cài `nginx-extras`

```bash
sudo dpkg -i nginx-extras_*.deb
```

- Enable và kiểm tra Nginx

```bash
sudo systemctl enable --now nginx
```

## 6. Cài OnlyOffice

- Runtime nền

```bash
sudo dpkg -i gcc-12-base_*.deb libgcc-s1_*.deb libstdc++6_*.deb libatomic1_*.deb

```

- **X11 core tối thiểu** (đặt sớm để tránh kẹt libxtst/AT-SPI)

```bash
sudo dpkg -i x11-common_*.deb
sudo dpkg -i libxau6_*.deb libxdmcp6_*.deb libxcb1_*.deb
sudo dpkg -i libx11-data_*.deb libx11-6_*.deb libxext6_*.deb
sudo dpkg -i libxi6_*.deb   # nếu có

```

- Dconf / GSettings / Schemas

```bash
sudo dpkg -i libdconf1_*.deb dconf-service_*.deb dconf-gsettings-backend_*.deb
sudo dpkg -i session-migration_*.deb
sudo dpkg -i gsettings-desktop-schemas_*.deb

```

- GDK-Pixbuf + thư viện ảnh + **icon cache & themes**

```bash
# GDK-Pixbuf
sudo dpkg -i libgdk-pixbuf2.0-common_*.deb
sudo dpkg -i libgdk-pixbuf-2.0-0_*.deb libgdk-pixbuf2.0-bin_*.deb

# Ảnh + GD
sudo dpkg -i libdeflate0_*.deb libjbig0_*.deb libjpeg-turbo8_*.deb libjpeg8_*.deb libtiff5_*.deb libwebp7_*.deb libxpm4_*.deb
sudo dpkg -i libgd3_*.deb

# Icon cache + hicolor
sudo dpkg -i gtk-update-icon-cache_*.deb
sudo dpkg -i hicolor-icon-theme_*.deb

# CÀI 3 THEME TRONG 1 LỆNH (tránh vòng phụ thuộc)
sudo dpkg -i adwaita-icon-theme_*.deb humanity-icon-theme_*.deb ubuntu-mono_*.deb

```

- Fontconfig + tiền đề Cairo/Pango

```bash
# Fontconfig
sudo dpkg -i fontconfig-config_*.deb libfontconfig1_*.deb fontconfig_*.deb

# Thai/HarfBuzz/Graphite & Pixman
sudo dpkg -i libdatrie1_*.deb libthai-data_*.deb libthai0_*.deb
sudo dpkg -i libgraphite2-3_*.deb libharfbuzz0b_*.deb
sudo dpkg -i libpixman-1-0_*.deb

# X11 cho Cairo
sudo dpkg -i libxrender1_*.deb
sudo dpkg -i libxcb-render0_*.deb libxcb-shm0_*.deb

```

- Cairo / Pango

```bash
sudo dpkg -i libcairo2_*.deb libcairo-gobject2_*.deb
sudo dpkg -i libpango-1.0-0_*.deb libpangocairo-1.0-0_*.deb libpangoft2-1.0-0_*.deb

```

- AT-SPI / ATK (cần `libxtst6`, đã có X11 core)

```bash
sudo dpkg -i libxtst6_*.deb
sudo dpkg -i at-spi2-core_*.deb libatspi2.0-0_*.deb
sudo dpkg -i libatk1.0-data_*.deb libatk1.0-0_*.deb libatk-bridge2.0-0_*.deb

```

- Wayland + X11 phụ trợ GTK

```bash
sudo dpkg -i libwayland-client0_*.deb libwayland-cursor0_*.deb libwayland-egl1_*.deb
sudo dpkg -i libxcomposite1_*.deb libxcursor1_*.deb libxdamage1_*.deb libxfixes3_*.deb \
            libxinerama1_*.deb libxkbcommon0_*.deb libxrandr2_*.deb

```

- GTK3 + librsvg (SVG) — **bù phụ thuộc trước rồi cài**

```bash
# Bù phụ thuộc GTK3:
sudo dpkg -i liblcms2-2_*.deb
sudo dpkg -i libavahi-common-data_*.deb libavahi-common3_*.deb libavahi-client3_*.deb   # cho libcups2
sudo dpkg -i libcolord2_*.deb libcups2_*.deb libepoxy0_*.deb

# SVG loader
sudo dpkg -i librsvg2-2_*.deb librsvg2-common_*.deb

# GTK3
sudo dpkg -i libgtk-3-common_*.deb
sudo dpkg -i libgtk-3-0_*.deb libgtk-3-bin_*.deb

```

- Fonts (KHÔNG cài `ttf-mscorefonts-installer` khi offline)

```bash
sudo dpkg -i fonts-dejavu-core_*.deb fonts-dejavu-extra_*.deb fonts-dejavu_*.deb
sudo dpkg -i fonts-liberation_*.deb fonts-crosextra-carlito_*.deb fonts-opensymbol_*.deb
sudo dpkg -i fonts-takao-gothic_*.deb fonts-takao-pgothic_*.deb

```

- X11/GL/Mesa (render headless)

```bash
# 1) X fonts (đúng thứ tự; bù thêm libfontenc1 trước khi cấu hình)
sudo dpkg -i ./xfonts-encodings_*.deb
sudo dpkg -i ./libfontenc1_*.deb
# tạo sẵn thư mục tránh cảnh báo postinst
sudo mkdir -p /usr/share/fonts/X11/misc /var/lib/xfonts
sudo dpkg -i ./xfonts-utils_*.deb
sudo dpkg -i ./xfonts-base_*.deb

# 2) libxcb cho GLX (đủ bộ để GLX cấu hình trơn tru)
sudo dpkg -i ./libxcb-glx0_*.deb ./libxcb-dri2-0_*.deb ./libxcb-dri3-0_*.deb \
             ./libxcb-present0_*.deb ./libxcb-xfixes0_*.deb ./libxcb-randr0_*.deb ./libxcb-sync1_*.deb

# 3) GLVND + Mesa core
sudo dpkg -i ./libglvnd0_*.deb
sudo dpkg -i ./libglapi-mesa_*.deb
# cần libx11-xcb1 trước khi cấu hình libglx-mesa0 (đặt tại đây)
sudo dpkg -i ./libx11-xcb1_*.deb
sudo dpkg -i ./libglx-mesa0_*.deb

# 4) DRM + sensors + LLVM (tiền đề cho mesa-dri)
sudo dpkg -i ./libpciaccess0_*.deb
sudo dpkg -i ./libsensors-config_*.deb ./libsensors5_*.deb
sudo dpkg -i ./libdrm-amdgpu1_*.deb ./libdrm-intel1_*.deb ./libdrm-nouveau2_*.deb ./libdrm-radeon1_*.deb
sudo dpkg -i ./libllvm15_*.deb

# 5) DRI & GL (sau khi DRM/sensors/LLVM đã có)
sudo dpkg -i ./libgl1-mesa-dri_*.deb ./libgl1-amber-dri_*.deb
sudo dpkg -i ./libxshmfence1_*.deb ./libxxf86vm1_*.deb
sudo dpkg -i ./libglx0_*.deb ./libgl1_*.deb

# (tùy chọn) chốt cấu hình
sudo dpkg --configure -a

```

- X headless (cần cho ONLYOFFICE)

```bash
# 1) Phụ thuộc cho x11-xkb-utils (đủ chuỗi libX*)
sudo dpkg -i ./libice6_*.deb ./libsm6_*.deb
sudo dpkg -i ./libxt6_*.deb ./libxmu6_*.deb ./libxaw7_*.deb ./libxkbfile1_*.deb

# 2) xkb utils (bắt buộc trước xserver-common/xvfb)
sudo dpkg -i ./x11-xkb-utils_*.deb

# 3) libxfont2 (bắt buộc cho Xvfb)
sudo dpkg -i ./libxfont2_*.deb

# 4) X server common + Xvfb
sudo dpkg -i ./xserver-common_*.deb
sudo dpkg -i ./xvfb_*.deb
```

- Bù phụ thuộc còn thiếu cho ONLYOFFICE (trước khi cài)

```bash
# Âm thanh & screensaver:
sudo dpkg -i libasound2-data_*.deb libasound2_*.deb
sudo dpkg -i libxss1_*.deb

#Thư viện PQ (nếu chưa cài)
sudo dpkg -i ./libpq5_*.deb

# 2) PostgreSQL client (đúng thứ tự)
sudo dpkg -i ./postgresql-client-common_*.deb
sudo dpkg -i ./postgresql-client-14_*.deb
sudo dpkg -i ./postgresql-client_*.deb

```

- Tạo gói “giả” cho `ttf-mscorefonts-installer` (máy offline)

```bash
mkdir -p /tmp/ttf-dummy/DEBIAN
cat >/tmp/ttf-dummy/DEBIAN/control <<'EOF'
Package: ttf-mscorefonts-installer
Version: 3.8ubuntu2
Section: misc
Priority: optional
Architecture: all
Maintainer: local <local@localhost>
Description: Dummy package providing ttf-mscorefonts-installer (offline)
 This dummy satisfies ONLYOFFICE dependency on ttf-mscorefonts-installer when offline.
EOF
dpkg-deb --build /tmp/ttf-dummy
sudo dpkg -i /tmp/ttf-dummy.deb

```

- Cài ONLYOFFICE Document Server (DE)

```bash
sudo dpkg --configure -a
sudo dpkg -i onlyoffice-documentserver-de_*.deb
sudo dpkg --configure -a

```