local WIDTH = 720
local HEIGHT = 480
local TOP = HEIGHT*0.5
local BOTTOM = -HEIGHT*0.5
local LEFT = -WIDTH*0.5
local RIGHT = WIDTH*0.5
local TOP_HEIGHT = 64

local PHPServerUrl = import("app.PHPServerUrl")
local DebugPopup = class("DebugPopup", tx.ui.Panel)

DebugPopup.RADIO_BUTTON_IMAGES = {
    off = "common_blue_btn_up.png",
    on = "common_red_btn_up.png",
}


function DebugPopup:ctor()
    DebugPopup.super.ctor(self,{WIDTH,HEIGHT})
    self:setNodeEventEnabled(true)
    self:setTextTitleStyle("调试选项")
    -- self:addLangConfig()
    self:addPhpServerUrlConfig()
    -- self:addHuaWeiDebugMode()
end

function DebugPopup:addLangConfig()
    local x, y = LEFT + 50, TOP - 120
    cc.ui.UILabel.new({text = "语言选择", size=24, color = cc.c3b(0xd7, 0xf6, 0xff)})
        :align(display.LEFT_TOP, x, y)
        :addTo(self)
    local group = cc.ui.UICheckBoxButtonGroup.new(display.TOP_TO_BOTTOM)
        :addButton(cc.ui.UICheckBoxButton.new(DebugPopup.RADIO_BUTTON_IMAGES)
            :setButtonLabel(cc.ui.UILabel.new({text = "中文", color = display.COLOR_WHITE}))
            :setButtonLabelOffset(30, 0)
            :align(display.LEFT_CENTER))
        -- :addButton(cc.ui.UICheckBoxButton.new(DebugPopup.RADIO_BUTTON_IMAGES)
        --     :setButtonLabel(cc.ui.UILabel.new({text = "英语", color = display.COLOR_WHITE}))
        --     :setButtonLabelOffset(30, 0)
        --     :align(display.LEFT_CENTER))
        :addButton(cc.ui.UICheckBoxButton.new(DebugPopup.RADIO_BUTTON_IMAGES)
            :setButtonLabel(cc.ui.UILabel.new({text = "泰语", color = display.COLOR_WHITE}))
            :setButtonLabelOffset(30, 0)
            :align(display.LEFT_CENTER))
        -- :addButton(cc.ui.UICheckBoxButton.new(DebugPopup.RADIO_BUTTON_IMAGES)
        --     :setButtonLabel(cc.ui.UILabel.new({text = "越南语", color = display.COLOR_WHITE}))
        --     :setButtonLabelOffset(30, 0)
        --     :align(display.LEFT_CENTER))
        :setButtonsLayoutMargin(10, 10, 10, 10)
        :onButtonSelectChanged(function(event)
            print("Option %d selected, Option %d unselected", event.selected, event.last)
            DebugPopup:switchLang_(self:langIndexToStr_(event.selected))
        end)
        :align(display.LEFT_TOP, x, y - 100)
        :addTo(self)
    local index = self:langStrToIndex_(appconfig.LANG_FILE_NAME)
    local count = group:getButtonsCount()
    if not index or index<1 then
        index = 1
    elseif index>count then
        index = count
    end
    group:getButtonAtIndex(index)
        :setButtonSelected(true)
end

function DebugPopup:addPhpServerUrlConfig()
    local x, y = LEFT + 250, TOP - 120
    cc.ui.UILabel.new({text = "服务器选择", size=24, color = cc.c3b(0xd7, 0xf6, 0xff)})
        :align(display.LEFT_TOP, x, y)
        :addTo(self)
    local group = cc.ui.UICheckBoxButtonGroup.new(display.TOP_TO_BOTTOM)
        :setButtonsLayoutMargin(10, 10, 10, 10)
        :onButtonSelectChanged(function(event)
            DebugPopup:switchPhpServer_(PHPServerUrl[event.selected].url)
        end)
        :align(display.LEFT_TOP, x, y - 120)
        :addTo(self)
    for i = 1,#PHPServerUrl do
        group:addButton(cc.ui.UICheckBoxButton.new(DebugPopup.RADIO_BUTTON_IMAGES)
            :setButtonLabel(cc.ui.UILabel.new({text = PHPServerUrl[i].name, color = display.COLOR_WHITE}))
            :setButtonLabelOffset(30, 0)
            :align(display.LEFT_CENTER))
    end
    group:getButtonAtIndex(self:getUrlIndex_(appconfig.LOGIN_SERVER_URL))
        :setButtonSelected(true)
end

function DebugPopup:addHuaWeiDebugMode()
    local x, y = LEFT + 480, TOP - 120
    cc.ui.UILabel.new({text = "华为SDK调试模式", size=24, color = cc.c3b(0xd7, 0xf6, 0xff)})
        :align(display.LEFT_TOP, x, y)
        :addTo(self)
    local group = cc.ui.UICheckBoxButtonGroup.new(display.TOP_TO_BOTTOM)
        :setButtonsLayoutMargin(10, 10, 10, 10)
        :onButtonSelectChanged(function(event)
            local selected = event.selected
            if tx.HuaWeiSDK then
                local isEnabled = false
                if selected == 1 then
                    isEnabled = true
                end
                tx.HuaWeiSDK:setDebugMode(isEnabled)
            end
        end)
        :align(display.LEFT_TOP, x, y - 100)
        :addTo(self)
    local title = {"打开","关闭"}
    for i = 1,#title do
        group:addButton(cc.ui.UICheckBoxButton.new(DebugPopup.RADIO_BUTTON_IMAGES)
            :setButtonLabel(cc.ui.UILabel.new({text = title[i]}))
            :setButtonLabelOffset(30, 0)
            :align(display.LEFT_CENTER))
    end
    group:getButtonAtIndex(1):setButtonSelected(true)
end

function DebugPopup:switchPhpServer_(url)
    appconfig.LOGIN_SERVER_URL = url
end

function DebugPopup:switchLang_(lang)
    appconfig.LANG_FILE_NAME = lang
    sa.LangUtil = nil
    sa.LangUtil = import("openpoker.lang.LangUtil")
    sa.LangUtil.reload()
end

function DebugPopup:langIndexToStr_(index)
    if index == 1 then
        return "lang"
    elseif index == 2 then
        return "lang_th"--"lang_en"
    elseif index == 3 then
        return "lang_th"
    elseif index == 4 then
        return "lang_vn"
    end

end

function DebugPopup:langStrToIndex_(str)
    if str == "lang" then
        return 1
    elseif str == "lang_en" then
        return 2
    elseif str == "lang_th" then
        return 3
    elseif str == "lang_vn" then
        return 4
    end
end

function DebugPopup:getUrlIndex_(url)
    for i = 1,#PHPServerUrl do
        if PHPServerUrl[i].url == url then
            return i
        end
    end
    return 1 -- 增加一点容错~
end

function DebugPopup:show()
    self:showPanel_()
end

function DebugPopup:hide()
    self:hidePanel_()
end

return DebugPopup
