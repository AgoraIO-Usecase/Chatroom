package io.agora.chatroom.manager;

import io.agora.chatroom.bean.Member;

public interface ChannelEventListener {

    void onSeatStatusUpdated(int position);

    void onUserGivingGift(String userId);

    void onMessageAdded(int position);

    void onMemberAdded(int position, Member member);

    void onMemberRemoved(int position, String userId);

    void onUserStatusChanged(String userId, Boolean muted);

    void onAudioMixingStateChanged(boolean isPlaying);

    void onAudioVolumeIndication(String userId, int volume);

}
