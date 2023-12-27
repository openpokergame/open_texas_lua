local MessagePopup = class("MessagePopup", tx.ui.Panel)
local MessageListItem = import(".MessageListItem")
local MessageData = import(".MessageData")

local WIDTH, HEIGHT = 1136, 746
local RIGHT_FRAME_W, RIGHT_FRAME_H = 820, 590
local FRIEND_MESSAGE = 1
local SYSTEM_MESSAGE = 2

local logger = sa.Logger.new("MessagePopup")

function MessagePopup:ctor()
    MessagePopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setNodeEventEnabled(true)

    self.currentFriPage_ = 1
    self.currentSysPage_ = 1
    self.maxFriPage_ = false
    self.maxSysPage_ = false
    self.isRewardSys_ = 0 --是否有系统领奖消息: 1有 0没有
    self.isRewardFri_ = 0 --是否有好友领奖消息: 1有 0没有
    self.selectedTab_ = FRIEND_MESSAGE
    self.this_ = self

    MessageListItem.MESSAGE_TYPE = FRIEND_MESSAGE

    self:setImgTitleStyle("#lang/pop_title_message.png")

    self:addLeftNode_()

    self:addRightNodes_()

    self.onNewMessageDataObserver = sa.DataProxy:addDataObserver(tx.dataKeys.NEW_MESSAGE, handler(self, self.updateNewMessagePoint_))
    self.updateOneKeyButtonStatusId_ = sa.EventCenter:addEventListener("UPDATE_MESSAGE_ONE_KEY_STATUS", handler(self, self.updateOneKeyButtonStatus_))
    -- 拉数据  保证 红点数量先拉取回来
    MessageData.requestMessageData()
    self:onMainTabChange_(self.selectedTab_)
end

--添加切换Tab
function MessagePopup:addLeftNode_()
    self:setMainTabStyle(sa.LangUtil.getText("MESSAGE", "TAB_TEXT"), self.selectedTab_, handler(self, self.onMainTabChange))

    local bg = self.background_
    local point_x, point_y = 285, HEIGHT - 130
    local dir = 100
    self.newFriendMessagePoint = display.newSprite("#common/common_red_point.png")
        :pos(point_x, point_y)
        :addTo(bg, 2)
        :hide()

    self.newSystemMessagePoint = display.newSprite("#common/common_red_point.png")
        :pos(point_x, point_y - dir)
        :addTo(bg, 2)
        :hide()
end

function MessagePopup:addRightNodes_()
    local bg_w, bg_h = RIGHT_FRAME_W, RIGHT_FRAME_H
    local bg = display.newScale9Sprite("#common/pop_right_sec_frame.png", 0, 0, cc.size(bg_w, bg_h))
        :align(display.RIGHT_BOTTOM, WIDTH - 28, 30)
        :addTo(self.background_)

    local list_w, list_h = 808, 460
    local x, y = bg_w/2, bg_h/2 + 58
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h),
            upRefresh = handler(self, self.requestMessageDataPage_)
        }, 
        MessageListItem
    )
    :pos(x, y)
    :addTo(bg)

    self.list_.onUpdateSendStatusListener = handler(self, self.filterSameSendButtonStatus_)

    self.noDataTips_ = self:createNoDataTips(sa.LangUtil.getText("MESSAGE", "EMPTY_PROMPT")):hide()

    -- 一键领取
    local btn_x, btn_y = bg_w*0.5, 65
    local btn_w, btn_h = 280, 104
    self.oneKeyGetRewardBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_yellow.png", pressed = "#common/btn_small_yellow_down.png", disabled = "#common/btn_small_disabled.png"},{scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :onButtonClicked(handler(self, self.onOneKeyGetRewardClicked_))
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("MESSAGE", "ONE_KEY_GET"), size = 26}))
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()

    -- 一键领取并回赠
    self.oneKeyGetAndSendBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_small_blue.png", pressed = "#common/btn_small_blue_down.png", disabled = "#common/btn_small_disabled.png"},{scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :onButtonClicked(handler(self, self.onOneKeyGetAndSendClicked_))
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("MESSAGE", "ONE_KEY_GET_AND_SEND"), size = 26}))
        :pos(btn_x, btn_y)
        :addTo(bg)
        :hide()
    -- 文字超出
    local label = self.oneKeyGetRewardBtn_:getButtonLabel("normal")
    local label1 = self.oneKeyGetAndSendBtn_:getButtonLabel("normal")
    sa.fitSprteWidth(label, 235)
    sa.fitSprteWidth(label1, 235)
end

function MessagePopup:onMainTabChange(evt)
    self:onMainTabChange_(evt.selected)
end

function MessagePopup:onMainTabChange_(selectedTab)
    self.selectedTab_ = selectedTab
    if self.selectedTab_ == FRIEND_MESSAGE then
        if self.friendData then
            self:setListData()
        else
            self:firstRequestMessageData_()
        end
    else
        if self.systemData then
            self:setListData()
        else
            self:firstRequestMessageData_()
        end
    end
end

function MessagePopup:firstRequestMessageData_()
    self.noDataTips_:hide()
    self.list_:setData(nil)
    self:setLoading(true)
    self:requestMessageDataPage_()
end

function MessagePopup:updateNewMessagePoint_()
    if MessageData.hasFriendMessage > 0 then
        self.newFriendMessagePoint:show()
    else
        self.newFriendMessagePoint:hide()
    end

    if MessageData.hasSystemMessage > 0 then
        self.newSystemMessagePoint:show()
    else
        self.newSystemMessagePoint:hide()
    end
end

function MessagePopup:onShowed()
    self.list_:setScrollContentTouchRect()
end

-- 使用分页加载模型请求数据
function MessagePopup:requestMessageDataPage_()
    if self.selectedTab_ == FRIEND_MESSAGE then
        if not self.maxFriPage_ and not self.requestingFri_ then
            self.requestingFri_ = true
            self:setLoading(true)
            sa.HttpService.CANCEL(self.getCurrentFriPageId_)
            self.getCurrentFriPageId_ = sa.HttpService.POST(
                {
                    mod = "News",
                    act = "getUserNews",
                    p = self.currentFriPage_,
                    newstype = 2
                },
                function(data)
                    self:onGetMessageDataPage_(data,2)
                    self.requestingFri_ = nil
                end,
                function ()
                    logger:debug("get_message_friend_data: fail")
                    self.requestingFri_ = nil
                end
            )
        end
    else
        if not self.maxSysPage_ and not self.requestingSys_ then
            self.requestingSys_ = true
            self:setLoading(true)
            sa.HttpService.CANCEL(self.getCurrentSysPageId_)
            self.getCurrentSysPageId_ = sa.HttpService.POST(
                {
                    mod = "News",
                    act = "getUserNews",
                    p = self.currentSysPage_,
                    newstype = 1
                },
                function(data)
                    self:onGetMessageDataPage_(data,1)
                    self.requestingSys_ = nil
                end,
                function ()
                    logger:debug("get_message_sys_data: fail")
                    self.requestingSys_ = nil
                end
            )
        end
    end
end

function MessagePopup:onGetMessageDataPage_(data,type)
    if not self.this_ then
        return true
    end

    self:setLoading(false)

    if data then
        local jsonData = json.decode(data)
        if jsonData.code and jsonData.code > 0 then
            -- 模拟数据
            if type==2 then
                if not self.friendData then self.friendData = {} end
            else
                if not self.systemData then self.systemData = {} end
            end
            if jsonData.red then -- 红点 系统一键领取 好友一键领取在MessageData接口中获取
                
            end
            MessageData.sendMoneyToFriendList = jsonData.sendMoneyToFriendList

            if jsonData.newslist and #jsonData.newslist > 0 then
                if type == 2 then
                    self.currentFriPage_ = self.currentFriPage_ + 1
                    for i = 1, #jsonData.newslist do
                        jsonData.newslist[i].msgType = FRIEND_MESSAGE
                        self.friendData[#self.friendData + 1] = jsonData.newslist[i]
                    end
                else
                    self.currentSysPage_ = self.currentSysPage_ + 1
                    for i = 1, #jsonData.newslist do
                        jsonData.newslist[i].msgType = SYSTEM_MESSAGE
                        self.systemData[#self.systemData + 1] = jsonData.newslist[i]
                    end
                end
            else
                if type == 2 then
                    self.maxFriPage_ = true
                else
                    self.maxSysPage_ = true
                end
            end
        end
        self:setListData(true)
        return true
    end
    return false
end

function MessagePopup:oneKeyGetReward_(newstype, callback)
    self:setLoading(true)
    sa.HttpService.POST(
        {
            mod = "News",
            act = "getNewsReward",
            newstype = newstype,
        },
        function(data)
            local retData = json.decode(data)
            callback(retData)
        end,
        function ()
        end)
end

function MessagePopup:onOneKeyGetRewardClicked_()
    self.oneKeyGetRewardBtn_:hide()
    self:oneKeyGetReward_(1, function(data)
        if not self.this_ then
            return
        end

        self:setLoading(false)
        if data.code == 1 then
            local desc = sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatNumberWithSplit(data.money))
            tx.TopTipManager:showGoldTips(sa.LangUtil.getText("COMMON", "REWARD_TIPS", desc))

            self.isRewardSys_ = 0
            self:updateMessageStatus_(self.systemData)
            self:playAddMoneyAnimation_(data.money)

            MessageData.oneKeyGetSystemReward()
        else
            self.oneKeyGetRewardBtn_:show()
        end
    end)
end

function MessagePopup:onOneKeyGetAndSendClicked_()
    self.oneKeyGetAndSendBtn_:hide()
    self:oneKeyGetReward_(2, function(data)
        if not self.this_ then
            return
        end

        self:setLoading(false)
        if data.code == 1 then
            local desc1 = sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatNumberWithSplit(data.money))
            local desc2 = sa.LangUtil.getText("STORE", "FORMAT_CHIP", sa.formatNumberWithSplit(data.givemoney))
            tx.TopTipManager:showGoldTips(sa.LangUtil.getText("MESSAGE", "GET_REWARD_TIPS", desc1, desc2))

            self.isRewardFri_ = 0
            self:updateMessageStatus_(self.friendData)

            local money = data.money - data.givemoney
            if money > 0 then
                self:playAddMoneyAnimation_(money)
            end

            MessageData.oneKeyGetFriendReward()
        else
            self.oneKeyGetAndSendBtn_:show()
        end
    end)
end

function MessagePopup:playAddMoneyAnimation_(money)
    local evtData = {}
    tx.userData.money = tx.userData.money + money
    evtData.money = money
    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
end

--过滤相同好友赠送按钮状态显示
function MessagePopup:filterSameSendButtonStatus_(uid)
    for _, v in ipairs(self.friendData) do
        if tonumber(v.newsfrom) == uid and tonumber(v.btntype) ~= 2 then
            if not v.isBroke then -- 破产的不用
                v.btntype = 1
                v.status = 2
            end
        end
    end

    table.insert(MessageData.sendMoneyToFriendList, uid)

    self:setListData(true)
end

--一键领取以后，隐藏所有领取按钮
function MessagePopup:updateMessageStatus_(data)
    for _, v in ipairs(data) do
        if v.btntype and tonumber(v.btntype) ~= 1 then
            if not v.isBroke then -- 破产的不用
                v.btntype = 1
                v.status = 2
            end
        end
    end

    self:setListData(true)
end

function MessagePopup:setListData(scroll)
    self.noDataTips_:hide()
    if self.selectedTab_ == FRIEND_MESSAGE then
        MessageListItem.MESSAGE_TYPE = FRIEND_MESSAGE
        self.list_:setData(self.friendData, scroll)
        if #self.friendData == 0 then
            self.noDataTips_:show()
        end
    else
        MessageListItem.MESSAGE_TYPE = SYSTEM_MESSAGE
        local showList = self.systemData

        -- 有破产奖励哦
        local time = tx.getBroken()
        if time then
            showList = clone(showList)
            table.insert(showList,1,{createtime=time,status=1,btntype=2,isBroke=true,content=sa.LangUtil.getText("CRASH","REWARD_TIPS")})
        end

        self.list_:setData(showList, scroll)
        if not showList or #showList == 0 then
            self.noDataTips_:show()
        end
    end

    self:showGetRewardButtonStatus_()
end

function MessagePopup:showGetRewardButtonStatus_()
    if self.selectedTab_ == FRIEND_MESSAGE then
        self.oneKeyGetRewardBtn_:hide()
        self.oneKeyGetAndSendBtn_:setVisible(self.isRewardFri_ > 0)
    else
        self.oneKeyGetAndSendBtn_:hide()
        self.oneKeyGetRewardBtn_:setVisible(self.isRewardSys_ > 0)
    end
end

function MessagePopup:updateOneKeyButtonStatus_(evt)
    local data = evt.data
    self.isRewardFri_ = data.redRewardFri
    self.isRewardSys_ = data.redRewardSys

    self:showGetRewardButtonStatus_()
end

function MessagePopup:onCleanup()
    sa.EventCenter:removeEventListener(self.updateOneKeyButtonStatusId_)
    sa.DataProxy:removeDataObserver(tx.dataKeys.NEW_MESSAGE, self.onNewMessageDataObserver)
    sa.HttpService.CANCEL(self.getCurrentFriPageId_)
    sa.HttpService.CANCEL(self.getCurrentSysPageId_)
    MessageData.clearCacheReadedNews()
end

return MessagePopup
