-- 好友列表元素
local FriendListItem = class("FriendListItem", sa.ui.ListItem)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local ITEM_W, ITEM_H = 808, 125
local BG_W, BG_H = 800, 122

function FriendListItem:ctor()
    self:setNodeEventEnabled(true)
    FriendListItem.super.ctor(self, ITEM_W, ITEM_H)
end

function FriendListItem:createContent_()
    local posY = BG_H/2

    local bg = display.newScale9Sprite("#common/pop_list_item_bg.png", 0, 0, cc.size(BG_W, BG_H))
        :pos(self.width_ * 0.5, ITEM_H/2)
        :addTo(self)

    --在线标记
    self.onLineIcon_ = display.newSprite("#dialogs/friend/friend_online_icon.png")
        :pos(20, posY)
        :addTo(bg)

    -- 头像
    self.avatar_ = SimpleAvatar.new()
        :pos(80, posY)
        :addTo(bg)
    NormalButton(self.avatar_):onButtonClicked(function()
        self:deleteFriendHandler()
    end)
    self.avatar_:setTouchSwallowEnabled(false)

    self.fbMark_ = display.newSprite("#dialogs/friend/friend_facenook_mark.png")
        :addTo(bg)
        :hide()

    self.lineMark_ = display.newSprite("#common/common_line_icon.png")
        :scale(0.6)
        :addTo(bg)
        :hide()

    local icon_x = 170
    self.sexIcon_ = display.newSprite("#common/common_sex_male.png")
        :align(display.LEFT_CENTER, icon_x, posY + 20)
        :scale(0.7)
        :addTo(bg)

    -- 昵称标签
    self.nick_ =  ui.newTTFLabel({text = "", size = 24})
        :align(display.LEFT_CENTER, icon_x + 40, posY + 20)
        :addTo(bg)

    display.newSprite("#common/common_chip_icon.png")
        :align(display.LEFT_CENTER, icon_x, posY - 20)
        :scale(0.7)
        :addTo(bg)

    -- 资产
    self.money_ =  ui.newTTFLabel({text = "", color = styles.FONT_COLOR.CHIP_TEXT, size = 24})
        :align(display.LEFT_CENTER, icon_x + 40, posY - 20)
        :addTo(bg)

    local btn_w, btn_h = 200, 104
    local btn_x = 530
    local btn_dir = 175

    -- 赠送按钮
    self.sendBtnNormalLabel_ = ui.newTTFLabel({text = sa.LangUtil.getText("FRIEND", "SEND_CHIP"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 20, align = ui.TEXT_ALIGN_CENTER})
    self.sendBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", self.sendBtnNormalLabel_)
        :pos(btn_x, posY)
        :onButtonClicked(buttontHandler(self, self.onSendClick_))
        :addTo(bg)
    self.sendBtn_:setTouchSwallowEnabled(false)

    -- 追踪按钮
    self.trackBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("RANKING", "TRACE_PLAYER"), color = styles.FONT_COLOR.LIGHT_TEXT, size = 20, align = ui.TEXT_ALIGN_CENTER}))
        :pos(btn_x + btn_dir, posY)
        :onButtonClicked(buttontHandler(self, self.onTraceClick_))
        :addTo(bg)
    self.trackBtn_:setTouchSwallowEnabled(false)

    --召回按钮
    self.recallBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png", disabled = "#common/btn_small_disabled.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("FRIEND", "RECALL_CHIP", sa.formatBigNumber(tx.userData.recallBackChips or 50000)), color = styles.FONT_COLOR.LIGHT_TEXT, size = 20, align = ui.TEXT_ALIGN_CENTER}))
        :pos(btn_x + btn_dir, posY)
        :onButtonClicked(buttontHandler(self, self.onRecallClick_))
        :addTo(bg)
        :hide()
    self.recallBtn_:setTouchSwallowEnabled(false)
end

function FriendListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)
    end

    if self.avatarDeactived_ and self.data_ then
        self:dealHead(self.data_)
    end
end

function FriendListItem:onItemDeactived()
    if self.created_ then
        if self.avatarLoaded_ then
            self.avatarLoaded_ = false
            self.avatarDeactived_ = true
            self.avatar_:setDefaultAvatar(self.data_.sex)
        end
    end
end

function FriendListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = true
    self.data_ = data
end

function FriendListItem:setData_(data)
    -- 设置头像
    if data.sex == "f" then
        self.sexIcon_:setSpriteFrame("common/common_sex_female.png")
        self.avatar_:setSpriteFrame("common/icon_female.png")
    else
        self.sexIcon_:setSpriteFrame("common/common_sex_male.png")
        self.avatar_:setSpriteFrame("common/icon_male.png")
    end

    local mark_x, mark_y = 105, BG_H/2 - 30
    if data.isFb == 1 then
        self.fbMark_:align(display.LEFT_CENTER, mark_x, mark_y):show()
        mark_x = mark_x + 30
    end
    
    if data.isLine == 1 then
        self.lineMark_:align(display.LEFT_CENTER, mark_x, mark_y):show()
    end

    -- 设置昵称
    self.nick_:setString(sa.limitNickLength(data.nick, 20))

    -- 资产设置
    self.money_:setString(sa.formatNumberWithSplit(data.money))

    self:dealHead(data)

    -- 设置赠送按钮
    if tx.userData.isSendChips and tx.userData.isSendChips == 0 then
        self.sendBtn_:hide()
    else
        self.sendBtn_:show()
        if data.send == 1 then
            self.sendBtn_:setButtonEnabled(true)
            self.sendBtnNormalLabel_:setString(sa.LangUtil.getText("FRIEND", "SEND_CHIP_WITH_NUM", sa.formatBigNumber(data.sdchip)))
        else
            self.sendBtn_:setButtonEnabled(false)
        end
    end

    -- 设置追踪按钮
    if data.serverGameid and data.serverTid and tonumber(data.serverGameid)>0 and tonumber(data.serverTid)>0 then
        data.isOnline = 1  -- 机器人online状态不对
        self.trackBtn_:setButtonEnabled(true)
    else
        self.trackBtn_:setButtonEnabled(false)
    end

    if data.isRecall == 1 then --0不需要召回 1需要召回
        self.recallBtn_:show()
        self.trackBtn_:hide()

        if data.isCanRecall == 0 then --每天只能点击一次召回  0不可点击 1可以点击
            self.recallBtn_:setButtonEnabled(false)
        else
            self.recallBtn_:setButtonEnabled(true)
        end
    else
        self.recallBtn_:hide()
        self.trackBtn_:show()
    end

    if data.isOnline == 0 then --0不在线 1在线
        self.onLineIcon_:setSpriteFrame("dialogs/friend/friend_offline_icon.png")
    else
        self.onLineIcon_:setSpriteFrame("dialogs/friend/friend_online_icon.png")
    end
end

function FriendListItem:dealHead(data)
    self.avatar_:setDefaultAvatar(data.sex)
    if data.img and string.len(data.img) > 5 then
        local imgurl = data.img
        if string.find(imgurl, "facebook") then
            if string.find(imgurl, "?") then
                imgurl = imgurl .. "&width=200&height=200"
            else
                imgurl = imgurl .. "?width=200&height=200"
            end
        end
        self.avatar_:loadImage(imgurl)
    end
end

function FriendListItem:onSendClick_()
    self.owner_.controller_:sendChip(self)
end

function FriendListItem:onSendChipSucc()
    tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "SEND_CHIP_SUCCESS", sa.formatNumberWithSplit(self.data_.sdchip)))
    tx.pushMsg(self.data_.uid," ", sa.LangUtil.getText("FRIEND","SEND_CHIP_PUSH",tx.userData.nick), true, 1)
    self.data_.send = 0
    self.sendBtn_:setButtonEnabled(false)
end

function FriendListItem:onTraceClick_()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = self.data_, isTrace = true})
    tx.PopupManager:removeAllPopup()
end

function FriendListItem:onRecallClick_()
    local lastLoginType = tx.userDefault:getStringForKey(tx.cookieKeys.LAST_LOGIN_TYPE)
    local data = {}
    table.insert(data, self.data_)
    -- if lastLoginType ==  "FACEBOOK" then
    --     if self.data_.isFb == 1 then --只能是FB -> FB之间才发FB消息 其他情况发推送
    --         self.owner_.controller_:recallFriend(data)
    --     else
    --         self.owner_.controller_:sendPushNews(self.data_.uid)
    --     end
    -- elseif lastLoginType == "GUEST" then
    --     self.owner_.controller_:sendPushNews(self.data_.uid)
    -- end

    self.owner_.controller_:sendPushNews(self.data_.uid)

    self.data_.isCanRecall = 0
    self.recallBtn_:setButtonEnabled(false) --每次打开界面，获取数据设置是否可以召回，只能点击一次，方便提醒玩家知道哪些已经召回
end

function FriendListItem:onCleanup()
end

function FriendListItem:deleteFriendHandler()
    if self.data_ and self.data_.uid~=tx.userData.uid then
        local OtherUserPopup = require("app.module.userInfo.OtherUserPopup")
        OtherUserPopup.new(self.data_):showPanel()
    end
end

return FriendListItem