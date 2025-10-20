#!/bin/bash
export LANG=en_US.UTF-8
if ! command -v cf8 >/dev/null 2>&1; then
if command -v apk >/dev/null 2>&1; then
    apk add --no-cache curl tar bash
    curl -L "https://github.com/cloudfoundry/cli/releases/download/v8.16.0/cf8-cli_8.16.0_linux_x86-64.tgz" | tar -xz -C /usr/local/bin
    chmod +x /usr/local/bin/cf8
elif command -v apt >/dev/null 2>&1; then
    apt-get update && apt-get install -y wget gnupg
    wget -qO- https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloudfoundry-cli-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloudfoundry-cli-archive-keyring.gpg] https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list > /dev/null
    apt-get update && apt-get install -y cf8-cli
else
    echo "脚本仅支持Alpine、Debian、Ubuntu系统"
    exit 1
fi
fi

if command -v apt >/dev/null 2>&1; then
if ! dpkg -l tzdata >/dev/null 2>&1; then
    apt-get update -y >/dev/null 2>&1 && apt-get install -y tzdata >/dev/null 2>&1
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime >/dev/null 2>&1
fi
elif command -v apk >/dev/null 2>&1; then
if ! apk info | grep tzdata >/dev/null 2>&1; then
    apk add --no-cache tzdata >/dev/null 2>&1
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime >/dev/null 2>&1
    echo "Asia/Shanghai" > /etc/timezone >/dev/null 2>&1
fi
fi

if ! command -v crond >/dev/null 2>&1; then
if command -v apk >/dev/null 2>&1; then
   apk add --no-cache cronie >/dev/null 2>&1
   rc-update add crond >/dev/null 2>&1 && rc-service crond start >/dev/null 2>&1
fi
elif ! command -v cron >/dev/null 2>&1; then
if command -v apt >/dev/null 2>&1; then
   apt-get update -y >/dev/null 2>&1 && apt-get install -y cron >/dev/null 2>&1
fi
fi

echo "*************************************"
echo "中国时间 $(date): SAP开始执行任务"
echo "运行cat $HOME/sap.log查看最近一次定时执行日志"
echo "*************************************"
# 设置区=====================================================================

# 必填！每个账号邮箱空一格
CF_USERNAMES=""

# 必填！每个账号对应密码空一格
CF_PASSWORDS=""

# 必填！每个账号对应地区空一格
REGIONS=""

# 必填！每个账号对应UUID空一格
UUIDS=""

# 8-9点保活时间间隔，单位：分钟
crontime=5

# 设置区=====================================================================

echo "*****************************************************"
echo "*****************************************************"
echo "甬哥Github项目  ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "Argosbx小钢炮脚本-SAP多账户自动保活脚本【VPS】"
echo "版本：V25.10.19"
echo "*****************************************************"
echo "*****************************************************"
read -ra CF_USERNAMES <<< "$CF_USERNAMES"
read -ra CF_PASSWORDS <<< "$CF_PASSWORDS"
read -ra REGIONS <<< "$REGIONS"
read -ra UUIDS <<< "$UUIDS"
jbpath=$(readlink -f "$0")
crontab -l 2>/dev/null > /tmp/crontab.tmp
sed -i "\|$jbpath|d" /tmp/crontab.tmp
echo "10-59/${crontime} 8 * * * /bin/bash $jbpath > $HOME/sap.log 2>&1" >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp
pushout(){
if echo "$push_out" | grep -iq "insufficient"; then
echo "🔴第 $((i+1)) 个实例部署：$apps 失败了，SAP资源被人抢光了，明早8:15-9:00再来吧，再见！！"
return 1
elif echo "$push_out" | grep -q "mapped"; then
echo "🔴第 $((i+1)) 个实例部署：$apps 失败了，请更换应用程序APP名称：$apps，再运行一次"
return 1
elif echo "$push_out" | grep -q "FAILED"; then
echo "🔴第 $((i+1)) 个实例部署：$apps 失败了，SAP繁忙中！请自查参数设置是否有误，后台实例是否超配额"
return 1
else
echo "$apps 完成"
return 0
fi
}
result(){
ROUTE=$(cf app "$apps" | grep "routes:" | awk '{print $2}')
url="https://$ROUTE/$UUID"
if curl -s "$url" | grep -iq "requested"; then
echo "🔴 $apps SAP创建失败，SAP资源被人抢光了，明早8:10-9:00再来吧，再见！！"
return 1
else
echo "🚀第 $((i+1)) 个实例部署成功"
echo "🟢实例名称: $apps"
echo "🟢服务器地区: $REGION"
echo "🌐点击打开代理节点的链接网址🔗: https://$ROUTE/$UUID"
echo
return 0
fi
}
for i in "${!CF_USERNAMES[@]}"; do
set +e
CF_EMAIL="${CF_USERNAMES[$i]}"
CF_PASSWORD="${CF_PASSWORDS[$i]}"
REGION="${REGIONS[$i]}"
UUID="${UUIDS[$i]}"
case "$REGION" in
SG) CF_API="https://api.cf.ap21.hana.ondemand.com" ;;
US) CF_API="https://api.cf.us10-001.hana.ondemand.com" ;;
AU-A) CF_API="https://api.cf.ap10.hana.ondemand.com" ;;
BR-A) CF_API="https://api.cf.br10.hana.ondemand.com" ;;
KR-A) CF_API="https://api.cf.ap12.hana.ondemand.com" ;;
CA-A) CF_API="https://api.cf.ca10.hana.ondemand.com" ;;
US-V-A) CF_API="https://api.cf.us10-001.hana.ondemand.com" ;;
US-O-A) CF_API="https://api.cf.us11.hana.ondemand.com" ;;
DE-A) CF_API="https://api.cf.eu10-005.hana.ondemand.com" ;;
JP-A) CF_API="https://api.cf.jp10.hana.ondemand.com" ;;
SG-A) CF_API="https://api.cf.ap11.hana.ondemand.com" ;;
AU-G) CF_API="https://api.cf.ap30.hana.ondemand.com" ;;
BR-G) CF_API="https://api.cf.br30.hana.ondemand.com" ;;
US-G) CF_API="https://api.cf.us30.hana.ondemand.com" ;;
DE-G) CF_API="https://api.cf.eu30.hana.ondemand.com" ;;
JP-O-G) CF_API="https://api.cf.jp30.hana.ondemand.com" ;;
JP-T-G) CF_API="https://api.cf.jp31.hana.ondemand.com" ;;
IL-G) CF_API="https://api.cf.il30.hana.ondemand.com" ;;
IN-G) CF_API="https://api.cf.in30.hana.ondemand.com" ;;
SA-G) CF_API="https://api.cf.sa31.hana.ondemand.com" ;;
AU-M) CF_API="https://api.cf.ap20.hana.ondemand.com" ;;
BR-M) CF_API="https://api.cf.br20.hana.ondemand.com" ;;
CA-M) CF_API="https://api.cf.ca20.hana.ondemand.com" ;;
US-V-M) CF_API="https://api.cf.us21.hana.ondemand.com" ;;
US-W-M) CF_API="https://api.cf.us20.hana.ondemand.com" ;;
NL-M) CF_API="https://api.cf.eu20-001.hana.ondemand.com" ;;
JP-M) CF_API="https://api.cf.jp20.hana.ondemand.com" ;;
SG-M) CF_API="https://api.cf.ap21.hana.ondemand.com" ;;
AE-N) CF_API="https://api.cf.neo-ae1.hana.ondemand.com" ;;
SA-N) CF_API="https://api.cf.neo-sa1.hana.ondemand.com" ;;            
*) echo "未知区域: $REGION"; continue ;;
esac
echo "=============================================="
echo "=========第 $((i+1)) 个实例开始启动============"
echo "=============================================="
cf login -a "$CF_API" -u "$CF_EMAIL" -p "$CF_PASSWORD"
ORG=$(cf orgs | sed -n '4p')
SPACE=$(cf spaces | sed -n '4p')
cf target -o "$ORG" -s "$SPACE"
echo "🔐 登录 SAP Cloud Foundry"
apps=$(cf apps | awk 'NR>3 {print $1}' | grep -v '^$')
ROUTE=$(cf app "$apps" | grep "routes:" | awk '{print $2}')
if [ -n "$ROUTE" ]; then
url="https://$ROUTE/$UUID"
if curl -s "$url" | grep -iq "vless"; then
echo "✅ $apps 正在运行中，跳过执行。"
result
continue
else
echo "🟡$apps 已部署，但未启动，现重启……"
push_out="$(timeout 180 cf restart "$apps" 2>&1)"
pushout
if [ $? -ne 0 ]; then
continue
fi
result
continue
fi
else
echo "🔴$apps 部署未成功，请自查参数设置是否有误，空间是否被删除"
fi
done
