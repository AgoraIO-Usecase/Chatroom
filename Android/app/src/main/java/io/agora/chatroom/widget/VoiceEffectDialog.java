package io.agora.chatroom.widget;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RadioGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import butterknife.BindView;
import butterknife.ButterKnife;
import io.agora.chatroom.R;
import io.agora.chatroom.adapter.VoiceEffectGridAdapter;
import io.agora.chatroom.manager.ChatRoomManager;
import io.agora.chatroom.manager.RtcManager;

public class VoiceEffectDialog extends DialogFragment implements VoiceEffectGridAdapter.OnItemClickListener, RadioGroup.OnCheckedChangeListener {

    @BindView(R.id.rg_title)
    RadioGroup rg_title;
    @BindView(R.id.rv_effect_grid)
    VoiceEffectGridRecyclerView rv_effect_grid;

    private Context mContext;

    private int mEffectSelectedIndex;
    private int mBeautifySelectedIndex;

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        mContext = context;
    }

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState) {
        Dialog dialog = new Dialog(mContext);
        dialog.setContentView(R.layout.dialog_effect_grid);

        ButterKnife.bind(this, dialog);

        initView();
        return dialog;
    }

    @Override
    public void onStart() {
        super.onStart();
        Dialog dialog = getDialog();
        if (dialog != null) {
            Window window = dialog.getWindow();
            if (window != null) {
                window.setBackgroundDrawableResource(android.R.color.transparent);
                WindowManager.LayoutParams params = window.getAttributes();
                params.gravity = Gravity.BOTTOM;
                params.width = WindowManager.LayoutParams.MATCH_PARENT;
                params.height = WindowManager.LayoutParams.WRAP_CONTENT;
                window.setAttributes(params);
            }
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        rg_title.check(R.id.rb_effect);
    }

    private void initView() {
        rg_title.setOnCheckedChangeListener(this);
        rv_effect_grid.setOnItemClickListener(this);
    }

    @Override
    public void onCheckedChanged(RadioGroup group, int checkedId) {
        switch (checkedId) {
            case R.id.rb_effect:
                rv_effect_grid.showEffect(mEffectSelectedIndex);
                break;
            case R.id.rb_beautify:
                rv_effect_grid.showBeautify(mBeautifySelectedIndex);
                break;
        }
    }

    @Override
    public void onItemClick(int position, int value) {
        RtcManager manager = ChatRoomManager.instance(mContext).getRtcManager();
        switch (rg_title.getCheckedRadioButtonId()) {
            case R.id.rb_effect:
                mEffectSelectedIndex = position;
                manager.setReverbPreset(value);
                break;
            case R.id.rb_beautify:
                mBeautifySelectedIndex = position;
                manager.setVoiceChanger(value);
                break;
        }
    }

}
