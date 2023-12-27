-- 礼物商店控制器

local GiftPopupController = class("GiftPopupController")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local LoadGiftControl = import(".LoadGiftControl")

local GIFT_SHOP_TAB = 1 --礼物商城
local GIFT_VIP_TAB = 2 --VIP礼物商城
local MY_GIFT_TAB = 3 --我的礼物

local SELF_BUY_GIFT = 1 --自己买的
local FRIEND_BUY_GIFT = 2 --好友买的
local SYSTEM_BUY_GIFT = 3 --系统赠送的

function GiftPopupController:ctor(view)
    sa.EventCenter:addEventListener(tx.eventNames.GET_CUR_SELECT_GIFT_ID, handler(self, self.getSelectGiftIdHandler))
    self.view_ = view

    self.boutiqueGift_ = {}  --精品礼物
    self.foodGift_ = {}      --食物礼物
    self.carGift_ = {}       --跑车礼物
    self.flowersGift_ = {}   --鲜花礼物

    self.boutiqueGiftVip_ = {}  --精品Vip礼物
    self.foodGiftVip_ = {}      --食物Vip礼物
    self.carGiftVip_ = {}       --跑车Vip礼物
    self.flowersGiftVip_ = {}   --鲜花Vip礼物

    self.selfBuyGiftData_ = {} --自己购买
    self.friendPresentData_ = {} --好友赠送
    self.systemPresentData_ = {} --系统赠送

    self.uid_ = 0
    self.tableUidArr_ = 0
    self.toUidArr_ = 0
    self.selectGiftId_ = nil
end

function GiftPopupController:onMainTabChange(selectedTab)
    requestRetryTimes_ = 2
    self.mainSelectedTab_ = selectedTab
    self:onSubTabChange(1)
end

function GiftPopupController:onSubTabChange(selectedTab)
    self.subSelectedTab_ = selectedTab
    self:showGiftView_()
end

function GiftPopupController:showGiftView_()
    self.view_:setListData(nil, -1)
    self.view_:setLoading(true)
    self.view_:setNoDataTip(false)

    if self.mainSelectedTab_ == GIFT_SHOP_TAB or self.mainSelectedTab_ == GIFT_VIP_TAB then
        if self.shopGiftData_ then
            self:showShopGiftView_(self.subSelectedTab_)
        else
            self:requestShopGiftData_()
        end
    elseif self.mainSelectedTab_ == MY_GIFT_TAB then
        if self.myGiftData_ then
            self:showMyGiftView_(self.subSelectedTab_)
        else
            self:requestMyGiftData_()
        end
    end 
end

function GiftPopupController:showShopGiftView_(selectedTab)
    if self.mainSelectedTab_ == GIFT_SHOP_TAB then
        if selectedTab == 1 then
            self:updateListData_(self.boutiqueGift_)
        elseif selectedTab == 2 then
            self:updateListData_(self.foodGift_)
        elseif selectedTab == 3 then
            self:updateListData_(self.carGift_)
        elseif  selectedTab == 4 then
            self:updateListData_(self.flowersGift_)
        end
    elseif self.mainSelectedTab_ == GIFT_VIP_TAB then
        if selectedTab == 1 then
            self:updateListData_(self.boutiqueGiftVip_)
        elseif selectedTab == 2 then
            self:updateListData_(self.foodGiftVip_)
        elseif selectedTab == 3 then
            self:updateListData_(self.carGiftVip_)
        elseif  selectedTab == 4 then
            self:updateListData_(self.flowersGiftVip_)
        end
    end
end

function GiftPopupController:showMyGiftView_(selectedTab)
    if selectedTab == 1 then
        self:updateListData_(self.selfBuyGiftData_, tx.userData.user_gift)
    elseif selectedTab == 2 then
        self:updateListData_(self.friendPresentData_, tx.userData.user_gift)
    elseif selectedTab == 3 then
        self:updateListData_(self.systemPresentData_, tx.userData.user_gift)
    end
end

function GiftPopupController:updateListData_(data, selected)
    if #data == 0 then
        self.view_:setLoading(false)
        self.view_:setNoDataTip(true)
        self.view_:setListData(data, -1)
    else
        self:getGroupGiftData_(data, selected)
    end
end

function GiftPopupController:requestShopGiftData_()
    if not self.shopGiftData_ then
        LoadGiftControl:getInstance():loadConfig(tx.userData.giftJsonDomain, function(success, data)
            if success then
                self.shopGiftData_ = data
                for _, gift in ipairs(data) do
                    if not gift.isShow or tonumber(gift.isShow) == 1 then
                        local giftType = tonumber(gift.type)
                        if giftType == 1 then
                            table.insert(self.boutiqueGift_, gift)
                        elseif giftType == 2 then
                            table.insert(self.foodGift_, gift)
                        elseif  giftType == 3 then 
                           table.insert(self.carGift_, gift)
                        elseif giftType == 4 then
                            table.insert(self.flowersGift_, gift)
                        -- VIP礼物
                        elseif giftType == 51 then
                            table.insert(self.boutiqueGiftVip_, gift)
                        elseif giftType == 52 then
                            table.insert(self.foodGiftVip_, gift)
                        elseif giftType == 53 then
                            table.insert(self.carGiftVip_, gift)
                        elseif giftType == 54 then
                            table.insert(self.flowersGiftVip_, gift)
                        end
                    end
                end

                self:sortGift_()

                self:onSubTabChange(1)
            end
        end)
    end
end

function GiftPopupController:sortGift_()
    self:sortByPrice_(self.boutiqueGift_)
    self:sortByPrice_(self.foodGift_)
    self:sortByPrice_(self.carGift_)
    self:sortByPrice_(self.flowersGift_)
    self:sortByPrice_(self.boutiqueGiftVip_)
    self:sortByPrice_(self.foodGiftVip_)
    self:sortByPrice_(self.carGiftVip_)
    self:sortByPrice_(self.flowersGiftVip_)
end

function GiftPopupController:sortByPrice_(list)
    table.sort(list, function(a, b)
        return tonumber(a.price) < tonumber(b.price)
    end)
end

function GiftPopupController:getGroupGiftData_(setGiftData, selectedId)
    if setGiftData then
        local storageGiftData = {}
        local row = 5  -- 一行有多少个
        local total = #setGiftData
        local last = total % row  -- 分割后，还有几个
        local minRow = math.floor(total/row) 

        for i = 1, minRow do
            table.insert(storageGiftData, {
                setGiftData[(i - 1) * row + 1],
                setGiftData[(i - 1) * row + 2],
                setGiftData[(i - 1) * row + 3],
                setGiftData[(i - 1) * row + 4],
                setGiftData[(i - 1) * row + 5]
            }) 
        end
        
        if last ~= 0 then
            local data = {}
            for i = 1, last do
                data[i] = setGiftData[minRow * row + i]
            end

            table.insert(storageGiftData, data)
        end

        self.view_:setListData(storageGiftData, selectedId)
        self.view_:setLoading(false)
        self.view_:setNoDataTip(false)
    else
        loadShopGiftDataError()
    end
end

function GiftPopupController:loadShopGiftDataError()
    requestRetryTimes_ = requestRetryTimes_ - 1
    if requestRetryTimes_ > 0 then
        self.giftDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestShopGiftData_), 2)
    end
end

function GiftPopupController:requestMyGiftData_()
    if self.myGiftRequesting_ then return end
    local request
    local retry = 3
    request = function()
        self.myGiftRequesting_ = true
        self.myGiftDataRequestId_ = sa.HttpService.POST(
            {
                mod = "Gift", 
                act = "list", 
            }, 
            handler(self, self.onGetMyGiftData_), 
            function()
                retry = retry - 1
                if retry > 0 then
                    request()
                else
                    self.myGiftRequesting_ = false
                end
            end
        )
    end
    request()
end

function GiftPopupController:onGetMyGiftData_(data)
    self.myGiftRequesting_ = false

    self.view_:setLoading(false)
    local jsonData = json.decode(data)
    if jsonData.code == 1 then
        local giftInfo = jsonData.giftInfo 
        self.myGiftData_ = giftInfo
        for _, gift in ipairs(giftInfo) do
            gift.imgUrl = tx.userData.giftDomain .. gift.img
            local giftType = gift.from
            if giftType == SELF_BUY_GIFT then
                table.insert(self.selfBuyGiftData_, gift)
            elseif giftType == FRIEND_BUY_GIFT then
                table.insert(self.friendPresentData_, gift)
            elseif  giftType == SYSTEM_BUY_GIFT then 
               table.insert(self.systemPresentData_, gift)
            end
        end
        self:onSubTabChange(1)
    end
end

function GiftPopupController:getTableUseUid(uid,tableUidArr,toUidArr,toInfoArr)
    self.uid_ = uid
    self.tableUidArr_ = tableUidArr
    self.toUidArr_ = toUidArr
    self.toInfoArr_ = toInfoArr
end

function GiftPopupController:getSelectGiftIdHandler(evt)
    self.selectGiftId_ = evt.data.giftId
end

function GiftPopupController:updateGiftIdHandler(data)
    self.selectGiftId_ = data
end

-- 设置设置自己的礼物
function GiftPopupController:useBuyGiftRequest(isRoom)
    if self.selectGiftId_ == nil or (tonumber(self.selectGiftId_) == tonumber(tx.userData.user_gift)) or self.selectGiftId_ == 0 then
        return 
    end

    self.setGiftRequestId_ = sa.HttpService.POST(
        {
            mod = "Gift", 
            act = "set",
            gid = self.selectGiftId_
        }, 
        function (data)
            local jsonData =  json.decode(data)
            if jsonData.code == 1 then
                tx.userData.user_gift = self.selectGiftId_
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "SET_GIFT_SUCCESS_TOP_TIP"))
                if isRoom then
                    tx.socket.HallSocket:sendUserInfoChanged()
                    tx.socket.HallSocket:sendSetGift(self.selectGiftId_, tx.userData.uid)
                end
                sa.EventCenter:dispatchEvent({name = tx.eventNames.HIDE_GIFT_POPUP})
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "SET_GIFT_FAIL_TOP_TIP"))
            end
        end, 
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "SET_GIFT_FAIL_TOP_TIP"))
        end
    )
end

-- 给牌桌的某个人购买
function GiftPopupController:requestPresentGiftData(isRoom)
    if self.selectGiftId_ == nil then
        return 
    end
    self.presentGiftRequestId_ = sa.HttpService.POST(
        {
            mod = "Gift", 
            act = "buyTo",
            gid = self.selectGiftId_,
            tuid_list = self.uid_

        }, 
        function (data)
            local jsonData =  json.decode(data)
            if jsonData and jsonData.code == 1 then
                local money_ = tonumber(jsonData.money) or 0
                tx.userData.money = tx.userData.money - money_
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=(-money_)}})
                if not isRoom then
                    tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "PRESENT_GIFT_SUCCESS_TOP_TIP"))
                end
                --赠送礼物成功
                local sendType = 1
                if isRoom then
                    local userinfo = {}
                    for k,v in ipairs(self.toUidArr_) do
                        if v==self.uid_ then
                            userinfo = {self.toInfoArr_[k]}
                            break;
                        end
                    end
                    tx.socket.HallSocket:sendOtherPlayerInfoChanged(self.selectGiftId_, tx.userData.uid, self.toUidArr_, self.toInfoArr_)
                    tx.socket.HallSocket:sendPresentGift(self.selectGiftId_, tx.userData.uid, {self.uid_})

                end
                sa.EventCenter:dispatchEvent({name = tx.eventNames.HIDE_GIFT_POPUP})
            elseif jsonData and jsonData.code == -4 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "VIP_GIFT"))
            elseif jsonData and jsonData.code == -5 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "PRESENT_GIFT_FAIL_TIPS"))
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "PRESENT_GIFT_FAIL_TOP_TIP"))
            end
        end, 
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_BUY_GIFT"))
        end
    )
end

-- 给自己购买
function GiftPopupController:buyGiftRequest(isRoom)
    if self.selectGiftId_ == nil then
        return 
    end

    self.view_:setLoading(true)
    self.buyGiftRequestId_ = sa.HttpService.POST(
        {
            mod = "Gift", 
            act = "buy",
            gid = self.selectGiftId_
        }, 
        function (data)
            local jsonData =  json.decode(data)
            self.view_:setLoading(false)
            if jsonData and jsonData.code == 1 then
                local money_ = tonumber(jsonData.money)
                tx.userData.money = tx.userData.money - money_
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=(-money_)}})
                
                tx.userData.user_gift = self.selectGiftId_
                local sendType = 1
                if isRoom then
                    tx.socket.HallSocket:sendUserInfoChanged()
                    tx.socket.HallSocket:sendSetGift(self.selectGiftId_, tx.userData.uid)
                end
                sa.EventCenter:dispatchEvent({name = tx.eventNames.HIDE_GIFT_POPUP})
            elseif jsonData and jsonData.code == -4 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "VIP_GIFT"))
            elseif jsonData and jsonData.code == -5 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "BUY_GIFT_FAIL_TIPS"))
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "BUY_GIFT_FAIL_TOP_TIP"))
            end
        end, 
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "BUY_GIFT_FAIL_TOP_TIP"))
            self.view_:setLoading(false)
        end
    )
end

--给牌桌的人购买
function GiftPopupController:requestPresentTableGift(isRoom)
    if self.selectGiftId_ == nil then
        return 
    end
    self.presentTableGiftRequestId_ = sa.HttpService.POST(
        {
            mod = "Gift", 
            act = "buyTo",
            gid = self.selectGiftId_,
            tuid_list = self.tableUidArr_

        }, 
        function (data)
            local jsonData =  json.decode(data)
            if jsonData and jsonData.code == 1 then
                local money_ = tonumber(jsonData.money) or 0
                tx.userData.money = tx.userData.money - money_
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=(-money_)}})
                if not isRoom then
                    tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "PRESENT_TABLE_GIFT_SUCCESS_TOP_TIP"))
                end
                local sendType = 3
                if isRoom then
                    tx.socket.HallSocket:sendOtherPlayerInfoChanged(self.selectGiftId_, tx.userData.uid, self.toUidArr_, self.toInfoArr_)
                    tx.socket.HallSocket:sendPresentGift(self.selectGiftId_, tx.userData.uid, self.toUidArr_)
                end
                sa.EventCenter:dispatchEvent({name = tx.eventNames.HIDE_GIFT_POPUP})
            elseif jsonData and jsonData.code == -4 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "VIP_GIFT"))
            elseif jsonData and jsonData.code == -5 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "PRESENT_TABLE_GIFT_FAIL_TIPS"))
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("GIFT", "PRESENT_TABLE_GIFT_FAIL_TOP_TIP"))
            end
        end, 
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_BUY_GIFT"))
        end
    )
end

function GiftPopupController:dispose()
    sa.HttpService.CANCEL(self.myGiftDataRequestId_)
    sa.HttpService.CANCEL(self.presentGiftRequestId_)
    sa.HttpService.CANCEL(self.buyGiftRequestId_)
    sa.HttpService.CANCEL(self.presentTableGiftRequestId_)

    if self.giftDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.giftDataRequestScheduleHandle_)
    end

    if self.myGiftDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.myGiftDataRequestScheduleHandle_)
    end

    self.selfBuyGiftData_ = nil
    self.friendPresentData_ = nil
    self.systemPresentData_ = nil

    sa.EventCenter:removeEventListenersByEvent(tx.eventNames.GET_CUR_SELECT_GIFT_ID)
end

return GiftPopupController
