local HolidayBasePopup = class("HolidayBasePopup", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 750, 550

function HolidayBasePopup:ctor(args)
    WIDTH, HEIGHT = args[1], args[2]
    self:size(WIDTH, HEIGHT)
    self:align(display.CENTER)
    self:setNodeEventEnabled(true)

    local cx, cy = WIDTH*0.5, HEIGHT*0.5
    local bg = display.newSprite("holiday_shake_reward_bg.jpg")
        :pos(cx, cy)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)

    self.title_ = ui.newTTFLabel({text = "", size = 40, color = cc.c3b(0xa3, 0x0, 0x0)})
        :pos(cx, HEIGHT - 40)
        :addTo(self)

    cc.ui.UIPushButton.new({normal = "#common/btn_close.png", pressed="#common/btn_close_down.png"})
        :pos(WIDTH - 40, HEIGHT - 40)
        :onButtonClicked(function()
            self:hidePanel()
            tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
        end)
        :addTo(self)
end

function HolidayBasePopup:setTextTitle(title)
    self.title_:setString(title)
end

function HolidayBasePopup:addList(itemClass, title)
    local list_w, list_h = w or 680, h or 410
    local list_x, list_y = x or WIDTH*0.5, y or 220

    if title then
        list_h = 380
        list_y = 200

        local frame_w, frame_h = list_w - 10, 46
        local frame = display.newScale9Sprite("#holiday_shake_ranking_frame.png", 0, 0, cc.size(frame_w, frame_h))
            :pos(list_x, 420)
            :addTo(self)

        local sy = frame_h*0.5
        local pos_x = {50, 190, 400, 590}
        for i, v in ipairs(title) do
            ui.newTTFLabel({text = v, size = 24})
                :pos(pos_x[i], sy)
                :addTo(frame)
        end
    end
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h),
            upRefresh = handler(self, self.onRefreshData_)
        }, 
        itemClass
    )
    :hideScrollBar()
    :pos(list_x, list_y)
    :addTo(self)
end

function HolidayBasePopup:onRefreshData_()
end

function HolidayBasePopup:setListData(data)
    self.list_:setData(data)
end

function HolidayBasePopup:showPanel()
    tx.PopupManager:addPopup(self)

    return self
end

function HolidayBasePopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function HolidayBasePopup:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(WIDTH*0.5, HEIGHT*0.5)
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

function HolidayBasePopup:onShowed()
    if self.list_ then
        self.list_:setScrollContentTouchRect()
    end
end

return HolidayBasePopup
