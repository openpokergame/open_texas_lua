local HelpPopupItem = class("HelpPopupItem", function()
    return display.newNode()
end)

--大条目
local bigItemWidth = 464
local bigItemHeight = 76
HelpPopupItem.BIG_WIDTH = bigItemWidth
HelpPopupItem.BIG_HEIGHT = bigItemHeight

--小条目
local smallItemWidth = 304
local smallItemHeight = 52
HelpPopupItem.SMALL_WIDTH = smallItemWidth
HelpPopupItem.SMALL_HEIGHT = smallItemHeight

local textColor = cc.c3b(0x00, 0x00, 0x00)
local textBigSize = 30
local textSmallSize = 20

local elements = {
    A = "#slot_help_element_red7.png",
    B = "#slot_help_element_bule7.png",
    C = "#slot_help_element_diamond.png",
    D = "#slot_help_element_bin.png",
    E = "#slot_help_element_cherry.png",
    F = "#slot_help_element_ling.png",
    G = "#slot_help_element_orange.png",
    H = "#slot_help_element_watermelon.png",
    I = "#slot_help_element_lemon.png",
    J = "#slot_help_element_bar.png",
    X = "#slot_help_element_any.png",
    Y = "#slot_help_element_same.png"
}

function HelpPopupItem:ctor(types, multiple, isBig)
    local width, height = smallItemWidth, smallItemHeight
    local typeScale = 1
    local labelTextSize = textSmallSize
    local type2MarginLeft = 5
    local type3MarginLeft = 5

    local num = 0
    for _, v in ipairs(types) do
        if v == "A" or v == "B" then
            num = num + 1
        end
    end

    if num == 3 then
        typeScale = 1.5
    end

    if isBig then
        width, height = bigItemWidth, bigItemHeight
        labelTextSize = textBigSize
        type2MarginLeft = 10
        type3MarginLeft = 10
    end

    self:size(width, height)

    local bg = display.newScale9Sprite("#slot_help_reward_bg.png")
        :pos(width/2, height/2)
        :size(width, height)
        :addTo(self)

    local type1 = display.newSprite(elements[types[1]]):addTo(bg):scale(typeScale)
    local type1Size = type1:getContentSize()
    local type1MarginLeft = 15
    local posX = 0
    type1:pos(posX + typeScale * type1Size.width/2 + type1MarginLeft, typeScale * type1Size.height/2 + (height - typeScale * type1Size.height)/2)

    local type2 = display.newSprite(elements[types[2]]):addTo(bg):scale(typeScale)
    local type2Size = type2:getContentSize()
    posX = posX + typeScale * type1Size.width + type1MarginLeft
    type2:pos(posX + typeScale * type2Size.width/2 + type2MarginLeft, typeScale * type2Size.height/2 + (height - typeScale * type2Size.height)/2)

    local type3 = display.newSprite(elements[types[3]]):addTo(bg):scale(typeScale)
    local type3Size = type3:getContentSize()
    posX = posX + typeScale * type2Size.width + type2MarginLeft
    type3:pos(posX + typeScale * type3Size.width/2 + type3MarginLeft, typeScale * type3Size.height/2 + (height - typeScale * type3Size.height)/2)

    local label = ui.newTTFLabel({
            text = multiple,
            size = labelTextSize, 
            color = textColor,
            align = ui.TEXT_ALIGN_CENTER
        }):addTo(bg)
    label:setAnchorPoint(cc.p(1, 0.5))
    local labelSize = label:getContentSize()
    local labelMarginRight = 15
    label:pos(width - labelMarginRight, labelSize.height/2 + (height - labelSize.height)/2)
end

return HelpPopupItem