package io.agora.chatroom.widget;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.SimpleItemAnimator;

import io.agora.chatroom.R;
import io.agora.chatroom.adapter.SeatGridAdapter;

public class SeatGridRecyclerView extends RecyclerView {

    private SeatGridAdapter mAdapter;

    public SeatGridRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public SeatGridRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public SeatGridRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        setHasFixedSize(true);

        ItemAnimator animator = getItemAnimator();
        if (animator instanceof SimpleItemAnimator)
            ((SimpleItemAnimator) animator).setSupportsChangeAnimations(false);

        mAdapter = new SeatGridAdapter(context);
        setAdapter(mAdapter);

        setLayoutManager(new GridLayoutManager(context, 5));

        int spacing = getResources().getDimensionPixelSize(R.dimen.item_seat_spacing);
        addItemDecoration(new ItemDecoration() {
            @Override
            public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull State state) {
                super.getItemOffsets(outRect, view, parent, state);
                outRect.set(spacing, spacing, spacing, spacing);
            }
        });
    }

    public void setOnItemClickListener(SeatGridAdapter.OnItemClickListener listener) {
        mAdapter.setOnItemClickListener(listener);
    }

    public void notifyItemChanged(String userId, boolean animated) {
        mAdapter.notifyItemChanged(userId, animated);
    }

    public void notifyItemChanged(int position) {
        mAdapter.notifyItemChanged(position);
    }

}
