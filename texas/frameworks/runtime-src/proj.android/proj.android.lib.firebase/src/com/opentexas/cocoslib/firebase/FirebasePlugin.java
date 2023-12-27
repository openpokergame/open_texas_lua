package com.opentexas.cocoslib.firebase;

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

//测试哦
import android.support.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;

import android.widget.Toast;

public class FirebasePlugin extends LifecycleObserverAdapter implements IPlugin {
    protected static final String TAG = FirebasePlugin.class.getSimpleName();
    protected String id;
    public String pushStr = null;   //推送内容

    @Override
    public void initialize() {
        Cocos2dxActivityWrapper.getContext().addObserver(this);

        setTags(Cocos2dxActivityWrapper.getContext());
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    @Override
    public void onStart(Activity activity) {
        super.onStart(activity);
    }

    @Override
    public void onStop(Activity activity) {
        super.onStop(activity);
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
        FirebaseInstanceId.getInstance().getInstanceId().addOnCompleteListener(new OnCompleteListener<InstanceIdResult>() {
            @Override
            public void onComplete(@NonNull Task<InstanceIdResult> task) {
                if (!task.isSuccessful()) {
                    Log.w(TAG, "getInstanceId failed", task.getException());
                    return;
                }

                // Get new Instance ID token
                String token = task.getResult().getToken();

                // Log and toast
                String msg = token;
                Log.d(TAG, msg);
                if (!TextUtils.isEmpty(token)) {
                    FirebaseBridge.callRegisteredCallback("GET_PUSH_TOKEN", true, token);
                }
            }
        });
    }
}
