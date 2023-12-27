local logger = sa.Logger.new("FirstPayButton")
local FirstPayButton = class("FirstPayButton", function ()
    return display.newNode()
end)

function FirstPayButton:ctor(goods)
    local btn = sp.SkeletonAnimation:create("spine/ann.json","spine/ann.atlas")
        :size(75, 75)
        :align(display.CENTER)
        :addTo(self)

    NormalButton(btn)
        :onButtonClicked(buttontHandler(self, self.onFirstPayClick_))
        :onButtonPressed(function()
            btn:setAnimation(0, 3, false)
            btn:addAnimation(0, 2, true)
        end)
    btn:setAnimation(0, 2, true)
end

function FirstPayButton:onFirstPayClick_()
    tx.PayGuideManager:quickPayGuide()
end

return FirstPayButton