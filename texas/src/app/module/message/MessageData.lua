--消息数据
local MessageData = class("MessageData")

-- 相当于static
MessageData.isInited = false
MessageData.hasNewMessage = false
MessageData.hasFriendMessage = 0
MessageData.hasSystemMessage = 0
MessageData.hasFriendReward = 0
MessageData.hasSystemReward = 0
MessageData.sendMoneyToFriendList = {} --当天玩家赠送筹码给好友的uid列表
--[[
redFri  int 未读好友消息总数,包含领奖的数量 >0:有; 0: 无
redSys  int 未读系统消息总数,包含领奖的数量 >0:有; 0: 无
redRewardSys    int 系统领奖消息总数 >0:有; 0: 无
redRewardFri    int 好友领奖消息总数 >0:有; 0: 无
]]
function MessageData.requestMessageData(isFromHall)
    if isFromHall==true and MessageData.isInited==true then  --在主大厅已经有消息了
        if tx.getBroken() then
            MessageData.hasNewMessage = true
            sa.DataProxy:setData(tx.dataKeys.NEW_MESSAGE, MessageData.hasNewMessage)
        end
        return false
    end
    sa.HttpService.CANCEL(MessageData.initId_)
    MessageData.initId_ = sa.HttpService.POST({
            mod = "News",
            act = "checkNew",
        },
        function(data)
            local jsonData = json.decode(data)
            if jsonData and jsonData.code == 1 then
                MessageData.isInited = true
                MessageData.hasFriendMessage = jsonData.redFri      --所有好友消息
                MessageData.hasSystemMessage = jsonData.redSys      --所有系统消息
                MessageData.hasFriendReward = jsonData.redRewardFri --带奖励好友
                MessageData.hasSystemReward = jsonData.redRewardSys --带奖励系统

                MessageData.checkNewMessage()
                MessageData.updateOneKeyStatus()
            end

            MessageData.checkBroken()
        end,
        function ()
            MessageData.checkBroken()
        end)
    return true
end

function MessageData.checkBroken()
    if tx.getBroken() then
        MessageData.hasNewMessage = true
        MessageData.hasSystemMessage = MessageData.hasSystemMessage and (MessageData.hasSystemMessage + 1) or 1
        MessageData.checkNewMessage()
    end
end

function MessageData.resetBroken()
    tx.setBroken(nil)
    if MessageData.prevHasNewMessage ~= nil then
        MessageData.hasNewMessage = MessageData.prevHasNewMessage
        MessageData.prevHasNewMessage = nil
    end

    sa.DataProxy:setData(tx.dataKeys.NEW_MESSAGE, MessageData.hasNewMessage)
end

function MessageData.redFriendMessage(num)
    num = num or 1
    MessageData.hasFriendMessage = MessageData.hasFriendMessage - num
    MessageData.checkNewMessage()
end

function MessageData.redSystemMessage(num)
    num = num or 1
    MessageData.hasSystemMessage = MessageData.hasSystemMessage - num
    MessageData.checkNewMessage()
end

function MessageData.getFriendReward(num)
    num = num or 1
    MessageData.redFriendMessage(num)
    MessageData.hasFriendReward = MessageData.hasFriendReward - num
    MessageData.updateOneKeyStatus()
end

function MessageData.getSystemReward(num)
    num = num or 1
    MessageData.redSystemMessage(num)
    MessageData.hasSystemReward = MessageData.hasSystemReward - num
    MessageData.updateOneKeyStatus()
end

function MessageData.oneKeyGetFriendReward()
    MessageData.getFriendReward(MessageData.hasFriendReward)
end

function MessageData.oneKeyGetSystemReward()
    MessageData.getSystemReward(MessageData.hasSystemReward)
end

function MessageData.checkNewMessage()
    if MessageData.hasFriendMessage > 0 or MessageData.hasSystemMessage > 0 then
        MessageData.hasNewMessage = true
    else
        MessageData.hasNewMessage = false
    end

    sa.DataProxy:setData(tx.dataKeys.NEW_MESSAGE, MessageData.hasNewMessage)
end

function MessageData.updateOneKeyStatus()
    sa.EventCenter:dispatchEvent({name="UPDATE_MESSAGE_ONE_KEY_STATUS", data={redRewardFri = MessageData.hasFriendReward, redRewardSys = MessageData.hasSystemReward}})
end
-- 缓存本地所有点击的消息
function MessageData.pushReadedNews(id)
    if not MessageData.readedNewsList then
        MessageData.readedNewsList = ""..id
    else
        MessageData.readedNewsList = MessageData.readedNewsList..","..id
    end
end
-- 清空所有已经点击的消息
function MessageData.clearCacheReadedNews()
    if not MessageData.readedNewsList or MessageData.readedNewsList=="" then return; end
    sa.HttpService.CANCEL(MessageData.clearCacheReadedNewsId_)
    MessageData.clearCacheReadedNewsId_ = sa.HttpService.POST(
        {
            mod = "News",
            act = "read",
            -- newsid = data.id
            newsidList = MessageData.readedNewsList
        },
        function()
            MessageData.readedNewsList = nil
        end,
        function()
            MessageData.readedNewsList = nil
        end
    )
end

-- 
function MessageData.clearAll()
    sa.HttpService.CANCEL(MessageData.initId_)
    sa.HttpService.CANCEL(MessageData.clearCacheReadedNewsId_)
    MessageData.isInited = false
    MessageData.hasNewMessage = false
    MessageData.hasFriendMessage = 0
    MessageData.hasSystemMessage = 0
    MessageData.hasFriendReward = 0
    MessageData.hasSystemReward = 0
    MessageData.sendMoneyToFriendList = {} --当天玩家赠送筹码给好友的uid列表
end

return MessageData
