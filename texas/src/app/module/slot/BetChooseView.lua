-- 下注选择

local BetChooseView = class("BetChooseView", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 530, 112
local MIN_BET = 100
local MAX_BET = 1000000
local ROOM_BET = {1, 2, 3, 5, 10}

function BetChooseView:ctor(bet, isInRoom, callback)
    self:setNodeEventEnabled(true)
    self.callback_ = callback
    self.isInRoom_ = isInRoom
    self.bet_ = bet
    self.index_ = 1

    MIN_BET = 100
    MAX_BET = self:getHallMaxBet_()

    if isInRoom then
        self:setRoomBetList_()
    end

    if self.callback_ then
        self.callback_(bet)
    end

    self:addMainUI_()

    if not isInRoom then
        self:setHallDefaultBet_()
    end
end

function BetChooseView:addMainUI_()
    local frame = display.newScale9Sprite("#slot_bet_frame.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :addTo(self)

    display.newSprite("#slot_bet_title.png")
        :pos(WIDTH/2, HEIGHT - 25)
        :addTo(frame)

    display.newSprite("#slot_bet_light.png")
        :pos(WIDTH/2, 45)
        :addTo(frame)

    self.betLabel_ = ui.newTTFLabel({text = self.bet_, size = 40, color = cc.c3b(0xff, 0xff, 0xff)})
        :pos(WIDTH/2, 45)
        :addTo(frame)

    local x, y = 57, HEIGHT/2 - 2
    self.minusBtn_ = cc.ui.UIPushButton.new({normal = "#slot_minus_bet_btn_normal.png", pressed = "#slot_minus_bet_btn_pressed.png", disabled = "#slot_minus_bet_btn_disabled.png"})
        :pos(x, y)
        :onButtonClicked(buttontHandler(self, self.onMinusClicked_))
        :onButtonPressed(function()
            tx.schedulerPool:clear(self.changeBaseId_)
            self.changeBaseId_ = tx.schedulerPool:loopCall(function()
                self:onMinusClicked_()
                return true
            end,0.1)
        end)
        :onButtonRelease(function()
            tx.schedulerPool:clear(self.changeBaseId_)
        end)
        :addTo(frame)
    self.minusBtn_:setDelayTouchEnabled(false)

    self.addBtn_ = cc.ui.UIPushButton.new({normal = "#slot_add_bet_btn_normal.png", pressed = "#slot_add_bet_btn_pressed.png", disabled = "#slot_add_bet_btn_disabled.png"})
        :pos(WIDTH - x, y)
        :onButtonClicked(buttontHandler(self, self.onAddClicked_))
        :onButtonPressed(function()
            tx.schedulerPool:clear(self.changeBaseId_)
            self.changeBaseId_ = tx.schedulerPool:loopCall(function()
                self:onAddClicked_()
                return true
            end,0.1)
        end)
        :onButtonRelease(function()
            tx.schedulerPool:clear(self.changeBaseId_)
        end)
        :addTo(frame)
    self.addBtn_:setDelayTouchEnabled(false)

    self:updateBetBtnStatus_()
end

function BetChooseView:onCleanup()
    tx.schedulerPool:clear(self.changeBaseId_)
end

function BetChooseView:onMinusClicked_()
    if self.canMinus_==false then
        self.minusBtn_:setButtonEnabled(false)
    else
        self:minusBetClicked_()
        self:updateBetInfo_()
    end
end

function BetChooseView:onAddClicked_()
    if self.canAdd_==false then
        self.addBtn_:setButtonEnabled(false)
    else
        self:addBetClicked_()
        self:updateBetInfo_()
    end
end

function BetChooseView:updateBetInfo_()
    self:updateBetLabel_()
    self:updateBetBtnStatus_()
end

function BetChooseView:updateBetBtnStatus_()
    self.canAdd_ = true
    self.canMinus_ = true
    self.minusBtn_:setButtonEnabled(true)
    self.addBtn_:setButtonEnabled(true)

    if tonumber(tx.userData.money) <= 5000 then
        tx.schedulerPool:clear(self.changeBaseId_)
        self.canAdd_ = false
        self.canMinus_ = false
        self.minusBtn_:setButtonEnabled(false)
        self.addBtn_:setButtonEnabled(false)
    elseif self.bet_ == MIN_BET then
        tx.schedulerPool:clear(self.changeBaseId_)
        self.canMinus_ = false
        self.minusBtn_:setButtonEnabled(false)
    elseif self.bet_ == MAX_BET then
        tx.schedulerPool:clear(self.changeBaseId_)
        self.canAdd_ = false
        self.addBtn_:setButtonEnabled(false)
    end
end

function BetChooseView:updateBetLabel_()
    self.betLabel_:setString(self.bet_)
    if self.callback_ then
        self.callback_(self.bet_)
    end
end

function BetChooseView:getHallMaxBet_()
    local num = math.floor(tonumber(tx.userData.money) / 20)
    local bet = math.floor(num / 100) * 100

    if bet > 1000000 then
        bet = 1000000
    end

    return bet
end

function BetChooseView:minusBetClicked_()
    if self.isInRoom_ then
        self.index_ = self.index_ - 1
        if self.index_ < 1 then
            self.index_ = 1
        end

        self.bet_ = self.betList_[self.index_]
    else
        self.bet_ = self.bet_ - 100
        tx.userDefault:setIntegerForKey("SLOT_DEFAULT_BET", self.bet_)
    end
end

function BetChooseView:addBetClicked_()
    if self.isInRoom_ then
        self.index_ = self.index_ + 1
        if self.index_ > #ROOM_BET then
            self.index_ = #ROOM_BET
        end

        self.bet_ = self.betList_[self.index_]
    else
        self.bet_ = self.bet_ + 100
        tx.userDefault:setIntegerForKey("SLOT_DEFAULT_BET", self.bet_)
    end
end

function BetChooseView:setPreBlind(preBlind)
    self.bet_ = preBlind
    self:setRoomBetList_()
    self:updateBetInfo_()
    if self.callback_ then
        self.callback_(preBlind)
    end
end

function BetChooseView:setRoomBetList_()
    self.betList_ = {}
    local len = #ROOM_BET

    MIN_BET = self.bet_
    MAX_BET = self.bet_ * ROOM_BET[len]
    for i = 1, len do
        self.betList_[i] = self.bet_ * ROOM_BET[i]
    end
end

function BetChooseView:setHallDefaultBet_()
    local bet = tx.userDefault:getIntegerForKey("SLOT_DEFAULT_BET", MIN_BET)
    if bet * 20 > tx.userData.money then
        bet = 100
    end

    self.bet_ = bet
    self:updateBetInfo_()
end

function BetChooseView:getBet()
    return self.bet_ or 0
end

return BetChooseView
