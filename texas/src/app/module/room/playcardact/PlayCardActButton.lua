-- 游戏玩牌活动按钮
local logger = sa.Logger.new("PlayCardActButton")
local PlayCardActButton = class("PlayCardActButton", function()
    return display.newNode()
end)

local PlayCardPopup = import(".PlayCardPopup")

function PlayCardActButton:ctor(ctx)
    self.ctx = ctx
    self.btn_ = display.newSprite("#commonroom/play_crad_act_btn.png")
        :scale(0.7)
        :pos(-45,155)
        :addTo(self)
    ScaleButton(self.btn_,1.05):onButtonClicked(buttontHandler(self, self.onPlayCardClicked_))

    self.label_ = ui.newTTFLabel({text = "", size = 24})
        :pos(75, 80)
        :addTo(self.btn_)

    self.light_ = display.newSprite("#commonroom/play_crad_act_light.png")
        :pos(75, 70)
        :addTo(self.btn_)
end

function PlayCardActButton:onPlayCardClicked_()
    PlayCardPopup.new(self.ctx.model.roomInfo.blind):showPanel()
end

function PlayCardActButton:setString(text)
    self.label_:setString(text)
end

function PlayCardActButton:showRewardAnimation()
    local seq = transition.sequence({cc.FadeIn:create(0.5), cc.FadeOut:create(0.5)})
    self.light_:show():runAction(cc.RepeatForever:create(seq))
end

function PlayCardActButton:hideRewardAnimation()
    self.light_:hide():stopAllActions()
end

return PlayCardActButton
