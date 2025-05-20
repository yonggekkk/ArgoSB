#!/bin/bash
export LANG=en_US.UTF-8
export nix=${nix:-''}
export UUID=${uuid:-''}
export port_vm_ws=${vmpt:-''}
export ARGO_DOMAIN=${agn:-''}   
export ARGO_AUTH=${agk:-''} 
[ -z "$nix" ] && sys='主流VPS-' || sys='容器NIX-'
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
echo "甬哥Github项目  ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "${sys}ArgoSB真一键无交互脚本"
echo "当前版本：25.5.10 测试beta7版"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
if [ -z "$nix" ]; then 
[[ $EUID -ne 0 ]] && echo "当前为主流VPS专用脚本模式，必须以root模式运行。请在脚本前加上 nix=y 切换为容器NIX模式运行" && exit

op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
if [[ $(echo "$op" | grep -i -E "arch") ]]; then
echo "脚本不支持当前的 $op 系统，请选择使用Ubuntu,Debian,Centos系统。" && exit
fi
[[ -z $(systemd-detect-virt 2>/dev/null) ]] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
aarch64) cpu=arm64;;
x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit;;
esac
hostname=$(hostname)
del(){
kill -15 $(cat /etc/s-box-ag/sbargopid.log 2>/dev/null) >/dev/null 2>&1
kill -15 $(cat /etc/s-box-ag/sbpid.log 2>/dev/null) >/dev/null 2>&1
crontab -l > /tmp/crontab.tmp
sed -i '/sbargopid/d' /tmp/crontab.tmp
sed -i '/sbpid/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp
rm -rf /etc/s-box-ag /usr/bin/agsb
}
up(){
rm -rf /usr/bin/agsb
curl -L -o /usr/bin/agsb -# --retry 2 --insecure https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh
chmod +x /usr/bin/agsb
}
if [[ "$1" == "del" ]]; then
del && sleep 2
echo "卸载完成" 
exit
elif [[ "$1" == "up" ]]; then
up && sleep 2
echo "升级完成" 
exit
fi
if [[ -n $(ps -e | grep sing-box) ]] && [[ -n $(ps -e | grep cloudflared) ]] && [[ -e /etc/s-box-ag/list.txt ]]; then
echo "ArgoSB脚本已在运行中"
argoname=$(cat /etc/s-box-ag/sbargoym.log 2>/dev/null)
if [ -z $argoname ]; then
argodomain=$(cat /etc/s-box-ag/argo.log 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [ -z $argodomain ]; then
echo "当前argo临时域名未生成，请先将脚本卸载(agsb del)，再重新安装ArgoSB脚本" 
else
echo "当前argo最新临时域名：$argodomain"
fi
else
echo "当前argo固定域名：$argoname"
echo "当前argo固定域名token：$(cat /etc/s-box-ag/sbargotoken.log 2>/dev/null)"
fi
cat /etc/s-box-ag/list.txt
exit
elif [[ -z $(ps -e | grep sing-box) ]] && [[ -z $(ps -e | grep cloudflared) ]]; then
echo "检查依赖安装……请稍等"
if command -v apt &> /dev/null; then
apt update -y &> /dev/null
apt install curl wget tar gzip cron jq procps coreutils util-linux -y &> /dev/null
elif command -v yum &> /dev/null; then
yum install -y curl wget jq tar procps-ng coreutils util-linux &> /dev/null
elif command -v apk &> /dev/null; then
apk update -y &> /dev/null
apk add wget curl tar jq tzdata openssl git grep procps coreutils util-linux dcron &> /dev/null
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "ArgoSB脚本未安装，开始安装…………" && sleep 3
echo
else
echo "ArgoSB脚本未启动，可能与其他sing-box或者argo脚本冲突了，请先将脚本卸载(agsb del)，再重新安装ArgoSB脚本"
exit
fi
warpcheck(){
wgcfv6=$(curl -s6m5 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
wgcfv4=$(curl -s4m5 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
}
v4orv6(){
if [ -z $(curl -s4m5 icanhazip.com -k) ]; then
echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a00:1098:2c::1\nnameserver 2a01:4f8:c2c:123f::1" > /etc/resolv.conf
fi
}
warpcheck
if [[ ! $wgcfv4 =~ on|plus && ! $wgcfv6 =~ on|plus ]]; then
v4orv6
else
systemctl stop wg-quick@wgcf >/dev/null 2>&1
kill -15 $(pgrep warp-go) >/dev/null 2>&1 && sleep 2
v4orv6
systemctl start wg-quick@wgcf >/dev/null 2>&1
systemctl restart warp-go >/dev/null 2>&1
systemctl enable warp-go >/dev/null 2>&1
systemctl start warp-go >/dev/null 2>&1
fi
mkdir -p /etc/s-box-ag
sbcore=$(curl -Ls https://data.jsdelivr.com/v1/package/gh/SagerNet/sing-box | grep -Eo '"[0-9.]+",' | sed -n 1p | tr -d '",')
sbname="sing-box-$sbcore-linux-$cpu"
echo "下载sing-box最新正式版内核：$sbcore"
curl -L -o /etc/s-box-ag/sing-box.tar.gz  -# --retry 2 https://github.com/SagerNet/sing-box/releases/download/v$sbcore/$sbname.tar.gz
if [[ -f '/etc/s-box-ag/sing-box.tar.gz' ]]; then
tar xzf /etc/s-box-ag/sing-box.tar.gz -C /etc/s-box-ag
mv /etc/s-box-ag/$sbname/sing-box /etc/s-box-ag
rm -rf /etc/s-box-ag/{sing-box.tar.gz,$sbname}
else
echo "下载失败，请检测网络" && exit
fi

if [ -z $port_vm_ws ]; then
port_vm_ws=$(shuf -i 10000-65535 -n 1)
fi
if [ -z $UUID ]; then
UUID=$(/etc/s-box-ag/sing-box generate uuid)
fi
echo
echo "当前vmess主协议端口：$port_vm_ws"
echo
echo "当前uuid密码：$UUID"
echo
sleep 3

cat > /etc/s-box-ag/sb.json <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${UUID}",
                "alterId": 0
            }
        ],
        "transport": {
            "type": "ws",
            "path": "${UUID}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"    
        },
        "tls":{
                "enabled": false,
                "server_name": "www.bing.com",
                "certificate_path": "/etc/s-box-ag/cert.pem",
                "key_path": "/etc/s-box-ag/private.key"
            }
    }
    ],
"outbounds": [
{
"type":"direct",
"tag":"direct"
}
]
}
EOF
nohup setsid /etc/s-box-ag/sing-box run -c /etc/s-box-ag/sb.json >/dev/null 2>&1 & echo "$!" > /etc/s-box-ag/sbpid.log
crontab -l > /tmp/crontab.tmp
sed -i '/sbpid/d' /tmp/crontab.tmp
echo '@reboot /bin/bash -c "nohup setsid /etc/s-box-ag/sing-box run -c /etc/s-box-ag/sb.json 2>&1 & pid=\$! && echo \$pid > /etc/s-box-ag/sbpid.log"' >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp
argocore=$(curl -Ls https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared | grep -Eo '"[0-9.]+",' | sed -n 1p | tr -d '",')
echo "下载cloudflared-argo最新正式版内核：$argocore"
curl -L -o /etc/s-box-ag/cloudflared -# --retry 2 https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu
chmod +x /etc/s-box-ag/cloudflared
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
name='固定'
nohup setsid /etc/s-box-ag/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH} >/dev/null 2>&1 & echo "$!" > /etc/s-box-ag/sbargopid.log
echo ${ARGO_DOMAIN} > /etc/s-box-ag/sbargoym.log
echo ${ARGO_AUTH} > /etc/s-box-ag/sbargotoken.log
else
name='临时'
nohup setsid /etc/s-box-ag/cloudflared tunnel --url http://localhost:$(sed 's://.*::g' /etc/s-box-ag/sb.json | jq -r '.inbounds[0].listen_port') --edge-ip-version auto --no-autoupdate --protocol http2 > /etc/s-box-ag/argo.log 2>&1 &
echo "$!" > /etc/s-box-ag/sbargopid.log
fi
echo "申请Argo$name隧道中……请稍等"
sleep 8
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
argodomain=$(cat /etc/s-box-ag/sbargoym.log 2>/dev/null)
else
argodomain=$(cat /etc/s-box-ag/argo.log 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [[ -n $argodomain ]]; then
echo "Argo$name隧道申请成功，域名为：$argodomain"
else
echo "Argo$name隧道申请失败，请稍后再试" && del && exit
fi
crontab -l > /tmp/crontab.tmp
sed -i '/sbargopid/d' /tmp/crontab.tmp
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
echo '@reboot /bin/bash -c "nohup setsid /etc/s-box-ag/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat /etc/s-box-ag/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 & pid=\$! && echo \$pid > /etc/s-box-ag/sbargopid.log"' >> /tmp/crontab.tmp
else
echo '@reboot /bin/bash -c "nohup setsid /etc/s-box-ag/cloudflared tunnel --url http://localhost:$(sed 's://.*::g' /etc/s-box-ag/sb.json | jq -r '.inbounds[0].listen_port') --edge-ip-version auto --no-autoupdate --protocol http2 > /etc/s-box-ag/argo.log 2>&1 & pid=\$! && echo \$pid > /etc/s-box-ag/sbargopid.log"' >> /tmp/crontab.tmp
fi
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp
up
vmatls_link1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-443\", \"add\": \"104.16.0.0\", \"port\": \"443\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link1" > /etc/s-box-ag/jh.txt
vmatls_link2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-8443\", \"add\": \"104.17.0.0\", \"port\": \"8443\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link2" >> /etc/s-box-ag/jh.txt
vmatls_link3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2053\", \"add\": \"104.18.0.0\", \"port\": \"2053\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link3" >> /etc/s-box-ag/jh.txt
vmatls_link4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2083\", \"add\": \"104.19.0.0\", \"port\": \"2083\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link4" >> /etc/s-box-ag/jh.txt
vmatls_link5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2087\", \"add\": \"104.20.0.0\", \"port\": \"2087\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link5" >> /etc/s-box-ag/jh.txt
vmatls_link6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2096\", \"add\": \"[2606:4700::]\", \"port\": \"2096\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link6" >> /etc/s-box-ag/jh.txt
vma_link7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-80\", \"add\": \"104.21.0.0\", \"port\": \"80\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link7" >> /etc/s-box-ag/jh.txt
vma_link8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8080\", \"add\": \"104.22.0.0\", \"port\": \"8080\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link8" >> /etc/s-box-ag/jh.txt
vma_link9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8880\", \"add\": \"104.24.0.0\", \"port\": \"8880\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link9" >> /etc/s-box-ag/jh.txt
vma_link10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2052\", \"add\": \"104.25.0.0\", \"port\": \"2052\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link10" >> /etc/s-box-ag/jh.txt
vma_link11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2082\", \"add\": \"104.26.0.0\", \"port\": \"2082\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link11" >> /etc/s-box-ag/jh.txt
vma_link12="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2086\", \"add\": \"104.27.0.0\", \"port\": \"2086\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link12" >> /etc/s-box-ag/jh.txt
vma_link13="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2095\", \"add\": \"[2400:cb00:2049::]\", \"port\": \"2095\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link13" >> /etc/s-box-ag/jh.txt
baseurl=$(base64 -w 0 < /etc/s-box-ag/jh.txt)
line1=$(sed -n '1p' /etc/s-box-ag/jh.txt)
line6=$(sed -n '6p' /etc/s-box-ag/jh.txt)
line7=$(sed -n '7p' /etc/s-box-ag/jh.txt)
line13=$(sed -n '13p' /etc/s-box-ag/jh.txt)
vmport=${port_vm_ws}
echo "ArgoSB脚本安装完毕" && sleep 2
cat > /etc/s-box-ag/list.txt <<EOF
---------------------------------------------------------
---------------------------------------------------------
Vmess主协议端口(Argo固定隧道端口)：$vmport
---------------------------------------------------------
单节点配置输出：
1、443端口的vmess-ws-tls-argo节点，默认优选IPV4：104.16.0.0
$line1

2、2096端口的vmess-ws-tls-argo节点，默认优选IPV6：[2606:4700::]（本地网络支持IPV6才可用）
$line6

3、80端口的vmess-ws-argo节点，默认优选IPV4：104.21.0.0
$line7

4、2095端口的vmess-ws-argo节点，默认优选IPV6：[2400:cb00:2049::]（本地网络支持IPV6才可用）
$line13

---------------------------------------------------------
聚合节点配置输出：
5、Argo节点13个端口及不死IP全覆盖：7个关tls 80系端口节点、6个开tls 443系端口节点

$baseurl

---------------------------------------------------------
相关快捷方式如下：
显示域名及节点信息：agsb
升级脚本：agsb up
卸载脚本：agsb del
---------------------------------------------------------
EOF
cat /etc/s-box-ag/list.txt
else
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[[ -z $(systemd-detect-virt 2>/dev/null) ]] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
aarch64) cpu=arm64;;
x86_64) cpu=amd64;;
esac
hostname=$(uname -a | awk '{print $2}')
mkdir -p nixag
del(){
kill -15 $(cat nixag/sbargopid.log 2>/dev/null) >/dev/null 2>&1
kill -15 $(cat nixag/sbpid.log 2>/dev/null) >/dev/null 2>&1
sed -i '/yonggekkk/d' ~/.bashrc 
source ~/.bashrc
rm -rf nixag
}
if [[ "$1" == "del" ]]; then
del && sleep 2
echo "卸载完成" 
exit
fi
if [[ -n $(ps -e | grep sing-box) ]] && [[ -n $(ps -e | grep cloudflared) ]] && [[ -e nixag/list.txt ]]; then
echo "ArgoSB脚本已在运行中"
cat nixag/list.txt
exit
else
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "ArgoSB脚本未安装，开始安装…………" && sleep 3
fi
if [ ! -e nixag/sing-box ]; then
sbcore=$(curl -Ls https://data.jsdelivr.com/v1/package/gh/SagerNet/sing-box | grep -Eo '"[0-9.]+",' | sed -n 1p | tr -d '",')
sbname="sing-box-$sbcore-linux-$cpu"
echo "下载sing-box最新正式版内核：$sbcore"
curl -L -o nixag/sing-box.tar.gz  -# --retry 2 https://github.com/SagerNet/sing-box/releases/download/v$sbcore/$sbname.tar.gz
if [[ -f 'nixag/sing-box.tar.gz' ]]; then
tar xzf nixag/sing-box.tar.gz -C nixag
mv nixag/$sbname/sing-box nixag
rm -rf nixag/{sing-box.tar.gz,$sbname}
chmod +x nixag/sing-box
else
echo "下载失败，请检测网络" && exit
fi
fi
if [ -z $port_vm_ws ]; then
port_vm_ws=$(shuf -i 10000-65535 -n 1)
fi
if [ -z $UUID ]; then
UUID=$(./nixag/sing-box generate uuid)
fi
echo
echo "当前vmess主协议端口：$port_vm_ws"
echo
echo "当前uuid密码：$UUID"
echo
if [[ "$hostname" == *firebase* || "$hostname" == *idx* ]]; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/yonggekkk/d' ~/.bashrc
echo "export nix=y uuid=${uuid} vmpt=${port_vm_ws} agn=${ARGO_DOMAIN} agk=${ARGO_AUTH} && bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)" >> ~/.bashrc
source ~/.bashrc
fi
sleep 2

cat > nixag/sb.json <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${UUID}",
                "alterId": 0
            }
        ],
        "transport": {
            "type": "ws",
            "path": "${UUID}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"    
        },
        "tls":{
                "enabled": false,
                "server_name": "www.bing.com",
                "certificate_path": "/nixag/cert.pem",
                "key_path": "/nixag/private.key"
            }
    }
    ],
"outbounds": [
{
"type":"direct",
"tag":"direct"
}
]
}
EOF
nohup ./nixag/sing-box run -c nixag/sb.json >/dev/null 2>&1 & echo "$!" > nixag/sbpid.log
if [ ! -e nixag/cloudflared ]; then
argocore=$(curl -Ls https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared | grep -Eo '"[0-9.]+",' | sed -n 1p | tr -d '",')
echo "下载cloudflared-argo最新正式版内核：$argocore"
curl -L -o nixag/cloudflared -# --retry 2 https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu
chmod +x nixag/cloudflared
fi
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
name='固定'
nohup ./nixag/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH} >/dev/null 2>&1 & echo "$!" > nixag/sbargopid.log
echo ${ARGO_DOMAIN} > nixag/sbargoym.log
echo ${ARGO_AUTH} > nixag/sbargotoken.log
else
name='临时'
nohup ./nixag/cloudflared tunnel --url http://localhost:${port_vm_ws} --edge-ip-version auto --no-autoupdate --protocol http2 > nixag/argo.log 2>&1 &
echo "$!" > nixag/sbargopid.log
fi
echo "申请Argo$name隧道中……请稍等"
sleep 8
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
argodomain=$(cat nixag/sbargoym.log 2>/dev/null)
nametn="当前Argo固定隧道token：$(cat nixag/sbargotoken.log 2>/dev/null)"
else
argodomain=$(cat nixag/argo.log 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [[ -n $argodomain ]]; then
echo "Argo$name隧道申请成功，域名为：$argodomain"
else
echo "Argo$name隧道申请失败，请稍后再试" && del && exit
fi
vmatls_link1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-443\", \"add\": \"104.16.0.0\", \"port\": \"443\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link1" > nixag/jh.txt
vmatls_link2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-8443\", \"add\": \"104.17.0.0\", \"port\": \"8443\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link2" >> nixag/jh.txt
vmatls_link3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2053\", \"add\": \"104.18.0.0\", \"port\": \"2053\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link3" >> nixag/jh.txt
vmatls_link4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2083\", \"add\": \"104.19.0.0\", \"port\": \"2083\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link4" >> nixag/jh.txt
vmatls_link5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2087\", \"add\": \"104.20.0.0\", \"port\": \"2087\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link5" >> nixag/jh.txt
vmatls_link6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2096\", \"add\": \"[2606:4700::]\", \"port\": \"2096\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link6" >> nixag/jh.txt
vma_link7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-80\", \"add\": \"104.21.0.0\", \"port\": \"80\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link7" >> nixag/jh.txt
vma_link8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8080\", \"add\": \"104.22.0.0\", \"port\": \"8080\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link8" >> nixag/jh.txt
vma_link9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8880\", \"add\": \"104.24.0.0\", \"port\": \"8880\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link9" >> nixag/jh.txt
vma_link10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2052\", \"add\": \"104.25.0.0\", \"port\": \"2052\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link10" >> nixag/jh.txt
vma_link11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2082\", \"add\": \"104.26.0.0\", \"port\": \"2082\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link11" >> nixag/jh.txt
vma_link12="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2086\", \"add\": \"104.27.0.0\", \"port\": \"2086\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link12" >> nixag/jh.txt
vma_link13="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2095\", \"add\": \"[2400:cb00:2049::]\", \"port\": \"2095\", \"id\": \"$UUID\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$UUID-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link13" >> nixag/jh.txt
line1=$(sed -n '1p' nixag/jh.txt)
line6=$(sed -n '6p' nixag/jh.txt)
line7=$(sed -n '7p' nixag/jh.txt)
line13=$(sed -n '13p' nixag/jh.txt)
echo "ArgoSB脚本安装完毕" && sleep 2
echo
echo
cat > nixag/list.txt <<EOF
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
以下节点信息内容，请查看nixag/list.txt文件或者运行cat nixag/jh.txt进行复制
---------------------------------------------------------
Vmess主协议端口(Argo固定隧道端口)：$port_vm_ws
当前Argo$name域名：$argodomain
$nametn
---------------------------------------------------------
1、443端口的vmess-ws-tls-argo节点，默认优选IPV4：104.16.0.0
$line1

2、2096端口的vmess-ws-tls-argo节点，默认优选IPV6：[2606:4700::]（本地网络支持IPV6才可用）
$line6

3、80端口的vmess-ws-argo节点，默认优选IPV4：104.21.0.0
$line7

4、2095端口的vmess-ws-argo节点，默认优选IPV6：[2400:cb00:2049::]（本地网络支持IPV6才可用）
$line13

5、Argo节点13个端口聚合节点信息，请查看nixag/jh.txt文件或者运行cat nixag/jh.txt进行复制
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
EOF
cat nixag/list.txt
fi
