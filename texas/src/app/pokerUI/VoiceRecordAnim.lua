local VoiceRecordAnim = {}
local curView = nil
local Z_ORDER = 1002
VoiceRecordAnim.show = function()
	if not curView or not curView:getParent() then --创建一个新的
		curView = display.newNode()
			:pos(display.cx, display.cy)
			:addTo(tx.runningScene, Z_ORDER)
		curView:retain()
		curView.bg = display.newScale9Sprite("#common/microphone_bg.png", 0, 0, cc.size(320, 284))
			:addTo(curView)
		curView.microp = display.newSprite("#common/microphone.png"):addTo(curView)
		local startY = -14
		local startX = 0
		curView.mic1 = display.newSprite("#common/microphone_edge.png")
			:pos(startX,startY)
			:addTo(curView)
		curView.mic2 = display.newSprite("#common/microphone_mid.png")
			:pos(startX,startY+22)
			:addTo(curView)
		curView.mic3 = display.newSprite("#common/microphone_mid.png")
			:pos(startX,startY+22*2)
			:addTo(curView)
		curView.mic4 = display.newSprite("#common/microphone_edge.png")
			:pos(startX,startY+22*3)
			:addTo(curView)
		curView.mic4:setRotation(180)
		curView.timeLabel = ui.newTTFLabel({
				text="",
				size=28,
				color=cc.c3b(0xff,0xf4,0x0a),
			})
			:pos(0,startY+111)
			:addTo(curView)
		curView.tipsLabel = ui.newTTFLabel({
				text=sa.LangUtil.getText("ROOM", "VOICE_RECORDING"),
				size=26,
				color=cc.c3b(0x9c,0xaf,0xfc),
			})
		:pos(0,startY-83)
		:addTo(curView)
		sa.fitSprteWidth(curView.tipsLabel, 260)
	end
	curView:setLocalZOrder(Z_ORDER)
	curView:show()
	curView:stopAllActions()
	curView.timeLabel:setString("10S")
	curView.mic1:show()
	curView.mic2:show()
	curView.mic3:show()
	curView.mic4:show()
	local totalTime = 10
	local recordTime = 0
	local dealIndex = 4
	local status = -1
	curView:schedule(function()
		recordTime = recordTime + 0.25
		if recordTime%1==0 then
			local leftTime = totalTime - recordTime
			curView.timeLabel:setString(leftTime.."S")
			if leftTime<1 then
				VoiceRecordAnim:hide()
			end
		end
		if dealIndex>4 then 
			dealIndex = 4
			status = status*(-1)
		elseif dealIndex<1 then
			dealIndex = 1
			status = status*(-1)
		end
		if status<1 then
			curView["mic"..dealIndex]:hide()
		else
			curView["mic"..dealIndex]:show()
		end
		dealIndex = dealIndex + status
	end, 0.25)
end

VoiceRecordAnim.hide = function()
	if curView and curView:getParent() then
		curView:hide()
	end
end

return VoiceRecordAnim