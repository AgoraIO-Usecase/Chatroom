package io.agora.chatroom;

/**
 * Created by yt on 2018/7/27/027.
 */

public class User {
    private int uid;
    // 音量值
    private int audioVolum;
    // 音频 mute 状态
    private boolean audioMute;
    // 是否是自己
    private boolean isUserSelf;


    public User(int uid, int audioVolum, boolean audioMute, boolean isUserSelf) {
        this.uid = uid;
        this.audioVolum = audioVolum;
        this.audioMute = audioMute;
        this.isUserSelf = isUserSelf;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public boolean isAudioMute() {
        return audioMute;
    }

    public void setAudioMute(boolean audioMute) {
        this.audioMute = audioMute;
    }

    public int getAudioVolum() {
        return audioVolum;
    }

    public void setAudioVolum(int audioVolum) {
        this.audioVolum = audioVolum;
    }

    public boolean isUserSelf() {
        return isUserSelf;
    }

    public void setUserSelf(boolean userSelf) {
        isUserSelf = userSelf;
    }
}
