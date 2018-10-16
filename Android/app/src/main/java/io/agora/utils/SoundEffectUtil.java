package io.agora.utils;

import io.agora.rtc.RtcEngine;

public class SoundEffectUtil {
    public static final int EFFECT_DEFAULT = 0;
    public static final int EFFECT_OLD_MAN = 1;
    public static final int EFFECT_BABY_BOY = 2;
    public static final int EFFECT_ZHU_BA_JIE = 3;
    public static final int EFFECT_ETHEREAL = 4;
    public static final int EFFECT_HULK = 5;
    public static final int EFFECT_BABY_GIRL = 6;
    public static final int EFFECT_RADIO = 7;
    public static final int EFFECT_LIVE = 8;
    public static final int EFFECT_STUDIO = 9;

    public static void changeEffect(RtcEngine engine, int toEffectType) {
        final Effect effect = Effect.getEffect(toEffectType);
        changeEffect(engine,  effect);
    }

    private static void changeEffect(RtcEngine engine, Effect effect) {
        engine.setLocalVoicePitch(effect.pitch);

        engine.setLocalVoiceEqualization(AudioConst.BAND_31, effect.band31);
        engine.setLocalVoiceEqualization(AudioConst.BAND_62, effect.band62);
        engine.setLocalVoiceEqualization(AudioConst.BAND_125, effect.band125);
        engine.setLocalVoiceEqualization(AudioConst.BAND_250, effect.band250);
        engine.setLocalVoiceEqualization(AudioConst.BAND_500, effect.band500);
        engine.setLocalVoiceEqualization(AudioConst.BAND_1K, effect.band1k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_2K, effect.band2k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_4K, effect.band4k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_8K, effect.band8k);
        engine.setLocalVoiceEqualization(AudioConst.BAND_16K, effect.band16k);

        engine.setLocalVoiceReverb(AudioConst.REVERB_DRY_LEVEL, effect.dryLevel);
        engine.setLocalVoiceReverb(AudioConst.REVERB_WET_LEVEL, effect.wetLevel);
        engine.setLocalVoiceReverb(AudioConst.REVERB_ROOM_SIZE, effect.roomSize);
        engine.setLocalVoiceReverb(AudioConst.REVERB_WET_DELAY, effect.wetDelay);
        engine.setLocalVoiceReverb(AudioConst.REVERB_STRENGTH, effect.strength);
    }

    private static class Effect {
        private static final double[] EFFECT_PITCH_SETTINGS = {
                1, 0.8, 1.23, 0.6, 1, 0.5, 1.45, 1, 1, 1
        };

        private static final int[][] EFFECT_OTHER_SETTINGS = {
                { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 10, 0, 50 },
                { -15, 0, 6, 1, -4, 1, -10, -5, 3, 3, -12, -12, 0, 90, 43 },
                { 15, 11, -3, -5, -7, -7, -9, -15, -15, -15, 4, 2, 0, 91, 44 },
                { 12, -9, -9, 3, -3, 11, 1, -8, -8, -9, -14, -8, 34, 0, 39 },
                { -8, -8, 5, 13, 2, 12, -3, 7, -2, -10, -17, -13, 72, 9, 69 },
                { -15, 3, -9, -8, -6, -4, -3, -2, -1, 1, 10, -9, 76, 124, 78 },
                { 10, 6, 1, 1, -6, 13, 7, -14, 13, -13, -11, -7, 0, 31, 44 },
                { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 30, 0, 100 },
                { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 50, 45, 100 },
                { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 0, 50 },
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

        private Effect(double pitch, int band31, int band62,
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

        private Effect(int effectType) {
            this(EFFECT_PITCH_SETTINGS[effectType],
                    EFFECT_OTHER_SETTINGS[effectType][0],
                    EFFECT_OTHER_SETTINGS[effectType][1],
                    EFFECT_OTHER_SETTINGS[effectType][2],
                    EFFECT_OTHER_SETTINGS[effectType][3],
                    EFFECT_OTHER_SETTINGS[effectType][4],
                    EFFECT_OTHER_SETTINGS[effectType][5],
                    EFFECT_OTHER_SETTINGS[effectType][6],
                    EFFECT_OTHER_SETTINGS[effectType][7],
                    EFFECT_OTHER_SETTINGS[effectType][8],
                    EFFECT_OTHER_SETTINGS[effectType][9],
                    EFFECT_OTHER_SETTINGS[effectType][10],
                    EFFECT_OTHER_SETTINGS[effectType][11],
                    EFFECT_OTHER_SETTINGS[effectType][12],
                    EFFECT_OTHER_SETTINGS[effectType][13],
                    EFFECT_OTHER_SETTINGS[effectType][14]);
        }

        private static Effect getEffect(int effectType) {
            int type = effectType;
            if (effectType < EFFECT_DEFAULT || effectType > EFFECT_STUDIO) {
                type = EFFECT_DEFAULT;
            }

            return new Effect(type);
        }
    }
}
