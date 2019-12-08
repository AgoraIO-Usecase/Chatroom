package io.agora.chatroom.widget;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import io.agora.chatroom.R;
import io.agora.chatroom.adapter.MessageListAdapter;

public class MessageListRecyclerView extends RecyclerView {

    private MessageListAdapter mAdapter;

    public MessageListRecyclerView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public MessageListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public MessageListRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        mAdapter = new MessageListAdapter(context);
        setAdapter(mAdapter);

        setLayoutManager(new LinearLayoutManager(context));

        int spacing = getResources().getDimensionPixelSize(R.dimen.item_message_spacing);
        addItemDecoration(new ItemDecoration() {
            @Override
            public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull State state) {
                super.getItemOffsets(outRect, view, parent, state);
                outRect.set(spacing, 0, spacing, spacing);
            }
        });
    }

    public void notifyItemInserted(int position) {
        mAdapter.notifyItemInserted(position);
        scrollToPosition(position);
    }

}
