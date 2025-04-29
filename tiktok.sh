
#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # 恢复默认

# 检测函数
check_ip_info() {
  echo -e "\n${YELLOW}[1/6] 检测IP信息...${NC}"
  ip_info=$(curl -sS https://ipinfo.io/json)
  echo "$ip_info" | jq .

  country=$(echo "$ip_info" | jq -r '.country')
  is_datacenter=$(echo "$ip_info" | jq -r '.org' | grep -i 'hosting\|datacenter\|cloud')
}

check_tiktok() {
  echo -e "\n${YELLOW}[2/6] 测试TikTok访问...${NC}"
  tiktok_status=$(curl -sSIL https://www.tiktok.com | grep "HTTP/")
  if [[ $tiktok_status == *"200"* ]]; then
    echo -e "${GREEN}✓ 可以访问TikTok主站${NC}"
  else
    echo -e "${RED}✗ 无法访问TikTok主站${NC}"
  fi

  # 检测地区解锁状态
  region_check=$(curl -sS https://www.tiktok.com/ | grep -E 'content="(https://www\.tiktok\.com/)"')
  if [[ $region_check == *"en/"* ]]; then
    echo -e "${GREEN}✓ 国际版解锁 (美国)${NC}"
  else
    echo -e "${YELLOW}⚠ 检测到地区限制${NC}"
  fi
}

check_dns() {
  echo -e "\n${YELLOW}[3/6] 检测DNS泄漏...${NC}"
  dns_servers=$(nslookup www.tiktok.com | grep "Server:" | awk '{print $2}')
  echo "当前DNS服务器：$dns_servers"

  if [[ $dns_servers == *"cloudflare"* ]] || [[ $dns_servers == *"google"* ]]; then
    echo -e "${GREEN}✓ 安全DNS配置${NC}"
  else
    echo -e "${YELLOW}⚠ 建议使用Cloudflare或Google DNS${NC}"
  fi
}

check_speed() {
  echo -e "\n${YELLOW}[4/6] 带宽测试...${NC}"
  speedtest-cli --simple
}

check_blacklist() {
  echo -e "\n${YELLOW}[5/6] IP黑名单检查...${NC}"
  ip=$(hostname -I | awk '{print $1}')
  check=$(curl -sS "https://api.abuseipdb.com/api/v2/check?ipAddress=$ip" \
    -H "Key: YOUR_API_KEY" \
    -H "Accept: application/json")

  abuse_score=$(echo "$check" | jq '.data.abuseConfidenceScore')
  if (( $(echo "$abuse_score > 25" | bc -l) )); then
    echo -e "${RED}✗ 高风险IP (评分: $abuse_score)${NC}"
  else
    echo -e "${GREEN}✓ 低风险IP (评分: $abuse_score)${NC}"
  fi
}

check_latency() {
  echo -e "\n${YELLOW}[6/6] 延迟测试...${NC}"
  ping -c 4 www.tiktok.com | grep "rtt"
}

# 主程序
main() {
  check_ip_info
  check_tiktok
  check_dns
  check_speed
  check_blacklist
  check_latency

  # 最终建议
  echo -e "\n${YELLOW}=== 最终建议 ===${NC}"
  [[ -n $is_datacenter ]] && echo -e "${RED}✗ 检测到数据中心IP${NC}" || echo -e "${GREEN}✓ 住宅IP检测通过${NC}"
  [[ $country != "US" ]] && echo -e "${YELLOW}⚠ 建议使用美国IP (当前: $country)${NC}"
}

main