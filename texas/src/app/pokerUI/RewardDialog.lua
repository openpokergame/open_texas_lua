-- 通用奖励弹窗
local RewardDialog = class("RewardDialog", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 900, 575
local CENTER_X, CENTER_Y = WIDTH*0.5, HEIGHT*0.5

function RewardDialog:ctor(data, isShare)
    self.data_ = data

    display.newScale9Sprite("#common/modal_texture.png", 0, 0, cc.size(display.width, display.height)):addTo(self)
    display.newScale9Sprite("#common/modal_texture.png", 0, 0, cc.size(display.width, display.height)):addTo(self)
        
    local bg = display.newNode()
        :size(WIDTH, HEIGHT)
        :align(display.CENTER, 0, 0)
        :addTo(self)

    local an = sp.SkeletonAnimation:create("spine/jianglitanchuang.json","spine/jianglitanchuang.atlas")
        :pos(CENTER_X, CENTER_Y)
        :addTo(bg)
    an:setAnimation(0, "1", false)

    local title = display.newSprite("#lang/reward_dialog_title.png")
        :scale(0)
        :pos(CENTER_X, HEIGHT - 50)
        :addTo(bg)
    transition.scaleTo(title, {scale = 2, time=0.2, onComplete=function()
        transition.scaleTo(title, {scale = 1, time=0.5, easing = "bounceOut"})
    end})

    self.rewardNode_ = display.newNode()
        :pos(CENTER_X, CENTER_Y)
        :addTo(bg)
        :hide()

    self:addRewardInfo(data)

    local btn_w, btn_h = 330, 146
    local btn_x, btn_y = CENTER_X, 20
    if isShare then
       self.btn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "SHARE"), size = 26}))
            :pos(btn_x, btn_y)
            :onButtonClicked(buttontHandler(self, self.onShareClicked_))
            :addTo(bg)
            :hide()
    else
        self.btn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "CONFIRM"), size = 26}))
            :pos(btn_x, btn_y)
            :onButtonClicked(buttontHandler(self, self.onConfirmClicked_))
            :addTo(bg)
            :hide()
    end

    local particle = cc.ParticleSystemQuad:create("particle/fk_6.plist")
        :pos(CENTER_X, CENTER_Y)
        :addTo(bg)

    self:playShowRewardAnimation_()
end

function RewardDialog:addRewardInfo(data, offsetY)
    offsetY = offsetY or 0
    self.rewardNode_:setPositionY(CENTER_Y + offsetY)

    if data.rewardList then
        local dir = 220
        local len = #data.rewardList
        local w = dir * len
        local sx = -w * 0.5 + dir*0.5
        for _, v in ipairs(data.rewardList) do
            local info = self:createRewardInfo_(v, sx)
            sx = sx + dir
        end
    else
        self:createRewardInfo_(data)
    end
end

function RewardDialog:addCardInfo_(data)
end

function RewardDialog:createRewardInfo_(data, x)
    local w, h = 170, 155
    local icon_x, icon_y = w*0.5, h*0.5
    local s = 1
    local icon = ""

    desc = sa.formatNumberWithSplit(data.num)
    if data.rewardType == 1 then
        icon = "#common/chips_1.png"
        icon_y = icon_y + 25
    elseif data.rewardType == 2 then
        icon = "#common/prop_hddj.png"
    elseif data.rewardType == 3 then
        icon = "#common/vip_level_icon_" .. data.vipLevel .. ".png"
        desc = data.desc
        s = 2
    elseif data.rewardType == 4 then
        icon = "#common/diamonds_3.png"
        icon_y = icon_y + 5
    elseif data.rewardType == 5 then
        icon = "#common/prop_laba.png"
    end

    local frame = display.newScale9Sprite("reward_dialog_item.png", 0, 0, cc.size(w, h))
        :pos(x or 0, 0)
        :addTo(self.rewardNode_)

    display.newSprite(icon)
        :scale(s)
        :pos(icon_x, icon_y)
        :addTo(frame)

    ui.newTTFLabel({text = desc, color = styles.FONT_COLOR.CHIP_TEXT, size = 40})
        :pos(icon_x, -40)
        :addTo(frame)

    return frame
end

function RewardDialog:playShowRewardAnimation_()
    self.rewardNode_:scale(1.2)
    local seq = transition.sequence({
        cc.DelayTime:create(0.3),
        cc.CallFunc:create(function()
            tx.SoundManager:playSound(tx.SoundManager.SHOW_GOLD_TIPS)
            self.rewardNode_:show()
        end),
        cc.EaseBackOut:create(cc.ScaleTo:create(0.2, 1))
    })
    self.rewardNode_:runAction(seq)

    seq = transition.sequence({
        cc.DelayTime:create(0.8),
        cc.FadeIn:create(0.2),
        cc.CallFunc:create(function() 
            tx.PopupManager:setModalIsRemovePopup(true)
        end),
    })

    self.btn_:opacity(0):show()
    self.btn_:runAction(seq)
end

function RewardDialog:onShareClicked_()
    local feedData = self.data_.feedData
    tx.ShareSDK:shareFeed(feedData, function(success, result)
        if success then
            self:hidePanel()
        end
    end)
end

function RewardDialog:onConfirmClicked_()
    self:hidePanel()
end

function RewardDialog:showPanel()
    tx.PopupManager:addPopup(self, true, true, true, false)
    tx.PopupManager:setModalIsRemovePopup(false)
end

function RewardDialog:hidePanel()
    tx.PopupManager:removePopup(self)
end

return RewardDialog