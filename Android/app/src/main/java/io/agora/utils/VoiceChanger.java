package io.agora.utils;


import io.agora.rtc.RtcEngine;

public class VoiceChanger {
    public static final int ROLE_DEFAULT = 0;
    public static final int ROLE_OLD_MAN = 1;
    public static final int ROLE_BABY_BOY = 2;
    public static final int ROLE_ZHU_BA_JIE = 3;
    public static final int ROLE_ETHEREAL = 4;
    public static final int ROLE_HULK = 5;
    public static final int ROLE_BABY_GIRL = 6;

    public static void changeVoice(RtcEngine engine, int toVoiceRole) {
        final VoiceRole role = VoiceRole.getVoiceRole(toVoiceRole);

        changeVoice(engine,  role);

    }

    private static void changeVoice(RtcEngine engine, VoiceRole role) {
        /** 通过改变 pitch, equalization, reverb 的值来产生声音效果*/
        engine.setLocalVoicePitch(role.pitch);

        engine.setLocalVoiceEqualization(AudioConst.BAND_31, role.band31);
        engine.setLocalVoiceEqualization(AudioConst.BAND_62, role.band62);
        engine.setLocalVoiceEqualization(AudioConst.BAND_125, role.band125);
        engine.setLocalVoiceEqualization(AudioConst.BAND_250, role.band250);
        engine.setLocalVoiceEqualization(AudioConst.BAND_500, role.band500);
        engine.setLocalVoiceEqualization(AudioConst.BAND_1K, role.band1k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_2K, role.band2k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_4K, role.band4k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_8K, role.band8k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_16K, role.band16k);

        engine.setLocalVoiceReverb(AudioConst.REVERB_DRY_LEVEL, role.dryLevel);
        engine.setLocalVoiceReverb(AudioConst.REVERB_WET_LEVEL, role.wetLevel);
        engine.setLocalVoiceReverb(AudioConst.REVERB_ROOM_SIZE, role.roomSize);
        engine.setLocalVoiceReverb(AudioConst.REVERB_WET_DELAY, role.wetDelay);
        engine.setLocalVoiceReverb(AudioConst.REVERB_STRENGTH, role.strength);
    }

    private static class VoiceRole {
        private static final double[] ROLE_PITCH_SETTING = {
                1, 0.8, 1.23, 0.6, 1, 0.5, 1.45
        };

        private static final int[][] ROLE_OTHER_SETTINGS = {
                { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
                { -15, 0, 6, 1, -4, 1, -10, -5, 3, 3, -12, -12, 0, 90, 43 },
                { 15, 11, -3, -5, -7, -7, -9, -15, -15, -15, 4, 2, 0, 91, 44 },
                { 12, -9, -9, 3, -3, 11, 1, -8, -8, -9, -14, -8, 34, 0, 39 },
                { -8, -8, 5, 13, 2, 12, -3, 7, -2, -10, -17, -13, 72, 9, 69 },
                { -15, 3, -9, -8, -6, -4, -3, -2, -1, 1, 10, -9, 76, 124, 78 },
                { 10, 6, 1, 1, -6, 13, 7, -14, 13, -13, -11, -7, 0, 31, 44 }
        };

        private double pitch = 1;

        private int band31 = 0;
        private int band62 = 0;
        private int band125 = 0;
        private int band250 = 0;
        private int band500 = 0;
        private int band1k = 0;
        private int band2k = 0;
        private int band4k = 0;
        private int band8k = 0;
        private int band16k = 0;

        private int dryLevel = 0;
        private int wetLevel = 0;
        private int roomSize = 0;
        private int wetDelay = 0;
        private int strength = 0;

        private VoiceRole() {

        }

        private VoiceRole(double pitch, int band31, int band62,
                         int band125, int band250, int band500,
                         int band1k, int band2k, int band4k,
                         int band8k, int band16k, int dryLevel,
                         int wetLevel, int roomSize, int wetDelay, int strength) {
            this.pitch = pitch;
            this.band31 = band31;
            this.band62 = band62;
            this.band125 = band125;
            this.band250 = band250;
            this.band500 = band500;
            this.band1k = band1k;
            this.band2k = band2k;
            this.band4k = band4k;
            this.band8k = band8k;
            this.band16k = band16k;
            this.dryLevel = dryLevel;
            this.wetLevel = wetLevel;
            this.roomSize = roomSize;
            this.wetDelay = wetDelay;
            this.strength = strength;
        }

        private VoiceRole(int role) {
            this(ROLE_PITCH_SETTING[role],
                    ROLE_OTHER_SETTINGS[role][0],
                    ROLE_OTHER_SETTINGS[role][1],
                    ROLE_OTHER_SETTINGS[role][2],
                    ROLE_OTHER_SETTINGS[role][3],
                    ROLE_OTHER_SETTINGS[role][4],
                    ROLE_OTHER_SETTINGS[role][5],
                    ROLE_OTHER_SETTINGS[role][6],
                    ROLE_OTHER_SETTINGS[role][7],
                    ROLE_OTHER_SETTINGS[role][8],
                    ROLE_OTHER_SETTINGS[role][9],
                    ROLE_OTHER_SETTINGS[role][10],
                    ROLE_OTHER_SETTINGS[role][11],
                    ROLE_OTHER_SETTINGS[role][12],
                    ROLE_OTHER_SETTINGS[role][13],
                    ROLE_OTHER_SETTINGS[role][14]);
        }

        private static VoiceRole getVoiceRole(int role) {
            if (role < ROLE_DEFAULT || role > ROLE_BABY_GIRL) {
                return new VoiceRole();
            }

            return new VoiceRole(role);
        }
    }
}
