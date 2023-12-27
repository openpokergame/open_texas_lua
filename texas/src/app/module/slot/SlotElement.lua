-- 老虎机元素
local SlotElement = class("SlotElement", function()
    return display.newNode()
end)

local elements = {
    A = "#slot_element_red7.png",
    B = "#slot_element_bule7.png",
    C = "#slot_element_diamond.png",
    D = "#slot_element_bin.png",
    E = "#slot_element_cherry.png",
    F = "#slot_element_ling.png",
    G = "#slot_element_orange.png",
    H = "#slot_element_watermelon.png",
    I = "#slot_element_lemon.png",
    J = "#slot_element_bar.png"
}

local ACCELERATE_TIME = 1.5
local UNIFORM_TIME = 1.5
local DECELERATE_TIME = 1.5

function SlotElement:ctor()
    local padding = 0
    self.heights = {}
    local sumHeight = 0

    local batch = display.newNode():addTo(self)

    local J0height = 250
    local J0 = display.newSprite(elements.J):addTo(batch):pos(0, -J0height - padding)

    local Aheight = 250
    local A = display.newSprite(elements.A):addTo(batch):pos(0, sumHeight)
    self.heights.A = sumHeight

    sumHeight = sumHeight + Aheight + padding
    local Bheight = 250
    local B = display.newSprite(elements.B):addTo(batch):pos(0, sumHeight)
    self.heights.B = sumHeight

    sumHeight = sumHeight + Bheight + padding
    local Cheight = 250
    local C = display.newSprite(elements.C):addTo(batch):pos(0, sumHeight)
    self.heights.C = sumHeight

    sumHeight = sumHeight + Cheight + padding
    local Dheight = 250
    local D = display.newSprite(elements.D):addTo(batch):pos(0, sumHeight)
    self.heights.D = sumHeight

    sumHeight = sumHeight + Dheight + padding
    local Eheight = 250
    local E = display.newSprite(elements.E):addTo(batch):pos(0, sumHeight)
    self.heights.E = sumHeight

    sumHeight = sumHeight + Eheight + padding
    local Fheight = 250
    local F = display.newSprite(elements.F):addTo(batch):pos(0, sumHeight)
    self.heights.F = sumHeight

    sumHeight = sumHeight + Fheight + padding
    local Gheight = 250
    local G = display.newSprite(elements.G):addTo(batch):pos(0, sumHeight)
    self.heights.G = sumHeight

    sumHeight = sumHeight + Gheight + padding
    local Hheight = 250
    local H = display.newSprite(elements.H):addTo(batch):pos(0, sumHeight)
    self.heights.H = sumHeight

    sumHeight = sumHeight + Hheight + padding
    local Iheight = 250
    local I = display.newSprite(elements.I):addTo(batch):pos(0, sumHeight)
    self.heights.I = sumHeight

    sumHeight = sumHeight + Iheight + padding
    local Jheight = 250
    local J = display.newSprite(elements.J):addTo(batch):pos(0, sumHeight)
    self.heights.J = sumHeight

    --second
    sumHeight = sumHeight + Jheight + padding
    local A2 = display.newSprite(elements.A):addTo(batch):pos(0, sumHeight)
    self.heights.A2 = sumHeight

    sumHeight = sumHeight + Aheight + padding
    local B2 = display.newSprite(elements.B):addTo(batch):pos(0, sumHeight)
    self.heights.B2 = sumHeight

    sumHeight = sumHeight + Bheight + padding
    local C2 = display.newSprite(elements.C):addTo(batch):pos(0, sumHeight)
    self.heights.C2 = sumHeight

    sumHeight = sumHeight + Cheight + padding
    local D2 = display.newSprite(elements.D):addTo(batch):pos(0, sumHeight)
    self.heights.D2 = sumHeight

    sumHeight = sumHeight + Dheight + padding
    local E2 = display.newSprite(elements.E):addTo(batch):pos(0, sumHeight)
    self.heights.E2 = sumHeight

    sumHeight = sumHeight + Eheight + padding
    local F2 = display.newSprite(elements.F):addTo(batch):pos(0, sumHeight)
    self.heights.F2 = sumHeight

    sumHeight = sumHeight + Fheight + padding
    local G2 = display.newSprite(elements.G):addTo(batch):pos(0, sumHeight)
    self.heights.G2 = sumHeight

    sumHeight = sumHeight + Gheight + padding
    local H2 = display.newSprite(elements.H):addTo(batch):pos(0, sumHeight)
    self.heights.H2 = sumHeight

    sumHeight = sumHeight + Hheight + padding
    local I2 = display.newSprite(elements.I):addTo(batch):pos(0, sumHeight)
    self.heights.I2 = sumHeight

    sumHeight = sumHeight + Iheight + padding
    local J2 = display.newSprite(elements.J):addTo(batch):pos(0, sumHeight)
    self.heights.J2 = sumHeight + Jheight + padding

    self.sumHeight_ = self.heights.J2
end

function SlotElement:start(isAccelerate, callback)
    self:stopAllActions()
    self:show()
    local move
    local py = -self.heights.J2
    if isAccelerate then
        move = cc.EaseSineIn:create(cc.MoveTo:create(ACCELERATE_TIME, cc.p(0, py)))
    else
        move = cc.MoveTo:create(UNIFORM_TIME, cc.p(0, py))
    end

    local sequence = transition.sequence({
        move,
        cc.CallFunc:create(function() 
            self:pos(0, self.heights.C)
            self:hide()
            if callback then
                callback()
            end
        end),
    })
    self:runAction(sequence)
end

function SlotElement:turnToWhich(element, callback)
    self:show()
    local sequence = transition.sequence({
            cc.EaseSineOut:create(cc.MoveTo:create(DECELERATE_TIME, cc.p(0, -self.heights[element]))),
            cc.CallFunc:create(function()
                if callback then
                    callback()
                end
            end),
        })
    self:runAction(sequence)
end

function SlotElement:stop()
    self:stopAllActions()
end

return SlotElement