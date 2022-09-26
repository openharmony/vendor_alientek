#!/bin/bash
#
# Copyright (c) 2022 Huawei Device Co., Ltd.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of
#    conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list
#    of conditions and the following disclaimer in the documentation and/or other materials
#    provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be used
#    to endorse or promote products derived from this software without specific prior written
#    permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
ENV_CMD=$1
CMD_ARG=$2
OHOS_DIR=$PWD
PROJECT_PATH=(
    "build/lite"
    "device/soc/st"
    "third_party/musl"
    "base/startup/bootstrap_lite"
    "base/startup/syspara_lite"
    "foundation/systemabilitymgr/samgr_lite"
    "test/xts/acts"
)

if [ "$ENV_CMD" == "clear" ]
then
    if [ "$CMD_ARG" == "--all" ]
    then
        repo forall -c "pwd;git add .;git commit -m \"xxx\";git reset --hard origin/master"
    else
        for args in ${PROJECT_PATH[@]}
        do
            echo "path: $args"
            cd $args
            git add .;git commit -m \"xxx\";git reset --hard origin/master
            cd $OHOS_DIR
        done
    fi
    rm -rf vendor/alientek
    rm -rf kernel/uniproton
    echo "Clear ok !!!"
elif [ "$ENV_CMD" == "create" ]
then
    echo "OHOS_DIR: $OHOS_DIR"
    cd kernel
    git clone https://gitee.com/openharmony-sig/kernel_uniproton.git
    mv kernel_uniproton uniproton
    cd ../vendor
    if [[ ! -d "vendor_alientek" ]] && [[ ! -d "alientek" ]]
    then
        git clone https://gitee.com/openharmony-sig/vendor_alientek.git
    fi
    if [ ! -d "alientek" ]
    then
        mv vendor_alientek alientek
    fi
    cd ../

    rm -rf ohos_config.json
    echo "{" > ohos_config.json
    echo "  \"root_path\": \"$OHOS_DIR\"," >> ohos_config.json
    echo "  \"board\": \"st/stm32f407zg\"," >> ohos_config.json
    echo "  \"kernel\": \"uniproton\"," >> ohos_config.json
    echo "  \"product\": \"rtos_demo\"," >> ohos_config.json
    echo "  \"product_path\": \"$OHOS_DIR/vendor/alientek/rtos_demo\"," >> ohos_config.json
    echo "  \"device_path\": \"$OHOS_DIR/device/soc/st/stm32f407zg/uniproton\"," >> ohos_config.json
    echo "  \"device_company\": \"soc\"," >> ohos_config.json
    echo "  \"os_level\": \"mini\"," >> ohos_config.json
    echo "  \"version\": \"3.0\"," >> ohos_config.json
    echo "  \"patch_cache\": \"$OHOS_DIR/vendor/alientek/rtos_demo/patch.yml\"," >> ohos_config.json
    echo "  \"product_json\": \"$OHOS_DIR/vendor/alientek/rtos_demo/config.json\"," >> ohos_config.json
    echo "  \"component_type\": \"\"," >> ohos_config.json
    echo "  \"product_config_path\": \"$OHOS_DIR/vendor/alientek/rtos_demo\"," >> ohos_config.json
    echo "  \"target_cpu\": null," >> ohos_config.json
    echo "  \"target_os\": null," >> ohos_config.json
    echo "  \"out_path\": \"$OHOS_DIR/out/st/stm32f407zg/rtos_demo\"," >> ohos_config.json
    echo "  \"subsystem_config_json\": \"build/subsystem_config.json\"," >> ohos_config.json
    echo "  \"device_config_path\": \"$OHOS_DIR/device/soc/st/stm32f407zg/uniproton\"" >> ohos_config.json
    echo "}" >> ohos_config.json
    if [ "$CMD_ARG" == "--patch" ]
    then
        hb build --patch
        if [ $? -ne 0 ]
        then
            hb build --patch -f
        fi
    fi
else
    echo "Inavlid ENV_CMD: $ENV_CMD"
fi
