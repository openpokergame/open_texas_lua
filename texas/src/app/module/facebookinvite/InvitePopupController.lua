-- 邀请好友相关逻辑
local InvitePopupController = class("InvitePopupController")
local logger = sa.Logger.new("InvitePopupController")

local INVITE_DAYS = 3 --邀请好友显示间隔天数
local INVITE_FB_NUM = 200 --拉取FB好友数
local INVITE_ARR_INDEX --分批邀请遍历下标

local sendInvite --递归邀请函数

function InvitePopupController:ctor(view)
	self.view_ = view
end

function InvitePopupController:getInvitableFriends()
	tx.Facebook:getInvitableFriends(300, handler(self, self.onGetData_))
end

function InvitePopupController:onGetData_(success, friendData, accesstoken)
	self.view_:onGetData_(success, friendData)
	-- self.view_:setSelectedAll()
end

-- 不能使用self，因为此对象会被释放
function updateTodayInviteCount_(num)
    local today = os.date('%Y%m%d')
    local k1 = tx.cookieKeys.FB_LAST_INVITE_DAY
    local k2 = tx.cookieKeys.FB_INVITE_FRIENDS_NUMBER
    local saved_day = tx.userDefault:getStringForKey(k1, '')

    if saved_day == today then
        local current = tx.userDefault:getIntegerForKey(k2, 0)
        tx.userDefault:setIntegerForKey(k2, current + num)
    else
        tx.userDefault:setStringForKey(k1, today)
        tx.userDefault:setIntegerForKey(k2, num)
    end

    tx.userDefault:flush()
end

function savedTodayInvitedMoney_(money)
    if money == 0 then
        return
    end

    local invitedMoney = tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_TODAY_INVITE_MONEY, "")
    local today = os.date("%Y%m%d")

    if invitedMoney == "" or string.sub(invitedMoney, 1, 8) ~= today then
        invitedMoney = today .."#" .. money
    else
        local reward = string.split(invitedMoney, "#") 
        local totalMoney = tonumber(reward[2]) + money

        invitedMoney = today .. "#" .. totalMoney
    end

    tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_TODAY_INVITE_MONEY, invitedMoney)
    tx.userDefault:flush()
end

function getTodayInvitedMoney_()
    local invitedMoney = tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_TODAY_INVITE_MONEY, "")
    local today = os.date("%Y%m%d")
    local money = 0

    if invitedMoney == "" or string.sub(invitedMoney, 1, 8) ~= today then
        money = 0
    else
        local reward = string.split(invitedMoney, "#") 
        money = tonumber(reward[2])
    end

    return money
end

function sendInvite(toIdList, nameList, toPictureList)
	local len = #toIdList
	if INVITE_ARR_INDEX > len then
		return
	end

    local toIds = table.concat(toIdList[INVITE_ARR_INDEX], ",")
    local names = table.concat(nameList[INVITE_ARR_INDEX], "#")
    local toPicture = toPictureList[INVITE_ARR_INDEX]
    local selectedNum = #toIdList[INVITE_ARR_INDEX]

	sa.HttpService.POST(
        {
            mod = "invite",
            act = "getInviteID"
        },
        function (data)
            local retData = json.decode(data)
            local requestData = ""

            if retData.code == 1 then
                requestData = "u:"..retData.u..";id:"..retData.id..";sk:"..retData.sk
            end

            local needReport = false
            if retData and retData.needReport and retData.needReport == 1 then
                needReport = true
            end

            tx.Facebook:sendInvites(
                requestData,
                toIds,
                sa.LangUtil.getText("FRIEND", "INVITE_SUBJECT"),
                sa.LangUtil.getText("FRIEND", "INVITE_CONTENT"),
                function (success, result)
                    if success then
                        -- 更新成功邀请的次数
                        updateTodayInviteCount_(selectedNum)

                        -- 保存邀请过的名字
                        if names ~= "" then
                            local invitedNames = tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_INVITED_NAMES, "")
                            local today = os.date("%Y%m%d")
                            if invitedNames == "" or string.sub(invitedNames, 1, 8) ~= today then
                                invitedNames = today .."#" .. names
                            else
                                invitedNames = invitedNames .. "#" .. names
                            end
                            tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_INVITED_NAMES, invitedNames)
                            tx.userDefault:flush()
                        end

                        -- 去掉最后一个逗号,java层拼接字符串会多一个逗号
                        if result.toIds then
                            local idLen = string.len(result.toIds)
                            if idLen > 0 and string.sub(result.toIds, idLen, idLen) == "," then
                                result.toIds = string.sub(result.toIds, 1, idLen - 1)
                            end
                        end
                        
                        requestData = string.gsub(requestData, ";match:2", "")

                        -- 上报php，领奖
                        local postData = {
                            mod = "invite",
                            act = "report",
                            data = requestData,
                            requestid = result.requestId,
                            list = result.toIds,
                            source = "register",
                        }

                        postData.type = "register"
                        if needReport then
                            postData.userList = names
                        end

                        sa.HttpService.POST(
                            postData,
                            function (data)
                                local retData = json.decode(data)
                                if retData and retData.code == 0 and retData.money then
                                    if retData.money > 0 then
                                        tx.userData.money = tx.userData.money + retData.money
                                        sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=retData.money}})
                                        savedTodayInvitedMoney_(retData.money)

                                        tx.TopTipManager:showGoldTips(sa.LangUtil.getText("FRIEND", "INVITE_SUCC_TIP", retData.money))
                                    else
                                        local todayMoney = getTodayInvitedMoney_()
                                        if todayMoney > 0 then
                                            tx.HorseLamp:showTips(sa.LangUtil.getText("FRIEND", "INVITE_SUCC_FULL_TIP", sa.formatBigNumber(todayMoney)),nil,true)
                                        end
                                    end
                                end
                            end,
                            function(data)
                                print("php return false:" .. data)
                            end
                        )

                        INVITE_ARR_INDEX = INVITE_ARR_INDEX + 1
                        sendInvite(toIdList, nameList, toPictureList)
                    end
                end
            )
        end,
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("TIPS", "ERROR_INVITE_FRIEND"))
        end
    )
end

function InvitePopupController:sendInvites(selectedList)
	local toIdArr, nameArr, pictureArr = {}, {}, {}
	local toIdList, nameList, toPictureList = {}, {}, {}
	local num = 0
	local index = 1
    for _, item in ipairs(selectedList) do
        local data = item:getData()
        local id = data.id
        if item:isSelected() then
        	num = num + 1
            table.insert(toIdArr, id)
            table.insert(nameArr, data.name)
            local pic = self:getFriendPicture_(data.url)
            table.insert(pictureArr, pic)

            if num == 50 then
            	toIdList[index] = toIdArr
    			nameList[index] = nameArr
    			toPictureList[index] = pictureArr

    			toIdArr = {}
				nameArr = {}
				pictureArr = {}

				num = 0
				index = index + 1
            end        
        end
    end

    if num > 0 then
    	toIdList[index] = toIdArr
    	nameList[index] = nameArr
    	toPictureList[index] = pictureArr
    end

    INVITE_ARR_INDEX = 1
	sendInvite(toIdList, nameList, toPictureList)
end

function InvitePopupController:filterAllData(friendData)
    local invitedNames = tx.userDefault:getStringForKey(tx.cookieKeys.FACEBOOK_INVITED_NAMES, "")
    local yesterdayInvitedNames = tx.userDefault:getStringForKey(tx.cookieKeys.YESTERDAY_INVITED_NAMES, "")
    local thirddayInvitedNames = tx.userDefault:getStringForKey(tx.cookieKeys.THIRDDAY_INVITED_NAMES, "")

    local yesterday = os.date("%Y%m%d",os.time() - 86400)
    local thirdday = os.date("%Y%m%d",os.time() - 86400 * 2)

    if thirddayInvitedNames ~= "" then
        local thirddayNamesTable = string.split(thirddayInvitedNames, "#")
        if thirddayNamesTable[1] ~= thirdday then
            tx.userDefault:setStringForKey(tx.cookieKeys.THIRDDAY_INVITED_NAMES, "")
            thirddayInvitedNames = ""
        end
    end

    if yesterdayInvitedNames ~= "" then
        local yesterdayNamesTable = string.split(yesterdayInvitedNames, "#")
        if yesterdayNamesTable[1] ~=  yesterday then
            if yesterdayNamesTable[1] == thirdday then
                thirddayInvitedNames = yesterdayInvitedNames
                tx.userDefault:setStringForKey(tx.cookieKeys.THIRDDAY_INVITED_NAMES, thirddayInvitedNames)
            end
            tx.userDefault:setStringForKey(tx.cookieKeys.YESTERDAY_INVITED_NAMES, "")
            yesterdayInvitedNames = ""
        end
    end

    if invitedNames ~= "" then
        local namesTable = string.split(invitedNames, "#")
        if namesTable[1] == thirdday then
            tx.userDefault:setStringForKey(tx.cookieKeys.THIRDDAY_INVITED_NAMES, invitedNames)
            tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_INVITED_NAMES, "")
            thirddayInvitedNames = invitedNames
            invitedNames = ""
        elseif namesTable[1] == yesterday then
            tx.userDefault:setStringForKey(tx.cookieKeys.YESTERDAY_INVITED_NAMES, invitedNames)
            tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_INVITED_NAMES, "")
            yesterdayInvitedNames = invitedNames
            invitedNames = ""
        elseif namesTable[1] == os.date("%Y%m%d") then
            
        else
            tx.userDefault:setStringForKey(tx.cookieKeys.FACEBOOK_INVITED_NAMES, "")
            invitedNames = ""
        end
    end

    local invitedNamesList = {invitedNames, yesterdayInvitedNames, thirddayInvitedNames}
    for i = 1, INVITE_DAYS do
    	local names = invitedNamesList[i]
    	if names ~= "" then
	        local namesTable = string.split(names, "#")
	        table.remove(namesTable, 1)
	        for _, name in pairs(namesTable) do
	            local i, max = 1, #friendData
	            while i <= max do
	                if friendData[i].name == name then
	                    logger:debug("remove invited name -> ", name)
	                    table.remove(friendData, i)
	                    i = i - 1
	                    max = max - 1
	                end
	                i = i + 1
	            end
	        end
	    end
    end

    return friendData
end

--获取好友头像图片名字
function InvitePopupController:getFriendPicture_(url)
    local p = ".*/(.*)_n%.jpg"
    local str = string.match(url, p)
    local md5str = crypto.md5(str)

    return md5str
end

return InvitePopupController