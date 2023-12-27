local SMS_IMG = {
    "img/checkout_guide_img_1.jpg",
    "img/checkout_guide_img_3.jpg",
    "img/checkout_guide_img_5.jpg",
    "img/checkout_guide_img_6.jpg",
}

local CARD_IMG = {
    "img/checkout_guide_img_1.jpg",
    "img/checkout_guide_img_2.jpg",
    "img/checkout_guide_img_4.jpg",
    "img/checkout_guide_img_5.jpg",
    "img/checkout_guide_img_6.jpg",
    "#checkout_guide_img_7.png",
}

local NUM_IMG = {
    "#checkout_guide_num_1.png",
    "#checkout_guide_num_2.png",
    "#checkout_guide_num_3.png",
    "#checkout_guide_num_4.png",
    "#checkout_guide_num_5.png",
    "#checkout_guide_num_6.png",
}

local TITLE_COLOR = cc.c3b(0xfc, 0xe7, 0x9c)
local TRUE_WALLET_URL = "http://ext.truemoney.com/wecard/"

local CheckoutGuidePopup = class("CheckoutGuidePopup", tx.ui.Panel)

local WIDTH, HEIGHT = 1040, 746
local LIST_W, LIST_H = WIDTH - 56, HEIGHT - 210
function CheckoutGuidePopup:ctor()
    CheckoutGuidePopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitleStyle(sa.LangUtil.getText("CHECKOUTGUIDE", "TITLE"))

    display.addSpriteFrames("checkout_guide_texture.plist", "checkout_guide_texture.png")

    self.tabTitle_ = sa.LangUtil.getText("CHECKOUTGUIDE", "TAB_TITLE")

    self:addMainUI_()
end

function CheckoutGuidePopup:addMainUI_()
    local x = WIDTH*0.5
    local bg = self.background_
    display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(WIDTH - 56, HEIGHT - 200))
        :align(display.BOTTOM_CENTER, x, 28)
        :addTo(bg)

    local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/pop_tab_normal_2.png", 
            indicator = "#common/pop_tab_selected_2.png"
        }, 
        sa.LangUtil.getText("CHECKOUTGUIDE", "TAB_TEXT"),
        {
            selectedText = {color = cc.c3b(0x6b, 0x33, 0x0), size = 24},
            defaltText = {color = styles.FONT_COLOR.CONTENT_TEXT, size = 24}
        }, true, true)
        :setTabBarSize(528, 52, 0, -4)
        :onTabChange(handler(self, self.onTabChange_))
        :pos(x, HEIGHT - 130)
        :addTo(bg)

    self:createSMSGuide_()

    self:createCardGuide_()

    tab:gotoTab(1)
end

function CheckoutGuidePopup:createSMSGuide_()
    local scrollContent = display.newNode() 
    local container = display.newNode():addTo(scrollContent)
    local sy = -50
    local imgDir = 424
    local stepDir = 84
    local stepDesc = sa.LangUtil.getText("CHECKOUTGUIDE", "SMS_STEP")

    ui.newTTFLabel({text = sa.LangUtil.getText("CHECKOUTGUIDE", "SMS_TITLE"), size = 28, color = TITLE_COLOR})
        :pos(0, sy + 25)
        :addTo(container)

    for i = 1, 4 do
        sy = sy - stepDir
        self:addStepText_(container, i, stepDesc[i], sy)

        sy = sy - imgDir
        self:addStepImg_(container, SMS_IMG[i], sy)
    end

    self.smsView_ = sa.ui.ScrollView.new({
            viewRect      = cc.rect(-LIST_W * 0.5, -LIST_H * 0.5, LIST_W, LIST_H),
            scrollContent = scrollContent,
            direction     = sa.ui.ScrollView.DIRECTION_VERTICAL,
        })
        :pos(WIDTH*0.5, LIST_H*0.5 + 33)
        :addTo(self.background_)

    local size = container:getCascadeBoundingBox()
    container:pos(0, size.height/2)
end

function CheckoutGuidePopup:createCardGuide_()
    local scrollContent = display.newNode() 
    local container = display.newNode():addTo(scrollContent)
    local sy = -50
    local imgDir = 424
    local stepDir = 84
    local stepDesc = sa.LangUtil.getText("CHECKOUTGUIDE", "CARD_STEP")
    local index = 1

    ui.newTTFLabel({text = sa.LangUtil.getText("CHECKOUTGUIDE", "CARD_TITLE"), size = 28, color = TITLE_COLOR})
        :pos(0, sy + 25)
        :addTo(container)

    for i = 1, 5 do
        sy = sy - stepDir
        self:addStepText_(container, index, stepDesc[index], sy)
        if index == 3 then
            index = index + 1
            sy = sy - stepDir + 1
            self:addStepText_(container, index, stepDesc[index], sy)
        end
        index = index + 1

        sy = sy - imgDir
        self:addStepImg_(container, CARD_IMG[i], sy)
    end

    sy = sy - 65
    ui.newTTFLabel({text = sa.LangUtil.getText("CHECKOUTGUIDE", "TRUE_WALLET_TITLE"), size = 28, color = TITLE_COLOR})
        :pos(0, sy + 32)
        :addTo(container)

    sy = sy - stepDir
    self:addStepText_(container, 1, sa.LangUtil.getText("CHECKOUTGUIDE", "TRUE_WALLET_STEP"), sy)

    sy = sy - imgDir
    self:addStepImg_(container, CARD_IMG[6], sy, 10)

    local btnLabel = ui.newTTFLabel({text = sa.LangUtil.getText("CHECKOUTGUIDE", "TRUE_WALLET_MORE") .. TRUE_WALLET_URL, size = 24})
    local btnSize = btnLabel:getContentSize()
    local btn = cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(btnSize.width, btnSize.height + 20)
        :setButtonLabel("normal", btnLabel)
        :onButtonClicked(buttontHandler(self, self.onTrueWalletMoreClicked_))
        :pos(0, sy + 25)
        :addTo(container)

    self.cardView_ = sa.ui.ScrollView.new({
            viewRect      = cc.rect(-LIST_W * 0.5, -LIST_H * 0.5, LIST_W, LIST_H),
            scrollContent = scrollContent,
            direction     = sa.ui.ScrollView.DIRECTION_VERTICAL,
        })
        :pos(WIDTH*0.5, LIST_H*0.5 + 33)
        :addTo(self.background_)
        :hide()

    local size = container:getCascadeBoundingBox()
    container:pos(0, size.height/2)
end

function CheckoutGuidePopup:addStepImg_(parent, img, y, offsetY)
    local bg = display.newSprite("img/checkout_guide_bg.jpg")
        :align(display.BOTTOM_CENTER, 0, y)
        :addTo(parent)

    offsetY = offsetY or 0
    display.newSprite(img)
        :pos(470, 212 + offsetY)
        :addTo(bg)
end

function CheckoutGuidePopup:addStepText_(parent, index, textStr, y)
    local w, h = 940, 84
    local frame = display.newScale9Sprite("#checkout_guide_title_frame.png", 0, 0, cc.size(w, h))
        :align(display.BOTTOM_CENTER, 0, y)
        :addTo(parent)

    local cy = h*0.5
    display.newSprite("#checkout_guide_num_frame.png")
        :pos(50, cy)
        :addTo(frame)

    display.newSprite(NUM_IMG[index])
        :pos(50, cy)
        :addTo(frame)

    ui.newTTFLabel({text = textStr, size = 26, color = cc.c3b(0x9f, 0xad, 0xff), dimensions=cc.size(830, 0)})
        :align(display.LEFT_CENTER, 110, cy)
        :addTo(frame)
end

function CheckoutGuidePopup:onTrueWalletMoreClicked_()
    device.openURL(TRUE_WALLET_URL)
end

function CheckoutGuidePopup:onTabChange_(selectedTab)
    if selectedTab == 1 then
        self.smsView_:show()
        self.cardView_:hide()
    else
        self.smsView_:hide()
        self.cardView_:show()
    end
end

function CheckoutGuidePopup:onShowed()
    self.smsView_:setScrollContentTouchRect()

    self.cardView_:setScrollContentTouchRect()
end

function CheckoutGuidePopup:onCleanup()
    display.removeSpriteFramesWithFile("checkout_guide_texture.plist", "checkout_guide_texture.png")
end

return CheckoutGuidePopup