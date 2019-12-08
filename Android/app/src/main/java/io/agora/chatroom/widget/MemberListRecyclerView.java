package io.agora.chatroom.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.SimpleItemAnimator;

import io.agora.chatroom.R;
import io.agora.chatroom.adapter.MemberListAdapter;

public class MemberListRecyclerView extends RecyclerView {

    private MemberListAdapter mAdapter;
    private ItemDecoration mItemDecoration = new ItemDecoration() {
        private Drawable mDivider = getResources().getDrawable(R.drawable.inset_divider);
        private final Rect mBounds = new Rect();
        private int spacing = getResources().getDimensionPixelSize(R.dimen.item_member_spacing);

        @Override
        public void onDraw(@NonNull Canvas c, @NonNull RecyclerView parent, @NonNull State state) {
            super.onDraw(c, parent, state);
            drawVertical(c, parent);
        }

        private void drawVertical(Canvas canvas, RecyclerView parent) {
            canvas.save();
            int left;
            int right;
            if (parent.getClipToPadding()) {
                left = parent.getPaddingLeft();
                right = parent.getWidth() - parent.getPaddingRight();
                canvas.clipRect(left, parent.getPaddingTop(), right,
                        parent.getHeight() - parent.getPaddingBottom());
            } else {
                left = 0;
                right = parent.getWidth();
            }

            int childCount = parent.getChildCount();
            for (int i = 0; i < childCount; i++) {
                View child = parent.getChildAt(i);
                parent.getDecoratedBoundsWithMargins(child, mBounds);
                if (i == 0) {
                    int top = mBounds.top - Math.round(child.getTranslationY());
                    int bottom = top + mDivider.getIntrinsicHeight();
                    mDivider.setBounds(left, top, right, bottom);
                    mDivider.draw(canvas);
                }
                if (i == childCount - 1) return;
                int bottom = mBounds.bottom + Math.round(child.getTranslationY());
                int top = bottom - mDivider.getIntrinsicHeight();
                mDivider.setBounds(left, top, right, bottom);
                mDivider.draw(canvas);
            }
            canvas.restore();
        }

        @Override
        public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull State state) {
            super.getItemOffsets(outRect, view, parent, state);
            outRect.set(spacing, spacing / 2, spacing, spacing / 2);
        }
    };

    public MemberListRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public MemberListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public MemberListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        setHasFixedSize(true);

        ItemAnimator animator = getItemAnimator();
        if (animator instanceof SimpleItemAnimator)
            ((SimpleItemAnimator) animator).setSupportsChangeAnimations(false);

        mAdapter = new MemberListAdapter(context);
        setAdapter(mAdapter);

        setLayoutManager(new LinearLayoutManager(context));

        addItemDecoration(mItemDecoration);
    }

    public void setOnItemClickListener(MemberListAdapter.OnItemClickListener listener) {
        mAdapter.setOnItemClickListener(listener);
    }

    public void notifyItemInserted(int position) {
        mAdapter.notifyItemInserted(position);
    }

    public void notifyItemRemoved(int position) {
        mAdapter.notifyItemRemoved(position);
        mAdapter.notifyItemRangeChanged(position, mAdapter.getItemCount() - 1);
    }

    public void notifyItemChangedByUserId(String userId) {
        mAdapter.notifyItemChangedByUserId(userId);
    }

}
