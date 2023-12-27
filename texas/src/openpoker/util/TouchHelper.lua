local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local TouchHelper = class("TouchHelper")

TouchHelper.CLICK = "CLICK"
TouchHelper.TOUCH_BEGIN = "TOUCH_BEGIN"
TouchHelper.TOUCH_MOVE = "TOUCH_MOVE"
TouchHelper.TOUCH_END = "TOUCH_END"

function TouchHelper:ctor(target, callback)
    self.callback_ = callback
    self.target_ = target
    self:enableTouch()
end

function TouchHelper:enableTouch()
    self.target_:setTouchEnabled(true)
    self.target_:setTouchSwallowEnabled(true)
    self.target_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

function TouchHelper:onTouch(evt)
    local name, x, y, prevX, prevY = evt.name, evt.x, evt.y, evt.prevX, evt.prevY
    local isTouchInSprite = self.target_:getCascadeBoundingBox():containsPoint(cc.p(x, y))

    if name == "began" then
        if isTouchInSprite then
            self.isClick_ = true
            self.touchStartX_ = x
            self.touchStartY_ = y
            self.isTouching_ = true
            self:notifyTarget(TouchHelper.TOUCH_BEGIN, isTouchInSprite, evt)

            return true
        else
            return false
        end
    elseif not self.isTouching_ then
        return false
    elseif name == "moved" then
        self.endX_ = evt.x
        self.endY_ = evt.y
        if math.abs(self.endX_-self.touchStartX_)>_G.___BUTTON_CLICK_FLAG___ then
            self.isClick_ = false
        elseif math.abs(self.endY_-self.touchStartY_)>_G.___BUTTON_CLICK_FLAG___ then
            self.isClick_ = false
        end
        self:notifyTarget(TouchHelper.TOUCH_MOVE, isTouchInSprite, evt)
    elseif name == "ended"  or name == "cancelled" then
        self.isTouching_ = false
        if not self.cancelClick_ and isTouchInSprite and self.isClick_ then
            self:notifyTarget(TouchHelper.CLICK, isTouchInSprite, evt)
        else
            self:notifyTarget(TouchHelper.TOUCH_END, isTouchInSprite, evt)
        end
        self.isClick_ = false
    end

    return true
end

function TouchHelper:notifyTarget(evtName, ...)
    if self.callback_ then
        self.callback_(self.target_, evtName, ...)
    end
end

return TouchHelper
