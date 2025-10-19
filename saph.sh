#!/bin/bash
export LANG=en_US.UTF-8
if ! command -v apk >/dev/null 2>&1 && ! command -v apt >/dev/null 2>&1; then
echo "脚本仅支持Alpine、Debian、Ubuntu系统" && exit
fi
[[ $EUID -ne 0 ]] && echo "请以root模式运行脚本" && exit
sapsbxinstall(){
URL="https://raw.githubusercontent.com/yonggekkk/argosbx/main/sapsbxh.sh"
DEST="$HOME/sapsbxh.sh"
command -v curl > /dev/null 2>&1 && curl -sSL $URL -o $DEST || wget -q $URL -O $DEST
if [ -s "$HOME/sapsbxh.sh" ]; then
chmod +x $HOME/sapsbxh.sh

echo
while true; do
read -p "必填！请输入SAP邮箱账号（每个账号邮箱空一格）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "50s/^.*$/CF_USERNAMES=\"${quoted% }\"/" $HOME/sapsbxh.sh

echo
while true; do
read -p "必填！请输入SAP密码（每个账号对应密码空一格）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "53s/^.*$/CF_PASSWORDS=\"${quoted% }\"/" $HOME/sapsbxh.sh

echo
while true; do
read -p "必填！请输入SAP地区（详见地区变量对照表，每个账号对应地区空一格）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "56s/^.*$/REGIONS=\"${quoted% }\"/" $HOME/sapsbxh.sh

echo
while true; do
read -p "必填！请输入UUID（每个账号对应UUID空一格）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "59s/^.*$/UUIDS=\"${quoted% }\"/" $HOME/sapsbxh.sh

echo
read -p "选填！请输入8:10-9:00点的保活时间间隔（单位:分钟，回车默认5分钟间隔）: " input
if [ -z "$input" ]; then
sed -i "62s/^.*$/crontime=5/" $HOME/sapsbxh.sh
else
sed -i "62s/^.*$/crontime=$input/" $HOME/sapsbxh.sh
fi
echo "脚本安装设置完毕"
echo "每天上午8:10-9:00之间脚本自动运行保活，可以再次进入脚本选择2测试执行一次" && sleep 3
command -v curl > /dev/null 2>&1 && bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosbx/main/saph.sh) || bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/argosbx/main/saph.sh)
else
echo "下载文件失败，请检查当前服务器是否支持curl或wget，网络是否支持github"
fi
}
unins(){
echo "请稍等……"
apt-get remove --purge -y cf8-cli >/dev/null 2>&1
rm -rf /usr/local/bin/cf8 "$HOME"/{sapsbxh.sh,sap.log,saph.sh}
crontab -l 2>/dev/null > /tmp/crontab.tmp
sed -i '/sapsbx/d' /tmp/crontab.tmp >/dev/null 2>&1
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp
echo "卸载完成"
}
goagain(){
if [ -s "$HOME/sapsbxh.sh" ]; then
bash $HOME/sapsbxh.sh
else
echo "未安装脚本，请卸载重装"
fi
}
showlog(){
if [ -s "$HOME/sap.log" ] && [ -s "$HOME/sapsbxh.sh" ]; then
cat $HOME/sap.log
else
echo "无自动执行日志，请明天上午9点后再来看"
fi
}

echo "*****************************************************"
echo "*****************************************************"
echo "甬哥Github项目  ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "Argosbx小钢炮脚本-SAP多账户自动保活脚本【VPS】"
echo "版本：V25.10.19"
echo "*****************************************************"
echo "*****************************************************"
cf_line=$(sed -n '50p' "$HOME/sapsbxh.sh" 2>/dev/null)
cf_value=$(echo "$cf_line" | sed -E 's/CF_USERNAMES="(.*)"/\1/' | xargs 2>/dev/null)
[ -z "$cf_value" ] && echo "当前未设置SAP变量，选择1添加变量" || { echo "当前已设置过SAP变量，详情如下显示，可选择2执行一次"; sed -n '47,64p' "$HOME/sapsbxh.sh" 2>/dev/null; }
echo "*****************************************************"
echo " 1. 安装脚本并添加/重置变量" 
echo " 2. 手动测试执行一次"
echo " 3. 查看最近一次自动执行日志"
echo " 4. 卸载脚本"   
echo " 0. 退出"
read -p "请输入数字【0-4】:" Input 
case "$Input" in  
 1 ) sapsbxinstall;;
 2 ) goagain;;
 3 ) showlog;;
 4 ) unins;;
 * ) exit 
esac
