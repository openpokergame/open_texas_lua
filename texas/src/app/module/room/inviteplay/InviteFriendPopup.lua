local InviteFriendPopup = class("InviteFriendPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 570
local IMAGE = {
    "#common/share_sdk_whatsapp_icon.png",
    "#common/exchange_code_sms_btn.png",
    "#common/share_sdk_line_icon.png",
    "#common/share_sdk_facebookmessenger_icon.png"
}
function InviteFriendPopup:ctor()
    InviteFriendPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitleStyle(sa.LangUtil.getText("HALL", "INVITE_TITLE"), true)
    -- 分享数据
    local type = consts.PUSH_TYPE.PUSH_INVITE_PLAY
    local gameId = tx.socket.HallSocket.curGameId
    local tid = tx.socket.HallSocket.curTid
    local gameLevel = tx.socket.HallSocket.curGameLevel
    local pwd = tx.socket.HallSocket.curGamePwd
    local feedData
    if gameLevel==tx.config.TEXAS_PRI_ROOM_LEVEL then -- 私人房
        if not pwd or pwd == "" then
            feedData = clone(sa.LangUtil.getText("FEED", "NO_PWD_PRIVATE_ROOM"))
            feedData.name = sa.LangUtil.formatString(feedData.name, tid)
            feedData.link = feedData.link.."&type="..type.."&gameId="..gameId.."&tid="..tid.."&gameLevel="..gameLevel
        else
            feedData = clone(sa.LangUtil.getText("FEED", "PRIVATE_ROOM"))
            feedData.name = sa.LangUtil.formatString(feedData.name, tid, pwd)
            feedData.link = feedData.link.."&type="..type.."&gameId="..gameId.."&tid="..tid.."&gameLevel="..gameLevel.."&pwd="..pwd
        end
    else
        feedData = clone(sa.LangUtil.getText("FEED", "NORMAL_ROOM_INVITE"))
        local gameList = sa.LangUtil.getText("COMMON", "GAME_NAMES")
        local gameName = gameList[gameId] or ""
        feedData.name = sa.LangUtil.formatString(feedData.name, gameName, tid)
        feedData.link = feedData.link.."&type="..type.."&gameId="..gameId.."&tid="..tid.."&gameLevel="..gameLevel
    end
    self.feedData_ = feedData

    local bg = self.background_

    ui.newTTFLabel({text = sa.LangUtil.getText("FRIEND", "ROOM_INVITE_PLAY_DES"), size = 30, color = cc.c3b(0xab, 0xa9, 0xfc), dimensions = cc.size(660, 0)})
        :pos(WIDTH/2, HEIGHT/2 + 30)
        :addTo(bg)

    local sx = 135
    local dir = 187
    local y = 118
    self.btnList_ = {}
    for i = 1, 4 do
        local btn = cc.ui.UIPushButton.new(IMAGE[i])
            :onButtonPressed(function(evt)
                evt.target.light:show()
            end)
            :onButtonRelease(function(evt)
                evt.target.light:hide()
            end)
            :onButtonClicked(handler(self, self.onShareClicked_))
            :pos(sx + (i - 1) * dir, y)
            :addTo(bg)

        btn:setTag(i)

        btn.light = display.newSprite("#common/common_share_light.png")
            :addTo(btn, cc.ui.UIPushButton.IMAGE_ZORDER - 1)
            :hide()
        self.btnList_[i] = btn
    end
    -- 删除SMS
    local sid = appconfig.SID[string.upper(device.platform)]
    if sid==19 or sid==20 then  --俄语版 短信 改为 VK分享
        self.btnList_[2]:hide()
        local xx,yy = self.btnList_[2]:getPosition()

        local i = 5
        local btn = cc.ui.UIPushButton.new("vk_share_btn.png")
            :onButtonPressed(function(evt)
                evt.target.light:show()
            end)
            :onButtonRelease(function(evt)
                evt.target.light:hide()
            end)
            :onButtonClicked(handler(self, self.onShareClicked_))
            :pos(xx,yy)
            :addTo(bg)
        btn:setTag(i)

        btn.light = display.newSprite("#common/common_share_light.png")
            :addTo(btn, cc.ui.UIPushButton.IMAGE_ZORDER - 1)
            :hide()
        self.btnList_[i] = btn
        
    elseif tx.config.SHOW_SMS~=1 then -- 删除SMS
        self.btnList_[2]:hide()
        local list = clone(self.btnList_)
        table.remove(list, 2)
        local newDir = dir*(#self.btnList_-1)/(#list-1)
        for k,v in pairs(list) do
            v:setPositionX(sx + (k - 1) * newDir)
        end
    end
end

function InviteFriendPopup:onShareClicked_(evt)
    local tag = evt.target:getTag()
    local feedData = self.feedData_
    if tag == 1 then
        tx.ShareSDK:shareByWhatsApp(feedData)
    elseif tag == 2 then
        tx.ShareSDK:shareByShortMessage(feedData)
    elseif tag == 3 then
        tx.ShareSDK:shareByLine(feedData)
    elseif tag == 4 then
        tx.ShareSDK:shareByFacebookMessenger(feedData)
    elseif tag == 5 then
        tx.ShareSDK:shareByVK(feedData)
    end
end

function InviteFriendPopup:showPanel()
    tx.PopupManager:addPopup(self)
end

function InviteFriendPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function InviteFriendPopup:onCleanup()
end

return InviteFriendPopup