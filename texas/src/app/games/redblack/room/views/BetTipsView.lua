-- 下注步骤提示
local BetTipsView = class("BetTipsView", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 610, 220
local TITLES
local TIPS = {
	"lang/redblack_play.png",
	"lang/redblack_war.png",
}

local SOUND = {
    tx.SoundManager.REDBLACK_WAR,
    tx.SoundManager.REDBLACK_TIMEOUT,
}

function BetTipsView:ctor(step)
    self:setNodeEventEnabled(true)
	self:size(WIDTH, HEIGHT)
	self:align(display.CENTER)

	local x, y = WIDTH*0.5, HEIGHT*0.5
    local bg = display.newScale9Sprite("#redblack/room/redblack_tips_big_bg.png", 0, 0, cc.size(WIDTH, HEIGHT))
    	:pos(x, y)
        :addTo(self)
    self.bg_ = bg

    TITLES = {
	    sa.LangUtil.getText("REDBLACK","SELECTED_BET_TIPS"),
	    sa.LangUtil.getText("REDBLACK","SELECTED_BET_END_TIPS"),
	}
    self.title_ = ui.newTTFLabel({text = "", size = 32})
        :align(display.TOP_CENTER, x, HEIGHT - 20)
        :addTo(bg)

    self.tips_ = display.newSprite()
    	:pos(x, y - 20)
        :addTo(bg)
end

function BetTipsView:setTipsSetp(step, callback)
	self.title_:setString(TITLES[step])
	self.tips_:setSpriteFrame(TIPS[step])

    self.betSoundId_ = tx.SoundManager:playSound(SOUND[step])
	self:playShowAnimation_(callback)

	return self
end

function BetTipsView:playShowAnimation_(callback)
	local x, y = WIDTH*0.5, HEIGHT*0.5
	local dir = 300
	self:show()
	self.bg_:pos(x - dir, y)
	self.bg_:setCascadeOpacityEnabled(true)
	self.bg_:stopAllActions()

	local t = 0.2
    local move_1 = cc.EaseSineIn:create(cc.MoveTo:create(t, cc.p(x, y)))
    local fade_1 = cc.FadeIn:create(t)
    local spawn_1 = cc.Spawn:create(move_1, fade_1)

    local move_2 = cc.EaseSineOut:create(cc.MoveTo:create(t, cc.p(x + dir, y)))
    local fade_2 = cc.FadeOut:create(t)
    local spawn_2 = cc.Spawn:create(move_2, fade_2)

    local sequence = transition.sequence({
        spawn_1,
        cc.DelayTime:create(0.5),
        spawn_2,
        cc.CallFunc:create(function()
            if callback then
            	callback()
            end
        end),
    })

    self.bg_:runAction(sequence)
end

function BetTipsView:reset()
    self:hide()
    self.bg_:stopAllActions()
end

function BetTipsView:onCleanup()
    tx.SoundManager:stopSound(self.betSoundId_)
end

return BetTipsView