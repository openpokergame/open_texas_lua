-- 对CCS的node进行数字键盘封装,类似EditLabel
local NumberEditbox = class("NumberEditbox", function()
    return display.newNode()
end)

local KeyboardView = import("app.module.keyboard.KeyboardView")
local KEYBOARD_W, KEYBOARD_H = 554, 404

function NumberEditbox:ctor(params)
    self:setNodeEventEnabled(true)
    self:initData_(params)

    local width, height = self.width_, self.height_
    self:size(width, height):align(display.CENTER)

    cc.ui.UIPushButton.new(self.img_, {scale9 = true})
        :setButtonSize(width, height)
        :onButtonClicked(buttontHandler(self, self.onInputClicked_))
        :pos(width*0.5, height*0.5)
        :addTo(self)

    self.numLabel_ = cc.ui.UILabel.new({text = "", color = self.color_, size = 30})
        :align(display.LEFT_CENTER, 10, height*0.5)
        :addTo(self)
    --目标文本
    if self.bmFont_ then
        self.numBMLabel_ = ui.newBMFontLabel({text = "", font = self.bmFont_})
            :align(display.LEFT_CENTER, 10, height*0.5)
            :addTo(self)
            :hide()
    end
    local originalSetString = self.numLabel_.setString
    self.numLabel_.setString = function(obj,str)
        originalSetString(obj,str)
        sa.fitSprteWidth(obj, width-20)
        if self.numBMLabel_ then
            if str==self.tips_ then
                self.numLabel_:show()
                self.numBMLabel_:hide()
            else
                self.numBMLabel_:setString(str)
                sa.fitSprteWidth(self.numBMLabel_, width-20)
                self.numLabel_:hide()
                self.numBMLabel_:show()
            end
        end
    end
    self.numLabel_:setString(self.tips_)
end

function NumberEditbox:initData_(params)
    self.width_, self.height_ = params.width, params.height

    self.img_ = params.img or "#common/common_edit_box_bg.png"
    local direction = params.direction or 1 --键盘方向 1在输入下面  2在输入框上面
    if direction == 1 then
        self.posx_, self.posy_ = KEYBOARD_W*0.5 - 8, -KEYBOARD_H*0.5
    else
        self.posx_, self.posy_ = KEYBOARD_W*0.5 - 8, KEYBOARD_H*0.5 + self.height_
    end
    self.offsetX_ = params.offsetX or 0
    self.offsetY_ = params.offsetY or 0

    self.color_ = params.color or styles.FONT_COLOR.INPUT_TEXT

    self.tips_ = params.tips or ""

    self.maxLen_ = params.maxLen or 6

    self.bmFont_ = params.bmFont or nil

    if params.onInputCallback then
        self.onInputCallback_ = params.onInputCallback
    end

    if params.onEnterCallback then
        self.onEnterCallback_ = params.onEnterCallback
    end
end

function NumberEditbox:onInputClicked_()
    self.numLabel_:setString(self.tips_)
    if self.onInputCallback_ then
        self.onInputCallback_()
    end

    sa.EventCenter:dispatchEvent({name=tx.eventNames.REMOVE_OTHER_KEYBOARD_POPUP})

    KeyboardView.new(true, self.maxLen_, self):pos(self.posx_+self.offsetX_, self.posy_+self.offsetY_):addTo(self)
end

function NumberEditbox:onEnterClicked_()
    if self.onEnterCallback_ then
        self.onEnterCallback_()
    end
end

function NumberEditbox:onNumChanged_(evt)
    local text = evt.data
    if text == "" then
       text = self.tips_
    end
    self.numLabel_:setString(text)
end

function NumberEditbox:getText()
    local text = self.numLabel_:getString()
    if text == self.tips_ then
        text = ""
    end
    return text
end

function NumberEditbox:setText(text)
    self.numLabel_:setString(text)
end

function NumberEditbox:setTextColor(color)
    self.numLabel_:setTextColor(color)
end

--添加键盘事件，键盘打开的时候调用
function NumberEditbox:addKeyboardEventListeners()
    self.onNumChangedListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.KEYBOARD_POPUP_NUM_CHANGED, handler(self, self.onNumChanged_))
    self.onEnterListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.KEYBOARD_POPUP_ENTER, handler(self, self.onEnterClicked_))
end

--删除键盘事件，键盘关闭的时候调用
function NumberEditbox:removeKeyboardEventListeners()
    sa.EventCenter:removeEventListener(self.onNumChangedListenerId_)
    sa.EventCenter:removeEventListener(self.onEnterListenerId_)
end

return NumberEditbox

