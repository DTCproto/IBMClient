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
    echo "随机密码为：${PASSWORD}"
    # 加密方式
    read -p "请输入你的加密方式(默认AES-128-GCM)：" METHOD
    if [ -z "${METHOD}" ];then
    METHOD=AES-128-GCM
    fi
    echo "加密方式为：${METHOD}"
    
    cat >  ${SH_PATH}/IBMYes/ss-go2-cloudfoundry/manifest.yml  << EOF
    applications:
    - path: .
      name: ${IBM_APP_NAME}
      random-route: true
      memory: ${IBM_MEM_SIZE}M
EOF

    cat >  ${SH_PATH}/IBMYes/ss-go2-cloudfoundry/Procfile  << EOF
    web: ./ss-go2/ss -s 'ss://${METHOD}:${PASSWORD}@:443' -verbose -plugin-opts "server;path=/${WSPATH}"
EOF

    echo "配置完成。"
}

clone_repo(){
    echo "进行初始化。。。"
	rm -rf IBMYes
    git clone https://github.com/xxx/IBMYes
    cd IBMYes
    cd ss-go2-cloudfoundry/ss-go2
    # Upgrade V2Ray to the latest version
    
    chmod 0755 ./*
    cd ${SH_PATH}/IBMYes/ss-go2-cloudfoundry
    echo "初始化完成。"
}

install(){
    echo "进行安装。。。"
    cd ${SH_PATH}/IBMYes/ss-go2-cloudfoundry
    ibmcloud target --cf
    echo "N"|ibmcloud cf install
    ibmcloud cf push
    echo "安装完成。"

}

clone_repo
create_mainfest_file
install
exit 0