package io.agora.chatroom.utils;

import android.text.TextUtils;

public class Constant {

    /**
     * Here give a random userId, You can use your business userId
     */
    public static final int sUserId = MemberUtils.getUserId();

    public static boolean isMyself(String userId) {
        return TextUtils.equals(userId, String.valueOf(Constant.sUserId));
    }

    public static final String sName = MemberUtils.getName();
    public static final int sAvatarIndex = MemberUtils.getAvatarIndex();

}
