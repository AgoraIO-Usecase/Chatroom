package io.agora.chatroom.widget;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import io.agora.chatroom.R;
import io.agora.chatroom.adapter.VoiceEffectGridAdapter;

public class VoiceEffectGridRecyclerView extends RecyclerView {

    private VoiceEffectGridAdapter mEffectAdapter;
    private VoiceEffectGridAdapter mBeautifyAdapter;

    public VoiceEffectGridRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public VoiceEffectGridRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public VoiceEffectGridRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        setHasFixedSize(true);

        mEffectAdapter = new VoiceEffectGridAdapter(context, R.array.voice_effect_keys, R.array.voice_effect_values);
        mBeautifyAdapter = new VoiceEffectGridAdapter(context, R.array.voice_beautify_keys, R.array.voice_beautify_values);

        setLayoutManager(new GridLayoutManager(context, 3));

        int spacing = getResources().getDimensionPixelSize(R.dimen.dialog_member_item_spacing);
        addItemDecoration(new RecyclerView.ItemDecoration() {
            @Override
            public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {
                super.getItemOffsets(outRect, view, parent, state);
                outRect.set(spacing / 2, spacing, spacing / 2, 0);
            }
        });
    }

    public void showEffect(int selectedIndex) {
        setAdapter(mEffectAdapter);
        mEffectAdapter.setSelectedIndex(selectedIndex);
    }

    public void showBeautify(int selectedIndex) {
        setAdapter(mBeautifyAdapter);
        mBeautifyAdapter.setSelectedIndex(selectedIndex);
    }

    public void setOnItemClickListener(VoiceEffectGridAdapter.OnItemClickListener listener) {
        mEffectAdapter.setOnItemClickListener(listener);
        mBeautifyAdapter.setOnItemClickListener(listener);
    }

}
