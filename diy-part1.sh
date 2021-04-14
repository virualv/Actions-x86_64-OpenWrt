#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# config openclash
mkdir package/luci-app-openclash
pushd package/luci-app-openclash
git init
git remote add -f origin https://github.com/vernesong/OpenClash.git
git config core.sparsecheckout true
echo "luci-app-openclash" >> .git/info/sparse-checkout
git pull origin master
git branch --set-upstream-to=origin/master master
pushd luci-app-openclash/tools/po2lmo
make && sudo -E make install
popd
popd
# config openclash end

# config smartdns
SMARTDNS_WORKING_DIR="`pwd`/feeds/packages/net/smartdns"
mkdir $SMARTDNS_WORKING_DIR -p
rm $SMARTDNS_WORKING_DIR/* -fr
wget https://github.com/pymumu/openwrt-smartdns/archive/master.zip -O $SMARTDNS_WORKING_DIR/master.zip
unzip $SMARTDNS_WORKING_DIR/master.zip -d $SMARTDNS_WORKING_DIR
mv $SMARTDNS_WORKING_DIR/openwrt-smartdns-master/* $SMARTDNS_WORKING_DIR/
rmdir $SMARTDNS_WORKING_DIR/openwrt-smartdns-master
rm $SMARTDNS_WORKING_DIR/master.zip
unset SMARTDNS_WORKING_DIR

SMARTDNS_LUCIBRANCH="lede" #更换此变量
SMARTDNS_LUCI_WORKING_DIR="`pwd`/feeds/luci/applications/luci-app-smartdns"
mkdir $SMARTDNS_LUCI_WORKING_DIR -p
rm $SMARTDNS_LUCI_WORKING_DIR/* -fr
wget https://github.com/pymumu/luci-app-smartdns/archive/${SMARTDNS_LUCIBRANCH}.zip -O $SMARTDNS_LUCI_WORKING_DIR/${SMARTDNS_LUCIBRANCH}.zip
unzip $SMARTDNS_LUCI_WORKING_DIR/${SMARTDNS_LUCIBRANCH}.zip -d $SMARTDNS_LUCI_WORKING_DIR
mv $SMARTDNS_LUCI_WORKING_DIR/luci-app-smartdns-${SMARTDNS_LUCIBRANCH}/* $SMARTDNS_LUCI_WORKING_DIR/
rmdir $SMARTDNS_LUCI_WORKING_DIR/luci-app-smartdns-${SMARTDNS_LUCIBRANCH}
rm $SMARTDNS_LUCI_WORKING_DIR/${SMARTDNS_LUCIBRANCH}.zip
unset SMARTDNS_LUCIBRANCH
unset SMARTDNS_LUCI_WORKING_DIR
# config smartdns end

#
pushd package/lean
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git
git clone https://github.com/virualv/luci-theme-pink.git
popd

# Add a feed source
sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
sed -i '$a src-git jerryk https://github.com/jerrykuku/openwrt-package' feeds.conf.default
sed -i '$a src-git passwall https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default


./scripts/feeds clean
