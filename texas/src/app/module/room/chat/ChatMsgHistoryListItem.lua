local ChatMsgHistoryListItem = class("ChatMsgHistoryListItem", sa.ui.ListItem)

ChatMsgHistoryListItem.WIDTH = 0
ChatMsgHistoryListItem.HEIGHT = 64

local WIDTH, HEIGHT = 0, 64

function ChatMsgHistoryListItem:ctor()
    WIDTH, HEIGHT = ChatMsgHistoryListItem.WIDTH, ChatMsgHistoryListItem.HEIGHT
    ChatMsgHistoryListItem.super.ctor(self, WIDTH, HEIGHT)
    self.label_ = ui.newTTFLabel({text="", size=26, color=cc.c3b(0xff, 0xff, 0xff),dimensions=cc.size(WIDTH-20, 0), align=ui.TEXT_ALIGN_LEFT})
        :pos(WIDTH * 0.5, HEIGHT * 0.5)
        :addTo(self)
end

function ChatMsgHistoryListItem:onDataSet(dataChanged, data)
    if dataChanged then
        local msg = data.messageContent or ""
        self.label_:setString(msg)
        if data.mtype == 1 then-- 大喇叭
            self.label_:setTextColor(cc.c3b(0x1f, 0xd7, 0xff))
        elseif data.mtype == 2 then-- 普通聊天消息
            self.label_:setTextColor(cc.c3b(0xff, 0xff, 0xff))
        end

        if string.find(msg, "@") then
            self.label_:setTextColor(cc.c3b(0xff, 0xe3, 0x62))
        end
        if data.url and string.len(data.url)>0 then --语音聊天
            if not self.voiceNode_ then
                self.voiceNode_ = display.newNode()
                    :addTo(self)

                self.voiceLabel_ = ui.newTTFLabel({text="", size=26, color=cc.c3b(0xff, 0xff, 0xff), align=ui.TEXT_ALIGN_LEFT})
                    :align(display.LEFT_CENTER)
                    :addTo(self.voiceNode_)

                self.voiceBg_ = display.newSprite("#dialogs/chat/bg_voice.png")--display.newScale9Sprite("#dialogs/chat/bg_voice.png", 0, 0, cc.size(126, 56))
                    :align(display.LEFT_CENTER)
                    :addTo(self.voiceNode_)

                local VoicePlayAnim = require("app.pokerUI.VoicePlayAnim")
                self.voiceAnim_ = VoicePlayAnim.new(data,2):pos(32, 30):addTo(self.voiceBg_)
            end
            self.voiceNode_:show()
            self.label_:hide()
            -- 重新赋值
            self.voiceLabel_:setString(self.label_:getString())
            self.voiceLabel_:setSystemFontSize(self.label_:getSystemFontSize())
            self.voiceLabel_:setTextColor(self.label_:getTextColor())
            local csize = self.voiceLabel_:getContentSize()
            self.voiceAnim_:setVoiceData(data)

            local x, y = 10, csize.height * 0.5
            self.voiceLabel_:pos(x, y)
            x = x + csize.width + 10
            if x > WIDTH - 60 then
                x = WIDTH - 60
            end
            self.voiceBg_:pos(x, y)
            self:setContentSize(cc.size(WIDTH, HEIGHT))
        else
            if self.voiceNode_ then
                self.voiceNode_:hide()
            end
            self.label_:show()
            local csize = self.label_:getContentSize()
            self.label_:pos(WIDTH * 0.5, csize.height * 0.5)
            self:setContentSize(cc.size(WIDTH, csize.height + 12))            
        end
    end
end

return ChatMsgHistoryListItem