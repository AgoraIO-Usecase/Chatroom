package io.agora.chatroom;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import butterknife.OnEditorAction;
import io.agora.chatroom.adapter.SeatGridAdapter;
import io.agora.chatroom.bean.ChannelData;
import io.agora.chatroom.bean.Member;
import io.agora.chatroom.bean.Seat;
import io.agora.chatroom.manager.ChannelEventListener;
import io.agora.chatroom.manager.ChatRoomManager;
import io.agora.chatroom.utils.AlertUtils;
import io.agora.chatroom.utils.Constant;
import io.agora.chatroom.widget.GiftPopView;
import io.agora.chatroom.widget.MemberListDialog;
import io.agora.chatroom.widget.MessageListRecyclerView;
import io.agora.chatroom.widget.SeatGridRecyclerView;
import io.agora.chatroom.widget.VoiceEffectDialog;

import static android.Manifest.permission.RECORD_AUDIO;
import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static androidx.core.content.PermissionChecker.PERMISSION_GRANTED;

public class ChatRoomActivity extends AppCompatActivity implements ChannelEventListener, SeatGridAdapter.OnItemClickListener {

    public static final String BUNDLE_KEY_CHANNEL_ID = "channelId";
    public static final String BUNDLE_KEY_BACKGROUND_RES = "backgroundRes";
    private final int PERMISSION_REQ_ID = 22;

    private ChatRoomManager mManager;

    public ChatRoomManager getManager() {
        return mManager;
    }

    private MemberListDialog mMemberDialog = new MemberListDialog();
    private VoiceEffectDialog mEffectDialog = new VoiceEffectDialog();
    private String mChannelId;
    private boolean mMuteRemote;

    @BindView(R.id.container)
    ConstraintLayout container;
    @BindView(R.id.tv_title)
    TextView tv_title;
    @BindView(R.id.btn_num)
    TextView btn_num;
    @BindView(R.id.rv_seat_grid)
    SeatGridRecyclerView rv_seat_grid;
    @BindView(R.id.rv_message_list)
    MessageListRecyclerView rv_message_list;
    @BindView(R.id.cb_mixing)
    CheckBox cb_mixing;
    @BindView(R.id.btn_mic)
    ImageButton btn_mic;
    @BindView(R.id.gift)
    GiftPopView gift;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_room);
        ButterKnife.bind(this);

        initView();
        initManager();
        refreshNum();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mManager.leaveChannel();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQ_ID) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED)
                mManager.joinChannel(mChannelId);
            else
                AlertUtils.showAlertDialog(this, "No permission", "finish", (dialog, which) -> finish());
        }
    }

    private void initView() {
        Intent intent = getIntent();
        container.setBackgroundResource(intent.getIntExtra(BUNDLE_KEY_BACKGROUND_RES, 0));
        mChannelId = intent.getStringExtra(BUNDLE_KEY_CHANNEL_ID);
        tv_title.setText(mChannelId);
        rv_seat_grid.setOnItemClickListener(this);
    }

    private void refreshNum() {
        btn_num.setText(String.valueOf(mManager.getMemberCount()));
    }

    private void initManager() {
        mManager = ChatRoomManager.instance(this);
        mManager.setListener(this);
        if (checkPermission())
            mManager.joinChannel(mChannelId);
    }

    private boolean checkPermission() {
        if (ContextCompat.checkSelfPermission(this, RECORD_AUDIO) != PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(this, WRITE_EXTERNAL_STORAGE) != PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{RECORD_AUDIO, WRITE_EXTERNAL_STORAGE}, PERMISSION_REQ_ID);
            return false;
        }
        return true;
    }

    public void givingGift(View view) {
        mManager.givingGift();
    }

    @OnCheckedChanged({R.id.cb_mixing})
    public void onCheckedChanged(CompoundButton view, boolean isChecked) {
        switch (view.getId()) {
            case R.id.cb_mixing:
                mManager.startMixing(isChecked);
                break;
        }
    }

    @OnClick({R.id.btn_exit, R.id.btn_num, R.id.btn_effect, R.id.btn_mic, R.id.btn_speaker})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_exit:
                finish();
                break;
            case R.id.btn_num:
                mMemberDialog.show(getSupportFragmentManager(), null);
                break;
            case R.id.btn_effect:
                mEffectDialog.show(getSupportFragmentManager(), null);
                break;
            case R.id.btn_mic:
                String myUserId = String.valueOf(Constant.sUserId);
                mManager.muteMic(myUserId, !mManager.getChannelData().isUserMuted(myUserId));
                break;
            case R.id.btn_speaker:
                mMuteRemote = !mMuteRemote;
                ((ImageButton) view).setImageResource(mMuteRemote ? R.mipmap.ic_speaker_off : R.mipmap.ic_speaker_on);
                mManager.muteAllRemoteAudioStreams(mMuteRemote);
                break;
        }
    }

    @OnEditorAction({R.id.et_input})
    public void onEditorAction(TextView v, int actionId, KeyEvent event) {
        if (actionId == EditorInfo.IME_ACTION_SEND || event.getKeyCode() == KeyEvent.KEYCODE_ENTER) {
            String message = v.getText().toString();
            if (TextUtils.isEmpty(message)) return;
            mManager.sendMessage(message);
            v.setText("");
        }
    }

    @Override
    public void onItemClick(View view, int position, Seat seat) {
        ChannelData channelData = mManager.getChannelData();
        boolean isAnchor = channelData.isAnchorMyself();
        if (seat != null) {
            if (seat.isClosed()) {
                if (isAnchor)
                    showSeatPop(view, new int[]{R.id.open_seat}, null, position);
                return;
            } else {
                String userId = seat.getUserId();
                boolean online = channelData.isUserOnline(userId);
                if (online) {
                    if (isAnchor) {
                        boolean muted = channelData.isUserMuted(userId);
                        showSeatPop(view, new int[]{
                                R.id.to_audience,
                                muted ? R.id.turn_on_mic : R.id.turn_off_mic,
                                R.id.close_seat
                        }, userId, position);
                    } else {
                        if (Constant.isMyself(userId))
                            showSeatPop(view, new int[]{R.id.to_audience}, userId, position);
                    }
                    return;
                }
            }
        }
        showSeatPop(
                view,
                isAnchor ? new int[]{R.id.to_broadcast, R.id.close_seat} : new int[]{R.id.to_broadcast},
                String.valueOf(Constant.sUserId),
                position
        );
    }

    private void showSeatPop(View view, int[] ids, String userId, int position) {
        AlertUtils.showPop(this, view, ids, (index, menu) -> {
            switch (menu.getId()) {
                case R.id.to_broadcast:
                    mManager.toBroadcaster(String.valueOf(Constant.sUserId), position);
                    break;
                case R.id.to_audience:
                    mManager.toAudience(userId);
                    break;
                case R.id.turn_off_mic:
                    mManager.muteMic(userId, true);
                    break;
                case R.id.turn_on_mic:
                    mManager.muteMic(userId, false);
                    break;
                case R.id.close_seat:
                    mManager.closeSeat(position);
                    break;
                case R.id.open_seat:
                    mManager.openSeat(position);
                    break;
            }
            return true;
        }, null);
    }

    @Override
    public void onSeatStatusUpdated(int position) {
        runOnUiThread(() -> rv_seat_grid.notifyItemChanged(position));
    }

    @Override
    public void onUserGivingGift(String userId) {
        runOnUiThread(() -> gift.show(userId));
    }

    @Override
    public void onMessageAdded(int position) {
        runOnUiThread(() -> rv_message_list.notifyItemInserted(position));
    }

    @Override
    public void onMemberAdded(int position, Member member) {
        runOnUiThread(() -> {
            refreshNum();
            rv_seat_grid.notifyItemChanged(member.getUserId(), false);
            mMemberDialog.notifyItemInserted(position);
        });
    }

    @Override
    public void onMemberRemoved(int position, String userId) {
        runOnUiThread(() -> {
            refreshNum();
            rv_seat_grid.notifyItemChanged(userId, false);
            mMemberDialog.notifyItemRemoved(position);
        });
    }

    @Override
    public void onUserStatusChanged(String userId, Boolean muted) {
        runOnUiThread(() -> {
            if (Constant.isMyself(userId)) {
                if (muted != null && muted)
                    btn_mic.setImageResource(R.mipmap.ic_mic_off);
                else
                    btn_mic.setImageResource(R.mipmap.ic_mic_on);
            }
            rv_seat_grid.notifyItemChanged(userId, false);
            mMemberDialog.notifyItemChangedByUserId(userId);
        });
    }

    @Override
    public void onAudioMixingStateChanged(boolean isPlaying) {
        runOnUiThread(() -> cb_mixing.setChecked(isPlaying));
    }

    @Override
    public void onAudioVolumeIndication(String userId, int volume) {
        runOnUiThread(() -> rv_seat_grid.notifyItemChanged(userId, true));
    }

}
