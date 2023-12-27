--游客绑定弹窗
local BindGuestView = class("BindGuestView", tx.ui.Panel)
local BindRewardView = import(".BindRewardView")
local WIDTH, HEIGHT = 830, 570
local GUEST_BIND_TYPE = 1

local BIND_DATA = {
	{
		icon = "#hall/hall_bind_icon_1.png",
		nor = "#common/btn_big_blue.png",
		pre = "#common/btn_big_blue_down.png",
		loginType = 3
	},
	{
		icon = "#hall/hall_bind_icon_2.png",
		nor = "#common/btn_big_green.png",
		pre = "#common/btn_big_green_down.png",
		loginType = 6
	},
	{
		icon = "#hall/hall_bind_icon_3.png",
		nor = "#hall/hall_bind_vk_btn_normal.png",
		pre = "#hall/hall_bind_vk_btn_pressed.png",
		loginType = 5
	},
}

function BindGuestView:ctor()
	BindGuestView.super.ctor(self, {WIDTH, HEIGHT})

	self:setTextTitleStyle(sa.LangUtil.getText("BIND", "TITLE"))

    self:addSecondFrame()

    local title = sa.LangUtil.getText("BIND", "BTN_TITLE_2")
    local btn_w, btn_h = 480, 146
    local sx, sy = WIDTH*0.5, HEIGHT - 190
    local dir = 125
    local len = 3
    local sid = appconfig.SID[string.upper(device.platform)]
    if sid ~= 19 and sid ~= 20 then
    	sy = HEIGHT - 220
	    dir = 180
	    len = 2
    end

    for i = 1, len do
    	local data = BIND_DATA[i]
    	local btn = cc.ui.UIPushButton.new({normal = data.nor, pressed = data.pre}, {scale9 = true})
            :setButtonSize(btn_w, btn_h)
            :pos(sx, sy)
            :onButtonClicked(buttontHandler(self, self.onBindClicked_))
            :addTo(self.background_)
        btn:setTag(i)

        display.newSprite(data.icon)
        	:pos(-155, 0)
        	:addTo(btn)

        ui.newTTFLabel({text = title[i], size = 28})
        	:align(display.LEFT_CENTER, -100, 0)
        	:addTo(btn)

        sy = sy - dir
    end
end

function requestBind_(success, result)
    if success then
        if GUEST_BIND_TYPE == 2 then --line
            result = string.urlencode(result)
        end
        sa.HttpService.POST(
        {
            mod = "user", 
            act = "visitorBind",
            token = result,
            flag = GUEST_BIND_TYPE,
            mobile_request = tx.Native:getLoginToken(),
        }, 
        function(data)
            local recallData = json.decode(data)
            local code = recallData.code
            if code == 1 then
                if tx.userData then
                    tx.userData.canBindGuest = 2
                end
                BindRewardView.new():showPanel()
            elseif code == -3 then
                showFailedTips_()
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("BIND", "FAILED_TIPS_2"))
            end
        end, 
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("BIND", "FAILED_TIPS_2"))
        end)
    else
        if result == "canceled" then
            tx.TopTipManager:showToast(sa.LangUtil.getText("BIND", "CANCELED"))
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("BIND", "FAILED_TIPS_2"))
        end
    end
end

function showFailedTips_()
    tx.ui.Dialog.new({
        closeWhenTouchModel = false,
        titleText = sa.LangUtil.getText("BIND", "FAILED_TITLE"),
        messageText = sa.LangUtil.getText("BIND", "FAILED_TIPS"),
        firstBtnText = sa.LangUtil.getText("BIND", "GOTO_LOGIN"),
        secondBtnText = sa.LangUtil.getText("BIND", "RETRY"),
        callback = function (type)
            if type == tx.ui.Dialog.FIRST_BTN_CLICK then
                _G.isBindGuestLogin = true
                sa.EventCenter:dispatchEvent(tx.eventNames.HALL_LOGOUT_SUCC)
            elseif type == tx.ui.Dialog.SECOND_BTN_CLICK then
                BindGuestView.new():showPanel()
            end
        end
    }):show()
end

function BindGuestView:onBindClicked_(evt)
	local tag = evt.target:getTag()
    GUEST_BIND_TYPE = tag
    tx.userDefault:setIntegerForKey(tx.cookieKeys.GUEST_BIND_TYPE, tag)
    --自己业务PHP实现绑定
    if tag == 1 then
        if tx.Facebook then
            tx.Facebook:bindGuest(requestBind_)
        end
    elseif tag == 2 then
        if tx.LineSDK then
            tx.LineSDK:bindGuest(requestBind_)
        end
    end
    self:hidePanel()
end

return BindGuestView