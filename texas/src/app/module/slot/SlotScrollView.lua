-- 滚动视图
local SlotScrollView = class("SlotScrollView", function()
    return display.newNode()
end)

local SlotElementView = import(".SlotElementView")

local WIDTH, HEIGHT = 992, 442

function SlotScrollView:ctor(callback)
    self.callback_ = callback
    self.schedulerPool_ = sa.SchedulerPool.new()

    display.newScale9Sprite("#slot_content_bg.jpg")
        :addTo(self)

    --滚动条elements
    local dir = WIDTH / 3
    local elementNode = display.newNode()
    local elementLeft = SlotElementView.new()
        :pos(-dir, 0)
        :addTo(elementNode)

    local elementMiddle = SlotElementView.new()
        :pos(0, 0)
        :addTo(elementNode)

    local elementRight = SlotElementView.new()
        :pos(dir, 0)
        :addTo(elementNode)

    self.elementViews_ = {elementLeft, elementMiddle, elementRight}

    --遮罩模板
    local width, height = 953, 393
    local clipNode = cc.ClippingNode:create():addTo(self)
    local stencil = display.newDrawNode()
    local stencilPadding = 5
    stencil:drawPolygon({
            {-width/2, -height/2 + stencilPadding},
            {-width/2, height/2 - stencilPadding},
            {width/2, height/2 - stencilPadding},
            {width/2, -height/2 + stencilPadding}
        })
    clipNode:setStencil(stencil)
    clipNode:addChild(elementNode)

    local posX = {-dir, 0, dir}
    for i = 1, 3 do
        display.newSprite("#slot_top_shadow.png")
            :align(display.TOP_CENTER, posX[i], HEIGHT/2 - 25)
            :addTo(self)

        display.newSprite("#slot_bottom_shadow.png")
            :align(display.BOTTOM_CENTER, posX[i], -HEIGHT/2 + 27)
            :addTo(self)
    end
end

function SlotScrollView:start(data)
    local changeValues = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J"}
    local values = data.values
    local value1 = changeValues[values[1] + 1]
    local value2 = changeValues[values[2] + 1]
    local value3 = changeValues[values[3] + 1]

    print("SlotScrollView:start", value1, value2, value3)
    local elements = {value1, value2, value3}
    local rewardMoney = data.rewardMoney
    local leftMoney = data.totalNum
    self.schedulerPool_:clearAll()
    for i, element in ipairs(self.elementViews_) do
        self.schedulerPool_:delayCall(function()
            element:start(elements[i], function()
                self.callback_(i, rewardMoney, leftMoney)
            end)
        end, 0.5 * (i - 1))
    end
end

function SlotScrollView:stop()
    for i, element in ipairs(self.elementViews_) do
        element:stop()
    end
    self.schedulerPool_:clearAll()
end

function SlotScrollView:dispose()
    self:stop()
end

return SlotScrollView