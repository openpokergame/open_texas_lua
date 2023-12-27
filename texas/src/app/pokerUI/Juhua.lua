local Juhua = class("Juhua", function(filename)
        return display.newSprite(filename or "#common/juhua.png")
    end)

function Juhua:ctor(filename)
    self:setNodeEventEnabled(true)
    self:setAnchorPoint(cc.p(0.5, 0.5))
end

function Juhua:onEnter()
    self:runAction(cc.RepeatForever:create(cc.RotateBy:create(100, 36000)))
end

function Juhua:onExit()
    self:stopAllActions()
end

return Juhua
