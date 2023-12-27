-- 大厅邀请好友视图
local InviteView = class("InviteView", function ()
    return display.newNode()
end)

local PreviewRankingItem = import(".PreviewRankingItem")
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local InvitePopup = import("app.module.facebookinvite.InvitePopup")
local ExchangeCodePopup = import("app.module.exchangecode.ExchangeCodePopup")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local WIDTH, HEIGHT = 335, 500
local LIST_X, LIST_Y = WIDTH*0.5, HEIGHT*0.5 - 25
local TITLE_X = 10
local RETRY_TIMES = 3

PreviewRankingItem.WIDTH = WIDTH

function InviteView:ctor()
    self:setNodeEventEnabled(true)

    self.this_ = self

    self:size(WIDTH, HEIGHT)
    -- display.newScale9Sprite("#common/pop_list_item_pressed.png", 0, 0, cc.size(WIDTH, HEIGHT))
    --     :pos(WIDTH/2, HEIGHT/2)
    --     :addTo(self)

    RETRY_TIMES = 3

    self:addRankingNode_()

    self:requestRankingData_()

    self:schedule(function()
        self:startRequestRankingData_()
    end, 30)
end

function InviteView:addRankingNode_()
    local x = WIDTH*0.5
    local frame = display.newScale9Sprite("#hall/hall_ranking_frame.png", 0, 0, cc.size(WIDTH, HEIGHT), cc.rect(100, 80, 1, 1))
        :align(display.BOTTOM_CENTER, x, 0)
        :addTo(self)

    self.wordIcon = display.newSprite("#lang/hall_ranking_title.png")
        :pos(x, HEIGHT - 25)
        :addTo(frame)

    local list_w, list_h = WIDTH, HEIGHT - 50
    self.list_ = sa.ui.ListView.new(
            {
                viewRect = cc.rect(-list_w * 0.5, -list_h * 0.5, list_w, list_h)
            }, 
            PreviewRankingItem
        )
        :hideScrollBar()
        :pos(LIST_X, LIST_Y)
        :addTo(frame)
end

function InviteView:onInviteClicked_()
    InvitePopup.new():showPanel()
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand {
            command = "event",
            args = {eventId = "hall_Invite_friends", label = "hall_Invite_friends"}   
        }
    end 
end

function InviteView:onExchangeClicked_()
    ExchangeCodePopup.new():showPanel()
end

function InviteView:startRequestRankingData_()
    if self.requestRankingScheduleHandle_ then
        scheduler.unscheduleGlobal(self.requestRankingScheduleHandle_)
        self.requestRankingScheduleHandle_ = nil
    end

    sa.HttpService.CANCEL(self.requestRankingId_)
    self.requestRankingId_ = sa.HttpService.POST(
        {
            mod = "Rank",
            act = "hallRank",
        },
        handler(self, self.onGetRankingData_),
        function ()
            RETRY_TIMES = RETRY_TIMES - 1
            if RETRY_TIMES > 0 then
                self.requestRankingScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.startRequestRankingData_), 1)
            end
        end)
end

function InviteView:requestRankingData_()
    if not _G.hallRankingData then
        self:setLoading(true)
    else
        self:setListData_(_G.hallRankingData)
    end
    self:startRequestRankingData_()
end

function InviteView:onGetRankingData_(data)
    if not self.this_ or not tx.userData then
        return
    end

    local retData = json.decode(data)
    if retData and retData.code == 1 then
        self:setLoading(false)
        _G.hallRankingData = retData.list
        self:insertSelfData_(retData.list)
        self:setListData_(retData.list)
    else
        RETRY_TIMES = RETRY_TIMES - 1
        if RETRY_TIMES > 0 then
            self.requestRankingScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.startRequestRankingData_), 1)
        end
    end
end

function InviteView:setListData_(data)
    self.list_:setData(data,true)
end

--插入自己
function InviteView:insertSelfData_(data)
    local selfData = {
        uid = tx.userData.uid,
        nick = tx.userData.nick, 
        img = tx.userData.s_picture,
        sex = tx.userData.sex,
        money = tx.userData.money, 
        level = tx.userData.level
    }

    local isInsert = true
    for _, v in ipairs(data) do
        if v.uid == selfData.uid then
            isInsert = false
            break
        end
    end

    if isInsert then
        table.insert(data, selfData)
        table.sort(data, function (a, b) return a.money > b.money end)

        for i = #data, 21, -1 do
            table.remove(data, i)
        end
    end
end

function InviteView:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(LIST_X, LIST_Y)
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function InviteView:onCleanup()
    sa.HttpService.CANCEL(self.requestRankingId_)

    if self.requestRankingScheduleHandle_ then
        scheduler.unscheduleGlobal(self.requestRankingScheduleHandle_)
    end
end

return InviteView
