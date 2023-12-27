--选择好友弹窗
local HolidayBasePopup = import(".HolidayBasePopup")
local HolidayFriendPopup = class("HolidayFriendPopup", HolidayBasePopup)
local HolidayFriendListItem = import(".HolidayFriendListItem")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local WIDTH, HEIGHT = 750, 550
local RETRY_TIMES = 3

function HolidayFriendPopup:ctor()
	HolidayFriendPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitle(sa.LangUtil.getText("NEWESTACT","HOLIDAY_SHAKE_SEND_FRIEND"))

    self:addList(HolidayFriendListItem)

    RETRY_TIMES = 3

    self.friendPage_ = 1

    self.maxPage_ = false

    self.friendData_ = {}

    self:getFriendData_()

    self.selectedFriendListenerId_ = sa.EventCenter:addEventListener("HOLIDAY_SELECTED_SEND_FRIEND", handler(self, self.onSelectedSendFriend_))
end

function HolidayFriendPopup:getFriendData_()
	if not self.maxPage_ then
        self:setLoading(true)
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
            RETRY_TIMES = RETRY_TIMES - 1
            if RETRY_TIMES > 0 then
                self.friendDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFriendDataPage_), 1)
            end
        end)
    end
end

function HolidayFriendPopup:onGetFriendDataPage_(jsondata)
    if jsondata then
        self:setLoading(false)
        local jsondata_ = json.decode(jsondata)
        local data = jsondata_.flist or {}
        if #data == 0 then
            self.maxPage_ = true
            if self.friendPage_ > 1 then
                return
            end
        end

        self.friendPage_ = self.friendPage_ + 1

        for _,v in ipairs(data) do
            table.insert(self.friendData_, v)
        end

        self:setListData(sa.transformDataToGroup(self.friendData_, 2))
    else
        self.friendDataRequestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.requestFriendDataPage_), 2)
    end
end

function HolidayFriendPopup:onRefreshData_()
	self:getFriendData_()
end

function HolidayFriendPopup:onSelectedSendFriend_(evt)
    self:hidePanel()
end

function HolidayFriendPopup:onCleanup()
    sa.EventCenter:removeEventListener(self.selectedFriendListenerId_)

    sa.HttpService.CANCEL(self.friendDataRequestId_)

    if self.friendDataRequestScheduleHandle_ then
        scheduler.unscheduleGlobal(self.friendDataRequestScheduleHandle_)
    end
end

return HolidayFriendPopup
