local RoomLoading = class("RoomLoading", function()
    return display.newNode()
end)

function RoomLoading:ctor(tip)
    if tip == sa.LangUtil.getText("ROOM", "ENTERING_MSG") or tip == sa.LangUtil.getText("MATCH", "CHANGING_ROOM_MSG") then
        tip = tx.EnterTipsManager:getRandomTips();
        tx.EnterTipsManager:reg(self)
    end
    self:setTouchEnabled(true)
    self:setNodeEventEnabled(true)
    -- 透明触摸层
    local transparentSkin = display.newSprite("#common/transparent.png")
        :addTo(self)
    transparentSkin:setScaleX(display.width / 4)
    transparentSkin:setScaleY(display.height / 4)

    -- 背景
    local bg = display.newSprite("#common/full_screen_tip_bg.png")
        :addTo(self)
    bg:setScaleX((display.width) / bg:getContentSize().width)

    -- 加载动画
    local an = sp.SkeletonAnimation:create("spine/loding.json","spine/loding.atlas")
        :pos(0, 40)
        :addTo(self)
    an:setAnimation(0, 1, true)
    
    -- 文字
    self.lbl = ui.newTTFLabel({text = tip, color = styles.FONT_COLOR.LIGHT_TEXT, size = 28, align = ui.TEXT_ALIGN_CENTER})
        :pos(0, -50)
        :addTo(self)
end

-- 显示在最上层
function RoomLoading:addTo(parent, index)
    cc.Node.addTo(self, parent, 1001)
    return self
end

function RoomLoading:onCleanup()
    tx.EnterTipsManager:unreg(self)
    if self.roomloadingId_ then
        sa.EventCenter:removeEventListener(self.roomloadingId_)
        self.roomloadingId_ = nil;
    end
end

return RoomLoading