#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.100.180/g' package/base-files/files/bin/config_generate
sed -i 's/root::0:0:99999:7:::/root:$1$ZzLkZmEb$Kpkpyxaj6bYCEtrs7LqWs.:18612:0:99999:7:::/g' package/base-files/files/etc/shadow
rm -rf feeds/packages/net/smartdns
sed -i "s,'eth1' 'eth0','eth0' 'eth1',g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network
#sed -i '12s/eth0/eth1/g' package/base-files/files/etc/board.d/99-default_network
#sed -i '13s/eth1/eth0/g' package/base-files/files/etc/board.d/99-default_network
#sed -i '13s/eth0 /eth1 /g' package/base-files/files/etc/board.d/99-default_network

#passwall
#添加
sed -i '/CONFIG=passwall/a\ulimit -u unlimited\nulimit -n 1000000' package/openwrt_passwall_luci/luci-app-passwall/root/usr/share/passwall/app.sh
sed -i 's/ulimit -n 65535/#ulimit -n 65535/g' package/openwrt_passwall_luci/luci-app-passwall/root/usr/share/passwall/app.sh

#删除
sed -i '/ulimit -u unlimited/d;/ulimit -n 1000000/d' package/openwrt_passwall_luci/luci-app-passwall/root/usr/share/passwall/app.sh


sed -i '/config_get port "$section" "port" "6053"/a\conf_append "speed-check-mode" "tcp:443"\nconf_append "serve-expired-ttl" "120"' package/smartdns/package/openwrt/files/etc/init.d/smartdns
# 关闭最小ttl
sed -i '/config_get rr_ttl_min "$section" "rr_ttl_min" ""/a\rr_ttl_min=""'package/smartdns/package/openwrt/files/etc/init.d/smartdns

#文件数打开
sed -i '/\$SMARTDNS_CONF \$args/i\procd_set_param limits nofile="1000000 1000000"' package/smartdns/package/openwrt/files/etc/init.d/smartdns

#去除最小ttl
sed -i 's/o.placeholder = "300"/--o.placeholder = "300"/g' package/luci-app-smartdns/luasrc/model/cbi/smartdns/smartdns.lua
sed -i 's/o.default     = 300/--o.default     = 300/g' package/luci-app-smartdns/luasrc/model/cbi/smartdns/smartdns.lua
