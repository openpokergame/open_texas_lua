package com.opentexas.cocoslib.sharesdk;

import java.util.List;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONException;
import org.json.JSONObject;

import com.opentexas.cocoslib.core.Cocos2dxActivityUtil;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;

import android.util.Log;

public class ShareSDKBridge {
    private static final String TAG = ShareSDKBridge.class.getSimpleName();
    private static int shareFacebookResultCallback = -1;
    private static int shareTipsCallback = -1;

    private static ShareSDKPlugin getShareSDKPlugin() {
        if (Cocos2dxActivityWrapper.getContext() != null) {
            List<IPlugin> list = Cocos2dxActivityWrapper.getContext().getPluginManager().findPluginByClass(ShareSDKPlugin.class);
            if (list != null && list.size() > 0) {
                return (ShareSDKPlugin) list.get(0);
            } else {
                Log.d(TAG, "ShareSDKPlugin not found");
            }
        }
        return null;
    }

    public static void setShareFacebookCallback(final int callback) {
        Log.d(TAG, "setShareFacebookCallback " + callback);
        if (ShareSDKBridge.shareFacebookResultCallback != -1) {
            Log.d(TAG, "release lua function " + ShareSDKBridge.shareFacebookResultCallback);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(ShareSDKBridge.shareFacebookResultCallback);
            ShareSDKBridge.shareFacebookResultCallback = -1;
        }
        ShareSDKBridge.shareFacebookResultCallback = callback;
    }

    public static void setShareTipsCallback(final int callback) {
        Log.d(TAG, "setShareTipsCallback " + callback);
        if (ShareSDKBridge.shareTipsCallback != -1) {
            Log.d(TAG, "release lua function " + ShareSDKBridge.shareTipsCallback);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(ShareSDKBridge.shareTipsCallback);
            ShareSDKBridge.shareTipsCallback = -1;
        }
        ShareSDKBridge.shareTipsCallback = callback;
    }

    public static void shareByFacebook(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByFacebook begin");
                    plugin.shareByFacebook(params);
                    Log.d(TAG, "plugin shareByFacebook end");
                }
            }, 50);
        }
    }

    public static void shareByTwitter(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByTwitter begin");
                    plugin.shareByTwitter(params);
                    Log.d(TAG, "plugin shareByTwitter end");
                }
            }, 50);
        }
    }

    public static void shareByInstagram(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByInstagram begin");
                    plugin.shareByInstagram(params);
                    Log.d(TAG, "plugin shareByInstagram end");
                }
            }, 50);
        }
    }

    public static void shareByLine(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByLine begin");
                    plugin.shareByLine(params);
                    Log.d(TAG, "plugin shareByLine end");
                }
            }, 50);
        }
    }

    public static void shareByWhatsApp(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByWhatsApp begin");
                    plugin.shareByWhatsApp(params);
                    Log.d(TAG, "plugin shareByWhatsApp end");
                }
            }, 50);
        }
    }

    public static void shareByFacebookMessenger(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByFacebookMessenger begin");
                    plugin.shareByFacebookMessenger(params);
                    Log.d(TAG, "plugin shareByFacebookMessenger end");
                }
            }, 50);
        }
    }

    public static void shareByShortMessage(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByShortMessage begin");
                    plugin.shareByShortMessage(params);
                    Log.d(TAG, "plugin shareByShortMessage end");
                }
            }, 50);
        }
    }

    public static void shareByCopy(final String params) {
        final ShareSDKPlugin plugin = getShareSDKPlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "plugin shareByOther begin");
                    plugin.shareByCopy(params);
                    Log.d(TAG, "plugin shareByOther end");
                }
            }, 50);
        }
    }

    //to lua
    public static void callLuaShareFacebookResult(final String result, boolean delay) {
        Log.d(TAG, "callLuaShareFacebookResult " + Thread.currentThread().getId());
        if (delay) {
            Cocos2dxActivityWrapper ctx = Cocos2dxActivityWrapper.getContext();
            if (ctx != null) {
                Cocos2dxActivityUtil.runOnResumed(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxActivityUtil.runOnGLThreadDelay(new Runnable() {
                            @Override
                            public void run() {
                                Log.d(TAG, "call lua function shareFacebookResultCallback " + ShareSDKBridge.shareFacebookResultCallback + " " + result);
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(ShareSDKBridge.shareFacebookResultCallback, result);
                            }
                        }, 50);
                    }
                });
            }
        } else {
            Cocos2dxActivityUtil.runOnResumed(new Runnable() {
                @Override
                public void run() {
                    Cocos2dxActivityUtil.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            Log.d(TAG, "call lua function shareFacebookResultCallback " + ShareSDKBridge.shareFacebookResultCallback + " " + result);
                            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(ShareSDKBridge.shareFacebookResultCallback, result);
                        }
                    });
                }
            });
        }
    }

    public static void callLuaShareTipsResult(final String result) {
        Log.d(TAG, "callLuaShareTipsResult " + Thread.currentThread().getId());
        Cocos2dxActivityUtil.runOnResumed(new Runnable() {
            @Override
            public void run() {
                Cocos2dxActivityUtil.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        if (ShareSDKBridge.shareTipsCallback != -1) {
                            Log.d(TAG, "call lua function shareTipsCallback " + ShareSDKBridge.shareTipsCallback + " " + result);
                            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(ShareSDKBridge.shareTipsCallback, result);
                        }
                    }
                });
            }
        });
    }
}
