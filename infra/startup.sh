#!/bin/bash
set -euxo pipefail

exec > /tmp/startup.log 2>&1

echo "[*] Startup script started at $(date)"

# Czekaj aż /dev/sdh się pojawi
echo "[*] Waiting for /dev/sdh..."
while [ ! -b /dev/sdh ]; do
  echo "  - /dev/sdh not found, waiting..."
  sleep 5
done
echo "[+] /dev/sdh found."

# Sprawdź czy partycja istnieje
if ! lsblk /dev/sdh1; then
  echo "[*] Creating partition on /dev/sdh..."
  echo 'start=2048, type=83' | sfdisk /dev/sdh
  partprobe
  sleep 2
  mkfs.ext4 /dev/sdh1
fi

mkdir -p /mnt/data
mount /dev/sdh1 /mnt/data
echo "/dev/sdh1 /mnt/data ext4 defaults 0 0" >> /etc/fstab

chmod -R 777 /mnt/data

# Instalacja Docker i EC2 Instance Connect
yum update -y
yum install -y docker ec2-instance-connect

systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user

# Kontener DBT
docker pull siudzinskim/vscode-dbt
docker run -d  -p 8888:8443 -p 8080:8080 -v /mnt/data/vscode:/config --name vs siudzinskim/vscode-dbt
(crontab -l ; echo "@reboot /usr/bin/docker start vs") | crontab -

echo "[+] Script completed at $(date)"

