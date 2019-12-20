package io.agora.chatroom.activity;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import io.agora.chatroom.R;
import io.agora.chatroom.adapter.ChannelGridAdapter;
import io.agora.chatroom.model.Channel;

public class ChannelGridActivity extends AppCompatActivity implements ChannelGridAdapter.OnItemClickListener {

    @BindView(R.id.rv_channel_grid)
    RecyclerView rv_channel_grid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_channel_grid);
        ButterKnife.bind(this);

        initRecyclerView();
    }

    private void initRecyclerView() {
        rv_channel_grid.setHasFixedSize(true);

        ChannelGridAdapter adapter = new ChannelGridAdapter(this);
        adapter.setOnItemClickListener(this);
        rv_channel_grid.setAdapter(adapter);

        rv_channel_grid.setLayoutManager(new GridLayoutManager(this, 2));

        int spacing = getResources().getDimensionPixelSize(R.dimen.item_channel_spacing);
        rv_channel_grid.addItemDecoration(new RecyclerView.ItemDecoration() {
            @Override
            public void getItemOffsets(@NonNull Rect outRect, @NonNull View view, @NonNull RecyclerView parent, @NonNull RecyclerView.State state) {
                super.getItemOffsets(outRect, view, parent, state);
                outRect.set(spacing, spacing, spacing, spacing);
            }
        });
    }

    @Override
    public void onItemClick(View view, int position, Channel channel) {
        Intent intent = new Intent(ChannelGridActivity.this, ChatRoomActivity.class);
        intent.putExtra(ChatRoomActivity.BUNDLE_KEY_CHANNEL_ID, channel.getName());
        intent.putExtra(ChatRoomActivity.BUNDLE_KEY_BACKGROUND_RES, channel.getBackgroundRes());
        startActivity(intent);
    }

}
