#!/bin/bash -ex
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

git config --global user.email "temp@example.com"
git config --global user.name "temp"

CODE_BASE_PATH=$(pwd)

cd ${CODE_BASE_PATH}

./scripts/feeds update -a
# add some ext packages
rm -rf package/luci-app-tcpdump || true
git clone https://github.com/KFERMercer/luci-app-tcpdump.git ./package/luci-app-tcpdump
pushd package/lean
rm -rf luci-theme-argon || true
#git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git
git clone https://github.com/virualv/luci-theme-pink.git
popd

sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
