package io.agora.adapter;


import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import io.agora.chatroom.R;
import io.agora.chatroom.User;
import io.agora.utils.Constant;


public class PopuwindowAdapter extends BaseAdapter {
    private Context context;
    private int mSelectPosition = -1;

    public PopuwindowAdapter(Context context) {
        this.context = context;

    }

    public void setSelectIndex(int index){
        this.mSelectPosition = index;
    }

    @Override
    public int getCount() {
        return Constant.SOUNDARRAY.length;
    }

    @Override
    public Object getItem(int position) {
        return Constant.SOUNDARRAY[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        MyViewHolder myViewHolder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.layout_item_popuwindow, null);
            myViewHolder = new MyViewHolder();
            myViewHolder.textViewName = (TextView) convertView.findViewById(R.id.item_pop_name);
            convertView.setTag(myViewHolder);
        } else {
            myViewHolder = (MyViewHolder) convertView.getTag();
        }

        myViewHolder.textViewName.setText(Constant.SOUNDARRAY[position]);
        if (position == mSelectPosition){
            convertView.setBackgroundColor(context.getResources().getColor(R.color.agora_blue));
        } else {
            convertView.setBackgroundColor(Color.WHITE);
        }

        return convertView;
    }

    class MyViewHolder {

        TextView textViewName;
    }
}
