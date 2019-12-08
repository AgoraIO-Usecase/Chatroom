package io.agora.chatroom.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.ArrayRes;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import butterknife.BindView;
import butterknife.ButterKnife;
import io.agora.chatroom.R;

public class VoiceEffectGridAdapter extends RecyclerView.Adapter<VoiceEffectGridAdapter.ViewHolder> {

    private LayoutInflater mInflater;
    private VoiceEffectGridAdapter.OnItemClickListener mListener;
    private int mSelectedIndex;

    private String[] mKeys;
    private int[] mValues;

    public VoiceEffectGridAdapter(Context context, @ArrayRes int keysId, @ArrayRes int valuesId) {
        mInflater = LayoutInflater.from(context);
        mKeys = context.getResources().getStringArray(keysId);
        mValues = context.getResources().getIntArray(valuesId);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.layout_item_effect, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        String key = mKeys[position];

        holder.tv_effect.setText(key);
        holder.tv_effect.setBackgroundResource(mSelectedIndex == position ? R.drawable.bg_effect_item_selected : R.drawable.bg_effect_item_normal);

        holder.tv_effect.setOnClickListener((view) -> {
            setSelectedIndex(position);
            if (mListener != null)
                mListener.onItemClick(position, mValues[position]);
        });
    }

    @Override
    public int getItemCount() {
        if (mKeys == null) return 0;
        return mKeys.length;
    }

    public void setSelectedIndex(int index) {
        notifyItemChanged(mSelectedIndex);
        mSelectedIndex = index;
        notifyItemChanged(index);
    }

    public void setOnItemClickListener(VoiceEffectGridAdapter.OnItemClickListener listener) {
        mListener = listener;
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        @BindView(R.id.tv_effect)
        TextView tv_effect;

        ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }
    }

    public interface OnItemClickListener {
        void onItemClick(int position, int value);
    }

}
