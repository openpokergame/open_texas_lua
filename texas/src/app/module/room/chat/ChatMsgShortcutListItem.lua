local ChatMsgShortcutListItem = class("ChatMsgShortcutListItem", sa.ui.ListItem)

ChatMsgShortcutListItem.WIDTH = 0
ChatMsgShortcutListItem.HEIGHT = 0
ChatMsgShortcutListItem.ON_ITEM_CLICKED_LISTENER = nil

function ChatMsgShortcutListItem:ctor()
    ChatMsgShortcutListItem.super.ctor(self, ChatMsgShortcutListItem.WIDTH, ChatMsgShortcutListItem.HEIGHT)
    self.btn_ = cc.ui.UIPushButton.new({normal = "#common/transparent.png" , pressed = "#common/transparent.png"}, {scale9=true})
            :setButtonLabel(cc.ui.UILabel.new({text="", size=28, color=cc.c3b(0xff, 0xff, 0xff)}))
            :setButtonSize(ChatMsgShortcutListItem.WIDTH, ChatMsgShortcutListItem.HEIGHT)
            :onButtonPressed(function(evt) 
                    self.btnPressedY_ = evt.y
                    self.btnClickCanceled_ = false
                end)
            :onButtonRelease(function(evt)
                    if math.abs(evt.y - self.btnPressedY_) > 5 then
                        self.btnClickCanceled_ = true
                    end
                end)
            :onButtonClicked(function(evt)
                    if not self.btnClickCanceled_ and ChatMsgShortcutListItem.ON_ITEM_CLICKED_LISTENER and self:getParent():getParent():getCascadeBoundingBox():containsPoint(cc.p(evt.x, evt.y)) then
                        ChatMsgShortcutListItem.ON_ITEM_CLICKED_LISTENER(self.data_,self:getIndex())
                    end
                end)
    self.btn_:setTouchSwallowEnabled(false)
    self.btn_:pos(ChatMsgShortcutListItem.WIDTH * 0.5, ChatMsgShortcutListItem.HEIGHT * 0.5)
    self.btn_:addTo(self)
    display.newScale9Sprite("#dialogs/chat/room_chat_left_line.png", ChatMsgShortcutListItem.WIDTH * 0.5-1, 0, cc.size(ChatMsgShortcutListItem.WIDTH, 2)):addTo(self)
end

function ChatMsgShortcutListItem:onDataSet(dataChanged, data)
    if dataChanged then
        -- self.btn_:setButtonLabelString(data)
        local label = self.btn_:getButtonLabel("normal")
        label:setString(data)
        if label:getContentSize().width > (ChatMsgShortcutListItem.WIDTH - 20) then
            label:setDimensions(ChatMsgShortcutListItem.WIDTH - 20, 0)
        end
    end
end

return ChatMsgShortcutListItem