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
import io.agora.chatroom.adapter.ChannelGridAdapter;

public class ChannelGridRecyclerView extends RecyclerView {

    private ChannelGridAdapter mAdapter;

    public ChannelGridRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public ChannelGridRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public ChannelGridRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        setHasFixedSize(true);

        mAdapter = new ChannelGridAdapter(context);
        setAdapter(mAdapter);

        setLayoutManager(new GridLayoutManager(context, 2));

        int spacing = getResources().getDimensionPixelSize(R.dimen.item_channel_spacing);
        addItemDecoration(new RecyclerView.ItemDecoration() {
            @Override
            public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {
                super.getItemOffsets(outRect, view, parent, state);
                outRect.set(spacing, spacing, spacing, spacing);
            }
        });
    }

    public void setOnItemClickListener(ChannelGridAdapter.OnItemClickListener listener) {
        mAdapter.setOnItemClickListener(listener);
    }

}
