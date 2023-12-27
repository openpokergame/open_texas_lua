--编辑收货地址信息

local AddressPopup = class("AddressPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 698
local CONTENT_TEXT = styles.FONT_COLOR.CONTENT_TEXT
local TITLES
local PLACEHOLDERS
local INPUTMODE = {
    cc.EDITBOX_INPUT_MODE_SINGLELINE,
    cc.EDITBOX_INPUT_MODE_NUMERIC,
    cc.EDITBOX_INPUT_MODE_SINGLELINE,
    cc.EDITBOX_INPUT_MODE_NUMERIC,
    cc.EDITBOX_INPUT_MODE_EMAILADDR
}

local KEY = {
    "name",-- 姓名
    "phone",-- 电话
    "address",-- 地址
    "zip",-- 邮编
    "email"-- 邮件
}

function AddressPopup:ctor()
	AddressPopup.super.ctor(self, {WIDTH, HEIGHT})
    self:setTextTitleStyle(sa.LangUtil.getText("STORE", "ADDRESS_POP_TITLE"))

    self.curInfo_ = {}
    for i, v in ipairs(KEY) do
        self.curInfo_[i] = ""
    end

    self:getAddressInfo_()
end

function AddressPopup:addMainUI_()
    local frame_w, frame_h = WIDTH - 56, 562
    local frame = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.BOTTOM_CENTER, WIDTH*0.5, 30)
        :addTo(self.background_)
    self.frame_ = frame

    local x = frame_w*0.5    
    ui.newTTFLabel({text=sa.LangUtil.getText("STORE", "REAL_TIPS"), size=26, color=CONTENT_TEXT})
        :pos(x, frame_h - 32)
        :addTo(frame)

    local y = frame_h - 62
    TITLES = sa.LangUtil.getText("STORE", "REAL_TITLES")
    PLACEHOLDERS = sa.LangUtil.getText("STORE", "REAL_PLACEHOLDER")

    self.infoLabels_ = {}
    self.mustTips_ = {}
    for i = 1, 5 do
        self.infoLabels_[i], self.mustTips_[i] = self:createEditItem_(i, x, y)
        y = y - 70
        if i == 3 then
            y = y - 64
        end
    end

    cc.ui.UIPushButton.new({normal = "#common/btn_small_green.png", pressed = "#common/btn_small_green_down.png"}, {scale9 = true})
        :setButtonSize(240, 104)
        :setButtonLabel("normal", ui.newTTFLabel({text = sa.LangUtil.getText("STORE", "REAL_SAVE"), size = 24}))
        :onButtonClicked(buttontHandler(self, self.onSaveClicked_))
        :pos(x, 48)
        :addTo(frame)
end

function AddressPopup:createEditItem_(index, x, y)
    local w, h = WIDTH - 56, 64
    if index == 3 then
        h = 128
    end

    local bg = display.newNode()
        :size(w, h)
        :align(display.TOP_CENTER, x, y)
        :addTo(self.frame_)

    local label_x, label_y = 145, h*0.5
    local label = ui.newTTFLabel({text=TITLES[index], size=24})
        :align(display.RIGHT_CENTER, label_x, label_y)
        :addTo(bg)

    local frame_w, frame_h = 600, h
    local frame = display.newScale9Sprite("#store/real_address_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.LEFT_CENTER, label_x + 12, h*0.5)
        :addTo(bg)

    local mustTips = ui.newTTFLabel({text="*", size=30, color=cc.c3b(0xff, 0x0, 0x0)})
        :pos(frame_w + 10, h*0.5 - 5)
        :addTo(frame)
        :hide()

    local editbox = ui.newEditBox({image = "#common/transparent.png", listener = handler(self, self.onEditBoxChange_), size = cc.size(frame_w, frame_h)})
        :pos(frame_w*0.5, frame_h*0.5)
        :addTo(frame)
    editbox:setFont(ui.DEFAULT_TTF_FONT, 26)
    editbox:setPlaceholderFont(ui.DEFAULT_TTF_FONT, 26)
    editbox:setPlaceholderFontColor(cc.c3b(0xEE, 0xEE, 0xEE))
    editbox:setInputMode(INPUTMODE[index])
    editbox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    editbox:setTag(index)
    editbox:setCascadeOpacityEnabled(true)
    editbox:opacity(0)

    local size = label:getContentSize()
    local str = PLACEHOLDERS[index]
    if self.curInfo_[index] ~= "" then
        str = self.curInfo_[index]
    end
    label = ui.newTTFLabel({text=str, size=26, color=CONTENT_TEXT, dimensions = cc.size(frame_w - 20, 0)})
        :align(display.LEFT_CENTER, 20, label_y)
        :addTo(frame)

    return label, mustTips
end

function AddressPopup:onEditBoxChange_(event, editbox)
    local tag = editbox:getTag()
    local str = editbox:getText()
    if event == "changed" then
        if str == "" then
            self.infoLabels_[tag]:setString(PLACEHOLDERS[tag])
        else
            self.infoLabels_[tag]:setString(str)
            self.mustTips_[tag]:hide()
        end
        self.curInfo_[tag] = str
    elseif event == "return" then
    end
end

function AddressPopup:onSaveClicked_()
    local isCompleted = true
    for i, v in ipairs(self.curInfo_) do
        if v == "" then
            isCompleted = false
            self.mustTips_[i]:show()
        end
    end

    if not isCompleted then
        tx.TopTipManager:showToast(sa.LangUtil.getText("STORE", "REAL_TIPS_2"))
        return
    end

    local params = {
        mod = "Mall", 
        act = "address",
    }

    for i,v in ipairs(self.curInfo_) do
        params[KEY[i]] = v
    end
    sa.HttpService.POST(
        params, 
        function (data)
            local jsonData =  json.decode(data)
            if jsonData.code == 1 then
            else
            end
        end, 
        function ()
        end
    )
end

function AddressPopup:getAddressInfo_()
    self:setLoading(true)
    sa.HttpService.POST(
        {
            mod = "Mall", 
            act = "addressList",
        }, 
        function (data)
            local jsonData =  json.decode(data)
            if jsonData.code == 1 then
                self:setLoading(false)
                for i, v in pairs(jsonData.list) do
                    local index = self:getIndexByKey_(i)
                    if index then
                        self.curInfo_[index] = v
                    end
                end
                self:addMainUI_()
            else
            end
        end,
        function ()
        end)
end

function AddressPopup:getIndexByKey_(key)
    local index
    for i, v in ipairs(KEY) do
        if key == v then
            index = i
            break
        end
    end

    return index
end

return AddressPopup
