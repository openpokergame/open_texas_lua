package com.opentexas.cocoslib.giantvoice;

import java.util.List;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.opentexas.cocoslib.core.Cocos2dxActivityUtil;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;

public class GiantVoiceBridge {
    private static final String TAG = GiantVoiceBridge.class.getSimpleName();
    private static int startRecordVoiceCallbackId = -1;
    private static int startPlayVoiceCallbackId = -1;
    private static int stopPlayVoiceCallbackId = -1;
    private static int recordVoiceCompleteCallbackId = -1;

    public static void setStartRecordVoiceCallback(int methodId) {
        if (startRecordVoiceCallbackId != -1) {
            Cocos2dxLuaJavaBridge.releaseLuaFunction(startRecordVoiceCallbackId);
            startRecordVoiceCallbackId = -1;
        }
        startRecordVoiceCallbackId = methodId;
    }

    public static void setStartPlayVoiceCallback(int methodId) {
        if (startPlayVoiceCallbackId != -1) {
            Cocos2dxLuaJavaBridge.releaseLuaFunction(startPlayVoiceCallbackId);
            startPlayVoiceCallbackId = -1;
        }
        startPlayVoiceCallbackId = methodId;
    }

    public static void setStopPlayVoiceCallback(int methodId) {
        if (stopPlayVoiceCallbackId != -1) {
            Cocos2dxLuaJavaBridge.releaseLuaFunction(stopPlayVoiceCallbackId);
            stopPlayVoiceCallbackId = -1;
        }
        stopPlayVoiceCallbackId = methodId;
    }

    public static void setRecordVoiceCompleteCallback(int methodId) {
        if (recordVoiceCompleteCallbackId != -1) {
            Cocos2dxLuaJavaBridge.releaseLuaFunction(recordVoiceCompleteCallbackId);
            recordVoiceCompleteCallbackId = -1;
        }
        recordVoiceCompleteCallbackId = methodId;
    }


    public static void initSDK(final String appId, final String appKey, final String xunfei, final String url) {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                GiantVoicePlugin plugin = getGiantVoicePlugin();
                if (plugin != null) {
                    plugin.initSDK(appId, appKey, xunfei, url);
                }
            }
        });
    }

//// 语音直播才用
//	public static void joinRoom(String roomId){
//		
//	}
//	public static void leaveRoom(){
//		
//	}

    public static void startPlayVoice(final String voiceUrl) {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                GiantVoicePlugin plugin = getGiantVoicePlugin();
                if (plugin != null) {
                    plugin.startPlayLocalVoice(voiceUrl);
                }
            }
        });
    }

    public static void stopPlayVoice() {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                GiantVoicePlugin plugin = getGiantVoicePlugin();
                if (plugin != null) {
                    plugin.stopPlayLocalVoice();
                }
            }
        });
    }

    public static void startRecordVoice(final int scaleLevel) {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                GiantVoicePlugin plugin = getGiantVoicePlugin();
                if (plugin != null) {
                    plugin.startRecordVoice(scaleLevel);
                }
            }
        });
    }

    public static void stopRecordVoice() {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                GiantVoicePlugin plugin = getGiantVoicePlugin();
                if (plugin != null) {
                    plugin.stopRecordVoice();
                }
            }
        });
    }

    public static void cancelRecordedVoice() {
        Cocos2dxActivityUtil.runOnBGThread(new Runnable() {
            @Override
            public void run() {
                GiantVoicePlugin plugin = getGiantVoicePlugin();
                if (plugin != null) {
                    plugin.cancelRecordedVoice();
                }
            }
        });
    }

    private static GiantVoicePlugin getGiantVoicePlugin() {
        if (Cocos2dxActivityWrapper.getContext() != null) {
            List<IPlugin> list = Cocos2dxActivityWrapper.getContext().getPluginManager().findPluginByClass(GiantVoicePlugin.class);
            if (list != null && list.size() > 0) {
                return (GiantVoicePlugin) list.get(0);
            } else {
                Log.d(TAG, "GiantVoicePlugin not found");
            }
        }
        return null;
    }

    ////////////////////////////////////////////////////////////////////////////////////////回调们

    /********************************************************************************************/
    static void callStartRecordVoice(final boolean value) {
        Cocos2dxActivityUtil.runOnResumed(new Runnable() {
            @Override
            public void run() {
                Cocos2dxActivityUtil.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        if (startRecordVoiceCallbackId != -1) {
                            if (value)
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(startRecordVoiceCallbackId, "1");
                            else
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(startRecordVoiceCallbackId, "0");
                        }
                    }
                });
            }
        });
    }

    static void callStartPlayVoice(final boolean value) {
        Cocos2dxActivityUtil.runOnResumed(new Runnable() {
            @Override
            public void run() {
                Cocos2dxActivityUtil.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        if (startPlayVoiceCallbackId != -1) {
                            if (value)
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(startPlayVoiceCallbackId, "1");
                            else
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(startPlayVoiceCallbackId, "0");
                        }
                    }
                });
            }
        });
    }

    static void callStopPlayVoice() {
        Cocos2dxActivityUtil.runOnResumed(new Runnable() {
            @Override
            public void run() {
                Cocos2dxActivityUtil.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        if (stopPlayVoiceCallbackId != -1) {
                            Cocos2dxLuaJavaBridge.callLuaFunctionWithString(stopPlayVoiceCallbackId, "");
                        }
                    }
                });
            }
        });
    }

    static void callRecordVoiceComplete(final int error, final String downloadUrl, final float duration, final String voiceText) {
        Cocos2dxActivityUtil.runOnResumed(new Runnable() {
            @Override
            public void run() {
                Cocos2dxActivityUtil.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        if (recordVoiceCompleteCallbackId != -1) {
                            JSONObject json = new JSONObject();
                            try {
                                json.put("error", error);
                                json.put("downloadUrl", downloadUrl);
                                json.put("duration", duration);
                                json.put("voiceText", voiceText); //语音转成对应的文字
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(recordVoiceCompleteCallbackId, json.toString());
                            } catch (JSONException e) {
                                Log.e(TAG, e.getMessage(), e);
                            }
                        }
                    }
                });
            }
        });
    }
}
