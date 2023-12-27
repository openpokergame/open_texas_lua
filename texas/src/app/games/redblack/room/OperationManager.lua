-- 底部操作按钮，个人信息

local OperationManager = class("OperationManager")
local RoomViewPosition = import(".views.RoomViewPosition")
local ChatMsgPanel = import("app.module.room.chat.ChatMsgPanel")
local UserInfoPopup = import("app.module.userInfo.UserInfoPopup")
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local BetChipItem = import(".views.BetChipItem")

local BET_MUL = {1, 4, 10, 20, 40, 100, 200, 400, 1000, 2000, 4000}
local BET_IMG = {
    "redblack/room/redblack_bet_chip_1.png",
    "redblack/room/redblack_bet_chip_2.png",
    "redblack/room/redblack_bet_chip_3.png",
    "redblack/room/redblack_bet_chip_4.png",
    "redblack/room/redblack_bet_chip_5.png",
    "redblack/room/redblack_bet_chip_6.png",
    "redblack/room/redblack_bet_chip_7.png",
    "redblack/room/redblack_bet_chip_8.png",
    "redblack/room/redblack_bet_chip_9.png",
    "redblack/room/redblack_bet_chip_10.png",
    "redblack/room/redblack_bet_chip_11.png",
}
local BET_ARROW = {
    "#redblack/room/redblack_bet_arrow_normal.png",
    "#redblack/room/redblack_bet_arrow_pressed.png",
    "#redblack/room/redblack_bet_arrow_disabled.png",
}
local BET_W, BET_H = display.width - 660, 130
local BET_NUM = #BET_IMG
local POSY = 65

function OperationManager:ctor()
    self.seatChips_ = 0
    self.isBetLast_ = false
    self.isBetDoubleMax_ = false
    self.leftIndex_ = 1
    self.rightIndex_ = 4
    self:initBetChip_(5000)
end

function OperationManager:initBetChip_(basechips)
    self.betchips_ = {}
    self.betchip_ = basechips
    for i,v in ipairs(BET_MUL) do
        self.betchips_[i] = basechips*v
    end
end

function OperationManager:createNodes()
    local node = self.scene.nodes.oprNode
    cc.ui.UIPushButton.new({normal = "#commonroom/chat.png" ,pressed = "#commonroom/chat_down.png"})
        :onButtonClicked(buttontHandler(self, self.onChatClicked_))
        :pos(65, POSY + 130)
        :addTo(node)

    self:addUserInfoNode_()

    self:addBetNode_()

    local btn_w, btn_h = 180, 104
    local btn_x, btn_y = display.width - 94, POSY - 5
    self.betLastBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK","BET_LAST"), size = 24}))
        :pos(btn_x, btn_y)
        :onButtonClicked(buttontHandler(self, self.onBetLastClicked_))
        :addTo(node, 2)
        :setButtonEnabled(false)

    self.betDoubleBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("REDBLACK","BET_DOUBLE"), size = 24}))
        :pos(btn_x - 192, btn_y)
        :onButtonClicked(buttontHandler(self, self.onBetDoubleClicked_))
        :addTo(node, 2)
        :setButtonEnabled(false)
end

--添加用户信息结点
function OperationManager:addUserInfoNode_()
    self.userNode_ = display.newNode():pos(65, POSY):addTo(self.scene.nodes.oprNode)
    self.avatar_ = SimpleAvatar.new({
            shapeImg = "#redblack/room/redblack_head_bg.png",
            frameImg = "#redblack/room/redblack_self_head_frame.png",
        })
        :setDefaultAvatar(tx.userData.sex)
        :addTo(self.userNode_, 1)
    NormalButton(self.avatar_):onButtonClicked(buttontHandler(self, self.onUserInfoClicked_))

    local sexIcon = "#common/common_sex_male.png"
    if tx.userData.sex == "f" then
        sexIcon = "#common/common_sex_female.png"
    end

    local x, y = 55, 22
    self.nick_ = self:createPropertyLabel_(sexIcon, tx.Native:getFixedWidthText("", 24, tx.userData.nick, 110), x, y)
    self.money_ = self:createPropertyLabel_("#common/common_chip_icon.png", sa.formatNumberWithSplit(tx.userData.money), x, -y, styles.FONT_COLOR.CHIP_TEXT)

    self.avatarUrlObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "s_picture", handler(self, function (obj, s_picture)
        if tx.userData.sex == "f" then
            self.avatar_:setSpriteFrame("common/icon_female.png")
        else
            self.avatar_:setSpriteFrame("common/icon_male.png")
        end
        if s_picture and string.len(s_picture) > 5 then
            local imgurl = s_picture
            if string.find(imgurl, "facebook") then
                if string.find(imgurl, "?") then
                    imgurl = imgurl .. "&width=200&height=200"
                else
                    imgurl = imgurl .. "?width=200&height=200"
                end
            end
            self.avatar_:loadImage(imgurl)
        end
    end))
    self.nickObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "nick", handler(self, self.updateNick))

    self.moneyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", handler(self, self.updateCurMoney))
end

function OperationManager:createPropertyLabel_(icon, str, x, y, textColor)
    local w, h = 158, 36
    local frame = display.newScale9Sprite("#redblack/room/redblack_money_frame.png", 0, 0, cc.size(w, h))
        :align(display.LEFT_CENTER, x, y)
        :addTo(self.userNode_)

    display.newSprite(icon)
        :pos(20, h*0.5)
        :scale(0.7)
        :addTo(frame)

    local label = ui.newTTFLabel({text = str, color = textColor, size = 18})
        :align(display.LEFT_CENTER, 40, h*0.5)
        :addTo(frame)

    return label
end

function OperationManager:addBetNode_()
    local betNode = display.newNode()
        :size(BET_W, BET_H)
        :align(display.CENTER, display.cx - 40, POSY)
        :addTo(self.scene.nodes.oprNode)

    local cx, cy = BET_W*0.5, BET_H*0.5
    local btn_x, btn_y = 30, cy
    local btn_x = {30, BET_W - btn_x}
    local s = {1, -1}
    self.arrowBtn_ = {}
    for i = 1, 2 do
        local btn = cc.ui.UIPushButton.new({normal = BET_ARROW[1], pressed = BET_ARROW[2], disabled = BET_ARROW[3]})
            :onButtonClicked(buttontHandler(self, self.onBetArrowClicked_))
            :scale(s[i])
            :pos(btn_x[i], btn_y)
            :addTo(betNode)
        btn:setTag(i)
        self.arrowBtn_[i] = btn
    end

    local list_w, list_h = BET_W - 130, BET_H
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h),
            direction = sa.ui.ScrollView.DIRECTION_HORIZONTAL,
        }, 
        BetChipItem
    )
    :hideScrollBar()
    :pos(cx, cy)
    :addTo(betNode)

    self.list_:setData(BET_IMG)

    self.scrollBeginListenerId_ = self.list_:addEventListener(sa.ui.ScrollView.EVENT_SCROLL_BEGIN, handler(self, self.onListScrollBegin_))
    self.scrollEndListenerId_ = self.list_:addEventListener(sa.ui.ScrollView.EVENT_SCROLL_END, handler(self, self.onListScrollEnd_))

    local items = self.list_:getListItems()
    local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    for i, v in ipairs(items) do
        tabGroup:addButton(v:getCheckBoxButton())
    end

    tabGroup:onButtonSelectChanged(handler(self, self.onMainTabChange_))
    tabGroup:getButtonAtIndex(1):setButtonSelected(true)

    self.betGroup_ = tabGroup

    self:updateArrowButtonStatus_(true)
end

function OperationManager:onMainTabChange_(evt)
    local selected = evt.selected
    self.betchip_ = self.betchips_[selected]
end

function OperationManager:updateNick(nick)
    self.nick_:setString(tx.Native:getFixedWidthText("", 24, nick or "", 110))
end

--更新当前的筹码数
function OperationManager:updateCurMoney(money)
    local betMoney = self.ctx.model:getTotalBetChips()
    if self.seatChips_ ~= money then
        money = money - betMoney --同步数据，当打开个人信息的时候，php会返回结算前的数值
        self.money_:setString(sa.formatNumberWithSplit(money))
        self.seatChips_ = money
        tx.userData.lastGameOverMoney = nil
    end
end

function OperationManager:processBetSuccess(betChips)
    self.seatChips_ = self.seatChips_ - betChips
    self.money_:setString(sa.formatNumberWithSplit(self.seatChips_))
end

function OperationManager:updateBetButtonState()
    local isBetDouble = self:isBetDoubleEnabled()
    self.betDoubleBtn_:setButtonEnabled(isBetDouble)

    local isLastBet = self:isLastBetEnabled()
    self.betLastBtn_:setButtonEnabled(isLastBet)
end

function OperationManager:isBetDoubleEnabled()
    local model = self.model
    if self.seatChips_<= 0 or #model.betList == 0 or model:getTotalBetChips() > self.seatChips_ or self.isBetDoubleMax_ then
        return false
    end

    return true
end

function OperationManager:isLastBetEnabled()
    local model = self.model
    if self.seatChips_<= 0 or #model.lastBetList == 0 or model:getLastBetChips() > self.seatChips_ or self.isBetLast_ then
        return false
    end

    return true
end

function OperationManager:stopBetButton()
    self.betDoubleBtn_:setButtonEnabled(false)
    self.betLastBtn_:setButtonEnabled(false)
end

function OperationManager:getCurMoney()
    return self.seatChips_ or 0
end

function OperationManager:requestBet(betType, betChips)
    betChips = betChips or self.betchip_
    local model = self.model
    local ctx = self.ctx
    if self.seatChips_ < betChips then
        if betChips ~= self.betchip_ then
            tx.TopTipManager:showToast(sa.LangUtil.getText("REDBLACK","BET_FAILD"))
        else
            local index = 0
            for i, v in ipairs(self.betchips_) do
                if self.seatChips_ >= v then
                    index = i
                end
            end

            if index == 0 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON","NOT_ENOUGH_MONEY"))
                ctx.scene:openStore()
            else
                self.betGroup_:getButtonAtIndex(index):setButtonSelected(true)

                tx.TopTipManager:showToast(sa.LangUtil.getText("REDBLACK","BET_FAILD_2", betChips, self.betchips_[index]))
            end
        end
        
        return
    end

    if self:isBetMaxTipsNum_(betChips) then
        return
    end
    
    ctx.chipManager:betChipSelf(betType, betChips, function()
        ctx.betTypeManager:updateMyChips(betType, betChips)
    end)
    
    local data = {
        betType = betType,
        betChips = betChips
    }
    model:processSelfBetSuccess(data)
    self:processBetSuccess(betChips)
    self:updateBetButtonState()

    tx.socket.HallSocket:sendGameCmd("sendBet", betType, betChips)
end

function OperationManager:isBetMaxTipsNum_(betChips)
    local model = self.model
    if model:isMaxBetNum(betChips) then
        tx.TopTipManager:showToast(sa.LangUtil.getText("REDBLACK","BET_LIMIT_TIPS", model:getMaxBetNum()))
        return true
    end

    return false
end

function OperationManager:betDoubleOrLast(isLast)
    local model = self.model
    local betList = {}
    local betChips = 0
    if not isLast and model.betList then
        betChips = model:getTotalBetChips()
        betList = clone(model.betList)
    elseif isLast and model.lastBetList then
        betChips = model:getLastBetChips()
        betList = clone(model.lastBetList)
        self.isBetLast_ = true
    end

    if self:isBetMaxTipsNum_(betChips) then
        if not isLast then
            self.isBetDoubleMax_ = true
        end
    else
        for _, v in ipairs(betList) do
            self:requestBet(v.betType, v.betChips)
        end
    end

    self:updateBetButtonState()
end

function OperationManager:getBetChip()
    return self.betchip_
end

function OperationManager:onChatClicked_()
    ChatMsgPanel.new(self.ctx):showPanel()
end

function OperationManager:onUserInfoClicked_()
    UserInfoPopup.new({},true):show(false)
end

function OperationManager:onBetDoubleClicked_()
    self:betDoubleOrLast(false)
end

function OperationManager:onBetLastClicked_()
    self:betDoubleOrLast(true)
end

function OperationManager:playBetAvatarAnimation()
    local btn = self.avatar_
    btn:stopAllActions()
    btn:scale(1)

    local t = 0.1
    transition.scaleTo(btn, {scale = 0.9, time=t, onComplete=function()
        transition.scaleTo(btn, {scale = 1.1, time=t, onComplete=function()
            transition.scaleTo(btn, {scale = 1, time=t})
        end})
    end})
end

function OperationManager:onBetArrowClicked_(evt)
    local tag = evt.target:getTag()
    local index = 1
    local dir = 1
    local leftIndex = self:getLeftButtonIndex_()
    local rightIndex = self:getRightButtonIndex_()
    if tag == 1 then
        dir = 1
        self.leftIndex_ = self:updateIndex_(leftIndex, -1)
        self.rightIndex_ = self:updateIndex_(rightIndex, -1)
        index = self.leftIndex_
    else
        dir = 2
        self.leftIndex_ = self:updateIndex_(leftIndex, 1)
        self.rightIndex_ = self:updateIndex_(rightIndex, 1)
        index = self.rightIndex_
    end

    self:updateArrowButtonStatus_(false)
    self.list_:moveItemByIndex(index, dir)
end

--获取左边第一个显示的按钮
function OperationManager:getLeftButtonIndex_()
    local index = 1
    for i = 1, BET_NUM do
        if self.list_:checkItemInViewByIndex(i) then
            index = i
            break
        end
    end

    return index
end

--获取右边第一个显示的按钮
function OperationManager:getRightButtonIndex_()
    local index = BET_NUM
    for i = BET_NUM, 1, -1 do
        if self.list_:checkItemInViewByIndex(i) then
            index = i
            break
        end
    end

    return index
end

function OperationManager:updateIndex_(index, dif)
    index = index + dif
    if index > BET_NUM then
        index = BET_NUM
    end

    if index < 1 then
        index = 1
    end

    return index
end

function OperationManager:disabledArrowButton_()
    for _,v in ipairs(self.arrowBtn_) do
        v:setButtonEnabled(false)
    end
end

function OperationManager:updateArrowButtonStatus_(isFind)
    if isFind then
        self.leftIndex_ = self:getLeftButtonIndex_()
        self.rightIndex_ = self:getRightButtonIndex_()
    end

    if self.leftIndex_ == 1 then
        self.arrowBtn_[1]:setButtonEnabled(false)
    else
        self.arrowBtn_[1]:setButtonEnabled(true)
    end

    if self.rightIndex_ == BET_NUM then
        self.arrowBtn_[2]:setButtonEnabled(false)
    else
        self.arrowBtn_[2]:setButtonEnabled(true)
    end
end

function OperationManager:onListScrollBegin_(evt)
    self:disabledArrowButton_()
end

function OperationManager:onListScrollEnd_(evt)
    self:updateArrowButtonStatus_(true)
end

function OperationManager:reset()
    self.isBetLast_ = false
    self.isBetDoubleMax_ = false
    self:stopBetButton()
end

function OperationManager:dispose()
    self.list_:removeEventListener(self.scrollBeginListenerId_)
    self.list_:removeEventListener(self.scrollEndListenerId_)

    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "nick", self.nickObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyObserverHandle_)
    sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "s_picture", self.avatarUrlObserverHandle_)
end

return OperationManager