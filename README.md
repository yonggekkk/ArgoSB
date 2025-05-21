## ArgoSB一键无交互脚本

### 1、脚本主打极简、轻便的体验

### 2、支持各种主流VPS系统、容器NIX系统

### 3、自动安装最新sing-box内核+最新Cloudflared-Argo内核，支持Argo临时/固定隧道

### 4、目前仅输出VMESS协议节点：13个端口节点及对应的优选不死IP全覆盖

----------------------------------------------------------

主流VPS脚本如下，默认安装为Argo临时隧道（uuid、vmess端口未设变量时，为随机生成）
```
bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```
----------------------------------------------------------

容器NIX脚本如下，默认安装为Argo临时隧道（uuid、vmess端口未设变量时，为随机生成）
```
nix=y bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

----------------------------------------------------------

### 可自定义变量参数：

#### 1、Argo临时隧道：
#### 脚本前必须要有端口(vmpt)、uuid密码(uuid)，每次重装后临时域名都不相同，需重新复制节点信息

主流VPS脚本：
```
uuid=你的uuid vmpt=可使用的端口 bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

容器NIX脚本：
```
nix=y uuid=你的uuid vmpt=可使用的端口 bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

#### 2、Argo固定隧道：
#### 脚本前必须要有端口(vmpt)、uuid密码(uuid)、固定域名(agn)、token(agk)，每次重装后固定域名不变，一键复活原Argo固定隧道分享

主流VPS脚本：
```
uuid=你的uuid vmpt=可使用的端口 agn=固定域名 agk=ey开头的token bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

容器NIX脚本：
```
nix=y uuid=你的uuid vmpt=可使用的端口 agn=固定域名 agk=ey开头的token bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```


#### 注：如果服务器支持任意端口，临时隧道端口变量(vmpt)可以不用设置

---------------------------------------------------------

### 相关快捷方式：

1、查看Argo的固定域名、固定隧道的token、临时域名、当前节点信息：

主流VPS脚本：```agsb``` 或者 ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)```

容器NIX脚本：```nix=y bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)```

2、升级ArgoSB脚本：

主流VPS脚本：```agsb up``` 或者 ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) up```

3、卸载ArgoSB脚本：

主流VPS脚本：```agsb del``` 或者 ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) del```

容器NIX脚本：```nix=y bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) del```

----------------------------------------------------------


#### 相关教程可参考甬哥博客，视频教程如下：

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

### Thanks to [VTEXS](https://console.vtexs.com/?affid=1558) for the sponsorship support

----------------------------------------------------------
