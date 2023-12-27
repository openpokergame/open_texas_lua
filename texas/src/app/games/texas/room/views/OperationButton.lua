local TouchHelper = sa.TouchHelper

local OperationButton = class("OperationButton", function()
    return display.newNode()
end)

OperationButton.BUTTON_WIDTH = 188
OperationButton.BUTTON_HEIGHT = 86

OperationButton.purpleColor = cc.c3b(0xff,0xff,0xff)
OperationButton.greenColor = cc.c3b(0xff,0xff,0xff)
OperationButton.redColor = cc.c3b(0xff,0xff,0xff)
OperationButton.yellowColor = cc.c3b(0xff,0xff,0xff)

function OperationButton:ctor(suffix,animParam)
    if not suffix then suffix="green" end
    self.animParam_ = animParam
    self.suffix_ = suffix
    self.touchHelper_ = TouchHelper.new(self, self.onTouch_)
    self.touchHelper_:enableTouch()

    self.isEnabled_ = true
    self.isCheckMode_ = true
    self.isChecked_ = false
    self.isPressed_ = false

    local btnW = OperationButton.BUTTON_WIDTH
    local btnH = OperationButton.BUTTON_HEIGHT
    self.backgrounds_ = {
        oprUp = display.newScale9Sprite("#texas/room/"..suffix..".png"):size(btnW, btnH):addTo(self),
        oprDown = display.newScale9Sprite("#texas/room/"..suffix.."_down.png"):size(btnW, btnH):addTo(self),
        checkUp = display.newScale9Sprite("#texas/room/purple.png"):size(btnW, btnH):addTo(self),
        checkDown = display.newScale9Sprite("#texas/room/purple_down.png"):size(btnW, btnH):addTo(self),
        checkSelected = display.newScale9Sprite("#texas/room/purple_select.png"):size(btnW, btnH):addTo(self),
        disable = display.newScale9Sprite("#texas/room/purple_select.png"):size(btnW, btnH):addTo(self),
    }

    self.iconCheckIcon_ = display.newSprite("#texas/room/select_icon_off.png"):pos(OperationButton.BUTTON_WIDTH * -0.5 + 38, 0):addTo(self)

    self.label_ = ui.newTTFLabel({
        text="",
        size=34,
        align=ui.TEXT_ALIGN_CENTER,
        color=cc.c3b(0xff, 0xff, 0xff)})
        :addTo(self)
    self:updateView_()
end

function OperationButton:setEnabled(isEnabled)
    self.isEnabled_ = isEnabled
    self:updateView_()
    return self
end

function OperationButton:setLabel(label_,isAllIn)
    self.label_:setString(label_)
    self.isAllIn = isAllIn
    return self
end

function OperationButton:getLabel()
    return self.label_:getString()
end

function OperationButton:isChecked()
    return self.isChecked_
end

function OperationButton:setChecked(isChecked, triggerHandler)
    local oldChecked = self.isChecked_
    self.isChecked_ = isChecked
    if isChecked ~= oldChecked and self.checkHandler_ and triggerHandler then
        self.checkHandler_(self, isChecked)
    end
    self:updateView_()
    return self
end

function OperationButton:setCheckMode(isCheckMode)
    self.isCheckMode_ = isCheckMode
    self:updateView_()
    return self
end

function OperationButton:onTouch(touchHandler)
    self.touchHandler_ = touchHandler
    return self
end

function OperationButton:onCheck(checkHandler)
    self.checkHandler_ = checkHandler
    return self
end

function OperationButton:onTouch_(evt)
    if self.isEnabled_ then
        if evt == TouchHelper.CLICK then
            tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
            self.isPressed_ = false
            if self.isCheckMode_ then
                self.isChecked_ = not self.isChecked_
                if self.checkHandler_ then
                    self.checkHandler_(self, self.isChecked_)
                end
            end
        elseif evt == TouchHelper.TOUCH_BEGIN then
            self.isPressed_ = true
        elseif evt == TouchHelper.TOUCH_END then
            self.isPressed_ = false
        end
        self:updateView_()

        if self.touchHandler_ then
            self.touchHandler_(evt)
        end
    end
end

function OperationButton:updateView_()
    if self.isCheckMode_ then
        self.iconCheckIcon_:show()
        if self.isChecked_ then
            self.iconCheckIcon_:setSpriteFrame("texas/room/select_icon_on.png")
        else
            self.iconCheckIcon_:setSpriteFrame("texas/room/select_icon_off.png")
        end
        self.label_:pos(20, 0)
    else
        self.iconCheckIcon_:hide()
        self.label_:pos(0, 0)
    end

    if not self.isEnabled_ then
        self:selectBackground("checkUp")
        self.label_:setTextColor(OperationButton.purpleColor)
    elseif self.isCheckMode_ then
        if self.isPressed_ then
            self:selectBackground("checkDown")
        elseif self.isChecked_ then
            self:selectBackground("checkSelected")
        else
            self:selectBackground("checkUp")
        end
        self.label_:setTextColor(OperationButton.purpleColor)
    else
        if self.isPressed_ then
            self:selectBackground("oprDown")
        else
            self:selectBackground("oprUp")
        end
        self.label_:setTextColor(OperationButton[self.suffix_.."Color"])
    end
    self:stopAllActions()
    if self.isEnabled_ then
        self.backgrounds_.checkUp:setOpacity(255)
        if self.animParam_ and self.animParam_.showY then
            transition.moveTo(self, {y = self.animParam_.showY, time=0.1})
        else
            transition.moveTo(self, {y = 0, time=0.1})
        end
    else
        self.backgrounds_.checkUp:setOpacity(128)
        if self.animParam_ and self.animParam_.hideY then
            transition.moveTo(self, {y = self.animParam_.hideY, time=0.1})
        else
            transition.moveTo(self, {y = -90, time=0.1})
        end
    end
end

function OperationButton:selectBackground(name)
    for k, v in pairs(self.backgrounds_) do
        if k == name then
            v:show()
        else
            v:hide()
        end
    end
end

return OperationButton