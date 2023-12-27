local ChatMsgToListItem = class("ChatMsgToListItem", sa.ui.ListItem)
local SimpleAvatar  = import("openpoker.ui.SimpleAvatar")
--need to be set before creating instances
ChatMsgToListItem.WIDTH = 0
ChatMsgToListItem.HEIGHT = 0
ChatMsgToListItem.ON_ITEM_CLICKED_LISTENER = nil

function ChatMsgToListItem:ctor()
    self:setNodeEventEnabled(true)
    ChatMsgToListItem.super.ctor(self, ChatMsgToListItem.WIDTH, ChatMsgToListItem.HEIGHT)
    self.btn_ = cc.ui.UIPushButton.new({normal = "#common/transparent.png" , pressed = "#common/transparent.png"}, {scale9=true})
        :setButtonSize(ChatMsgToListItem.WIDTH, ChatMsgToListItem.HEIGHT)
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
                if not self.btnClickCanceled_ and ChatMsgToListItem.ON_ITEM_CLICKED_LISTENER and self:getParent():getParent():getCascadeBoundingBox():containsPoint(cc.p(evt.x, evt.y)) then
                    ChatMsgToListItem.ON_ITEM_CLICKED_LISTENER(self.data_)
                end
            end)
    self.btn_:setTouchSwallowEnabled(false)
    self.btn_:pos(ChatMsgToListItem.WIDTH * 0.5, ChatMsgToListItem.HEIGHT * 0.5)
    self.btn_:addTo(self)

    self.userAvatar_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
        :pos(ChatMsgToListItem.WIDTH*0.5-96, ChatMsgToListItem.HEIGHT*0.5)
        :scale(0.55)
        :addTo(self)

    self.userNameTxt_ = ui.newTTFLabel({
            text="",
            color=cc.c3b(0xff, 0xff, 0xff),
            size=28,
            align = ui.TEXT_ALIGN_LEFT,
        })
        :align(display.CENTER_LEFT)
        :pos(ChatMsgToListItem.WIDTH*0.5-20, ChatMsgToListItem.HEIGHT*0.5)
        :addTo(self)

    display.newScale9Sprite("#dialogs/chat/room_chat_fast_line.png", ChatMsgToListItem.WIDTH * 0.5, 0, cc.size(ChatMsgToListItem.WIDTH, 2)):addTo(self)
end

function ChatMsgToListItem:onDataSet(dataChanged, data)
    if dataChanged then
        local imgurl = data.img
        if not imgurl or string.len(imgurl) <= 5 then
            self.userAvatar_:setDefaultAvatar(data.sex)
        else
            if string.find(imgurl, "facebook") then
                if string.find(imgurl, "?") then
                    imgurl = imgurl .. "&width=200&height=200"
                else
                    imgurl = imgurl .. "?width=200&height=200"
                end
            end
            self.userAvatar_:loadImage(imgurl)
        end
        
        self.userNameTxt_:setString(data.nick)
    end
end

return ChatMsgToListItem