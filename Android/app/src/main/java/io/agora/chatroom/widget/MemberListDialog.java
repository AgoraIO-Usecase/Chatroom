package io.agora.chatroom.widget;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import io.agora.chatroom.ChatRoomActivity;
import io.agora.chatroom.R;
import io.agora.chatroom.adapter.MemberListAdapter;
import io.agora.chatroom.bean.ChannelData;
import io.agora.chatroom.manager.ChatRoomManager;

public class MemberListDialog extends DialogFragment implements MemberListAdapter.OnItemClickListener {

    @BindView(R.id.tv_title)
    TextView tv_title;
    @BindView(R.id.rv_member_list)
    MemberListRecyclerView rv_member_list;

    private ChatRoomActivity mActivity;

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        mActivity = (ChatRoomActivity) context;
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState) {
        Dialog dialog = new Dialog(mActivity);
        dialog.setContentView(R.layout.dialog_member_list);

        ButterKnife.bind(this, dialog);

        refreshTitle();
        initRecyclerView();
        return dialog;
    }

    @Override
    public void onStart() {
        super.onStart();
        Dialog dialog = getDialog();
        if (dialog != null) {
            Window window = dialog.getWindow();
            if (window != null)
                window.setBackgroundDrawableResource(android.R.color.transparent);
        }
    }

    private void initRecyclerView() {
        rv_member_list.setOnItemClickListener(this);
    }

    private void refreshTitle() {
        if (mActivity != null) {
            int num = mActivity.getManager().getChannelData().getMemberList().size();
            tv_title.setText(mActivity.getString(R.string.channel_member_list, num));
        }
    }

    public void notifyItemInserted(int position) {
        refreshTitle();
        if (rv_member_list != null) {
            rv_member_list.notifyItemInserted(position);
            rv_member_list.scrollToPosition(position);
        }
    }

    public void notifyItemRemoved(int position) {
        refreshTitle();
        if (rv_member_list != null) {
            rv_member_list.notifyItemRemoved(position);
            rv_member_list.scrollToPosition(position);
        }
    }

    public void notifyItemChangedByUserId(String userId) {
        if (rv_member_list != null)
            rv_member_list.notifyItemChangedByUserId(userId);
    }

    @Override
    public void onItemClick(View view, int position, String userId) {
        ChatRoomManager manager = mActivity.getManager();
        ChannelData channelData = manager.getChannelData();
        switch (view.getId()) {
            case R.id.btn_role:
                if (channelData.isUserOnline(userId))
                    manager.toAudience(userId);
                else
                    manager.toBroadcaster(userId, channelData.firstIndexOfEmptySeat());
                break;
            case R.id.btn_mute:
                manager.muteMic(userId, !channelData.isUserMuted(userId));
                break;
        }
    }

    @OnClick({R.id.btn_close})
    public void onClick(View view) {
        dismiss();
    }

}
