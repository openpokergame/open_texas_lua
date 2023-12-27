local AboutPopup = class("AboutPopup", tx.ui.Panel)

local WIDTH, HEIGHT = 830, 570

function AboutPopup:ctor()
    AboutPopup.super.ctor(self, {WIDTH, HEIGHT})

    self:setTextTitleStyle(sa.LangUtil.getText("ABOUT", "TITLE"))

    self:addContentNode_()

    self:addTermsNode_()
end

function AboutPopup:addContentNode_()    
    local frame_w, frame_h = WIDTH - 56, HEIGHT - 160
    local frame = display.newScale9Sprite("#common/userinfo_middle_frame.png", 0, 0, cc.size(frame_w, frame_h))
        :align(display.BOTTOM_CENTER, WIDTH/2, 30)
        :addTo(self.background_)    

    --玩家uid
    local x, y = 30, frame_h - 30
    local fontSize = 26
    local label = ui.newTTFLabel({text = sa.LangUtil.getText("ABOUT", "UID", tx.userData.uid), size = fontSize})
        :align(display.LEFT_TOP, x, y)
        :addTo(frame)

    local dir = label:getContentSize().height + 20

    --版本号
    y = y - dir
    label = ui.newTTFLabel({text = sa.LangUtil.getText("ABOUT", "VERSION", SA_UPDATE and SA_UPDATE.VERSION or tx.Native:getAppVersion()), size = fontSize})
        :align(display.LEFT_TOP, x, y)
        :addTo(frame)
    dir = label:getContentSize().height + 20

    --粉丝页
    y = y - dir
    ui.newTTFLabel({text = sa.LangUtil.getText("ABOUT", "FANS"), size = fontSize})
        :align(display.LEFT_TOP, x, y)
        :addTo(frame)
end

--服务条款
function AboutPopup:addTermsNode_()
    local bg = self.background_
    local x, y = WIDTH/2, 85
    local label = ui.newTTFLabel({text = sa.LangUtil.getText("ABOUT", "SERVICE"), size = 20})
        :pos(x, y)
        :addTo(bg)

    local size = label:getContentSize()
    cc.ui.UIPushButton.new("#common/transparent.png", {scale9 = true})
        :setButtonSize(size.width, size.height)
        :pos(x, y)
        :onButtonClicked(function()
            device.openURL(appconfig.POLICY_URL)
        end)
        :addTo(bg)

    --公司版权
    ui.newTTFLabel({text = sa.LangUtil.getText("ABOUT", "COPY_RIGHT"), size = 20, color = styles.FONT_COLOR.CONTENT_TEXT})
        :pos(x, y - 25)
        :addTo(bg)
end

return AboutPopup