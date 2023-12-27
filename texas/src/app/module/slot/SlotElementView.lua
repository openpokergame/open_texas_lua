-- 管理元素，负责滚动

local SlotElementView = class("SlotElementView", function()
    return display.newNode()
end)

local SlotElement = import(".SlotElement")

function SlotElementView:ctor()
    self.view1 = SlotElement.new():addTo(self)
    self.view2 = SlotElement.new():addTo(self):hide()
end

function SlotElementView:start(element, callback)
    self.view1:start(true, function()
        self.view2:start(false, function()
            self.view1:turnToWhich(element, callback)
        end)
    end)
end

function SlotElementView:stop()
    self.view1:stop()
    self.view2:stop()
end

return SlotElementView