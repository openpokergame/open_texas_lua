package com.opentexas.cocoslib.line;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.linecorp.linesdk.api.LineApiClient;
import com.linecorp.linesdk.api.LineApiClientBuilder;
import com.linecorp.linesdk.auth.LineLoginApi;
import com.linecorp.linesdk.auth.LineLoginResult;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;
import com.opentexas.cocoslib.core.LifecycleObserverAdapter;

public class LinePlugin extends LifecycleObserverAdapter implements IPlugin {
    private static final String TAG = LinePlugin.class.getSimpleName();
    private static final int REQUEST_CODE = 1;
    private String pluginId;
    private String channelId;
    private LineApiClient lineApiClient;

    public LinePlugin(String channelId) {
        this.channelId = channelId;
    }

    @Override
    public void initialize() {
        Cocos2dxActivityWrapper.getContext().addObserver(this);
        LineApiClientBuilder apiClientBuilder = new LineApiClientBuilder(Cocos2dxActivityWrapper.getContext(), this.channelId);
        lineApiClient = apiClientBuilder.build();
    }

    @Override
    public void setId(String id) {
        pluginId = id;
    }

    public String getId() {
        return pluginId;
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        super.onActivityResult(activity, requestCode, resultCode, data);
        LineLoginResult result = LineLoginApi.getLoginResultFromIntent(data);
        switch (result.getResponseCode()) {
            case SUCCESS:
                String accessToken = result.getLineCredential().getAccessToken().getAccessToken();
                String userID = result.getLineProfile().getUserId();
                String displayName = result.getLineProfile().getDisplayName();
                String statusMessage = result.getLineProfile().getStatusMessage();
                String pictureUrl = "";
                Uri uri = result.getLineProfile().getPictureUrl();
                if (uri != null) {
                    pictureUrl = uri.toString();
                }
                JSONObject json = new JSONObject();
                try {
                    json.put("accessToken", accessToken);
                    json.put("userID", userID);
                    json.put("displayName", displayName);
                    json.put("statusMessage", statusMessage);
                    json.put("pictureUrl", pictureUrl);
                    LineBridge.callLuaLogin(json.toString(), true);
                } catch (JSONException e) {
                    LineBridge.callLuaLogin("failed", true);
                    Log.e(TAG, e.getMessage(), e);
                }
                break;
            case CANCEL:
                LineBridge.callLuaLogin("canceled", true);
                Log.e(TAG, "Line Login Canceled by user!!");
                break;
            default:
                LineBridge.callLuaLogin("failed", true);
                Log.e(TAG, "Line Login FAILED!" + result.getErrorData().toString());
        }
    }

    public void login() {
        try {
            // App-to-app login
            Intent loginIntent = LineLoginApi.getLoginIntent(Cocos2dxActivityWrapper.getContext(), this.channelId);
            Cocos2dxActivityWrapper.getContext().startActivityForResult(loginIntent, REQUEST_CODE);
            //// Browser Login
            //Intent loginIntent = LineLoginApi.getLoginIntentWithoutLineAppAuth(Cocos2dxActivityWrapper.getContext(), this.channelId);
            //Cocos2dxActivityWrapper.getContext().startActivityForResult(loginIntent, REQUEST_CODE);
        } catch (Exception e) {
            Log.e(TAG, e.toString());
            LineBridge.callLuaLogin("failed", true);
        }
    }

    public void logout() {
        this.lineApiClient.logout();
    }

    public void share(String params) {
        try {
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");
            ComponentName cn = new ComponentName("jp.naver.line.android"
                    , "jp.naver.line.android.activity.selectchat.SelectChatActivity");
            Intent shareIntent = new Intent();
            shareIntent.setAction(Intent.ACTION_SEND);
//            Uri uri = Uri.parse(MediaStore.Images.Media.insertImage(mActivity.getContentResolver(), bitmap, null,null));
//            shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
//            shareIntent.setType("image/jpeg"); //图片分享
            shareIntent.setType("text/plain"); // 纯文本
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, caption);
            shareIntent.putExtra(Intent.EXTRA_TEXT, name + "\n" + link);

            shareIntent.setComponent(cn);//跳到指定APP的Activity
            Cocos2dxActivityWrapper.getContext().startActivity(Intent.createChooser(shareIntent, ""));
        } catch (Exception e) {
            LineBridge.callLuaShareResult("failed", true);
            Log.e(TAG, e.getMessage(), e);
        }
    }
}