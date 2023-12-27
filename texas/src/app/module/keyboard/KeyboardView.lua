-- 数字键盘视图
local KeyboardView = class("KeyboardView", function()
    return display.newNode()
end)

KeyboardView.ELEMENTS = {
    "bg",

    "btnNode.btn_0",
    "btnNode.btn_1",
    "btnNode.btn_2",
    "btnNode.btn_3",
    "btnNode.btn_4",
    "btnNode.btn_5",
    "btnNode.btn_6",
    "btnNode.btn_7",
    "btnNode.btn_8",
    "btnNode.btn_9",
    "btnNode.btn_10",
    "btnNode.btn_11",
}

local NUM_LABEL_X = 263

function KeyboardView:ctor(isModule, maxLen, delegate)
    self:setNodeEventEnabled(true)

    self.maxLen_ = maxLen or 10

    self.isModule_ = isModule

    if isModule then
        self:addModule_()
    end

    self:initViews_()

    self.delegate_ = delegate
    if self.delegate_ then
        self.delegate_:addKeyboardEventListeners()
    end

    self.onRemoveListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.REMOVE_OTHER_KEYBOARD_POPUP, handler(self, self.hidePanel_))
end

function KeyboardView:addModule_()
    local btn_w, btn_h = display.width*1.5, display.height*1.5
    cc.ui.UIPushButton.new("#common/transparent.png", {scale9=true})
        :setButtonSize(btn_w, btn_h)
        :onButtonClicked(buttontHandler(self,self.onCloseClicked_))
        :addTo(self, -999)
end

function KeyboardView:initViews_()
    tx.ui.EditPanel.bindElementsToTarget(self, "dialog_keyboard.csb", true)

    self.bg:setTouchEnabled(true)

    for i = 0, 9 do
        local btn = self.btnNode["btn_" .. i]
        ImgButton(btn,"#dialogs/keyboard/keyboard_num_btn_normal.png","#dialogs/keyboard/keyboard_num_btn_pressed.png")
            :onButtonClicked(buttontHandler(self, self.onNumClicked_))
            :setTag(i)
    end

    ImgButton(self.btnNode.btn_10,"#dialogs/keyboard/keyboard_num_btn_normal.png","#dialogs/keyboard/keyboard_num_btn_pressed.png")
        :onButtonClicked(buttontHandler(self, self.onDeleteClicked_))

    ImgButton(self.btnNode.btn_11,"#dialogs/keyboard/keyboard_num_btn_normal.png","#dialogs/keyboard/keyboard_num_btn_pressed.png")
        :onButtonClicked(buttontHandler(self, self.onEnterClicked_))

    self.curNumStr_ = ""
end

function KeyboardView:updateNumText_(str)
    sa.EventCenter:dispatchEvent({name=tx.eventNames.KEYBOARD_POPUP_NUM_CHANGED, data = self.curNumStr_})
end

--数字按钮点击
function KeyboardView:onNumClicked_(evt)
    local len = string.len(self.curNumStr_)
    if len == self.maxLen_ then
        return
    end

    local tag = evt.target:getTag()
    self.curNumStr_ = self.curNumStr_ .. tag
    self:updateNumText_()
end

--删除点击
function KeyboardView:onDeleteClicked_()
    local len = string.len(self.curNumStr_)
    if len > 0 then
        len = len - 1
        self.curNumStr_ = string.sub(self.curNumStr_, 1, len)
    end

    self:updateNumText_()
end

--确定点击
function KeyboardView:onEnterClicked_()
    self.curNumStr_ = ""

    sa.EventCenter:dispatchEvent({name=tx.eventNames.KEYBOARD_POPUP_ENTER})

    if self.isModule_ then
        self:hidePanel_()
    end
end

function KeyboardView:onCloseClicked_()
    self:hidePanel_()
end

function KeyboardView:hidePanel_()
    self:removeFromParent()
end

function KeyboardView:hideBg()
    self.bg:hide()

    return self
end

function KeyboardView:onCleanup()
    display.removeSpriteFramesWithFile("dialog_keyboard_texture.plist", "dialog_keyboard_texture.png")
    if self.delegate_ then
        self.delegate_:removeKeyboardEventListeners()
    end

    sa.EventCenter:removeEventListener(self.onRemoveListenerId_)
end

return KeyboardView