-- 结算增加筹码视图
local AddChipView = class("AddChipView", function()
    return display.newNode()
end)

function AddChipView:ctor(num)
    -- local light = sp.SkeletonAnimation:create("spine/JYdaxiang.json", "spine/JYdaxiang.atlas")
    --     :addTo(self)
    -- if light:findAnimation(9) then
    --     light:setAnimation(0, 9, false)
    -- end

    local label = ui.newBMFontLabel({text = "+" .. sa.formatBigNumber(num), font = "fonts/xiaohuang.fnt"})
        :addTo(self)

    local move = cc.Spawn:create(
        cc.FadeIn:create(0.5),
        cc.EaseBackOut:create(cc.MoveBy:create(0.5, cc.p(0, 50)))
    )

    local sequence = transition.sequence({
        cc.DelayTime:create(0.2),
        move,
        cc.DelayTime:create(0.2),
        cc.FadeOut:create(0.3),
        cc.CallFunc:create(function() 
            self:removeFromParent()
        end),
    })

    label:opacity(0)
    label:runAction(sequence)
end

return AddChipView