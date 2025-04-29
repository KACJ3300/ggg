# 跨境电商TikTok检测脚本
# 脚本功能
检测IP地理位置

检查IP类型（数据中心/住宅）

测试TikTok访问能力

检测DNS泄漏

网络延迟测试

带宽速度测试

IP黑名单检查

# 安装方法
# 安装依赖（Ubuntu/Debian）
sudo apt update && sudo apt install -y curl jq speedtest-cli dnsutils

# 下载脚本
wget https://github.com/KACJ3300/tiktok-test/blob/main/tiktok.sh
chmod +x tiktok.sh

# 使用方法
# 运行脚本
./tiktok_vps_check.sh

# 输出示例：
[2/6] 测试TikTok访问...
HTTP/2 200 
✓ 可以访问TikTok主站
✓ 国际版解锁 (美国)

[5/6] IP黑名单检查...
✓ 低风险IP (评分: 12)
# 关键指标说明
IP类型：优先选择住宅IP（避免被标记为数据中心IP）

地理位置：推荐目标市场对应的国家IP（如美国用US）

Abuse评分：低于25分为安全

下载速度：建议≥50Mbps（视频上传需求）

延迟：建议<200ms

# 注意事项
需要替换AbuseIPDB的API_KEY（免费注册：https://www.abuseipdb.com/）

首次运行可能需要允许speedtest-cli

推荐在纯净系统环境下测试（避免代理干扰）

建议在使用前通过实际账号操作（上传视频、评论互动）进行最终验证。


