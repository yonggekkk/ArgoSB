# ArgoSB One-Click Non-Interactive Proxy Script 【Current Version: V25.7.4】
## I just translate main repository.
<img width="636" height="238" alt="0cbc3f82134b4fc99afd6cee37e98be" src="https://github.com/user-attachments/assets/a76ca418-badb-4e9a-a771-6682ec713e06" />

#### 1. Based on Sing-box + Xray + Cloudflared-Argo triple-core automatic allocation

#### 2. Supports Docker Image deployment, public image repository: ```ygkkk/argosb```

#### 3. The SSH script is designed for simplicity and lightweight operation, requiring almost no dependencies, supports non-root users, and is compatible with all mainstream VPS systems

#### 4. Supports NIX container systems, especially recommended for servers like IDX-Google and Clawcloud

#### 5. All proxy protocols do not require a domain name, offering high freedom of choice, and support for single or multiple proxy protocols in any combination
【Currently supported: AnyTLS, Vless-xhttp-reality, Vless-reality-vision, Vmess-ws, Hy2, Tuic, Argo temporary/fixed tunnels】

#### 6. For more diverse features, it is recommended to use the VPS-dedicated four-in-one script [Sing-box-yg](https://github.com/yonggekkk/sing-box-yg)

----------------------------------------------------------

### I. Custom Variable Parameter Explanation:

| Variable Meaning | Variable Name | Variable Value "" Setting | Delete Variable | Variable Value "" Left Empty | Variable Requirements and Explanation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1. Enable vless-reality-vision | vlpt | Specify port | Disable vless-reality-vision | Random port | Required (one of) 【Xray core: TCP】 |
| 1. Enable vless-xhttp-reality | xhpt | Specify port | Disable vless-xhttp-reality | Random port | Required (one of) 【Xray core: TCP】 |
| 1. Enable anytls | anpt | Specify port | Disable anytls | Random port | Required (one of) 【Singbox core: TCP】 |
| 2. Enable vmess-ws | vmpt | Specify port | Disable vmess-ws | Random port | Required (one of) 【Xray/Singbox core: TCP】 |
| 3. Enable hy2 | hypt | Specify port | Disable hy2 | Random port | Required (one of) 【Singbox core: UDP】 |
| 4. Enable tuic | tupt | Specify port | Disable tuic | Random port | Required (one of) 【Singbox core: UDP】 |
| 5. Argo switch | argo | Fill in "y" | Disable Argo tunnel | Disable Argo tunnel | Optional, when "y" is filled, the vmess variable vmpt must be enabled |
| 6. Argo fixed tunnel domain | agn | Domain resolved on CF | Use temporary tunnel | Use temporary tunnel | Optional, Argo must be "y" to activate fixed tunnel |
| 7. Argo fixed tunnel token | agk | CF token starting with "ey" | Use temporary tunnel | Use temporary tunnel | Optional, Argo must be "y" to activate fixed tunnel |
| 8. UUID password | uuid | Complies with UUID format | Randomly generated | Randomly generated | Optional |
| 9. Reality domain | reym | Complies with reality domain rules | yahoo | yahoo | Optional |
| 10. Switch IPv4 or IPv6 configuration | ip | Fill in "4" or "6" | Auto-detect IP configuration | Auto-detect IP configuration | Optional, "4" for IPv4 configuration output, "6" for IPv6 configuration output |
| 11. 【Only for Docker containers】Listening port, web query | PORT | Specify port | 3000 | 3000 | Optional |
| 12. 【Only for Docker containers】Enable vless-ws-tls | DOMAIN | Server domain | Disable vless-ws-tls | Disable vless-ws-tls | Optional, vless-ws-tls can exist independently, uuid variable must be enabled |


![f776f1b3b1e0ebe9a537baf8660a387](https://github.com/user-attachments/assets/b9b357de-85b8-4270-aa87-2f50d63d672e)


#### Notes for using ```ygkkk/argosb``` image:

1. It is recommended to include the uuid variable to keep it unchanged after restarting.

2. Click "restart" to automatically update the image, but the keys related to the reality protocol will be reset, requiring re-exporting reality nodes.

3. After restarting, the temporary domain name of the Argo tunnel will change, requiring re-exporting Argo nodes, while the fixed tunnel remains unchanged.

4. Running Xray/Sing-box/Argo three cores simultaneously may trigger certain Docker container limits, causing errors. It is recommended to run a maximum of two cores at the same time.

#### Notes for using VPS:

1. If uuid is left empty and randomly generated, it will remain unchanged after restarting.

2. Updating the script requires uninstalling and reinstalling. It is recommended to keep the script with variables for quick reinstallation.

3. After restarting, the temporary domain name of the Argo tunnel will change, requiring re-exporting Argo nodes, while the fixed tunnel remains unchanged.

----------------------------------------------------------

### II. SSH One-Click Variable Script Template:

Note: Fill the variable values between "", leave a space between variables, and unused variables can be deleted.

```
vlpt="" vmpt="" hypt="" tupt="" xhpt="" anpt="" uuid="" reym="" argo="" agn="" agk="" ip="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

----------------------------------------------------------

### III. Three Recommended SSH One-Click Script Combinations:

1: All protocols coexist or single protocol + Argo temporary/fixed tunnel
```
vlpt="" vmpt="" hypt="" tupt="" xhpt="" anpt="" argo="y" agn="" agk="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

2: Only Argo temporary tunnel. Fixed tunnel requires filling in port (vmpt), domain (agn), and token (agk).

Recommended for VPS containers like IDX-Google without public IP, enabling quick intranet penetration to obtain nodes.

```
vmpt="" argo="y" agn="" agk="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

3: Single protocol, mainstream UDP or TCP protocol running alone.

Example for hy2: The following script enables the hy2 variable hypt. Other protocol variables refer to the parameter explanation.

```
hypt="" bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)
```

---------------------------------------------------------

### IV. SSH Shortcuts (After the first installation, reconnect SSH for the "agsb" shortcut to take effect):

1. View Argo fixed domain, fixed tunnel token, temporary domain, and current installed node information:

```agsb list``` or ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) list```


2. Switch between IPv4/IPv6 node configurations online (for dual-stack VPS):

Display IPv4 node configuration:

```ip=4 agsb list``` or ```ip=4 bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) list```

Display IPv6 node configuration:

```ip=6 agsb list``` or ```ip=6 bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) list```

3. Uninstall the script:

```agsb del``` or ```bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh) del```

----------------------------------------------------------

#### Tutorials can be found on Yongge's blog. Video tutorials are as follows:

Latest recommendation: [Claw.cloud Free VPS Proxy Setup Final Tutorial (5): ArgoSB Script Docker Image Update Supports AnyTLS, Xhttp-Reality](https://youtu.be/-mhZIhHRyno)

[Claw.cloud Free VPS Proxy Setup Final Tutorial (4): Starting at Just 1 Cent, 4 Price Tiers + 7 Protocol Combinations to Choose From; Node Viewing, Restarting, Upgrading, IP Changing, Configuration Modification Instructions](https://youtu.be/xOQV_E1-C84)

[Claw.cloud Free VPS Proxy Setup Final Tutorial (3): ArgoSB All-in-One Docker Image Released, Supports Real-Time Node Updates; TCP/UDP Direct Connection Protocol Settings for Client "CDN" Bypass Domain](https://youtu.be/JEXyj9UoMzU)

[Claw.cloud Free VPS Proxy Setup Final Tutorial (2): Starting at Just 2 Cents; Supports Argo | Reality | Vmess | Hysteria2 | Tuic Proxy Protocol Combinations](https://youtu.be/NnuMgnJqon8)

[Claw.cloud Free VPS Proxy Setup Final Tutorial (1): The Simplest Online | Two Non-Interactive Scripts | CDN Optimized IP | Workers Reverse Proxy | ArgoSB Tunnel Setup](https://youtu.be/Esofirx8xrE)

[IDX Google Free VPS Proxy Setup Tutorial (2): ArgoSB One-Click Proxy Script Released | One Enter to Complete Everything | The Laziest and Easiest Argo Proxy Node Script](https://youtu.be/OoXJ_jxoEyY)

[IDX Google Free VPS Proxy Setup Tutorial (3): NIX Container Latest Workspace Method to Set Up Argo Free Nodes | One Enter to Complete Everything | Argo Fixed Tunnel One-Click Revival](https://youtu.be/0I5eI1KKx08)

[IDX Google Free VPS Proxy Setup Tutorial (4): Supports Automatic Proxy Node Restart After Reset | The Simplest Keep-Alive Method](https://youtu.be/EGrz6Wvevqc)

More updates coming...

----------------------------------------------------------

### Communication Platforms: [Yongge's Blog](https://ygkkk.blogspot.com), [Yongge's YouTube Channel](https://www.youtube.com/@ygkkk), [Yongge's Telegram Group](https://t.me/+jZHc6-A-1QQ5ZGVl), [Yongge's Telegram Channel](https://t.me/+DkC9ZZUgEFQzMTZl)

----------------------------------------------------------
### Thank you for your support! WeChat donations to Yongge: ygkkk
![41440820a366deeb8109db5610313a1](https://github.com/user-attachments/assets/e5b1f2c0-bd2c-4b8f-8cda-034d3c8ef73f)

----------------------------------------------------------
### Thank you for the star🌟 in the upper right corner
[![Stargazers over time](https://starchart.cc/yonggekkk/ArgoSB.svg)](https://starchart.cc/yonggekkk/ArgoSB)

----------------------------------------------------------
### Disclaimer: All code is sourced from the Github community and integrated with ChatGPT

### Thanks to [VTEXS](https://console.vtexs.com/?affid=1558) for the sponsorship supp