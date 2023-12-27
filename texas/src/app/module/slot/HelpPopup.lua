local HelpPopup = class("HelpPopup", function()
    return display.newNode()
end)

local HelpPopupItem = import(".HelpPopupItem")

local WIDTH, HEIGHT = 1037, 731

local configTable = {
    {{"A", "A", "A"}, "1000"}, {{"B", "B", "B"}, "100"},
    {{"C", "C", "C"}, "50"},  {{"D", "D", "D"}, "20"},
    {{"E", "E", "E"}, "10"},   {{"F", "F", "F"}, "8"},
    {{"G", "G", "G"}, "8"},      {{"H", "H", "H"}, "5"},
    {{"I", "I", "I"}, "5"},   {{"J", "J", "J"}, "5"},
    {{"A", "A", "X"}, "3"},   {{"B", "B", "X"}, "3"},
    {{"C", "C", "X"}, "3"},   {{"X", "A", "A"}, "3"},
    {{"X", "B", "B"}, "3"},   {{"X", "C", "C"}, "3"},
    {{"A", "X", "A"}, "3"},   {{"B", "X", "B"}, "3"},
    {{"C", "X", "C"}, "3"},   {{"Y", "Y", "X"}, "2"},
    {{"X", "Y", "Y"}, "2"},   {{"Y", "X", "Y"}, "2"}
}

function HelpPopup:ctor(blind, config)
    self.blind_ = blind
    self.config = config
    self:addMainUI_()
end

function HelpPopup:addMainUI_()
    local bg = display.newSprite("#slot_background.png"):addTo(self):setTouchEnabled(true)

    display.newSprite("#lang/slot_help_title.png")
        :pos(WIDTH/2, HEIGHT - 50)
        :addTo(bg)

    ui.newTTFLabel({text = sa.LangUtil.getText("SLOT", "HELP_TIPS", sa.formatBigNumber(self.blind_ * 1000)), size = 30, color = cc.c3b(0xff, 0xeb, 0x8f), align = ui.TEXT_ALIGN_CENTER})
        :align(display.TOP_CENTER, WIDTH/2, HEIGHT - 95)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#slot_close_btn_normal.png", pressed = "#slot_close_btn_pressed.png"})
        :pos(WIDTH - 55, HEIGHT - 100)
        :onButtonClicked(buttontHandler(self, self.onCloseClicked_))
        :addTo(bg)

    local frame_w, frame_h = 994, 526
    local frame = display.newScale9Sprite("#slot_help_bg.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.BOTTOM_CENTER, WIDTH/2, 25)
        :addTo(bg)


    local blind = sa.formatBigNumber(self.blind_) .. " * "

    --大条目
    local x, y = 13, frame_h - 52
    local dir = 502
    HelpPopupItem.new(configTable[1][1], blind .. self:getConfigData(configTable[1][1], 1), true)
        :align(display.LEFT_CENTER, x, y)
        :addTo(frame)

    HelpPopupItem.new(configTable[2][1], blind .. self:getConfigData(configTable[2][1], 2), true)
        :align(display.LEFT_CENTER, x + dir, y)
        :addTo(frame)

    --小条目
    y = y - 75
    dir = 332
    local offsetY = 60
    for i = 3, 18, 3 do
        HelpPopupItem.new(configTable[i][1], blind .. self:getConfigData(configTable[i][1],i))
            :align(display.LEFT_CENTER, x, y)
            :addTo(frame)

        HelpPopupItem.new(configTable[i + 1][1], blind .. self:getConfigData(configTable[i + 1][1],i+1))
            :align(display.LEFT_CENTER, x + dir, y)
            :addTo(frame)

        HelpPopupItem.new(configTable[i + 2][1], blind .. self:getConfigData(configTable[i + 2][1],i+2))
            :align(display.LEFT_CENTER, x + dir * 2, y)
            :addTo(frame)

        y = y - offsetY
    end

    HelpPopupItem.new(configTable[21][1], blind .. self:getConfigData(configTable[21][1],21))
        :align(display.LEFT_CENTER, x, y)
        :addTo(frame)

    HelpPopupItem.new(configTable[22][1], blind .. self:getConfigData(configTable[22][1],22))
        :align(display.LEFT_CENTER, x + dir, y)
        :addTo(frame)
end



function HelpPopup:onCloseClicked_()
    self:hidePanel()
end

function HelpPopup:getConfigData(cardtype,index)
    local txt = ""
    for k,v in ipairs(cardtype) do
        txt = txt .. v
    end

    if self.config then
        for k,v in ipairs(self.config) do
            if txt == v[1] then
                return v[2]
            end
        end
    end

    return configTable[index][2]
end

function HelpPopup:showPanel(inRoom)
    tx.PopupManager:addPopup(self)
end

function HelpPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

return HelpPopup