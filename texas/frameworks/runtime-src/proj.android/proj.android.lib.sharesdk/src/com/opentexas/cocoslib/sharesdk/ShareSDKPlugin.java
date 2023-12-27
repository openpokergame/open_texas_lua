package com.opentexas.cocoslib.sharesdk;

import java.net.ConnectException;
import java.util.HashMap;

import org.json.JSONObject;

import com.mob.MobSDK;

import cn.sharesdk.facebook.Facebook;
import cn.sharesdk.facebookmessenger.FacebookMessenger;
import cn.sharesdk.facebookmessenger.FacebookMessengerClientNotExistException;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.instagram.Instagram;
import cn.sharesdk.instagram.InstagramClientNotExistException;
import cn.sharesdk.line.Line;
import cn.sharesdk.line.LineClientNotExistException;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.system.text.ShortMessage;
import cn.sharesdk.twitter.Twitter;
import cn.sharesdk.whatsapp.WhatsApp;
import cn.sharesdk.whatsapp.WhatsAppClientNotExistException;

import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;
import com.opentexas.cocoslib.core.LifecycleObserverAdapter;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.util.Log;

public class ShareSDKPlugin extends LifecycleObserverAdapter implements IPlugin {
    private static final String TAG = ShareSDKPlugin.class.getSimpleName();
    private String pluginId;
    private String appKey;
    private String appSecret;

    public ShareSDKPlugin(String appKey, String appSecret) {
        this.appKey = appKey;
        this.appSecret = appSecret;
    }

    private PlatformActionListener mPlatformActionListener = new PlatformActionListener() {

        @Override
        public void onError(Platform platform, int action, Throwable throwable) {
            //失败的回调，arg:平台对象，arg1:表示当前的动作，arg2:异常信息
            String str = "Platform = " + platform.toString() + ",action = " + action + ",Throwable = " + throwable.toString();
            Log.e(TAG, "PlatformActionListener onError, " + str);
            if (throwable instanceof InstagramClientNotExistException) {
                ShareSDKBridge.callLuaShareTipsResult("NoInstagramClient");
            } else if (throwable instanceof LineClientNotExistException) {
                ShareSDKBridge.callLuaShareTipsResult("NoLineClient");
            } else if (throwable instanceof WhatsAppClientNotExistException) {
                ShareSDKBridge.callLuaShareTipsResult("NoWhatsAppClient");
            } else if (throwable instanceof FacebookMessengerClientNotExistException) {
                ShareSDKBridge.callLuaShareTipsResult("NoFacebookMessengerClient");
            } else if (throwable instanceof ConnectException) {
                ShareSDKBridge.callLuaShareTipsResult("NetConnectFailed");
            } else {
                ShareSDKBridge.callLuaShareTipsResult("failed");
            }
        }

        @Override
        public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
            //分享成功的回调
            String str = "Platform = " + arg0.toString() + ",action = " + arg1 + ",msg = " + arg2.toString();
            Log.d(TAG, "onComplete, " + str);
            ShareSDKBridge.callLuaShareTipsResult("success");
        }

        @Override
        public void onCancel(Platform arg0, int arg1) {
            //取消分享的回调
            String str = "Platform = " + arg0.toString() + ",action = " + arg1;
            Log.i(TAG, "onCancel, " + str);
            ShareSDKBridge.callLuaShareTipsResult("canceled");
        }
    };

    //测试代码1
    public void showShare(JSONObject json) {
        String name = json.optString("name");
        String caption = json.optString("caption");
        String message = json.optString("message");
        String link = json.optString("link");
        String picture = json.optString("picture");

        OnekeyShare oks = new OnekeyShare();

//		oks.setImageUrl("http://opentexas.vip/img/feed/1.jpg");
        oks.setText("text showShare");
        oks.setTitle("showShare");
        oks.setUrl(link);
        oks.setImageUrl(picture);

//	     oks.setPlatform(Facebook.NAME);

        oks.show(Cocos2dxActivityWrapper.getContext());
    }

    //测试代码2
    public void showShare() {
        OnekeyShare oks = new OnekeyShare();
        //关闭sso授权
        oks.disableSSOWhenAuthorize();

        // 分享时Notification的图标和文字  2.5.9以后的版本不     调用此方法
        //oks.setNotification(R.drawable.ic_launcher, getString(R.string.app_name));
        // title标题，印象笔记、邮箱、信息、微信、人人网和QQ空间使用
//	     oks.setTitle(getString(R.string.share));
        // titleUrl是标题的网络链接，仅在人人网和QQ空间使用
        oks.setTitleUrl("http://sharesdk.cn");
        // text是分享文本，所有平台都需要这个字段
        oks.setText("我是分享文本");
        // imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
        oks.setImagePath("/sdcard/test.jpg");//确保SDcard下面存在此张图片
        // url仅在微信（包括好友和朋友圈）中使用
        oks.setUrl("http://sharesdk.cn");
        // comment是我对这条分享的评论，仅在人人网和QQ空间使用
        oks.setComment("我是测试评论文本");
        // site是分享此内容的网站名称，仅在QQ空间使用
//	     oks.setSite(getString(R.string.app_name));
        // siteUrl是分享此内容的网站地址，仅在QQ空间使用
        oks.setSiteUrl("http://sharesdk.cn");

//	     oks.setPlatform(Facebook.NAME);

        // 启动分享GUI
        oks.show(Cocos2dxActivityWrapper.getContext());
    }

    //分享到Facebook
    public void shareByFacebook(String params) {
        try {
            Log.i(TAG, "shareByFacebook");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");

            Platform platform = ShareSDK.getPlatform(Facebook.NAME);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setUrl(link);
            shareParams.setImageUrl(picture);
            shareParams.setShareType(Platform.SHARE_WEBPAGE);

            platform.setPlatformActionListener(new PlatformActionListener() {

                @Override
                public void onError(Platform arg0, int arg1, Throwable arg2) {
                    //失败的回调，arg:平台对象，arg1:表示当前的动作，arg2:异常信息
                    String str = "Platform = " + arg0.toString() + ",action = " + arg1 + ",msg = " + arg2.toString();
                    Log.e(TAG, "onError" + str);
                    ShareSDKBridge.callLuaShareFacebookResult("failed", true);
                }

                @Override
                public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
                    //分享成功的回调
                    String str = "Platform = " + arg0.toString() + ",action = " + arg1 + ",msg = " + arg2.toString();
                    Log.d(TAG, "onComplete" + str);

                    String postId = arg2.get("post_id").toString();
                    Log.d(TAG, "postId = " + postId);
                    if (postId != null) {
                        ShareSDKBridge.callLuaShareFacebookResult(postId, true);
                    } else {
                        ShareSDKBridge.callLuaShareFacebookResult("failed", true);
                    }
                }

                @Override
                public void onCancel(Platform arg0, int arg1) {
                    //取消分享的回调
                    String str = "Platform = " + arg0.toString() + ",action = " + arg1;
                    Log.i(TAG, "onCancel" + str);
                    ShareSDKBridge.callLuaShareFacebookResult("canceled", true);
                }
            });
            platform.share(shareParams);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    //Twitter
    public void shareByTwitter(String params) {
        try {
            Log.i(TAG, "shareByTwitter");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");

            Platform platform = ShareSDK.getPlatform(Twitter.NAME);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setText(link + " " + name);
            shareParams.setImageUrl(picture);

            platform.setPlatformActionListener(mPlatformActionListener);
            platform.share(shareParams);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    //Instagram
    public void shareByInstagram(String params) {
        try {
            Log.i(TAG, "shareByInstagram");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");

            Platform platform = ShareSDK.getPlatform(Instagram.NAME);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setText(name);//不显示
            shareParams.setImageUrl(picture);

            platform.setPlatformActionListener(mPlatformActionListener);
            platform.share(shareParams);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    //Line支持分享文本或图片，但两者不能同时分享 参数说明
    public void shareByLine(String params) {
        try {
            Log.i(TAG, "shareByLine");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");

            Platform platform = ShareSDK.getPlatform(Line.NAME);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setText(link + " " + name);

            platform.setPlatformActionListener(mPlatformActionListener);
            platform.share(shareParams);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    //WhatsApp支持分享文本或图片，但两者不能同时分享 参数说明
    public void shareByWhatsApp(String params) {
        try {
            Log.i(TAG, "shareByWhatsApp");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");

            Platform platform = ShareSDK.getPlatform(WhatsApp.NAME);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setText(link + " " + name);

            platform.setPlatformActionListener(mPlatformActionListener);
            platform.share(shareParams);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    //FacebookMessenger
    public void shareByFacebookMessenger(String params) {
        try {
            Log.i(TAG, "shareByFacebookMessenger");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");

            Log.i(TAG, "Platform.SHARE_WEBPAGE");
            Platform platform = ShareSDK.getPlatform(FacebookMessenger.NAME);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setText(name);
            shareParams.setTitle(caption);
            shareParams.setImageUrl(picture);
            shareParams.setUrl(link);
            shareParams.setShareType(Platform.SHARE_WEBPAGE);
            platform.setPlatformActionListener(mPlatformActionListener);
            platform.share(shareParams);

        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    //sms
    public void shareByShortMessage(String params) {
        try {
            Log.i(TAG, "shareByShortMessage");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");

            Platform platform = ShareSDK.getPlatform(ShortMessage.NAME);
            Platform.ShareParams shareParams = new Platform.ShareParams();
            shareParams.setTitle(caption);
            shareParams.setText(link + " " + name);

            platform.setPlatformActionListener(mPlatformActionListener);
            platform.share(shareParams);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    //shareByCopy
    public void shareByCopy(String params) {
        try {
            Log.i(TAG, "shareByCopy");
            JSONObject json = new JSONObject(params);
            String name = json.optString("name");
            String caption = json.optString("caption");
            String message = json.optString("message");
            String link = json.optString("link");
            String picture = json.optString("picture");

            // 得到剪贴板管理器
            Context context = Cocos2dxActivityWrapper.getContext();
            ClipboardManager cmb = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
            ClipData clipData = ClipData.newPlainText("label", name + " " + link);
            cmb.setPrimaryClip(clipData);

            Log.i(TAG, cmb.getPrimaryClip().toString());
            ShareSDKBridge.callLuaShareTipsResult("shareByCopy");
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void initialize() {
        Cocos2dxActivityWrapper.getContext().addObserver(this);
        MobSDK.init(Cocos2dxActivityWrapper.getContext(), this.appKey, this.appSecret);
    }

    @Override
    public void setId(String id) {
        pluginId = id;
    }
}
