package com.opentexas.cocoslib.adjust;

import android.app.Activity;
import android.app.Application.ActivityLifecycleCallbacks;
import android.os.Bundle;

import com.adjust.sdk.Adjust;
import com.adjust.sdk.AdjustConfig;
import com.adjust.sdk.AdjustEvent;
import com.adjust.sdk.LogLevel;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;
import com.opentexas.cocoslib.core.LifecycleObserverAdapter;

public class AdjustPlugin extends LifecycleObserverAdapter implements IPlugin {
    protected static final String TAG = AdjustPlugin.class.getSimpleName();
    protected String id;
    private String appToken;

    public AdjustPlugin(String appToken) {
        this.appToken = appToken;
    }

    @Override
    public void initialize() {
        // TODO Auto-generated method stub
        Cocos2dxActivityWrapper.getContext().addObserver(this);
//		SDK version is 4.12.0
//		String environment = AdjustConfig.ENVIRONMENT_SANDBOX;
        String environment = AdjustConfig.ENVIRONMENT_PRODUCTION;
        AdjustConfig config = new AdjustConfig(Cocos2dxActivityWrapper.getContext(), this.appToken, environment, true);
//		config.setLogLevel(LogLevel.VERBOSE);
        Adjust.onCreate(config);
        Adjust.onResume();
        Cocos2dxActivityWrapper.getContext().getApplication().registerActivityLifecycleCallbacks(new AdjustLifecycleCallbacks());
    }

    @Override
    public void setId(String id) {
        // TODO Auto-generated method stub
        this.id = id;
    }

    private static final class AdjustLifecycleCallbacks implements ActivityLifecycleCallbacks {
        @Override
        public void onActivityResumed(Activity activity) {
            Adjust.onResume();
        }

        @Override
        public void onActivityPaused(Activity activity) {
            Adjust.onPause();
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
        }

        @Override
        public void onActivityCreated(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityStarted(Activity activity) {
        }

        @Override
        public void onActivityStopped(Activity activity) {
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle saveInstanceState) {

        }
    }

    public void trackRevenue(String revenue, String currency, String eventToken) {
        try {
            AdjustEvent event = new AdjustEvent(eventToken);
            event.setRevenue(Double.parseDouble(revenue), currency);
            Adjust.trackEvent(event);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
