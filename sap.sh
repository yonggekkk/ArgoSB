#!/bin/bash
export LANG=en_US.UTF-8
if ! command -v apk >/dev/null 2>&1 && ! command -v apt >/dev/null 2>&1; then
echo "脚本仅支持Alpine、Debian、Ubuntu系统" && exit
fi
[[ $EUID -ne 0 ]] && echo "请以root模式运行脚本" && exit
sapsbxinstall(){
URL="https://raw.githubusercontent.com/yonggekkk/argosbx/beta/sapsbx.sh"
DEST="$HOME/sapsbx.sh"
command -v curl > /dev/null 2>&1 && curl -sSL $URL -o $DEST || wget -q $URL -O $DEST
if [ -s "$HOME/sapsbx.sh" ]; then
chmod +x $HOME/sapsbx.sh
while true; do
read -p "必填！请输入SAP邮箱账号（多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "50s/^.*$/CF_USERNAMES=\"${quoted% }\"/" $HOME/sapsbx.sh

while true; do
read -p "必填！请输入SAP密码（多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "53s/^.*$/CF_PASSWORDS=\"${quoted% }\"/" $HOME/sapsbx.sh

while true; do
read -p "必填！请输入SAP地区（详见地区文件表，多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "56s/^.*$/REGIONS=\"${quoted% }\"/" $HOME/sapsbx.sh

while true; do
read -p "必填！请输入UUID（多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "59s/^.*$/UUIDS=\"${quoted% }\"/" $HOME/sapsbx.sh

read -p "可选！请输入SAP应用名称（回车为地区-邮箱名称，多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
sed -i "62s/^.*$/APP_NAMES=\"\"/" $HOME/sapsbx.sh
else
quoted=$(printf '%s ' $input)
sed -i "62s/^.*$/APP_NAMES=\"${quoted% }\"/" $HOME/sapsbx.sh
fi

read -p "可选！请输入Argo固定隧道端口（回车表示关闭Argo隧道，多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
sed -i "65s/^.*$/VMPTS=\"\"/" $HOME/sapsbx.sh
sed -i "68s/^.*$/AGNS=\"\"/" $HOME/sapsbx.sh
sed -i "71s/^.*$/AGKS=\"\"/" $HOME/sapsbx.sh
else
quoted=$(printf '%s ' $input)
sed -i "65s/^.*$/VMPTS=\"${quoted% }\"/" $HOME/sapsbx.sh

while true; do
read -p "必填！请输入Argo固定隧道域名（多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "68s/^.*$/AGNS=\"${quoted% }\"/" $HOME/sapsbx.sh

while true; do
read -p "必填！请输入Argo固定隧道token（多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "71s/^.*$/AGKS=\"${quoted% }\"/" $HOME/sapsbx.sh
fi

read -p "可选！请输入8-9点的保活时间间隔（单位:分钟，回车默认3分钟间隔。针对个人账户，企业账号回车跳过）: " input
if [ -z "$input" ]; then
sed -i "74s/^.*$/crontime=3/" $HOME/sapsbx.sh
else
sed -i "74s/^.*$/crontime=$input/" $HOME/sapsbx.sh
fi
echo "脚本安装设置完毕，将在每天上午8:15-9:00之间自动运行保活"
else
echo "下载文件失败，请检查当前服务器是否支持curl或wget，网络是否支持github"
fi
}
unins(){
echo "请稍等……"
apt-get remove --purge -y cf8-cli >/dev/null 2>&1
rm -rf /usr/local/bin/cf8 $HOME/sapsbx.sh $HOME/sap.log
crontab -l 2>/dev/null > /tmp/crontab.tmp
sed -i '/sapsbx/d' /tmp/crontab.tmp >/dev/null 2>&1
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp
echo "卸载完成"
}
goagain(){
if [ -s "$HOME/sapsbx.sh" ]; then
bash $HOME/sapsbx.sh
else
echo "未安装脚本，请卸载重装"
fi
}
showlog(){
if [ -s "$HOME/sap.log" ] && [ -s "$HOME/sapsbx.sh" ]; then
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
echo "Argosbx小钢炮脚本-SAP多账户自动部署并保活脚本【VPS】"
echo "版本：V25.10.4"
echo "*****************************************************"
echo "提示：请确保已创建好空间，重置已生效变量需先删除应用程序"
echo "*****************************************************"
cf_line=$(sed -n '50p' "$HOME/sapsbx.sh")
cf_value=$(echo "$cf_line" | sed -E 's/CF_USERNAMES="(.*)"/\1/' | xargs)
[ -z "$cf_value" ] && echo "当前未设置SAP变量，选择1添加变量" || { echo "当前已设置过SAP变量，详情如下显示，可选择2执行一次"; sed -n '46,77p' "$HOME/sapsbx.sh"; }
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
