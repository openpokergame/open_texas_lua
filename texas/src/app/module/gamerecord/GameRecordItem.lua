local PokerCard = tx.ui.PokerCard
local getClientId = function(selfServerSeatId,targetServerSeatId)
    local offset = 4 - selfServerSeatId
    return (targetServerSeatId+offset+9)%9+1
end

local GameRecordDetail = class("GameRecordDetail",function ()
    return display.newNode()
end)

GameRecordDetail.ELEMENTS = {
    "labelTime",
    "nodeNameBg.bg1",
    "nodeNameBg.bg2",
    "nodeNameBg.bg3",
    "nodeNameBg.bg4",
    "nodeNameBg.bg5",
    "nodeNameBg.bg6",
    "nodeNameBg.bg7",
    "nodeNameBg.bg8",
    "nodeNameBg.bg9",
    "nodeName.labelName1",
    "nodeName.labelWin1",
    "nodeName.labelName2",
    "nodeName.labelWin2",
    "nodeName.labelName3",
    "nodeName.labelWin3",
    "nodeName.labelName4",
    "nodeName.labelWin4",
    "nodeName.labelName5",
    "nodeName.labelWin5",
    "nodeName.labelName6",
    "nodeName.labelWin6",
    "nodeName.labelName7",
    "nodeName.labelWin7",
    "nodeName.labelName8",
    "nodeName.labelWin8",
    "nodeName.labelName9",
    "nodeName.labelWin9",
    "nodeCard.card1",
    "nodeCard.card2",
    "nodeCard.card3",
    "nodeCard.card4",
    "nodeCard.card5",
    "nodeCard.card6",
    "nodeCard.card7",
    "nodeCard.card8",
    "nodeCard.card9",
    "btnPre.label",
    "btnNext.label",
    "btnShare.label",
}

function GameRecordDetail:ctor()
	self:setNodeEventEnabled(true)
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_game_record_detail.csb",true)
    self.editView:pos(0,7)
	self.btnPre.label:setString(sa.LangUtil.getText("USERINFO", "LAST_GAME"))
	self.btnNext.label:setString(sa.LangUtil.getText("USERINFO", "NEXT_GAME"))
	self.btnShare.label:setString(sa.LangUtil.getText("WINORLOSE", "SHARE"))
	ImgButton(self.btnPre,"#common/btn_small_blue.png","#common/btn_small_blue_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        if self.callBack_ then
        	self.callBack_(1)
        end
    end)
    self.btnPre:setTouchSwallowEnabled(false)
	ImgButton(self.btnNext,"#common/btn_small_blue.png","#common/btn_small_blue_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        if self.callBack_ then
        	self.callBack_(2)
        end
    end)
    self.btnNext:setTouchSwallowEnabled(false)
	ImgButton(self.btnShare,"#common/btn_small_green.png","#common/btn_small_green_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        if self.callBack_ then
        	self.callBack_(3)
        end
    end)
    self.btnShare:setTouchSwallowEnabled(false)
end

function GameRecordDetail:setDataAndCallBack(data,callBack)
	self.data_ = data
	self.callBack_ = callBack
    local info = self.data_.tableInfo or {}
    local mySeatId = info.seatid or 4
    for i=1,9,1 do
        self.nodeName["labelName"..i]:hide()
        self.nodeName["labelWin"..i]:hide()
        self.nodeNameBg["bg"..i]:hide()
        self.nodeCard["card"..i]:hide()
    end
    local time = info.time or os.time()
    self.labelTime:setString(sa.TimeUtil:getTimeSimpleString(time,"-",true))
    if not self.pubCard_1 then
        self.pubCard_1 = PokerCard.new():pos(-100, 0):addTo(self.nodeCard):scale(0.4)
        self.pubCard_2 = PokerCard.new():pos(-50, 0):addTo(self.nodeCard):scale(0.4)
        self.pubCard_3 = PokerCard.new():pos(0, 0):addTo(self.nodeCard):scale(0.4)
        self.pubCard_4 = PokerCard.new():pos(50, 0):addTo(self.nodeCard):scale(0.4)
        self.pubCard_5 = PokerCard.new():pos(100, 0):addTo(self.nodeCard):scale(0.4)
    end
    for i=1,5,1 do
        local cardValue = info["pubCard"..i]
        local cardView = self["pubCard_"..i]
        if not cardValue or cardValue==0 then
            if cardView then
                cardView:hide()
            end
        elseif cardView then
            cardView:setCard(cardValue)
            cardView:showFront()
            cardView:show()
        end
    end
    local bg = nil
    local labelName = nil
    local labelWin = nil
    local card = nil
    for k,v in pairs(data) do
        if k~="tableInfo" then
            local clientId = getClientId(mySeatId,v.seatid)
            bg = self.nodeNameBg["bg"..clientId]
            labelName = self.nodeName["labelName"..clientId]
            labelWin = self.nodeName["labelWin"..clientId]
            card = self.nodeCard["card"..clientId]
            if bg then
                bg:show()
                labelName:show()
                labelWin:show()
                card:show()
                if not card.card1_ then
                    card.card1_ = PokerCard.new():pos(-10, 0):addTo(card):scale(0.35)
                    card.card2_ = PokerCard.new():pos(10, 0):addTo(card):scale(0.35)
                    card.card3_ = PokerCard.new():pos(10, 0):addTo(card):scale(0.35)
                    card.card4_ = PokerCard.new():pos(10, 0):addTo(card):scale(0.35)
                end
                -- 奥马哈
                if v.hand4 then
                    card.card3_:show()
                    card.card4_:show()
                    card.card1_:pos(-24, 0):scale(0.35)
                    card.card2_:pos(-8, 0):scale(0.35)
                    card.card3_:pos(8, 0):scale(0.35)
                    card.card4_:pos(24, 0):scale(0.35)
                else
                    card.card3_:hide()
                    card.card4_:hide()
                    card.card1_:pos(-10, 0):scale(0.35)
                    card.card2_:pos(10, 0):scale(0.35)
                end
                if (v.pubCard5 and v.pubCard5~=0) or v.isSelf then
                    if not v.hand1 or v.hand1==0 then
                        card.card1_:showBack()
                    else
                        card.card1_:setCard(v.hand1)
                        card.card1_:showFront()
                    end
                    if not v.hand2 or v.hand2==0 then
                        card.card2_:showBack()
                    else
                        card.card2_:setCard(v.hand2)
                        card.card2_:showFront()
                    end
                    -- 奥马哈
                    if v.hand4 then
                        if not v.hand3 or v.hand3==0 then
                            card.card3_:showBack()
                        else
                            card.card3_:setCard(v.hand3)
                            card.card3_:showFront()
                        end
                        if not v.hand4 or v.hand4==0 then
                            card.card4_:showBack()
                        else
                            card.card4_:setCard(v.hand4)
                            card.card4_:showFront()
                        end
                    end
                    -- -- if v.isSelf and (not v.pubCard5 or v.pubCard5==0) and v.hh_wincoins and tonumber(v.hh_wincoins)<=0 then
                    -- --     if not card.foldLabel_ then
                    -- --         card.foldLabel_ = ui.newTTFLabel({size=20, text="", color=cc.c3b(0xff, 0x5a, 0x5a)})
                    -- --             :addTo(card)
                    -- --     end
                    -- --     card.foldLabel_:setString(sa.LangUtil.getText("ROOM","FOLD"))
                    -- --     card.foldLabel_:show()
                    -- -- elseif card.foldLabel_ then
                    -- --     card.foldLabel_:hide()
                    -- -- end
                else
                    card.card1_:showBack()
                    card.card2_:showBack()
                    card.card3_:showBack()
                    card.card4_:showBack()
                end
                if v.hh_wincoins and tonumber(v.hh_wincoins)>0 then
                    bg:setSpriteFrame(display.newSprite("#dialogs/gamerecord/win_bg.png"):getSpriteFrame())--,bg:getCapInsets())
                    labelName:setColor(cc.c3b(255,255,255))
                    labelWin:setColor(cc.c3b(0xEE, 0xE6, 0x5D))
                    card.card1_:removeDark()
                    card.card2_:removeDark()
                    card.card3_:removeDark()
                    card.card4_:removeDark()
                    labelWin:setString("+"..sa.formatNumberWithSplit(v.hh_wincoins or ""))
                else
                    bg:setSpriteFrame(display.newSprite("#dialogs/gamerecord/lose_bg.png"):getSpriteFrame())--,bg:getCapInsets())
                    labelName:setColor(cc.c3b(0x77,0x72,0xcd))
                    labelWin:setColor(cc.c3b(0x77,0x72,0xcd))
                    -- -- card.card1_:addDark()
                    -- -- card.card2_:addDark()
                    if not v.pubCard5 or v.pubCard5==0 then
                        card.card1_:addDark()
                        card.card2_:addDark()
                        card.card3_:addDark()
                        card.card4_:addDark()
                    else
                        card.card1_:removeDark()
                        card.card2_:removeDark()
                        card.card3_:removeDark()
                        card.card4_:removeDark()
                    end
                    labelWin:setString(sa.formatNumberWithSplit(v.hh_wincoins or ""))
                end
                bg:setContentSize(cc.size(104,50))
                labelName:setString(v.nick or "")
            end
        end
    end
end

----------------------------------------------分割线------------------------------------------------------
local GameRecordItem = class("GameRecordItem", sa.ui.ListItem)

local ITEM_W, ITEM_H = 950, 124
local bottomPanelMinHeight = 1
local bottomPanelMaxHeight = 418
local editOffY = 0

local card2Coord = {
    [1] = {-2, 0, 0.5, -10},
    [2] = {18, 0, 0.5, 0}
}
local card4Coord = {
    [1] = {-3.5-13, -0.35, 0.45, -20},
    [2] = {11.15-13, 1.2, 0.45, -10},
    [3] = {26.85-13, 0, 0.45, 0},
    [4] = {42.05-13, -4.25, 0.45, 10}
}

GameRecordItem.ELEMENTS = {
    "bg",
    "nodeCard",
    "labelName",
    "labelBlind",
    "labelWin",
    "bgTime.labelTime",
    "btnDetail",
}

function GameRecordItem:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.heightExtra_ = 0
	self.isFolded_ = true
	self:setNodeEventEnabled(true)
    GameRecordItem.super.ctor(self, ITEM_W, ITEM_H)
end

function GameRecordItem:dealDetail(isFast)
	if not self.recordDetail_ then
		self.recordDetail_ = GameRecordDetail.new():addTo(self.bottomPanel_)
			:pos(ITEM_W*0.5,bottomPanelMaxHeight*0.5)
	end
    if self.recordDetail_ and self.isFolded_ then
        self.recordDetail_:setDataAndCallBack(self.data_,function(type)
            local index = self:getIndex()
            local list = self:getOwner()
            local item = nil
            if type==1 then
                if not index or index<=1 then 
                    -- 提示
                    return;
                end
                self:dealDetail(true)
                local item = list:getListItem(index-1)
                if item then
                    item:lazyCreateContent()
                    item.isFolded_ = true
                    item.heightExtra_ = 0
                    item:dealDetail()
                end
            elseif type==2 then
                local allData = list:getData()
                if not index or index>=#allData then 
                    -- 提示
                    return;
                end
                self:dealDetail(true)
                local item = list:getListItem(index+1)
                if item then
                    item:lazyCreateContent()
                    item.isFolded_ = true
                    item.heightExtra_ = 0
                    item:dealDetail()
                end
            elseif type==3 then
                local feedData = clone(sa.LangUtil.getText("FEED", "INVITE_FRIEND"))
                tx.ShareSDK:shareFeed(feedData, function(success, result)
                    if success then
                        --
                    else
                        --
                    end
                end)
            end
        end)
    end
	self:foldContent(isFast)
end

function GameRecordItem:foldContent(isFast)
	if self.isFolded_ then
        self.isFolded_ = false
        self.btnDetail:rotation(0)
        if isFast then
        	self.heightExtra_ = bottomPanelMaxHeight
        end
    else
        self.isFolded_ = true
        self.btnDetail:rotation(-90)
        if isFast then
        	self.heightExtra_ = 1
        end
    end
    self:unscheduleUpdate()
    self:scheduleUpdate()
end

function GameRecordItem:lazyCreateContent()
	if not self.created_ then
        self.dataChanged_ = true
		self.created_ = true

		tx.ui.EditPanel.bindElementsToTarget(self,"dialog_game_record_item.csb",true)
    	self.editView:pos(ITEM_W*0.5,ITEM_H*0.5+editOffY)
    	self.card1_ = PokerCard.new():pos(-2, 0):addTo(self.nodeCard):scale(0.5)
		self.card1_:setRotation(-10)
    	self.card2_ = PokerCard.new():pos(18, 0):addTo(self.nodeCard):scale(0.5)
        self.card3_ = PokerCard.new():pos(-2, 0):addTo(self.nodeCard):scale(0.5)
        self.card3_:setRotation(-10)
        self.card4_ = PokerCard.new():pos(18, 0):addTo(self.nodeCard):scale(0.5)

    	-- 底部详细信息
    	self.bottomPanel_ = cc.ClippingNode:create()
	        :pos(0, -bottomPanelMinHeight*0.5)
	        :addTo(self)

		self.stencil_ = display.newRect(ITEM_W, bottomPanelMinHeight, {fill=true, fillColor=cc.c4f(0, 0, 0, 1)})
        	:align(display.BOTTOM_LEFT, 0, 0)--设置模板位置，也就是裁剪显示的内容
    	self.bottomPanel_:setStencil(self.stencil_)
    	-- 伸缩
    	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame_))
        -- 按钮
        ColorButton(self.bg,cc.c3b(200,200,200)):onButtonClicked(function()
            tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
            self:dealDetail()
        end)
        self.bg:setTouchSwallowEnabled(false)
    end
    if self.data_ and self.dataChanged_ then
        self.dataChanged_ = false
    	local info = self.data_.tableInfo or {}
    	self.labelName:setString(sa.LangUtil.getText("USERINFO","PLAY_TOTOAL_COUNT")..(info.id or ""))
    	local blind = info.blind or 50
		self.labelBlind:setString(sa.LangUtil.getText("COMMON","BLIND_BIG_SMALL",sa.formatBigNumber(blind),sa.formatBigNumber(blind*2)))
		-- 输赢情况
		local result = info.result or 0
    	if result==0 then
    		self.labelWin:setColor(cc.c3b(0xff, 0xff, 0xff))
            self.labelWin:setString(result)
    	elseif result>0 then
    		self.labelWin:setColor(cc.c3b(0xf6, 0xe6, 0x60))
            self.labelWin:setString("+"..result)
    	else
    		self.labelWin:setColor(cc.c3b(0x30, 0xff, 0x68))
            self.labelWin:setString(result)
    	end
    	local time = info.time or os.time()
    	self.bgTime.labelTime:setString(sa.TimeUtil:getTimeSimpleString(time,"-"))
        local card1 = info.hand1 or 0
        local card2 = info.hand2 or 0
        local card3 = info.hand3
        local card4 = info.hand4
        if card1==0 then
            self.card1_:showBack()
        else
            self.card1_:setCard(card1)
            self.card1_:showFront()
        end
        if card2==0 then
            self.card2_:showBack()
        else
            self.card2_:setCard(card2)
            self.card2_:showFront()
        end
        -- 奥马哈
        -- local card2Coord
        -- local card4Coord
        local temp = nil
        if card3 and card4 then
            self.card3_:show()
            self.card4_:show()
            if card3==0 then
                self.card3_:showBack()
            else
                self.card3_:setCard(card3)
                self.card3_:showFront()
            end
            if card4==0 then
                self.card4_:showBack()
            else
                self.card4_:setCard(card4)
                self.card4_:showFront()
            end
            temp = card4Coord[1]
            self.card1_:pos(temp[1],temp[2]):scale(temp[3]):setRotation(temp[4])
            temp = card4Coord[2]
            self.card2_:pos(temp[1],temp[2]):scale(temp[3]):setRotation(temp[4])
            temp = card4Coord[3]
            self.card3_:pos(temp[1],temp[2]):scale(temp[3]):setRotation(temp[4])
            temp = card4Coord[4]
            self.card4_:pos(temp[1],temp[2]):scale(temp[3]):setRotation(temp[4])
        else
            self.card3_:hide()
            self.card4_:hide()
            temp = card2Coord[1]
            self.card1_:pos(temp[1],temp[2]):scale(temp[3]):setRotation(temp[4])
            temp = card2Coord[2]
            self.card2_:pos(temp[1],temp[2]):scale(temp[3]):setRotation(temp[4])
        end
        if self.recordDetail_ then
            -- self.recordDetail_:setDataAndCallBack(self.data_,self.recordDetail_.callBack_)
            self:foldContent(true)
        end
    end
end

function GameRecordItem:onEnterFrame_()
	local bottomHeight = bottomPanelMaxHeight
    local dest, direction
    if self.isFolded_ then
        dest = 0
        direction = -1
    else
        dest = bottomHeight
        direction = 1
    end
    if self.heightExtra_ == dest then
        if dest == 0 then
            if self.recordDetail_ then
                self.recordDetail_:removeFromParent()
                self.recordDetail_ = nil
            end
        end
        self:unscheduleUpdate()
    else
        self.heightExtra_ = self.heightExtra_ + direction * math.max(1, math.abs(self.heightExtra_ - dest) * 0.4)
        if direction > 0 and self.heightExtra_ > dest or direction < 0 and self.heightExtra_ < dest then
            self.heightExtra_ = dest
        end
    end

    local contentHeight = ITEM_H + self.heightExtra_
    self.stencil_:setScaleY(self.heightExtra_)
    self:setContentSize(cc.size(ITEM_W, contentHeight))
    self.editView:setPositionY(contentHeight-ITEM_H*0.5+editOffY)
    if self.recordDetail_ then
    	self.recordDetail_:setPositionY(self.heightExtra_*0.5)
    end
    self:dispatchEvent({name="RESIZE"})
    -- 顶到最上面
    -- if self.isFolded_==false then
    	local list = self:getOwner()
    	local tempWorldPt = list.content_:convertToWorldSpace(cc.p(self:getPosition()))
    	local offY = list.viewRectOriginPoint_.y - tempWorldPt.y
    	-- list:scrollTo(offY-3)
		list:scrollTo(offY-3 + (bottomPanelMaxHeight - self.heightExtra_)*0.5)
    -- end
end

function GameRecordItem:onDataSet(dataChanged, data)
	self.dataChanged_ = dataChanged
    self.data_ = data
end
 
return GameRecordItem