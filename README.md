<div align="center">
  <h1 align="center">Marzban <br> Multi Path </br></h1>
</div>

## About

Marzban adalah tools manajemen proxy yang menyediakan antarmuka pengguna yang sederhana dan mudah digunakan untuk mengelola ratusan akun proxy yang didukung oleh Xray-core.

Source : [Marzban](https://github.com/Gozargah/Marzban)

Perbedaan pada repo ini adalah menggunakan nginx agar dapat berjalan multi port atau multi path.

### Requirement

- VPS ( Tested on Ubuntu 20.04 )
- CPU MIN 1 CORE atau diatas
- RAM 1 OR atau diatas
- Punya Domain
- Pointing CloudFlare

### Installation

1. Update VPS
   ```sh
   apt-get update && apt-get upgrade -y && apt dist-upgrade -y && update-grub && reboot
   ```
2. Install Tools

   ```sh
   wget https://raw.githubusercontent.com/fxthur/marzban-nginx/main/marzbanInstall.sh && chmod 755 marzbanInstall.sh && ./marzbanInstall.sh
   ```

3. Done (Open in browser)
   ```js
   http://domain:8000/dashboard
   ```

## Fitur

- Multi Path
- Bisa digunakan untuk SSL dan Non SSL

## Config

Secara default user dan password pada pannel adalah
admin | admin.
jadi silahkan ganti dengan cara

#### Change Admin

```sh
  nano /root/marzban/env
```

####

```sh
  cd /root/marzban
```

#### Restart Docker

```sh
  docker compose down && docker compose up -d
```

## Setting Host

### VMESS_INBOUND

TLS MODE

```sh
Port 443
Address = Domain CF
SNI = Domain CF
Host = Domain CF
Security TLS
```

NTLS MODE

```sh
Port 80
Address = Domain CF
Security None
```

### VLESS_INBOUND

TLS MODE

```sh
Port 443
Address = Domain CF
SNI = Domain CF
Host = Domain CF
Security TLS
```

NTLS MODE

```sh
Port 80
Address = Domain CF
Security None
```

### TROJAN_INBOUND

TLS MODE

```sh
Port 443
Address = Domain CF
SNI = Domain CF
Host = Domain CF
Security TLS
```
