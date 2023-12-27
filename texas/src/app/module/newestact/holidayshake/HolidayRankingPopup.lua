--赠送记录弹窗
local HolidayBasePopup = import(".HolidayBasePopup")
local HolidayRankingPopup = class("HolidayRankingPopup", HolidayBasePopup)
local HolidayRankingItem = import(".HolidayRankingItem")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local WIDTH, HEIGHT = 750, 550
local RETRY_TIMES = 3

function HolidayRankingPopup:ctor()
	HolidayRankingPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitle(sa.LangUtil.getText("NEWESTACT","HOLIDAY_SHAKE_RANKING"))

    self:addList(HolidayRankingItem, sa.LangUtil.getText("NEWESTACT","HOLIDAY_SHAKE_RANKING_TITLE"))

    ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT","HOLIDAY_SHAKE_RANKING_TIPS"), size = 22, color = cc.c3b(0xa3, 0x0, 0x0)})
        :pos(WIDTH*0.5, HEIGHT - 85)
        :addTo(self)

    RETRY_TIMES = 3

    self:getRankingData_()
end

function HolidayRankingPopup:getRankingData_()
	self:setLoading(true)
	sa.HttpService.CANCEL(self.requestId_)
    self.requestId_ = sa.HttpService.POST(
    {
        mod = "Activity",
        act = "getSendMoneyRank",
    },
    function(data)
    	self:setLoading(false)
    	local retData = json.decode(data)
    	if retData.data then
    		self:setListData(retData.data)
    	else
    		RETRY_TIMES = RETRY_TIMES - 1
	        if RETRY_TIMES > 0 then
	            self.requestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.getRankingData_), 1)
	        end
    	end
    end,
    function ()
        RETRY_TIMES = RETRY_TIMES - 1
        if RETRY_TIMES > 0 then
            self.requestScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.getRankingData_), 1)
        end
    end)
end

function HolidayRankingPopup:onCleanup()
	sa.HttpService.CANCEL(self.requestId_)

	if self.requestScheduleHandle_ then
		scheduler.unscheduleGlobal(self.requestScheduleHandle_)
	end
end

return HolidayRankingPopup
