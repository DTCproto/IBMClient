# IBMYes

**测速节点已经停用，无法测试**

**自动重启可能失效，IBM 的 API 节点似乎失效**

**本项目初衷是想学习 CI/CD 以及容器的使用，任何与此无关的问题将不做回复。**

本项目包括 3 部分

1. IBM Cloud Fonudray 搭建应用
2. 利用 Github 的 Actions 每周重启 IBM Cloud Fonudray
3. ~~Cloudflare 高速节点中转~~

# 使用 IBM Cloud Fonudray 搭建

```shell
wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/DTCproto/IBMYes/master/install.sh && chmod +x install.sh && ./install.sh
```

至此我们已经有一个可用的 v2ray 了，但是他每 10 天会重启一次，而且网速延迟很差，所以接下来会解决这个问题。

# 利用 Github 的 Actions 每周重启 IBM Cloud Fonudray

```shell
参考来源 https://github.com/CCChieh/IBMYes
```

IBM Cloud 10 天不操作就会关机，所以我们需要 十天内对其重启一次，避免关机。
