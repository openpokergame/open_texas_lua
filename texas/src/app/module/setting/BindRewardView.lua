local BindRewardView = class("BindRewardView", tx.ui.Panel)
local SimpleAvatar   = import("openpoker.ui.SimpleAvatar")
local WIDTH, HEIGHT = 830, 570

function BindRewardView:ctor()
	BindRewardView.super.ctor(self, {WIDTH, HEIGHT})

    self.this_ = self

	self:setTextTitleStyle(sa.LangUtil.getText("BIND", "SUCCESS_TITLE"))

    self:addSecondFrame()

    self:addInfoNode_()

    cc.ui.UIPushButton.new({normal = "#common/btn_big_yellow.png", pressed = "#common/btn_big_yellow_down.png"}, {scale9 = true})
        :setButtonSize(400, 146)
        :setButtonLabel(ui.newTTFLabel({text = sa.LangUtil.getText("BIND", "GET_REWARD"), size = 30}))
        :pos(WIDTH*0.5, 105)
        :onButtonClicked(buttontHandler(self, self.onGetRewardClicked_))
        :addTo(self.background_)
end

function BindRewardView:addInfoNode_()
    local bg = self.background_
    local x, y = 270, HEIGHT - 180

    self.avatarIcon_ = SimpleAvatar.new({shapeImg = "#common/head_bg.png", frameImg = "#common/head_frame.png"})
        :setDefaultAvatar(tx.userData.sex)
        :pos(150, HEIGHT - 260)
        :addTo(bg)

    local s_picture = tx.userData.s_picture
    if s_picture and string.len(s_picture) > 5 then
        local imgurl = s_picture
        if string.find(imgurl, "facebook") then
            if string.find(imgurl, "?") then
                imgurl = imgurl .. "&width=200&height=200"
            else
                imgurl = imgurl .. "?width=200&height=200"
            end
        end
        self.avatarIcon_:loadImage(imgurl)
    end

    ui.newTTFLabel({text = tx.userData.nick, size = 30})
        :align(display.LEFT_CENTER, x, y)
        :addTo(bg)

    ui.newTTFLabel({text = "ID:".. tx.userData.uid, size = 30})
        :align(display.LEFT_CENTER, x + 300, y)
        :addTo(bg)

    y = y - 40
    local bindType = tx.userDefault:getIntegerForKey(tx.cookieKeys.GUEST_BIND_TYPE, 1)
    local account = sa.LangUtil.getText("BIND", "ACCOUNT")
    local reward = sa.formatNumberWithSplit(tx.userData.guestBindReward)
    ui.newTTFLabel({text = sa.LangUtil.getText("BIND", "GET_REWARD_TIPS", account[bindType], reward), size = 30, dimensions = cc.size(500, 0), align = ui.TEXT_ALIGN_LEFT, valign = ui.TEXT_VALIGN_TOP,})
        :align(display.LEFT_TOP, x, y)
        :addTo(bg)
end

function BindRewardView:onGetRewardClicked_(evt)
    local btn = evt.target
    btn:setButtonEnabled(false)
    self:setLoading(true)
	sa.HttpService.POST(
        {
            mod = "user",
            act = "visitorBindRwd",
            uid = tx.userData.uid
        },
        function(data)
            if self.this_ then
                self:setLoading(false)
                btn:setButtonEnabled(true)
            end

            local jsonData = json.decode(data)
            if jsonData.code == 1 then
                local reward = {
                    rewardType = 1,
                    num = jsonData.money
                }

                tx.userData.isGuestBindReward = 1
                tx.userData.money = tx.userData.money + tonumber(reward.num)
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=reward.num}})
                sa.EventCenter:dispatchEvent("GUEST_BIND_REWARD")
                
                tx.ui.RewardDialog.new(reward):showPanel()
                
                if self.this_ then
                    self:hidePanel()
                end
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("BIND", "GET_REWARD_FAILED"))
            end
        end,
        function ()
            if self.this_ then
                self:setLoading(false)
                btn:setButtonEnabled(true)
            end
            tx.TopTipManager:showToast(sa.LangUtil.getText("BIND", "GET_REWARD_FAILED"))
        end)
end

return BindRewardView