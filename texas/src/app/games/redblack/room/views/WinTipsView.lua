-- 胜利提示动画
local WinTipsView = class("WinTipsView", function()
    return display.newNode()
end)

function WinTipsView:ctor(area)
    self:setNodeEventEnabled(true)

	--压中提示背景
    self.area_ = display.newScale9Sprite("#redblack/room/redblack_win_blink_area.png", 0, 0, cc.size(area.width, area.height))
        :addTo(self)

    --胜利动画
    self.winAnimation_ = sp.SkeletonAnimation:create("spine/JYdaxiang.json", "spine/JYdaxiang.atlas")
        :addTo(self, 2)

    self.emitter_ = cc.ParticleSystemQuad:create("particle/redblack_win_2.plist")
        :addTo(self)
end

function WinTipsView:playAnimation()
    self.winSoundId_ = tx.SoundManager:playSound(tx.SoundManager.REDBLACK_WIN)

	self:show()

    self.emitter_:resetSystem()

	self.area_:runAction(cc.RepeatForever:create(cc.Blink:create(1, 2)))

    if self.winAnimation_ and self.winAnimation_:findAnimation(8) then
        self.winAnimation_:setAnimation(0, 8, false)
    end
end

function WinTipsView:stopAnimation()
    self:stopAllActions()

	self.area_:stopAllActions()

    self.emitter_:stopSystem()

	self:hide()
end

function WinTipsView:onCleanup()
    tx.SoundManager:stopSound(self.winSoundId_)
end

return WinTipsView