-- 语言切换视图

local LanguageSwitchView = class("LanguageSwitchView", function()
	return display.newNode()
end)

local LanguageListItem = import(".LanguageListItem")

local lang_data = appconfig.all_lang

function LanguageSwitchView:ctor(params)
	self.isInRoom_ = params
	local normalImg = "#dialogs/setting/drop_down_box_btn_normal.png"
	local pressedImg = "#dialogs/setting/drop_down_box_btn_pressed.png"
	local btn_w, btn_h = 254, 68

	self.isDrop_ = false
	if not self.isInRoom_ then
		self.btnList_ = cc.ui.UIPushButton.new({normal = normalImg, pressed = pressedImg}, {scale9=true, capInsets = cc.rect(30, 34, 1, 1)})
			:setButtonSize(btn_w, btn_h)
			:setDelayTouchEnabled(false)
			:onButtonClicked(buttontHandler(self,self.onDropDownClicked_))
			:addTo(self)
		self.btnList_:setTouchSwallowEnabled(false)

		self.arrow_ = display.newSprite("#common/setting_arrow_icon.png")
			:pos(95, 0)
			:addTo(self)
	end

	local index = nil
	local lang = tx.userDefault:getStringForKey("CUR_LANGUAGE", "")
	local region = tx.userDefault:getStringForKey("CUR_LANGUAGE_REGION", "")
	local getPrevSet = function(lang)
		for k,v in pairs(lang_data) do
			if lang==v.langCode then
				if not region or region=="" then
					return k
				end
				if v.region==region then
					return k
				end
			end
		end
		return nil
	end
	index = getPrevSet(tx.userDefault:getStringForKey("CUR_LANGUAGE", ""))
	if not index then
		index = getPrevSet(appconfig.LANG)
	end
	if not index then
		index = 1
	end


	local curData = lang_data[index]
	self.curIcon_ = display.newSprite("#" .. curData.icon)
		:pos(-95, 0)
		:addTo(self)

	self.curLang_ = ui.newTTFLabel({text = curData.lang, size = 22, color = cc.c3b(0xef, 0xef, 0xef)})
		:align(display.LEFT_CENTER, -52, 0)
		:addTo(self)
end

function LanguageSwitchView:onDropDownClicked_()
	if self.isDrop_ then
		self.isDrop_ = false
		self.arrow_:flipY(false)
		self:hideList_()
	else
		self.isDrop_ = true
		self.arrow_:flipY(true)
		self:addDropList_()
	end
end

function LanguageSwitchView:addDropList_()
	local frame_w, frame_h = 304, 310
	if #lang_data*60<frame_h then
		frame_h = #lang_data*60+60
	end
	self.frame_ = display.newScale9Sprite("#dialogs/setting/drop_down_box_list_frame.png", 0, 0, cc.size(frame_w, frame_h))
		:align(display.TOP_CENTER, 0, -10)
		:addTo(self, -1)

	self.listNode_ = display.newNode()
		:pos(0, -frame_h*0.5 - 10)
		:addTo(self)
	local list_w, list_h = frame_w - 50, frame_h - 60
	local list = sa.ui.ListView.new(
		{
			viewRect = cc.rect(-list_w/2, -list_h/2, list_w, list_h),
		}, 
		LanguageListItem
	)
	:addTo(self.listNode_)

	list:setData(lang_data, true)
	list:addEventListener("ITEM_EVENT", handler(self, self.onItemEvent_))
	list:setScrollContentTouchRect()

	self:addModule_()
end

function LanguageSwitchView:hideList_()
	if self.frame_ then
		self.frame_:removeFromParent()
		self.frame_ = nil

		if self.modal_ then
			self.modal_:removeFromParent()
			self.modal_ = nil
		end

		self.isDrop_ = false
		self.arrow_:flipY(false)
	end
	if self.listNode_ then
		self.listNode_:removeFromParent()
		self.listNode_ = nil
	end
end

function LanguageSwitchView:onItemEvent_(evt)
	if evt.type == "DROPDOWN_LIST_SELECT" then
		self.curLang_:setString(evt.data.lang)
		self.curIcon_:setSpriteFrame(evt.data.icon)
		tx.userDefault:setStringForKey("CUR_LANGUAGE", evt.data.langCode)
		if evt.data.region then
			tx.userDefault:setStringForKey("CUR_LANGUAGE_REGION", evt.data.region) -- 区分地区
		else
			tx.userDefault:setStringForKey("CUR_LANGUAGE_REGION", "") -- 不区分地区
		end
		tx.userDefault:flush()
		-- 重置语言
		appconfig.setLang()
		sa.LangUtil = nil
		sa.LangUtil = require("openpoker.lang.LangUtil")
		sa.LangUtil.reload()
		display.removeSpriteFramesWithFile("lang_texture.plist", "lang_texture.png")
		display.addSpriteFrames("lang_texture.plist", "lang_texture.png",function( ... )
			sa.HttpService.setDefaultParameter("lang",appconfig.LANG)
			sa.EventCenter:dispatchEvent({name="CHANGE_LANGUE"})
		end)
	end

	self:hideList_()
end

function LanguageSwitchView:addModule_()
	if not self.modal_ then
		self.modal_ = display.newScale9Sprite("#common/transparent.png", 0, 0, cc.size(display.width*1.5, display.height*1.5))
			:pos(0, 0)
			:addTo(self, -999)

		self.modal_:setTouchEnabled(true)
		-- self.modal_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.hideList_))
		self.modal_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
			self.btnList_._isClicked_ = false   -- 屏蔽点击事件
			self:hideList_()
		end)
	end
end

return LanguageSwitchView