package com.opentexas.cocoslib.umeng;

import java.util.List;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.opentexas.cocoslib.core.Cocos2dxActivityUtil;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;

public class UmengBridge {
    private static final String TAG = UmengBridge.class.getSimpleName();

    private static UmengPlugin getUmengPlugin() {
        if (Cocos2dxActivityWrapper.getContext() != null) {
            List<IPlugin> list = Cocos2dxActivityWrapper.getContext().getPluginManager().findPluginByClass(UmengPlugin.class);
            if (list != null && list.size() > 0) {
                return (UmengPlugin) list.get(0);
            } else {
                Log.d(TAG, "XinGePushPlugin not found");
            }
        }
        return null;
    }

    public static void reporttUserLevel(final int level) {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                UmengPlugin plugin = getUmengPlugin();
                if (plugin != null) {
                    Log.d(TAG, "register begin");
                    plugin.setPlayerLevel(level);
                    Log.d(TAG, "register end");
                }
            }
        });
    }
}
