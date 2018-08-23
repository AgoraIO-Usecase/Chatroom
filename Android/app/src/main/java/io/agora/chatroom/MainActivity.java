package io.agora.chatroom;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AlertDialog;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

import io.agora.rtc.Constants;
import io.agora.utils.Constant;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }


    public void clickRoomGamingStandard(View view) {
        onClickJoin(Constant.ChatRoomGamingStandard, Constant.ChatRoomGamingStandardName, ((TextView) view).getText().toString());
    }

    public void clickRoomEntertainmentStandard(View view) {
        onClickJoin(Constant.ChatRoomEntertainmentStandard, Constant.ChatRoomEntertainmentStandardName, ((TextView) view).getText().toString());
    }

    public void clickRoomEntertainmentHighQuality(View view) {
        onClickJoin(Constant.ChatRoomEntertainmentHighQuality, Constant.ChatRoomEntertainmentHighQualityName, ((TextView) view).getText().toString());
    }

    public void clickRoomGamingHighQuality(View view) {
        onClickJoin(Constant.ChatRoomGamingHighQuality, Constant.ChatRoomGamingHighQualityName, ((TextView) view).getText().toString());
    }

    public void onClickJoin(final int roomId, final String roomName, final String titleName) {
        // show dialog to choose role
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(R.string.msg_choose_role);
        builder.setNegativeButton(R.string.label_audience, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                startRoomActivity(Constants.CLIENT_ROLE_AUDIENCE, roomId, roomName, titleName);
            }
        });
        builder.setPositiveButton(R.string.label_broadcaster, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                startRoomActivity(Constants.CLIENT_ROLE_BROADCASTER, roomId, roomName, titleName);
            }
        });
        AlertDialog dialog = builder.create();

        dialog.show();
    }

    private void startRoomActivity(int clientRole, int roomId, String roomName, String titleName) {
        Intent intent = new Intent(this, RoomActivity.class);
        intent.putExtra(Constant.ACTION_KEY_CROLE, clientRole);
        intent.putExtra(Constant.ACTION_KEY_ROOM_MODE, roomId);
        intent.putExtra(Constant.ACTION_KEY_ROOM_NAME, roomName);
        intent.putExtra(Constant.ACTION_KEY_TITLE_NAME, titleName);
        startActivity(intent);
    }
}
