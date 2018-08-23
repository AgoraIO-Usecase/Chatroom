package io.agora.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import io.agora.chatroom.R;
import io.agora.chatroom.User;


/**
 * 用户列表适配器
 */
public class UsesAdapter extends BaseAdapter {
    private Context context;

    private List<User> mUserList = new ArrayList<>();

    public UsesAdapter(Context context, List<User> mUserList) {
        this.context = context;
        this.mUserList = mUserList;
    }

    @Override
    public int getCount() {
        return mUserList.size();
    }

    @Override
    public Object getItem(int position) {
        return mUserList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        MyViewHolder myViewHolder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.layout_item_user, null);
            myViewHolder = new MyViewHolder();
            myViewHolder.headImg = (ImageView) convertView.findViewById(R.id.item_header);
            myViewHolder.imgMute = (TextView) convertView.findViewById(R.id.item_mute);
            myViewHolder.textViewName = (TextView) convertView.findViewById(R.id.item_name);
            myViewHolder.textViewAudioVolume = (TextView) convertView.findViewById(R.id.item_volume_indication);
            convertView.setTag(myViewHolder);
        } else {
            myViewHolder = (MyViewHolder) convertView.getTag();
        }

        User user = mUserList.get(position);
        myViewHolder.imgMute.setVisibility(user.isAudioMute() ? View.VISIBLE : View.GONE);
        myViewHolder.textViewName.setText("" + user.getUid());
        myViewHolder.textViewAudioVolume.setText(context.getString(R.string.str_audio_volumn) + user.getAudioVolum());
        // 如果是自己，用女生的头像，是他人则用男生的头像
        if (user.isUserSelf()) {
            myViewHolder.headImg.setBackgroundResource(R.mipmap.localself);
        } else {
            myViewHolder.headImg.setBackgroundResource(R.mipmap.others);
        }

        return convertView;
    }

    class MyViewHolder {

        ImageView headImg;
        TextView imgMute;
        TextView textViewName;
        TextView textViewAudioVolume;
    }
}
