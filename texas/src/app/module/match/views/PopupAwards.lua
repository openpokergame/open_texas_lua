local PopupAwards = class("PopupAwards",function()
	return display.newNode()
end)

function PopupAwards:ctor(matchLevel, rank)
	self:initData_(matchLevel)

	self.rank_ = rank
	local reward = self.data_.reward
	local isReward = true
	self.isShowShareBtn_ = true
	if rank > #reward then
		isReward = false
	end

	self.isInMatch_ = tx.socket.HallSocket.isInMatch

	self:addMainUI_()

	if isReward then
		local str = sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatBigNumber(reward[rank].chips))
		if rank == 1 and reward[rank].dhqReward > 0 then
			local str2 = sa.LangUtil.getText("STORE", "FORMAT_DHQ", reward[rank].dhqReward)
			str = str .. " + " .. str2
		end
		local textArr = sa.LangUtil.getText("MATCH", "REWARD_TEXT")
        local index = math.random(1, #textArr)
		self.rewardTips_:setString(sa.LangUtil.getText("MATCH", "REWARD_TIPS", str, textArr[index]))

		self.shareBtn_:onButtonClicked(buttontHandler(self, self.onShareClicked_))
			:setButtonLabelString(sa.LangUtil.getText("COMMON", "SHARE"))
	else
		local textArr = sa.LangUtil.getText("MATCH", "NO_REWARD_TEXT")
        local index = math.random(1, #textArr)
		self.rewardTips_:setString(textArr[index])

		self.shareBtn_:onButtonClicked(buttontHandler(self, self.onLookClicked_))
			:setButtonLabelString(sa.LangUtil.getText("MATCH", "LEFT_LOOK"))
	end

	if self.isInMatch_ then
		self.backHallBtn_:setButtonLabelString(sa.LangUtil.getText("MATCH", "BACK_HALL"))
	else
		self.backHallBtn_:setButtonLabelString(sa.LangUtil.getText("MATCH", "CLOSE"))
		if not isReward then
			self.isShowShareBtn_ = false
			self.backHallBtn_:setPositionX(-250)
			self.againBtn_:setPositionX(250)
		end
	end

	if tonumber(rank) == 1 then
		self.rankingLabel_:setPositionX(-10)
	end
	self.rankingLabel_:setString(rank)
end

function PopupAwards:initData_(matchLevel)
	local data 
	local config = tx.userData.sngTableConfig
	for _, v in ipairs(config) do
		if v.matchlevel == matchLevel then
			data = v
			break
		end
	end

	self.data_ = data
	self.matchLevel_ = matchLevel
end

function PopupAwards:addMainUI_()
	local an = sp.SkeletonAnimation:create("spine/match_reward.json","spine/match_reward.atlas")
        :pos(0, -140)
        :addTo(self)
    an:setAnimation(0, "light", true)

	local animation = sp.SkeletonAnimation:create("spine/match_reward.json","spine/match_reward.atlas")
        :pos(0, -140)
        :addTo(self, 1)
    animation:setAnimation(0, "jiesuan", false)

    local emitter = cc.ParticleSystemQuad:create("particle/match_reward_dots.plist")
		:pos(0, 80)
        :addTo(self)

    self.rankingLabel_ = ui.newBMFontLabel({text = "", font = "fonts/match_reward_rank.fnt"})
        :pos(0, 265)
        :addTo(animation)

    ui.newTTFLabel({text = sa.LangUtil.getText("MATCH", "RANKING"), size = 30, color = cc.c3b(0x87, 0x43, 0x00)})
    	:pos(0, 70)
    	:addTo(animation)

    local frame_w, frame_h = 450, 120
    local frame = display.newScale9Sprite("img/match_reward_bg.png", 0, 0, cc.size(frame_w, frame_h))
        :pos(0, -190)
        :addTo(self)
        :hide()
    self.rewardTipsFrame_ = frame

    self.rewardTips_ = ui.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER})
    	:pos(frame_w*0.5, frame_h*0.5)
    	:addTo(frame)

	local btn_w, btn_h = 320, 146
 	local btn_x, btn_y = 0, -315
 	local dir = 350
 	self.backHallBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
 		:setButtonSize(btn_w, btn_h)
 		:setButtonLabel(ui.newTTFLabel({text = "", size = 26}))
        :onButtonClicked(buttontHandler(self, self.onCloseClicked_))
        :pos(btn_x - dir, btn_y)
        :addTo(self)
        :hide()

    self.shareBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text = "", size = 26}))
        :pos(btn_x, btn_y)
        :addTo(self)
        :hide()

    self.againBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("MATCH", "PLAY_AGAIN"), size = 26}))
        :onButtonClicked(buttontHandler(self, self.onPlayAgainClicked_))
        :pos(btn_x + dir, btn_y)
        :addTo(self)
        :hide()

    
    animation:performWithDelay(function()
    	self:showAllButton_()
    end, 0.5)
end

function PopupAwards:showAllButton_()
    self.rewardTipsFrame_:show()
    self.backHallBtn_:show()
    if self.isShowShareBtn_ then
    	self.shareBtn_:show()
    end
	self.againBtn_:show()
end

function PopupAwards:onCloseClicked_()
	if self.isInMatch_ then
	    local curScene = display.getRunningScene()
        curScene:doBackToHall()
	else
		self:hidePanel_()
	end
end

function PopupAwards:onShareClicked_()
	local feedData = clone(sa.LangUtil.getText("FEED", "MATCH_COMPLETE"))
    feedData.name = sa.LangUtil.formatString(feedData.name, self.data_.name, self.rank_)
	tx.ShareSDK:shareFeed(feedData, function(success, result)
		if success then
            self:hidePanel_()
        end
	end)
end

function PopupAwards:onLookClicked_()
	tx.userData.isMatchLook = true
	if tx.userData.isMatchEnd then
		local curScene = display.getRunningScene()
		if curScene and curScene.matchEndTips then
			curScene:matchEndTips()
		end
	end
	self:hidePanel_()
end

function PopupAwards:onPlayAgainClicked_()
	tx.matchProxy:playAgainReg(self.matchLevel_)
	self:hidePanel_()
end

function PopupAwards:showPanel()
    tx.PopupManager:addPopup(self, true, true, false, true)
    return self
end

function PopupAwards:onClose()
	self:hidePanel_()
end

function PopupAwards:hidePanel_()
	tx.PopupManager:removePopup(self)
    return self
end

function PopupAwards:onCleanup()
end

return PopupAwards