#!/bin/sh
export LANG=en_US.UTF-8
[ -z "${vlpt+x}" ] || vlp=yes
[ -z "${vmpt+x}" ] || { vmp=yes; vmag=yes; } 
[ -z "${hypt+x}" ] || hyp=yes
[ -z "${tupt+x}" ] || tup=yes
[ -z "${xhpt+x}" ] || xhp=yes
[ -z "${anpt+x}" ] || anp=yes
[ -z "${sspt+x}" ] || ssp=yes
[ -z "${arpt+x}" ] || arp=yes
[ -z "${warp+x}" ] || wap=yes
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsb/(s|x)' || pgrep -f 'agsb/(s|x)' >/dev/null 2>&1; then
if [ "$1" = "rep" ]; then
[ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：rep重置协议时，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
else
[ "$1" = "del" ] || [ "$ssp" = yes ] || [ "$vlp" = yes ] || [ "$vmp" = yes ] || [ "$hyp" = yes ] || [ "$tup" = yes ] || [ "$xhp" = yes ] || [ "$anp" = yes ] || [ "$arp" = yes ] || { echo "提示：未安装ArgoSB脚本，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
export uuid=${uuid:-''}
export port_vl_re=${vlpt:-''}
export port_vm_ws=${vmpt:-''}
export port_hy2=${hypt:-''}
export port_tu=${tupt:-''}
export port_xh=${xhpt:-''}
export port_an=${anpt:-''}
export port_ar=${arpt:-''}
export port_ss=${sspt:-''}
export ym_vl_re=${reym:-''}
export cdnym=${cdnym:-''}
export argo=${argo:-''}
export ARGO_DOMAIN=${agn:-''}
export ARGO_AUTH=${agk:-''}
export ippz=${ippz:-''}
export warp=${warp:-''}
export name=${name:-''}
v46url="https://icanhazip.com"
agsburl="https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh"
showmode(){
echo "ArgoSB脚本项目地址：https://github.com/yonggekkk/ArgoSB"
echo "主脚本：bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) 或 bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)"
echo "显示节点信息命令：agsb list 【或者】 主脚本 list"
echo "更换代理协议变量组命令：自定义各种协议变量组 agsb rep 【或者】 自定义各种协议变量组 主脚本 rep"
echo "更新脚本命令：原已安装的自定义各种协议变量组 主脚本 rep"
echo "重启脚本命令：agsb res 【或者】 主脚本 res"
echo "卸载脚本命令：agsb del 【或者】 主脚本 del"
echo "双栈VPS显示IPv4节点配置命令：ippz=4 agsb list 【或者】 ippz=4 主脚本 list"
echo "双栈VPS显示IPv6节点配置命令：ippz=6 agsb list 【或者】 ippz=6 主脚本 list"
echo "---------------------------------------------------------"
echo
}
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "甬哥Github项目 ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "ArgoSB一键无交互小钢炮脚本💣"
echo "当前版本：V25.8.27"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[ -z "$(systemd-detect-virt 2>/dev/null)" ] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
aarch64) cpu=arm64;;
x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
mkdir -p "$HOME/agsb"
warpcheck(){
url="https://www.cloudflare.com/cdn-cgi/trace"
wgcfv6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 "$url") || (command -v wget >/dev/null 2>&1 && wget -6 --tries=2 -qO- "$url") | grep warp | cut -d= -f2 )
wgcfv4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 "$url") || (command -v wget >/dev/null 2>&1 && wget -4 --tries=2 -qO- "$url") | grep warp | cut -d= -f2 )
}
v4v6(){
v4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url") || (command -v wget >/dev/null 2>&1 && wget -4 --tries=2 -qO- "$v46url") )
v6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url") || (command -v wget >/dev/null 2>&1 && wget -6 --tries=2 -qO- "$v46url") )
}
warpsx(){
if [ -n "$name" ]; then
sxname=$name-
echo "$sxname" > "$HOME/agsb/name"
echo
echo "所有节点名称前缀：$name"
fi
v4v6
if echo "$v6" | grep -q '^2a09' || echo "$v4" | grep -q '^104.28'; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
echo; echo "请注意：你已安装了warp"
else
if [ "$wap" != yes ]; then
s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo
else
case "$warp" in
""|sx|xs) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s ) s1outtag=warp-out; s2outtag=warp-out; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6) s1outtag=warp-out; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
x ) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x4) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
x6) s1outtag=direct; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
s4x4|x4s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s4x6|x6s4) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
s6x4|x4s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
s6x6|x6s6) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0"'; wap=warp ;;
sx4|x4s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
sx6|x6s) s1outtag=warp-out; s2outtag=warp-out; x1outtag=warp-out; x2outtag=direct; xip='"::/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warp ;;
xs4|s4x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"0.0.0.0/0"'; wap=warp ;;
xs6|s6x) s1outtag=warp-out; s2outtag=direct; x1outtag=warp-out; x2outtag=warp-out; xip='"::/0", "0.0.0.0/0"'; sip='"::/0"'; wap=warp ;;
* ) s1outtag=direct; s2outtag=direct; x1outtag=direct; x2outtag=direct; xip='"::/0", "0.0.0.0/0"'; sip='"::/0", "0.0.0.0/0"'; wap=warpargo ;;
esac
fi
fi
case "$warp" in x4) wxryx='ForceIPv4' ;; x6) wxryx='ForceIPv6' ;; *) wxryx='ForceIPv4v6' ;; esac
case "$warp" in x4|x6|x) if command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url" >/dev/null || command -v wget >/dev/null 2>&1 && wget -6 --tries=2 -qO- "$v46url" >/dev/null; then xryx='ForceIPv4v6' sbyx='prefer_ipv4'; else xryx='ForceIPv4' sbyx='ipv4_only'; fi ;; *) xryx='ForceIPv4v6' sbyx='prefer_ipv4' ;; esac
}

insuuid(){
if [ -z "$uuid" ] && [ ! -e "$HOME/agsb/uuid" ]; then
if [ -e "$HOME/agsb/sing-box" ]; then
uuid=$("$HOME/agsb/sing-box" generate uuid)
else
uuid=$("$HOME/agsb/xray" uuid)
fi
echo "$uuid" > "$HOME/agsb/uuid"
elif [ -n "$uuid" ]; then
echo "$uuid" > "$HOME/agsb/uuid"
fi
uuid=$(cat "$HOME/agsb/uuid")
echo "UUID密码：$uuid"
}
installxray(){
echo
echo "=========启用xray内核========="
if [ ! -e "$HOME/agsb/xray" ]; then
url="https://github.com/yonggekkk/ArgoSB/releases/download/argosbx/xray-$cpu"; out="$HOME/agsb/xray"; (command -v curl >/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && wget -O "$out" --tries=2 "$url")
chmod +x "$HOME/agsb/xray"
sbcore=$("$HOME/agsb/xray" version 2>/dev/null | awk '/^Xray/{print $2}')
echo "已安装Xray正式版内核：$sbcore"
fi
cat > "$HOME/agsb/xr.json" <<EOF
{
  "log": {
    "access": "/dev/null",
    "error": "/dev/null",
    "loglevel": "none"
  },
  "inbounds": [
EOF
insuuid
if [ -n "$xhp" ] || [ -n "$vlp" ]; then
if [ -z "$ym_vl_re" ]; then
ym_vl_re=www.amd.com
fi
echo "$ym_vl_re" > "$HOME/agsb/ym_vl_re"
echo "Reality域名：$ym_vl_re"
mkdir -p "$HOME/agsb/xrk"
if [ ! -e "$HOME/agsb/xrk/private_key" ]; then
key_pair=$("$HOME/agsb/xray" x25519)
private_key=$(echo "$key_pair" | head -1 | awk '{print $3}')
public_key=$(echo "$key_pair" | tail -n 1 | awk '{print $3}')
short_id=$(date +%s%N | sha256sum | cut -c 1-8)
echo "$private_key" > "$HOME/agsb/xrk/private_key"
echo "$public_key" > "$HOME/agsb/xrk/public_key"
echo "$short_id" > "$HOME/agsb/xrk/short_id"
fi
private_key_x=$(cat "$HOME/agsb/xrk/private_key")
public_key_x=$(cat "$HOME/agsb/xrk/public_key")
short_id_x=$(cat "$HOME/agsb/xrk/short_id")
fi
if [ -n "$xhp" ]; then
xhp=xhpt
if [ -z "$port_xh" ] && [ ! -e "$HOME/agsb/port_xh" ]; then
port_xh=$(shuf -i 10000-65535 -n 1)
echo "$port_xh" > "$HOME/agsb/port_xh"
elif [ -n "$port_xh" ]; then
echo "$port_xh" > "$HOME/agsb/port_xh"
fi
port_xh=$(cat "$HOME/agsb/port_xh")
echo "Vless-xhttp-reality端口：$port_xh"
cat >> "$HOME/agsb/xr.json" <<EOF
    {
      "tag":"xhttp-reality",
      "listen": "::",
      "port": ${port_xh},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "xhttp",
        "security": "reality",
        "realitySettings": {
          "fingerprint": "chrome",
          "target": "${ym_vl_re}:443",
          "serverNames": [
            "${ym_vl_re}"
          ],
          "privateKey": "$private_key_x",
          "shortIds": ["$short_id_x"]
        },
        "xhttpSettings": {
          "host": "",
          "path": "${uuid}-xh",
          "mode": "auto"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"],
        "metadataOnly": false
      }
    },
EOF
else
xhp=xhptargo
fi
if [ -n "$vlp" ]; then
vlp=vlpt
if [ -z "$port_vl_re" ] && [ ! -e "$HOME/agsb/port_vl_re" ]; then
port_vl_re=$(shuf -i 10000-65535 -n 1)
echo "$port_vl_re" > "$HOME/agsb/port_vl_re"
elif [ -n "$port_vl_re" ]; then
echo "$port_vl_re" > "$HOME/agsb/port_vl_re"
fi
port_vl_re=$(cat "$HOME/agsb/port_vl_re")
echo "Vless-reality-vision端口：$port_vl_re"
cat >> "$HOME/agsb/xr.json" <<EOF
        {
            "tag":"reality-vision",
            "listen": "::",
            "port": $port_vl_re,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "fingerprint": "chrome",
                    "dest": "${ym_vl_re}:443",
                    "serverNames": [
                      "${ym_vl_re}"
                    ],
                    "privateKey": "$private_key_x",
                    "shortIds": ["$short_id_x"]
                }
            },
          "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls", "quic"],
          "metadataOnly": false
      }
    },  
EOF
else
vlp=vlptargo
fi
if [ -n "$ssp" ]; then
ssp=sspt
if [ ! -e "$HOME/agsb/sskey" ]; then
sskey=$(head -c 16 /dev/urandom | base64 -w0)
echo "$sskey" > "$HOME/agsb/sskey"
fi
if [ -z "$port_ss" ] && [ ! -e "$HOME/agsb/port_ss" ]; then
port_ss=$(shuf -i 10000-65535 -n 1)
echo "$port_ss" > "$HOME/agsb/port_ss"
elif [ -n "$port_ss" ]; then
echo "$port_ss" > "$HOME/agsb/port_ss"
fi
sskey=$(cat "$HOME/agsb/sskey")
port_ss=$(cat "$HOME/agsb/port_ss")
echo "Shadowsocks-2022端口：$port_ss"
cat >> "$HOME/agsb/xr.json" <<EOF
        {
            "tag":"ss-2022",
            "listen": "::",
            "port": $port_ss,
            "protocol": "shadowsocks",
                "settings": {
                "method": "2022-blake3-aes-128-gcm",
                "password": "$sskey",
                "network": "tcp,udp"
        },
          "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls", "quic"],
          "metadataOnly": false
      }
    },  
EOF
else
ssp=ssptargo
fi
}

installsb(){
echo
echo "=========启用Sing-box内核========="
if [ ! -e "$HOME/agsb/sing-box" ]; then
url="https://github.com/yonggekkk/ArgoSB/releases/download/argosbx/sing-box-$cpu"; out="$HOME/agsb/sing-box"; (command -v curl>/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && wget -O "$out" --tries=2 "$url")
chmod +x "$HOME/agsb/sing-box"
sbcore=$("$HOME/agsb/sing-box" version 2>/dev/null | awk '/version/{print $NF}')
echo "已安装Sing-box正式版内核：$sbcore"
fi
cat > "$HOME/agsb/sb.json" <<EOF
{
"log": {
    "disabled": false,
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
EOF
insuuid
command -v openssl >/dev/null 2>&1 && openssl ecparam -genkey -name prime256v1 -out "$HOME/agsb/private.key" >/dev/null 2>&1
command -v openssl >/dev/null 2>&1 && openssl req -new -x509 -days 36500 -key "$HOME/agsb/private.key" -out "$HOME/agsb/cert.pem" -subj "/CN=www.bing.com" >/dev/null 2>&1
if [ ! -f "$HOME/agsb/private.key" ]; then
url="https://github.com/yonggekkk/ArgoSB/releases/download/argosbx/private.key"; out="$HOME/agsb/private.key"; (command -v curl>/dev/null 2>&1 && curl -Ls -o "$out" --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && wget -q -O "$out" --tries=2 "$url")
url="https://github.com/yonggekkk/ArgoSB/releases/download/argosbx/cert.pem"; out="$HOME/agsb/cert.pem"; (command -v curl>/dev/null 2>&1 && curl -Ls -o "$out" --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && wget -q -O "$out" --tries=2 "$url")
fi
if [ -n "$hyp" ]; then
hyp=hypt
if [ -z "$port_hy2" ] && [ ! -e "$HOME/agsb/port_hy2" ]; then
port_hy2=$(shuf -i 10000-65535 -n 1)
echo "$port_hy2" > "$HOME/agsb/port_hy2"
elif [ -n "$port_hy2" ]; then
echo "$port_hy2" > "$HOME/agsb/port_hy2"
fi
port_hy2=$(cat "$HOME/agsb/port_hy2")
echo "Hysteria2端口：$port_hy2"
cat >> "$HOME/agsb/sb.json" <<EOF
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
            "certificate_path": "$HOME/agsb/cert.pem",
            "key_path": "$HOME/agsb/private.key"
        }
    },
EOF
else
hyp=hyptargo
fi
if [ -n "$tup" ]; then
tup=tupt
if [ -z "$port_tu" ] && [ ! -e "$HOME/agsb/port_tu" ]; then
port_tu=$(shuf -i 10000-65535 -n 1)
echo "$port_tu" > "$HOME/agsb/port_tu"
elif [ -n "$port_tu" ]; then
echo "$port_tu" > "$HOME/agsb/port_tu"
fi
port_tu=$(cat "$HOME/agsb/port_tu")
echo "Tuic端口：$port_tu"
cat >> "$HOME/agsb/sb.json" <<EOF
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
                "certificate_path": "$HOME/agsb/cert.pem",
                "key_path": "$HOME/agsb/private.key"
            }
        },
EOF
else
tup=tuptargo
fi
if [ -n "$anp" ]; then
anp=anpt
if [ -z "$port_an" ] && [ ! -e "$HOME/agsb/port_an" ]; then
port_an=$(shuf -i 10000-65535 -n 1)
echo "$port_an" > "$HOME/agsb/port_an"
elif [ -n "$port_an" ]; then
echo "$port_an" > "$HOME/agsb/port_an"
fi
port_an=$(cat "$HOME/agsb/port_an")
echo "Anytls端口：$port_an"
cat >> "$HOME/agsb/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anytls-sb",
            "listen":"::",
            "listen_port":${port_an},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls":{
                "enabled": true,
                "certificate_path": "$HOME/agsb/cert.pem",
                "key_path": "$HOME/agsb/private.key"
            }
        },
EOF
else
anp=anptargo
fi
if [ -n "$arp" ]; then
arp=arpt
if [ -z "$ym_vl_re" ]; then
ym_vl_re=www.amd.com
fi
echo "$ym_vl_re" > "$HOME/agsb/ym_vl_re"
echo "Reality域名：$ym_vl_re"
mkdir -p "$HOME/agsb/sbk"
if [ ! -e "$HOME/agsb/sbk/private_key" ]; then
key_pair=$("$HOME/agsb/sing-box" generate reality-keypair)
private_key=$(echo "$key_pair" | awk '/PrivateKey/ {print $2}' | tr -d '"')
public_key=$(echo "$key_pair" | awk '/PublicKey/ {print $2}' | tr -d '"')
short_id=$("$HOME/agsb/sing-box" generate rand --hex 4)
echo "$private_key" > "$HOME/agsb/sbk/private_key"
echo "$public_key" > "$HOME/agsb/sbk/public_key"
echo "$short_id" > "$HOME/agsb/sbk/short_id"
fi
private_key_s=$(cat "$HOME/agsb/sbk/private_key")
public_key_s=$(cat "$HOME/agsb/sbk/public_key")
short_id_s=$(cat "$HOME/agsb/sbk/short_id")
if [ -z "$port_ar" ] && [ ! -e "$HOME/agsb/port_ar" ]; then
port_ar=$(shuf -i 10000-65535 -n 1)
echo "$port_ar" > "$HOME/agsb/port_ar"
elif [ -n "$port_ar" ]; then
echo "$port_ar" > "$HOME/agsb/port_ar"
fi
port_ar=$(cat "$HOME/agsb/port_ar")
echo "Any-Reality端口：$port_ar"
cat >> "$HOME/agsb/sb.json" <<EOF
        {
            "type":"anytls",
            "tag":"anyreality-sb",
            "listen":"::",
            "listen_port":${port_ar},
            "users":[
                {
                  "password":"${uuid}"
                }
            ],
            "padding_scheme":[],
            "tls": {
            "enabled": true,
            "server_name": "${ym_vl_re}",
             "reality": {
              "enabled": true,
              "handshake": {
              "server": "${ym_vl_re}",
              "server_port": 443
             },
             "private_key": "$private_key_s",
             "short_id": ["$short_id_s"]
            }
          }
        },
EOF
else
arp=arptargo
fi
}

xrsbvm(){
if [ -n "$vmp" ]; then
vmp=vmpt
if [ -z "$port_vm_ws" ] && [ ! -e "$HOME/agsb/port_vm_ws" ]; then
port_vm_ws=$(shuf -i 10000-65535 -n 1)
echo "$port_vm_ws" > "$HOME/agsb/port_vm_ws"
elif [ -n "$port_vm_ws" ]; then
echo "$port_vm_ws" > "$HOME/agsb/port_vm_ws"
fi
port_vm_ws=$(cat "$HOME/agsb/port_vm_ws")
echo "Vmess-ws端口：$port_vm_ws"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsb/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
if [ -e "$HOME/agsb/xray" ]; then
cat >> "$HOME/agsb/xr.json" <<EOF
        {
            "tag": "vmess-xr",
            "listen": "::",
            "port": ${port_vm_ws},
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                  "path": "${uuid}-vm"
            }
        },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }, 
EOF
else
cat >> "$HOME/agsb/sb.json" <<EOF
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
        }
    },
EOF
fi
else
vmp=vmptargo
fi
}

xrsbout(){
if [ -e "$HOME/agsb/xr.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsb/xr.json"
cat >> "$HOME/agsb/xr.json" <<EOF
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
      "domainStrategy":"${xryx}"
     }
    },
    {
      "tag": "x-warp-out",
      "protocol": "wireguard",
      "settings": {
        "secretKey": "COAYqKrAXaQIGL8+Wkmfe39r1tMMR80JWHVaF443XFQ=",
        "address": [
          "172.16.0.2/32",
          "2606:4700:110:8eb1:3b27:e65e:3645:97b0/128"
        ],
        "peers": [
          {
            "publicKey": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
            "allowedIPs": [
              "0.0.0.0/0",
              "::/0"
            ],
            "endpoint": "${xendip}:2408"
          }
        ],
        "reserved": [134, 63, 85]
        }
    },
    {
      "tag":"warp-out",
      "protocol":"freedom",
        "settings":{
        "domainStrategy":"${wxryx}"
       },
       "proxySettings":{
       "tag":"x-warp-out"
     }
}
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "type": "field",
        "ip": [ ${xip} ],
        "network": "tcp,udp",
        "outboundTag": "${x1outtag}"
      },
      {
        "type": "field",
        "network": "tcp,udp",
        "outboundTag": "${x2outtag}"
      }
    ]
  }
}
EOF
nohup "$HOME/agsb/xray" run -c "$HOME/agsb/xr.json" >/dev/null 2>&1 &
fi
if [ -e "$HOME/agsb/sb.json" ]; then
sed -i '${s/,\s*$//}' "$HOME/agsb/sb.json"
cat >> "$HOME/agsb/sb.json" <<EOF
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "endpoints": [
    {
      "type": "wireguard",
      "tag": "warp-out",
      "address": [
        "172.16.0.2/32",
        "2606:4700:110:8eb1:3b27:e65e:3645:97b0/128"
      ],
      "private_key": "COAYqKrAXaQIGL8+Wkmfe39r1tMMR80JWHVaF443XFQ=",
      "peers": [
        {
          "address": "${sendip}",
          "port": 2408,
          "public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
          "allowed_ips": [
            "0.0.0.0/0",
            "::/0"
          ],
          "reserved": [134, 63, 85]
        }
      ]
    }
  ],
  "route": {
    "rules": [
       {
          "action": "sniff"
        },
       {
        "action": "resolve",
         "strategy": "${sbyx}"
       },
      {
        "ip_cidr": [ ${sip} ],         
        "outbound": "${s1outtag}"
      }
    ],
    "final": "${s2outtag}"
  }
}
EOF
nohup "$HOME/agsb/sing-box" run -c "$HOME/agsb/sb.json" >/dev/null 2>&1 &
fi
}
killstart(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsb/c|/agsb/s|/agsb/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'agsb/s' 2>/dev/null) $(pgrep -f 'agsb/c' 2>/dev/null) $(pgrep -f 'agsb/x' 2>/dev/null) >/dev/null 2>&1
nohup $HOME/agsb/sing-box run -c $HOME/agsb/sb.json >/dev/null 2>&1 &
nohup $HOME/agsb/xray run -c $HOME/agsb/xr.json >/dev/null 2>&1 &
if [ -e "$HOME/agsb/sbargotoken.log" ]; then
nohup $HOME/agsb/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsb/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &
else
if [ -e "$HOME/agsb/xr.json" ] && [ -e "$HOME/agsb/argo.log" ]; then
nohup $HOME/agsb/cloudflared tunnel --url http://localhost:$(grep -A2 vmess-xr $HOME/agsb/xr.json | tail -1 | tr -cd 0-9) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsb/argo.log 2>&1 &
elif [ -e "$HOME/agsb/sb.json" ] && [ -e "$HOME/agsb/argo.log" ]; then
nohup $HOME/agsb/cloudflared tunnel --url http://localhost:$(grep -A2 vmess-sb $HOME/agsb/sb.json | tail -1 | tr -cd 0-9) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsb/argo.log 2>&1 &
fi
fi
sleep 6
}
ins(){
if [ "$hyp" != yes ] && [ "$tup" != yes ] && [ "$anp" != yes ] && [ "$arp" != yes ]; then
installxray
xrsbvm
warpsx
xrsbout
hyp="hyptargo"; tup="tuptargo"; anp="anptargo"; arp="arptargo"
elif [ "$xhp" != yes ] && [ "$vlp" != yes ] && [ "$ssp" != yes ]; then
installsb
xrsbvm
warpsx
xrsbout
xhp="xhptargo"; vlp="vlptargo"; ssp="ssptargo"
else
installsb
installxray
xrsbvm
warpsx
xrsbout
fi
if [ -n "$argo" ] && [ -n "$vmag" ]; then
echo
echo "=========启用Cloudflared-argo内核========="
if [ ! -e "$HOME/agsb/cloudflared" ]; then
argocore=$({ command -v curl >/dev/null 2>&1 && curl -Ls https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared || wget -qO- https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared; } | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Cloudflared-argo最新正式版内核：$argocore"
url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu"; out="$HOME/agsb/cloudflared"; (command -v curl>/dev/null 2>&1 && curl -Lo "$out" -# --retry 2 "$url") || (command -v wget>/dev/null 2>&1 && wget -O "$out" --tries=2 "$url")
chmod +x "$HOME/agsb/cloudflared"
fi
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
name='固定'
nohup "$HOME/agsb/cloudflared" tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "${ARGO_AUTH}" >/dev/null 2>&1 &
echo "${ARGO_DOMAIN}" > "$HOME/agsb/sbargoym.log"
echo "${ARGO_AUTH}" > "$HOME/agsb/sbargotoken.log"
else
name='临时'
nohup "$HOME/agsb/cloudflared" tunnel --url http://localhost:"${port_vm_ws}" --edge-ip-version auto --no-autoupdate --protocol http2 > "$HOME/agsb/argo.log" 2>&1 &
fi
echo "申请Argo$name隧道中……请稍等"
sleep 8
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
argodomain=$(cat "$HOME/agsb/sbargoym.log" 2>/dev/null)
else
argodomain=$(grep -a trycloudflare.com "$HOME/agsb/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [ -n "${argodomain}" ]; then
echo "Argo$name隧道申请成功"
else
echo "Argo$name隧道申请失败，请稍后再试"
fi
fi
echo
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsb/(s|x)' || pgrep -f 'agsb/(s|x)' >/dev/null 2>&1 ; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/yonggekkk/d' ~/.bashrc
echo "if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsb/(s|x)' && ! pgrep -f 'agsb/(s|x)' >/dev/null 2>&1; then echo '检测到系统可能中断过，或者变量格式错误？建议在SSH对话框输入 reboot 重启下服务器。现在自动执行ArgoSB脚本的节点恢复操作，请稍等……'; sleep 6; export cdnym=\"${cdnym}\" name=\"${name}\" ippz=\"${ippz}\" argo=\"${argo}\" uuid=\"${uuid}\" $wap=\"${warp}\" $xhp=\"${port_xh}\" $ssp=\"${port_ss}\" $anp=\"${port_an}\" $arp=\"${port_ar}\" $vlp=\"${port_vl_re}\" $vmp=\"${port_vm_ws}\" $hyp=\"${port_hy2}\" $tup=\"${port_tu}\" reym=\"${ym_vl_re}\" agn=\"${ARGO_DOMAIN}\" agk=\"${ARGO_AUTH}\"; bash <(command -v curl >/dev/null 2>&1 && curl -Ls "$agsburl" || wget -qO- "$agsburl"); fi" >> ~/.bashrc
COMMAND="agsb"
SCRIPT_PATH="$HOME/bin/$COMMAND"
mkdir -p "$HOME/bin"
(command -v curl >/dev/null 2>&1 && curl -sL "$agsburl" -o "$SCRIPT_PATH") || (command -v wget >/dev/null 2>&1 && wget -qO "$SCRIPT_PATH" "$agsburl")
chmod +x "$SCRIPT_PATH"
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsb\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsb\/xray/d' /tmp/crontab.tmp
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsb/s' || pgrep -f 'agsb/s' >/dev/null 2>&1 ; then
echo '@reboot /bin/sh -c "nohup $HOME/agsb/sing-box run -c $HOME/agsb/sb.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsb/x' || pgrep -f 'agsb/x' >/dev/null 2>&1 ; then
echo '@reboot /bin/sh -c "nohup $HOME/agsb/xray run -c $HOME/agsb/xr.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
fi
sed -i '/agsb\/cloudflared/d' /tmp/crontab.tmp
if [ -n "$argo" ] && [ -n "$vmag" ]; then
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
echo '@reboot /bin/sh -c "nohup $HOME/agsb/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsb/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
else
if [ -e "$HOME/agsb/xray" ]; then
echo '@reboot /bin/sh -c "nohup $HOME/agsb/cloudflared tunnel --url http://localhost:$(grep -A2 vmess-xr $HOME/agsb/xr.json | tail -1 | tr -cd 0-9) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsb/argo.log 2>&1 &"' >> /tmp/crontab.tmp
else
echo '@reboot /bin/sh -c "nohup $HOME/agsb/cloudflared tunnel --url http://localhost:$(grep -A2 vmess-sb $HOME/agsb/sb.json | tail -1 | tr -cd 0-9) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsb/argo.log 2>&1 &"' >> /tmp/crontab.tmp
fi
fi
fi
crontab /tmp/crontab.tmp 2>/dev/null
rm /tmp/crontab.tmp
echo "ArgoSB脚本进程启动成功，安装完毕" && sleep 2
else
echo "ArgoSB脚本进程未启动，安装失败" && exit
fi
}
cip(){
ipbest(){
serip=$( (command -v curl >/dev/null 2>&1 && (curl -s4m5 -k "$v46url" || curl -s6m5 -k "$v46url") ) || (command -v wget >/dev/null 2>&1 && (wget -4 -qO- --tries=2 "$v46url" || wget -6 -qO- --tries=2 "$v46url") ) )
if echo "$serip" | grep -q ':'; then
server_ip="[$serip]"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
else
server_ip="$serip"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
fi
}
ipchange(){
v4v6
if [ -z "$v4" ]; then
vps_ipv4='无IPV4'
vps_ipv6="$v6"
elif [ -n "$v4" ] && [ -n "$v6" ]; then
vps_ipv4="$v4"
vps_ipv6="$v6"
else
vps_ipv4="$v4"
vps_ipv6='无IPV6'
fi
if echo "$v6" | grep -q '^2a09'; then
w6="【WARP】"
fi
if echo "$v4" | grep -q '^104.28'; then
w4="【WARP】"
fi
echo
echo "=========当前服务器本地IP情况========="
echo "本地IPV4地址：$vps_ipv4 $w4"
echo "本地IPV6地址：$vps_ipv6 $w6"
echo
sleep 2
if [ "$ippz" = "4" ]; then
if [ -z "$v4" ]; then
ipbest
else
server_ip="$v4"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
fi
elif [ "$ippz" = "6" ]; then
if [ -z "$v6" ]; then
ipbest
else
server_ip="[$v6]"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
fi
else
ipbest
fi
}
warpcheck
if ! echo "$wgcfv4" | grep -qE 'on|plus' && ! echo "$wgcfv6" | grep -qE 'on|plus'; then
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
rm -rf "$HOME/agsb/jh.txt"
uuid=$(cat "$HOME/agsb/uuid")
server_ip=$(cat "$HOME/agsb/server_ip.log")
sxname=$(cat "$HOME/agsb/name" 2>/dev/null)
vmcdnym=$(cat "$HOME/agsb/cdnym" 2>/dev/null)
echo "*********************************************************"
echo "*********************************************************"
echo "ArgoSB脚本输出节点配置如下："
echo
case "$server_ip" in
104.28*|\[2a09*) echo "检测到有WARP的IP作为客户端地址 (104.28或者2a09开头的IP)，请把客户端地址上的WARP的IP手动更换为VPS本地IPV4或者IPV6地址" && sleep 3 ;;
esac
echo
if [ -e "$HOME/agsb/xray" ]; then
ym_vl_re=$(cat "$HOME/agsb/ym_vl_re" 2>/dev/null)
private_key_x=$(cat "$HOME/agsb/xrk/private_key" 2>/dev/null)
public_key_x=$(cat "$HOME/agsb/xrk/public_key" 2>/dev/null)
short_id_x=$(cat "$HOME/agsb/xrk/short_id" 2>/dev/null)
sskey=$(cat "$HOME/agsb/sskey" 2>/dev/null)
fi
if [ -e "$HOME/agsb/sing-box" ]; then
ym_vl_re=$(cat "$HOME/agsb/ym_vl_re" 2>/dev/null)
private_key_s=$(cat "$HOME/agsb/sbk/private_key" 2>/dev/null)
public_key_s=$(cat "$HOME/agsb/sbk/public_key" 2>/dev/null)
short_id_s=$(cat "$HOME/agsb/sbk/short_id" 2>/dev/null)
fi
if grep xhttp-reality "$HOME/agsb/xr.json" >/dev/null 2>&1; then
echo "💣【 vless-xhttp-reality 】节点信息如下："
port_xh=$(cat "$HOME/agsb/port_xh")
vl_xh_link="vless://$uuid@$server_ip:$port_xh?encryption=none&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=xhttp&path=$uuid-xh&mode=auto#${sxname}vl-xhttp-reality-$hostname"
echo "$vl_xh_link" >> "$HOME/agsb/jh.txt"
echo "$vl_xh_link"
echo
fi
if grep reality-vision "$HOME/agsb/xr.json" >/dev/null 2>&1; then
echo "💣【 vless-reality-vision 】节点信息如下："
port_vl_re=$(cat "$HOME/agsb/port_vl_re")
vl_link="vless://$uuid@$server_ip:$port_vl_re?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_x&sid=$short_id_x&type=tcp&headerType=none#${sxname}vl-reality-vision-$hostname"
echo "$vl_link" >> "$HOME/agsb/jh.txt"
echo "$vl_link"
echo
fi
if grep ss-2022 "$HOME/agsb/xr.json" >/dev/null 2>&1; then
echo "💣【 Shadowsocks-2022 】节点信息如下："
port_ss=$(cat "$HOME/agsb/port_ss")
ss_link="ss://$(echo -n "2022-blake3-aes-128-gcm:$sskey@$server_ip:$port_ss" | base64 -w0)#${sxname}Shadowsocks-2022-$hostname"
echo "$ss_link" >> "$HOME/agsb/jh.txt"
echo "$ss_link"
echo
fi
if grep vmess-xr "$HOME/agsb/xr.json" >/dev/null 2>&1 || grep vmess-sb "$HOME/agsb/sb.json" >/dev/null 2>&1; then
echo "💣【 vmess-ws 】节点信息如下："
port_vm_ws=$(cat "$HOME/agsb/port_vm_ws")
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> "$HOME/agsb/jh.txt"
echo "$vm_link"
echo
if [ -f "$HOME/agsb/cdnym" ]; then
echo "💣【 vmess-ws 】80系CDN或者回源CDN节点信息如下："
echo "注：优选IP地址或者端口可自行手动修改"
vm_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-cdn-$hostname\", \"add\": \"104.16.0.0\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$vmcdnym\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_cdn_link" >> "$HOME/agsb/jh.txt"
echo "$vm_cdn_link"
echo
fi
fi
if grep anytls-sb "$HOME/agsb/sb.json" >/dev/null 2>&1; then
echo "💣【 AnyTLS 】节点信息如下："
port_an=$(cat "$HOME/agsb/port_an")
an_link="anytls://$uuid@$server_ip:$port_an?insecure=1&allowInsecure=1#${sxname}anytls-$hostname"
echo "$an_link" >> "$HOME/agsb/jh.txt"
echo "$an_link"
echo
fi
if grep anyreality-sb "$HOME/agsb/sb.json" >/dev/null 2>&1; then
echo "💣【 Any-Reality 】节点信息如下："
port_ar=$(cat "$HOME/agsb/port_ar")
ar_link="anytls://$uuid@$server_ip:$port_ar?security=reality&sni=$ym_vl_re&fp=chrome&pbk=$public_key_s&sid=$short_id_s&type=tcp&headerType=none#${sxname}any-reality-$hostname"
echo "$ar_link" >> "$HOME/agsb/jh.txt"
echo "$ar_link"
echo
fi
if grep hy2-sb "$HOME/agsb/sb.json" >/dev/null 2>&1; then
echo "💣【 Hysteria2 】节点信息如下："
port_hy2=$(cat "$HOME/agsb/port_hy2")
hy2_link="hysteria2://$uuid@$server_ip:$port_hy2?security=tls&alpn=h3&insecure=1&sni=www.bing.com#${sxname}hy2-$hostname"
echo "$hy2_link" >> "$HOME/agsb/jh.txt"
echo "$hy2_link"
echo
fi
if grep tuic5-sb "$HOME/agsb/sb.json" >/dev/null 2>&1; then
echo "💣【 Tuic 】节点信息如下："
port_tu=$(cat "$HOME/agsb/port_tu")
tuic5_link="tuic://$uuid:$uuid@$server_ip:$port_tu?congestion_control=bbr&udp_relay_mode=native&alpn=h3&sni=www.bing.com&allow_insecure=1&allowInsecure=1#${sxname}tuic-$hostname"
echo "$tuic5_link" >> "$HOME/agsb/jh.txt"
echo "$tuic5_link"
echo
fi
argodomain=$(cat "$HOME/agsb/sbargoym.log" 2>/dev/null)
[ -z "$argodomain" ] && argodomain=$(grep -a trycloudflare.com "$HOME/agsb/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [ -n "$argodomain" ]; then
vmatls_link1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-443\", \"add\": \"104.16.0.0\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link1" >> "$HOME/agsb/jh.txt"
vmatls_link2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-8443\", \"add\": \"104.17.0.0\", \"port\": \"8443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link2" >> "$HOME/agsb/jh.txt"
vmatls_link3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2053\", \"add\": \"104.18.0.0\", \"port\": \"2053\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link3" >> "$HOME/agsb/jh.txt"
vmatls_link4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2083\", \"add\": \"104.19.0.0\", \"port\": \"2083\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link4" >> "$HOME/agsb/jh.txt"
vmatls_link5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2087\", \"add\": \"104.20.0.0\", \"port\": \"2087\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link5" >> "$HOME/agsb/jh.txt"
vmatls_link6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2096\", \"add\": \"[2606:4700::0]\", \"port\": \"2096\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link6" >> "$HOME/agsb/jh.txt"
vma_link7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-80\", \"add\": \"104.21.0.0\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link7" >> "$HOME/agsb/jh.txt"
vma_link8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-8080\", \"add\": \"104.22.0.0\", \"port\": \"8080\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link8" >> "$HOME/agsb/jh.txt"
vma_link9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-8880\", \"add\": \"104.24.0.0\", \"port\": \"8880\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link9" >> "$HOME/agsb/jh.txt"
vma_link10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2052\", \"add\": \"104.25.0.0\", \"port\": \"2052\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link10" >> "$HOME/agsb/jh.txt"
vma_link11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2082\", \"add\": \"104.26.0.0\", \"port\": \"2082\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link11" >> "$HOME/agsb/jh.txt"
vma_link12="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2086\", \"add\": \"104.27.0.0\", \"port\": \"2086\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link12" >> "$HOME/agsb/jh.txt"
vma_link13="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2095\", \"add\": \"[2400:cb00:2049::0]\", \"port\": \"2095\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link13" >> "$HOME/agsb/jh.txt"
sbtk=$(cat "$HOME/agsb/sbargotoken.log" 2>/dev/null)
if [ -n "$sbtk" ]; then
nametn="当前Argo固定隧道token：$sbtk"
fi
argoshow=$(echo -e "Vmess主协议端口(Argo固定隧道端口)：$port_vm_ws\n当前Argo$name域名：$argodomain\n$nametn\n\n1、💣443端口的vmess-ws-tls-argo节点\n$vmatls_link1\n\n2、💣80端口的vmess-ws-argo节点\n$vma_link7\n")
fi
echo "---------------------------------------------------------"
echo "$argoshow"
echo "---------------------------------------------------------"
echo "聚合节点信息，请查看$HOME/agsb/jh.txt文件或者运行cat $HOME/agsb/jh.txt进行复制"
echo "---------------------------------------------------------"
echo "相关快捷方式如下：(首次安装成功后需重连SSH，agsb快捷方式才可生效)"
showmode
}
cleandel(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsb/c|/agsb/s|/agsb/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null && echo "Killed $PID ($TARGET)" || echo "Could not kill $PID ($TARGET)"; fi; fi; done
kill -15 $(pgrep -f 'agsb/s' 2>/dev/null) $(pgrep -f 'agsb/c' 2>/dev/null) $(pgrep -f 'agsb/x' 2>/dev/null) >/dev/null 2>&1
sed -i '/yonggekkk/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsb\/sing-box/d' /tmp/crontab.tmp
sed -i '/agsb\/xray/d' /tmp/crontab.tmp
sed -i '/agsb\/cloudflared/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp 2>/dev/null
rm /tmp/crontab.tmp
rm -rf  "$HOME/bin/agsb"
}
if [ "$1" = "del" ]; then
cleandel
rm -rf "$HOME/agsb"
echo "卸载完成"
echo "欢迎继续使用甬哥侃侃侃ygkkk的ArgoSB一键无交互小钢炮脚本💣"
echo
showmode
exit
elif [ "$1" = "rep" ]; then
cleandel
rm -rf "$HOME/agsb"/{sb.json,xr.json,sbargoym.log,sbargotoken.log,argo.log,cdnym}
echo "ArgoSB重置协议完成，开始更新相关协议变量……" && sleep 3
echo
elif [ "$1" = "list" ]; then
cip
exit
elif [ "$1" = "res" ]; then
killstart
sleep 5
echo "重启完成"
exit
fi
if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -Eq 'agsb/(s|x)' && ! pgrep -f 'agsb/(s|x)' >/dev/null 2>&1; then
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsb/c|/agsb/s|/agsb/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null && echo "Killed $PID ($TARGET)" || echo "Could not kill $PID ($TARGET)"; fi; fi; done
kill -15 $(pgrep -f 'agsb/s' 2>/dev/null) $(pgrep -f 'agsb/c' 2>/dev/null) $(pgrep -f 'agsb/x' 2>/dev/null) >/dev/null 2>&1
v4orv6(){
if [ -z "$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url") || (command -v wget >/dev/null 2>&1 && wget -4 -qO- --tries=2 "$v46url") )" ]; then
echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf
fi
if [ -n "$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url") || (command -v wget >/dev/null 2>&1 && wget -6 -qO- --tries=2 "$v46url") )" ]; then
sendip="2606:4700:d0::a29f:c001"
xendip="[2606:4700:d0::a29f:c001]"
else
sendip="162.159.192.1"
xendip="162.159.192.1"
fi
}
warpcheck
if ! echo "$wgcfv4" | grep -qE 'on|plus' && ! echo "$wgcfv6" | grep -qE 'on|plus'; then
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
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "ArgoSB脚本未安装，开始安装…………" && sleep 2
setenforce 0 >/dev/null 2>&1
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1
iptables -F >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
ins
cip
echo
else
echo "ArgoSB脚本已安装"
echo
echo "相关快捷方式如下："
showmode
exit
fi
