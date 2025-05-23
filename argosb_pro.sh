#!/bin/bash
export LANG=en_US.UTF-8
export uuid=${uuid:-''}
export port_vl_re=${vlpt:-''}
export port_vm_ws=${vmpt:-''}
export port_hy2=${hypt:-''}
export port_tu=${tupt:-''}
export ym_vl_re=${reym:-''}
export ARGO_DOMAIN=${agn:-''}   
export ARGO_AUTH=${agk:-''} 
export argo=${argo:-''}
export ipsw=${ip:-''}
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
echo "甬哥Github项目  ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "123"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[[ -z $(systemd-detect-virt 2>/dev/null) ]] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
aarch64) cpu=arm64;;
x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
mkdir -p ./aspro
warpcheck(){
wgcfv6=$(curl -s6m5 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
wgcfv4=$(curl -s4m5 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
}
pidshow(){
sbpid=$(cat ./aspro/sbpid.log 2>/dev/null) 
sbpidp=$(cat /proc/$sbpid/status 2>/dev/null)
}
ins(){
if [ ! -e ./aspro/sing-box ]; then
curl -L -o ./aspro/sing-box  -# --retry 2 https://github.com/yonggekkk/ArgoSB/releases/download/singbox/sing-box-$cpu
chmod +x ./aspro/sing-box
sbcore=$(./aspro/sing-box version 2>/dev/null | awk '/version/{print $NF}')
echo "已安装Sing-box正式版内核：$sbcore"
fi
for var in port_vl_re port_vm_ws port_hy2 port_tu; do
if [ -z "${!var}" ]; then
eval "$var=$(shuf -i 10000-65535 -n 1)"
fi
done
if [ -z $uuid ]; then
uuid=$(./aspro/sing-box generate uuid)
fi
if [ -z $ym_vl_re ]; then
ym_vl_re=www.yahoo.com
fi
echo "$uuid" > ./aspro/uuid
echo "$port_vl_re" > ./aspro/port_vl_re
echo "$port_vm_ws" > ./aspro/port_vm_ws
echo "$port_hy2" > ./aspro/port_hy2
echo "$port_tu" > ./aspro/port_tu
echo "$ym_vl_re" > ./aspro/ym_vl_re
openssl ecparam -genkey -name prime256v1 -out ./aspro/private.key
openssl req -new -x509 -days 36500 -key ./aspro/private.key -out ./aspro/cert.pem -subj "/CN=www.bing.com"
if [ ! -e ./aspro/private_key ]; then
key_pair=$(./aspro/sing-box generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$(./aspro/sing-box generate rand --hex 4)
echo "$private_key" > ./aspro/private_key
echo "$public_key" > ./aspro/public.key
echo "$short_id" > ./aspro/short_id
fi
private_key=$(< ./aspro/private_key)
public_key=$(< ./aspro/public.key)
short_id=$(< ./aspro/short_id)
echo "Vless-reality端口：$port_vl_re"
echo "Vmess-ws端口：$port_vm_ws"
echo "Hysteria-2端口：$port_hy2"
echo "Tuic-v5端口：$port_tu"
echo "当前uuid密码：$uuid"
echo "当前reality域名：$ym_vl_re"
echo "当前reality pr key：$private_key"
echo "当前reality pu key：$public_key"
echo "当前reality id：$short_id"
cat > ./aspro/sb.json <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-sb",
      "listen": "::",
      "listen_port": ${port_vl_re},
      "users": [
        {
          "uuid": "${uuid}",
          "flow": "xtls-rprx-vision"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "${ym_vl_re}",
          "reality": {
          "enabled": true,
          "handshake": {
            "server": "${ym_vl_re}",
            "server_port": 443
          },
          "private_key": "$private_key",
          "short_id": ["$short_id"]
        }
      }
    },
{
        "type": "vmess",
        "tag": "vmess-sb",
        "listen": "::",
        "listen_port": ${port_vm_ws},
        "users": [
            {
                "uuid": "${uuid}",
                "alterId": 0
            }
        ],
        "transport": {
            "type": "ws",
            "path": "${uuid}-vm",
            "max_early_data":2048,
            "early_data_header_name": "Sec-WebSocket-Protocol"    
        },
        "tls":{
                "enabled": false,
                "server_name": "www.bing.com",
                "certificate_path": "./aspro/cert.pem",
                "key_path": "./aspro/private.key"
            }
    },
    {
        "type": "hysteria2",
        "tag": "hy2-sb",
        "listen": "::",
        "listen_port": ${port_hy2},
        "users": [
            {
                "password": "${uuid}"
            }
        ],
        "ignore_client_bandwidth":false,
        "tls": {
            "enabled": true,
            "alpn": [
                "h3"
            ],
            "certificate_path": "./aspro/cert.pem",
            "key_path": "./aspro/private.key"
        }
    },
        {
            "type":"tuic",
            "tag": "tuic5-sb",
            "listen": "::",
            "listen_port": ${port_tu},
            "users": [
                {
                    "uuid": "${uuid}",
                    "password": "${uuid}"
                }
            ],
            "congestion_control": "bbr",
            "tls":{
                "enabled": true,
                "alpn": [
                    "h3"
                ],
                "certificate_path": "./aspro/cert.pem",
                "key_path": "./aspro/private.key"
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
nohup ./aspro/sing-box run -c ./aspro/sb.json >/dev/null 2>&1 & echo "$!" > ./aspro/sbpid.log
if [[ -n $argo ]]; then
if [ ! -e ./aspro/cloudflared ]; then
argocore=$(curl -Ls https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared | grep -Eo '"[0-9.]+",' | sed -n 1p | tr -d '",')
echo "下载cloudflared-argo最新正式版内核：$argocore"
curl -L -o ./aspro/cloudflared -# --retry 2 https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu
chmod +x ./aspro/cloudflared
fi
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
name='固定'
nohup ./aspro/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH} >/dev/null 2>&1 & echo "$!" > ./aspro/sbargopid.log
echo ${ARGO_DOMAIN} > ./aspro/sbargoym.log
echo ${ARGO_AUTH} > ./aspro/sbargotoken.log
else
name='临时'
nohup ./aspro/cloudflared tunnel --url http://localhost:${port_vm_ws} --edge-ip-version auto --no-autoupdate --protocol http2 > ./aspro/argo.log 2>&1 &
echo "$!" > ./aspro/sbargopid.log
fi
echo "申请Argo$name隧道中……请稍等"
sleep 8
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
argodomain=$(cat ./aspro/sbargoym.log 2>/dev/null)
else
argodomain=$(grep -a trycloudflare.com ./aspro/argo.log 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [[ -n "${argodomain}" ]]; then
echo "Argo$name隧道申请成功，域名为：$argodomain"
else
echo "Argo$name隧道申请失败，请稍后再试"
fi
fi

sbpid=$(cat ./aspro/sbpid.log 2>/dev/null) 
sbpidp=$(cat /proc/$sbpid/status 2>/dev/null)
if [ -n "$sbpidp" ] || ps -p "$sbpid" > /dev/null 2>&1; then
[ -f ~/.bashrc ] || touch ~/.bashrc

sed -i '/yonggekkk/d' ~/.bashrc
echo "ip=${ipsw} argo=${argo} uuid=${uuid} vlpt=${port_vl_re} vmpt=${port_vm_ws} hypt=${port_hy2} tupt=${port_tu} reym=${ym_vl_re} agn=${ARGO_DOMAIN} agk=${ARGO_AUTH} && bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/beta/argosb_pro.sh)" >> ~/.bashrc
COMMAND="asp"
SCRIPT_PATH="$HOME/bin/$COMMAND"
mkdir -p "$HOME/bin"
curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/beta/argosb_pro.sh > "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"

sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
source ~/.bashrc

crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/sbpid/d' /tmp/crontab.tmp
echo '@reboot /bin/bash -c "nohup ./aspro/sing-box run -c ./aspro/sb.json >/dev/null 2>&1 & echo "$!" > ./aspro/sbpid.log"' >> /tmp/crontab.tmp
sed -i '/sbargopid/d' /tmp/crontab.tmp
if [[ -n $argo ]]; then
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
echo '@reboot /bin/bash -c "nohup ./aspro/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat ./aspro/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 & pid=\$! && echo \$pid > ./aspro/sbargopid.log"' >> /tmp/crontab.tmp
else
echo '@reboot /bin/bash -c "nohup ./aspro/cloudflared tunnel --url http://localhost:$(grep "listen_port" ./aspro/sb.json | grep -oP '\d+' | sed -n '2p') --edge-ip-version auto --no-autoupdate --protocol http2 > ./aspro/argo.log 2>&1 & pid=\$! && echo \$pid > ./aspro/sbargopid.log"' >> /tmp/crontab.tmp
fi
fi
crontab /tmp/crontab.tmp 2>/dev/null
rm /tmp/crontab.tmp
echo "ArgoSB_PRO脚本进程启动成功，安装完毕" && sleep 2
else
echo "ArgoSB_PRO脚本进程未启动，安装失败" && exit
fi
}
cip(){
ipbest(){
serip=$(curl -s4m5 icanhazip.com -k || curl -s6m5 icanhazip.com -k)
if [[ "$serip" =~ : ]]; then
server_ip="[$serip]"
echo "$server_ip" > ./aspro/server_ip.log
else
server_ip="$serip"
echo "$server_ip" > ./aspro/server_ip.log
fi
}
ipchange(){
v4=$(curl -s4m5 icanhazip.com -k)
v6=$(curl -s6m5 icanhazip.com -k)
if [ "$ipsw" == "4" ]; then
if [ -z "$v4" ]; then
ipbest
else
server_ip="$v4"
echo "$server_ip" > ./aspro/server_ip.log
fi
elif [ "$ipsw" == "6" ]; then
if [ -z "$v6" ]; then
ipbest
else
server_ip="[$v6]"
echo "$server_ip" > ./aspro/server_ip.log
fi
else
ipbest
fi
}
warpcheck
if [[ ! $wgcfv4 =~ on|plus && ! $wgcfv6 =~ on|plus ]]; then
ipchange
else
systemctl stop wg-quick@wgcf >/dev/null 2>&1
kill -15 $(pgrep warp-go) >/dev/null 2>&1 && sleep 2
ipchange
systemctl start wg-quick@wgcf >/dev/null 2>&1
systemctl restart warp-go >/dev/null 2>&1
systemctl enable warp-go >/dev/null 2>&1
systemctl start warp-go >/dev/null 2>&1
fi
uuid=$(< ./aspro/uuid)
port_vl_re=$(< ./aspro/port_vl_re)
port_vm_ws=$(< ./aspro/port_vm_ws)
port_hy2=$(< ./aspro/port_hy2)
port_tu=$(< ./aspro/port_tu)
ym_vl_re=$(< ./aspro/ym_vl_re)
private_key=$(< ./aspro/private_key)
public_key=$(< ./aspro/public.key)
short_id=$(< ./aspro/short_id)
server_ip=$(< ./aspro/server_ip.log)
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key&sid=$short_id&type=tcp&headerType=none#vl-reality-$hostname"
echo "$vl_link" > ./aspro/jh.txt
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> ./aspro/jh.txt
hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&sni=www.bing.com#hy2-$hostname"
echo "$hy2_link" >> ./aspro/jh.txt
tuic5_link="tuic://$uuid:$uuid@$server_ip:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=www.bing.com&allow_insecure=1#tu5-$hostname"
echo "$tuic5_link" >> ./aspro/jh.txt
argodomain=$(cat ./aspro/sbargoym.log 2>/dev/null)
[[ -z "$argodomain" ]] && argodomain=$(grep -a trycloudflare.com ./aspro/argo.log 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [[ -n "$argodomain" ]]; then
vmatls_link1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-443\", \"add\": \"104.16.0.0\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link1" >> ./aspro/jh.txt
vmatls_link2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-8443\", \"add\": \"104.17.0.0\", \"port\": \"8443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link2" >> ./aspro/jh.txt
vmatls_link3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2053\", \"add\": \"104.18.0.0\", \"port\": \"2053\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link3" >> ./aspro/jh.txt
vmatls_link4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2083\", \"add\": \"104.19.0.0\", \"port\": \"2083\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link4" >> ./aspro/jh.txt
vmatls_link5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2087\", \"add\": \"104.20.0.0\", \"port\": \"2087\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link5" >> ./aspro/jh.txt
vmatls_link6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2096\", \"add\": \"[2606:4700::0]\", \"port\": \"2096\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link6" >> ./aspro/jh.txt
vma_link7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-80\", \"add\": \"104.21.0.0\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link7" >> ./aspro/jh.txt
vma_link8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8080\", \"add\": \"104.22.0.0\", \"port\": \"8080\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link8" >> ./aspro/jh.txt
vma_link9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8880\", \"add\": \"104.24.0.0\", \"port\": \"8880\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link9" >> ./aspro/jh.txt
vma_link10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2052\", \"add\": \"104.25.0.0\", \"port\": \"2052\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link10" >> ./aspro/jh.txt
vma_link11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2082\", \"add\": \"104.26.0.0\", \"port\": \"2082\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link11" >> ./aspro/jh.txt
vma_link12="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2086\", \"add\": \"104.27.0.0\", \"port\": \"2086\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link12" >> ./aspro/jh.txt
vma_link13="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2095\", \"add\": \"[2400:cb00:2049::]\", \"port\": \"2095\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link13" >> ./aspro/jh.txt
line5=$(sed -n '5p' aspro/jh.txt)
line10=$(sed -n '10p' aspro/jh.txt)
line11=$(sed -n '11p' aspro/jh.txt)
line17=$(sed -n '17p' aspro/jh.txt)
sbtk=$(cat ./aspro/sbargotoken.log 2>/dev/null)
if [ -n "$sbtk" ]; then
nametn="当前Argo固定隧道token：$sbtk"
fi
argoshow=$(echo -e "Vmess主协议端口(Argo固定隧道端口)：$port_vm_ws\n当前Argo$name域名：$argodomain\n$nametn\n\n1、443端口的vmess-ws-tls-argo节点，默认优选IPV4：104.16.0.0\n$line5\n\n2、2096端口的vmess-ws-tls-argo节点，默认优选IPV6：[2606:4700::]（本地网络支持IPV6才可用）\n$line10\n\n3、80端口的vmess-ws-argo节点，默认优选IPV4：104.21.0.0\n$line11\n\n4、2095端口的vmess-ws-argo节点，默认优选IPV6：[2400:cb00:2049::]（本地网络支持IPV6才可用）\n$line17\n")
fi
jh_txt=$(cat ./aspro/jh.txt)
cat > ./aspro/list.txt <<EOF
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
以下节点信息内容，请查看aspro/list.txt文件或者运行cat aspro/jh.txt进行复制
---------------------------------------------------------

节点配置输出：
【 vless-reality-vision 】节点信息如下：
$vl_link

【 vmess-ws 】节点信息如下：
$vm_link

【 Hysteria-2 】节点信息如下：
$hy2_link

【 Tuic-v5 】节点信息如下：
$tuic5_link

---------------------------------------------------------
$argoshow
---------------------------------------------------------
聚合节点信息，请查看aspro/jh.txt文件或者运行cat aspro/jh.txt进行复制
---------------------------------------------------------
相关快捷方式如下：
显示节点信息：asp或者脚本 list
双栈VPS显示IPv4节点配置：ip=4 asp或者脚本 cip
双栈VPS显示IPv6节点配置：ip=6 asp或者脚本 cip
卸载脚本：asp或者脚本 del
---------------------------------------------------------
---------------------------------------------------------
EOF
cat ./aspro/list.txt
}

if [[ "$1" == "del" ]]; then
kill -15 $(cat ./aspro/sbargopid.log 2>/dev/null) >/dev/null 2>&1
kill -15 $(cat ./aspro/sbpid.log 2>/dev/null) >/dev/null 2>&1
sed -i '/yonggekkk/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
source ~/.bashrc
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/sbpid/d' /tmp/crontab.tmp
sed -i '/sbargopid/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp 2>/dev/null
rm /tmp/crontab.tmp
rm -rf ./aspro ./bin/asp
echo "卸载完成"
exit
elif [[ "$1" == "list" ]]; then
cat ./aspro/list.txt
exit
elif [[ "$1" == "cip" ]]; then
cip && sleep 2
echo "配置切换完成" 
exit
fi

sbpid=$(cat ./aspro/sbpid.log 2>/dev/null) 
sbpidp=$(cat /proc/$sbpid/status 2>/dev/null)
if [ -z "$sbpidp" ] && ! ps -p "$sbpid" > /dev/null 2>&1; then
kill -15 $(cat ./aspro/sbargopid.log 2>/dev/null) >/dev/null 2>&1
kill -15 $(cat ./aspro/sbpid.log 2>/dev/null) >/dev/null 2>&1
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
echo "检查依赖安装……请稍等"
if ! command -v openssl >/dev/null 2>&1; then
if command -v apt-get >/dev/null 2>&1; then
apt-get update -y >/dev/null 2>&1
apt-get install -y openssl >/dev/null 2>&1
elif command -v yum >/dev/null 2>&1; then
yum install -y openssl >/dev/null 2>&1
elif command -v apk >/dev/null 2>&1; then
apk update >/dev/null 2>&1
apk add openssl >/dev/null 2>&1
fi
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "ArgoSB_PRO脚本未安装，开始安装…………" && sleep 2
ins
cip
echo
else
echo "ArgoSB_PRO脚本已安装"
echo "相关快捷方式如下："
echo "显示节点信息：asp或者脚本 list"
echo "双栈VPS显示IPv4节点配置：ip=4 asp或者脚本 cip"
echo "双栈VPS显示IPv6节点配置：ip=6 asp或者脚本 cip"
echo "卸载脚本：asp或者脚本 del"
exit
fi
