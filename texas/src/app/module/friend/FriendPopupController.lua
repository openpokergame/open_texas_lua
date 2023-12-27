local FriendPopupController = class("FriendPopupController")
local SendChipData = import(".SendChipData")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local logger = sa.Logger.new("FriendPopupController")

local SHOW_FRIEND = 1 --我关注的
local SHOW_FRIEND_2 = 2 --关注我的
local SHOW_MORE_FRIEND = 3 --更多好友
local REQUEST_RETRY_TIMES = 2

function FriendPopupController:ctor(view)
    self.view_ = view
    self.friendPage_ = 1
    self.selectedTab_ = 1
    self.onePageCount_ = 7
    self.maxPage_ = false
    self.recallData_ = {}
    self.sendChipsData_ = SendChipData.new()

    self.updateFriendDataId_ = sa.EventCenter:addEventListener(tx.eventNames.UPDATE_FRIEND_DATA, handler(self, self.updateFriendData_))
end

function FriendPopupController:onMainTabChange(selectedTab)
    self.selectedTab_ = selectedTab
    REQUEST_RETRY_TIMES = 2

    self:getCanRecallFriends_()

    if self.selectedTab_ == SHOW_FRIEND then
        self.sendChipsData_:setIndex(SHOW_FRIEND)
        if not self.friendData_ then
            self:requestFriendDataPage_()
        else
            self.view_:setListData(self.friendData_)
            self:updateSendChipsView_()
        end
    elseif self.selectedTab_ == SHOW_FRIEND_2 then
        self.sendChipsData_:setIndex(SHOW_FRIEND_2)
        if not self.followMeData_ then   
            self:requestFollowMeFriendData_()
        else
            self.view_:setListData(self.followMeData_)
            self:updateSendChipsView_()
        end
    elseif self.selectedTab_ == SHOW_MORE_FRIEND then
        self.view_:setNoDataTip(false)
    end
end

function FriendPopupController:onFriendUpFrefresh()
    if self.selectedTab_ == SHOW_FRIEND then
        self:requestFriendDataPage_()
    end
end

-- 使用分页加载模型请求数据
function FriendPopupController:requestFriendDataPage_()
    if not self.maxPage_ then
        if not self.friendData_ then
            self.friendData_ = {}
        end

        self.view_:setLoading(true)
        sa.HttpService.CANCEL(self.friendDataRequestId_)
        self.friendDataRequestId_ = sa.HttpService.POST(
        {
            mod = "friend",
            act = "list",
            new = 1,
            page = self.friendPage_
        },
        handler(self, self.onGetFriendDataPage_),
        function ()
            REQUEST_RETRY_TIMES = REQUEST_RETRY_TIMES - 1
            if REQUEST_RETRY_TIMES > 0 then
                self.friendDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFriendDataPage_), 1)
            end
        end
    )
    end
end

function FriendPopupController:onGetFriendDataPage_(jsondata)
    if jsondata then
        self.view_:setLoading(false)
        local jsondata_ = json.decode(jsondata) 
        local data = jsondata_.flist or {}
        if #data == 0 then
            self.maxPage_ = true
            if self.friendPage_ > 1 then
                return
            end
        end

        self.friendPage_ = self.friendPage_ + 1
        for i = 1, #data do
            table.insert(self.friendData_, data[i])
        end

        jsondata_.flist = self.friendData_
        self:setSendData_(SHOW_FRIEND, jsondata_)

        if self.selectedTab_ == SHOW_FRIEND then
            self.view_:setListData(self.friendData_)
            self:updateSendChipsView_()
            self:updateRecallView_()
        end
    else
        self.friendDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFriendDataPage_), 2)
    end
end

-- 获取关注我的好友数据
function FriendPopupController:requestFollowMeFriendData_()
        if not self.followMeData_ then
            self.followMeData_ = {}
        end

        self.view_:setLoading(true)
        sa.HttpService.CANCEL(self.followMeRequestId_)
        self.followMeRequestId_ = sa.HttpService.POST(
        {
            mod = "Friend",
            act = "getWatchmeFri",
        },
        handler(self, self.onGetFollowMeFriendData_),
        function ()
            REQUEST_RETRY_TIMES = REQUEST_RETRY_TIMES - 1
            if REQUEST_RETRY_TIMES > 0 then
                self.followMeRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFollowMeFriendData_), 1)
            end
        end)
end

function FriendPopupController:onGetFollowMeFriendData_(jsondata)
    if jsondata then
        local jsondata_ = json.decode(jsondata)
        self.followMeData_ = jsondata_.flist or {}

        self:setSendData_(SHOW_FRIEND_2, jsondata_)

        if self.selectedTab_ == SHOW_FRIEND_2 then
            self.view_:setListData(self.followMeData_)
            self:updateSendChipsView_()
            self:updateRecallView_()
        end
    else
        self.followMeRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFollowMeFriendData_), 2)
    end
end

function FriendPopupController:setSendData_(index, jsondata)
    local data = {}
    data.cnt = jsondata.cnt or 0
    data.money = jsondata.money or 500
    data.flist = jsondata.flist or {}

    self.sendChipsData_:addData(index, data)
end

function FriendPopupController:sendChip(friendListItem)
    sa.HttpService.CANCEL(self.sendChipRequestId_)
    self.sendChipRequestId_ = sa.HttpService.POST(
        {
            mod = "Friend",
            act = "sendMoneyToFriend",
            fuid = friendListItem:getData().uid
        },
        function (data)
            self:onSendChip_(data, friendListItem)
        end,
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_SEND_FRIEND_CHIP"))
        end
    )
end

function FriendPopupController:onSendChip_(data, friendListItem)
    if data then
        local retData = json.decode(data)
        if retData.code then
            if retData.code == -3 then-- 没钱了
                tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "SEND_CHIP_TOO_POOR"))
            elseif retData.code == -2 then-- 赠送次数用完
                tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "SEND_CHIP_COUNT_OUT"))
            elseif retData.code == 1 then-- 赠送成功
                if friendListItem then
                    friendListItem:onSendChipSucc()
                    local id = friendListItem:getData().uid
                    self.sendChipsData_:sendChipSuccess(id)
                    self:updateSendChipsView_()
                end
                local money_ = tonumber(retData.money) or 0
                tx.userData.money = tx.userData.money - money_
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=(-money_)}})
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "EXCEPTION_SEND_FRIEND_CHIP"))
            end
        end
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "EXCEPTION_SEND_FRIEND_CHIP"))
    end
end

--一键赠送
function FriendPopupController:oneKeySend()
    self.sendChipsData_:oneKeySend(handler(self, self.oneKeySendFriends))
end

function FriendPopupController:oneKeySendFriends(ftype)
    sa.HttpService.POST(
        {
            mod = "Friend",
            act = "sendMoneyToFriends",
            type = ftype
        },
        function (data)
            local retData = json.decode(data)
            if retData.code == 1 then
                local money = self.sendChipsData_:getMoney()
                self.sendChipsData_:oneKeySendSuccess()
                self:resetSendChipsData_()
                local addMoney = tonumber(retData.money) or 0
                tx.userData.money = tx.userData.money - addMoney
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=(-addMoney)}})
                tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "SEND_CHIP_SUCCESS", sa.formatNumberWithSplit(retData.total * money)))
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "EXCEPTION_SEND_FRIEND_CHIP"))
            end
        end,
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_SEND_FRIEND_CHIP"))
        end
    )
end

function FriendPopupController:updateSendChipsView_()
    local data = self.sendChipsData_:getData()
    if data and data.cnt > 0 then
        local tm = data.cnt * data.money
        if tm > 0 then
            self.view_:updateOneKeySendStatus(true, tm)
        else
            self.view_:updateOneKeySendStatus(false)
        end
    else
        self.view_:updateOneKeySendStatus(false)
    end
end

function FriendPopupController:resetSendChipsData_()
    local data = self.friendData_
    if self.selectedTab_ == SHOW_FRIEND_2 then
        data = self.followMeData_
    end

    if data then
        for i, v in ipairs(data) do
            v.send = 0
        end
    end
    
    self.view_:setListData(data)
    self.view_:updateOneKeySendStatus(false)
end

--召回好友
function FriendPopupController:recallFriend(friendData, oneKeyCallback)
    -- 上报使用邀请老用户好友功能的用户数上报
    local date = tx.userDefault:getStringForKey(tx.cookieKeys.DALIY_REPORT_OLDUSER_INVITED)
    if date ~= os.date("%Y%m%d") then
        tx.userDefault:setStringForKey(tx.cookieKeys.DALIY_REPORT_OLDUSER_INVITED, os.date("%Y%m%d"))
        cc.analytics:doCommand{
            command = "eventCustom",
            args = {
                eventId = "invite_olduser_count",
                attributes = "type,invite_olduser",
                counter = 1
            }
        }
    end

    local toIds, names, toIdArr, nameArr = '', '', {}, {}

    for _, item in ipairs(friendData) do
        table.insert(toIdArr, tostring(item.siteid))
        table.insert(nameArr, item.nick)
    end

    toIds = table.concat(toIdArr, ",")
    names = table.concat(nameArr, "#")

    -- 发送邀请
    if toIds ~= "" then
        sa.HttpService.POST(
            {
                mod = "recall", 
                act = "getRecallID"
            }, 
            function (data)
                local retData = json.decode(data)
                local requestData

                if retData.code and retData.code == 1 then
                    requestData = "u:"..retData.u..";id:"..retData.id..";sk:"..retData.sk
                else
                    return
                end
                local retry = 10
                local function send_fb_invites()
                    local msg = sa.LangUtil.getText("FRIEND","CALL_FRIEND_TO_GAME")
                    tx.Facebook:sendInvites(
                        "oldUserRecall" .. requestData, 
                        toIds, 
                        sa.LangUtil.getText("FRIEND", "INVITE_SUBJECT"), 
                        msg,
                        function (success, result)
                            if success then
                                if names ~= "" then
                                    local recalledNames = tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_RECALLED_NAMES, "")
                                    local today = os.date("%Y%m%d")
                                    if recalledNames == "" or string.sub(recalledNames, 1, 8) ~= today then
                                        recalledNames = today .."#" .. names
                                    else
                                        recalledNames = recalledNames .. "#" .. names
                                    end
                                    tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_RECALLED_NAMES, recalledNames)
                                    tx.userDefault:flush()
                                end

                                local noreward_ = 0
                                if oneKeyCallback then
                                    oneKeyCallback()
                                    noreward_ = 1  -- 一键召回的时候发推送了，不需要发奖
                                else
                                    self:updateRecallData_(friendData[1].uid)--单个召回
                                end

                                -- 去掉最后一个逗号
                                if result.toIds then
                                    local idLen = string.len(result.toIds)
                                    if idLen > 0 and string.sub(result.toIds, idLen, idLen) == "," then
                                        result.toIds = string.sub(result.toIds, 1, idLen - 1)
                                    end
                                end

                                -- 上报php，领奖
                                local postData = {
                                    mod = "recall", 
                                    act = "report", 
                                    data = requestData, 
                                    requestid = result.requestId, 
                                    list = result.toIds, 
                                    sig = crypto.md5(result.toIds .. "ab*&()[cae!@+?>#5981~.,-zm"),
                                    source = "recall",
                                    type = "recall",
                                    noreward = noreward_
                                }

                                sa.HttpService.POST(
                                    postData, 
                                    function (data)
                                        local retData = json.decode(data)
                                        if retData and retData.code == 1 and retData.money and retData.money > 0 then
                                            tx.userData.money = tx.userData.money + retData.money
                                            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=retData.money}})
                                            self:showRecallSuccTip_()
                                        end
                                    end
                                )
                            else
                                logger:debugf("sendInvites result %s", result)
                                if string.find(result,"facebookErrorCode: 100") ~= nil or
                                    string.find(result,"does not resolve to a valid user ID") ~= nil then
                                    local reg = "message%:%s+%d+"
                                    local matStr = string.match(result,reg)
                                    local desId = string.match(matStr,"%d+")

                                    logger:debugf("sendInvites result faild, rectry! desId:%s", desId)
                                    for i = #toIdArr, 1, -1 do
                                        if toIdArr[i] == desId then
                                            table.remove(toIdArr, i)
                                            table.remove(nameArr, i)
                                        end
                                    end
                                    toIds = table.concat(toIdArr, ",")
                                    names = table.concat(nameArr, "#")
                                    
                                    if retry > 0 and #toIdArr > 0 then
				    	                retry = retry - 1
                                        send_fb_invites()
                                    else
                                        tx.TopTipManager:showToast(sa.LangUtil.getText("COMMON", "USER_NEED_RELOGIN"))
                                    end
                                end
                            end
                        end
                    )
                end

                send_fb_invites()
            end, 
            function ()
            end
        )
    end
end

--发送推送消息
function FriendPopupController:sendPushNews(touid)
    self.sendPushNewsRequestId_ = sa.HttpService.POST(
        {
            mod = "recall",
            act = "pushNews",
            touid = touid
        },
        function(data)
            local retData = json.decode(data)
            if retData.code == 1 or retData.code == -2 then --1表示发送成功并发送推送，-2表示发送成功，但不会发送推送
                self:showRecallSuccTip_()
            else
                self:showRecallFailedTip_()
            end
        end,
        function()
            self:showRecallFailedTip_()
        end
    )
end

--一键召回
function FriendPopupController:oneKeyRecall()
    self:oneKeyRecallFriends()
end

function FriendPopupController:oneKeyRecallFriends()
    local recallFbList = nil
    local data = self.recallData_[self.selectedTab_]
    if data then
        recallFbList = data.fblist
    end

    -- if recallFbList and #recallFbList > 0 then
    --     if #recallFbList >= 50 then
    --         for i = #recallFbList, 50, -1 do
    --             table.remove(recallFbList, i)
    --         end
    --     end
    --     self:recallFriend(recallFbList, handler(self, self.oneKeyPushFriends))
    -- else
    --     self:oneKeyPushFriends()
    -- end

    --暂时不区分FB
    self:oneKeyPushFriends()
end

function FriendPopupController:oneKeyPushFriends()
    self:resetRecallData_()
    sa.HttpService.POST({
            mod = "recall",
            act = "sendRecallMulti",
        },
        handler(self, self.onOneKeyPushResult),
        function () end
    )
end

function FriendPopupController:onOneKeyPushResult(data)
    local jsonData = json.decode(data or {})
    if jsonData and jsonData.code == 1 then
        tx.HorseLamp:showTips(sa.LangUtil.getText(
            "FRIEND",
            "RECALL_SUCC_TIP",
            jsonData.money,
            tx.userData.recallBackChips),nil,true)
    else
        self:showRecallFailedTip_()
    end
end

----每次请求，发送请求全部关闭一键召回触摸
function FriendPopupController:getCanRecallFriends_()
    self.view_:updateOneKeyRecallStatus(false)
    sa.HttpService.POST({
        mod = "recall",
        act = "getCanRecallList",
        type = self.selectedTab_
    },
    function(data)
        local jsonData = json.decode(data or {})
        if jsonData and jsonData.code == 1 then
            self.recallData_[self.selectedTab_] = jsonData
            self:updateRecallView_()
        end
    end,
    function ()
    end
    )
end

function FriendPopupController:updateRecallView_()
    local data = self.recallData_[self.selectedTab_]
    local friendData = self.friendData_
    if self.selectedTab_ == SHOW_FRIEND_2 then
        friendData = self.followMeData_
    end

    if friendData and #friendData > 0 and data and data.code == 1 then
        if data.money and data.money > 0 then
            self.view_:updateOneKeyRecallStatus(true, data.money)
        else
            self.view_:updateOneKeyRecallStatus(false)
        end
    else
        self.view_:updateOneKeyRecallStatus(false)
    end
end

--过滤重叠数据
function FriendPopupController:updateRecallData_(id)
    id = tonumber(id)
    local data = self.friendData_
    if self.selectedTab_ == SHOW_FRIEND then
        data = self.followMeData_
    end

    if data then
        local money = self.recallData_[self.selectedTab_].money
        for _, v in ipairs(data) do
            if tonumber(v.uid) == id then
                v.isCanRecall = 0
                money = money - tx.userData.recallSendChips
                break
            end
        end

        self.recallData_[self.selectedTab_].money = money
    end
end

function FriendPopupController:resetRecallData_()
    local data = self.friendData_
    local other = self.followMeData_
    local idArr = {}
    if self.selectedTab_ == SHOW_FRIEND_2 then
        data = self.followMeData_
        other = self.friendData_
    end

    if data then
        for i, v in ipairs(data) do
            v.isCanRecall = 0
            idArr[tonumber(v.uid)] = true
        end
    end

    if other then
        for _, v in ipairs(other) do
            if idArr[tonumber(v.uid)] then
                v.isCanRecall = 0
            end
        end
    end

    self.view_:setListData(data)
    self.view_:updateOneKeyRecallStatus(false)
end

--发送召回成功提示
function FriendPopupController:showRecallSuccTip_()
    self:getCanRecallFriends_()--重新获取一键召回数据
    tx.HorseLamp:showTips(sa.LangUtil.getText(
        "FRIEND",
        "RECALL_SUCC_TIP",
        tx.userData.recallSendChips,
        tx.userData.recallBackChips),nil,true)
end

--发送召回失败提示
function FriendPopupController:showRecallFailedTip_()
    tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "RECALL_FAILED_TIP"))
end

--清除好友数据，可以重新发送请求获取
function FriendPopupController:clearAllFriendData()
    self.friendData_ = nil
    self.friendPage_ = 1
    self.maxPage_ = false
end

--邀请好友奖励配置
function FriendPopupController:getInviteRewardConfig(callback)
    if not self.inviteRewardConfig_ then
        self.view_:setLoading(true)
        sa.HttpService.CANCEL(self.inviteRewardConfigRequestId_)
        self.inviteRewardConfigRequestId_ = sa.HttpService.POST({
            mod = "Invite",
            act = "initMyGiftBag",
        },
        function(data)
            local retData = json.decode(data)
            if retData.code == 1 then
                self.view_:setLoading(false)
                self.inviteRewardConfig_ = retData
                callback(retData)
            else
                self.getInviteRewardConfigScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.getInviteRewardConfig), 2)
            end
        end,
        function ()
            self.getInviteRewardConfigScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.getInviteRewardConfig), 2)
        end
        )
    else
        callback(self.inviteRewardConfig_)
    end
end

--获取奖励
function FriendPopupController:getInviteReward(rewardType)
    self.view_:setLoading(true)
    sa.HttpService.CANCEL(self.inviteRewardRequestId_)
    self.inviteRewardRequestId_ = sa.HttpService.POST({
        mod = "Invite",
        act = "rewardGiftBag",
        type = rewardType
    },
    function(data)
        local retData = json.decode(data)
        if retData.code == 1 then
            local evtData = {} -- 动画
            local reward = retData.reward
            if reward.money then
                tx.userData.money = tx.userData.money + tonumber(reward.money)
                evtData.money = reward.money
            end

            if reward.diamond then
                tx.userData.diamonds = tx.userData.diamonds + tonumber(reward.diamond)
                evtData.diamonds = reward.diamond
            end
            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
            self.view_:setLoading(false)
        end
    end,
    function ()
    end
    )
end

function FriendPopupController:updateFriendData_(evt)
    self:clearAllFriendData()
    if self.selectedTab_ == SHOW_FRIEND then
        self:onMainTabChange(SHOW_FRIEND)
    end
end

function FriendPopupController:dispose()
    sa.HttpService.CANCEL(self.friendDataRequestId_)
    sa.HttpService.CANCEL(self.followMeRequestId_)
    sa.HttpService.CANCEL(self.delFriendDataRequestId_)
    sa.HttpService.CANCEL(self.sendChipRequestId_)
    sa.HttpService.CANCEL(self.sendPushNewsRequestId_)
    sa.HttpService.CANCEL(self.inviteRewardRequestId_)
    sa.HttpService.CANCEL(self.inviteRewardConfigRequestId_)

    if self.friendDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.friendDataRequestScheduleHandle_)
    end

    if self.followMeRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.followMeRequestScheduleHandle_)
    end

    if self.getInviteRewardConfigScheduleHandle_ then
        scheduler.unscheduleGlobal(self.getInviteRewardConfigScheduleHandle_)
    end

    sa.EventCenter:removeEventListener(self.updateFriendDataId_)
end

return FriendPopupController
