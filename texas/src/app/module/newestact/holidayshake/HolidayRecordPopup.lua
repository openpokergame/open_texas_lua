--赠送记录弹窗
local HolidayBasePopup = import(".HolidayBasePopup")
local HolidayRecordPopup = class("HolidayRecordPopup", HolidayBasePopup)
local HolidayRecordItem = import(".HolidayRecordItem")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local WIDTH, HEIGHT = 750, 550
local RETRY_TIMES = 3

function HolidayRecordPopup:ctor(data)
	HolidayRecordPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitle(sa.LangUtil.getText("NEWESTACT","HOLIDAY_SHAKE_SEND_RECORD"))

    self:addList(HolidayRecordItem)

    RETRY_TIMES = 3

    self:getRecordData_()
end

function HolidayRecordPopup:getRecordData_()
	self:setLoading(true)
	sa.HttpService.CANCEL(self.requestId_)
    self.requestId_ = sa.HttpService.POST(
    {
        mod = "Activity",
        act = "getSendMoneyRecord",
    },
    function(data)
    	self:setLoading(false)
    	local retData = json.decode(data)
    	if retData.data then
    		self:setListData(retData.data)
    	else
    		RETRY_TIMES = RETRY_TIMES - 1
	        if RETRY_TIMES > 0 then
	            self.requestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.getRecordData_), 1)
	        end
    	end
    end,
    function ()
        RETRY_TIMES = RETRY_TIMES - 1
        if RETRY_TIMES > 0 then
            self.requestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.getRecordData_), 1)
        end
    end)
end

function HolidayRecordPopup:onCleanup()
	sa.HttpService.CANCEL(self.requestId_)

	if self.requestScheduleHandle_ then
		scheduler.unscheduleGlobal(self.requestScheduleHandle_)
	end
end

return HolidayRecordPopup
