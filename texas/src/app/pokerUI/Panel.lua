local Panel = class("Panel", function()
    return display.newNode()
end)

local PANEL_CLOSE_BTN_Z_ORDER = 99
local TAB_ON_COLOR = styles.FONT_COLOR.MAIN_TAB_ON
local TAB_OFF_COLOR =  styles.FONT_COLOR.MAIN_TAB_OFF

function Panel:ctor(args, bgImg)
    self:setNodeEventEnabled(true)
    self.width_, self.height_ = args[1], args[2]

    self.loadingX_, self.loadingY_ = 0, 0

    self.close_x_ = self.width_ - 70
    self.close_y_ = self.height_ - 70

    bgImg = bgImg or "#common/pop_bg.png"

    self.background_ = display.newScale9Sprite(bgImg, 0, 0, cc.size(self.width_, self.height_), cc.rect(170, 170, 1, 1)):addTo(self)
    self.background_:setTouchEnabled(true)
    self.background_:setTouchSwallowEnabled(true)
end

function Panel:initViews()
end

function Panel:requestDatas()
end

function Panel:onShowed()
end

function Panel:addCloseBtn()
    if not self.closeBtn_ then
        self.closeBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_close.png", pressed="#common/btn_close_down.png"})
            :pos(self.close_x_, self.close_y_)
            :onButtonClicked(function()
                self:onClose()
                tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
            end)
            :addTo(self.background_, PANEL_CLOSE_BTN_Z_ORDER)
    end
end

function Panel:addSecondFrame()
    display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(self.width_ - 56, self.height_ - 150))
        :align(display.BOTTOM_CENTER, self.width_*0.5, 30)
        :addTo(self.background_)
end

function Panel:setMainTabStyle(title, selected, callback)
    local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    local btn_w, btn_h = 260, 90
    local dir = 96
    local x, y = 158, self.height_ - 171
    for i = 1, #title do
        local onLabel = ui.newTTFLabel({text = title[i], size = 24, color = TAB_ON_COLOR})
        local offLabel = ui.newTTFLabel({text = title[i], size = 24, color = TAB_OFF_COLOR})
        sa.fitSprteWidth(onLabel, 250)
        sa.fitSprteWidth(offLabel, 250)
        local btn = cc.ui.UICheckBoxButton.new({
                on="#common/pop_left_tab_selected.png",
                off="#common/pop_left_tab_normal.png",
                off_pressed = "#common/pop_left_tab_pressed.png"},
                {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel("on", onLabel)
            :setButtonLabel("off", offLabel)
            :setButtonLabelAlignment(display.CENTER)
            :pos(x, y)
            :addTo(self.background_, 1)

        tabGroup:addButton(btn)

        y = y - dir
    end

    tabGroup:getButtonAtIndex(selected):setButtonSelected(true):updateButtonLable_() --刷新label状态，感觉是引擎bug
    tabGroup:onButtonSelectChanged(callback)

    self:setLoadingPosition(120, -50)

    return tabGroup
end

function Panel:setImgTitleStyle(title)
    if self.closeBtn_ then self.closeBtn_:removeFromParent(); self.closeBtn_=nil end
    if self.title_ then self.title_:removeFromParent(); self.title_=nil end

    local x, y = 28, self.height_ - 78

    self.title_ = display.newSprite(title)
        :align(display.LEFT_CENTER, x, y)
        :addTo(self.background_)

    self:addCloseBtn()
end

function Panel:setTextTitleStyle(title, isLine)
    if self.closeBtn_ then self.closeBtn_:removeFromParent(); self.closeBtn_=nil end
    if self.title_ then self.title_:removeFromParent(); self.title_=nil end
    if self.line_ then self.line_:removeFromParent(); self.line_=nil end

    local x, y = self.width_*0.5, self.height_ - 70

    self.title_ = ui.newTTFLabel({text = title or "", size = 40})
        :pos(x, y)
        :addTo(self.background_)

    self:addCloseBtn()

    if isLine then
        self.line_ = display.newScale9Sprite("#common/pop_title_dividing_line.png", 0, 0, cc.size(self.width_ - 120, 2))
            :pos(x, y - 50)
            :addTo(self.background_)
    end
end

function Panel:setLoadingPosition(x, y)
    self.loadingX_, self.loadingY_ = x, y
end

function Panel:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(self.loadingX_, self.loadingY_)
                :addTo(self, 9999)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

--设置关闭按钮位置
function Panel:setCloseBtnOffset(x, y)
    self.closeBtn_:pos(self.close_x_ + x, self.close_y_ + y)
end

function Panel:showPanel_(isModal, isCentered, closeWhenTouchModel, useShowAnimation)
    tx.PopupManager:addPopup(self, isModal ~= false, isCentered ~= false, closeWhenTouchModel ~= false, useShowAnimation ~= false)
    return self
end

function Panel:showPanel()
    self:showPanel_(true, true, true, true)
    return self
end

function Panel:hidePanel()
    self:hidePanel_()
end

function Panel:hidePanel_()
    tx.PopupManager:removePopup(self)
end

function Panel:createNoDataTips(tips)
    local bg_w, bg_h = self.width_, self.height_
    local frame_w, frame_h = 820, 590
    local frame = display.newNode()
        :size(frame_w, frame_h)
        :align(display.RIGHT_BOTTOM, bg_w - 28, 30)
        :addTo(self.background_)

    local x, y = 258, 286
    display.newSprite("#common/no_con_bg.png")
        :pos(x, y)
        :addTo(frame)

    ui.newTTFLabel({text = tips, size = 24})
        :pos(x, y)
        :addTo(frame)

    display.newSprite("#common/no_con_icon.png")
        :align(display.LEFT_CENTER, 410, 320)
        :addTo(frame)

    return frame
end

function Panel:setCloseCallback(closeCallback)
    self.closeCallback_ = closeCallback
    return self
end

function Panel:onClose()
    self:hidePanel_()
end

function Panel:onRemovePopup(removeFunc)
    if self.closeCallback_ then
        self.closeCallback_()
    end

    removeFunc()
end

return Panel
