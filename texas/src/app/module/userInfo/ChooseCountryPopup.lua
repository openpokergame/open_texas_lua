local ChooseCountryPopup = class("ChooseCountryPopup", function()
    return display.newNode()
end)

local ChooseCountryItem = import(".ChooseCountryItem")

local WIDTH, HEIGHT = 724, 510
local C_X, C_Y = WIDTH*0.5, HEIGHT*0.5

function ChooseCountryPopup:ctor(curCountryId)
    self:setNodeEventEnabled(true)

    local bg = display.newScale9Sprite("#common/pop_small_tips_frame.png", 0, 0, cc.size(WIDTH, HEIGHT)):addTo(self)
    bg:setTouchEnabled(true)
    bg:setTouchSwallowEnabled(true)
    self.bg_ = bg

    ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "CHOOSE_COUNTRY_TITLE"), size = 32})
        :pos(C_X, HEIGHT - 50)
        :addTo(bg)

    cc.ui.UIPushButton.new({normal = "#common/btn_close.png", pressed="#common/btn_close_down.png"})
        :pos(WIDTH - 50, HEIGHT - 50)
        :onButtonClicked(function()
            self:hidePanel()
            tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
        end)
        :addTo(bg)

    self:addList_(curCountryId)
end

function ChooseCountryPopup:addList_(curCountryId)
    local scrollNode = display.newNode()
    local contentNode = display.newNode():addTo(scrollNode)

    local list_w, list_h = 646, 410
    local sx = -list_w * 0.5
    local title_x = -list_w * 0.5 + 10
    local title_h = 35
    local dir_w, dir_h = 326, 64
    local y = 0
    local countryNum = 1
    local curCountryIndex = 1

    local countryList = sa.LangUtil.getText("USERINFO", "COUNTRY_LIST")

    local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    self.tabGroup_ = tabGroup

    self.items_ = {}
    for i, v in ipairs(countryList) do
        ui.newTTFLabel({text = v.title, size = 28})
            :align(display.LEFT_TOP, title_x, y)
            :addTo(contentNode)
        y = y - title_h

        local x = sx
        local startIndex = i*100
        for index, countryName in ipairs(v.list) do
            local countryId = startIndex + index
            local data = {id = countryId, name = countryName}
            if curCountryId == countryId then
                curCountryIndex = countryNum
            end

            if index % 2 == 1 then
                x = sx

                if index > 2 then
                    y = y - dir_h
                end
            else
                x = sx + dir_w
            end
            local item = ChooseCountryItem.new(data)
                :align(display.LEFT_TOP, x, y)
                :addTo(contentNode)
            self.items_[countryNum] = item

            tabGroup:addButton(item:getCheckBoxButton())

            countryNum = countryNum + 1
        end

        y = y - dir_h - 15
    end

    sa.ui.ScrollView.new({
            viewRect      = cc.rect(-list_w * 0.5, -list_h * 0.5, list_w, list_h),
            scrollContent = scrollNode,
        })
        :pos(C_X, C_Y - 26)
        :addTo(self.bg_)

    local size = contentNode:getCascadeBoundingBox()
    contentNode:setPositionY(size.height*0.5)

    tabGroup:onButtonSelectChanged(handler(self, self.onButtonSelectChanged_))
    tabGroup:getButtonAtIndex(curCountryIndex):setButtonSelected(true)
end

function ChooseCountryPopup:onButtonSelectChanged_(evt)
    self.selectData_ = self.items_[evt.selected]:getData()
end

function ChooseCountryPopup:showPanel()
    tx.PopupManager:addPopup(self, true, true, true, true)
end

function ChooseCountryPopup:hidePanel()
    tx.PopupManager:removePopup(self)
end

function ChooseCountryPopup:onShowed()
end

function ChooseCountryPopup:onCleanup()
    sa.EventCenter:dispatchEvent({name=tx.eventNames.UPDATE_COUNTRY, data=self.selectData_})
end

return ChooseCountryPopup