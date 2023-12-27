package com.opentexas.cocoslib.core.functions;

import android.content.Context;

import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;

import java.util.Locale;

public class GetSysLanguageFunction {
    public static String apply() {
        String language = "";
        try {
            Context ctx = Cocos2dxActivityWrapper.getContext();
            if (ctx != null) {
                Locale locale = ctx.getResources().getConfiguration().locale;
                language = locale.getLanguage();
                String contry = locale.getCountry();
                if (contry == null) {
                    contry = "";
                }
                language = language + "," + contry;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return language;
    }
}
