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

# 选填！每个账号对应的应用程序名称APP空一格，不填则每个实例都自动生成，多个账号中有个别账号自动生成填no
APP_NAMES=""

# 选填！当使用Argo固定/临时隧道时，此端口变量必填，每个账号对应端口空一格，不填则每个实例都不启用argo，多个账号中有个别账号不启用填no
VMPTS="" 

# 选填！Argo固定隧道域名，每个账号对应域名空一格，不填则每个实例都启用argo临时隧道，多个账号中有个别账号不启用填no
AGNS="" 

# 选填！Argo固定隧道token，每个账号对应token空一格，不填则每个实例都启用argo临时隧道，多个账号中有个别账号不启用填no
AGKS=""

# 8-9点保活时间间隔，单位：分钟
crontime=5

# 设置区=====================================================================

# 优先独立执行！删除账户内的APP名称，多个APP空一格，执行后务必还原留空状态：DELAPP="" 
DELAPP=""

echo "*****************************************************"
echo "*****************************************************"
echo "甬哥Github项目  ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "Argosbx小钢炮脚本-SAP多账户自动部署并保活脚本【VPS】"
echo "版本：V25.10.5"
echo "*****************************************************"
echo "*****************************************************"
read -ra CF_USERNAMES <<< "$CF_USERNAMES"
read -ra CF_PASSWORDS <<< "$CF_PASSWORDS"
read -ra REGIONS <<< "$REGIONS"
read -ra UUIDS <<< "$UUIDS"
read -ra APP_NAMES <<< "$APP_NAMES"
read -ra VMPTS <<< "$VMPTS"
read -ra AGNS <<< "$AGNS"
read -ra AGKS <<< "$AGKS"
jbpath=$(readlink -f "$0")
crontab -l 2>/dev/null > /tmp/crontab.tmp
sed -i "\|$jbpath|d" /tmp/crontab.tmp
echo "10-59/${crontime} 8 * * * /bin/bash $jbpath > $HOME/sap.log 2>&1" >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp
pushout() {
  if echo "$push_out" | grep -iq "insufficient"; then
    echo "🔴第 $((i+1)) 个实例部署：${APP_NAME} 失败了，SAP资源被人抢光了，明早8:10-9:00再来吧，再见！！"
    return 1
  elif echo "$push_out" | grep -q "mapped"; then
    echo "🔴第 $((i+1)) 个实例部署：${APP_NAME} 失败了，请更换应用程序APP名称：${APP_NAME}，再运行一次"
    return 1
  elif echo "$push_out" | grep -q "FAILED"; then
    echo "🔴第 $((i+1)) 个实例部署：${APP_NAME} 失败了，SAP繁忙中！请自查参数设置是否有误，空间是否被删除"
    return 1
  else
    echo "${APP_NAME} 完成"
    return 0
  fi
}
sapcfevn() {
  cf set-env "$APP_NAME" uuid "$UUID"
  if [ -n "$VMPT" ]; then
    cf set-env "$APP_NAME" agn "$AGN"
    cf set-env "$APP_NAME" agk "$AGK"
    cf set-env "$APP_NAME" vmpt "$VMPT"
    cf set-env "$APP_NAME" argo "y"
  fi
  ROUTE=$(cf app "$APP_NAME" | grep "routes:" | awk '{print $2}')
  cf set-env "$APP_NAME" DOMAIN "$ROUTE"
}
result() {
  ROUTE=$(cf app "$APP_NAME" | grep "routes:" | awk '{print $2}')
  url="https://$ROUTE/$UUID"
  if curl -s "$url" | grep -iq "requested"; then
  echo "🔴 ${APP_NAME} SAP创建失败，SAP资源被人抢光了，明早8:10-9:00再来吧，再见！！"
  return 1
  else
  echo "🚀第 $((i+1)) 个实例部署成功"
  echo "🟢实例名称: $APP_NAME"
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
  APP_NAME="${APP_NAMES[$i]}"
  VMPT="${VMPTS[$i]}"
  AGN="${AGNS[$i]}"
  AGK="${AGKS[$i]}"
  [ "$APP_NAME" = "no" ] && APP_NAME=""
  [ "$VMPT" = "no" ] && VMPT=""
  [ "$AGN" = "no" ] && AGN=""
  [ "$AGK" = "no" ] && AGK=""
  case "$REGION" in
    SG) CF_API="https://api.cf.ap21.hana.ondemand.com"; serv="sg" ;;
    US) CF_API="https://api.cf.us10-001.hana.ondemand.com"; serv="us" ;;
    AU-A) CF_API="https://api.cf.ap10.hana.ondemand.com"; serv="au-a" ;;
    BR-A) CF_API="https://api.cf.br10.hana.ondemand.com"; serv="br-a" ;;
    KR-A) CF_API="https://api.cf.ap12.hana.ondemand.com"; serv="us-a" ;;
    CA-A) CF_API="https://api.cf.ca10.hana.ondemand.com"; serv="us-a" ;;
    US-V-A) CF_API="https://api.cf.us10-001.hana.ondemand.com"; serv="us-v-a" ;;
    US-O-A) CF_API="https://api.cf.us11.hana.ondemand.com"; serv="us-o-a" ;;
    DE-A) CF_API="https://api.cf.eu10-005.hana.ondemand.com"; serv="de-a" ;;
    JP-A) CF_API="https://api.cf.jp10.hana.ondemand.com"; serv="jp-a" ;;
    SG-A) CF_API="https://api.cf.ap11.hana.ondemand.com"; serv="sg-a" ;;
    AU-G) CF_API="https://api.cf.ap30.hana.ondemand.com"; serv="au-g" ;;
    BR-G) CF_API="https://api.cf.br30.hana.ondemand.com"; serv="br-g" ;;
    US-G) CF_API="https://api.cf.us30.hana.ondemand.com"; serv="us-g" ;;
    DE-G) CF_API="https://api.cf.eu30.hana.ondemand.com"; serv="de-g" ;;
    JP-O-G) CF_API="https://api.cf.jp30.hana.ondemand.com"; serv="jp-o-g" ;;
    JP-T-G) CF_API="https://api.cf.jp31.hana.ondemand.com"; serv="jp-t-g" ;;
    IL-G) CF_API="https://api.cf.il30.hana.ondemand.com"; serv="il-g" ;;
    IN-G) CF_API="https://api.cf.in30.hana.ondemand.com"; serv="in-g" ;;
    SA-G) CF_API="https://api.cf.sa31.hana.ondemand.com"; serv="sa-g" ;;
    AU-M) CF_API="https://api.cf.ap20.hana.ondemand.com"; serv="au-m" ;;
    BR-M) CF_API="https://api.cf.br20.hana.ondemand.com"; serv="br-m" ;;
    CA-M) CF_API="https://api.cf.ca20.hana.ondemand.com"; serv="ca-m" ;;
    US-V-M) CF_API="https://api.cf.us21.hana.ondemand.com"; serv="us-v-m" ;;
    US-W-M) CF_API="https://api.cf.us20.hana.ondemand.com"; serv="us-w-m" ;;
    NL-M) CF_API="https://api.cf.eu20-001.hana.ondemand.com"; serv="nl-m" ;;
    JP-M) CF_API="https://api.cf.jp20.hana.ondemand.com"; serv="jp-m" ;;
    SG-M) CF_API="https://api.cf.ap21.hana.ondemand.com"; serv="sg-m" ;;
    AE-N) CF_API="https://api.cf.neo-ae1.hana.ondemand.com"; serv="ae-n" ;;
    SA-N) CF_API="https://api.cf.neo-sa1.hana.ondemand.com"; serv="sa-n" ;;
    *) echo "未知区域: $REGION"; continue ;;
  esac
  if [ -z "$APP_NAME" ]; then
    APP_NAME="sap-$serv-${CF_EMAIL//[^a-zA-Z0-9_-]/-}"
  else
    APP_NAME="${APP_NAME//[^a-zA-Z0-9_-]/-}"
  fi
  echo "=============================================="
  echo "=========第 $((i+1)) 个实例开始启动============"
  echo "=============================================="
  cf login -a "$CF_API" -u "$CF_EMAIL" -p "$CF_PASSWORD"
  ORG=$(cf orgs | sed -n '4p')
  SPACE=$(cf spaces | sed -n '4p')
  cf target -o "$ORG" -s "$SPACE"
  echo "🔐 登录 SAP Cloud Foundry"
  if [ -n "$DELAPP" ]; then
  for app in $DELAPP; do
  cf delete "$app" -r -f
  done
  else
  ROUTE=$(cf app "$APP_NAME" | grep "routes:" | awk '{print $2}')
  if [ -n "$ROUTE" ]; then
    url="https://$ROUTE/$UUID"
    if curl -s "$url" | grep -iq "vless"; then
      echo "✅ ${APP_NAME} SAP正在运行中，跳过执行。"
      result
      continue
    else
      echo "🟡${APP_NAME} 已部署，但未启动，现重启……"
      sapcfevn
      push_out="$(cf restart "$APP_NAME" 2>&1)"
      echo "$push_out"
      pushout
      if [ $? -ne 0 ]; then
        continue
      fi
      result
      continue
    fi
  else
    echo "🟡${APP_NAME} 未部署，开始部署……"
    push_out="$(cf push "$APP_NAME" --docker-image ygkkk/argosbx -m 512M --health-check-type port 2>&1)"
    echo "$push_out"
    pushout
    if [ $? -ne 0 ]; then
      continue
    fi
    sapcfevn
    cf restage "$APP_NAME"
    cf app "$APP_NAME"
    result
  fi
  fi
done
