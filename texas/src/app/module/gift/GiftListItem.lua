-- 礼物列表元素

local GiftListItem = class("GiftListItem", sa.ui.ListItem)
local AnimationIcon = import("openpoker.ui.AnimationIcon")
local SimpleAvatar  = import("openpoker.ui.SimpleAvatar")

local ITEM_DISTANCE = 160
local ITEM_TEXT_COLOR = styles.FONT_COLOR.CONTENT_TEXT
local ITEM_W, ITEM_H = 800, 180
local GIFT_MAX_W, GIFT_MAX_H = 100, 100 --礼物最大宽高

function GiftListItem:ctor(uid, useIdArray, toUidArr)
    self:setNodeEventEnabled(true)
    GiftListItem.super.ctor(self, ITEM_W, ITEM_H)

    local posY = ITEM_H/2
    self.btnGroups = {}
    self.giftIcons = {}
    self.hotIcons = {}
    self.newIcons = {}

    local btn_w, btn_h = 150, 176
    for i = 1, 5 do
        self.btnGroups[i] = cc.ui.UICheckBoxButton.new({
                on="#common/pop_list_item_selected.png",
                off="#common/pop_list_item_bg.png",
                off_pressed = "#common/pop_list_item_pressed.png"},
                {scale9 = true}
            )
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel(ui.newTTFLabel({text="", size=24, color=cc.c3b(0xb2, 0xdc, 0xff)}))
            :setButtonLabelOffset(0, -55)
            :setButtonLabelAlignment(display.CENTER)
            :pos(80 + ITEM_DISTANCE * (i - 1), posY)
            :onButtonStateChanged(handler(self, self.selectChangeListener))
            :addTo(self)
            :hide()

        self.btnGroups[i]:setTouchSwallowEnabled(false)

        self.giftIcons[i] = AnimationIcon.new(nil, 1.0, 0.5)
            :pos(0, 24)
            :addTo(self.btnGroups[i])

        local x, y = -46, 56
        self.hotIcons[i] = display.newSprite("#common/pop_hot_mark.png")
            :pos(x, y)
            :addTo(self.btnGroups[i])
            :hide()
            
        self.newIcons[i] = display.newSprite("#common/pop_new_mark.png")
            :pos(x, y)
            :addTo(self.btnGroups[i])
            :hide()
    end
end

function GiftListItem:setData(data)
    local dataChanged = (self.data_ ~= data)
    self.data_ = data
    if self.onDataSet then
        self:onDataSet(dataChanged, data)
    end

    return self
end

function GiftListItem:onDataSet(dataChanged, data)
    for i = 1, 5 do
        if #data >= i then
            self.owner_.btnGroup_:addButton(self.btnGroups[i]:show(), data[i].id)
        else
            self.btnGroups[i]:hide()
        end
    end

    -- 加载礼物纹理
    self:loadImageTexture(data)

    -- 加载礼物价格
    self:loadGiftPrice(data)

    -- 加载礼物ID
    self:loadGiftId(data)
end

function GiftListItem:loadGiftId(data)
    for i = 1, #data do
        self.btnGroups[i].ID = data[i].id 
        self.btnGroups[i].positionId = 1
    end
end

function GiftListItem:loadGiftPrice(data)
    local lblStr
    local lbl
    for i = 1, #data do
        lblStr = sa.formatBigNumber(data[i].price or 0).."("..data[i].expireDay ..sa.LangUtil.getText("GIFT","DATA_LABEL")..")"

        lbl = ui.newTTFLabel({text= lblStr, size=22, color=ITEM_TEXT_COLOR})
        self.btnGroups[i]:setButtonLabel("off", lbl)
        sa.fitSprteWidth(lbl, 130)

        if data[i].property then
            if data[i].property == "1" then
                self.hotIcons[i]:show()
            elseif data[i].property == "2" then
                self.newIcons[i]:show()
            else
                self.hotIcons[i]:hide()
                self.newIcons[i]:hide()
            end
        end
    end
end

function GiftListItem:loadImageTexture(data)
    for i = 1, #data do
        if data[i].img and string.len(data[i].img) > 0 then
            self.giftIcons[i]:onData(data[i].imgUrl, GIFT_MAX_W, GIFT_MAX_H, nil, 12)
        end
    end
end

function GiftListItem:selectChangeListener(event)
    if event.target:isButtonSelected()  then
        local selectGiftId = event.target.ID
        local selectGiftName = event.target.name
        local positionId = event.target.positionId
        sa.EventCenter:dispatchEvent({name = tx.eventNames.GET_CUR_SELECT_GIFT_ID, data = {giftId = selectGiftId}})
    else
        
    end
end

return GiftListItem