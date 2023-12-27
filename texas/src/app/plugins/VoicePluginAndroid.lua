local VoicePluginAndroid = class("VoicePluginAndroid")
local logger = sa.Logger.new("VoicePluginAndroid")
local UploadUrl = "http://giant.audio.mztgame.com/wangpan.php" --方便热更新修改
local XUNFEIID = "58536195"
function VoicePluginAndroid:ctor()
    self.open = true
    self.startRecordVoiceHandler_ = handler(self, self.onStartRecordVoiceResult_)
    self.startPlayVoiceHandler_ = handler(self, self.onStartPlayVoiceResult_)
    self.stopPlayVoiceHandler_ = handler(self, self.onStopPlayVoiceResult_)
    self.recordVoiceCompleteHandler_ = handler(self, self.onRecordVoiceCompleteResult_)
    self:call_("initSDK", {appconfig.RTCHAT_APPID,appconfig.RTCHAT_APPKEY,XUNFEIID,UploadUrl}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    self:call_("setStartRecordVoiceCallback", {self.startRecordVoiceHandler_}, "(I)V")
    self:call_("setStartPlayVoiceCallback", {self.startPlayVoiceHandler_}, "(I)V")
    self:call_("setStopPlayVoiceCallback", {self.stopPlayVoiceHandler_}, "(I)V")  --播放完毕
    self:call_("setRecordVoiceCompleteCallback", {self.recordVoiceCompleteHandler_}, "(I)V")
end
function VoicePluginAndroid:onStartRecordVoiceResult_(result)
    if result=="1" then --成功
        
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "WARN_NO_PERMISSION"))
        tx.voiceRecordAnim:hide()
        self.isRecording_ = nil
        self.startRecordTime_ = nil
    end
end
function VoicePluginAndroid:onStartPlayVoiceResult_(result)
    if result=="1" then --成功  全局要用到  只能同时播一个
        self.isPlaying = true
    else
        -- 播放失败  默认播放完毕
        self:onStopPlayVoiceResult_()
    end
end
function VoicePluginAndroid:onStopPlayVoiceResult_(result)
    self.isPlaying = nil
    sa.EventCenter:dispatchEvent({name="PLAY_VOICE_COMPLETE"})
end
function VoicePluginAndroid:onRecordVoiceCompleteResult_(result)
    logger:debug(result)
    local ret = json.decode(result)
    local error,downloadUrl,duration,voiceText = nil,nil,nil,nil
    if ret then
        error = ret.error
        downloadUrl = ret.downloadUrl
        duration = ret.duration
        voiceText = ret.voiceText
    end
    -- 立即播放
    if downloadUrl and downloadUrl~="" then
        local startX,endX = string.find(downloadUrl,"http")
        if startX and endX then
            sa.EventCenter:dispatchEvent({name="RECORD_VOICE_COMPLETE", data=ret})
        end
    end
    self.isRecording_ = nil
    self.startRecordTime_ = nil
    tx.schedulerPool:clear(self.recordEndId_)
    self.recordEndId_ = nil
end
-- start public function
function VoicePluginAndroid:startPlayVoice(voiceUrl)
    if not voiceUrl or voiceUrl=="" then return; end
    self:stopPlayVoice()    -- 先停掉前一个
    self.isPlaying = true
    self:call_("startPlayVoice", {voiceUrl}, "(Ljava/lang/String;)V")
    sa.EventCenter:dispatchEvent({name="PLAY_NEW_VOICE", data=voiceUrl})
end
function VoicePluginAndroid:stopPlayVoice()
    self:call_("stopPlayVoice", {}, "()V")
end
function VoicePluginAndroid:startRecordVoice()
    if self.isRecording_ then  --正在录音重复调用
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "VOICE_TOOFAST"))
        return; 
    end
    self:cancelRecordedVoice()  -- 先停掉前一个
    
    self.recordTooLongId_ = tx.schedulerPool:delayCall(function() --录制时间太长了 强制发出
        tx.voiceRecordAnim:hide()
        tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "VOICE_TOOLONG"))
        self:stopRecordVoice()
    end, 10.1)
    tx.schedulerPool:clear(self.recordEndId_)
    self.recordEndId_ = nil
    self.isRecording_ = true
    self.startRecordTime_ = os.time()

    tx.voiceRecordAnim:show()
    local scaleLevel = 1
    self:call_("startRecordVoice", {scaleLevel}, "(I)V")
end
function VoicePluginAndroid:stopRecordVoice()
    tx.schedulerPool:clear(self.recordTooLongId_)
    self.recordTooLongId_ = nil
    if self.isRecording_ then
        local curTime = os.time()
        if curTime-self.startRecordTime_>=1 then
            -- 如果太长时间不回调，就无法再进行录制
            tx.schedulerPool:clear(self.recordEndId_)
            self.recordEndId_ = nil
            self.recordEndId_ = tx.schedulerPool:delayCall(function()
                tx.schedulerPool:clear(self.recordEndId_)
                self.recordEndId_ = nil
                self:cancelRecordedVoice()
            end, 7)
            self:call_("stopRecordVoice", {}, "()V")
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "VOICE_TOOSHORT"))
            self:cancelRecordedVoice()
        end
    else
        self:cancelRecordedVoice()
    end
end
function VoicePluginAndroid:cancelRecordedVoice()
    tx.schedulerPool:clear(self.recordTooLongId_)
    self.recordTooLongId_ = nil
    self:call_("cancelRecordedVoice", {}, "()V")
    self.isRecording_ = nil
    self.startRecordTime_ = nil
end
-- end public function
function VoicePluginAndroid:call_(javaMethodName, javaParams, javaMethodSig)
    if device.platform == "android" and self.open then
        local ok, ret = luaj.callStaticMethod("com/opentexas/cocoslib/giantvoice/GiantVoiceBridge", javaMethodName, javaParams, javaMethodSig)
        if not ok then
            if ret == -1 then
                logger:errorf("call %s failed, -1 不支持的参数类型或返回值类型", javaMethodName)
            elseif ret == -2 then
                logger:errorf("call %s failed, -2 无效的签名", javaMethodName)
            elseif ret == -3 then
                logger:errorf("call %s failed, -3 没有找到指定的方法", javaMethodName)
            elseif ret == -4 then
                logger:errorf("call %s failed, -4 Java 方法执行时抛出了异常", javaMethodName)
            elseif ret == -5 then
                logger:errorf("call %s failed, -5 Java 虚拟机出错", javaMethodName)
            elseif ret == -6 then
                logger:errorf("call %s failed, -6 Java 虚拟机出错", javaMethodName)
            end
        end
        return ok, ret
    else
        logger:debugf("call %s failed, not in android platform", javaMethodName)
        tx.schedulerPool:delayCall(function()
            if javaMethodName=="startRecordVoice" then
                self:onStartRecordVoiceResult_()
            elseif javaMethodName=="startPlayVoice" then
                self:onStartPlayVoiceResult_()
            elseif javaMethodName=="stopPlayVoice" then
                self:onStopPlayVoiceResult_()
            elseif javaMethodName=="stopRecordVoice" then
                self:onRecordVoiceCompleteResult_()
            end
        end,0.2)
        return false, nil
    end
end

return VoicePluginAndroid
