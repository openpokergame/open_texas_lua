package com.opentexas.cocoslib.umeng;

import android.app.Activity;

import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;
import com.opentexas.cocoslib.core.LifecycleObserverAdapter;
import com.umeng.analytics.game.UMGameAgent;
import com.umeng.analytics.mobclick.game.MobClickCppHelper;

public class UmengPlugin extends LifecycleObserverAdapter implements IPlugin {
    protected static final String TAG = UmengBridge.class.getSimpleName();
    protected String id;
    private String appKey;

    public UmengPlugin(String appKey) {
        this.appKey = appKey;
    }

    @Override
    public void initialize() {
        Cocos2dxActivityWrapper.getContext().addObserver(this);
        MobClickCppHelper.init(Cocos2dxActivityWrapper.getContext(), this.appKey, "GooglePlay");
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    @Override
    public void onResume(Activity activity) {
        super.onResume(activity);
        MobClickCppHelper.onResume(Cocos2dxActivityWrapper.getContext());
    }

    @Override
    public void onPause(Activity activity) {
        super.onPause(activity);
        MobClickCppHelper.onPause(Cocos2dxActivityWrapper.getContext());
    }

    public void setPlayerLevel(int level) {
        UMGameAgent.setPlayerLevel(level);
    }

}
