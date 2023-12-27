-- 玩家标记视图

local UserMarkView = class("UserMarkView", function()
	return display.newNode()
end)

local HelpPopup = import("app.module.help.HelpPopup")

local WIDTH, HEIGHT = 500, 360
local CUSTOMIZE_ID = 8 --自定义id
local TITLE
local IMAGE = {
	"#common/userinfo_mark_icon_1.png",
	"#common/userinfo_mark_icon_2.png",
	"#common/userinfo_mark_icon_3.png",
	"#common/userinfo_mark_icon_4.png",
	"#common/userinfo_mark_icon_5.png",
	"#common/userinfo_mark_icon_6.png",
	"#common/userinfo_mark_icon_7.png",
	"#common/userinfo_mark_icon_8.png"
}

function UserMarkView:ctor(id)
	self:addModule_()

	self.selectedId_ = id or -1

	self.comment_ = ""

    TITLE = sa.LangUtil.getText("USERINFO", "MARK_TEXT")
	local bg = display.newScale9Sprite("#common/pop_small_tips_frame.png", 0, 0, cc.size(WIDTH, HEIGHT))
        :addTo(self)
    bg:setTouchEnabled(true)

   	cc.ui.UIPushButton.new({normal = "#common/userinfo_mark_help_btn_normal.png", pressed = "#common/userinfo_mark_help_btn_pressed.png"})
		:onButtonClicked(buttontHandler(self,self.onHelpClicked_))
		:pos(45, HEIGHT - 45)
		:addTo(bg)

    ui.newTTFLabel({text = sa.LangUtil.getText("USERINFO", "MARK_TIPS"), size = 24, color = cc.c3b(0xef, 0xef, 0xef)})
        :pos(WIDTH/2, HEIGHT - 45)
        :addTo(bg)

    self:addMarkList_(bg)
end

function UserMarkView:addModule_()
    local modal = display.newScale9Sprite("#common/transparent.png", 0, 0, cc.size(display.width * 2, display.height * 2)):addTo(self, -1)
    modal:setTouchEnabled(true)
    modal:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onClosed_))   
end

function UserMarkView:addMarkList_(parent)
	local tabGroup = tx.ui.CheckBoxButtonGroup.new()
    local btn_w, btn_h = 200, 51
    local dir = 60
    local x, y = 135, HEIGHT - 118
    for i = 1, 7 do
    	if i == 5 then
    		x = x + 230
    		y = HEIGHT - 118
    	end

        local btn = cc.ui.UICheckBoxButton.new({
                on="#common/userinfo_mark_selected.png",
                off="#common/userinfo_mark_normal.png",
                off_pressed = "#common/userinfo_mark_pressed.png"},
                {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :setButtonLabel("on", ui.newTTFLabel({text = TITLE[i], size = 24, color = cc.c3b(0xff, 0xff, 0xff)}))
            :setButtonLabel("off", ui.newTTFLabel({text = TITLE[i], size = 24, color = styles.FONT_COLOR.CONTENT_TEXT}))
            :setButtonLabelAlignment(display.LEFT_CENTER)
            :setButtonLabelOffset(-25, 0)
            :pos(x, y)
            :addTo(parent)

        display.newSprite(IMAGE[i])
        	:pos(-60, 0)
        	:addTo(btn)

        tabGroup:addButton(btn)

        y = y - dir
    end

    if self.selectedId_ > 0 then
    	tabGroup:getButtonAtIndex(self.selectedId_):setButtonSelected(true):updateButtonLable_()
    end

    tabGroup:onButtonSelectChanged(handler(self, self.onButtonSelectChanged_))

    --自定义
    self.markEdit_ = ui.newEditBox({image = "#common/userinfo_mark_normal.png", imagePressed = "#common/userinfo_mark_pressed.png", listener = handler(self, self.onMarkEdit_), size = cc.size(btn_w, btn_h)})
        :pos(x, y)
        :addTo(parent)
    self.markEdit_:setMaxLength(10)
    self.markEdit_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.markEdit_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.markEdit_:setText("")

    display.newSprite(IMAGE[CUSTOMIZE_ID])
    	:pos(x - 60, y)
    	:addTo(parent)

    ui.newTTFLabel({text = TITLE[CUSTOMIZE_ID], size = 24, color = styles.FONT_COLOR.CONTENT_TEXT})
    	:align(display.LEFT_CENTER, x - 25, y)
    	:addTo(parent)
end

function UserMarkView:onHelpClicked_()
	HelpPopup.new({index=2,subIndex=2}):showPanel()
end

function UserMarkView:onMarkEdit_(event, editbox)
	if event == "began" then
    elseif event == "changed" then
    elseif event == "ended" then
    elseif event == "return" then
        local text = editbox:getText()
        local filteredText = tx.keyWordFilter(text)
        filteredText = string.trim(filteredText)
        if filteredText == "" then
        	tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "MARK_NO_EMPTY"))
        else
        	self.comment_ = filteredText
        	self.selectedId_ = CUSTOMIZE_ID
            -- 修复崩溃问题
            tx.schedulerPool:delayCall(function ()
        	   self:onClosed_()
            end, 0.1)
        end
    end
end

function UserMarkView:onButtonSelectChanged_(evt)
	local id = evt.selected
	self.selectedId_ = id
	self.comment_ = TITLE[id]
    -- 修复崩溃问题
	tx.schedulerPool:delayCall(function ()
        self:onClosed_()
    end, 0.1)
end

function UserMarkView:onClosed_()
	sa.EventCenter:dispatchEvent({name = "UPDATE_MARKINFO", data = {id = self.selectedId_, comment = self.comment_}})
	self:removeFromParent()
end

return UserMarkView
