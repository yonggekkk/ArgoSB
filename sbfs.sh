#!/bin/bash
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
echo "甬哥Github项目  ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "123"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

export uuid=${uuid:-'bc97f674-c578-4940-9234-0a1da46041b9'}
export port_vl_re=${vlpt:-'44444'}
export port_vm_ws=${vmpt:-'33333'}
export port_hy2=${hypt:-'22222'}
export port_tu=${tupt:-'11111'}
export ym_vl_re=${reym:-''}
export ARGO_DOMAIN=${agn:-''}   
export ARGO_AUTH=${agk:-''} 
export argo=${ag:-''}


hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[[ -z $(systemd-detect-virt 2>/dev/null) ]] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
aarch64) cpu=arm64;;
x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
mkdir -p ./nixag
if [[ "$1" == "del" ]]; then
kill -15 $(cat ./nixag/sbargopid.log 2>/dev/null) >/dev/null 2>&1
kill -15 $(cat ./nixag/sbpid.log 2>/dev/null) >/dev/null 2>&1
sed -i '/yonggekkk/d' ~/.bashrc 
source ~/.bashrc
rm -rf ./nixag 
exit
elif [[ "$1" == "list" ]]; then
if [[ -e ./nixag/list.txt ]]; then
argoname=$(cat ./nixag/sbargoym.log 2>/dev/null)
if [ -z $argoname ]; then
argodomain=$(cat ./nixag/argo.log 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [ -z $argodomain ]; then
echo "当前argo临时域名未生成" 
else
echo "当前argo最新临时域名：$argodomain"
fi
else
echo "当前argo固定域名：$argoname"
echo "当前argo固定域名token：$(cat ./nixag/sbargotoken.log 2>/dev/null)"
fi
cat ./nixag/list.txt
else
echo "ArgoSB脚本未安装"
fi
exit
fi


if [[ ! -e ./nixag/list.txt ]]; then
echo "检查依赖安装……请稍等"
if command -v apt &> /dev/null; then
apt update -y
apt install grep procps coreutils -y
elif command -v yum &> /dev/null; then
yum install grep procps-ng coreutils -y
elif command -v apk &> /dev/null; then
apk update -y
apk add grep procps coreutils -y
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "ArgoSB脚本未安装，开始安装…………" && sleep 2
echo
else
echo "ArgoSB脚本已安装"
exit
fi
curl -L -o ./nixag/sing-box  -# --retry 2 https://github.com/yonggekkk/ArgoSB/releases/download/singbox/sing-box-$cpu
chmod +x ./nixag/sing-box
for var in port_vl_re port_vm_ws port_hy2 port_tu; do
if [ -z "${!var}" ]; then
eval "$var=$(shuf -i 10000-65535 -n 1)"
fi
done
if [ -z $uuid ]; then
uuid=$(./nixag/sing-box generate uuid)
fi
if [ -z $ym_vl_re ]; then
ym_vl_re=www.yahoo.com
fi

openssl ecparam -genkey -name prime256v1 -out ./nixag/private.key
openssl req -new -x509 -days 36500 -key ./nixag/private.key -out cert.pem -subj "/CN=www.bing.com"
if [ ! -e ./nixag/private_key ]; then
key_pair=$(/./nixag/sing-box generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$(/./nixag/sing-box generate rand --hex 4)
echo "$private_key" > ./nixag/private_key
echo "$public_key" > ./nixag/public.key
echo "$short_id" > ./nixag/short_id
fi

echo "Vless-reality端口：$port_vl_re"
echo "Vmess-ws端口：$port_vm_ws"
echo "Hysteria-2端口：$port_hy2"
echo "Tuic-v5端口：$port_tu"
echo "当前uuid密码：$uuid"
echo "当前reality域名：$ym_vl_re"
echo "当前reality pr key：$private_key"
echo "当前reality pu key：$public_key"
echo "当前reality id：$short_id"

cat > ./nixag/sb.json <<EOF
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
                "certificate_path": "./nixag/cert.pem",
                "key_path": "./nixag/private.key"
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
            "certificate_path": "./nixag/cert.pem",
            "key_path": "./nixag/private.key"
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
                "certificate_path": "./nixag/cert.pem",
                "key_path": "./nixag/private.key"
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

nohup ./nixag/sing-box run -c ./nixag/sb.json >/dev/null 2>&1 & echo "$!" > ./nixag/sbpid.log
if [ -n $ag ]; then
if [ ! -e ./nixag/cloudflared ]; then
curl -L -o ./nixag/cloudflared -# --retry 2 https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu
chmod +x ./nixag/cloudflared
fi
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
name='固定'
nohup ./nixag/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH} >/dev/null 2>&1 & echo "$!" > ./nixag/sbargopid.log
echo ${ARGO_DOMAIN} > ./nixag/sbargoym.log
echo ${ARGO_AUTH} > ./nixag/sbargotoken.log
else
name='临时'
nohup ./nixag/cloudflared tunnel --url http://localhost:${port_vm_ws} --edge-ip-version auto --no-autoupdate --protocol http2 > ./nixag/argo.log 2>&1 &
echo "$!" > ./nixag/sbargopid.log
fi
echo "申请Argo$name隧道中……请稍等"
sleep 8
if [[ -n "${ARGO_DOMAIN}" && -n "${ARGO_AUTH}" ]]; then
argodomain=$(cat ./nixag/sbargoym.log 2>/dev/null)
nametn="当前Argo固定隧道token：$(cat ./nixag/sbargotoken.log 2>/dev/null)"
else
argodomain=$(cat ./nixag/argo.log 2>/dev/null | grep -a trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [[ -n $argodomain ]]; then
echo "Argo$name隧道申请成功，域名为：$argodomain"
else
echo "Argo$name隧道申请失败，请稍后再试"
fi
fi

private_key=$(< ./nixag/private_key)
public_key=$(< ./nixag/public.key)
short_id=$(< ./nixag/short_id)
server_ip=$(curl -s4m5 icanhazip.com -k)
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key&sid=$short_id&type=tcp&headerType=none#vl-reality-$hostname"
echo "$vl_link" > ./nixag/jh.txt
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> ./nixag/jh.txt
hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&sni=www.bing.com#hy2-$hostname"
echo "$hy2_link" >> ./nixag/jh.txt
tuic5_link="tuic://$uuid:$uuid@$server_ip:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=www.bing.com&allow_insecure=1#tu5-$hostname"
echo "$tuic5_link" >> ./nixag/jh.txt
if [[ -n $argodomain ]]; then
vmatls_link1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-443\", \"add\": \"104.16.0.0\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link1" >> ./nixag/jh.txt
vmatls_link2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-8443\", \"add\": \"104.17.0.0\", \"port\": \"8443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link2" >> ./nixag/jh.txt
vmatls_link3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2053\", \"add\": \"104.18.0.0\", \"port\": \"2053\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link3" >> ./nixag/jh.txt
vmatls_link4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2083\", \"add\": \"104.19.0.0\", \"port\": \"2083\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link4" >> ./nixag/jh.txt
vmatls_link5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2087\", \"add\": \"104.20.0.0\", \"port\": \"2087\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link5" >> ./nixag/jh.txt
vmatls_link6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-tls-argo-$hostname-2096\", \"add\": \"[2606:4700::]\", \"port\": \"2096\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link6" >> ./nixag/jh.txt
vma_link7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-80\", \"add\": \"104.21.0.0\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link7" >> ./nixag/jh.txt
vma_link8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8080\", \"add\": \"104.22.0.0\", \"port\": \"8080\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link8" >> ./nixag/jh.txt
vma_link9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-8880\", \"add\": \"104.24.0.0\", \"port\": \"8880\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link9" >> ./nixag/jh.txt
vma_link10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2052\", \"add\": \"104.25.0.0\", \"port\": \"2052\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link10" >> ./nixag/jh.txt
vma_link11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2082\", \"add\": \"104.26.0.0\", \"port\": \"2082\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link11" >> ./nixag/jh.txt
vma_link12="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2086\", \"add\": \"104.27.0.0\", \"port\": \"2086\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link12" >> ./nixag/jh.txt
vma_link13="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"vmess-ws-argo-$hostname-2095\", \"add\": \"[2400:cb00:2049::]\", \"port\": \"2095\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link13" >> ./nixag/jh.txt
line5=$(sed -n '5p' nixag/jh.txt)
line10=$(sed -n '10p' nixag/jh.txt)
line11=$(sed -n '11p' nixag/jh.txt)
line17=$(sed -n '17p' nixag/jh.txt)
argoshow=$(echo -e "Vmess主协议端口(Argo固定隧道端口)：$port_vm_ws\n当前Argo$name域名：$argodomain\n$nametn\n\n1、443端口的vmess-ws-tls-argo节点，默认优选IPV4：104.16.0.0\n$line5\n\n2、2096端口的vmess-ws-tls-argo节点，默认优选IPV6：[2606:4700::]（本地网络支持IPV6才可用）\n$line10\n\n3、80端口的vmess-ws-argo节点，默认优选IPV4：104.21.0.0\n$line11\n\n4、2095端口的vmess-ws-argo节点，默认优选IPV6：[2400:cb00:2049::]（本地网络支持IPV6才可用）\n$line17\n")
fi
jh_txt=$(cat ./nixag/jh.txt)
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/yonggekkk/d' ~/.bashrc
echo "export ag=${argo} {uuid=${uuid} vlpt=${port_vl_re} vmpt=${port_vm_ws} hypt=${port_hy2} tupt=${port_tu} reym=${ym_vl_re} agn=${ARGO_DOMAIN} agk=${ARGO_AUTH} && bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)" >> ~/.bashrc
source ~/.bashrc
echo "ArgoSB脚本安装完毕" && sleep 2

cat > ./nixag/list.txt <<EOF
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
以下节点信息内容，请查看nixag/list.txt文件或者运行cat nixag/jh.txt进行复制
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
聚合节点信息，请查看nixag/jh.txt文件或者运行cat nixag/jh.txt进行复制
---------------------------------------------------------
---------------------------------------------------------
EOF
cat ./nixag/list.txt
