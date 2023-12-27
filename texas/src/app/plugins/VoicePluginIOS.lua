local VoicePluginIOS = class("VoicePluginIOS")
local logger = sa.Logger.new("VoicePluginIOS")
local UploadUrl = "http://giant.audio.mztgame.com/wangpan.php" --方便热更新修改
local XUNFEIID = "5853625c"
function VoicePluginIOS:ctor()
    self.open = true  -- IOS暂时关闭
    luaoc.callStaticMethod("GiantVoiceBridge", "initSDK", {appid=appconfig.RTCHAT_APPID,key=appconfig.RTCHAT_APPKEY,xunfei=XUNFEIID,url=UploadUrl})
    luaoc.callStaticMethod("GiantVoiceBridge", "setStartRecordVoiceCallback", {listener = handler(self, self.onStartRecordVoiceResult_)})
    luaoc.callStaticMethod("GiantVoiceBridge", "setStartPlayVoiceCallback", {listener = handler(self, self.onStartPlayVoiceResult_)})
    luaoc.callStaticMethod("GiantVoiceBridge", "setStopPlayVoiceCallback", {listener = handler(self, self.onStopPlayVoiceResult_)})
    luaoc.callStaticMethod("GiantVoiceBridge", "setRecordVoiceCompleteCallback", {listener = handler(self, self.onRecordVoiceCompleteResult_)})
end
function VoicePluginIOS:onStartRecordVoiceResult_(result)
    if result=="1" then --成功
        
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "WARN_NO_PERMISSION"))
        tx.voiceRecordAnim:hide()
        self.isRecording_ = nil
        self.startRecordTime_ = nil
    end
end
function VoicePluginIOS:onStartPlayVoiceResult_(result)
    if result=="1" then --成功  全局要用到  只能同时播一个
        self.isPlaying = true
    else
        -- 播放失败  默认播放完毕
        self:onStopPlayVoiceResult_()
    end
end
function VoicePluginIOS:onStopPlayVoiceResult_(result)
    self.isPlaying = nil
    sa.EventCenter:dispatchEvent({name="PLAY_VOICE_COMPLETE"})
end
function VoicePluginIOS:onRecordVoiceCompleteResult_(result)
    logger:debug(result)
    local ret = json.decode(result)
    local error,downloadUrl,duration,voiceText = nil,nil,nil,nil
    if ret then
        error = ret.error
        downloadUrl = ret.url
        duration = ret.duration
        voiceText = ret.text
    end
    -- 立即播放
    if downloadUrl and downloadUrl~=""  then
        local startX,endX = string.find(downloadUrl,"http")
        if startX and endX then
            ret.downloadUrl = downloadUrl
            ret.voiceText = voiceText
            sa.EventCenter:dispatchEvent({name="RECORD_VOICE_COMPLETE", data=ret})
        end
    end
    self.isRecording_ = nil
    self.startRecordTime_ = nil
    tx.schedulerPool:clear(self.recordEndId_)
    self.recordEndId_ = nil
end
-- start public function
function VoicePluginIOS:startPlayVoice(voiceUrl)
    if not voiceUrl or voiceUrl=="" then return; end
    self:stopPlayVoice()    -- 先停掉前一个
    self.isPlaying = true
    luaoc.callStaticMethod("GiantVoiceBridge", "startPlayVoice", {voiceUrl = voiceUrl})
    sa.EventCenter:dispatchEvent({name="PLAY_NEW_VOICE", data=voiceUrl})
end
function VoicePluginIOS:stopPlayVoice()
    luaoc.callStaticMethod("GiantVoiceBridge", "stopPlayVoice")
end
function VoicePluginIOS:startRecordVoice()
    if self.isRecording_ then --正在录音重复调用
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
    luaoc.callStaticMethod("GiantVoiceBridge", "startRecordVoice", {scaleLevel = scaleLevel})
end
function VoicePluginIOS:stopRecordVoice()
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
            luaoc.callStaticMethod("GiantVoiceBridge", "stopRecordVoice")
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("ROOM", "VOICE_TOOSHORT"))
            self:cancelRecordedVoice()
        end
    else
        self:cancelRecordedVoice()
    end
end
function VoicePluginIOS:cancelRecordedVoice()
    tx.schedulerPool:clear(self.recordTooLongId_)
    self.recordTooLongId_ = nil
    luaoc.callStaticMethod("GiantVoiceBridge", "cancelRecordedVoice")
    self.isRecording_ = nil
    self.startRecordTime_ = nil
end

return VoicePluginIOS
