package io.agora.chatroom.model;

import android.text.TextUtils;

import io.agora.chatroom.util.MemberUtil;

public class Constant {

    /**
     * Here give a random userId, You can use your business userId
     */
    public static final int sUserId = MemberUtil.getUserId();

    public static boolean isMyself(String userId) {
        return TextUtils.equals(userId, String.valueOf(Constant.sUserId));
    }

    public static final String sName = MemberUtil.getName();
    public static final int sAvatarIndex = MemberUtil.getAvatarIndex();

}
