local logger = sa.Logger.new("PanelFeedback")

local PanelFeedback = class("PanelFeedback", function() return display.newNode() end)
local ItemFeedback = import(".items.ItemFeedback")
PanelFeedback.ELEMENTS = {
    "nodeTabs",
    "labelNoFeed",
    "inputBg",
    "btnPic",
    "btnPic.iconPic",
    "btnSend.labelSend",
    "nodeFeedList",
}

function PanelFeedback:ctor(idx)
    self:setNodeEventEnabled(true)
	self.selected_ = idx or 1
	if self.selected_<1 or self.selected_>4 then self.selected_=1 end
	tx.ui.EditPanel.bindElementsToTarget(self,"dialog_help_feed_back.csb",true)    
    self.iconSize_ = self.btnPic.iconPic:getContentSize()
    self.btnSend.labelSend:setString(sa.LangUtil.getText("COMMON","SEND"))
    sa.fitSprteWidth(self.btnSend.labelSend, 145)
    ImgButton(self.btnSend,"#common/btn_small_green.png","#common/btn_small_green_down.png"):onButtonClicked(function()
        self:sendFeedBack()
    end)
    ColorButton(self.btnPic):onButtonClicked(function()
        self:pickPicture()
    end)

    local size = self.inputBg:getContentSize()
    local inputWidth  = size.width
    local inputHeight = size.height
    local inputContentSize = 26
    local inputContentColor = cc.c3b(0xff, 0xff, 0xff)
    local inputEditBox_x, inputEditBox_y = size.width*0.5, size.height*0.5
    local editbox = ui.newEditBox({
            image = "#common/transparent.png",
            size = cc.size(inputWidth, inputHeight),
            listener = handler(self, self.onContentEdit_)
        })
        :align(display.LEFT_CENTER, 0, inputEditBox_y)
        :addTo(self.inputBg)
    editbox:setTouchSwallowEnabled(false)
    editbox:setFontColor(inputContentColor)
    editbox:setPlaceholderFontColor(inputContentColor)
    editbox:setFont(ui.DEFAULT_TTF_FONT, inputContentSize)
    editbox:setPlaceholderFont(ui.DEFAULT_TTF_FONT, inputContentSize)
    editbox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editbox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)

    self.hintText_ = sa.LangUtil.getText("HELP", "FEED_BACK_HINT")
    self.showContent = ui.newTTFLabel({
            text = "",
            size = inputContentSize,
            color = styles.FONT_COLOR.CONTENT_TEXT,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_TOP,
            dimensions = cc.size(inputWidth - 50, inputHeight - 10)
        })
        :align(display.LEFT_CENTER, 10, inputEditBox_y)
        :addTo(self.inputBg)
        :size(inputWidth, inputHeight)


	local size = self.nodeTabs:getContentSize()
	local tab = tx.ui.TabBarWithIndicator.new(
        {
            background = "#common/transparent.png", 
            indicator = "#common/pop_tab_selected_2.png"
        },
        sa.LangUtil.getText("HELP", "FEED_BACK_SUB_TAB_TEXT"),
        {
            selectedText = {color = styles.FONT_COLOR.SUB_TAB_ON, size = 24},
            defaltText = {color = styles.FONT_COLOR.SUB_TAB_OFF, size = 24}
        },
        true, true)
		:setTabBarSize(size.width, 52, 0, -4)
		:onTabChange(handler(self, self.onTabChanged_))
		:pos(size.width*0.5, size.height*0.5)
		:addTo(self.nodeTabs)
    self.tab_ = tab
	tab:gotoTab(self.selected_, true)

    -- local LIST_WIDTH,LIST_HEIGHT = 768, 196
    -- ItemFeedback.WIDTH = LIST_WIDTH
    -- self.feedbackList_ = sa.ui.ListView.new(
    --         {
    --             viewRect = cc.rect(-LIST_WIDTH * 0.5, -LIST_HEIGHT * 0.5, LIST_WIDTH, LIST_HEIGHT),
    --         },
    --         ItemFeedback
    --     )
    --     :addTo(self.nodeFeedList)
    -- --测试数据
    -- self.feedbackList_:setData({
    --     {q="为啥我这么帅",a="没办法啊..."},
    --     {q="为啥我这么帅",a="客服回复中..."},
    --     {q="为啥我这么帅",a="客服回复中..."},
    --     {q="为啥我这么帅",a="客服回复中..."},
    -- })
end

function PanelFeedback:onContentEdit_(event, editbox)
    if event == "began" then
        local displayingText = self.showContent:getString()
        local isIn_ = false
        for k,v in pairs(self.hintText_) do
            if displayingText==v then
                isIn_ = true
                break;
            end
        end
        if isIn_ then
            editbox:setText("")
        else
            editbox:setText(displayingText)
        end
        self.showContent:setString("")
    elseif event == "changed" then
    elseif event == "ended" then
        local text = editbox:getText()
        if text == "" or  string.trim(text)=="" then
            local index = self.tab_:getSelectedTab()
            text = self.hintText_[index]
        end
        self.showContent:setString(text)
        editbox:setText("")
    elseif event == "return" then

    end
end

function PanelFeedback:onTabChanged_(selectedTab)
    self:setLoading(false)
    self:rebackImg()
    self.showContent:setString(self.hintText_[selectedTab])
end

--上传反馈
function PanelFeedback:pickPicture()
    local function pickImageCallback(success, result)
        -- -- 测试
        -- success = true
        -- result = "C:/Users/Administrator/Desktop/22.jpg"
        if success then
            if sa.isFileExist(result) then
                -- self:removeImg()   --路径一样不能删除哦
                self.feedBackImgUrl_ = result -- 反馈图片的路径
                display.removeSpriteFrameByImageName(result)  --IOS一直被缓存着...因为名字一样的，显示还是第一张选择图片
                self.btnPic.iconPic:setSpriteFrame(display.newSprite(result):getSpriteFrame())
                local size = self.btnPic.iconPic:getContentSize()
                local scaleX_ = self.iconSize_.width/size.width
                local scaleY_ = self.iconSize_.height/size.height
                if scaleX_<scaleY_ then
                    self.btnPic.iconPic:setScale(scaleX_)
                else
                    self.btnPic.iconPic:setScale(scaleY_)
                end
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
                self:rebackImg()
            end
        else
            -- if result == "nosdcard" then
            --     tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            -- else
            --     tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            -- end
            self:rebackImg()
        end
    end
    tx.Native:pickupPic(pickImageCallback)
    -- tx.Native:pickImage(pickImageCallback)
end
function PanelFeedback:sendFeedBack()
    local displayingText = self.showContent:getString()
    local isIn_ = false
    for k,v in pairs(self.hintText_) do
        if displayingText==v then
            isIn_ = true
            break;
        end
    end
    if isIn_ then
        tx.TopTipManager:showToast(sa.LangUtil.getText("HELP","MUST_INPUT_FEEDBACK_TEXT_MSG"))
        return;
    end
    local feedUid = 1
    local feedLid = 1
    local outGame = 0
    local feedImgUrl = appconfig.FEEDBACK_IMG_URL
    local feedContentUrl = appconfig.FEEDBACK_CONTENT_URL
    local index = self.tab_:getSelectedTab()
    if tx.userData and tx.userData.uid then
        feedUid = tx.userData.uid
        feedImgUrl = tx.userData.userFeedbackUrl
        feedContentUrl = tx.userData.CGI_ROOT
        feedLid = tx.userData.lid
    end
    -- 获取缓存中最后一个登录的ID
    if feedUid==1 then
        outGame = 1
        local uids = tx.userDefault:getStringForKey(tx.cookieKeys.LOGIN_UIDS, "")
        if uids ~= "" then
            local uidsTbl = string.split(uids, "#")
            if uidsTbl and #uidsTbl>0 then
                feedUid = uidsTbl[1]
            end
        end
    end
    local function uploadContent(img)
        sa.HttpService.CANCEL(self.feedBackRequestId_)
        local feedParam = {}
        if device.platform == "android" then  -- Android的审核问题
            feedParam.macid = tx.Native:getMac()
        else
            feedParam = tx.Native:getDeviceInfo()
            feedParam.macid = feedParam.deviceId or ""
        end
        feedParam.mod = "Feedback"
        feedParam.act = "usersubmit"
        feedParam.uid = feedUid
        feedParam.sid = appconfig.SID[string.upper(device.platform)] or 1
        feedParam.type = index
        feedParam.desc = displayingText
        feedParam.img = img
        feedParam.lid = feedLid
        feedParam.version = (SA_UPDATE and SA_UPDATE.VERSION or tx.Native:getAppVersion())
        feedParam.network = network.getInternetConnectionStatus()
        feedParam.outGame = outGame
        self.feedBackRequestId_ = sa.HttpService.POST_URL(feedContentUrl,
            feedParam,
            function()
                tx.TopTipManager:showToast(sa.LangUtil.getText("HELP", "FEED_BACK_SUCCESS"))
                self:onTabChanged_(index)
            end,
            function()
                tx.TopTipManager:showToast(sa.LangUtil.getText("HELP", "FEED_BACK_FIAL"))
                self:setLoading(false)
            end
        )
    end
    local function uploadImageCallBack(result, evt)
        if evt.name == "completed" then
            local request = evt.request
            local code = request:getResponseStatusCode()
            local ret = request:getResponseString()
            logger:debugf("REQUEST getResponseStatusCode() = %d", code)
            logger:debugf("REQUEST getResponseHeadersString() =\n%s", request:getResponseHeadersString())
            logger:debugf("REQUEST getResponseDataLength() = %d", request:getResponseDataLength())
            logger:debugf("REQUEST getResponseString() =\n%s", ret)

            local retTable = json.decode(ret)
            if retTable and retTable.code == 1 and retTable.img then
                uploadContent(retTable.img)
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("HELP", "FEED_BACK_FIAL"))
                self:setLoading(false)
            end
        elseif evt.name == 'cancelled' then
            tx.TopTipManager:showToast(sa.LangUtil.getText("HELP", "FEED_BACK_FIAL"))
            self:setLoading(false)
        elseif evt.name == 'failed' then
            tx.TopTipManager:showToast(sa.LangUtil.getText("HELP", "FEED_BACK_FIAL"))
            self:setLoading(false)
        elseif evt.name == 'unknown' then
            tx.TopTipManager:showToast(sa.LangUtil.getText("HELP", "FEED_BACK_FIAL"))
            self:setLoading(false)
        end
    end
    local function uploadImage(imgPath)
        if sa.isFileExist(imgPath) then
            tx.TopTipManager:showToast(sa.LangUtil.getText("HELP", "UPLOADING_PIC_MSG"))
            local sid = appconfig.SID[string.upper(device.platform)] or 1
            local time = os.time()
            local iconKey = "%^(sa)-#$fback9988@&^!"
            local sign = crypto.md5(feedUid .. "|" .. sid .. "|" .. time .. iconKey)

            local upload_data = {
                fileFieldName = "upload", filePath = imgPath,
                contentType = "image/png",
                extra = {
                    {"uid", feedUid},
                    {"sid", sid},
                    {"time", time},
                    {"sign", sign},
                }
            }
            local PHPServerUrl_ = require("app.PHPServerUrl")
            if appconfig.LOGIN_SERVER_URL == PHPServerUrl_[1].url then
                table.insert(upload_data.extra,{"demo", 1})
            end

            local cb = sa.lime.simple_curry(uploadImageCallBack, imgPath)
            network.uploadFile(cb, feedImgUrl, upload_data)
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            self:setLoading(false)
        end
    end
    self:setLoading(true)
    if self.feedBackImgUrl_ and string.trim(self.feedBackImgUrl_)~="" then
        uploadImage(self.feedBackImgUrl_)
    else
        uploadContent("")
    end
end
function PanelFeedback:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(0, 0)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end
function PanelFeedback:removeImg()
    if self.feedBackImgUrl_ then
        os.remove(self.feedBackImgUrl_)
    end
    self.feedBackImgUrl_ = nil
end
function PanelFeedback:rebackImg()
    self:removeImg()
    self.btnPic.iconPic:setScale(1)
    self.btnPic.iconPic:setSpriteFrame(display.newSprite("#dialogs/help/photo_icon.png"):getSpriteFrame())
end
function PanelFeedback:onCleanup()
    self:removeImg()
    sa.HttpService.CANCEL(self.feedBackRequestId_)
end
return PanelFeedback