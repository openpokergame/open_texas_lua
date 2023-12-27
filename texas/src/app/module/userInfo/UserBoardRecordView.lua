-- 用户牌局记录

local UserBoardRecordView = class("UserBoardRecordView", function()
	return display.newNode()
end)

local WIDTH, HEIGHT = 964, 250
local TEXT_COLOR = styles.FONT_COLOR.CONTENT_TEXT

function UserBoardRecordView:ctor(data, delegate)
	local bg = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(WIDTH, HEIGHT))
		:addTo(self)

	self.bg_ = bg
	self.selected_ = 1
	self.delegate_ = delegate

	local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/pop_tab_normal_2.png", 
            indicator = "#common/pop_tab_selected_2.png"
        }, 
        sa.LangUtil.getText("USERINFO", "BOARD_RECORD_TAB_TEXT"),
        {
            selectedText = {color = cc.c3b(0xff, 0xff, 0xff), size = 22},
            defaltText = {color = TEXT_COLOR, size = 22}
        }, true, true)
	    :setTabBarSize(580, 52, 0, -4)
	    :onTabChange(handler(self, self.onTabChanged_))
	    :pos(WIDTH/2, HEIGHT - 38)
	    :addTo(bg)

	self:addOrdinaryBoardInfo_(data)
	self:addSNGMatchInfo_(data.sngInfo or {})
	self:addMTTInfo_(data)

	tab:gotoTab(self.selected_, true)
end

function UserBoardRecordView:onTabChanged_(selectedTab)
	if selectedTab == 1 then
		self.ordinaryBoardInfo_:show()
		self.sngMatchInfoNode_:hide()
		self.mttMatchInfoNode_:hide()
	elseif selectedTab == 2 then
		self.ordinaryBoardInfo_:hide()
		self.sngMatchInfoNode_:show()
		self.mttMatchInfoNode_:hide()
	elseif selectedTab == 3 then
		self.ordinaryBoardInfo_:hide()
		self.sngMatchInfoNode_:hide()
		self.mttMatchInfoNode_:show()
	end
end

--普通玩牌
function UserBoardRecordView:addOrdinaryBoardInfo_(data)
	local node = display.newNode()
		:size(WIDTH, 170)
		:align(display.BOTTOM_CENTER, WIDTH/2, 0)
		:addTo(self.bg_)

	self.ordinaryBoardInfo_ = node

	local totalPoker = data.totalPoker
	local recordData = {
		boardNum = totalPoker, --牌局数
		winRate = sa.transformToPercent(data.winTimes, totalPoker), --胜率
		vpip = sa.transformToPercent(data.ruju, totalPoker), --入局率
		wtsd = sa.transformToPercent(data.tanpai, totalPoker) --摊牌率
	}
	local key = {"boardNum", "winRate", "vpip", "wtsd"}

	local title = {
		sa.LangUtil.getText("USERINFO", "PLAY_TOTOAL_COUNT"),
		sa.LangUtil.getText("USERINFO", "WIN_TOTAL_RATE"),
		sa.LangUtil.getText("USERINFO", "PLAY_START_RATE"),
		sa.LangUtil.getText("USERINFO", "SHOW_CARD_RATE")
	}

	local posX = {40, 40, 355, 355}
	local posY = {140, 60, 140, 60}
	for i = 1, 4 do
		local label = ui.newTTFLabel({text= title[i], size = 24, color = TEXT_COLOR})
	        :align(display.LEFT_CENTER, posX[i], posY[i])
	        :addTo(node)

	    local size = label:getContentSize()
		ui.newTTFLabel({text= recordData[key[i]], size = 24})
	        :align(display.LEFT_CENTER, posX[i] + size.width, posY[i])
	        :addTo(node)
	end

    local PokerCard = tx.ui.PokerCard
    local cards= {}
    local x, y = WIDTH - 340, 78
    local dir = 60
    local cardUint = {}
    if data.bestcard ~= "0" and data.bestcard ~= 0 then
    	for i = 1, 5 do
    		cardUint[i] = tonumber(string.sub(data.bestcard, (i + 1) * 2, (i + 1) * 2 + 1))
    	end
    end

    for i = 1, 5 do
    	cards[i] = PokerCard.new()
    		:showBack()
    		:scale(0.48)
	    	:pos(x + (i - 1) * dir, y)
	    	:addTo(node)
    end

    if cardUint and #cardUint>0 then
    	for i = 1, 5 do
	    	cards[i]:showFront():setCard(cardUint[i])
	    end
    end

    local x, y = WIDTH - 370, 140
    local label = ui.newTTFLabel({text= sa.LangUtil.getText("USERINFO", "MAX_CARD_TYPE"), size = 24, color = TEXT_COLOR})
        :align(display.LEFT_CENTER, x, y)
        :addTo(node)
    sa.fitSprteWidth(label, 130)

    local title = ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "BOARD"), size = 22, align = ui.TEXT_ALIGN_CENTER})
    sa.fitSprteWidth(title, 110)
    local btn = cc.ui.UIPushButton.new({normal = "#common/userinfo_board_normal.png", pressed = "#common/userinfo_board_pressed.png"}, {scale9 = true})
        :setButtonSize(170, 48)
        :onButtonClicked(buttontHandler(self, self.onBoardClicked_))
        :setButtonLabel(title)
        :setButtonLabelOffset(25, 0)
        :pos(x + 220, y)
        :addTo(node)

    display.newSprite("#common/userinfo_board_icon.png")
        :pos(-58, 2)
        :addTo(btn)
end

--坐满即玩比赛场
function UserBoardRecordView:addSNGMatchInfo_(data)
	local node = display.newNode()
		:size(WIDTH, 170)
		:align(display.BOTTOM_CENTER, WIDTH/2, 0)
		:addTo(self.bg_)

	self.sngMatchInfoNode_ = node

	self:addJoinMatchInfo_(node, sa.LangUtil.getText("USERINFO", "JOIN_MATCH_NUM"), data.matchNum or 0, 167, 107)
	self:addJoinMatchInfo_(node, sa.LangUtil.getText("USERINFO", "GET_REWARD_NUM"), data.rewardNum or 0, WIDTH/2 - 12, 107)

	local x, y = WIDTH - 193, 107
    local cup_x, cup_y = WIDTH - 185, 125
    local cupInfo = {0, 0, 0} --做兼容，开发比赛的时候就不需要了
    cupInfo = data.cupInfo or cupInfo
    self:addCupInfo_("#common/userinfo_cup_2.png", cupInfo[2], 20, cup_x - 95, cup_y - 12)
    self:addCupInfo_("#common/userinfo_cup_1.png", cupInfo[1], 22, cup_x, cup_y)
    self:addCupInfo_("#common/userinfo_cup_3.png", cupInfo[3], 20, cup_x + 95, cup_y - 12)

    ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "MY_CUP"), size = 24})
        :pos(cup_x, y - 80)
        :addTo(node)
end

function UserBoardRecordView:addCupInfo_(img, num, fontSize, x, y)
	local icon = display.newSprite(img)
        :pos(x, y)
        :addTo(self.sngMatchInfoNode_)

    ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "MY_PROPS_TIMES", num), size = fontSize, color = cc.c3b(0xff, 0xff, 0x0)})
        :pos(x, y - 60)
        :addTo(self.sngMatchInfoNode_)
end

--锦标赛（定时）
function UserBoardRecordView:addMTTInfo_(data)
	local node = display.newNode()
		:size(WIDTH, 170)
		:align(display.BOTTOM_CENTER, WIDTH/2, 0)
		:addTo(self.bg_)

	self.mttMatchInfoNode_ = node

	self:addJoinMatchInfo_(node, sa.LangUtil.getText("USERINFO", "JOIN_MATCH_NUM"), 0, 167, 107)
	self:addJoinMatchInfo_(node, sa.LangUtil.getText("USERINFO", "GET_REWARD_NUM"), 0, WIDTH/2 - 12, 107)

	local x, y = WIDTH - 193, 107
    ui.newTTFLabel({text = 0, size = 80, color = cc.c3b(0xff, 0xe3, 0x62)})
        :pos(x, y)
        :addTo(node)

    ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "MATCH_BEST_SCORE"), size = 24})
        :pos(x, y - 80)
        :addTo(node)
end

function UserBoardRecordView:addJoinMatchInfo_(parent, title, num, x ,y)
    ui.newTTFLabel({text = num, size = 80})
        :pos(x, y)
        :addTo(parent)

    ui.newTTFLabel({text = title, size = 24})
        :pos(x, y - 80)
        :addTo(parent)
end

function UserBoardRecordView:updateOrdinaryBoardInfo_()
	-- body
end

function UserBoardRecordView:updateSNGMatchInfo_()
	-- body
end

function UserBoardRecordView:updateMTTInfo_()
	-- body
end

function UserBoardRecordView:onBoardClicked_()
    self.delegate_:openBoardPopup()
end

return UserBoardRecordView
