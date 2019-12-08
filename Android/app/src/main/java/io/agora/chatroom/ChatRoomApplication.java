package io.agora.chatroom;

import android.app.Application;

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
        String appId = getString(R.string.private_app_id);
        RtcManager.instance(this).init(appId);
        RtmManager.instance(this).init(appId);
    }

}
