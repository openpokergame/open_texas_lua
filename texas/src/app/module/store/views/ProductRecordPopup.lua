local ProductRecordPopup = class("ProductRecordPopup", tx.ui.Panel)
local HistoryListItem = import(".HistoryListItem")

local WIDTH, HEIGHT = 830, 570
local LIST_WIDTH, LIST_HEIGHT =  WIDTH - 80, HEIGHT - 170

function ProductRecordPopup:ctor()
	ProductRecordPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("STORE", "TITLE_HISTORY"), true)

    HistoryListItem.WIDTH = LIST_WIDTH
    HistoryListItem.HEIGHT =  70

    self:setLoadingPosition(0, -50)
    self:addHistoryPage_()
    self:setLoading(true)
    self:loadHistory()
end

function ProductRecordPopup:loadHistory()
    sa.HttpService.CANCEL(self.requestPayRecordId_)
    self.requestPayRecordId_ = sa.HttpService.POST(
        {
            mod = "User",
            act = "getMyOrderList",
        },
        function(retData)
            local ret = json.decode(retData)
            if ret then
                -- ret = {
                --     code=1,
                --     list={
                --         {gid=1,gname="hhkh",order_time=os.time()},
                --         {gid=1,gname="hhkh",order_time=os.time()},
                --         {gid=1,gname="hhkh",order_time=os.time()},
                --         {gid=1,gname="hhkh",order_time=os.time()},
                --         {gid=1,gname="hhkh",order_time=os.time()},
                --     }
                -- }
                if ret.code==1 then
                    self:setlist_(ret.list)
                elseif ret.code==-2 then
                    self:setlist_(sa.LangUtil.getText("STORE","NO_BUY_HISTORY_HINT"))
                end    
            end
        end,
        function (error)
            -- self:setlist_(sa.LangUtil.getText("STORE","NO_BUY_HISTORY_HINT"))
        end
    )
end

function ProductRecordPopup:addHistoryPage_()
    local page = display.newNode():addTo(self)
    local pageX, pageY = 0, -45

    self.list_ = sa.ui.ListView.new({
            viewRect = cc.rect(-0.5 * LIST_WIDTH, -0.5 * LIST_HEIGHT, LIST_WIDTH, LIST_HEIGHT),
            direction = sa.ui.ListView.DIRECTION_VERTICAL
        }, HistoryListItem)
        :pos(pageX, pageY)
        :addTo(page)

    self.listMsg_ = ui.newTTFLabel({text = "", size = 24, align = ui.TEXT_ALIGN_CENTER})
        :pos(pageX, pageY)
        :addTo(page)
        :hide()

    return page
end

function ProductRecordPopup:setlist_(data)
    if data then
        local listData = data
        
        self:setLoading(false)
        if type(listData) == "string" then
            self.listMsg_:setString(listData)
            self.listMsg_:show()
            self.list_:setData(nil)
        else
            self.listMsg_:hide()
            self.list_:setData(listData)
            self:updateTouchRect_()
        end
    else
        self.list_:setData(nil)
        self.listMsg_:hide()
    end
end

function ProductRecordPopup:updateTouchRect_()
    if self.list_ then
        self.list_:setScrollContentTouchRect()
    end
end

function ProductRecordPopup:onShowed()
    self:updateTouchRect_()
end

function ProductRecordPopup:show()
    self:showPanel_()
end

function ProductRecordPopup:onCleanup()
    sa.HttpService.CANCEL(self.requestPayRecordId_)
end

return ProductRecordPopup
