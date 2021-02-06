package io.agora.chatroom;

import android.app.Application;

import cn.leancloud.AVOSCloud;
import io.agora.chatroom.manager.RtcManager;
import io.agora.chatroom.manager.RtmManager;

public class ChatRoomApplication extends Application {

    public static Application instance;

    public ChatRoomApplication() {
        instance = this;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        RtcManager.instance(this).init();
        RtmManager.instance(this).init();
        AVOSCloud.initialize(this, instance.getApplicationContext().getString(R.string.leancloud_app_id),
                instance.getApplicationContext().getString(R.string.leancloud_app_key),
                instance.getApplicationContext().getString(R.string.leancloud_server_url));

    }

}
