#!/bin/bash
#========================================================================================================================
# https://github.com/thecupangin/oWRT
# Description: Automatically Build OpenWrt for Amlogic S9xxx STB
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
# edited by zapriant
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-tano）
sed -i 's/luci-theme-bootstrap/luci-theme-tano/g' feeds/luci/collections/luci/Makefile

# change password to "root"
sed -i "s/root::0:0:99999:7:::/root:$1$Px5lfQdL$suWhpQngCSnh9DlbQsC0N/:18936:0:99999:7:::/g" package/base-files/files/etc/shadow

# change ssid
sed -i "s/OpenWrt/CupangOs/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# change hostname
sed -i "s/ImmortalWrt/CupangOs/g" package/base-files/files/bin/config_generate

# change banner
rm -rf ./package/emortal/default-settings/files/openwrt_banner
svn export https://github.com/thecupangin/cupang/trunk/amlogic-s9xxx/common-files/files/etc/banner package/emortal/default-settings/files/openwrt_banner

# change timezone
sed -i -e "s/CST-8/WIB-7/g" -e "s/Shanghai/Jakarta/g" package/emortal/default-settings/files/99-default-settings-chinese

# change shell
sed -i "s/\/bin\/ash/\/usr\/bin\/zsh/g" package/base-files/files/etc/passwd

# translate luci-app-wrtbwmon
# sed -i -e "s/客户端/Host/g" -e "s/下载带宽/DL Speed/g" -e "s/上传带宽/UL Speed/g" -e "s/总下载流量/Download/g" -e "s/总上传流量/Upload/g" -e "s/流量合计/Total/g" -e "s/首次上线时间/First Seen/g" -e "s/最后上线时间/Last Seen/g" -e "s/总计/TOTAL/g" -e "s/数据更新时间/Last updated/g" -e "s/倒数/Updating again in/g" -e "s/秒后刷新./seconds./g" feeds/luci/applications/luci-app-wrtbwmon/htdocs/luci-static/wrtbwmon.js

# fix luci-app-nlbwmon
# sed -i "s|services/||g" feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='cupangOs'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
#sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Set hostname to HelmiWrt
#uci set system.@system[0].hostname='oWRT'

# Set Timezone to Asia/Jakarta
#uci set system.@system[0].timezone='WIB-7'
#uci set system.@system[0].zonename='Asia/Jakarta'
#uci commit system

# Set default wifi name to oWRT
sed -i "s#option ssid 'OpenWrt'#option ssid 'CupangOs-LEDE'#iIg" /etc/config/wireless

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add luci-app-openclash
# git clone https://github.com/vernesong/OpenClash package/lean/luci-app-openclash
#mkdir -p files/etc/openclash/core

#open_clash_premium_url=$(curl -sL https://api.github.com/repos/Dreamacro/clash/releases/tags/premium | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')
#open_clash_main_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')
## offical_clash_main_url=$(curl -sL https://api.github.com/repos/Dreamacro/clash/releases/tags/v1.3.5 | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')
#clash_tun_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')
#clash_game_url=$(curl -sL https://api.github.com/repos/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-$1 | sed 's/.*url\": \"//g' | sed 's/\"//g')

#wget --show-progress -qO- $open_clash_premium_url | gunzip -c > files/etc/openclash/core/clash
#wget --show-progress -qO- $open_clash_main_url | tar xOvz > files/etc/openclash/core/clash_original
## wget --show-progress -qO- $offical_clash_main_url | gunzip -c > files/etc/openclash/core/clash
#wget --show-progress -qO- $clash_tun_url | gunzip -c > files/etc/openclash/core/clash_tun
#wget --show-progress -qO- $clash_game_url | tar xOvz > files/etc/openclash/core/clash_game

#chmod +x files/etc/openclash/core/clash*

# Offline images sources
#mkdir -p files/www/luci-static/resources/openclash
#wget --show-progress -qO files/www/luci-static/resources/openclash/Tutorials.svg https://img.shields.io/badge/Tutorials--lightgrey?logo=Wikipedia&style=social
#wget --show-progress -qO files/www/luci-static/resources/openclash/Star.svg https://img.shields.io/badge/Star--lightgrey?logo=github&style=social
#wget --show-progress -qO files/www/luci-static/resources/openclash/Telegram.svg https://img.shields.io/badge/Telegram--lightgrey?logo=Telegram&style=social
#wget --show-progress -qO files/www/luci-static/resources/openclash/Sponsor.svg https://img.shields.io/badge/Sponsor--lightgrey?logo=ko-fi&style=social


# Add luci-theme-argon-armygreen
git clone https://github.com/thecupangin/luci-theme-argon_armygreen package/lean/luci-theme-argon_armygreen
# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../lean/luci-theme-argon
# Add luci-app-tinyfm
git clone https://github.com/helmiau/helmiwrt-packages/luci-app-tinyfm package/luci-app-tinyfm
# Add luci-app-openspeedtest
git clone https://github.com/helmiau/helmiwrt-packages/luci-app-openspeedtest package/luci-app-openspeedtest
# Add luci-app-diskman
git clone --depth=1 https://github.com/SuLingGG/luci-app-diskman
mkdir parted
cp luci-app-diskman/Parted.Makefile parted/Makefile
# Add p7zip
# svn co https://github.com/hubutui/p7zip-lede/trunk package/p7zip

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------