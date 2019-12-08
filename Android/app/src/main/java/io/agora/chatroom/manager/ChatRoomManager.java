package io.agora.chatroom.manager;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;

import java.util.Map;

import io.agora.chatroom.bean.AttributeKey;
import io.agora.chatroom.bean.ChannelData;
import io.agora.chatroom.bean.Member;
import io.agora.chatroom.bean.Message;
import io.agora.chatroom.bean.Seat;
import io.agora.chatroom.utils.Constant;
import io.agora.rtc.Constants;
import io.agora.rtm.ErrorInfo;
import io.agora.rtm.ResultCallback;
import io.agora.rtm.RtmMessage;

public final class ChatRoomManager {

    private final String TAG = ChatRoomManager.class.getSimpleName();

    private static ChatRoomManager instance;

    private RtcManager mRtcManager;
    private RtmManager mRtmManager;
    private ChannelEventListener mListener;

    private ChannelData mChannelData = new ChannelData();

    public ChannelData getChannelData() {
        return mChannelData;
    }

    private ChatRoomManager(Context context) {
        mRtcManager = RtcManager.instance(context);
        mRtcManager.setListener(mRtcListener);
        mRtmManager = RtmManager.instance(context);
        mRtmManager.setListener(mRtmListener);
    }

    public static ChatRoomManager instance(Context context) {
        if (instance == null) {
            synchronized (ChatRoomManager.class) {
                if (instance == null)
                    instance = new ChatRoomManager(context);
            }
        }
        return instance;
    }

    public void setListener(ChannelEventListener listener) {
        mListener = listener;
    }

    public void joinChannel(String channelId) {
        mRtmManager.login(Constant.sUserId, new ResultCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                updateMyMemberInfo();
                mRtcManager.joinChannel(channelId, Constant.sUserId);
            }

            @Override
            public void onFailure(ErrorInfo errorInfo) {

            }
        });
    }

    public void leaveChannel() {
        mRtcManager.leaveChannel();
        mRtmManager.leaveChannel();
        mChannelData.release();
    }

    public void toBroadcaster(String userId, int position) {
        if (Constant.isMyself(userId)) {
            int index = mChannelData.indexOfSeatArray(userId);
            if (position != index) {
                updateSeat(index, null, new ResultCallback<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        updateSeat(position, new Seat(userId), new ResultCallback<Void>() {
                            @Override
                            public void onSuccess(Void aVoid) {
                                mRtcManager.setClientRole(Constants.CLIENT_ROLE_BROADCASTER);
                            }

                            @Override
                            public void onFailure(ErrorInfo errorInfo) {

                            }
                        });
                    }

                    @Override
                    public void onFailure(ErrorInfo errorInfo) {

                    }
                });
            } else {
                updateSeat(position, new Seat(userId), new ResultCallback<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        mRtcManager.setClientRole(Constants.CLIENT_ROLE_BROADCASTER);
                    }

                    @Override
                    public void onFailure(ErrorInfo errorInfo) {

                    }
                });
            }
        } else {
            if (!mChannelData.isAnchorMyself()) return;
            sendOrder(userId, Message.ORDER_TYPE_BROADCASTER, String.valueOf(position));
        }
    }

    private void updateSeat(int position, Seat seat, ResultCallback<Void> callback) {
        if (position >= 0 && position < AttributeKey.KEY_SEAT_ARRAY.length) {
            mRtmManager.addOrUpdateChannelAttributes(AttributeKey.KEY_SEAT_ARRAY[position], new Gson().toJson(seat), callback);
        } else {
            callback.onSuccess(null);
        }
    }

    public void toAudience(String userId) {
        if (Constant.isMyself(userId)) {
            mRtcManager.setClientRole(Constants.CLIENT_ROLE_AUDIENCE);
//            int index = mChannelData.indexOfSeatArray(userId);
//            updateSeat(index, null, new ResultCallback<Void>() {
//                @Override
//                public void onSuccess(Void aVoid) {
//                }
//
//                @Override
//                public void onFailure(ErrorInfo errorInfo) {
//
//                }
//            });
        } else {
            if (!mChannelData.isAnchorMyself()) return;
            sendOrder(userId, Message.ORDER_TYPE_AUDIENCE, null);
        }
    }

    private void sendOrder(String userId, String orderType, String content) {
        Message message = new Message(orderType, content, Constant.sUserId);
        mRtmManager.sendMessageToPeer(userId, new Gson().toJson(message), new ResultCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {

            }

            @Override
            public void onFailure(ErrorInfo errorInfo) {

            }
        });
    }

    public void muteMic(String userId, boolean muted) {
        if (Constant.isMyself(userId)) {
            if (!mChannelData.isUserOnline(userId)) return;
            mRtcManager.muteLocalAudioStream(muted);
        } else {
            if (!mChannelData.isAnchorMyself()) return;
            sendOrder(userId, Message.ORDER_TYPE_MUTE, String.valueOf(muted));
        }
    }

    public void closeSeat(int position) {
        if (!mChannelData.isAnchorMyself()) return;
        Seat seat = mChannelData.getSeatArray()[position];
        updateSeat(position, new Seat(true), new ResultCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                if (seat != null) {
                    String userId = seat.getUserId();
                    if (mChannelData.isUserOnline(userId))
                        toAudience(userId);
                }
            }

            @Override
            public void onFailure(ErrorInfo errorInfo) {

            }
        });
    }

    public void openSeat(int position) {
        if (!mChannelData.isAnchorMyself()) return;
        updateSeat(position, null, null);
    }

    private void checkAndBeAnchor() {
        String myUserId = String.valueOf(Constant.sUserId);

        if (mChannelData.isAnchorMyself()) {
            toBroadcaster(myUserId, mChannelData.firstIndexOfEmptySeat());
        } else {
            if (mChannelData.hasAnchor()) return;
            mRtmManager.addOrUpdateChannelAttributes(AttributeKey.KEY_ANCHOR_ID, myUserId, new ResultCallback<Void>() {
                @Override
                public void onSuccess(Void aVoid) {
                    toBroadcaster(myUserId, mChannelData.firstIndexOfEmptySeat());
                }

                @Override
                public void onFailure(ErrorInfo errorInfo) {

                }
            });
        }
    }

    public void sendMessage(String text) {
        Message message = new Message(text, Constant.sUserId);
        mRtmManager.sendMessage(message.toJsonString(), new ResultCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                addMessage(message);
            }

            @Override
            public void onFailure(ErrorInfo errorInfo) {

            }
        });
    }

    public void givingGift() {
        Message message = new Message(Message.MESSAGE_TYPE_GIFT, null, Constant.sUserId);
        mRtmManager.sendMessage(message.toJsonString(), new ResultCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                if (mListener != null)
                    mListener.onUserGivingGift(message.getSendId());
            }

            @Override
            public void onFailure(ErrorInfo errorInfo) {

            }
        });
    }

    public void updateMyMemberInfo() {
        Member member = new Member(String.valueOf(Constant.sUserId), Constant.sName, Constant.sAvatarIndex);
        mRtmManager.setLocalUserAttributes(AttributeKey.KEY_USER_INFO, new Gson().toJson(member));
    }

    public void startMixing(boolean isStart) {
        if (isStart) {
            mRtcManager.startAudioMixing("/assets/mixing.mp3");
        } else {
            mRtcManager.stopAudioMixing();
        }
    }

    public void setReverbPreset(int type) {
        mRtcManager.setReverbPreset(type);
    }

    public void setVoiceChanger(int type) {
        mRtcManager.setVoiceChanger(type);
    }

    public int getMemberCount() {
        return mChannelData.getMemberList().size();
    }

    public void muteAllRemoteAudioStreams(boolean muted) {
        mRtcManager.muteAllRemoteAudioStreams(muted);
    }

    private RtcManager.RtcEventListener mRtcListener = new RtcManager.RtcEventListener() {
        @Override
        public void onJoinChannelSuccess(String channelId) {
            mRtmManager.joinChannel(channelId, null);
        }

        @Override
        public void onUserOnlineStateChanged(int uid, boolean isOnline) {
            if (isOnline) {
                mChannelData.addUser(uid, false);

                if (mListener != null)
                    mListener.onUserStatusChanged(String.valueOf(uid), false);
            } else {
                mChannelData.removeUser(uid);

                if (mListener != null)
                    mListener.onUserStatusChanged(String.valueOf(uid), null);
            }
        }

        @Override
        public void onUserMuteAudio(int uid, boolean muted) {
            mChannelData.addUser(uid, muted);

            if (mListener != null)
                mListener.onUserStatusChanged(String.valueOf(uid), muted);
        }

        @Override
        public void onAudioMixingStateChanged(boolean isPlaying) {
            if (mListener != null)
                mListener.onAudioMixingStateChanged(isPlaying);
        }

        @Override
        public void onAudioVolumeIndication(int uid, int volume) {
            if (mListener != null)
                mListener.onAudioVolumeIndication(String.valueOf(uid), volume);
        }
    };

    private RtmManager.RtmEventListener mRtmListener = new RtmManager.RtmEventListener() {
        @Override
        public void onChannelAttributesLoaded() {
            checkAndBeAnchor();
        }

        @Override
        public void onChannelAttributesUpdated(Map<String, String> attributes) {
            for (Map.Entry<String, String> entry : attributes.entrySet()) {
                String key = entry.getKey();
                switch (key) {
                    case AttributeKey.KEY_ANCHOR_ID:
                        String userId = entry.getValue();
                        if (mChannelData.setAnchorId(userId))
                            Log.i(TAG, String.format("onChannelAttributesUpdated %s %s", key, userId));
                        break;
                    default:
                        int index = AttributeKey.indexOfSeatKey(key);
                        if (index >= 0)
                            updateSeatArray(index, entry.getValue());
                        break;
                }
            }
        }

        @Override
        public void onMemberJoined(String userId, Map<String, String> attributes) {
            for (Map.Entry<String, String> entry : attributes.entrySet()) {
                if (AttributeKey.KEY_USER_INFO.equals(entry.getKey())) {
                    Member member = new Gson().fromJson(entry.getValue(), Member.class);

                    int index = mChannelData.addMember(member);

                    if (mListener != null)
                        mListener.onMemberAdded(index, member);
                    break;
                }
            }
        }

        @Override
        public void onMemberLeft(String userId) {
            int index = mChannelData.removeMember(userId);

            if (mListener != null)
                mListener.onMemberRemoved(index, userId);
        }

        @Override
        public void onMessageReceived(RtmMessage message) {
            processMessage(message);
        }
    };

    private void updateSeatArray(int position, String value) {
        Seat seat = new Gson().fromJson(value, Seat.class);
        boolean flag = mChannelData.updateSeat(position, seat);
        if (flag) {
            Log.i(TAG, String.format("onChannelAttributesUpdated %s %s", AttributeKey.KEY_SEAT_ARRAY[position], value));

            if (mListener != null)
                mListener.onSeatStatusUpdated(position);
        }
    }

    private void processMessage(RtmMessage rtmMessage) {
        Message message = new Gson().fromJson(rtmMessage.getText(), Message.class);
        switch (message.getMessageType()) {
            case Message.MESSAGE_TYPE_TEXT:
            case Message.MESSAGE_TYPE_IMAGE:
                addMessage(message);
                break;
            case Message.MESSAGE_TYPE_GIFT:
                if (mListener != null)
                    mListener.onUserGivingGift(message.getSendId());
                break;
            case Message.MESSAGE_TYPE_ORDER:
                String myUserId = String.valueOf(Constant.sUserId);
                switch (message.getOrderType()) {
                    case Message.ORDER_TYPE_AUDIENCE:
                        toAudience(myUserId);
                        break;
                    case Message.ORDER_TYPE_BROADCASTER:
                        toBroadcaster(myUserId, Integer.valueOf(message.getContent()));
                        break;
                    case Message.ORDER_TYPE_MUTE:
                        muteMic(myUserId, Boolean.valueOf(message.getContent()));
                        break;
                }
                break;
        }
    }

    private void addMessage(Message message) {
        int position = mChannelData.addMessage(message);
        if (mListener != null)
            mListener.onMessageAdded(position);
    }

}
