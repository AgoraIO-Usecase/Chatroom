# 在线语音聊天室

**语音聊天室** 是一种纯音频的使用场景。用户作为主播或者听众加入房间进行语音聊天，也可以在房间内任意切换自己的主播/听众身份。

这个示例程序展示了对音频设置有不同的需求的四种常见语音聊天室类型：

- **开黑聊天室**: 频道内用户需要频繁上下麦，用户不想花费过多流量
- **娱乐房间**: 频道内用户需要频繁上下麦，用户对流量使用不敏感，对音质有要求
- **K 歌房**: 满足唱歌场景需求，还原KTV效果
- **FM 超高音质房间**: 超高音质，声音还原度高，语音电台主播首选

## 功能列表
这个示例程序演示了如何使用 声网 Agora 的音频SDK，实现不同类型语音聊天室的音频聊天功能。

- 加入房间：选择一个房间类型，使用主播或听众的身份加入房间，和房间内的其他用户进行语音交流；
- 主播/听众切换：在房间内可以随时使用“上麦”按钮来切换自己的主播/听众身份；
- 听筒/外放切换：可以使用“外放”按钮切换听筒或外放；
- 停止发送音频：主播可以使用“静音自己”按钮停止发送音频；
- 停止接收音频：可以使用“不收音频”按钮停止接收房间内其他人的音频；
- 音乐伴奏：主播可以使用“伴奏”按钮播放伴奏音乐并发送给房间内其他人；
- 变声效果：主播可以使用“变声”按钮选择自己的变声效果。

## 注意事项
1. 示例程序只演示了“语音聊天室”类场景中和语音聊天相关部分的逻辑，不是完整的产品。如要开发完整的产品，需要自行实现业务部分逻辑；
2. “FM 超高音质房间” 需要使用 声网 Agora 提供的特殊优化版本SDK，官网SDK版本尚无法支持。如有需要请联系声网售前获取。

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
	​	* XCode 9.0 +
	​	* iOS 8.0 +

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

#### 网络
请确保在使用 Agora 相关功能及服务前，已打开特定端口，详见 [防火墙说明](https://docs.agora.io/cn/Agora%20Platform/firewall?platform=All%20Platforms)。

## 常见问题
1. 当 audioProfile 的 scenario 被设为 Default，ShowRoom，Education，GameStreaming 且为单主播时不开启降噪

		如果在这种情况下，觉得噪声过大，可以通过私有接口 agoraKit.setParameters("{\"che.audio.enable.ns\":true}") 来开启降噪
   
2. 当调用 disableAudio 或 leaveChannel 时，如果有其他应用在使用 AVAudioSession 时（进行录放音）会被打断

		可以通过调用 agoraKit.setAudioSessionOperationRestriction(.deactivateSession) 来使 audio session 在 disableAudio 或 leaveChannel 后依然保持活跃状态

## 联系我们

- 如果发现了示例程序的 bug，欢迎提交 [issue](https://github.com/AgoraIO-Usecase/ChatRoom/issues)
- 声网 SDK 完整 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题，你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题，可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持，你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单

## 代码许可

The MIT License (MIT).
