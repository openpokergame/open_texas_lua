local functions = {}

function functions.getCardDesc(handCard)
    if handCard then
        local value = handCard % 256
        local variety = math.floor(handCard / 256)

        local p = ""
        if variety == 1 then
            p = "方块"
        elseif variety == 2 then
            p = "梅花"
        elseif variety == 3 then
            p = "红桃"
        elseif variety == 4 then
            p = "黑桃"
        end

        if value >= 2 and value <= 10 then
            p = p .. value
        elseif value == 11 then
            p = p .. "J"
        elseif value == 12 then
            p = p .. "Q"
        elseif value == 13 then
            p = p .. "K"
        elseif value == 14 then
            p = p .. "A"
        end

        if p == "" then
            return "无"
        else
            return p
        end
    else
        return "无"
    end
end

function functions.cacheKeyWordFile()
    if not functions.keywords and tx.userData then
        sa.cacheFile(tx.userData.FILTER_CONF, function(result, content)
            if result == "success" then
                functions.keywords = json.decode(content);
                
                table.sort(functions.keywords, function(a, b)
                    return string.utf8len(a)>string.utf8len(b);
                end);
            end
        end, "keywordfilter")
    end
end

function functions.keyWordFilter(message, replaceWord)
    local replaceWith = replaceWord or "**"
    if not functions.keywords then
        functions.cacheKeyWordFile()
    else
        local searchMsg = string.lower(message)
        for i=1,#functions.keywords do
            local v = functions.keywords[i];
            local keywords = string.lower(v)
            local limit = 50
            while true do
                limit = limit - 1
                if limit <= 0 then
                    break
                end
                local s, e = string.find(searchMsg, keywords)
                if s and s > 0 then
                    searchMsg = string.sub(searchMsg, 1, s - 1) .. replaceWith ..string.sub(searchMsg, e + 1)
                    message = string.sub(message, 1, s - 1) .. replaceWith .. string.sub(message, e + 1)
                else
                    break
                end
            end
        end
    end
    return message
end

function functions.badNetworkToptip()
    local t = sa.LangUtil.getText("COMMON", "BAD_NETWORK")
    --tx.TopTipManager:showToast(t)
end

function functions.exportMethods(target)
    for k, v in pairs(functions) do
        if k ~= "exportMethods" then
            target[k] = v
        end
    end
end

function functions.splitString(str, sep)
    local t = {}
    sep = sep or '#'
    local pattern = string.format('([^%s]+)', sep)
    for line in string.gmatch(str, pattern) do
        table.insert(t, line)
    end
    return t
end

function functions.pushMsg(push_uid,title,msg,showIcon, type)
    local sid = appconfig.SID[string.upper(device.platform)]
    local md5key = push_uid .. sid .. "_openpokersec"
    local data = {}
    data.contentTitle = title or " "
    data.contentText = msg or " " 
    data.parameters = {}
    local s_picture = tx.userData.s_picture
    if string.len(s_picture) <= 5 then
    else
        if showIcon then
            data.parameters.pictureUrl = s_picture
        end
    end
    sa.HttpService.POST(
        {
            mod = "Push",
            act = "sendMsg",
            push_uid = push_uid,
            msg = json.encode(data),
            key = crypto.md5(md5key),
            type = type
        },
        function(data)
        end,
        function ()
        end)
end

function functions.setScaleBtn(btn,scale)
    -- if typeof
    btn:onButtonPressed(function(evt) 
            btn:setScale(scale or 0.9)
        end
        )
        :onButtonRelease(function(evt)
            btn:setScale(1)
        end
        )
end

function functions.getUserInfo(default)
    local userInfo = nil
    local vip = 0
    if default ~= true then
        if tx.userData.vipinfo and tx.userData.vipinfo.level then
            vip = tonumber(tx.userData.vipinfo.level) or 0
        end
        userInfo = {
            uid = tx.userData.uid,
            nick = tx.userData.nick,
            img = tx.userData.s_picture,
            sex = tx.userData.sex,
            -- level = tx.userData.level,
            -- lose = tx.userData.lose,
            -- win = tx.userData.win,
            money = tx.userData.money,
            -- exp = tx.userData.exp,
            -- sitemid = tx.userData.sitemid,
            giftId = tx.userData.user_gift,
            vip = vip,
            -- sid = appconfig.SID[string.upper(device.platform)],
            -- lid = tx.userData.lid or 1,
        }
    else
        userInfo = {
            uid = tx.userData.uid,
            nick = "",
            img = "",
            sex = "m",
            -- level = 3,
            -- lose = 0,
            -- win = 0,
            money = 10000,
            -- exp = 100,
            -- sitemid = 0,
            giftId = 0,
            vip = vip,
            -- sid = 5,
            -- lid = 1
        }
    end
    return userInfo 
end

return functions
