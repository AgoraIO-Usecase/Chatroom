package io.agora.chatroom;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

import butterknife.BindView;
import butterknife.ButterKnife;
import io.agora.chatroom.adapter.ChannelGridAdapter;
import io.agora.chatroom.bean.Channel;
import io.agora.chatroom.widget.ChannelGridRecyclerView;

public class ChannelGridActivity extends AppCompatActivity implements ChannelGridAdapter.OnItemClickListener {

    @BindView(R.id.rv_channel_grid)
    ChannelGridRecyclerView rv_channel_grid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_channel_grid);
        ButterKnife.bind(this);

        rv_channel_grid.setOnItemClickListener(this);
    }

    @Override
    public void onItemClick(View view, int position, Channel channel) {
        Intent intent = new Intent(ChannelGridActivity.this, ChatRoomActivity.class);
        intent.putExtra(ChatRoomActivity.BUNDLE_KEY_CHANNEL_ID, channel.getName());
        intent.putExtra(ChatRoomActivity.BUNDLE_KEY_BACKGROUND_RES, channel.getBackgroundRes());
        startActivity(intent);
    }

}
