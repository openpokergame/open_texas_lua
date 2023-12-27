--玩牌活动
local PlayCardContent = class("PlayCardContent", function()
    return display.newNode()
end)

local PlayCardListItem = import(".PlayCardListItem")

local WIDTH, HEIGHT = 820, 590

function PlayCardContent:ctor(data)
    local x = WIDTH*0.5
    local sy = HEIGHT - 65
    ui.newTTFLabel({text = data.title, color = cc.c3b(0xff, 0xe0, 0x75), size = 50})
        :pos(x, sy)
        :addTo(self)

    sy = sy - 65
    ui.newTTFLabel({text = data.time, size = 30})
        :pos(x, sy)
        :addTo(self)

    local titleX = {100, 260, 400, 530}
    local title = sa.LangUtil.getText("NEWESTACT","PLAY_CARD_LIST_TITLE")
    for i = 1, 4 do
        ui.newTTFLabel({text = title[i], size = 24, color = cc.c3b(0xff, 0x81, 0xa6)})
            :pos(titleX[i], sy - 35)
            :addTo(self)
    end

    sy = sy - 250
    local list_w, list_h = WIDTH, 400
    self.list_ = sa.ui.ListView.new(
        {
            viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h)
        }, 
        PlayCardListItem
    )
    :pos(x, sy)
    :addTo(self)

    self.list_:setData(data.list)

    self:schedule(function()
        self.list_:setScrollContentTouchRect()
    end, 0.5)
end

return PlayCardContent