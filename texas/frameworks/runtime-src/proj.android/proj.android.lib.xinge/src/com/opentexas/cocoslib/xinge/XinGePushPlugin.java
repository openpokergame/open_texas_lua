package com.opentexas.cocoslib.xinge;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.text.TextUtils;
import android.util.Log;

import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;
import com.opentexas.cocoslib.core.LifecycleObserverAdapter;
import com.tencent.android.tpush.XGIOperateCallback;
import com.tencent.android.tpush.XGPushClickedResult;
import com.tencent.android.tpush.XGPushConfig;
import com.tencent.android.tpush.XGPushManager;

public class XinGePushPlugin extends LifecycleObserverAdapter implements IPlugin {
    protected static final String TAG = XinGePushPlugin.class.getSimpleName();
    protected String id;
    public String pushStr = null;   //推送内容

    @Override
    public void initialize() {
        Cocos2dxActivityWrapper.getContext().addObserver(this);

        XGPushConfig.enableDebug(Cocos2dxActivityWrapper.getContext(), false);
        setTags(Cocos2dxActivityWrapper.getContext());
        XGPushManager.registerPush(Cocos2dxActivityWrapper.getContext(), new XGIOperateCallback() {
            @Override
            public void onSuccess(Object data, int flag) {
                Log.d(TAG, "token:" + data);
            }

            @Override
            public void onFail(Object data, int errCode, String msg) {
                Log.e(TAG, "注册失败" + errCode + ",错误消息是" + msg);
            }
        });
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    @Override
    public void onStart(Activity activity) {
        super.onStart(activity);
        XGPushClickedResult click = XGPushManager.onActivityStarted(activity);
        if (click != null) {
            Log.d(TAG, "the push start is" + click.toString());
            // String title = click.getTitle();
            // String content = click.getContext();
            String customContent = click.getCustomContent();
            //
            if (customContent != null && customContent.length() != 0) {
                this.pushStr = customContent;
                try {
                    JSONObject jsonObject = new JSONObject(customContent);
                    String cmdStr = jsonObject.optString("cmd");
                    if ("autoPush".equals(cmdStr)) {
                        Cocos2dxHelper.setBoolForKey("RN_HAVEAUTORECALL", true);
                        Cocos2dxHelper.setStringForKey("RN_AUTORECALL_MSG", customContent);
                    }
                } catch (JSONException e) {
                    Log.e(TAG, e.getMessage());
                }
            }
        }
    }

    @Override
    public void onStop(Activity activity) {
        super.onStop(activity);
        XGPushManager.onActivityStoped(activity);
    }

    private void setTags(Context ctx) {
        Object umengChannelId = null;
        PackageManager packageManager = ctx.getPackageManager();
        ApplicationInfo applicationInfo;
        try {
            applicationInfo = packageManager.getApplicationInfo(ctx.getPackageName(), 128);
            if (applicationInfo != null && applicationInfo.metaData != null) {
                umengChannelId = applicationInfo.metaData.get("UMENG_CHANNEL");
            }
        } catch (NameNotFoundException e) {
            Log.e(TAG, e.getMessage());
        }
        String name;
        if (umengChannelId != null) {
            name = procTagName(String.valueOf(umengChannelId));
            if (!TextUtils.isEmpty(name)) {
                XGPushManager.setTag(ctx, name);
            }
        }
    }

    private String procTagName(Object nameObj) {
        String name = null;
        if (nameObj != null) {
            if (nameObj instanceof String) {
                name = (String) nameObj;
            } else {
                name = String.valueOf(nameObj);
            }
        }
        if (TextUtils.isEmpty(name)) {
            return "";
        } else {
            return name.trim();
        }
    }

    public void register() {
        String token = XGPushConfig.getToken(Cocos2dxActivityWrapper.getContext());
        if (!TextUtils.isEmpty(token)) {
            XinGePushBridge.callRegisteredCallback("GET_PUSH_TOKEN", true, token);
        }
    }
}
