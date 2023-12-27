local MessageListItem = class("MessageListItem", sa.ui.ListItem)
local MessageData   = import("app.module.message.MessageData")
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local logger = sa.Logger.new("MessageListItem")

local CONTENT_COLOR_READED = cc.c3b(0x77, 0x72, 0xcd)

local ITEM_W, ITEM_H = 808, 125
local BG_W, BG_H = 800, 122
local AVATAR_SIZE = 50
local FRIEND_MESSAGE = 1
local SYSTEM_MESSAGE = 2

local NORMAL_MESSAGE = 1 --普通消息
local GET_REWARD_MESSAGE = 2 --普通领奖消息
local SEND_CHIPS_MESSAGE = 3 --回赠好友筹码消息

MessageListItem.MESSAGE_TYPE = FRIEND_MESSAGE

function MessageListItem:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self:setNodeEventEnabled(true)
    MessageListItem.super.ctor(self, ITEM_W, ITEM_H)
end

function MessageListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self.dataChanged_ = true
        local posY = BG_H/2
        self.frame_ = display.newScale9Sprite("#common/pop_list_item_bg.png", ITEM_W/2, ITEM_H/2, cc.size(BG_W, BG_H)):addTo(self)
        local frame = self.frame_

        self.icon_ = SimpleAvatar.new({
                shapeImg = "#common/modal_texture.png",
                frameImg = "#common/transparent.png",
                scale9 = 1,
                offsetSize = 0,
                size = AVATAR_SIZE
            })
            :pos(58, posY)
            :addTo(frame)

        self.content_ = ui.newTTFLabel({text = "", size = 24})
            :align(display.LEFT_CENTER, 120, posY + 18)
            :addTo(frame)
        self.cDefaultH_ = self.content_:getContentSize().height

        self.time_ = ui.newTTFLabel({text = "", color = styles.FONT_COLOR.DIAMOND, size = 24})
            :align(display.LEFT_CENTER, 120, posY - 18)
            :addTo(frame)

        -- 领取奖励
        local btn_w, btn_h = 200, 104
        local btn_x, btn_y = BG_W - 100, posY
        self.getRewardBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png", disabled = "#common/btn_small_disabled.png"},{scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :onButtonClicked(handler(self, self.onGetRewardClicked_))
            :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "GET_REWARD"), size = 26}))
            :pos(btn_x, btn_y)
            :addTo(frame)
            :hide()
        self.getRewardBtn_:setTouchSwallowEnabled(false)

        -- 回赠奖励
        self.sendChipBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png", disabled = "#common/btn_small_disabled.png"},{scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :onButtonClicked(handler(self, self.onSendChipClicked_))
            :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("MESSAGE", "SEND_CHIP"), size = 26}))
            :pos(btn_x, btn_y)
            :addTo(frame)
            :hide()
        self.sendChipBtn_:setTouchSwallowEnabled(false)
        -- 文字超出
        local label = self.getRewardBtn_:getButtonLabel("normal")
        local label1 = self.sendChipBtn_:getButtonLabel("normal")
        sa.fitSprteWidth(label, 150)
        sa.fitSprteWidth(label1, 150)

        self:setTouchEnabled(true)
        self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onMessageClick_))
        self:setTouchSwallowEnabled(false)
    end
    -- 外部数据 一键领取的时候不刷新问题
    if self.data_ and self.dataChanged_ then
        self.dataChanged_ = false
        local data = self.data_
        if data.img then
            self.icon_:setDefaultAvatar(data.img)
            if data.img=="m" then
                
            else
                self.icon_:loadImage(data.img)
            end
        end

        self.time_:setString(sa.TimeUtil:getMessageTime(data.createtime))

        if tonumber(data.btntype) == GET_REWARD_MESSAGE then
            self.content_:setDimensions(500,0)
        elseif tonumber(data.btntype) == SEND_CHIPS_MESSAGE then
            self.content_:setDimensions(500,0)
        else
            self.content_:setDimensions(660,0)
        end

        if data.content then
            self.content_:setString(data.content)
        end

        -- 重新调整坐标
        local curH_ = self.content_:getContentSize().height
        local curSelfHeight = ITEM_H
        if curH_>self.cDefaultH_ then
            curSelfHeight = (curH_-self.cDefaultH_) + ITEM_H
        end
        local posY = curSelfHeight/2
        self.frame_:setContentSize(cc.size(BG_W,curSelfHeight-2))
        self.frame_:pos(ITEM_W/2, posY)

        self.icon_:setPositionY(posY)

        self.content_:setPositionY(posY + 18)

        self.time_:setPositionY(posY - 18-(curSelfHeight-ITEM_H)*0.5)

        self.getRewardBtn_:setPositionY(posY)
        self.sendChipBtn_:setPositionY(posY)

        local preSize = self:getContentSize()
        self:setContentSize(cc.size(BG_W, curSelfHeight))
        if preSize.height~=curSelfHeight then
            self:dispatchEvent({name="RESIZE"})
        end
    end
    -- 一键领取状态不修复BUG
    if self.data_ then
        self:changeMSGShowState()
    end
end

function MessageListItem:changeMSGShowState()
    local data = self.data_
    if data.img then  --有头像的

    else
        if tonumber(data.status) == 2 and tonumber(data.btntype) == NORMAL_MESSAGE then
            self.icon_:setSpriteFrame("common/message_already_read.png")
        else
            self.icon_:setSpriteFrame("common/message_no_read.png")
        end
    end
    if tonumber(data.status) == 2 then
        self.content_:setTextColor(CONTENT_COLOR_READED)
        self.time_:setTextColor(CONTENT_COLOR_READED)
    else
        self.content_:setTextColor(cc.c3b(0xff, 0xff, 0xff))
        self.time_:setTextColor(styles.FONT_COLOR.DIAMOND)
    end
    self.getRewardBtn_:hide()
    self.sendChipBtn_:hide()
    if tonumber(data.btntype) == GET_REWARD_MESSAGE then
        self.getRewardBtn_:show()
        self.sendChipBtn_:hide()
    elseif tonumber(data.btntype) == SEND_CHIPS_MESSAGE then
        self:showSendStatus()
    end
end

function MessageListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = dataChanged
    self.data_ = data
end

--设置已读文本状态，并检测是否有新消息
function MessageListItem:setReadedTextStatus_()
    self.data_.status = 2
    self.content_:setTextColor(CONTENT_COLOR_READED)
    self.time_:setTextColor(CONTENT_COLOR_READED)
end

function MessageListItem:onMessageClick_()
    local data = self.data_
    if tonumber(data.btntype) == NORMAL_MESSAGE and tonumber(data.status) == 1 then
        data.status = 2
        MessageData.pushReadedNews(data.id)
        if data.msgType == FRIEND_MESSAGE then
            MessageData.redFriendMessage()
        else
            MessageData.redSystemMessage()
        end

        if not self.icon_ then return; end  -- UI已经删除
        
        self:setReadedTextStatus_()
        if not data.img then
            self.icon_:setSpriteFrame("common/message_already_read.png")
        end
    end
end

function MessageListItem:onGetRewardClicked_()
    self.getRewardBtn_:setButtonEnabled(false)
    -- 破产领奖
    if self.data_.isBroke==true then
        sa.HttpService.POST(
            {
                mod = "Broke",
                act = "reward",
            },
            function (data)
                local jsonData = json.decode(data)
                if jsonData and jsonData.code == 1 then
                    tx.setBroken(nil)
                    tx.userData.money = tx.userData.money+tonumber(jsonData.money)
                    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=jsonData.money}})
                    tx.TopTipManager:showGoldTips(sa.LangUtil.getText("COMMON", "REWARD_TIPS", jsonData.money))
                    MessageData.getSystemReward()
                    self.data_.btntype = 1

                    if not self.icon_ then return; end  -- UI已经删除

                    self.getRewardBtn_:hide()
                    self.content_:setTextColor(CONTENT_COLOR_READED)
                    self.time_:setTextColor(CONTENT_COLOR_READED)
                    if not self.data_.img then
                        self.icon_:setSpriteFrame("common/message_already_read.png")
                    end
                end
            end,
            function()
            end)
    else
        sa.HttpService.POST(
        {
            mod = "News",
            act = "userReward",
            newsid = self.data_.id
        },
        function (data)
            local jsonData = json.decode(data)
            if jsonData.code == 1 then
                local evtData = {} -- 动画
                local money = tonumber(jsonData.money)
                local diamonds = tonumber(jsonData.diamonds)
                local props = tonumber(jsonData.props)
                local exp = tonumber(jsonData.exp)
                local speakers = tonumber(jsonData.speakers)
                local rewardType = ""
                if money > 0 then
                    tx.userData.money = tx.userData.money + money
                    evtData.money = money
                    rewardType = "FORMAT_CHIP"
                end

                if diamonds > 0 then
                    tx.userData.diamonds = tx.userData.diamonds + diamonds
                    evtData.diamonds = diamonds
                    rewardType = "FORMAT_DIAMONDS"
                end

                if props > 0 then
                    evtData.props = props
                    rewardType = "FORMAT_PROP"
                end

                if speakers > 0 then
                    evtData.speakers = speakers
                    rewardType = "FORMAT_DLB"
                end

                if exp > 0 then
                    evtData.exp = exp
                end

                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
                if jsonData.type < 4 or jsonData.type > 4 then -- 1为游戏币,2为道具,3钻石,4经验
                    local desc = sa.LangUtil.getText("STORE", rewardType, sa.formatNumberWithSplit(jsonData.num))
                    tx.TopTipManager:showGoldTips(sa.LangUtil.getText("COMMON", "REWARD_TIPS", desc))
                end

                if self.data_.msgType == FRIEND_MESSAGE then
                    self.data_.btntype = SEND_CHIPS_MESSAGE  -- 领取完好友消息哦
                    MessageData.getFriendReward()
                else
                    MessageData.getSystemReward()
                end

                if not self.icon_ then return; end  -- UI已经删除

                self:showSendStatus()
                self:setReadedTextStatus_()
                if not self.data_.img then
                    self.icon_:setSpriteFrame("common/message_already_read.png")
                end
            else
                if not self.icon_ then return; end  -- UI已经删除
                self.getRewardBtn_:setButtonEnabled(true)
            end
        end,
        function()
            if not self.icon_ then return; end  -- UI已经删除
            self.getRewardBtn_:setButtonEnabled(true)
        end)
    end
end

function MessageListItem:onSendChipClicked_()
    self.getRewardBtn_:setButtonEnabled(false)
    sa.HttpService.POST(
        {
            mod = "Friend",
            act = "sendMoneyToFriend",
            fuid = self.data_.newsfrom
        },
        handler(self, self.onSendChip_),
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_SEND_FRIEND_CHIP"))
        end
    )
end

function MessageListItem:onSendChip_(data)
    local retData = json.decode(data)

    if retData.code == 1 then
        local sendMoney = tonumber(retData.money) or 0
        tx.userData.money = tx.userData.money - sendMoney
        sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=(-sendMoney)}})

        if not self.icon_ then return; end  -- UI已经删除

        self:hideSendStatus()
        local list = self:getOwner()
        if list.onUpdateSendStatusListener then
            list.onUpdateSendStatusListener(tonumber(self.data_.newsfrom))
        end
    else
        if not self.icon_ then return; end  -- UI已经删除

        if retData.code == -3 then-- 没钱了
            tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "SEND_CHIP_TOO_POOR"))
        elseif retData.code == -2 then-- 赠送次数用完
            -- 已经赠送过了
            self:hideSendStatus()
            local list = self:getOwner()
            if list.onUpdateSendStatusListener then
                list.onUpdateSendStatusListener(tonumber(self.data_.newsfrom))
            end

            tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "SEND_CHIP_COUNT_OUT"))
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "EXCEPTION_SEND_FRIEND_CHIP"))
        end
    end
end

function MessageListItem:isShowSendButton_()
    if tonumber(self.data_.btntype) == SEND_CHIPS_MESSAGE then
        if self.data_.msgType == FRIEND_MESSAGE then
            local uid = tonumber(self.data_.newsfrom)
            local list = MessageData.sendMoneyToFriendList
            for _, v in ipairs(list) do
                if tonumber(v) == uid then
                    return false
                end
            end

            return true
        end
        return true
    end

    return false
end

function MessageListItem:showSendStatus()
    if self:isShowSendButton_() then
        self.data_.btntype = SEND_CHIPS_MESSAGE

        self.getRewardBtn_:hide()
        self.sendChipBtn_:show()
    else
        self:hideSendStatus()
    end
end

function MessageListItem:hideSendStatus()
    self.data_.btntype = NORMAL_MESSAGE

    self.getRewardBtn_:hide()
    self.sendChipBtn_:hide()
end

function MessageListItem:onCleanup()
    
end

return MessageListItem
