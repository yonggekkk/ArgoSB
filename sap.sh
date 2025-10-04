#!/bin/bash
export LANG=en_US.UTF-8
[[ $EUID -ne 0 ]] && echo "请以root模式运行脚本" && exit
URL="https://raw.githubusercontent.com/yonggekkk/argosbx/beta/sapsbx.sh"
DEST="$HOME/sapsbx.sh"
command -v curl > /dev/null 2>&1 && curl -sSL $URL -o $DEST || wget -q $URL -O $DEST
if [ -s "$HOME/sapsbx.sh" ]; then
chmod +x $HOME/sapsbx.sh

while true; do
read -p "必填！请输入sap账号（用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "50s/^.*$/CF_USERNAMES=\"${quoted% }\"/" $HOME/sapsbx.sh

while true; do
read -p "必填！请输入sap密码（多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
echo "输入不能为空，请重新输入！"
else
break
fi
done
quoted=$(printf '%s ' $input)
sed -i "53s/^.*$/CF_PASSWORDS=\"${quoted% }\"/" $HOME/sapsbx.sh

while true; do
read -p "必填！请输入地区（US或者SG，多个按顺序用空格分隔）: " input
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

read -p "可选！请输入sapsbx应用名称（回车为地区邮箱名称，多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
sed -i "62s/^.*$/APP_NAMES=\"\"/" $HOME/sapsbx.sh
else
quoted=$(printf '%s ' $input)
sed -i "62s/^.*$/APP_NAMES=\"${quoted% }\"/" $HOME/sapsbx.sh
fi

read -p "可选！请输入Argo固定端口（回车跳过表示关闭Argo，仅用vless，多个按顺序用空格分隔）: " input
if [ -z "$input" ]; then
sed -i "65s/^.*$/VMPTS=\"\"/" $HOME/sapsbx.sh
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

read -p "可选！请输入保活时间间隔（单位:分钟，默认3分钟间隔）: " input
if [ -z "$input" ]; then
sed -i "74s/^.*$/crontime=3/" $HOME/sapsbx.sh
else
sed -i "74s/^.*$/crontime=$input/" $HOME/sapsbx.sh
fi
bash $HOME/sapsbx.sh
else
echo "下载文件失败，请检查当前服务器是否支持curl或wget，网络是否支持github"
fi
