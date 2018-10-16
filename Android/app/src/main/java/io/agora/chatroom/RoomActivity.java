package io.agora.chatroom;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import java.util.ArrayList;
import java.util.List;
import io.agora.adapter.PopuwindowAdapter;
import io.agora.adapter.UsesAdapter;
import io.agora.rtc.Constants;
import io.agora.rtc.IRtcEngineEventHandler;
import io.agora.rtc.RtcEngine;
import io.agora.utils.Constant;
import io.agora.utils.SoundEffectUtil;

/**
 * Created by yt on 2018/8/15/015.
 */

public class RoomActivity extends Activity {
    private static final int PERMISSION_REQ_ID_RECORD_AUDIO = 22;

    private ListView mListView;
    private TextView mTextViewTitle;
    private CheckBox mCheckBoxToBroadCast;
    private CheckBox mCheckBoxSpeakOut;
    private CheckBox mCheckBoxMuteLocalAudio;
    private CheckBox mCheckBoxMuteRemoteAudio;
    private CheckBox mCheckBoxAudioMixing;
    private CheckBox mCheckBoxAudioAccents;
    private String mChannelName;
    private String mTitleName;

    private boolean bIsBroadCaster = false;
    private int mRoomMode;
    private RtcEngine mRtcEngine;
    private List<User> mUserList = new ArrayList<>();
    private UsesAdapter mAdapter;
    private int mChangeVolumnIndex = -1;
    // uid 在 onJoinChannelSuccess 回调中进行赋值，值来自服务器生成的唯一随机数。这个随机数用 uid 记录
    private int mLocalUid;

    /**
     * 声网频道内业务回调
     */
    private final IRtcEngineEventHandler mRtcEventHandler = new IRtcEngineEventHandler() {

        @Override
        public void onUserJoined(final int uid, int elapsed) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    // 当有用户加入时，添加到用户列表
                    mUserList.add(new User(uid, 0, false, false));
                    mAdapter.notifyDataSetChanged();
                }
            });
        }

        @Override
        public void onUserOffline(final int uid, int reason) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    // 当用户离开时，从用户列表中清除
                    mUserList.remove(getUserIndex(uid));
                    mAdapter.notifyDataSetChanged();
                }
            });
        }

        @Override
        public void onUserMuteAudio(final int uid, final boolean muted) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    // 收到某个uid mute 状态后刷新人员列表
                    int index = getUserIndex(uid);
                    mUserList.get(index).setAudioMute(muted);
                    mAdapter.notifyDataSetChanged();
                }
            });
        }

        @Override
        public void onJoinChannelSuccess(final String channel, final int uid, int elapsed) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {

                    // onJoinChannelSuccess 回调中，uid 不会为0
                    // 当 joinChannel api 中填入 0 时，agora 服务器会生成一个唯一的随机数，并在 onJoinChannelSuccess 回调中返回
                    mLocalUid = uid;
                    mUserList.clear();
                    /** 进入频道，主播状态下将自己加入到 user 列表**/
                    if (bIsBroadCaster) {
                        mUserList.add(new User(uid, 0, false, true));
                    }
                    if (mAdapter != null)
                        mAdapter.notifyDataSetChanged();
                }
            });
        }

        @Override
        public void onAudioVolumeIndication(final IRtcEngineEventHandler.AudioVolumeInfo[] speakers, int totalVolume) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (speakers != null) {
                        for (IRtcEngineEventHandler.AudioVolumeInfo audioVolumeInfo : speakers) {

                            /**
                             * 根据uid判断是他人还是自己， uid 0 默认是自己，根据 uid = 0 的取本地音量值，和joinchannelsuccess 内
                             * 本地的 LocalUid 对应
                             *
                             */
                            if (audioVolumeInfo.uid != 0) {
                                int index = getUserIndex(audioVolumeInfo.uid);
                                if (index >= 0) {
                                    mUserList.get(index).setAudioVolum(audioVolumeInfo.volume);
                                }
                            } else {
                                int index = getUserIndex(mLocalUid);
                                if (index >= 0) {
                                    mUserList.get(index).setAudioVolum(audioVolumeInfo.volume);
                                }
                            }
                        }
                        mAdapter.notifyDataSetChanged();
                    }
                }
            });
        }

        @Override
        public void onAudioMixingFinished() {
            super.onAudioMixingFinished();
            /** 伴奏播放结束时，将button 置为未选中状态 **/
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mCheckBoxAudioMixing.setChecked(false);
                }
            });
        }
    };

    private int getUserIndex(int uid) {
        for (int i = 0; i < mUserList.size(); i++) {
            if (mUserList.get(i).getUid() == uid) {
                return i;
            }
        }
        return -1;
    }
    @Override
    protected void onPause(){
        super.onPause();
    }

    @Override
    protected void onStop(){
        RtcEngine.destroy();
        super.onStop();
    }

    @Override
    protected void onDestroy(){
        super.onDestroy();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_room);
        /***
         * 动态申请权限
         */
        if (checkSelfPermission(Manifest.permission.RECORD_AUDIO, PERMISSION_REQ_ID_RECORD_AUDIO)) {

            initAgoraEngineAndJoinChannel();
        }
    }

    public boolean checkSelfPermission(String permission, int requestCode) {

        if (ContextCompat.checkSelfPermission(this,
                permission)
                != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(this,
                    new String[]{permission},
                    requestCode);
            return false;
        }
        return true;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String permissions[], @NonNull int[] grantResults) {

        switch (requestCode) {
            case PERMISSION_REQ_ID_RECORD_AUDIO: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    initAgoraEngineAndJoinChannel();
                } else {
                    showLongToast("No permission for " + Manifest.permission.RECORD_AUDIO);
                    finish();
                }
                break;
            }

        }
    }

    public final void showLongToast(final String msg) {
        this.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_LONG).show();
            }
        });
    }

    private void initAgoraEngineAndJoinChannel() {
        String appID = getString(R.string.private_app_id);

        try {
            // 初始化SDK对象
            mRtcEngine = RtcEngine.create(getBaseContext(), appID, mRtcEventHandler);
            mRtcEngine.setLogFile("/sdcard/chatRoom.log");

        } catch (Exception e) {

            throw new RuntimeException("NEED TO check rtc sdk init fatal error\n" + Log.getStackTraceString(e));
        }

        setupData();
        setupUI();

        /** 根据房间类型设置 audioProfile **/
        switch (mRoomMode) {
            case Constant.ChatRoomGamingStandard:
                /** 开黑聊天室 */
                mRtcEngine.setAudioProfile(Constants.AUDIO_PROFILE_SPEECH_STANDARD, Constants.AUDIO_SCENARIO_CHATROOM_GAMING);
                break;
            case Constant.ChatRoomEntertainmentStandard:
                /** 娱乐聊天室 */
                mRtcEngine.setAudioProfile(Constants.AUDIO_PROFILE_MUSIC_STANDARD, Constants.AUDIO_SCENARIO_CHATROOM_ENTERTAINMENT);
                break;
            case Constant.ChatRoomEntertainmentHighQuality:
                /** K 歌房 */
                mRtcEngine.setAudioProfile(Constants.AUDIO_PROFILE_MUSIC_HIGH_QUALITY, Constants.AUDIO_SCENARIO_CHATROOM_ENTERTAINMENT);
                break;
            case Constant.ChatRoomGamingHighQuality:
                /** FM 超高音质**/
                mRtcEngine.setAudioProfile(Constants.AUDIO_PROFILE_MUSIC_HIGH_QUALITY_STEREO, Constants.AUDIO_SCENARIO_SHOWROOM);
                break;
        }
        // 设置直播模式
        mRtcEngine.setChannelProfile(Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);
        // 启动音量监听
        mRtcEngine.enableAudioVolumeIndication(1000, 3);
        // 当 joinChannel api 中填入 0 时，agora 服务器会生成一个唯一的随机数，并在 onJoinChannelSuccess 回调中返回
        mRtcEngine.joinChannel(null, mChannelName, "", 0);

    }

    /**
     * 获取从上一个界面传过来的频道信息，角色信息
     */
    private void setupData() {
        Intent intent = getIntent();
        if (intent != null) {
            mRoomMode = intent.getIntExtra(Constant.ACTION_KEY_ROOM_MODE, Constant.ChatRoomGamingStandard);
            bIsBroadCaster = intent.getIntExtra(Constant.ACTION_KEY_CROLE, Constants.CLIENT_ROLE_BROADCASTER) == Constants.CLIENT_ROLE_BROADCASTER;
            mChannelName = intent.getStringExtra(Constant.ACTION_KEY_ROOM_NAME);
            mTitleName = intent.getStringExtra(Constant.ACTION_KEY_TITLE_NAME);
        }
    }

    private void setupUI() {
        mTextViewTitle = (TextView) findViewById(R.id.room_name);
        mListView = (ListView) findViewById(R.id.room_listview);
        mTextViewTitle.setText(mTitleName);
        mAdapter = new UsesAdapter(this, mUserList);
        mListView.setAdapter(mAdapter);

        mCheckBoxToBroadCast = (CheckBox) findViewById(R.id.room_to_broadcast);
        mCheckBoxSpeakOut = (CheckBox) findViewById(R.id.room_speak_out);
        mCheckBoxMuteLocalAudio = (CheckBox) findViewById(R.id.room_mute_self);
        mCheckBoxMuteRemoteAudio = (CheckBox) findViewById(R.id.room_mute_other);
        mCheckBoxAudioMixing = (CheckBox) findViewById(R.id.room_audio_mixing);
        mCheckBoxAudioAccents = (CheckBox) findViewById(R.id.room_audio_accents);
        mCheckBoxToBroadCast.setOnCheckedChangeListener(onCheckedChangeListener);
        mCheckBoxSpeakOut.setOnCheckedChangeListener(onCheckedChangeListener);
        mCheckBoxMuteLocalAudio.setOnCheckedChangeListener(onCheckedChangeListener);
        mCheckBoxMuteRemoteAudio.setOnCheckedChangeListener(onCheckedChangeListener);
        mCheckBoxAudioMixing.setOnCheckedChangeListener(onCheckedChangeListener);
        mCheckBoxAudioAccents.setOnCheckedChangeListener(onCheckedChangeListener);
        /**
         * 刚进入时根据是观众还是主播状态做一次UI控制，伴奏，变音，静音自己按钮不可点击
         * */
        if (bIsBroadCaster) {
            mCheckBoxToBroadCast.setChecked(true);
            showBroadCast();
        } else {
            mCheckBoxToBroadCast.setChecked(false);
            showAudience();
        }
    }

    /**
     * 上下麦，声音外放，本地听筒 mute 按钮和 microphone mute 按钮状态切换
     **/
    private CompoundButton.OnCheckedChangeListener onCheckedChangeListener = new CompoundButton.OnCheckedChangeListener() {
        @Override
        public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
            switch (buttonView.getId()) {
                case R.id.room_to_broadcast:
                    bIsBroadCaster = isChecked;
                    if (isChecked) {
                        showBroadCast();
                    } else {
                        showAudience();
                    }
                    break;
                case R.id.room_speak_out:
                    // 切换听筒还是外放
                    mRtcEngine.setEnableSpeakerphone(isChecked);
                    break;
                case R.id.room_mute_other:
                    mRtcEngine.muteAllRemoteAudioStreams(isChecked);
                    break;
                case R.id.room_mute_self:
                    mRtcEngine.muteLocalAudioStream(isChecked);
                    break;
                case R.id.room_audio_mixing:
                    // 播放伴奏音乐
                    if (isChecked) {
                        mRtcEngine.startAudioMixing("/assets/mixing.mp3", false, false, 1);
                        // 调整伴奏音量，防止伴奏声音过大影响人声
                        mRtcEngine.adjustAudioMixingVolume(15);
                    } else {
                        mRtcEngine.stopAudioMixing();
                    }

                    break;
                case R.id.room_audio_accents:
                    showPopuWindowMenu(buttonView);
                    break;
            }
        }
    };

    /**
     * 通过popuwindow 显示变色的选项
     *
     * @param parentView
     */
    private void showPopuWindowMenu(final View parentView) {
        View conventView = LayoutInflater.from(this).inflate(R.layout.activity_popuwindow, null, false);
        final PopupWindow popupWindow = new PopupWindow(conventView, 300, RelativeLayout.LayoutParams.WRAP_CONTENT, true);

        ListView listview = (ListView) conventView.findViewById(R.id.pop_listview);
        final PopuwindowAdapter popAdapter = new PopuwindowAdapter(this);
        popAdapter.setSelectIndex(mChangeVolumnIndex);
        listview.setAdapter(popAdapter);
        listview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                /**
                 * 选择事件，如果是当前选项，则取消选中，设默认值。不是则修改选中条目背景色
                 * **/

                if (position == mChangeVolumnIndex) {
                    mChangeVolumnIndex = -1;
                    mCheckBoxAudioAccents.setBackgroundColor(getResources().getColor(R.color.gray));
                } else {
                    mChangeVolumnIndex = position;
                    mCheckBoxAudioAccents.setBackgroundColor(getResources().getColor(R.color.agora_blue));
                }

                SoundEffectUtil.changeEffect(mRtcEngine, mChangeVolumnIndex + 1);
                popAdapter.setSelectIndex(position);
                popAdapter.notifyDataSetChanged();
                ((CheckBox) parentView).setText(Constant.SOUNDARRAY[position]);
                popupWindow.dismiss();
            }
        });

        popupWindow.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        popupWindow.setOutsideTouchable(true);
        popupWindow.setTouchable(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N_MR1) {

            int[] location = new int[2];
            parentView.getLocationOnScreen(location);

            DisplayMetrics displayMetrics = new DisplayMetrics();
            WindowManager windowManager = getWindowManager();
            windowManager.getDefaultDisplay().getMetrics(displayMetrics);
            popupWindow.showAtLocation(parentView, Gravity.LEFT | Gravity.BOTTOM, location[0], (int) (displayMetrics.heightPixels - location[1] + 40 * displayMetrics.density));

        } else {
            popupWindow.showAsDropDown(parentView, 0, 8);
        }


    }

    /**
     * 上麦界面
     */
    private void showBroadCast() {

        // 设置为主播
        mRtcEngine.setClientRole(Constants.CLIENT_ROLE_BROADCASTER);
        // role 改变后需要将自己添加到用户列表
        if (mLocalUid != 0) {
            mUserList.add(new User(mLocalUid, 0, false, true));
            mAdapter.notifyDataSetChanged();
        }
        // 上麦状态下，部分功能按钮可点击
        mCheckBoxAudioAccents.setEnabled(true);
        mCheckBoxAudioMixing.setEnabled(true);
        mCheckBoxMuteLocalAudio.setEnabled(true);
        mCheckBoxSpeakOut.setChecked(true);

    }

    /**
     * 下麦界面
     */
    private void showAudience() {
        //设为观众
        mRtcEngine.setClientRole(Constants.CLIENT_ROLE_AUDIENCE);
        if (mCheckBoxAudioMixing.isChecked()) {
            mCheckBoxAudioMixing.setChecked(false);
        }
        // role 为观众后需要将自己从用户列表移除
        int index = getUserIndex(mLocalUid);
        if (index >= 0) {
            mUserList.remove(index);
        }
        mAdapter.notifyDataSetChanged();

        // 下麦状态下，部分功能按钮不可点击
        mCheckBoxAudioAccents.setEnabled(false);
        mCheckBoxAudioMixing.setEnabled(false);
        mCheckBoxMuteLocalAudio.setEnabled(false);
        // 下麦状态下，伴奏按钮状态还原
        mCheckBoxAudioMixing.setChecked(false);
        mCheckBoxMuteLocalAudio.setChecked(false);

    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        leaveChannel();
    }

    /**
     * 退出按钮点击事件
     *
     * @param view
     */
    public void finishRoom(View view) {
        leaveChannel();
    }

    /**
     * 离开频道
     **/
    private void leaveChannel() {

        if (mRtcEngine != null) {
            mRtcEngine.leaveChannel();
        }
        finish();
    }
}
