package com.opentexas.cocoslib.adjust;

import java.util.List;

import android.util.Log;

import com.opentexas.cocoslib.core.Cocos2dxActivityUtil;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;

public class AdjustBridge {
    private static final String TAG = AdjustBridge.class.getSimpleName();

    private static AdjustPlugin getAdjustPlugin() {
        if (Cocos2dxActivityWrapper.getContext() != null) {
            List<IPlugin> list = Cocos2dxActivityWrapper.getContext().getPluginManager().findPluginByClass(AdjustPlugin.class);
            if (list != null && list.size() > 0) {
                return (AdjustPlugin) list.get(0);
            } else {
                Log.d(TAG, "AdjustPlugin not found");
            }
        }
        return null;
    }

    public static void trackRevenue(final String revenue, final String currency, final String eventToken) {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                AdjustPlugin plugin = getAdjustPlugin();
                if (plugin != null) {
                    plugin.trackRevenue(revenue, currency, eventToken);
                }
            }
        });
    }
}
