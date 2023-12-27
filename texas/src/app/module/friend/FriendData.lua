--好友数据
local FriendData = class("FriendData")

-- 相当于static
FriendData.hasNewMessage = false

function FriendData:ctor()
    self:requestMessageData()
end

function FriendData:requestMessageData()
    self.requestMessageDataId = sa.HttpService.POST({
        mod = "Invite",
        act = "initMyGiftBag",
    },
    handler(self, self.onGetMessageData),
    function () end
    )
end

function FriendData:onGetMessageData(data)
    FriendData.hasNewMessage = false
    local jsonData = json.decode(data)
    if jsonData and jsonData.code == 1 then
        local invited = jsonData.invited
        local rewarded = jsonData.rewarded
        local configRewardNum = jsonData.configRewardNum
        local index = 0
        for i, v in ipairs(configRewardNum) do
            if invited >= v then
                index = i
            end
        end

        for i = 1, index do
            if rewarded[i] == 0 then
                FriendData.hasNewMessage = true
                break
            end
        end
    end
    sa.DataProxy:setData(tx.dataKeys.NEW_FRIEND_DATA, FriendData.hasNewMessage)
end

return FriendData
