local PackageDetailView = class("PackageDetailView", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 515, 185

function PackageDetailView:ctor(params)
    self:size(WIDTH, HEIGHT)
    self:align(display.CENTER)

    local x, y = WIDTH*0.5, HEIGHT*0.5
    local bg = display.newScale9Sprite("#common/pop_small_tips_frame.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :pos(x, y)
        :addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)

    local label_x = 35
    ui.newTTFLabel({text = params.title, size = 32})
        :align(display.LEFT_CENTER, label_x, HEIGHT - 50)
        :addTo(bg)

    ui.newTTFLabel({text = params.desc, size = 26, dimensions = cc.size(WIDTH - 50, 0)})
        :align(display.LEFT_CENTER, label_x, 60)
        :addTo(bg)

    local x, y = WIDTH*0.5, 20 --默认箭头在中间
    local direction = params.direction
    if direction == 1 then --箭头在左边
        self:align(display.LEFT_CENTER)
        x = 75
    elseif direction == 3 then --箭头在右边
        x = WIDTH - 75
        self:align(display.RIGHT_CENTER)
    end

    display.newSprite("#common/pop_tips_arrow.png")
        :align(display.TOP_CENTER, x, y)
        :addTo(bg)
end

return PackageDetailView