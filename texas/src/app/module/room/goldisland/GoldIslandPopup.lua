local GoldIslandPopup = class("GoldIslandPopup", function()
    return display.newNode()
end)
local HelpPopup = import(".HelpPopup")
local CountLabel = import("openpoker.ui.CountLabel")

local WIDTH, HEIGHT = 370, 730
local SHOW_X = WIDTH*0.5 - 20
local HIDE_X = -WIDTH*0.5

function GoldIslandPopup:ctor(controller)
    self:setNodeEventEnabled(true)
    local bg = display.newScale9Sprite("#common/pop_bg.png", 0, 0, cc.size(WIDTH, HEIGHT), cc.rect(170, 170, 1, 1)):addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)

    self:pos(HIDE_X, HEIGHT*0.5 + 70)

    self.bg_ = bg

    self.controller_ = controller

    local x = WIDTH*0.5
    display.newSprite("img/goldisland_bg_1.jpg")
        :align(display.TOP_CENTER, x, HEIGHT - 30)
        :addTo(bg)

    self.rewardPool_ = CountLabel.new({text = sa.formatNumberWithSplit(tx.userData.goldIslandPool), font = "fonts/jiangchi.fnt", UILabelType = 1})
        :setStartNum(tx.userData.goldIslandPool)
        :pos(x, HEIGHT - 210)
        :addTo(bg)
    sa.fitSprteWidth(self.rewardPool_, 310)

    self:addRewardDesc_()

    self:addHelpBtn_()

    self:addBuyBtn_()

    self:updateBuyBtnStatus_()

    self.autoBuyObserverHandle_ = sa.DataProxy:addPropertyObserver(tx.dataKeys.USER_DATA, "autoBuyGoldIsland", handler(self, self.updateAutoBuyStatus_))

    self.updateBuyBtnStatusId_ = sa.EventCenter:addEventListener(tx.eventNames.UPDATE_GOLD_ISLAND_BUY_STATUS, handler(self, self.updateBuyBtnStatus_))
    self.updatePoolChipsId_ = sa.EventCenter:addEventListener(tx.eventNames.UPDATE_GOLD_ISLAND_POOL, handler(self, self.updateGoldIslandPool_))
end

function GoldIslandPopup:addRewardDesc_()
    local bg = self.bg_
    local x, y = WIDTH*0.5, 440
    ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "TITLE"), size = 30})
        :pos(x, y)
        :addTo(bg)

    local dir = 70
    display.newSprite("#texas/room/goldisland_line.png")
        :align(display.RIGHT_CENTER, x - dir, y)
        :addTo(bg)

    display.newSprite("#texas/room/goldisland_line.png")
        :flipX(true)
        :align(display.LEFT_CENTER, x + dir, y)
        :addTo(bg)

    local cardTypeList = sa.LangUtil.getText("HELP", "RULE_DESC")
    local rewardList = tx.userData.goldIslandConfig.reward

    local sx, sy = 60, 390
    for i = 1, 3 do
        ui.newTTFLabel({text = cardTypeList[i], size = 28})
            :align(display.LEFT_CENTER, sx, sy)
            :addTo(bg)

        ui.newTTFLabel({text = rewardList[i] .. "%", size = 28})
            :align(display.RIGHT_CENTER, 310, sy)
            :addTo(bg)

        sy = sy - 45
    end
end

function GoldIslandPopup:addHelpBtn_()
    local bg = self.bg_
    local x, y = WIDTH*0.5, 260
    local labelColor = cc.c3b(0x53, 0xff, 0xf1)

    local btnLabel = ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "RULE_BTN"), size = 26, color = labelColor})
    local btnSize = btnLabel:getContentSize()
    local btn = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(btnSize.width, btnSize.height + 40)
        :setButtonLabel(btnLabel)
        :onButtonClicked(buttontHandler(self, self.onRuleClicked_))
        :pos(x, y)
        :addTo(bg)

    local line = ui.newTTFLabel({text = "_", size = 26, color = labelColor})
        :pos(x, y)
        :addTo(bg)
    local lineSize = line:getContentSize()
    line:setScaleX(btnSize.width/lineSize.width)
end

function GoldIslandPopup:addBuyBtn_()
    local bg = self.bg_
    local x = WIDTH*0.5
    local btn_w, btn_h = 240, 104

    self.buyBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png", disabled = "#common/btn_small_blue.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "BUY_BTN"), size = 26}))
        :setButtonLabel("disabled", ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "ALREADY_BUY"), size = 26}))
        :pos(x, 200)
        :onButtonClicked(buttontHandler(self, self.onBuyClicked_))
        :addTo(bg)

    ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "PRICE", tx.userData.goldIslandConfig.betChips), size = 26, color = styles.FONT_COLOR.CONTENT_TEXT})
        :pos(x, 145)
        :addTo(bg)

    local btn = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "AUTO_BUY"), size = 26}))
        :setButtonLabelAlignment(display.LEFT_CENTER)
        :setButtonLabelOffset(-50, 0)
        :pos(x, 80)
        :onButtonClicked(buttontHandler(self, self.onAutoBuyClicked_))
        :setDelayTouchEnabled(false)
        :addTo(bg)

    self.autoBuyIcon_ = display.newSprite()
        :pos(-73, 0)
        :addTo(btn)
end

function GoldIslandPopup:onRuleClicked_()
    HelpPopup.new():showPanel()
end

function GoldIslandPopup:onBuyClicked_()
    self.controller_:buyGoldIsland()
    self:hidePanel()
end

function GoldIslandPopup:onAutoBuyClicked_()
    tx.userData.autoBuyGoldIsland = not tx.userData.autoBuyGoldIsland
end

function GoldIslandPopup:updateAutoBuyStatus_()
    if tx.userData.autoBuyGoldIsland then
        self.autoBuyIcon_:setSpriteFrame("texas/room/goldisland_btn_on.png")
    else
        self.autoBuyIcon_:setSpriteFrame("texas/room/goldisland_btn_off.png")
    end
end

function GoldIslandPopup:updateGoldIslandPool_(evt)
    self.rewardPool_:setEndNum(evt.data)
    sa.fitSprteWidth(self.rewardPool_, 310)
end

function GoldIslandPopup:updateBuyBtnStatus_()
    if tx.userData.isBuyGoldIsland then
        self.buyBtn_:setButtonEnabled(false)
    else
        self.buyBtn_:setButtonEnabled(true)
    end
    self.buyBtn_:updateButtonLable_()
end

function GoldIslandPopup:showPanel()    
    tx.PopupManager:addPopup(self, true, false, true, false)
end

function GoldIslandPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function GoldIslandPopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(0, 40)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function GoldIslandPopup:onCleanup()
    if self.updateBuyBtnStatusId_ then
        sa.EventCenter:removeEventListener(self.updateBuyBtnStatusId_)
    end

    if self.updatePoolChipsId_ then
        sa.EventCenter:removeEventListener(self.updatePoolChipsId_)
    end

    if self.autoBuyObserverHandle_ then
        sa.DataProxy:removePropertyObserver(tx.dataKeys.USER_DATA, "autoBuyGoldIsland", self.autoBuyObserverHandle_)
    end
end

function GoldIslandPopup:onShowPopup()
    self:stopAllActions()
    transition.moveTo(self, {time = 0.2, x = SHOW_X, easing="OUT", onComplete=function()
    end})
end

function GoldIslandPopup:onRemovePopup(removeFunc)
    self:stopAllActions()
    transition.moveTo(self, {time = 0.2, x = HIDE_X, easing="OUT", onComplete=function() 
        removeFunc()
    end})
end

return GoldIslandPopup