local SafePopupController = class("SafePopupController")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local requestRetryTimes_ = 2

function SafePopupController:ctor(view)
    self.view_ = view
end

function SafePopupController:saveMoney(moneyType, num)
    self:saveOrGetMoney_(moneyType, num)
end

function SafePopupController:getMoney(moneyType, num)
    self:saveOrGetMoney_(moneyType, -num)
end

-- 存钱或取钱
function SafePopupController:saveOrGetMoney_(moneyType, num)
    local text = sa.LangUtil.getText("SAFE", "SAVE_MONEY_FAILED")
    if num < 0 then
        text = sa.LangUtil.getText("SAFE", "GET_MONEY_FAILED")
    end
    self.friendDataRequestId_ = sa.HttpService.POST(
    {
        mod = "Vip", 
        act = "storeMoney",
        money = num,
        state=moneyType
    }, 
    function(data)
        local recallData = json.decode(data)
        if recallData.code == 1 then
            if self.view_ then
                self.view_:updateTextInfo(moneyType, tonumber(recallData.list.money))
            end
        elseif recallData.code == -2 then
            tx.TopTipManager:showToast(sa.LangUtil.getText("SAFE", "VIP_TIPS_2"))
        else
            tx.TopTipManager:showToast(text)
        end
    end,
    function ()
        tx.TopTipManager:showToast(text)
    end)
end

--修改密码
function SafePopupController:changePassword(password)
    local isPassword = tx.userData.safe_password
    local successTips = sa.LangUtil.getText("SAFE", "SET_PASSWORD_SUCCESS")
    local failedTips = sa.LangUtil.getText("SAFE", "SET_PASSWORD_FAILED")
    local str = crypto.md5(password)

    if isPassword == 1 then
        successTips = sa.LangUtil.getText("SAFE", "CHANGE_PASSWORD_SUCCESS")
        failedTips = sa.LangUtil.getText("SAFE", "CHANGE_PASSWORD_FAILED")
    end

    if password == "" then
        successTips = sa.LangUtil.getText("SAFE", "CLEAN_PASSWORD_SUCCESS")
        failedTips = sa.LangUtil.getText("SAFE", "CLEAN_PASSWORD_FAILED")
        str = ""
    end

    sa.HttpService.POST(
    {
        mod = "Vip",
        act = "updateBankPasswd", 
        passwd = str
    }, 
    function(data)
        local recallData = json.decode(data)
        if recallData.code == 1 or recallData.code == 0 then
            tx.userData.safe_password = recallData.code
            tx.TopTipManager:showToast(successTips)
        else
            tx.TopTipManager:showToast(failedTips)
        end
    end, 
    function ()
        tx.TopTipManager:showToast(failedTips)
    end)
end

function SafePopupController:dispose()
end

return SafePopupController