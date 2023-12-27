-- 搜索房间数字键盘
local KeyboardPopup = class("KeyboardPopup", function()
    return display.newNode()
end)

local KeyboardView = import(".KeyboardView")
local BG_W, BG_H = 554, 490

function KeyboardPopup:ctor(iconWorldPos)
    self:setNodeEventEnabled(true)

    self.numStr_ = ""

    self:size(BG_W, BG_H)
    self:align(display.CENTER)

    local x = BG_W*0.5
    local bg = display.newScale9Sprite("#common/keyboard_new_bg.png", 0, 0, cc.size(BG_W, BG_H))
        :pos(BG_W*0.5, BG_H*0.5)
        :addTo(self)

    bg:setTouchEnabled(true)

    self.iconWorldPos_ = iconWorldPos --搜索图标的世界坐标

    local edit_y = BG_H - 57
    display.newSprite("#common/keyboard_editbox_bg.png")
        :flipX(true)
        :align(display.LEFT_CENTER, x, edit_y)
        :addTo(bg)

    display.newSprite("#common/keyboard_editbox_bg.png")
        :align(display.RIGHT_CENTER, x, edit_y)
        :addTo(bg)

    self.num_ = ui.newBMFontLabel({text = "", font = "fonts/keyboard.fnt"})
        :pos(x, edit_y + 12)
        :addTo(bg)


    self.tips_ =  ui.newTTFLabel({text = sa.LangUtil.getText("PRIVTE", "INPUTROOMIDTIPS"), size = 30})
        :opacity(100)
        :pos(x, edit_y)
        :addTo(bg)

    self.cursor_ = display.newSprite("#common/common_input_cursor.png")
        :pos(x, edit_y)
        :addTo(bg)

    self:startBlink_()

    KeyboardView.new(false, 6)
        :hideBg()
        :pos(x, 200)
        :addTo(bg)

    self.onEnterListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.KEYBOARD_POPUP_ENTER, handler(self, self.onEnterClicked_))
    self.onNumChangedListenerId_ = sa.EventCenter:addEventListener(tx.eventNames.KEYBOARD_POPUP_NUM_CHANGED, handler(self, self.onNumChanged_))
end

function KeyboardPopup:startBlink_()
    self.cursor_:show():runAction(cc.RepeatForever:create(cc.Blink:create(1, 1)))
    self.tips_:show()
end

function KeyboardPopup:stopBlink_()
    self.cursor_:hide():stopAllActions()
    self.tips_:hide()
end

function KeyboardPopup:onEnterClicked_()
    local tid = self.numStr_
    tid = tonumber(tid)
    if not tid then 
        tx.TopTipManager:showToast(sa.LangUtil.getText("PRIVTE", "INPUTROOMIDTIPS"))
        return
    end

    local gameId = 1
    tx.socket.HallSocket:searchRoom(gameId, tid)

    self:hidePanel()
end

function KeyboardPopup:onNumChanged_(evt)
    local text = evt.data
    self.numStr_ = text
    self:stopBlink_()
    if text == "" then
        self:startBlink_()
    end

    self.num_:setString(text)
end

function KeyboardPopup:showPanel()
    local tempLocalPt = self:convertToNodeSpace(self.iconWorldPos_)
    display.newSprite("#common/keyboard_arrow.png")
        :align(display.BOTTOM_CENTER, tempLocalPt.x, BG_H - 19)
        :addTo(self)

    display.newSprite("#common/btn_scene_search_down.png")
        :pos(tempLocalPt.x, tempLocalPt.y)
        :addTo(self)

    tx.PopupManager:addPopup(self, true, false, true, false)
end

function KeyboardPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function KeyboardPopup:onCleanup()
    sa.EventCenter:removeEventListener(self.onEnterListenerId_)
    sa.EventCenter:removeEventListener(self.onNumChangedListenerId_)
end

return KeyboardPopup