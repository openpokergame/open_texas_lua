local LuckturnPopup = class("LuckturnPopup", function()
    return display.newNode()
end)

local LuckturnController = import(".LuckturnController")
local LuckturnView = import(".LuckturnView")
local LuckturnRecordListItem = import(".LuckturnRecordListItem")
local ScrollLabel = import("openpoker.ui.ScrollLabel")

local LIST_X = 358

function LuckturnPopup:ctor()
    self.controller_ = LuckturnController.new(self)

	self:setNodeEventEnabled(true)

    local node = display.newNode()
        :size(1160, 750)
        :align(display.CENTER)
        :addTo(self)
    node:setTouchEnabled(true)

	self:addMainUI_()

    self.controller_:getLuckturnConfig()
end

function LuckturnPopup:addMainUI_()
    local bg_w, bg_h = 584, 618
    local bg = display.newSprite("#dialogs/luckturn/luckturn_bg.png")
        :pos(290, 0)
        :addTo(self)

    self.bg_ = bg

    self.luckturnView_ = LuckturnView.new(self.controller_)
        :pos(-210, -25)
        :addTo(self, 1)

    cc.ui.UIPushButton.new({normal = "#dialogs/luckturn/luckturn_close_btn_normal.png", pressed = "#dialogs/luckturn/luckturn_close_btn_pressed.png"})
        :pos(bg_w - 20, bg_h - 20)
        :onButtonClicked(buttontHandler(self, self.hidePanel_))
        :addTo(bg)

    self.countdown_ = ui.newBMFontLabel({text = sa.TimeUtil:getTimeString1(0), font = "fonts/luckturn_time.fnt"})
        :pos(LIST_X, 72)
        :addTo(self.bg_)
end

function LuckturnPopup:updateUI(data, isCache)
    self.data_ = data
    -- -- 模拟数据
    -- self.data_.freetimes = 3
    -- self.data_.countdown = sa.getTime() + 10
    -- self.data_.fulltimes = 3
    
    self:addRecordNode_(data.record)
    self.luckturnView_:updateUI(data, isCache)
    self:addRuleNode_(data.countdownTime)
    self:checkStartOrStopCountDown()
end

function LuckturnPopup:changeOneTime(isAdd)
    if self.data_ then
        local freetimes = tonumber(self.data_.freetimes) or 0
        if isAdd then
            freetimes = freetimes + 1
        else
            freetimes = freetimes - 1
        end
        self.data_.freetimes = freetimes
        self:checkStartOrStopCountDown()
    end
end

function LuckturnPopup:checkStartOrStopCountDown()
    if self.data_ then
        local freetimes = tonumber(self.data_.freetimes) or 0
        if freetimes<0 then
            freetimes = 0
        end
        local fulltimes = tonumber(self.data_.fulltimes) or 3 -- 最多次数
        if freetimes>=fulltimes then
            freetimes = fulltimes
            self.data_.countdown = 0
        end
        self.data_.freetimes = freetimes
        local countdown = tonumber(self.data_.countdown) or 0
        if freetimes<fulltimes and countdown==0 then -- 客户端强制记录时间
            local countdownTime = tonumber(self.data_.countdownTime) or 8
            self.data_.countdown = sa.getTime() + countdownTime * 60 * 60
            countdown = self.data_.countdown
        end
        if countdown>0 then
            self.count_ = self.data_.countdown - sa.getTime()
            self:updateCountdown(self.count_)
            local actNum = self.countdown_:getNumberOfRunningActions()
            if actNum<1 then
                self.countdown_:schedule(function()
                    self.count_ = self.count_ - 1
                    if self.count_ <= 0 then
                        local freetimes = tonumber(self.data_.freetimes) or 0
                        freetimes = freetimes + 1
                        self.data_.freetimes = freetimes
                        local countdownTime = tonumber(self.data_.countdownTime) or 8
                        self.data_.countdown = sa.getTime() + countdownTime * 60 * 60
                        self.countdown_:stopAllActions()
                        self:updateCountdown(0)
                        self:checkStartOrStopCountDown()
                    end
                    self:updateCountdown(self.count_)
                    self.luckturnView_:addLuckturnBtnNode_(self.data_,self.count_)
                end, 1)
            end
        else
            self.countdown_:stopAllActions()
            self:updateCountdown(0)
        end
        self.luckturnView_:addLuckturnBtnNode_(self.data_,self.count_)
    else
        self.countdown_:stopAllActions()
        self:updateCountdown(0)
    end
end

--规则
function LuckturnPopup:addRuleNode_(time)
    if self.rule_ then
        return
    end

    local dw, dh = 360, 100
    local str = sa.LangUtil.getText("LUCKTURN", "RULE_TEXT", time)
    self.rule_ = ScrollLabel.new(
        {
            text = str,
            color = cc.c3b(0x76,0x5f,0xb9),
            size = 20,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
        },
        {
            viewRect = cc.rect(-dw/2, -dh/2, dw, dh)
        })
    :hideScrollBar()
    :pos(LIST_X, 162)
    :addTo(self.bg_)
end

function LuckturnPopup:updateCountdown(count)
    self.countdown_:setString(sa.TimeUtil:getTimeString1(count))
end

--获奖记录
function LuckturnPopup:addRecordNode_(data)
    if self.list_ then
        self.list_:setData(data)
    else
        local list_w, list_h = 360, 230
        self.list_ = sa.ui.ListView.new(
            {
                viewRect = cc.rect(-list_w/2, -list_h /2, list_w, list_h),
            }, 
            LuckturnRecordListItem
        )
        :hideScrollBar()
        :pos(LIST_X, 359)
        :addTo(self.bg_)

        self.list_:setData(data)
    end
end

function LuckturnPopup:showPanel()
    tx.PopupManager:addPopup(self)
    return self
end

function LuckturnPopup:hidePanel_()
    tx.PopupManager:removePopup(self)
    return self
end

function LuckturnPopup:onClose()
    if self.modal_ then
        self.modal_:removeFromParent()
        self.modal_ = nil
    end

	return self:hidePanel_()
end

function LuckturnPopup:startTurn()
    self.luckturnView_:startTurn()
end

function LuckturnPopup:updateLuckturnStatus(isSuccess, data)
    self.luckturnView_:updateLuckturnStatus(isSuccess, data)
end

function LuckturnPopup:onShowed()
    if self.list_ then
        self.list_:setScrollContentTouchRect()
    end
end

function LuckturnPopup:onCleanup()
    self.controller_:dispose()
    display.removeSpriteFramesWithFile("dialog_luckturn_texture.plist", "dialog_luckturn_texture.png")
end

function LuckturnPopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(-210, 5)
                :addTo(self, 999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function LuckturnPopup:setCloseCallback(closeCallback)
    self.closeCallback_ = closeCallback
    return self
end
function LuckturnPopup:onRemovePopup(removeFunc)
    if self.closeCallback_ then
        self.closeCallback_()
    end
    removeFunc()
end
return LuckturnPopup