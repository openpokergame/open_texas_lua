local Panel = import("app.pokerUI.Panel")
local ScrollLabel = import("openpoker.ui.ScrollLabel")
local UpdatePopup = class("UpdatePopup", Panel)

local WIDTH, HEIGHT = 830, 570

function UpdatePopup:ctor(verTitle, verMessage, updateUrl)
    UpdatePopup.super.ctor(self, {WIDTH, HEIGHT})

    local bg = self.background_
    local x = WIDTH*0.5
    self.updateUrl_ = updateUrl

    self:setTextTitleStyle(sa.LangUtil.getText("UPDATE", "TITLE"))

    local frame_w, frame_h = WIDTH - 56, 290
    local frame = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.BOTTOM_CENTER, x, 160)
        :addTo(self.background_)

    display.newSprite("img/update_icon.png")
        :pos(140, frame_h*0.5)
        :addTo(frame)

    local dw, dh = 470, 240
    self.updateLabel = ScrollLabel.new(
            {
                text = "",
                color = styles.FONT_COLOR.CONTENT_TEXT,
                size = 25,
                align = ui.TEXT_ALIGN_LEFT,
                valign = ui.TEXT_VALIGN_TOP,
                dimensions = cc.size(dw, dh)
            },
            {
                viewRect = cc.rect(-dw * 0.5, -dh * 0.5, dw, dh)
            })
        :pos(frame_w*0.5 + 150, frame_h*0.5)
        :addTo(frame)
    self.updateLabel:setString(verMessage)

    local btn_w, btn_h = 326, 146
    local dir = 200
    cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("COMMON", "SHARE"), size = 26}))
        :onButtonClicked(buttontHandler(self, self.onShareClicked_))
        :pos(x - 200, 95)
        :addTo(bg) 

    --立即升级
    cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("UPDATE", "UPDATE_NOW"), size = 26}))
        :onButtonClicked(buttontHandler(self, self.onUpdateClicked_))
        :pos(x + 200, 95)
        :addTo(bg)
end

function UpdatePopup:onShowed()
    self.updateLabel:setScrollContentTouchRect()
end

function UpdatePopup:onShareClicked_()
    local feedData = clone(sa.LangUtil.getText("FEED", "INVITE_FRIEND"))
    tx.ShareSDK:shareFeed(feedData, function(success, result)
        if success then
            self:hidePanel_()
        end
    end)
end

function UpdatePopup:onUpdateClicked_()
    device.openURL(self.updateUrl_)
end

return UpdatePopup