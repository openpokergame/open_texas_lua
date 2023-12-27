package com.opentexas.cocoslib.line;

import java.util.List;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.util.Log;

import com.opentexas.cocoslib.core.Cocos2dxActivityUtil;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;

public class LineBridge {
    private static final String TAG = LineBridge.class.getSimpleName();

    private static int loginResultCallback = -1;
    private static int shareResultCallback = -1;

    private static LinePlugin getLinePlugin() {
        if (Cocos2dxActivityWrapper.getContext() != null) {
            List<IPlugin> list = Cocos2dxActivityWrapper.getContext().getPluginManager().findPluginByClass(LinePlugin.class);
            if (list != null && list.size() > 0) {
                return (LinePlugin) list.get(0);
            } else {
                Log.d(TAG, "LinePlugin not found");
            }
        }
        return null;
    }

    //for lua
    public static void setLoginCallback(final int callback) {
        Log.d(TAG, "setLoginCallback " + callback);
        if (LineBridge.loginResultCallback != -1) {
            Log.d(TAG, "release lua function " + LineBridge.loginResultCallback);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(LineBridge.loginResultCallback);
            LineBridge.loginResultCallback = -1;
        }
        LineBridge.loginResultCallback = callback;
    }

    public static void setShareResultCallback(final int callback) {
        Log.d(TAG, "setShareResultCallback " + callback);
        if (LineBridge.shareResultCallback != -1) {
            Log.d(TAG, "release lua function " + LineBridge.shareResultCallback);
            Cocos2dxLuaJavaBridge.releaseLuaFunction(LineBridge.shareResultCallback);
            LineBridge.shareResultCallback = -1;
        }
        LineBridge.shareResultCallback = callback;
    }

    public static void login() {
        final LinePlugin plugin = getLinePlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "line plugin login begin");
                    plugin.login();
                    Log.d(TAG, "line plugin login end");
                }
            }, 50);
        }
    }

    public static void logout() {
        final LinePlugin plugin = getLinePlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "line plugin logout begin");
                    plugin.logout();
                    Log.d(TAG, "line plugin logout end");
                }
            }, 50);
        }
    }

    public static void share(final String params) {
        final LinePlugin plugin = getLinePlugin();
        if (plugin != null) {
            Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
                @Override
                public void run() {
                    Log.d(TAG, "line plugin share begin");
                    plugin.share(params);
                    Log.d(TAG, "line plugin share end");
                }
            }, 50);
        }
    }

    //to lua
    static void callLuaLogin(final String accessToken, boolean delay) {
        Log.d(TAG, "callLuaLogin " + Thread.currentThread().getId());
        if (delay) {
            Cocos2dxActivityWrapper ctx = Cocos2dxActivityWrapper.getContext();
            if (ctx != null) {
                Cocos2dxActivityUtil.runOnResumed(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxActivityUtil.runOnGLThreadDelay(new Runnable() {
                            @Override
                            public void run() {
                                Log.d(TAG, "call lua function Line loginResultCallback " + LineBridge.loginResultCallback + " " + accessToken);
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(LineBridge.loginResultCallback, accessToken);
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
                            Log.d(TAG, "call lua function Line loginResultCallback " + LineBridge.loginResultCallback + " " + accessToken);
                            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(LineBridge.loginResultCallback, accessToken);
                        }
                    });
                }
            });
        }
    }

    static void callLuaShareResult(final String result, boolean delay) {
        Log.d(TAG, "callLuaLineShareResult " + Thread.currentThread().getId());
        if (delay) {
            Cocos2dxActivityWrapper ctx = Cocos2dxActivityWrapper.getContext();
            if (ctx != null) {
                Cocos2dxActivityUtil.runOnResumed(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxActivityUtil.runOnGLThreadDelay(new Runnable() {
                            @Override
                            public void run() {
                                Log.d(TAG, "call lua function line shareResultCallback " + LineBridge.shareResultCallback + " " + result);
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(LineBridge.shareResultCallback, result);
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
                            Log.d(TAG, "call lua function line shareResultCallback " + LineBridge.shareResultCallback + " " + result);
                            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(LineBridge.shareResultCallback, result);
                        }
                    });
                }
            });
        }
    }
}