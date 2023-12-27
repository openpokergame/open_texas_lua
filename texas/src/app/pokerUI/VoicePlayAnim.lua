local VoicePlayAnim = class("VoicePlayAnim", function()
    return display.newNode()
end)

--[[
	全局只能同时播放一个声音
	data:播放数据
	playType：播放类型，1:默认播放（房间内坐下的玩家），2:点击播放（聊天记录里的）
--]]
function VoicePlayAnim:ctor(data,playType,parent)
	self:setNodeEventEnabled(true)
	self.parent__ = parent
	self.playType_ = playType
	self.dealIndex_ = 3
	self.status_ = -1
	self.data_ = data
	self.playNewVoiceId_ = sa.EventCenter:addEventListener("PLAY_NEW_VOICE", handler(self, self.onPlayNewVoice_))
	self.playVoiceCompleteId_ = sa.EventCenter:addEventListener("PLAY_VOICE_COMPLETE", handler(self, self.onPlayVoiceComplete_))
	self.animIcon_ = display.newSprite("#common/microphone_chat_signal3.png")
		:addTo(self)
	if playType==1 then
		self:play()
	else
	-- elseif playType==2 then
		NormalButton(self.parent__ or self.animIcon_):onButtonClicked(function(evt)
			self:play()
		end)
	end
end
--充值数据
function VoicePlayAnim:setVoiceData(data)
	self.data_ = data
end

function VoicePlayAnim:showPlayAnim()
	self.isPlaying_ = true
	self.animIcon_:schedule(function()
		if self.dealIndex_>3 then 
			self.dealIndex_ = 3
			self.status_ = self.status_*(-1)
		elseif self.dealIndex_<1 then
			self.dealIndex_ = 1
			self.status_ = self.status_*(-1)
		end
		self.animIcon_:setSpriteFrame("common/microphone_chat_signal"..self.dealIndex_..".png")
		self.dealIndex_ = self.dealIndex_ + self.status_
	end, 0.2)
end

function VoicePlayAnim:play()
	if self.isPlaying_ then return; end -- 正在播放就不播了
	self.animIcon_:stopAllActions()
	self:showPlayAnim()
	self.animIcon_:performWithDelay(function()
		self:onPlayVoiceComplete_()
    end,15) -- 播放10秒  远程加载5秒
    -- if self.playType_==1 and self.data_.id==tx.userData.uid then -- 房间内默认播放
    -- 	print("自己的就不播了吧")
    -- else
    	tx.VoiceSDK:startPlayVoice(self.data_.url)
    -- end
end

function VoicePlayAnim:stop()
	self.isPlaying_ = nil
	self.animIcon_:stopAllActions()
	self.animIcon_:setSpriteFrame("common/microphone_chat_signal3.png")
end

function VoicePlayAnim:onPlayNewVoice_(evt)
	if self.data_.url==evt.data then  --正好是自己
		if not self.isPlaying_ then
			self:showPlayAnim()
		end
	else
		self:onPlayVoiceComplete_()
	end
end
function VoicePlayAnim:onPlayVoiceComplete_(evt)
	self:stop()
	if self.playType_==1 and self.parent__ and self.parent__:getParent() then
		self.parent__:removeFromParent()
	end
end
function VoicePlayAnim:onCleanup()
	sa.EventCenter:removeEventListener(self.playNewVoiceId_)
	sa.EventCenter:removeEventListener(self.playVoiceCompleteId_)
end

return VoicePlayAnim