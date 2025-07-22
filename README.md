## ArgoSB一键无交互小钢炮脚本💣【当前版本：V25.7.15】

<img width="636" height="238" alt="0cbc3f82134b4fc99afd6cee37e98be" src="https://github.com/user-attachments/assets/a76ca418-badb-4e9a-a771-6682ec713e06" />

#### 1、基于Sing-box + Xray + Cloudflared-Argo 三内核自动分配

#### 2、支持Docker Image镜像部署，公开镜像库：```ygkkk/argosb```

#### 3、SSH脚本主打极简轻便，几乎无需依赖，支持非root，兼容所有主流VPS系统

#### 4、支持NIX容器系统，特别推荐IDX-Google、Clawcloud爪云类的服务器

#### 5、指定内核可选Wireguard-WARP全局出站模式，更换落地IP为WARP的IP

#### 6、所有代理协议都无需域名，选择自由度高，支持单个或多个代理协议任意组合
【目前支持：AnyTLS、Vless-xhttp-reality、Vless-reality-vision、Vmess-ws、Hy2、Tuic、Argo临时/固定隧道】

#### 7、如需要多样的功能，推荐使用VPS专用四合一脚本[Sing-box-yg](https://github.com/yonggekkk/sing-box-yg)

----------------------------------------------------------

### 一、自定义变量参数说明：

| 变量意义 | 变量名称| 变量值""填写| 删除变量 | 变量值""留空 | 变量要求及说明 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1、启用vless-reality-vision | vlpt | 端口指定 | 关闭vless-reality-vision | 端口随机 | 必选之一 【xray内核：TCP】 |
| 2、启用vless-xhttp-reality | xhpt | 端口指定 | 关闭vless-xhttp-reality | 端口随机 | 必选之一 【xray内核：TCP】 |
| 3、启用anytls | anpt | 端口指定 | 关闭anytls | 端口随机 | 必选之一 【singbox内核：TCP】 |
| 4、启用vmess-ws | vmpt | 端口指定 | 关闭vmess-ws | 端口随机 | 必选之一 【xray/singbox内核：TCP】 |
| 5、启用hy2 | hypt | 端口指定 | 关闭hy2 | 端口随机 | 必选之一 【singbox内核：UDP】 |
| 6、启用tuic | tupt | 端口指定 | 关闭tuic | 端口随机 | 必选之一 【singbox内核：UDP】 |
| 7、warp开关 | warp | 填写s或者x | 关闭warp | 所有内核协议启用warp | 可选，s表示singbox所有协议启用warp，x表示xray所有协议启用warp |
| 8、argo开关 | argo | 填写y | 关闭argo隧道 | 关闭argo隧道 | 可选，填写y时，vmess变量vmpt必须启用 |
| 9、argo固定隧道域名 | agn | 解析在CF上的域名 | 使用临时隧道 | 使用临时隧道 | 可选，argo填写y才可激活固定隧道|
| 10、argo固定隧道token | agk | CF获取的ey开头的token | 使用临时隧道 | 使用临时隧道 | 可选，argo填写y才可激活固定隧道 |
| 11、uuid密码 | uuid | 符合uuid规定格式 | 随机生成 | 随机生成 | 可选 |
| 12、reality域名（仅支持reality类协议） | reym | 符合reality域名规定 | yahoo | yahoo | 可选，使用CF类域名时，可用作ProxyIP/客户端地址反代IP（建议高位端口或纯IPV6下使用，以防被扫泄露）|
| 13、切换ipv4或ipv6配置 | ip | 填写4或者6 | 自动识别IP配置 | 自动识别IP配置 | 可选，4表示IPV4配置输出，6表示IPV6配置输出 |
| 14、【仅容器类docker】监听端口，网页查询 | PORT | 端口指定 | 3000 | 3000 | 可选 |
| 15、【仅容器类docker】启用vless-ws-tls | DOMAIN | 服务器域名 | 关闭vless-ws-tls | 关闭vless-ws-tls | 可选，vless-ws-tls可独立存在，uuid变量必须启用 |


![f776f1b3b1e0ebe9a537baf8660a387](https://github.com/user-attachments/assets/b9b357de-85b8-4270-aa87-2f50d63d672e)


#### 使用```ygkkk/argosb```镜像注意：

1、uuid变量建议都加上，重启后uuid将保持不变

2、点击restart重启，即可自动更新镜像，但reality协议相关key会被重置，需重新导出reality节点

3、argo临时隧道重启后，临时域名会变，需重新导出argo节点，固定隧道则不变

4、xray/sing-box/argo三内核同时运行会触发某些docker容器限制，出现报错，建议最多同时运行两个内核

#### 使用VPS注意：

1、uuid留空随机生成后，重启后uuid将保持不变

2、更新脚本只能卸载重装，建议留存带变量的脚本，方便快速重装

3、argo临时隧道重启后，临时域名会变，需重新导出argo节点，固定隧道则不变

4、如果已安装了warp脚本，这将与argosb内置warp冲突，两者必须选其一

----------------------------------------------------------

### 二、SSH一键变量脚本模版说明：

脚本以 ```变量名称="变量值"的单个或多个组合 + bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)``` 的形式运行，一次回车即可快速安装

必选其一的协议端口变量：```vmpt=""```、```vlpt=""```、```xhpt=""```、```anpt=""```、```hypt=""```、```tupt=""```

可选功能型变量：```warp=""```、```uuid=""```、```reym=""```、```argo=""```、```agn=""```、```agk=""```、```ip=""```

注意：请参考```一、自定义变量参数说明```中变量的作用说明，变量值填写在""之间，变量之间空一格，不用的变量可以删除

----------------------------------------------------------

### 三、SSH一键脚本的三类组合推荐：

#### 1：仅Argo临时/固定隧道

类似无公网的IDX-Google-VPS容器推荐使用此脚本，快速一键内网穿透获取节点

仅argo临时隧道节点
```
vmpt="" argo="y" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

仅argo固定隧道节点，必须填写端口(vmpt)、域名(agn)、token(agk)
```
vmpt="端口" argo="y" agn="解析的CF域名" agk="CF获取的token" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

#### 2：单协议，主流UPD协议或者TCP协议单独运行

Vless-Reality-Vision协议节点
```
vlpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Vless-Xhttp-Reality协议节点
```
xhpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

AnyTLS协议节点
```
anpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Vmess-ws协议节点
```
vmpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Hy2协议节点
```
hypt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Tuic协议节点
```
tupt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

#### 3：全协议共存 + Argo临时/固定隧道
```
vlpt="" vmpt="" hypt="" tupt="" xhpt="" anpt="" argo="y" agn="" agk="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

---------------------------------------------------------

### 四、SSH快捷方式 (首次安装成功后需重连SSH，agsb快捷方式才可生效)：

 1、查看Argo的固定域名、固定隧道的token、临时域名、当前已安装的节点信息：

```agsb list``` 或者 ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) list```

 2、在线切换IPV4/IPV6节点配置 (双栈VPS专享)：

显示IPV4节点配置：

```ip=4 agsb list```或者```ip=4 bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) list```

显示IPV6节点配置：

```ip=6 agsb list```或者```ip=6 bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) list```

 3、重启脚本：

```agsb res``` 或者 ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) res```

 4、卸载脚本：

```agsb del``` 或者 ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) del```

----------------------------------------------------------


#### 相关教程可参考甬哥博客，视频教程如下：

最新推荐：[Clawcloud爪云、IDX Google VPS的福音：解决服务器IP访问困扰！Argosb脚本新增WARP出站功能，轻松更换落地IP为Cloudflare WARP IP](https://youtu.be/HO_XLBmIYJw)

[Claw.cloud免费VPS搭建代理最终教程（五）：ArgoSB脚本docker镜像更新支持AnyTLS、Xhttp-Reality](https://youtu.be/-mhZIhHRyno)

[Claw.cloud免费VPS搭建代理最终教程（四）：最低仅1美分，4套价格+7组协议的套餐组合任你选；查看节点、重启升级、更换IP、更改配置的操作说明](https://youtu.be/xOQV_E1-C84)

[Claw.cloud免费VPS搭建代理最终教程（三）：ArgoSB全能docker镜像发布，支持网页实时更新节点；TCP/UDP直连协议设置客户端"CDN"免墙域名](https://youtu.be/JEXyj9UoMzU)

[Claw.cloud免费VPS搭建代理最终教程（二）：最低仅需2美分；支持Argo | Reality | Vmess | Hysteria2 | Tuic代理协议任意组合](https://youtu.be/NnuMgnJqon8)

[Claw.cloud免费VPS搭建代理最终教程（一）：全网最简单 | 两大无交互回车脚本 | 套CDN优选IP | workers反代 | ArgoSB隧道搭建](https://youtu.be/Esofirx8xrE)

[IDX Google免费VPS代理搭建教程（二）：ArgoSB一键代理脚本发布 | 一次回车搞定一切 | 懒人小白最强Argo代理节点脚本](https://youtu.be/OoXJ_jxoEyY)

[IDX Google免费VPS代理搭建教程（三）：NIX容器最新工作区方式搭建Argo免费节点 | 一次回车搞定一切 | Argo固定隧道一键复活](https://youtu.be/0I5eI1KKx08)

[IDX Google免费VPS代理搭建教程（四）：支持重置后自动启动代理节点功能 | 最简单的保活方法](https://youtu.be/EGrz6Wvevqc)

更新中……

----------------------------------------------------------

### 交流平台：[甬哥博客地址](https://ygkkk.blogspot.com)、[甬哥YouTube频道](https://www.youtube.com/@ygkkk)、[甬哥TG电报群组](https://t.me/+jZHc6-A-1QQ5ZGVl)、[甬哥TG电报频道](https://t.me/+DkC9ZZUgEFQzMTZl)

----------------------------------------------------------
### 感谢支持！微信打赏甬哥侃侃侃ygkkk
![41440820a366deeb8109db5610313a1](https://github.com/user-attachments/assets/e5b1f2c0-bd2c-4b8f-8cda-034d3c8ef73f)

----------------------------------------------------------
### 感谢你右上角的star🌟
[![Stargazers over time](https://starchart.cc/yonggekkk/ArgoSB.svg)](https://starchart.cc/yonggekkk/ArgoSB)

----------------------------------------------------------
### 声明：所有代码来源于Github社区与ChatGPT的整合

### Thanks to [VTEXS](https://console.vtexs.com/?affid=1558) for the sponsorship support
