Argosbx在SAP平台部署代理节点，基于[eooce](https://github.com/eooce/Auto-deploy-sap-and-keepalive)相关功能现实，可用vless-ws-tls(cdn)、vmess-ws-argo-cdn、vmess-ws-tls-argo-cdn

Vless-ws-tls为默认安装，Argo固定或临时隧道为可选，也可使用[workers/pages反代方式](https://github.com/yonggekkk/argosbx/blob/main/_worker.js)启用Vless-ws-tls的CDN替代Argo的CDN

SAP个人注册地址：https://www.sap.com/products/technology-platform/trial.html

----------------------------------------- 

#### 注意：目前以下三种方式的部署部分已不可用！！！

* 方式一：[Github方式](https://github.com/yonggekkk/argosbx/blob/main/.github/workflows/main.yml)，请自建私库设置运行。安装启动同时进行，无定时保活

* 方式二：Docker方式，镜像地址：```ygkkk/sapsbx```，可在clawcloud爪云等docker平台上运行。安装启动同时进行，自带8:10-9:00每5分钟的定时保活

* 方式三：VPS服务器方式。安装启动同时进行，支持自定义8:10-9:00定时保活时间段间隔

VPS服务器方式脚本地址：（再次进入快捷方式```bash sap.sh```）：

```curl -sSL https://raw.githubusercontent.com/yonggekkk/argosbx/main/sap.sh -o sap.sh && chmod +x sap.sh && bash sap.sh```

或者

```wget -q https://raw.githubusercontent.com/yonggekkk/argosbx/main/sap.sh -O sap.sh && chmod +x sap.sh && bash sap.sh```

----------------------------------------- 

#### 注意：以下三种方式仅支持保活！仅```CF_USERNAMES ``` ```CF_PASSWORDS``` ```REGIONS``` ```UUIDS```四个变量可用且为必填

* 方式一：[Github方式](https://github.com/yonggekkk/argosbx/blob/main/.github/workflows/mainh.yml)，请自建私库设置运行。仅适用手动保活

* 方式二：Docker方式，镜像地址：```ygkkk/sapsbxh```，可在clawcloud爪云等docker平台上运行。仅保活，自带8:10-9:00每5分钟的定时保活

* 方式三：VPS服务器方式。仅保活，支持自定义8:10-9:00定时保活时间段间隔

VPS服务器方式脚本地址：（再次进入快捷方式```bash saph.sh```）：

```curl -sSL https://raw.githubusercontent.com/yonggekkk/argosbx/main/saph.sh -o saph.sh && chmod +x saph.sh && bash saph.sh```

或者

```wget -q https://raw.githubusercontent.com/yonggekkk/argosbx/main/saph.sh -O saph.sh && chmod +x saph.sh && bash saph.sh```

----------------------------------------- 

* 变量设置说明：每个变量的多个账号需按顺序依次对应填写，多个之间空一格，多个中如有个别留空则填```no```代替
  
| 变量名称 | 变量值 | 是否必填 | 变量作用 |
| :----- | :-------- | :-------- | :--- |
| CF_USERNAMES | 单个或多个SAP账号邮箱  | 必填  | 登录账号 |
| CF_PASSWORDS | 单个或多个SAP密码  | 必填  | 登录密码 |
| REGIONS | 单个或多个地区变量代码 | 必填 | 登录实例地区 |
| UUIDS | 单个或多个UUID | 必填 | 代理协议UUID |
| APP_NAMES | 单个或多个应用程序app名称 | 可选，留空填```no```，则为地区码+邮箱 | 应用程序app名称 |
| VMPTS | 单个或多个argo固定/临时隧道端口| 可选，留空填```no```，则关闭argo隧道  | 启用argo固定/临时隧道时必填 |
| AGNS  | 单个或多个argo固定隧道域名 | 可选，留空填```no```，则启用临时隧道  | 使用argo固定域名时必填 |
| AGKS | 单个或多个argo固定隧道token | 可选，留空填```no```，则启用临时隧道  | 使用argo固定域名时必填 |
| DELAPP | 单个或多个应用程序名app | 优先独立执行 | 删除指定应用程序app，github或docker执行后务必还原留空状态 |


---------------------------------------

视频教程：[🔥SAP搭建免费节点一条龙教程：多平台多账号搭建+保活一次搞定，支持Argo/workers/pags多种CDN方式](https://youtu.be/NRYZNKWoLj8)

-----------------------------------------

 试用90天账户专区：

| IP服务商 | 地区      | 国家城市  | REGIONS地区变量代码(大写) |
| :----- | :-------- | :-------- | :--- |
| Azure微软   | 亚洲      | 新加坡    | SG   |
| AWS亚马逊 | 北美      | 美国      | US   |


 企业账户专区：

| IP服务商 | 地区      | 国家城市    | REGIONS地区变量代码(大写)    |
| :----- | :-------- | :---------- | :------ |
| AWS亚马逊 | 亚洲      | 澳大利亚-悉尼 | AU-A    |
| AWS亚马逊 | 亚洲      | 日本-东京    | JP-A    |
| AWS亚马逊 | 亚洲      | 新加坡      | SG-A    |
| AWS亚马逊 | 亚洲      | 韩国-首尔    | KR-A    |
| AWS亚马逊 | 北美      | 加拿大-蒙特利尔 | CA-A    |
| AWS亚马逊 | 北美      | 美国-弗吉尼亚 | US-V-A  |
| AWS亚马逊 | 北美      | 美国-俄勒冈   | US-O-A  |
| AWS亚马逊 | 南美      | 巴西-圣保罗   | BR-A    |
| AWS亚马逊 | 欧洲      | 德国-法兰克福 | DE-A    |
| Google谷歌   | 亚洲      | 澳大利亚-悉尼 | AU-G    |
| Google谷歌   | 亚洲      | 日本-大阪    | JP-O-G  |
| Google谷歌   | 亚洲      | 日本-东京    | JP-T-G  |
| Google谷歌   | 亚洲      | 印度-孟买    | IN-G    |
| Google谷歌   | 亚洲      | 以色列-特拉维夫 | IL-G    |
| Google谷歌   | 亚洲      | 沙特-达曼    | SA-G    |
| Google谷歌   | 北美      | 美国-爱荷华  | US-G    |
| Google谷歌   | 南美      | 巴西-圣保罗  | BR-G    |
| Google谷歌   | 欧洲      | 德国-法兰克福 | DE-G    |
| Azure微软   | 亚洲      | 澳大利亚-悉尼 | AU-M    |
| Azure微软   | 亚洲      | 日本-东京    | JP-M    |
| Azure微软   | 亚洲      | 新加坡      | SG-M    |
| Azure微软   | 北美      | 加拿大-多伦多 | CA-M    |
| Azure微软   | 北美      | 美国-弗吉尼亚 | US-V-M  |
| Azure微软   | 北美      | 美国-华盛顿   | US-W-M  |
| Azure微软   | 南美      | 巴西-圣保罗  | BR-M    |
| Azure微软   | 欧洲      | 荷兰-阿姆斯特丹 | NL-M    |
| SAP    | 亚洲      | 阿联酋-迪拜  | AE-N    |
| SAP    | 亚洲      | 沙特-利雅得  | SA-N    |
