--支付活动
local PayContent = class("PayContent", function()
    return display.newNode()
end)

local WIDTH, HEIGHT = 820, 590
local LABEL_X = 40
local TEXT_CORLOR_1 = cc.c3b(0xff, 0xff, 0xff)
local TEXT_CORLOR_2 = cc.c3b(0xff, 0xe2, 0x5a) -- 黄
local TEXT_CORLOR_3 = cc.c3b(0x37, 0xff, 0x74) -- 绿
local TEXT_CORLOR_4 = cc.c3b(0x50, 0xe0, 0xff) -- 蓝
local TEXT_CORLOR_5 = cc.c3b(0xf4, 0x50, 0xe3) -- 紫

function PayContent:ctor(data)
    self.data_ = data

    self.currency_ = data.currency

    local sy = HEIGHT - 130
    ui.newTTFLabel({text = data.title, color = cc.c3b(0xff, 0xd3, 0x3c), size = 50})
        :align(display.LEFT_CENTER, LABEL_X, sy)
        :addTo(self)

    local count_x, count_y = WIDTH - 120, HEIGHT - 75
    ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT","PAY_COUNT"), color = TEXT_CORLOR_2, size = 30})
        :pos(count_x, count_y)
        :addTo(self)

    ui.newTTFLabel({text = data.curCount .. data.currency, color = TEXT_CORLOR_2, size = 30})
        :pos(count_x, count_y - 55)
        :addTo(self)

    sy = sy - 60
    ui.newTTFLabel({text = data.time, size = 32})
        :align(display.LEFT_CENTER, LABEL_X, sy)
        :addTo(self)

    sy = sy - 60
    for i = 1, #data.list do
        self:createLabel_(i)
            :pos(LABEL_X, sy)
            :addTo(self)
        sy = sy - 40
    end

    ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT","PAY_TIPS"), size = 22, color = TEXT_CORLOR_5})
        :pos(WIDTH*0.5, 130)
        :addTo(self)
end

function PayContent:createLabel_(index)
    local data = self.data_.list[index]
    local node = display.newNode()
    local align_ = display.LEFT_CENTER
    local w = 0
    local label = ui.newTTFLabel({text = index .. "." .. sa.LangUtil.getText("NEWESTACT","PAY_TIPS_1"), color = TEXT_CORLOR_1, size = 20})
        :align(align_, w, 0)
        :addTo(node)
    w = w + label:getContentSize().width

    label = ui.newTTFLabel({text = data.count .. self.currency_, color = TEXT_CORLOR_2, size = 22})
        :align(align_, w, 0)
        :addTo(node)
    w = w + label:getContentSize().width

    label = ui.newTTFLabel({text = sa.LangUtil.getText("NEWESTACT","PAY_TIPS_2"), color = TEXT_CORLOR_1, size = 20})
        :align(align_, w, 0)
        :addTo(node)
    w = w + label:getContentSize().width

    label = ui.newTTFLabel({text = sa.formatBigNumber(data.chips), color = TEXT_CORLOR_2, size = 22})
        :align(align_, w, 0)
        :addTo(node)
    w = w + label:getContentSize().width

    if data.diamonds then
        label = ui.newTTFLabel({text = "+", color = TEXT_CORLOR_1, size = 22})
            :align(align_, w, 0)
            :addTo(node)
        w = w + label:getContentSize().width

        label = ui.newTTFLabel({text = sa.LangUtil.getText("STORE","FORMAT_DIAMONDS", data.diamonds), color = TEXT_CORLOR_3, size = 22})
            :align(align_, w, 0)
            :addTo(node)
        w = w + label:getContentSize().width
    end

    if data.vip then
        label = ui.newTTFLabel({text = "+", color = TEXT_CORLOR_1, size = 22})
            :align(align_, w, 0)
            :addTo(node)
        w = w + label:getContentSize().width

        label = ui.newTTFLabel({text = data.vip, color = TEXT_CORLOR_4, size = 22})
            :align(align_, w, 0)
            :addTo(node)
        w = w + label:getContentSize().width
    end
    

    return node
end

return PayContent