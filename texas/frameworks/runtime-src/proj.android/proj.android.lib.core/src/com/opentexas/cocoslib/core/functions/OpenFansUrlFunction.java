package com.opentexas.cocoslib.core.functions;

import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.util.Log;

public class OpenFansUrlFunction {
    private static String TAG = "OpenFansUrlFunction";

    public static void apply(final String appFansUrl, final String webFansUrl) {
        Context ctx = Cocos2dxActivityWrapper.getContext();

        try {
            Log.d(TAG, "appFansUrl = " + appFansUrl);
            ctx.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(appFansUrl)));
        } catch (Exception e) {
            try {
                Log.d(TAG, "webFansUrl = " + webFansUrl);
                ctx.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(webFansUrl)));
            } catch (Exception err) {
                Log.d(TAG, err.toString());
            }
        }
    }
}
