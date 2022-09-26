# vendor_alientek

## 简介

该仓库托管OpenHarmony社区开发的，而非某个厂商单独开发的典型产品样例代码，主要用于基于UniProton内核的能力验证。

## 软件架构
```
//device/soc/st
  | stm32f407zg   --- 基于UniProton内核的单板

//vendor/ohos
  | rtos_demo     --- 基础能力验证demo
  | rtos_demo_xts --- xts
```

## 使用说明

OpenHarmony的uniproton内核的编译构建系统是一个基于gn和ninja的组件化构建系统，支持按组件配置、裁剪和拼装，按需构建出定制化的产品。本文主要介绍如何基于gn和ninja编译uniproton工程，GCC+gn、IAR、Keil MDK等编译方式可以参考社区爱好者贡献的站点。

## 编译构建指导

### 1.搭建系统基础环境

在搭建各个开发板环境前，需要完成OpenHarmony系统基础环境搭建。系统基础环境主要是指OpenHarmony的编译环境和开发环境，详细介绍请参考官方站点[开发环境准备](https://gitee.com/openharmony/docs/blob/HEAD/zh-cn/device-dev/quick-start/quickstart-lite-env-setup.md)。开发者需要根据环境搭建文档完成环境搭建。

### 2.获取OpenHarmony源码

详细的源码获取方式，请见[源码获取](https://gitee.com/openharmony/docs/blob/HEAD/zh-cn/device-dev/get-code/sourcecode-acquire.md)。获取OpenHarmony完整仓代码后，假设克隆目录为`~/openHarmony`。

### 3.编译工具链下载

安装GNU Arm Embedded Toolchain 32位编译器:

官方下载地址为: [GNU Arm Embedded Toolchain编译器](https://developer.arm.com/downloads/-/gnu-rm)，指定版本:10-2020-q4-major。

安装参考以下命令:

```
tar -xvf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 -C /opt/tools
```

注意: 安装完成后需要将安装目录加入***环境变量***中。

### 4.搭建孵化仓编译环境

首次搭建，需要在//vendor目录下执行:
```
git clone https://gitee.com/openharmony-sig/vendor_alientek

```

拷贝vendor_alientek目录下的***uniproton_env.sh***脚本至OpenHarmony源码根目录，在OpenHarmony源码根目录下执行:
```
chmod +x uniproton_env.sh

./uniproton_env.sh create --patch
```
等脚本执行结束，孵化仓编译环境搭建结束。

### 5.编译

在源码根目录执行:
```
hb set
```

选择: alientek@rtos_demo

执行xts测试用例，则选择: alientek@rtos_demo_xts

编译执行命令:
```
hb build -f
```

### 6.环境清理

在OpenHarmony 源码根目录下执行命令:

```
./uniproton_env.sh clear
```
可清理掉该项目相关的所有修改。

若执行命令:

```
./uniproton_env.sh clear --all
```
可清理掉该针对OpenHarmony源码的所有修改。***此命令慎重执行***

## 贡献

目前整个孵化项目涉及到的除了上述两个sig仓以外，其它仓均使用OpenHarmony现有的仓，在OpenHarmony上有修改的仓有:

```
//device/soc/st

//third_party/musl

//build/lite

//base/startup/bootstrap_lite

//base/startup/syspara_lite

//foundation/systemabilitymgr/samgr_lite

//test/xts/acts
```

以上几个仓在孵化阶段以patch的形式管理，孵化毕业时再同步提交至OpenHarmony社区。

patch的维护方法:

以//device/soc/st 为例子, 执行编译时已经将该仓的patch应用，如有修改，则直接修改即可，修改之后在本地提交所有修改，并产生一笔提交记录，然后通过命令:

```
git format-patch [本次提交的前一次提交的commit Id]

mv 0001-feat-xxx.patch ../../../vendor/alientek/patches/0001-device-soc-st-stm32f407zg.patch
```

然后到//vendor/alientek仓将该patch修改上库。

其它仓库方法类似，在这里不做过多讲述。

[如何参与](https://gitee.com/openharmony/docs/blob/HEAD/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)

## 相关仓

[device_soc_st](https://gitee.com/openharmony/device_soc_st)

[kernel_uniproton](https://gitee.com/openharmony-sig/kernel_uniproton)
