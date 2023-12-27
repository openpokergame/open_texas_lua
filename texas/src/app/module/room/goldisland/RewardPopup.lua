local RewardPopup = class("RewardPopup", tx.ui.Panel)
local WIDTH, HEIGHT = 830, 570
local PokerCard = tx.ui.PokerCard

function RewardPopup:ctor(data)
	RewardPopup.super.ctor(self, {WIDTH, HEIGHT})

	self:setTextTitleStyle(sa.LangUtil.getText("GOLDISLAND", "REWARD_TITLE"))

    local bg = self.background_

    local frame_w, frame_h = 774, 310
    local frame = display.newSprite("img/goldisland_bg_2.jpg")
        :pos(WIDTH*0.5, HEIGHT*0.5 + 25)
        :addTo(bg)

    local x = 400
    local cardTypes = sa.LangUtil.getText("COMMON", "CARD_TYPE")
    ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "CARD_TYPE", cardTypes[data.cardType]), size = 26})
        :align(display.LEFT_CENTER, x, 280)
        :addTo(frame)

    local cards = data.cards
    local sx, sy = x + 30, 220
    local dir = 60
    for i = 1, 5 do
        PokerCard.new()
            :showFront()
            :setCard(cards[i])
            :scale(0.48)
            :pos(sx + (i - 1) * dir, sy)
            :addTo(frame)
    end

    ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "REWARD_NUM", data.percent), size = 26})
        :align(display.LEFT_CENTER, x, 140)
        :addTo(frame)
    
    local label = ui.newTTFLabel({text = sa.formatNumberWithSplit(data.reward), size = 60, color = styles.FONT_COLOR.CHIP_TEXT})
        :align(display.LEFT_CENTER, x, 90)
        :addTo(frame)
    sa.fitSprteWidth(label, 360)

    ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "REWARD_TIPS"), size = 26})
        :align(display.LEFT_CENTER, x, 40)
        :addTo(frame)

    cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
        :setButtonSize(330, 146)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("GOLDISLAND", "REWARD_BTN"), size = 40}))
        :pos(WIDTH*0.5, 90)
        :onButtonClicked(function()
            self:hidePanel()
        end)
        :addTo(bg)
end

return RewardPopup