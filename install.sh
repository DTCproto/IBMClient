#!/bin/bash
SH_PATH=$(cd "$(dirname "$0")";pwd)
cd ${SH_PATH}

create_mainfest_file(){
    echo "进行配置。。。"
    # 应用名称
    read -p "请输入你的应用名称：" IBM_APP_NAME
    echo "应用名称：${IBM_APP_NAME}"
    # 内存大小
    read -p "请输入你的应用内存大小(默认256)：" IBM_MEM_SIZE
    if [ -z "${IBM_MEM_SIZE}" ];then
    IBM_MEM_SIZE=256
    fi
    echo "内存大小：${IBM_MEM_SIZE}"
    # WebSocket路径
    read -p "请输入你的应用WebSocket路径(默认 ibm-cloud-v2)：" WSPATH
    if [ -z "${WSPATH}" ];then
    WSPATH=ibm-cloud-v2
    fi
    echo "应用WebSocket路径：${WSPATH}"
    # 密码
    read -p "请输入你的密码：" PASSWORD
    if [ -z "${PASSWORD}" ];then
    PASSWORD=$(cat /proc/sys/kernel/random/uuid)
    fi
    echo "密码为：${PASSWORD}"
    # 加密方式
    read -p "请输入你的加密方式(默认AES-128-GCM)：" METHOD
    if [ -z "${METHOD}" ];then
    METHOD=AES-128-GCM
    fi
    echo "加密方式为：${METHOD}"

    cat >  ${SH_PATH}/IBMClient/web-cloudfoundry/manifest.yml  << EOF
    applications:
      - name: ${IBM_APP_NAME}
        random-route: true
        memory: ${IBM_MEM_SIZE}M
        command: resources/elf/web-go -s 'ss://${METHOD}:${PASSWORD}@:8080' -verbose -plugin "resources/elf/plugin" -plugin-opts "server;path=/${WSPATH}"
        buildpacks:
          - go_buildpack
        env:
          GOVERSION: go1.14
          GOPACKAGENAME: web-cloudfoundry
          GO_INSTALL_PACKAGE_SPEC: web-cloudfoundry
EOF

    echo "配置完成。配置如下："
    echo "[manifest.yml]："
    cat ${SH_PATH}/IBMClient/web-cloudfoundry/manifest.yml
    
}

clone_repo(){
    echo "进行初始化。。。"
	rm -rf IBMClient
    git clone https://github.com/DTCproto/IBMClient.git
    cd IBMClient
    git submodule update --init --recursive
    cd web-cloudfoundry
    go build -ldflags "-w -s"
    
    # 权限赋值
    chmod 0755 resources/elf/*
    
    echo "初始化完成。"
}

install(){
    echo "进行安装 START..."
    cd ${SH_PATH}/IBMClient/web-cloudfoundry
    echo "开始执行[ibmcloud target --cf]..."
    ibmcloud target --cf
    echo "开始执行[ibmcloud cf install]..."
    echo "N"|ibmcloud cf install
    echo "开始执行[ibmcloud cf push]..."
    ibmcloud cf push
    
    echo "安装完成. END"

}

clone_repo
create_mainfest_file
install
exit 0