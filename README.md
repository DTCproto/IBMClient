# IBMYes

**本项目初衷是想学习 CI/CD 以及容器的使用，任何与此无关的问题将不做回复。**
**参考来源 [https://github.com/CCChieh/IBMYes]**

本项目包括以下部分

1. IBM Cloud Fonudray 搭建应用
2. 利用 Github 的 Actions 每周重启 IBM Cloud Fonudray

# 使用 IBM Cloud Fonudray 搭建

```shell
wget --no-check-certificate -O install.sh https://raw.githubusercontent.com/DTCproto/IBMYes/master/install.sh && chmod +x install.sh && ./install.sh
```

# 利用 Github 的 Actions 每周重启 IBM Cloud Fonudray

~~ 不在此处进行说明 ~~

IBM Cloud 10 天不操作就会关机，所以我们需要 十天内对其重启一次，避免关机。
