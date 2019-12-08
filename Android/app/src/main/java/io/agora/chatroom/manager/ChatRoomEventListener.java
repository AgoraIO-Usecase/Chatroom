package io.agora.chatroom.manager;

public interface ChatRoomEventListener {

    void onSeatUpdated(int position);

    void onUserGivingGift(String userId);

    void onMessageAdded(int position);

    void onMemberListUpdated(String userId);

    void onUserStatusChanged(String userId, Boolean muted);

    void onAudioMixingStateChanged(boolean isPlaying);

    void onAudioVolumeIndication(String userId, int volume);

}
