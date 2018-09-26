# 在线语音聊天室

Other Language: [English](README.md)

**语音聊天室** 是一种纯音频的使用场景。用户作为主播或者听众加入房间进行语音聊天，也可以在房间内任意切换自己的主播/听众身份。包含:

* 场景描述
* 实现方案
* 集成方法 - Android
* 集成方法 - iOS
* 进阶指南

## 场景描述

* 房主创建房间，多个客人加入房间参与语音聊天
* 房主播放背景音乐
* 房主切换背景图片
* 客人可以向房主申请上麦、下麦
* 房主采用高音质，上麦客人采用默认音质。

## 实现方案

下图为语音聊天室的实现架构图：

.. image:: online_chatroom_architecture.jpg
   :scale: 130%

声网已在 GitHub 提供了 Android 和 iOS 平台的 [实现代码](https://github.com/AgoraIO-Community/Agora-Online-Chatroom/tree/master/Agora-Online-Chatroom)。


## 集成方法 - Android

### 集成 SDK

#### 步骤 1：准备环境

1. 下载最新版 [Android 视频通话/视频直播 SDK](https://docs.agora.io/cn/Agora%20Platform/downloads) 。

2. 请确保满足以下开发环境要求:

    * Android SDK API Level> = 16

    * Android Studio 2.0 或以上版本

    * 支持语音和视频功能的真机

    * App 要求 Android 4.1 或以上设备

3. 请确保在使用 Agora 相关功能及服务前，已打开特定端口，详见 [防火墙说明](https://docs.agora.io/cn/Agora%20Platform/firewall?platform=All%20Platforms)。


#### 步骤 2: 添加 SDK

1. 将下载的软件包中 *libs* 文件夹下的库根据实际需求拷贝到您项目对应的文件夹里。

   * agora-rtc-sdk.jar (mandatory)

   * armeabi-v7a/

   * x86/

   * arm64-v8a

**注意:** 当你将所需库复制到正确路径的 *libs* 文件夹里时，如果该路径包含中文，则无法成功编译，报错中会提到 ASCII 码。


2. 请根据您项目的 *build.gradle* 文件里的设置，将上述库放入正确路径的 *libs* 文件夹下。例如:

.. image:: android_library.png
   :scale: 50%

3. 请在 build.gradle 文件里指定 so 文件的目录，即上一步里面 libs 文件夹的路径。

.. image:: android_so.png
   :scale: 45%

#### 步骤 3: 配置 NDK

如果出现以下问题，请配置 NDK:

.. image:: android6.png
   :scale: 60%

该错误表示没有安装 NDK。请从网站上下载，请将其放在与 Android SDK 平行的路径下:

.. image:: android7.png
   :scale: 40%

#### 步骤 4: 添加权限

为保证 SDK 正常运行，程序部署时需在 *AndroidManisfest.xml* 文件中加入以下许可：

.. code-block:: python

   <uses-permission android:name="android.permission.INTERNET" />

   <uses-permission android:name="android.permission.RECORD_AUDIO" />

   <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />

   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />


#### 步骤 5：同步项目文件

点击 **Sync Project With Gradle Files** ，直到同步完成。

.. image:: android9.png
   :scale: 60%


#### 步骤 6：混淆代码

当您在写混淆代码时，请添加以下代码:

.. image:: mixed_code.png
   :scale: 20%

### 加入声网频道实现语音聊天

首先申请 App ID，详见 :ref:`app_id_native`。

以下流程图描述了加入或离开频道以及客人上下麦的时序关系。

.. image:: online_chatroom_flowchart.jpg
   :scale: 130%


#### 房主端

1. 创建 RtcEngine 对象，并填入 App ID，详见 :ref:`live_android_create`。

2. 设置频道为 **直播模式**，详见 :ref:`live_android_setChannelProfile`。

3. 把房主的用户角色设为 BROADCASTER，详见 :ref:`live_android_setClientRole`。

4. 创建并加入频道, 详见 :ref:`live_android_joinchannel`。

5. 通过信令或消息服务器通知所有用户替换背景图片。

6. 当收到客人上麦申请时，同意或拒绝请求。

7. 闭麦：把自己静音。详见 :ref:`live_android_muteLocalAudioStream`。

8. 开始播放伴奏，详见 :ref:`live_android_startAudioMixing`。

   **注意**: 伴奏音量应小于人声。

9. 离开频道，详见 :ref:`live_android_leaveChannel`。

10. 通知频道内其他客人退出频道。

#### 客人端

1. 创建 RtcEngine 对象，并填入 App ID，详见 :ref:`live_android_create`。

2. 设置频道为 **直播模式**，详见 :ref:`live_android_setChannelProfile`。

3. 把客人的用户角色设为 AUDIENCE，详见 :ref:`live_android_setClientRole`。

4. 创建并加入频道, 详见 :ref:`live_android_joinchannel`。

5. 收到房主替换背景图片请求时，替换背景图片。

6. 向房主申请上麦。

7. 房主同意申请后，客人需要重新把用户角色设为 BROADCASTER 开始上麦，详见 :ref:`live_android_setClientRole`。

8. 上麦结束后，客人将自己的用户角色重新设回 AUDIENCE, 详见 :ref:`live_android_setClientRole`。

9. 离开频道，详见 :ref:`live_android_leaveChannel`。


## 进阶指南

调整伴奏音量：
~~~~~~~~~~~~~~~~~~~~~

调整伴奏音量，详见 :ref:`live_android_adjustAudioMixingVolume`。

设置高音质
~~~~~~~~~~~~~~~~~~~~~

设置音质，详见 :ref:`setAudioProfile_live_android`。
## 注意事项
1. 示例程序只演示了“语音聊天室”类场景中和语音聊天相关部分的逻辑，不是完整的产品。如要开发完整的产品，需要自行实现业务部分逻辑；
2. “FM 超高音质房间” 需要使用 声网 Agora 提供的特殊优化版本SDK，官网SDK版本尚无法支持。如有需要请联系声网售前获取。其他

## 运行示例程序
在 [Agora.io 用户注册页](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。

在 [Agora.io SDK 下载页](https://www.agora.io/cn/blog/download/) 下载对应平台的 **语音通话 + 直播 SDK**。如需体验“FM 超高音质房间”，请联系声网售前获取特殊优化版本SDK。

#### iOS
1. 将有效的 AppID 填写进 KeyCenter.swift

	```
	static func appId() -> String {
	    return <#YOUR APPID#>
	}
	```

2. 解压 SDK 压缩包，将文件 **AgoraAudioKit.framework** 复制到本项目的 iOS/ChatRoom 文件夹下。
3. 使用 XCode 打开 iOS/ARD-Agora-Murder-Mystery-Game.xcodeproj，连接 iOS 测试设备，设置有效的开发者签名后即可运行。

		运行环境:
		* XCode 9.0 +
		* iOS 8.0 +

#### Android
1. 将有效的 AppID 填写进 "app/src/main/res/values/strings_config.xml"

	```
	<string name="private_app_id"><#YOUR APP ID#></string>
	```

2. 解压 SDK 压缩包，将其中的 **libs** 文件夹下的 ***.jar** 复制到本项目的 **app/libs** 下，其中的 **libs** 文件夹下的 **arm64-v8a**/**x86**/**armeabi-v7a** 复制到本项目的 **app/src/main/jniLibs** 下。
3. 使用 Android Studio 打开该项目，连接 Android 测试设备，编译并运行。

		运行环境:
		* Android Studio 2.0 +
		* minSdkVersion 16
		* 部分模拟器会存在功能缺失或者性能问题，所以推荐使用真机 Android 设备


## 联系我们

- 如果发现了示例程序的 bug，欢迎提交 [issue](https://github.com/AgoraIO-Usecase/ChatRoom/issues)
- 声网 SDK 完整 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题，你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题，可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持，你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单

## 代码许可

The MIT License (MIT).
