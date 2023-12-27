--充值卡兑换提示框
local CashCardTipsPopup = class("CashCardTipsPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 600

function CashCardTipsPopup:ctor()
	CashCardTipsPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("STORE", "CASH_CARD_TITLE"))

    self:addMainUI_()
end

function CashCardTipsPopup:addMainUI_()
    local frame_w, frame_h = WIDTH - 56, 350
    local frame = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 130)
        :addTo(self.background_)
    self.frame_ = frame

    local x = frame_w*0.5    
    ui.newTTFLabel({text=sa.LangUtil.getText("STORE", "CASH_CARD_TIPS_1"), size=26, color = styles.FONT_COLOR.CONTENT_TEXT, align = ui.TEXT_ALIGN_LEFT, dimensions = cc.size(650, 0)})
        :pos(x, frame_h - 50)
        :addTo(frame)

    local editbox = ui.newEditBox({image = "#common/common_edit_box_bg.png", listener = handler(self, self.onEditBoxChange_), size = cc.size(650, 64)})
        :pos(frame_w*0.5, 100)
        :addTo(frame)
    editbox:setFont(ui.DEFAULT_TTF_FONT, 30)
    editbox:setPlaceholderFont(ui.DEFAULT_TTF_FONT, 30)
    editbox:setPlaceholderFontColor(cc.c3b(0x9b, 0xa9, 0xff))
    editbox:setPlaceHolder(sa.LangUtil.getText("STORE", "CASH_CARD_TIPS_2"))
    editbox:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    editbox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    self.editbox_ = editbox

    cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
        :setButtonSize(240, 104)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("STORE", "REAL_EXCHANGE_BTN"), size = 24}))
        :onButtonClicked(buttontHandler(self, self.onExchangeClicked_))
        :pos(WIDTH*0.5, 80)
        :addTo(self.background_)
end

function CashCardTipsPopup:onEditBoxChange_(event, editbox)
    if event == "changed" then
    elseif event == "return" then
    end
end

function CashCardTipsPopup:onExchangeClicked_()
    local str = string.trim(self.editbox_:getText()) 
    local len = string.len(str)
    local num = tonumber(str)

    if num and len == 10 then
        local num1 = string.sub(str, 1, 3)
        local num2 = string.sub(str, 4, 6)
        local num3 = string.sub(str, 7)
        tx.ui.Dialog.new({
            closeWhenTouchModel = false,
            messageText = sa.LangUtil.getText("STORE", "CASH_CARD_TIPS_4", num1, num2, num3),
            callback = function (type)
                if type == tx.ui.Dialog.SECOND_BTN_CLICK then
                    
                end
            end
        }):show()
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "CASH_CARD_TIPS_3"))
    end
end

function CashCardTipsPopup:onCleanup()
end

return CashCardTipsPopup
