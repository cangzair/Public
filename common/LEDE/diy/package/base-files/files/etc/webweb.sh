#!/bin/bash

[[ ! -f /mnt/network ]] && chmod +x /etc/networkip && source /etc/networkip

cp -Rf /etc/config/network /mnt/network

#sed -i '/mp\/luci-/d' /etc/crontabs/root && echo "0 1 * * 1 rm /tmp/luci-*cache > /dev/null 2>&1" >> /etc/crontabs/root

if [[ `grep -c "x86_64" /etc/openwrt_release` -eq '0' ]]; then
  source /etc/openwrt_release
  sed -i "s/x86_64/${DISTRIB_TARGET}/g" /etc/banner
fi

chmod -R 775 /etc/init.d /usr/share

if [[ -f /etc/init.d/ddnsto ]]; then
 chmod 775 /etc/init.d/ddnsto
 /etc/init.d/ddnsto enable
fi

rm -rf /etc/networkip
rm -rf /etc/webweb.sh
exit 0
