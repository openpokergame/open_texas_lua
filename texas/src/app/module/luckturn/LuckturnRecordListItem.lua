local LuckturnRecordListItem = class("LuckturnRecordListItem", sa.ui.ListItem)
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")

local BG_W, BG_H = 360, 55
local ITEM_W, ITEM_H = 360, 60

function LuckturnRecordListItem:ctor()
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    LuckturnRecordListItem.super.ctor(self, ITEM_W, ITEM_H)
end

function LuckturnRecordListItem:createContent_()
    local posY = BG_H/2
    local img = "#dialogs/luckturn/luckturn_record_1.png"
    if self.index_ % 2 == 1 then
        img = "#dialogs/luckturn/luckturn_record_2.png"
    end

    local frame = display.newScale9Sprite(img, ITEM_W/2, ITEM_H/2, cc.size(BG_W, BG_H)):addTo(self)
    self.frame_ = frame

    self.avatar_ = SimpleAvatar.new({shapeImg = "#dialogs/luckturn/luckturn_head_bg.png", frameImg = "#dialogs/luckturn/luckturn_head_frame.png", isRectHead = true})
        :pos(40, posY)
        :addTo(frame)

    self.reward_ =  ui.newTTFLabel({text = "", color = cc.c3b(0x76,0x5f,0xb9), size = 20, align = ui.TEXT_ALIGN_LEFT, dimensions = cc.size(270, 0)})
        :align(display.LEFT_CENTER, 75, posY)
        :addTo(frame)
end

function LuckturnRecordListItem:lazyCreateContent()
    if not self.created_ then
        self.created_ = true
        self:createContent_()
    end

    if self.dataChanged_ then
        self.dataChanged_ = false
        self:setData_(self.data_)

        local size = self.reward_:getContentSize()
        if size.height > BG_H then
            local item_h = size.height + 20
            local bg_h = item_h - 10
            self.frame_:size(BG_W, bg_h):pos(ITEM_W*0.5, item_h*0.5)

            local y = bg_h*0.5
            self.reward_:setPositionY(y)
            self.avatar_:setPositionY(y)

            self:size(ITEM_W, item_h)
            self:dispatchEvent({name="RESIZE"})
        end
    end
end

function LuckturnRecordListItem:onDataSet(dataChanged, data)
    self.dataChanged_ = self.dataChanged_ or dataChanged
    self.data_ = data
end

function LuckturnRecordListItem:setData_(data)
    if data.img and string.len(data.img) > 5 then
       self.avatar_:loadImage(data.img)
    else
        self.avatar_:setDefaultAvatar(data.sex)
    end 

    local desc = ""
    if data.money then
        desc = sa.LangUtil.getText("LUCKTURN", "CHIP_REWARD_TIPS", data.nick, sa.formatBigNumber(data.money))
    else
        desc = sa.LangUtil.getText("LUCKTURN", "PROPS_REWARD_TIPS", data.nick, data.props)
    end

    self.reward_:setString(desc)
end

return LuckturnRecordListItem