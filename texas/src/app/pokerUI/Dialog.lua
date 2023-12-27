local Panel = import(".Panel")
local Dialog = class("Dialog", Panel)

local WIDTH, HEIGHT = 830, 570

Dialog.FIRST_BTN_CLICK  = 1
Dialog.SECOND_BTN_CLICK = 2
Dialog.CLOSE_BTN_CLICK  = 3

function Dialog:ctor(args)
    Dialog.super.ctor(self, {WIDTH, HEIGHT})

    if type(args) == "string" then
        self.messageText_ = args
        self.firstBtnText_ = sa.LangUtil.getText("COMMON", "CANCEL")
        self.secondBtnText_ = sa.LangUtil.getText("COMMON", "CONFIRM")
        self.titleText_ = sa.LangUtil.getText("COMMON", "NOTICE")
    elseif type(args) == "table" then
        self.messageText_ = args.messageText
        self.callback_ = args.callback
        self.firstBtnText_ = args.firstBtnText or sa.LangUtil.getText("COMMON", "CANCEL")
        self.secondBtnText_ = args.secondBtnText or sa.LangUtil.getText("COMMON", "CONFIRM")
        self.titleText_ = args.titleText or sa.LangUtil.getText("COMMON", "NOTICE")
        self.noCloseBtn_ = (args.hasCloseButton == false)
        self.noFristBtn_ = (args.hasFirstButton == false)
        self.notCloseWhenTouchModel_ = not args.closeWhenTouchModel
    end    

    self:setTextTitleStyle(self.titleText_, true)

    if self.noCloseBtn_ then
        self.closeBtn_:hide()
    end
    
    -- 添加标签
    local bg = self.background_
    ui.newTTFLabel({
            text = self.messageText_,
            color = styles.FONT_COLOR.LIGHT_TEXT,
            size = 30,
            align = args.align or ui.TEXT_ALIGN_CENTER,
            dimensions = cc.size(WIDTH - 120, 0)
        })
    :pos(WIDTH*0.5, HEIGHT*0.5 + 10)
    :addTo(bg)

    -- 初始化按钮
    local showFirstBtn = false
    local btn_w, btn_h =330, 146
    local btn_x, btn_y = WIDTH*0.5, 100
    if not self.noFristBtn_ then
        if self.firstBtnText_ then
            showFirstBtn = true
        end
    end

    self.secondBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_green.png", pressed = "#common/btn_big_green_down.png"}, {scale9 = true})
        :setButtonSize(btn_w, btn_h)
        :setButtonLabel("normal", ui.newTTFLabel({text = self.secondBtnText_, color = styles.FONT_COLOR.LIGHT_TEXT, size = 34, align = ui.TEXT_ALIGN_CENTER}))
        :onButtonClicked(buttontHandler(self, self.onButtonClick_))
        :addTo(bg)
    local label = self.secondBtn_:getButtonLabel("normal")
    if label then
        sa.fitSprteWidth(label, 260)
    end

    if showFirstBtn then
        self.firstBtn_ = cc.ui.UIPushButton.new({normal = "#common/btn_big_blue.png", pressed = "#common/btn_big_blue_down.png"}, {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel("normal", ui.newTTFLabel({text = self.firstBtnText_, color = styles.FONT_COLOR.LIGHT_TEXT, size = 34, align = ui.TEXT_ALIGN_CENTER}))
            :onButtonClicked(buttontHandler(self, self.onButtonClick_))
            :addTo(bg)
        local label = self.firstBtn_:getButtonLabel("normal")
        if label then
            sa.fitSprteWidth(label, 260)
        end

        btn_x = 220
        self.firstBtn_:pos(btn_x, btn_y)
        self.secondBtn_:pos(WIDTH - btn_x, btn_y)
    else
        self.secondBtn_:pos(btn_x, btn_y)
    end
end

-- 按钮点击事件处理
function Dialog:onButtonClick_(event)
    if self.callback_ then
        if event.target == self.firstBtn_ then
            self.callback_(Dialog.FIRST_BTN_CLICK)
        elseif event.target == self.secondBtn_ then
            self.callback_(Dialog.SECOND_BTN_CLICK)
        end

        self.callback_ = nil
    end
    
    if self.hidePanel_ then
        self:hidePanel_()
    end
end

function Dialog:show()
    if self.notCloseWhenTouchModel_ then
        self:showPanel_(true, true, false, true)
    else
        self:showPanel_()
    end
    return self
end

function Dialog:onRemovePopup(removeFunc)
    if self.callback_ then
        self.callback_(Dialog.CLOSE_BTN_CLICK)
    end
    removeFunc()
end

function Dialog:onClose()
    if self.callback_ then
        self.callback_(Dialog.CLOSE_BTN_CLICK)
    end
    
    self.callback_ = nil
    self:hidePanel_()
end

return Dialog