#!/bin/bash

# Cloudflare IP 列表的 URL
CF_IPV4_URL="https://www.cloudflare.com/ips-v4"
CF_IPV6_URL="https://www.cloudflare.com/ips-v6"

# 需要开放给 Cloudflare 的端口 (HTTP 和 HTTPS)
PORTS="80,443"

# 清理旧的 Cloudflare 规则 (可选，但推荐)
# 这可以防止规则列表无限增长。我们通过注释来识别它们。
echo "Deleting old Cloudflare rules..."
ufw status numbered | grep "# Cloudflare" | awk -F"[][]" '{print $2}' | sort -rn | while read -r num ; do
    ufw --force delete "$num"
done

# 添加 IPv4 规则
echo "Fetching Cloudflare IPv4 ranges and adding rules..."
for ip in $(curl -s $CF_IPV4_URL); do
    ufw allow from $ip to any port $PORTS proto tcp comment 'Cloudflare IP'
done

# 添加 IPv6 规则 (如果您的服务器启用了 IPv6)
echo "Fetching Cloudflare IPv6 ranges and adding rules..."
for ip in $(curl -s $CF_IPV6_URL); do
    ufw allow from $ip to any port $PORTS proto tcp comment 'Cloudflare IP'
done

echo "Cloudflare IP rules updated successfully."