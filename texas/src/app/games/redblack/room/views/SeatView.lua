local SeatView = class("SeatView", function() 
    return display.newNode()
end)

local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local OtherUserRoomPopup = import("app.module.userInfo.OtherUserRoomPopup")

function SeatView:ctor(ctx)
    self.data_ = nil
    self.ctx = ctx
    self.avatar_ = SimpleAvatar.new({
            shapeImg = "#redblack/room/redblack_head_bg.png",
            frameImg = "#redblack/room/redblack_head_frame.png",
        })
        :addTo(self)
    NormalButton(self.avatar_):onButtonClicked(buttontHandler(self, self.onUserInfoClicked_))

    local w, h = 100, 40
    self.frame_ = display.newScale9Sprite("#redblack/room/redblack_chips_frame.png", 0, 0, cc.size(w, h))
        :pos(0, -55)
        :addTo(self)

    self.money_ = ui.newTTFLabel({text = "", size = 24, color = styles.FONT_COLOR.CHIP_TEXT})
        :pos(w*0.5, h*0.5)
        :addTo(self.frame_)

    self:removeData()
end

function SeatView:onUserInfoClicked_()
    if not self.data_ then
        return
    end

    if self.isUserInfoClick_ then
        return
    end

    if self.data_.uid == tx.userData.uid then
        return
    end

    self.isUserInfoClick_ = true
    tx.schedulerPool:delayCall(function()
        self.isUserInfoClick_ = false
    end, 0.5)

    OtherUserRoomPopup.new(self.ctx, self.data_):showPanel()
end

function SeatView:setData(data)
    self.data_ = data
    if self.data_ == nil then
        self:removeData()
        return
    end

    self.avatar_:setDefaultAvatar(data.sex)

    if data.img and string.len(data.img) > 5 then
        local imgurl = data.img
        if string.find(imgurl, "facebook") then
            if string.find(imgurl, "?") then
                imgurl = imgurl .. "&width=200&height=200"
            else
                imgurl = imgurl .. "?width=200&height=200"
            end
        end
        self.avatar_:loadImage(imgurl)
    end

    self.frame_:show()
    self.money_:setString(sa.formatBigNumber(data.money))
    sa.fitSprteWidth(self.money_, 90)
end

function SeatView:removeData()
    self.data_ = nil
    self.avatar_:setSpriteFrame("redblack/room/redblack_head_bg.png")
    self.frame_:hide()
end

function SeatView:setSeatId(seatId)
    if self.data_ then
        self.data_.seatId = seatId
    end
end

function SeatView:dispose()
end

return SeatView