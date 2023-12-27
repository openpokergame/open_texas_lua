local BuyInPopup = class("BuyInPopup", tx.ui.Panel)

local WIDTH , HEIGHT= 1020, 660

BuyInPopup.ELEMENTS = {
    "btnBuy",
    "btnBuy.labelBtnBuy",

    "btnAutoIn",
    "btnAutoIn.labelAutoIn",
    "btnAutoIn.clickArea",
    "btnAutoIn1",
    "btnAutoIn1.labelAutoIn",
    "btnAutoIn1.clickArea",

    "mainNode.nodeBuy.labelBuy",

    "mainNode.labelBlind",

    "mainNode.nodeSub.btnSub",
    "mainNode.nodeSub.labelSubWord",
    "mainNode.nodeSub.labelSubValue",
    "mainNode.nodeAdd.btnAdd",
    "mainNode.nodeAdd.labelAddWord",
    "mainNode.nodeAdd.labelAddValue",

    "mainNode.nodeSelf.word",
    "mainNode.nodeSelf.value",
    "mainNode.nodeSelf.icon",

    "mainNode.nodeSlider",
    "mainNode.nodeSlider.bg",
    "mainNode.nodeSlider.bar",
    "mainNode.nodeSlider.barBtn",
}

function BuyInPopup:initViews_()
    tx.ui.EditPanel.bindElementsToTarget(self,"dialog_buyin.csb",true)
    if self.param_ and self.param_.type==1 then
        -- self.btnBuy.labelBtnBuy:setString(sa.LangUtil.getText("ROOM", "ADD_IN_BTN_LABEL"))
        -- self.btnAutoIn:hide()
        -- self.btnAutoIn1:hide()
        -- local yy = self.btnBuy:getPositionY()
        -- self.btnBuy:setPositionY(yy+30)
        self.btnBuy.labelBtnBuy:setString(sa.LangUtil.getText("ROOM", "ADD_IN_BTN_LABEL"))
    else
        self.btnBuy.labelBtnBuy:setString(sa.LangUtil.getText("ROOM", "BUY_IN_BTN_LABEL"))
    end
    self.mainNode.labelBlind:setString(sa.LangUtil.getText("COMMON", "BLIND_BIG_SMALL", self.blind_,self.blind_*2))
    self.mainNode.nodeSelf.word:setString(sa.LangUtil.getText("ROOM", "BUY_IN_BALANCE_TITLE"))
    self.btnAutoIn.labelAutoIn:setString(sa.LangUtil.getText("ROOM", "BUY_IN_AUTO"))
    self.btnAutoIn1.labelAutoIn:setString(sa.LangUtil.getText("ROOM", "BUY_IN_AUTO_MIN"))
    self.mainNode.nodeSub.labelSubWord:setString(sa.LangUtil.getText("ROOM", "BUY_IN_MIN"))
    if self.min_>1000000 then
        self.mainNode.nodeSub.labelSubValue:setString(sa.formatBigNumber(self.min_))
    else
        self.mainNode.nodeSub.labelSubValue:setString(sa.formatNumberWithSplit(self.min_))
    end

    self.mainNode.nodeAdd.labelAddWord:setString(sa.LangUtil.getText("ROOM", "BUY_IN_MAX"))
    if self.max_>1000000 then
        self.mainNode.nodeAdd.labelAddValue:setString(sa.formatBigNumber(self.max_))
    else
        self.mainNode.nodeAdd.labelAddValue:setString(sa.formatNumberWithSplit(self.max_))
    end

    self.moneyChangeObserverId_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "money", handler(self, self.onMoneyChanged_))
    ImgButton(self.btnBuy,"#common/btn_big_green.png","#common/btn_big_green_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        self.param_.callback(self.curValue_, self.isAutoBuyin_)
        self:hidePanel()
    end)

    ImgButton(self.mainNode.nodeSub.btnSub,"#dialogs/buyin/buy_pop_sub.png","#dialogs/buyin/buy_pop_sub_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        self.curValue_ = self.curValue_ - self.step_
        if self.curValue_ < self.min_ then
            self.curValue_ = self.min_
        elseif self.curValue_ > self.max_ then
            self.curValue_ = self.max_
        end
        self:onSliderPercentValueChanged_(math.min(self.myMoneyPercent_, (self.curValue_ - self.min_) / self.range_), false, false)
    end)

    ImgButton(self.mainNode.nodeAdd.btnAdd,"#dialogs/buyin/buy_pop_add.png","#dialogs/buyin/buy_pop_add_down.png"):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        self.curValue_ = self.curValue_ + self.step_
        if self.curValue_ < self.min_ then
            self.curValue_ = self.min_
        elseif self.curValue_ > self.max_ then
            self.curValue_ = self.max_
        end
        self:onSliderPercentValueChanged_(math.min(self.myMoneyPercent_, (self.curValue_ - self.min_) / self.range_), false, false)
    end)

    ColorButton(self.btnAutoIn,cc.c3b(170,170,170)):onButtonClicked(function()
        self:dealAutoInData(1)
        self:dealAutoIn()
    end)

    ColorButton(self.btnAutoIn1,cc.c3b(170,170,170)):onButtonClicked(function()
        self:dealAutoInData(2)
        self:dealAutoIn()
    end)

    -- 布局
    local size = self.btnAutoIn.labelAutoIn:getContentSize()
    local size1 = self.btnAutoIn1.labelAutoIn:getContentSize()
    size.width = size.width + 50
    size1.width = size1.width + 50
    local t1,t2 = 0,0
    if size.width>WIDTH*0.5 then
        t1 = size.width - WIDTH*0.5
    end
    if size1.width>WIDTH*0.5 then
        t2 = size1.width - WIDTH*0.5
    end

    if t1==0 and t2==0 then
        self.btnAutoIn:setPositionX(-WIDTH*0.25 - size.width*0.5)
        self.btnAutoIn1:setPositionX(WIDTH*0.25 - size1.width*0.5)
    else
        if t1>0 then
            self.btnAutoIn:setPositionX(-WIDTH*0.5 + 50)
            self.btnAutoIn1:setPositionX(WIDTH*0.25 - size1.width*0.5 + t1)
        elseif t2>0 then
            self.btnAutoIn:setPositionX(-WIDTH*0.25 - size.width*0.5 - t2 + 80)
            self.btnAutoIn1:setPositionX(WIDTH*0.5 - size1.width)
        end
    end

    local size2 = self.btnAutoIn.clickArea:getContentSize()
    self.btnAutoIn.clickArea:setContentSize(cc.size(size.width,size2.height))
    local size3 = self.btnAutoIn1.clickArea:getContentSize()
    self.btnAutoIn1.clickArea:setContentSize(cc.size(size1.width,size3.height))

    ColorButton(self.mainNode.nodeSelf):onButtonClicked(function()
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        self:hidePanel()
        tx.PayGuideManager:openStore()
    end)

    -- slider
    local barBtnSize = self.mainNode.nodeSlider.barBtn:getContentSize()
    self.thumbSlideLen_ = self.mainNode.nodeSlider.bg:getContentSize().width
    self.thumbLeft_ = 0 + barBtnSize.width*0.5 - 8  -- 8 像素透明区域
    self.thumbRight_ = self.thumbSlideLen_ - barBtnSize.width*0.5 + 8
    self.thumbSlideLen_ = self.thumbSlideLen_ - barBtnSize.width + 16
    ImgButton(self.mainNode.nodeSlider.barBtn, "#dialogs/buyin/buy_pop_slider.png", "#dialogs/buyin/buy_pop_slider_down.png")
        :onButtonPressed(function(evt)
            self.isThumbTouching_ = true
            self.thumbTouchBeginX_ = evt.x
            self.thumbBeginX_ = self.mainNode.nodeSlider.barBtn:getPositionX()
            self:unscheduleUpdate()
        end)
        :onButtonMove(function(evt)
            local movedX = evt.x - self.thumbTouchBeginX_
            local toX = self.thumbBeginX_ + movedX
            if toX >= self.thumbRight_ then
                toX = self.thumbRight_
            elseif toX <= self.thumbLeft_ then
                toX = self.thumbLeft_
            end
            local val = (toX - self.thumbLeft_) / self.thumbSlideLen_
            self:onSliderPercentValueChanged_(val, false, true)
        end)
        :onButtonRelease(function(evt)
            self.isThumbTouching_ = false
            self.posPercent_ = (self.mainNode.nodeSlider.barBtn:getPositionX() - self.thumbLeft_) / self.thumbSlideLen_
            if self.posPercent_ > self.myMoneyPercent_ then
                self:scheduleUpdate()
                self.animIsShow_ = false
                self.animCount_ = 2 * 2
                self.schedulerPool_:clearAll()
                self.schedulerPool_:loopCall(function()
                    self.mainNode.nodeSelf.value:setOpacity(self.animIsShow_ and 255 or 0.3 * 255)
                    self.mainNode.nodeSelf.icon:setOpacity(self.animIsShow_ and 255 or 0.3 * 255)
                    self.animIsShow_ = not self.animIsShow_
                    self.animCount_ = self.animCount_ - 1
                    if self.animCount_ == 0 then
                        self.mainNode.nodeSelf.value:setOpacity(255)
                        self.mainNode.nodeSelf.icon:setOpacity(255)
                        return false
                    end
                    return true
                end, 0.1)
            end
        end)

    self:dealAutoIn()
    self:onSliderPercentValueChanged_(math.min(self.middlePercent_, self.myMoneyPercent_), true, false)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onEnterFrame_))
    self:setLoading(false)
end

function BuyInPopup:dealAutoInData(data)
    if self.isAutoBuyin_ == data then
        self.isAutoBuyin_ = 0
    else
        self.isAutoBuyin_ = data
    end
end

function BuyInPopup:dealAutoIn()
    if self.isAutoBuyin_==1 then
        self.btnAutoIn:setSpriteFrame("common/ui_checkbox_on.png")
        self.btnAutoIn1:setSpriteFrame("common/ui_checkbox_off.png")
    elseif self.isAutoBuyin_==2 then
        self.btnAutoIn:setSpriteFrame("common/ui_checkbox_off.png")
        self.btnAutoIn1:setSpriteFrame("common/ui_checkbox_on.png")
    else
        self.btnAutoIn:setSpriteFrame("common/ui_checkbox_off.png")
        self.btnAutoIn1:setSpriteFrame("common/ui_checkbox_off.png")
    end
end

function BuyInPopup:ctor(param)
    self.param_ = param
    self.blind_ = param.blind
    self.min_ = param.minBuyIn
    self.max_ = param.maxBuyIn
    self.range_ = self.max_ - self.min_
    self.step_ = math.ceil(self.range_ / 10)
    if self.param_ and self.param_.type==1 then  -- 一定是百分之百哈哈
        self.myMoneyPercent_ = 1
    else
        self.myMoneyPercent_ = ((tx.userData and tx.userData.money or 0) - self.min_) / self.range_
    end
    self.middlePercent_ = (self.max_ * 0.5 - self.min_) / self.range_
    -- 居然会是负值
    if self.middlePercent_<0 then
        self.middlePercent_ = 0.5
    end

    local isBuyin = cc.UserDefault:getInstance():getStringForKey(tx.cookieKeys.AUTO_BUY_IN, "1")
    if isBuyin=="true" or isBuyin=="1" then
        self.isAutoBuyin_ = 1
    elseif isBuyin=="2" then
        self.isAutoBuyin_ = 2
    else
        self.isAutoBuyin_ = 0
    end

    self.schedulerPool_ = sa.SchedulerPool.new()
    self:setNodeEventEnabled(true)

    BuyInPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setLoading(true)

    self:setTextTitleStyle(sa.LangUtil.getText("ROOM","BUY_IN_TITLE"))

    self:initViews_()
end

function BuyInPopup:onEnterFrame_()
    if self.posPercent_ <= self.myMoneyPercent_ then
        self.posPercent_ = self.myMoneyPercent_
        self:unscheduleUpdate()
    else
        self.posPercent_ = self.posPercent_ - math.max((self.posPercent_ - self.myMoneyPercent_) * 0.06, 2 / self.thumbSlideLen_)
        if self.posPercent_ <= self.myMoneyPercent_ then
            self.posPercent_ = self.myMoneyPercent_
            self:unscheduleUpdate()
        end
    end
    self:onSliderPercentValueChanged_(self.posPercent_, true, false)
end

function BuyInPopup:onSliderPercentValueChanged_(newVal, forceUpdate, needSound)
    if self.percentValue_ ~= newVal or forceUpdate then
        local curTime = sa.getTime()
        local prevTime = self.lastRaiseSliderGearTickPlayTime_ or 0

        local moneyVal = math.round(self.min_ + self.range_ * newVal)
        local money = tx.userData and tx.userData.money or 0
        local curText = sa.formatNumberWithSplit(moneyVal)
        self.mainNode.nodeBuy.labelBuy:setString(curText)
        sa.fitSprteWidth(self.mainNode.nodeBuy.labelBuy, 350)
        
        self.mainNode.nodeSlider.barBtn:setPositionX(self.thumbLeft_ + self.thumbSlideLen_ * newVal)
        -- self.thumb_:setPositionX(self.thumbLeft_ + self.thumbSlideLen_ * newVal)

        newVal = math.max(0, math.min(self.myMoneyPercent_, newVal, 1))

        self.prevValue_ = self.curValue_
        self.curValue_ = math.round(self.min_ + self.range_ * newVal)
        if needSound and self.prevValue_ ~= self.curValue_  and curTime - prevTime > 0.05 then
            self.lastRaiseSliderGearTickPlayTime_ = curTime
            tx.SoundManager:playSound(tx.SoundManager.GEAR_TICK)
        end

        self.percentValue_ = newVal
        local size = self.mainNode.nodeSlider.bar:getContentSize()
        self.mainNode.nodeSlider.bar:setContentSize(cc.size(self.thumbLeft_ + newVal * self.thumbSlideLen_, size.height))
        self.mainNode.nodeSub.btnSub:setButtonEnabled(newVal > 0)
        self.mainNode.nodeAdd.btnAdd:setButtonEnabled(newVal < math.min(self.myMoneyPercent_, 1))
    end
end



function BuyInPopup:onCleanup()
    if self.moneyChangeObserverId_ then
        sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "money", self.moneyChangeObserverId_)
        self.moneyChangeObserverId_ = nil
    end
    if self.isAutoBuyin_==1 then
        cc.UserDefault:getInstance():setStringForKey(tx.cookieKeys.AUTO_BUY_IN, "1")
    elseif self.isAutoBuyin_==2 then
        cc.UserDefault:getInstance():setStringForKey(tx.cookieKeys.AUTO_BUY_IN, "2")
    else
        cc.UserDefault:getInstance():setStringForKey(tx.cookieKeys.AUTO_BUY_IN, "")
    end
    self:unscheduleUpdate()
    self.schedulerPool_:clearAll()
    display.removeSpriteFramesWithFile("dialog_buyin.plist", "dialog_buyin.png")
end

function BuyInPopup:onMoneyChanged_(money)
    local label = self.mainNode.nodeSelf.value
    label:setString(sa.formatBigNumber(money or 0))
    self.myMoneyPercent_ = math.max(0, ((money or 0) - self.min_) / self.range_)
    if self.param_ and self.param_.type==1 then
        self.myMoneyPercent_ = 1
    end
    local size = label:getContentSize()
    self.mainNode.nodeSelf.icon:setPositionX(size.width+15)
end

return BuyInPopup