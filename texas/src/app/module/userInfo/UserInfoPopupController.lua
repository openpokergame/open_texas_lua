local UserInfoPopupController = class("UserInfoPopupController")
local logger = sa.Logger.new("UserInfoPopupController")

function UserInfoPopupController:ctor(view)
    self.view_ = view
end

--上传头像图片
function UserInfoPopupController:uploadPicture()
    -- 统计点击的次数
    local function report_change_avatar_click()
        if device.platform == "android" or device.platform == "ios" then
            cc.analytics:doCommand {
                command = "event",
                args = {eventId = "change_avatar_click", label = "user Upload Avatar_click"}
            }
        end
    end

    local function report_upload_failed(reason)
        local t = sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_FAIL")
        tx.TopTipManager:showToast(t)
        if device.platform == "android" or device.platform == "ios" then
            cc.analytics:doCommand {
                command = "event",
                args = {eventId = "upload_avatar_failed", label = "Upload Avatar to userData.UPLOAD_PIC failed: " .. reason}
            }
        end
    end

    local function report_change_avatar_time()
        if device.platform == "android" or device.platform == "ios" then
            cc.analytics:doCommand {
                command = "event",
                args = {eventId = "change_avatar_time", label = "user Upload avatar_time"}
            }
        end
    end

    local userData = tx.userData
    
    local function uploadPictureCallback(result, evt)
        if evt.name == "completed" then
            local request = evt.request
            local code = request:getResponseStatusCode()
            local ret = request:getResponseString()
            logger:debugf("REQUEST getResponseStatusCode() = %d", code)
            logger:debugf("REQUEST getResponseHeadersString() =\n%s", request:getResponseHeadersString())
            logger:debugf("REQUEST getResponseDataLength() = %d", request:getResponseDataLength())
            logger:debugf("REQUEST getResponseString() =\n%s", ret)

            local retTable = json.decode(ret)
            if retTable and retTable.code == 1 and retTable.iconname then
                local imgURL = retTable.iconname
                sa.HttpService.POST(
                    {
                        mod="user",
                        act="uploadIcon",
                        iconname=imgURL
                    },
                    function(data)
                        local jsonData = json.decode(data)
                        if jsonData and jsonData.code == 1 then
                            tx.fastSaveHead(jsonData.data.s_picture,self.newHeadPath_)
                            userData.s_picture = jsonData.data.s_picture

                            local t = sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_SUCCESS")
                            tx.TopTipManager:showToast(t)
                            if self.view_ and (self.view_.isInRoom_ or self.view_.isRedblack==true) then
                                tx.socket.HallSocket:sendUserInfoChanged(true)
                            end
                        else
                            self:delSelect()
                            local t = sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_FAIL")
                            tx.TopTipManager:showToast(t)
                        end
                    end,
                    function()
                        self:delSelect()
                        local t = sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_FAIL")
                        tx.TopTipManager:showToast(t)
                    end)
            else
                self:delSelect()
                local msg = ""
                if retTable and retTable.msg then
                    msg = retTable.msg
                else
                    msg = sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_UPLOAD_FAIL")
                end
                tx.TopTipManager:showToast(msg)
            end
            -- 统计换头像成功的次数
            report_change_avatar_time()
        elseif evt.name == 'cancelled' then
            self:delSelect()
            report_upload_failed('cancelled')
        elseif evt.name == 'failed' then
            self:delSelect()
            report_upload_failed('failed')
        elseif evt.name == 'unknown' then
            self:delSelect()
            report_upload_failed('unknown')
        end
    end

    local function pickImageCallback(success, result)
        logger:debug("tx.Native:pickImage callback ", success, result)
        if success then
            if sa.isFileExist(result) then
                self.newHeadPath_ = result
                tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_IS_UPLOADING"))
                local sid = appconfig.SID[string.upper(device.platform)] or 1
                local time = os.time()
                local iconKey = "%^(sa)-#$9988@&"
                local sign = crypto.md5(userData.uid .. "|" .. sid .. "|" .. time .. iconKey)

                local upload_data = {
                    fileFieldName = "upload", filePath = result,
                    contentType = "image/png",
                    extra = {
                        {"uid", userData.uid},
                        {"sid", sid},
                        {"time", time},
                        {"sign", sign},
                    }
                }
                local PHPServerUrl_ = require("app.PHPServerUrl")
                if appconfig.LOGIN_SERVER_URL == PHPServerUrl_[1].url then
                    table.insert(upload_data.extra,{"demo", 1})
                end

                local cb = sa.lime.simple_curry(uploadPictureCallback, result)
                network.uploadFile(cb, userData.userUploadIconUrl, upload_data)
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            end
        else
            if result == "nosdcard" then
                tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_NO_SDCARD"))
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "UPLOAD_PIC_PICK_IMG_FAIL"))
            end
        end
    end

    report_change_avatar_click()
    tx.Native:pickImage(pickImageCallback)
end

function UserInfoPopupController:delSelect()
    if self.newHeadPath_ then
        os.remove(self.newHeadPath_)
        self.newHeadPath_ = nil
    end
end

--line认证
function UserInfoPopupController:checkLine(line)
    self.view_:setLoading(true)
    sa.HttpService.POST({
        mod = "User",
        act = "setLine",
        lineaccount = line
    },
    function(data)
        local retData = json.decode(data)
        self.view_:setLoading(false)
        if retData.code == 1 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "LINE_CHECK_SUCCESS"))
            tx.userData.lineaccount = line
            local today = os.date('%Y%m%d')
            local key = "CHECK_LINE" .. today
            tx.userDefault:setIntegerForKey(key, 1)
        else
            tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "LINE_CHECK_FAIL"))
        end
    end,
    function()
        self.view_:setLoading(false)
        tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "LINE_CHECK_FAIL"))
    end
    )
end

--牌局信息
function UserInfoPopupController:getBoardRecord(id)
    self.view_:setLoading(true)
    self.getInfoId_ = sa.HttpService.POST({
        mod = "User",
        act = "checkPlayer",
        cuid = id
    },
    function(data)
        local retData = json.decode(data)
        if retData and retData.code == 1 then
            if tonumber(id)==tx.userData.uid and retData.info and retData.info.money then -- 个人获取同步资产
                tx.userData.money = tonumber(retData.info.money) or tx.userData.money
                tx.userData.diamonds = tonumber(retData.info.diamonds) or tx.userData.diamonds
                tx.userData.level = tonumber(retData.info.level) or tx.userData.level
                tx.userData.exp = tonumber(retData.info.exp) or tx.userData.exp
                tx.userData.countryId = tonumber(retData.info.countryId) or tx.userData.countryId
            end
            self.view_:setLoading(false)
            self.view_:addUserBoardRecordView(retData.info)
            tx.userData.nextRewardLevel = retData.info.nextRewardLevel
        else
            -- tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "GET_BOARD_RECORD_FAIL"))
        end
    end,
    function()
        -- tx.TopTipManager:showToast(sa.LangUtil.getText("USERINFO", "GET_BOARD_RECORD_FAIL"))
    end
    )
end

function UserInfoPopupController:dispose()
    self:delSelect()
    sa.HttpService.CANCEL(self.getInfoId_)
end

return UserInfoPopupController
