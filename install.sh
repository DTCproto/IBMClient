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
    
    cat >  ${SH_PATH}/IBMYes/ss-go2-cloudfoundry/manifest.yml  << EOF
    applications:
      - path: cmd/server
        name: ${IBM_APP_NAME}
        random-route: true
        memory: ${IBM_MEM_SIZE}M
        buildpacks:
          - go_buildpack
        env:
          GOPACKAGENAME: ss-go2-cloudfoundry
EOF

    cat >  ${SH_PATH}/IBMYes/ss-go2-cloudfoundry/Procfile  << EOF
    web: ss-go2 -s 'ss://${METHOD}:${PASSWORD}@:8080' -verbose -plugin "v2ray-plugin" -plugin-opts "server;path=/${WSPATH}"
EOF

    echo "配置完成。配置如下："
    cat ${SH_PATH}/IBMYes/ss-go2-cloudfoundry/Procfile
    cat ${SH_PATH}/IBMYes/ss-go2-cloudfoundry/manifest.yml
    
}

clone_repo(){
    echo "进行初始化。。。"
	rm -rf IBMYes
    git clone https://github.com/DTCproto/IBMYes.git
    cd IBMYes
    git submodule update --init --recursive
    cd ss-go2-cloudfoundry/cmd/server
    
    # 权限赋值
    chmod 0755 ./*
    # cd ${SH_PATH}/IBMYes/ss-go2-cloudfoundry
    echo "初始化完成。"
}

install(){
    echo "进行安装 START..."
    cd ${SH_PATH}/IBMYes/ss-go2-cloudfoundry
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