#!/bin/bash
#========================================================================================================================
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
# edited by robbyaprianto
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-neobird）
sed -i 's/luci-theme-bootstrap/luci-theme-neobird/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
sed -i 's/192.168.1.1/12.12.12.1/g' package/base-files/files/bin/config_generate

# change ssid
sed -i "s/OpenWrt/CupangOs/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh

# change hostname
sed -i "s/OpenWrt/CupangOs/g" package/base-files/files/bin/config_generate

# change timezone
sed -i "s/UTC/WIB-7/g" package/base-files/files/bin/config_generate

# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
sed -i 's/root::0:0:99999:7:::/root:$1$wOheR5zg$7LWQZUwOPIkCB8M9WoTfo1:0:0:99999:7:::/g' /etc/shadow
popd

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
#sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# change password to root = $1$VwIN8jaz$Kj/MUD3dMwJrxEPdCJrEq.
sed -i 's/root::0:0:99999:7:::/root:$1$VwIN8jaz$Kj/MUD3dMwJrxEPdCJrEq.:0:0:99999:7:::/g' /etc/shadow


# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
#helmi-package
svn co https://github.com/helmiau/helmiwrt-packages/trunk/luci-app-netmon package/luci-app-netmon
svn co https://github.com/helmiau/helmiwrt-packages/trunk/luci-app-tinyfm package/luci-app-tinyfm
svn co https://github.com/helmiau/helmiwrt-packages/trunk/corkscrew package/corkscrew
svn co https://github.com/helmiau/helmiwrt-packages/trunk/badvpn package/badvpn

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add luci-app-openclash
#git clone https://github.com/vernesong/OpenClash package/lean/luci-app-openclash
svn co https://github.com/thecupangin/cupangOs-packages/trunk/luci-app-openclash package/luci-app-openclash

# rooter system
git clone https://github.com/ofmodemsandmen/RooterSource source

#add tema
git clone --dept 1 https://github.com/thinktip/luci-theme-neobird.git package/luci-theme-neobird
svn co https://github.com/lynxnexy/lynx/trunk/luci-theme-netgear package/luci-theme-netgear
#git clone https://github.com/kenzok8/small-package package/small-package
# Add luci-theme-argon-armygreen
git clone https://github.com/thecupangin/luci-theme-argon_armygreen package/lean/luci-theme-argon_armygreen
# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../lean/luci-theme-argon
# Add luci-app-diskman
git clone --depth=1 https://github.com/SuLingGG/luci-app-diskman
mkdir parted
cp luci-app-diskman/Parted.Makefile parted/Makefile

#
# ------------------------------- Other ends -------------------------------