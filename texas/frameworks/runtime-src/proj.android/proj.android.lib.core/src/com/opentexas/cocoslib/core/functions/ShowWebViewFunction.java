package com.opentexas.cocoslib.core.functions;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;

public class ShowWebViewFunction {
    public static void apply(final String url) {
        final Cocos2dxActivityWrapper ctx = Cocos2dxActivityWrapper.getContext();
        if (ctx != null) {
            ctx.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Uri uri = Uri.parse(url);
                    Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                    try {
                        ctx.startActivity(Intent.createChooser(intent, "Choose Browser"));
                    } catch (Exception e) {
                        Log.e(ShowWebViewFunction.class.getSimpleName(), e.getMessage(), e);
                    }
                }
            });
        }
    }
}
