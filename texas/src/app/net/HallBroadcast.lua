
local PROTOCOL = import(".HALL_SOCKET_PROTOCOL")
local BPROTOCOL = import(".BROADCAST_SOCKET_PROTOCOL")

local HallController = import("app.module.hall.HallController")
local MessageData = import("app.module.message.MessageData")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local HallBroadcast = class("HallBroadcast")

function HallBroadcast:ctor()
    self.showGoldislandRewardTipsTimes_ = 0
    self.goldislandHandle_ = nil
end

function HallBroadcast:onProcessPacket(pack)
    local P = PROTOCOL
    local cmd = pack.cmd
    if cmd == P.HALL_BROADCAST_PERSON then
        local PBPT = BPROTOCOL
        local info = json.decode(pack.info)
        if pack.type == PBPT.SVR_ADD_SIT_EXP then
            sa.EventCenter:dispatchEvent({
                name=tx.eventNames.SVR_BROADCAST_ADD_EXP,
                exp= info and info.exp or 0
            })
        elseif pack.type == PBPT.SVR_MODIFY_USER_ASSET then
            if info then
                self:moneyChange_(info)
            end
        elseif pack.type == PBPT.SVR_MODIFY_USER_PROP then
            if info then
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data = {props = info.num}})
                tx.userData.hddjnum = tx.userData.hddjnum + tonumber(info.num)
            end
        elseif pack.type == PBPT.SVR_MODIFY_USER_AVATAR then
            if info then
                tx.userData.s_picture = info.img
                if tx.socket.HallSocket.isInRoom then
                    tx.socket.HallSocket:sendUserInfoChanged(true)
                end
            end
        elseif pack.type == PBPT.SVR_MESSAGE_CENTER then
            MessageData.hasNewMessage = true
            sa.DataProxy:setData(tx.dataKeys.NEW_MESSAGE, MessageData.hasNewMessage)
        elseif pack.type == PBPT.SVR_ACT_STATE then
            sa.EventCenter:dispatchEvent({
                name=tx.eventNames.SVR_BROADCAST_ACT_STATE,
                actId=info.actId or 0,
                actState=info.actState or 0,
                actTarget=info.actTarget or 0
            })
        elseif pack.type == PBPT.SVR_VIP_LIGHT then
            if info and info.awardmsg and info.awardmsg.code == 0 and info.awardmsg.msg then 
                self:vipLight(info.awardmsg.msg)
            end
            -- 刷新onoff
            app:loadOnOffData()
        elseif pack.type == PBPT.SVR_TASK_REWARD_CHANGE then
            if info and info.num and info.num > 0 then
                sa.DataProxy:setData(tx.dataKeys.NEW_REWARD_TASK, true)
            end
        elseif pack.type == PBPT.SVR_CHANGE_GIFT then
            if info and info.id then
                if info.type == 1 then
                    -- tx.TopTipManager:showToast("ยินดีด้วยค่ะ คุณได้รับของขวัญวันฮาโลวีนประดับรูปประจำตัว")
                end
                tx.userData.user_gift = info.id
                if tx.socket.HallSocket.isRoomEntered_ then
                    tx.socket.HallSocket:sendUserInfoChanged(true)
                end
            end
        elseif pack.type == PBPT.SVR_INVITE_PLAY then  -- 收到邀请进入房间玩牌
            if info and info.tid and info.gameId then
                if tx.socket.HallSocket.isInRoom and tx.socket.HallSocket.curGameId==tonumber(info.gameId)
                    and tx.socket.HallSocket.curTid==tonumber(info.tid) then
                    return;
                end
                local games = sa.LangUtil.getText("COMMON", "GAME_NAMES")
                local gameName = games[info.gameId] or ""
                local config = tx.userData.tableConfig
                local cities = sa.LangUtil.getText("HALL", "CHOOSE_ROOM_CITY_NAME")
                local cityName = ""
                if info.gameLevel==tx.config.TEXAS_PRI_ROOM_LEVEL then
                    cityName = sa.LangUtil.getText("PRIVTE","ROOM_NAME")
                elseif info.gameId==tx.config.TEXAS_GAME_ID and info.gameLevel and config then
                    for i, v in ipairs(config) do
                        for _, vv in pairs(v) do
                            for iii, vvv in ipairs(vv) do
                                if tonumber(info.gameLevel) == tonumber(vvv.level) then
                                    local num = vvv.index or iii
                                    local index = (i - 1) * 6 + num
                                    cityName = cities[index] or ""
                                    break
                                end
                                
                            end
                        end
                    end
                end
                local tips = sa.LangUtil.getText("FRIEND","ROOM_INVITE_TIPS_CON",info.nick or "",gameName,cityName)
                local btnLabel = sa.LangUtil.getText("PRIVTE","ENTERROOM")
                tx.TopTipManager:showBottomTips({uid=info.uid,img=info.img,tips=tips,btnLabel=btnLabel,sex=info.sex,callback=function()
                    local enterRoomFun = function()
                        -- 进入房间 派发进房间哦
                        local roomData = {serverGameid = info.gameId, serverLevel = info.gameLevel, serverTid = info.tid, pwd = info.pwd}
                        sa.EventCenter:dispatchEvent({name = tx.eventNames.ENTER_ROOM_WITH_DATA, data = roomData, isTrace = false})
                    end
                    if tx.socket.HallSocket.isInRoom then
                        local isInGame = false
                        local curScene = tx.runningScene
                        if curScene and curScene.ctx and curScene.ctx.model and curScene.ctx.model.isSelfInGame then
                            isInGame = curScene.ctx.model:isSelfInGame()
                        end
                        if isInGame then
                            tx.ui.Dialog.new({
                                messageText = sa.LangUtil.getText("ROOM", "LEAVE_IN_GAME_MSG"),
                                callback = function (type)
                                    if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                                        enterRoomFun()
                                    end
                                end
                            }):show()
                        else
                            enterRoomFun()
                        end
                    else
                        enterRoomFun()
                    end
                end})
            end
        elseif pack.type == PBPT.SVR_PAY_SUCCESS then
            tx.HorseLamp:showTips(sa.LangUtil.getText("STORE", "DELIVERY_SUCC_MSG"),nil,true)

            if tx.userData.payStatus == 0 then --首充支付成功
                tx.userData.payStatus = 1
                tx.userData.marketData = nil
                sa.EventCenter:dispatchEvent(tx.eventNames.USER_FIRST_PAY_SUCCESS)
            end

            -- 重新获取个人支付信息
            local requestPayInfo
            local maxretry = 4
            requestPayInfo = function()
                sa.HttpService.POST({
                        mod="LoginSuc",
                        act="getUserPayInfo",
                    },
                    function(retData)
                        local retJson = json.decode(retData)
                        if retJson and retJson.code == 1 then
                            local userData = tx.userData
                            userData.payinfo = retJson.payinfo
                            if userData.payinfo then
                                if userData.payinfo.brokesalegoods then
                                    userData.payinfo.brokesalegoods.clientTime = os.time()
                                    userData.payinfo.brokesalegoods = nil -- 清空倒计时
                                end
                            end

                            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_INFO_CHANGE})
                            sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PAY_SUCCESS})
                        else
                            maxretry = maxretry - 1
                            if maxretry > 0 then
                                requestPayInfo()
                            end
                        end
                    end,
                    function()
                        maxretry = maxretry - 1
                        if maxretry > 0 then
                            requestPayInfo()
                        end
                    end)
            end
            requestPayInfo()
            -- 广告支付ROT统计 info.channel
            if info and info.revenue and info.currency then
                -- 广告SDK
                if tx.AdvertSDK and tx.AdvertSDK.trackRevenue then
                    tx.AdvertSDK:trackRevenue(info.revenue,info.currency)
                end
                -- FaceBookSDK
                if tx.Facebook and tx.Facebook.statisticsFBADPay then
                    tx.Facebook:statisticsFBADPay(info.revenue,info.currency)
                end
            end
        elseif pack.type == PBPT.SVR_PLAY_CARD_ACT_REWARD then
            local curScene = tx.runningScene
            if curScene and curScene.ctx and curScene.ctx.model and curScene.ctx.model.roomInfo and curScene.ctx.model.roomInfo.blind then
                tx.getPlayPokerNum(curScene.ctx.model.roomInfo.blind)
            end
        end
    elseif cmd == P.HALL_BROADCAST_SYSTEM then
        local PBST = BPROTOCOL
        local info = json.decode(pack.info)
        if info and info.type then 
            if info.type == PBST.SVR_BIG_SLOT_REWARD then
                tx.HorseLamp:showTips(sa.LangUtil.getText("SLOT", "TOP_PRIZE", info.nick or "", sa.formatBigNumber(tonumber(info.addmoney or 0))),nil,true)
            elseif info.type == PBST.SVR_SERVER_STOP then
                sa.EventCenter:dispatchEvent({name=tx.eventNames.SERVER_STOPPED})
            elseif info.type == PBST.SVR_BIG_LABA then  --大喇叭消息
                self:pushGameLabaMessage_(info)
            elseif info.type == PBST.SVR_GOLD_ISLAND_WIN then
                if tx.userData.uid == info.uid then
                    tx.userData.goldIslandRewardData = info --要在结算审核,同步座位筹码
                end

                local userInfo = json.decode(info.info)
                local cardTypes = sa.LangUtil.getText("COMMON", "CARD_TYPE")
                local text = sa.LangUtil.getText("GOLDISLAND", "BROADCAST_REWARD_TIPS", userInfo.nick, cardTypes[info.cards_type], sa.formatNumberWithSplit(info.win))
                self:showGoldislandRewardTips_(text)
            elseif info.type == PBST.SVR_GOLD_ISLAND_CUR_POOL then
                local pool = tonumber(info.total)
                tx.userData.goldIslandPool = pool
                sa.EventCenter:dispatchEvent({name = tx.eventNames.UPDATE_GOLD_ISLAND_POOL, data = pool})
            elseif info.type == PBST.SVR_GOLD_ISLAND_BET_POOL then
                local pool = tonumber(info.total)
                tx.userData.goldIslandPool = pool
                sa.EventCenter:dispatchEvent({name = tx.eventNames.UPDATE_GOLD_ISLAND_POOL, data = pool})
            end
        end
    end
end

function HallBroadcast:moneyChange_(retData)
    local userData = tx.userData
    if retData.exp then
        retData.exp = tonumber(retData.exp)
        if retData.exp and retData.exp > 0 then
            userData.exp = retData.exp
            userData.level = tx.Level:getLevelByExp(retData.exp) or userData.level
            userData.title = tx.Level:getTitleByExp(retData.exp) or userData.title
        end
    end

    local evtData = {}
    if retData.money then -- 游戏币
        local totalMoney = tonumber(retData.money)
        local changeMoney = totalMoney - tx.userData.money
        tx.userData.money = totalMoney
        evtData.money = changeMoney
    end

    if retData.diamonds then-- 钻石
        local totalDiamonds = tonumber(retData.diamonds)
        local changeDiamonds = totalDiamonds - tonumber(tx.userData.diamonds)
        evtData.diamonds = changeDiamonds
        tx.userData.diamonds = totalDiamonds
    end

    sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data=evtData})
end

function HallBroadcast:showGoldislandRewardTips_(text)
    tx.HorseLamp:showTips(text)

    if self.goldislandHandle_ then
        scheduler.unscheduleGlobal(self.goldislandHandle_)
    end

    self.showGoldislandRewardTipsTimes_ = 0
    self.goldislandHandle_ = scheduler.scheduleGlobal(function()
        tx.HorseLamp:showTips(text)

        self.showGoldislandRewardTipsTimes_ = self.showGoldislandRewardTipsTimes_ + 1
        if self.showGoldislandRewardTipsTimes_ == 30 then
            scheduler.unscheduleGlobal(self.goldislandHandle_)
            self.goldislandHandle_ = nil
        end
    end, 120)
end

--广播消息start---------------------------------------------------------------------------------------------
local GAME_LABA_DELAY = 30
-- 把游戏广播压入待播放对象中
function HallBroadcast:pushGameLabaMessage_(info)
    local priorityVal = 0
    local PBST = BPROTOCOL
    -- 系统喇叭优先级最高
    if info and (not info.uid or info.uid=="" or tonumber(info.uid)==0) then
        priorityVal = 100
    end
    -- 
    if not self.waitLabaQueues_ then
        self.waitLabaQueues_ = {{priority=priorityVal, data=info}}
    else
        -- table.insertto()
        local isAdd = false
        for k,v in pairs(self.waitLabaQueues_) do
            if priorityVal>v.priority then
                isAdd = true
                table.insert(self.waitLabaQueues_, k, {priority=priorityVal, data=info})
                break;
            end
        end
        if not isAdd then
            table.insert(self.waitLabaQueues_,{priority=priorityVal, data=info})
        end
    end
    -- 
    self:sendNextGameLabaMessage_()
end

-- 发送游戏广播消息
function HallBroadcast:sendGameLabaMessage_()
    -- 判断玩家如果在登录界面不提示广播消息
    if not tx.userData then
        self.waitLabaQueues_ = nil
        return
    end
    -- 
    if not self.waitLabaQueues_ or #self.waitLabaQueues_<1 then
        return
    end
    -- 
    local icon_ = nil
    local retData = table.remove(self.waitLabaQueues_, 1)
    if not retData then
        self:sendNextGameLabaMessage_()
        return
    end
    retData = retData.data
    if not retData or not retData.msg or string.trim(retData.msg)=="" then
        self:sendNextGameLabaMessage_()
        return
    end
    -- 
    local textColor = nil
    if retData.type then
        if not retData.uid or retData.uid=="" or tonumber(retData.uid)==0 then
            icon_ = display.newSprite("#common/tips_laba_sys.png")
            textColor = cc.c3b(0xfb,0xea,0x68)
        else
            icon_ = display.newSprite("#common/tips_laba_icon.png")
        end
        -- if retData.type == "bcExchange" then
        --     icon_ = display.newSprite("#common_toast_speaker.png")
        -- elseif retData.type == "bcChampion" then
        --     icon_ = display.newSprite("#common_toast_match.png")
        -- end
    end
    -- 按钮信息
    local buttonInfo = nil
    local id = retData.uid
    local nick = retData.nick or ""
    local msg = retData.msg or ""
    local url = retData.url

    if not icon_ then
        tx.HorseLamp:showTips({animType=tx.HorseLamp.ANIM_TYPE_HOR, text = nick .. ":" .. retData.msg, textColor = textColor},buttonInfo,false)
    else
        tx.HorseLamp:showTips({animType=tx.HorseLamp.ANIM_TYPE_HOR, text = nick .. ":" .. retData.msg, textColor = textColor, image = icon_},buttonInfo,false)
    end

    --塞进去大喇叭中
    local chatHistory = sa.DataProxy:getData(tx.dataKeys.BIG_LA_BA_CHAT_HISTORY)
    if not chatHistory then
        chatHistory = {}
    end

    local msg1 = sa.LangUtil.getText("ROOM", "CHAT_FORMAT", nick, msg)
    chatHistory[#chatHistory + 1] = {messageContent = msg1, time = sa.getTime(), mtype = 1, id = id, url = url}
    -- 最多50条
    if #chatHistory>20 then
        while(true) do
            table.remove(chatHistory,1)
            if #chatHistory<=20 then
                break;
            end
        end
    end
    sa.DataProxy:setData(tx.dataKeys.BIG_LA_BA_CHAT_HISTORY, chatHistory)

    -- 记录
    -- 
    self.lastShowTime_ = os.time()
    -- 延迟一秒播放下一条
    scheduler.performWithDelayGlobal(handler(self, self.sendNextGameLabaMessage_), GAME_LABA_DELAY+1)
end

function HallBroadcast:sendNextGameLabaMessage_()
    -- 两条消息间隔要超过5分钟
    if not self.lastShowTime_ then
        self:sendGameLabaMessage_()
    elseif os.time() - self.lastShowTime_ >= GAME_LABA_DELAY then
        self:sendGameLabaMessage_()
    else
        
    end
end

-- 移除监听
function HallBroadcast:removeListener()
end

--广播消息end---------------------------------------------------------------------------------------------
return HallBroadcast