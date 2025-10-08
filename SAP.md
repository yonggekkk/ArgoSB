Argosbx在SAP平台部署代理节点，基于[eooce](https://github.com/eooce/Auto-deploy-sap-and-keepalive)相关功能现实，可用vless-ws-tls(cdn)、vmess-ws-argo-cdn、vmess-ws-tls-argo-cdn

Vless-ws-tls为默认安装，Argo固定或临时隧道为可选，也可使用workers/pages反代方式启用Vless-ws-tls的CDN替代Argo的CDN

SAP个人注册地址：https://www.sap.com/products/technology-platform/trial.html

* 方式一：[Github方式](https://github.com/yonggekkk/argosbx/blob/main/.github/workflows/main.yml)，请自建私库设置运行。安装启动同时进行，无定时保活

* 方式二：Docker方式，镜像地址：```ygkkk/sapsbx```，可在clawcloud爪云等docker平台上运行。安装启动同时进行，自带定时保活

* 方式三：VPS服务器方式。安装启动同时进行，自带定时保活

VPS服务器方式脚本地址：（再次进入快捷方式```bash sap.sh```）：

```curl -sSL https://raw.githubusercontent.com/yonggekkk/argosbx/main/sap.sh -o sap.sh && chmod +x sap.sh && bash sap.sh```

或者

```wget -q https://raw.githubusercontent.com/yonggekkk/argosbx/main/sap.sh -O sap.sh && chmod +x sap.sh && bash sap.sh```

----------------------------------------- 

* 变量设置说明
  
| 变量名称 | 变更值（多个之间空一格）| 是否必填  | 变量作用 |
| :----- | :-------- | :-------- | :--- |
| CF_USERNAMES | 单个或多个SAP账号邮箱  | 必填  | 登录账号 |
| CF_PASSWORDS | 单个或多个SAP密码  | 必填  | 登录密码 |
| REGIONS | 单个或多个地区变量代码 | 必填 | 登录实例地区 |
| UUIDS | 单个或多个UUID | 必填 | 代理协议UUID |
| APP_NAMES | 单个或多个应用程序名称 | 可选，留空则为地区码+邮箱 | 应用程序名称 |
| VMPTS | 单个或多个argo固定/临时隧道端口| 可选，留空则关闭argo隧道  | vmess主协议端口 |
| AGNS  | 单个或多个argo固定隧道域名 | 可选，留空则启用临时隧道  | 使用argo固定域名才需要 |
| AGKS | 单个或多个argo固定隧道token | 可选，留空则启用临时隧道  | 使用argo固定域名才需要 |
| DELAPP | 单个或多个应用程序名 | 优先独立执行 | 删除指定应用程序才需要，github或docker执行后务必还原留空状态 |


---------------------------------------

### REGIONS：地区变量代码表

#### 个人区专用：

| IP服务商 | 地区      | 国家城市  | 地区变量代码(大写) |
| :----- | :-------- | :-------- | :--- |
| Azure微软   | 亚洲      | 新加坡    | SG   |
| AWS亚马逊 | 北美      | 美国      | US   |


#### 企业区专用：

| IP服务商 | 地区      | 国家城市    | 地区变量代码(大写)    |
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
