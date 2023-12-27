package com.opentexas.cocoslib.giantvoice;

import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.text.TextUtils;
import android.util.Log;

import com.giantvoice.util.FileData;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;
import com.opentexas.cocoslib.core.LifecycleObserverAdapter;
import com.ztgame.voiceengine.NativeVoiceEngine;
import com.ztgame.voiceengine.RTChatSDKVoiceListener;
import com.ztgame.voiceengine.ReceiveDataFromC;

public class GiantVoicePlugin extends LifecycleObserverAdapter implements IPlugin {
    protected static final String TAG = GiantVoicePlugin.class.getSimpleName();
    protected String id;
    private NativeVoiceEngine rtChatSdk;
    ReceiveDataFromC receiveDataFromC;
    private String AppID = "58536195";  //android讯飞ID
    private String FileURL = "http://giant.audio.mztgame.com/wangpan.php";
    private String downloadUrlLocal;
    private String voiceTextLocal;
    private Context mContext;
    float volumeValue = 10;
    boolean isInit = false;
    boolean mute = true;
    boolean isPlaying = false;
    boolean isRecording = false;

    private void showToast(String msg) {
//		Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void initialize() {
        Cocos2dxActivityWrapper.getContext().addObserver(this);
        rtChatSdk = NativeVoiceEngine.getInstance();
        rtChatSdk.register(Cocos2dxActivityWrapper.getContext());
        rtChatSdk.setDebugLogEnabled(true);
        mContext = Cocos2dxActivityWrapper.getContext();
        receiveDataFromC = new ReceiveDataFromC();
        receiveDataFromC.setRtChatSDKVoiceListener(new RTChatSDKVoiceListener() {
            @Override
            public void rtchatsdkListener(int cmdType, final int error, String dataPtr, int dataSize) {
                Log.i(TAG, dataPtr);
                switch (cmdType) {
                    case 1://初始化
                    {
                        String msg = "SDK初始化失败 ------";
                        int ret = rtChatSdk.getSdkState();
                        if (error == 1) {
                            isInit = true;
                            msg = "SDK初始化成功 ------";
                        }
                        ;
                        if (error == 0 && ret > 0) {
                            msg = "SDK重复初始化 ------";
                        }
                        // rtChatSdk.setParams(FileURL, AppID);
                        showToast(msg + error);
                    }
                    break;
                    case 7://进入房间
                    {
                        showToast("进入房间" + error);
                    }
                    break;
                    case 25://录音结束，上传成功
                    {
                        FileData fileData = getDataFromJson(dataPtr);
                        String voiceText;
                        float duration;
                        if (fileData == null) {
                            downloadUrlLocal = null;
                            voiceText = null;
                            duration = 0;
                        } else {
                            downloadUrlLocal = fileData.getUrl();
                            voiceText = fileData.getText();
                            duration = Float.valueOf(fileData.getDuration());
                        }
                        Log.i(TAG, "-录音结束-jni_log----error:" + error + " downloadUrlLocal:" + downloadUrlLocal + " duration:" + duration + " text:" + voiceText);
                        voiceTextLocal = voiceText;
//                        etResult.setText("回调后的翻译：" + voiceTextLocal);
                        showToast("录音结束" + error + " downloadUrlLocal:" + downloadUrlLocal + " duration:" + duration);
                        GiantVoiceBridge.callRecordVoiceComplete(error, downloadUrlLocal, duration, voiceText);
                    }
                    break;
                    case 35://播放结束
                    {
                        isPlaying = false;
                        rtChatSdk.stopPlayLocalVoice();
                        showToast("播放完毕");
                        GiantVoiceBridge.callStopPlayVoice();
                        //Log.i(TAG, "-MainActivity-播放完毕------error" + error + " " + dataSize);
                    }
                    break;
                    default:
                        break;
                }
            }
        });
    }

    private static FileData getDataFromJson(String msg) {
        try {
            if (TextUtils.isEmpty(msg))
                return null;
            Log.i(TAG, "MainActivity delete alibaba:" + msg);
            JSONObject jsonObject = new JSONObject(msg);
            String url = jsonObject.getString("url");
            String duration = jsonObject.getString("duration");
            String filesize = jsonObject.getString("filesize");
            String text = jsonObject.getString("text");
            String labelid = jsonObject.getString("labelid");
            FileData user = new FileData();
            user.setDuration(duration);
            user.setUrl(url);
            user.setFilesize(filesize);
            user.setText(text);
            user.setLabelid(labelid);
            Log.i(TAG, "MainActivity delete alibaba:" + user.toString());
            return user;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void setUserInfo(String userName, String userKey) {
        if (TextUtils.isEmpty(userName))
            userName = "nameChange";
        rtChatSdk.setUserInfo(userName, userKey);
        showToast("设置登录用户信息" + userName);
    }

    public void cancelRecordedVoice() {
        rtChatSdk.cancelRecordedVoice();
        isRecording = false;
        showToast("取消录音");
    }

    public void stopRecordVoice() {
        rtChatSdk.stopRecordVoice();
        showToast("已经停止录音");
    }

    public void startRecordVoice(int scaleLevel) {
        //先检测权限
        Boolean havePermit = true;
        // int audioSource = MediaRecorder.AudioSource.MIC;
        // int sampleRateInHz = 44100;
        // int channelConfig = AudioFormat.CHANNEL_IN_STEREO;
        // int audioFormat = AudioFormat.ENCODING_PCM_16BIT;
        // int bufferSizeInBytes = 0;
        // bufferSizeInBytes = AudioRecord.getMinBufferSize(sampleRateInHz,
        //               channelConfig, audioFormat);
        // AudioRecord audioRecord =  new AudioRecord(audioSource, sampleRateInHz,
        //               channelConfig, audioFormat, bufferSizeInBytes);
        // try{
        // 	audioRecord.startRecording();
        // }catch (IllegalStateException e){
        // 	e.printStackTrace();
        // }
        // if (audioRecord.getRecordingState() != AudioRecord.RECORDSTATE_RECORDING) {
        // 	havePermit = false;
        // 	audioRecord = null;
        // }else{
        // 	audioRecord.stop();
        //        audioRecord.release();
        //        audioRecord = null;
        // }

        if (scaleLevel == 0) scaleLevel = 1;
        boolean recordVoiceRet = false;
        if (havePermit == true) {
            recordVoiceRet = rtChatSdk.startRecordVoice(false, true, scaleLevel);
        }
        showToast("开始录音   code=" + recordVoiceRet);
        GiantVoiceBridge.callStartRecordVoice(recordVoiceRet);
    }

    public void stopPlayLocalVoice() {
        if (isPlaying) {
            rtChatSdk.stopPlayLocalVoice();
        }
        isPlaying = false;
        showToast("已经停止播放");
    }

    public void startPlayLocalVoice(String voiceUrl) {
        if (TextUtils.isEmpty(voiceUrl) || !this.isInit) {
            GiantVoiceBridge.callStartPlayVoice(false);
            return;
        }
        if (isPlaying) {
            rtChatSdk.stopPlayLocalVoice();
        }
        isPlaying = true;
        GiantVoiceBridge.callStartPlayVoice(true);
        rtChatSdk.startPlayLocalVoice(voiceUrl);
        showToast("正在播放");
    }

    public void adjustSpeakerVolume(int volumeValue) {
        if (volumeValue < 0) volumeValue = 0;
        else if (volumeValue > 10) volumeValue = 10;
        int retCode = rtChatSdk.adjustSpeakerVolume(volumeValue);
        showToast("设置录制音量大小  volumeValue:" + volumeValue + " retCode:" + retCode);
    }

    public void initSDK(String appId, String appKey, String xunfei, String url) {
        showToast("初始化SDK");
        this.AppID = xunfei;
        this.FileURL = url;
        rtChatSdk.initSDK(appId, appKey);
    }

    public void customRoomServerAddr(String roomServerStr) {
        if (TextUtils.isEmpty(roomServerStr)) {
            showToast("自定义房间失败         " + "请输入IP:");
            return;
        }
        rtChatSdk.setUserInfo("nameChange", "nameChange");
        // rtChatSdk.setParams(FileURL, AppID);
        // rtChatSdk.customRoomServerAddr(roomServerStr);
        showToast("自定义房间:" + roomServerStr);
    }

    public void requestJoinPlatformRoom(String roomId) {
        if (TextUtils.isEmpty(roomId)) {
            showToast("房间号不能为空");
            return;
        }
        int retCode = rtChatSdk.requestJoinPlatformRoom(roomId, 1, 4);
        showToast("进入房间返回的值：retCode:" + retCode);
    }

    public void requestLeavePlatformRoom() {
        int retCode = rtChatSdk.requestLeavePlatformRoom();
        showToast("离开房间返回的值：retCode:" + retCode);
    }

    public void setLouderSpeaker(int value) {
        int retCode = 0;
        if (value == 0) {
            retCode = rtChatSdk.setLouderSpeaker(false);
            showToast("关闭扬声器:" + retCode);
        } else {
            retCode = rtChatSdk.setLouderSpeaker(true);
            showToast("打开扬声器:" + retCode);
        }
    }

    public void setSendVoice() {
        rtChatSdk.setSendVoice(!mute);
        mute = !mute;
        String str = null;
        if (mute) str = "true";
        else str = "false";
        showToast("设置静音:" + str);
    }

    @Override
    public void onRequestPermissionsResult(Activity activity, int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(activity, requestCode, permissions, grantResults);
        rtChatSdk.onRequestPermissionsResult(requestCode, permissions, grantResults);
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

    @Override
    public void onDestroy(Activity activity) {
        rtChatSdk.stopAudioManager();
        rtChatSdk.unRegister();
        rtChatSdk = null;
        super.onDestroy(activity);
    }
}
