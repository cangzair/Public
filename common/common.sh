#!/bin/bash
# https://github.com/281677160/AutoBuild-OpenWrt
# common Module by 28677160
# matrix.target=${Modelfile}

TIME() {
Compte=$(date +%Y年%m月%d号%H时%M分)
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31m";;
	g) export Color="\e[32m";;
	b) export Color="\e[34m";;
	y) export Color="\e[33m";;
	z) export Color="\e[35m";;
	l) export Color="\e[36m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}

################################################################################################################
# LEDE源码通用diy.sh文件
################################################################################################################
Diy_lede() {

find . -name 'luci-app-netdata' -o -name 'netdata' -o -name 'luci-theme-argon' -o -name 'mentohust' | xargs -i rm -rf {}
find . -name 'luci-app-ipsec-vpnd' -o -name 'luci-app-wol' | xargs -i rm -rf {}
find . -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' | xargs -i rm -rf {}
find . -name 'UnblockNeteaseMusic-Go' -o -name 'UnblockNeteaseMusic' -o -name 'luci-app-unblockmusic' | xargs -i rm -rf {}

}


################################################################################################################
# LIENOL源码通用diy.sh文件
################################################################################################################
Diy_lienol() {

find . -name 'luci-app-netdata' -o -name 'netdata' -o -name 'luci-app-ttyd' | xargs -i rm -rf {}
find . -name 'ddns-scripts_aliyun' -o -name 'ddns-scripts_dnspod' -o -name 'luci-app-wol' | xargs -i rm -rf {}
find . -name 'UnblockNeteaseMusic-Go' -o -name 'UnblockNeteaseMusic' -o -name 'luci-app-unblockmusic' | xargs -i rm -rf {}

}


################################################################################################################
# 天灵源码18.06 diy.sh文件
################################################################################################################
Diy_Tianling() {

find . -name 'luci-app-argon-config' -o -name 'luci-theme-argon' -o -name 'luci-theme-argonv3' -o -name 'luci-theme-netgear' | xargs -i rm -rf {}
find . -name 'luci-app-netdata' -o -name 'netdata' -o -name 'luci-app-cifs' | xargs -i rm -rf {}
find . -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' -o -name 'luci-app-wol' | xargs -i rm -rf {}
find . -name 'luci-app-adguardhome' -o -name 'adguardhome' -o -name 'luci-theme-opentomato' | xargs -i rm -rf {}

}


################################################################################################################
# 天灵源码21.02 diy.sh文件
################################################################################################################
Diy_mortal() {

find . -name 'luci-app-netdata' -o -name 'netdata' -o -name 'luci-app-cifs' | xargs -i rm -rf {}
find . -name 'luci-app-wol' -o -name 'luci-app-argon-config' | xargs -i rm -rf {}
find . -name 'luci-app-adguardhome' -o -name 'adguardhome' | xargs -i rm -rf {}
rm -rf feeds/luci/themes

}


################################################################################################################
# 全部作者源码公共diy.sh文件
################################################################################################################
Diy_all() {

#if [[ ${REGULAR_UPDATE} == "true" ]]; then
#	git clone https://github.com/281677160/luci-app-autoupdate feeds/luci/applications/luci-app-autoupdate
#	[[ -f "${PATH1}/AutoUpdate.sh" ]] && cp -Rf "${PATH1}"/AutoUpdate.sh package/base-files/files/bin/AutoUpdate.sh
#	[[ -f "${PATH1}/replace.sh" ]] && cp -Rf "${PATH1}"/replace.sh package/base-files/files/bin/replace.sh
#fi
#[[ -f "${PATH1}/openwrt.sh" ]] && cp -Rf "${PATH1}"/openwrt.sh package/base-files/files/sbin/openwrt
#chmod 777 package/base-files/files/sbin/openwrt

if [[ "${REPO_BRANCH}" == "master" ]]; then
	cp -Rf "${Home}"/build/common/LEDE/files "${Home}"
	cp -Rf "${Home}"/build/common/LEDE/diy/* "${Home}"
	cp -Rf "${Home}"/build/common/LEDE/patches/* "${PATH1}/patches"
elif [[ "${REPO_BRANCH}" == "main" ]]; then
	cp -Rf "${Home}"/build/common/LIENOL/files "${Home}"
	cp -Rf "${Home}"/build/common/LIENOL/diy/* "${Home}"
	cp -Rf "${Home}"/build/common/LIENOL/patches/* "${PATH1}/patches"
elif [[ "${REPO_BRANCH}" == "openwrt-18.06" ]]; then
	cp -Rf "${Home}"/build/common/TIANLING/files "${Home}"
	cp -Rf "${Home}"/build/common/TIANLING/diy/* "${Home}"
	cp -Rf "${Home}"/build/common/TIANLING/patches/* "${PATH1}/patches"
elif [[ "${REPO_BRANCH}" == "openwrt-21.02" ]]; then
	cp -Rf "${Home}"/build/common/MORTAL/files "${Home}"
	cp -Rf "${Home}"/build/common/MORTAL/diy/* "${Home}"
	cp -Rf "${Home}"/build/common/MORTAL/patches/* "${PATH1}/patches"
	#chmod -R 777 ${Home}/build/common/Convert
	#cp -Rf ${Home}/build/common/Convert/* "${Home}"
	#/bin/bash Convert.sh
fi
if [ -n "$(ls -A "${PATH1}/diy" 2>/dev/null)" ]; then
	cp -Rf "${PATH1}"/diy/* "${Home}"
fi
if [ -n "$(ls -A "${PATH1}/files" 2>/dev/null)" ]; then
	cp -Rf "${PATH1}/files" "${Home}" && chmod -R +x ${Home}/files
fi
if [ -n "$(ls -A "${PATH1}/patches" 2>/dev/null)" ]; then
	find "${PATH1}/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d './' -p1 --forward --no-backup-if-mismatch"
fi
if [[ "${REPO_BRANCH}" == "master" ]] && [[ ! ${byop} == "0" ]]; then
	sed -i 's/distversion)%>/distversion)%><!--/g' package/lean/autocore/files/*/index.htm
	sed -i 's/luciversion)%>)/luciversion)%>)-->/g' package/lean/autocore/files/*/index.htm
fi
if [[ "${REPO_BRANCH}" == "openwrt-18.06" ]] && [[ ! ${byop} == "0" ]]; then
	sed -i 's/distversion)%>/distversion)%><!--/g' package/emortal/autocore/files/*/index.htm
	sed -i 's/luciversion)%>)/luciversion)%>)-->/g' package/emortal/autocore/files/*/index.htm
fi	
}

################################################################################################################
# s905x3_s905x2_s905x_s905d_s922x_s912 一键打包脚本
################################################################################################################
Diy_amlogic() {
cd $GITHUB_WORKSPACE
}

################################################################################################################
# 判断脚本是否缺少主要文件（如果缺少settings.ini设置文件在检测脚本设置就运行错误了）
################################################################################################################
Diy_settings() {
rm -rf ${Home}/build/QUEWENJIANerros
if [ -z "$(ls -A "$PATH1/${CONFIG_FILE}" 2>/dev/null)" ]; then
	echo
	TIME r "错误提示：编译脚本缺少[${CONFIG_FILE}]名称的配置文件,请在[build/${Modelfile}]文件夹内补齐"
	echo "errors" > ${Home}/build/QUEWENJIANerros
	echo
fi
if [ -z "$(ls -A "$PATH1/${DIY_PART_SH}" 2>/dev/null)" ]; then
	echo
	TIME r "错误提示：编译脚本缺少[${DIY_PART_SH}]名称的自定义设置文件,请在[build/${Modelfile}]文件夹内补齐"
	echo "errors" > ${Home}/build/QUEWENJIANerros
	echo
fi
if [ -n "$(ls -A "${Home}/build/QUEWENJIANerros" 2>/dev/null)" ]; then
rm -rf ${Home}/build/QUEWENJIANerros
exit 1
fi
rm -rf {build,README.md}
}


################################################################################################################
# 判断插件冲突
################################################################################################################
Diy_chajian() {
echo
make defconfig
echo "TIME b \"					插件冲突信息\"" > ${Home}/CHONGTU


if [ -n "$(ls -A "${Home}/Chajianlibiao" 2>/dev/null)" ]; then

	echo "TIME z \"\"" >>CHONGTU
else
	rm -rf CHONGTU
fi
}


################################################################################################################
# 为编译做最后处理
################################################################################################################
Diy_chuli() {

sed -i '$ s/exit 0$//' ${Home}/package/base-files/files/etc/rc.local
echo '
if [[ `grep -c "coremark" /etc/crontabs/root` -eq "1" ]]; then
  sed -i "/coremark/d" /etc/crontabs/root
fi
/etc/init.d/network restart
/etc/init.d/uhttpd restart
exit 0
' >> ${Home}/package/base-files/files/etc/rc.local


for X in $(ls -1 target/linux/generic | grep "config-")
do
	sed -i '/CONFIG_FAT_DEFAULT_IOCHARSET/d' target/linux/generic/${X}
	echo -e '\nCONFIG_FAT_DEFAULT_IOCHARSET="utf8"' >> target/linux/generic/${X}
done

if [[ "${BY_INFORMATION}" == "true" ]]; then
	grep -i CONFIG_PACKAGE_luci-app .config | grep  -v \# > Plug-in
	grep -i CONFIG_PACKAGE_luci-theme .config | grep  -v \# >> Plug-in
	if [[ `grep -c "CONFIG_PACKAGE_luci-i18n-qbittorrent-zh-cn=y" ${Home}/.config` -eq '0' ]]; then
		sed -i '/qbittorrent/d' Plug-in
	fi
	if [[ `grep -c "CONFIG_PACKAGE_luci-app-passwall2=y" ${Home}/.config` -eq '0' ]]; then
		sed -i '/luci-app-passwall2/d' Plug-in
	fi
	sed -i '/INCLUDE/d' Plug-in > /dev/null 2>&1
	sed -i '/=m/d' Plug-in > /dev/null 2>&1
	sed -i 's/CONFIG_PACKAGE_/、/g' Plug-in
	sed -i 's/=y/\"/g' Plug-in
	awk '$0=NR$0' Plug-in > Plug-2
	awk '{print "	" $0}' Plug-2 > Plug-in
	sed -i "s/^/TIME g \"/g" Plug-in
fi
rm -rf ${Home}/files/{README,README.md}
}

################################################################################################################
# 编译信息
################################################################################################################
Diy_xinxi() {
echo
TIME b "编译源码: ${CODE}"
TIME b "源码链接: ${REPO_URL}"
TIME b "源码分支: ${REPO_BRANCH}"
TIME b "源码作者: ${ZUOZHE}"
TIME b "Luci版本: ${OpenWrt_name}"
[[ "${Modelfile}" == "openwrt_amlogic" ]] && {
	TIME b "编译机型: 晶晨系列"
} || {
	TIME b "编译机型: ${TARGET_PROFILE}"
}
TIME b "固件作者: ${Author}"
TIME b "仓库地址: ${Github}"
TIME b "启动编号: #${Run_number}（${CangKu}仓库第${Run_number}次启动[${Run_workflow}]工作流程）"
TIME b "编译时间: ${Compte}"
[[ "${Modelfile}" == "openwrt_amlogic" ]] && {
	TIME g "友情提示：您当前使用【${Modelfile}】文件夹编译【晶晨系列】固件"
} || {
	TIME g "友情提示：您当前使用【${Modelfile}】文件夹编译【${TARGET_PROFILE}】固件"
}
echo
echo
if [[ ${UPLOAD_FIRMWARE} == "true" ]]; then
	TIME y "上传固件在github actions: 开启"
else
	TIME r "上传固件在github actions: 关闭"
fi
if [[ ${UPLOAD_CONFIG} == "true" ]]; then
	TIME y "上传[.config]配置文件: 开启"
else
	TIME r "上传[.config]配置文件: 关闭"
fi
if [[ ${UPLOAD_BIN_DIR} == "true" ]]; then
	TIME y "上传BIN文件夹(固件+IPK): 开启"
else
	TIME r "上传BIN文件夹(固件+IPK): 关闭"
fi
if [[ ${UPLOAD_COWTRANSFER} == "true" ]]; then
	TIME y "上传固件至【奶牛快传】: 开启"
else
	TIME r "上传固件至【奶牛快传】: 关闭"
fi
if [[ ${UPLOAD_WETRANSFER} == "true" ]]; then
	TIME y "上传固件至【WETRANSFER】: 开启"
else
	TIME r "上传固件至【WETRANSFER】: 关闭"
fi
if [[ ${UPLOAD_RELEASE} == "true" ]]; then
	TIME y "发布固件: 开启"
else
	TIME r "发布固件: 关闭"
fi
if [[ ${SERVERCHAN_SCKEY} == "true" ]]; then
	TIME y "微信/电报通知: 开启"
else
	TIME r "微信/电报通知: 关闭"
fi
if [[ ${BY_INFORMATION} == "true" ]]; then
	TIME y "编译信息显示: 开启"
fi
if [[ ${REGULAR_UPDATE} == "true" ]]; then
	TIME y "把定时自动更新插件编译进固件: 开启"
else
	TIME r "把定时自动更新插件编译进固件: 关闭"
fi
if [[ ${REGULAR_UPDATE} == "true" ]]; then
	echo
	TIME l "定时自动更新信息"
	TIME z "插件版本: ${AutoUpdate_Version}"
	if [[ ${TARGET_PROFILE} == "x86-64" ]]; then
		TIME b "传统固件: ${Legacy_Firmware}"
		TIME b "UEFI固件: ${UEFI_Firmware}"
		TIME b "固件后缀: ${Firmware_sfx}"
	else
		TIME b "固件名称: ${Up_Firmware}"
		TIME b "固件后缀: ${Firmware_sfx}"
	fi
	TIME b "固件版本: ${Openwrt_Version}"
	TIME b "云端路径: ${Github_UP_RELEASE}"
	TIME g "《编译成功后，会自动把固件发布到指定地址，然后才会生成云端路径》"
	TIME g "《普通的那个发布固件跟云端的发布路径是两码事，如果你不需要普通发布的可以不用打开发布功能》"
	TIME g "修改IP、DNS、网关或者在线更新，请输入命令：openwrt"
	echo
else
	echo
fi
echo
TIME z " 系统空间      类型   总数  已用  可用 使用率"
cd ../ && df -hT $PWD && cd openwrt
echo
echo
if [ -n "$(ls -A "${Home}/EXT4" 2>/dev/null)" ]; then
	echo
	echo
	chmod -R +x ${Home}/EXT4
	source ${Home}/EXT4
	rm -rf EXT4
fi
if [ -n "$(ls -A "${Home}/Chajianlibiao" 2>/dev/null)" ]; then
	echo
	echo
	chmod -R +x ${Home}/CHONGTU
	source ${Home}/CHONGTU
	rm -rf {CHONGTU,Chajianlibiao}
	echo
	echo
fi
if [ -n "$(ls -A "${Home}/Plug-in" 2>/dev/null)" ]; then
	TIME r "	      已选插件列表"
	chmod -R +x ${Home}/Plug-in
	source ${Home}/Plug-in
	rm -rf {Plug-in,Plug-2}
	echo
fi
}
