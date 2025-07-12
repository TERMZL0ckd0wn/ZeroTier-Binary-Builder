#!/bin/bash

echo "Downloading zerotier one binary..."
mkdir -p /bin/zerotier-one && cd /bin/zerotier-one
curl -LJ https://github.com/rafalb8/ZeroTierOne-Static/releases/latest/download/zerotier-one-x86_64.tar.gz \
    | tar --strip-components=1 -xzf -

echo "Configuring zerotier one..."
# Binary will be run as a user service, but needs root, so add permission to run sudo without password for zerotier-one
echo "%wheel ALL=(ALL) NOPASSWD: /bin/zerotier-one" | sudo tee /etc/sudoers.d/zerotier 1> /dev/null

mkdir -p /etc/sv/zerotier

cat <<EOF > /etc/sv/zerotier/run
#!/bin/bash
exec 2>&1
exec zerotier-one
EOF

echo "Enabling the zerotier one service..."
ln -s /etc/sv/zerotier /var/service

echo "Zerotier is installed and running!"
echo "binary directory is at /bin"
