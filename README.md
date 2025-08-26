## ArgoSB一键无交互小钢炮脚本💣：极简 + 轻量 + 快速

---------------------------------------

<img width="636" height="238" alt="0cbc3f82134b4fc99afd6cee37e98be" src="https://github.com/user-attachments/assets/a76ca418-badb-4e9a-a771-6682ec713e06" />

### 【ArgoSB当前版本：V25.8.27】

---------------------------------------

#### 1、基于Sing-box + Xray + Cloudflared-Argo 三内核自动分配

#### 2、支持Linux类主流VPS系统，SSH脚本支持非root环境运行，几乎无需依赖，无脑一次回车搞定

#### 3、支持Docker Image镜像部署，公开镜像库：```ygkkk/argosb```

#### 4、支持NIX容器系统，特别推荐IDX-Google、Clawcloud爪云、CloudCat的服务器

#### 5、根据Sing-box与Xray不同内核，可选15种WARP出站模式，更换落地IP为WARP的IP，解锁流媒体

#### 6、所有代理协议都无需域名（除了argo固定隧道），支持单个或多个代理协议任意组合并快速重置更换
【 已支持：AnyTLS、Any-reality、Vless-xhttp-reality、Vless-reality-vision、Shadowsocks-2022、Vmess-ws、Hysteria2、Tuic、Argo临时/固定隧道 】

#### 7、如需要多样的功能，推荐使用VPS专用四合一脚本[Sing-box-yg](https://github.com/yonggekkk/sing-box-yg)

----------------------------------------------------------

## 一、自定义变量参数说明：

| 变量意义 | 变量名称| 在变量值""之间填写| 删除变量 | 在变量值""之间留空 | 变量要求及说明 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1、启用vless-reality-vision | vlpt | 端口指定 | 关闭vless-reality-vision | 端口随机 | 必选之一 【xray内核：TCP】 |
| 2、启用vless-xhttp-reality | xhpt | 端口指定 | 关闭vless-xhttp-reality | 端口随机 | 必选之一 【xray内核：TCP】 |
| 3、启用shadowsocks-2022 | sspt | 端口指定 | 关闭shadowsocks-2022 | 端口随机 | 必选之一 【xray内核：TCP】 |
| 4、启用anytls | anpt | 端口指定 | 关闭anytls | 端口随机 | 必选之一 【singbox内核：TCP】 |
| 5、启用any-reality | arpt | 端口指定 | 关闭any-reality | 端口随机 | 必选之一 【singbox内核：TCP】 |
| 6、启用vmess-ws | vmpt | 端口指定 | 关闭vmess-ws | 端口随机 | 必选之一 【xray/singbox内核：TCP】 |
| 7、启用hysteria2 | hypt | 端口指定 | 关闭hy2 | 端口随机 | 必选之一 【singbox内核：UDP】 |
| 8、启用tuic | tupt | 端口指定 | 关闭tuic | 端口随机 | 必选之一 【singbox内核：UDP】 |
| 9、warp开关 | warp | 详见下方15种warp出站模式图 | 关闭warp | singbox与xray内核协议都启用warp全局V4+V6 | 可选，详见下方15种warp出站模式图 |
| 10、argo开关 | argo | 填写y | 关闭argo隧道 | 关闭argo隧道 | 可选，填写y时，vmess变量vmpt必须启用，且固定隧道必须填写vmpt端口 |
| 11、argo固定隧道域名 | agn | 托管在CF上的域名 | 使用临时隧道 | 使用临时隧道 | 可选，argo填写y才可激活固定隧道|
| 12、argo固定隧道token | agk | CF获取的ey开头的token | 使用临时隧道 | 使用临时隧道 | 可选，argo填写y才可激活固定隧道 |
| 13、uuid密码 | uuid | 符合uuid规定格式 | 随机生成 | 随机生成 | 可选 |
| 14、reality域名（仅支持reality类协议） | reym | 符合reality域名规定 | yahoo | yahoo | 可选，使用CF类域名时，可用作ProxyIP/客户端地址反代IP（建议高位端口或纯IPV6下使用，以防被扫泄露）|
| 15、vmess客户端host地址 | cdnym | IP解析的CF域名 | vmess为直连 | vmess为直连 | 可选，使用80系CDN或者回源CDN时可设置，否则客户端host地址需手动更改为IP解析的CF的域名|
| 16、切换ipv4或ipv6配置 | ippz | 填写4或者6 | 自动识别IP配置 | 自动识别IP配置 | 可选，4表示IPV4配置输出，6表示IPV6配置输出 |
| 17、添加所有节点名称前缀 | name | 任意字符 | 默认协议名前缀 | 默认协议名前缀 | 可选 |
| 18、【仅容器类docker】监听端口，网页查询 | PORT | 端口指定 | 3000 | 3000 | 可选 |
| 19、【仅容器类docker】启用vless-ws-tls | DOMAIN | 服务器域名 | 关闭vless-ws-tls | 关闭vless-ws-tls | 可选，vless-ws-tls可独立存在，uuid变量必须启用 |

<img width="926" height="602" alt="a8dd55d7606084a147580c4d292b5d10" src="https://github.com/user-attachments/assets/17509155-ad47-43bd-9943-fc7c57b72e42" />

<img width="1498" height="655" alt="1b05db3ba201b35f440b139e8f0ee4b1" src="https://github.com/user-attachments/assets/dfd9e034-baeb-460e-94e2-32bf88f3112a" />

<img width="918" height="677" alt="b5fe6e2154adffbad769772e115cb9b1" src="https://github.com/user-attachments/assets/6ea0c407-2cae-4bac-a769-d50e90178e71" />

----------------------------------------------------------

## 二、SSH一键变量脚本模版说明：

### 脚本以 ```变量名称="变量值"的单个或多个组合 + 主脚本``` 的形式运行

主脚本：```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)```

必选其一的协议端口变量：```vmpt=""```、```vmpt="" argo="y"```、```vlpt=""```、```xhpt=""```、```anpt=""```、```arpt=""```、```hypt=""```、```tupt=""```、```sspt=""```

可选的功能类变量：```warp=""```、```uuid=""```、```reym=""```、```cdnym=""```、```argo=""```、```agn=""```、```agk=""```、```ippz=""```、```name=""```

请参考```一、自定义变量参数说明```中变量的作用说明，变量值填写在```" "```之间，变量之间空一格，不用的变量可以删除

* ### 模版1：多个任意协议组合运行
```
sspt="" vlpt="" vmpt="" hypt="" tupt="" xhpt="" anpt="" arpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

* ### 模版2：主流TCP或UDP单个协议运行

Vless-Reality-Vision协议节点
```
vlpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Vless-Xhttp-Reality协议节点
```
xhpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Shadowsocks-2022协议节点
```
sspt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

AnyTLS协议节点
```
anpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Any-Reality协议节点
```
arpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Vmess-ws协议节点
```
vmpt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Hysteria2协议节点
```
hypt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Tuic协议节点
```
tupt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

* ### 模版3：开启CDN优选的节点运行

Argo临时/固定隧道运行优选节点，类似无公网的IDX-Google-VPS容器推荐使用此脚本，快速一键内网穿透获取节点

Argo临时隧道CDN优选节点
```
vmpt="" argo="y" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

Argo固定隧道CDN优选节点，必须填写端口(vmpt)、域名(agn)、token(agk)
```
vmpt="端口" argo="y" agn="解析的CF域名" agk="CF获取的token" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

80系端口、回源端口的CDN优选节点
```
vmpt="80系端口、指定随机端口" cdnym="ip已解析的CF域名" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```
---------------------------------------------------------

## 三、多功能SSH快捷方式命令组

#### 说明：首次安装成功后需重连SSH，```agsb 命令```的快捷方式才可生效；如未生效，请使用```主脚本 命令```的快捷方式

1、查看Argo的固定域名、固定隧道的token、临时域名、当前已安装的节点信息命令：```agsb list``` 或者 ```主脚本 list```

2、更换代理协议变量组命令：```自定义各种协议变量组 agsb rep``` 或者 ```自定义各种协议变量组 主脚本 rep```

3、更新脚本命令：```原已安装的自定义各种协议变量组 主脚本 rep``` 

4、重启脚本命令：```agsb res``` 或者 ```主脚本 res```

5、卸载脚本命令：```agsb del``` 或者 ```主脚本 del```

6、临时切换IPV4/IPV6节点配置 (双栈VPS专享)：

显示IPV4节点配置：```ippz=4 agsb list```或者```ippz=4 主脚本 list```

显示IPV6节点配置：```ippz=6 agsb list```或者```ippz=6 主脚本 list```

----------------------------------------------------------

#### 相关教程可参考[甬哥博客](https://ygkkk.blogspot.com/2025/08/argosb.html)，视频教程如下：

更新中……

最新推荐：[ArgoSB一键无交互小钢炮脚本💣（二）：代理节点的IP、端口被封依旧可用！ArgoSB脚本套CDN优选4大方案教程](https://youtu.be/RnUT1CNbCr8)

[ArgoSB一键无交互小钢炮脚本💣（一）：VPS/nat VPS在主协议下的应用；仅按一次回车，多协议自由搭配](https://youtu.be/CiXmttY7mhw)

[Clawcloud爪云、IDX Google VPS的福音：解决服务器IP访问困扰！Argosb脚本新增WARP出站功能，轻松更换落地IP为Cloudflare WARP IP](https://youtu.be/HO_XLBmIYJw)

[Claw.cloud免费VPS搭建代理最终教程（五）：ArgoSB脚本docker镜像更新支持AnyTLS、Xhttp-Reality](https://youtu.be/-mhZIhHRyno)

[Claw.cloud免费VPS搭建代理最终教程（四）：最低仅1美分，4套价格+7组协议的套餐组合任你选；查看节点、重启升级、更换IP、更改配置的操作说明](https://youtu.be/xOQV_E1-C84)

[Claw.cloud免费VPS搭建代理最终教程（三）：ArgoSB全能docker镜像发布，支持网页实时更新节点；TCP/UDP直连协议设置客户端"CDN"免墙域名](https://youtu.be/JEXyj9UoMzU)

[Claw.cloud免费VPS搭建代理最终教程（二）：最低仅需2美分；支持Argo | Reality | Vmess | Hysteria2 | Tuic代理协议任意组合](https://youtu.be/NnuMgnJqon8)

[Claw.cloud免费VPS搭建代理最终教程（一）：全网最简单 | 两大无交互回车脚本 | 套CDN优选IP | workers反代 | ArgoSB隧道搭建](https://youtu.be/Esofirx8xrE)

[IDX Google免费VPS代理搭建教程（三）：NIX容器最新工作区方式搭建Argo免费节点 | 一次回车搞定一切 | Argo固定隧道一键复活](https://youtu.be/0I5eI1KKx08)

[IDX Google免费VPS代理搭建教程（四）：支持重置后自动启动代理节点功能 | 最简单的保活方法](https://youtu.be/EGrz6Wvevqc)

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
