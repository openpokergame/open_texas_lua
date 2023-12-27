package com.opentexas.gametexas;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;

import com.opentexas.cocoslib.adjust.AdjustPlugin;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.PluginManager;
import com.opentexas.cocoslib.facebook.FacebookPlugin;
import com.opentexas.cocoslib.firebase.FirebasePlugin;
import com.opentexas.cocoslib.giantvoice.GiantVoicePlugin;
import com.opentexas.cocoslib.iab.InAppBillingPlugin;
import com.opentexas.cocoslib.line.LinePlugin;
import com.opentexas.cocoslib.sharesdk.ShareSDKPlugin;
import com.opentexas.cocoslib.umeng.UmengPlugin;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Calendar;

public class GameMain extends Cocos2dxActivityWrapper {
    public static Context STATIC_REF = null;
    private static GameMain _instance;
    private static int pushType = -1;
    private static String pushCode;

    public static int getPushType() {
        int type = pushType;
        pushType = -1;
        return type;
    }

    public static String getPushCode() {
        String tempCode = pushCode;
        pushCode = null;
        if (tempCode == null) {
            tempCode = "";
        }
        return tempCode;
    }

    public static Cocos2dxActivityWrapper getContext() {
        return (Cocos2dxActivityWrapper) STATIC_REF;
    }

    public static GameMain getInstance() {
        return _instance;
    }

    public static void startLocalNotification(int notifiId, String exdata, int time) {
        //得到15秒后的时间
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.SECOND, time);
        Intent alermIntent = new Intent(Cocos2dxActivityWrapper.getContext(), NotifyBroadcastReceiver.class);
        alermIntent.setAction("intent.action.alarmnotify.app" + notifiId);
        alermIntent.setType(exdata);
        PendingIntent alarmPendingIntent = PendingIntent.getBroadcast(Cocos2dxActivityWrapper.getContext(), 0, alermIntent, 0);
        AlarmManager alarmManager = (AlarmManager) Cocos2dxActivityWrapper.getContext().getSystemService(Activity.ALARM_SERVICE);
        alarmManager.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), alarmPendingIntent);
        //_instance.stopLocalNotification(matchId,exdata);
    }

    public static void stopLocalNotification(int notifiId, String exdata) {
        AlarmManager am = (AlarmManager) Cocos2dxActivityWrapper.getContext().getSystemService(Activity.ALARM_SERVICE);
        Intent alermIntent = new Intent(Cocos2dxActivityWrapper.getContext(), NotifyBroadcastReceiver.class);
        alermIntent.setAction("intent.action.alarmnotify.app" + notifiId);
        alermIntent.setType(exdata);
        PendingIntent alarmPendingIntent = PendingIntent.getBroadcast(Cocos2dxActivityWrapper.getContext(), 0, alermIntent, 0);
        am.cancel(alarmPendingIntent);
    }

    private void hideSystemUI() {
        int flags;
        int curApiVersion = android.os.Build.VERSION.SDK_INT;
        // This work only for android 4.4+  
        if (curApiVersion >= Build.VERSION_CODES.KITKAT) {
            // This work only for android 4.4+  
            // hide navigation bar permanently in android activity  
            // touch the screen, the navigation bar will not show  
            flags = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION // hide nav bar
                    | View.SYSTEM_UI_FLAG_FULLSCREEN // hide status bar
                    | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;

        } else {
            // touch the screen, the navigation bar will show  
            flags = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION;
        }
        // must be executed in main thread :)  
        getWindow().getDecorView().setSystemUiVisibility(flags);
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        super.onKeyUp(keyCode, event);
        if ((keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN)) {
            this.hideSystemUI();
        }
        return false;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.hideSystemUI();

        STATIC_REF = this;
        _instance = this;
        Intent intent = getIntent();
        needReport(intent);
        addShortcutIfNeeded(R.string.app_name, R.drawable.icon);
//        GetPackageInfoFunction.getKeyCode(null);
    }

    @Override
    protected void onResume() {
        super.onResume();
        this.hideSystemUI();
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        Log.d(TAG, "onWindowFocusChanged() hasFocus=" + hasFocus);
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            this.hideSystemUI();
        }
    }

    @Override
    public void onNewIntent(Intent intent) {
        needReport(intent);
    }

    public void needReport(Intent intent) {
        //adb shell am start -W -a android.intent.action.VIEW -d "opentexas://opentexas-th?type=1,fuck=2,test=3,me=4,you=5,she=6,her=7"
        //adb shell am start -W -a android.intent.action.VIEW -d "opentexas://opentexas-th?type=1\&a=d"
        if (intent != null && intent.getData() != null) {//深度链接
            Uri uri = intent.getData();//链接地址
            String scheme = uri.getScheme();
            String host = uri.getHost();//域名
            String query = uri.getQuery();//获取参数列表
            Log.d("needReport", "scheme = " + scheme);
            Log.d("needReport", "scheme host = " + host);
            Log.d("needReport", "scheme host query= " + query);
            this.intentData = query;
        } else if (intent != null && intent.getExtras() != null) { //firebase推送
            try {
                JSONObject json = new JSONObject();
                for (String key : intent.getExtras().keySet()) {
                    Object value = intent.getExtras().get(key);
                    if (key != null && value != null) {
                        json.put(key, value.toString());
                    }
                }
                String jsonStr = json.toString();
                this.intentData = jsonStr;
            } catch (JSONException e) {
                Log.e(TAG, e.getMessage(), e);
            }

        }
    }

    @Override
    protected void onSetupPlugins(PluginManager pluginManager) {
        // ok
        pluginManager.addPlugin("IN_APP_BILLING", new InAppBillingPlugin());
        // xx: 申请中，需要删除账号
        pluginManager.addPlugin("FACEBOOK", new FacebookPlugin());
        // ok
        pluginManager.addPlugin("Umeng", new UmengPlugin("654e5664b2f6fa00ba7c6241"));
//        pluginManager.addPlugin("XINGE_PUSH", new XinGePushPlugin());
        // xx: 申请中
        pluginManager.addPlugin("ADJUST", new AdjustPlugin("63if6vf1222o"));
        // ok
        pluginManager.addPlugin("ShareSDK", new ShareSDKPlugin("38d13bd44cf34", "5aed52ad22aac6a23e09cf92ea991bb9"));
        // xx: 申请中
        pluginManager.addPlugin("GiantVoice", new GiantVoicePlugin());
        // xx: 账号申请中
        pluginManager.addPlugin("Line", new LinePlugin("1631229940"));
        // ok
        pluginManager.addPlugin("Firebase", new FirebasePlugin());
    }

    public void reportData(String sid, String lid, String log) {
//	    String url = "http://mvlptl9k01.opentexas.com/m/Push/pushLog?sid="+ sid + "&lid="+ lid;
//	    HttpPost httpRequest =new HttpPost(url);
//	    List <NameValuePair> params=new ArrayList<NameValuePair>();
//	    params.add(new BasicNameValuePair("log",log));
//	    try {
//            httpRequest.setEntity(new UrlEncodedFormEntity(params,HTTP.UTF_8));
//            new DefaultHttpClient().execute(httpRequest);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }
}
