--[[
    全局上下文
]]

-- 临时hack, 在mac player上面运行时,把平台 伪装成windows以适配现有代码
if device.platform == 'mac' then
    device.platform = 'windows'
end

require("app.consts")
require("app.styles")


-- 通过元表特殊处理 特定key的读写访问
tx = setmetatable(tx or {}, {
    __index = function (t, k)
        if k == "userData" then
            return sa.DataProxy:getData(tx.dataKeys.USER_DATA)
        elseif k == "runningScene" then
            return cc.Director:getInstance():getRunningScene()
        elseif k == "userDefault" then
            return cc.UserDefault:getInstance()
        end
    end,
    -- 拦截特殊key,防止错误的用法
    __newindex = function (t, k, v)
        if k ~= "userData" and k ~= "runningScene" and k ~= "userDefault" then
            rawset(t, k, v)
        else
            print('error mk field set! ', k)
        end
    end
})

import(".util.functions").exportMethods(tx)
-- 破产数据
tx.getBroken = function()
    local userData = tx.userData
    if userData then
        local time = tx.userDefault:getStringForKey("BROKEN"..userData.uid, "")
        return tonumber(time)
    end
    return nil
end

tx.setBroken = function(time)
    local userData = tx.userData
    if userData then
        if time then
            tx.userDefault:setStringForKey("BROKEN"..userData.uid, time)
        else
            tx.userDefault:setStringForKey("BROKEN"..userData.uid, "")
        end
        tx.userDefault:flush()
    end
end

tx.getBindGuestStatus = function()
    local canBindGuest = tx.userData.canBindGuest
    local isGuestBindReward = tx.userData.isGuestBindReward
    if canBindGuest == 0 or (canBindGuest == 2 and isGuestBindReward == 1) then --功能未开启或者绑定且领奖，不显示按钮
        return 0
    elseif canBindGuest == 1 then --未绑定
        return 1
    elseif canBindGuest == 2 and isGuestBindReward == 0 then --绑定且未领奖
        return 2
    end
end

--检测自己是否是VIP
tx.checkIsVip = function()
    local userData = tx.userData
    if userData then
        if userData.vipinfo.level > 0 then
            return true
        end
    end

    return false
end

tx.checkIsVipExpression = function(id)
    local userData = tx.userData
    local expression = {}
    if userData then
        expression = userData.vipinfo.expression
    end

    local index = tonumber(string.sub(id, 1, 1))
    if index == 2 then
        return true, expression.dog or 1000
    elseif index == 4 then
        return true, expression.ant or 2000
    end

    return false, 0
end

--非VIP,发送VIP表情或者道具
tx.sendVipExpression = function (params)
    local id = params.id
    local price = params.price
    local sendType = params.sendType
    local expressType = 1
    if sendType == 1 then
        local index = tonumber(string.sub(id, 1, 1))
        if index == 2 then
            expressType = 3
        elseif index == 4 then
            expressType = 2
        end
    end

    sa.HttpService.POST(
        {
            mod = "Vip",
            act = "useExpression",
            type = expressType --2 开源表情 3 旺财表情
        },
        function (data)
            local ret = json.decode(data)
            local code = ret.code
            if code == -3 or code == -4 then
                tx.TopTipManager:showToast(sa.LangUtil.getText("VIP", "SEND_EXPRESSIONS_FAILED"))
            elseif code == 1 then
                tx.userData.money = tx.userData.money - price
                sa.EventCenter:dispatchEvent({name=tx.eventNames.USER_PROPERTY_CHANGE, data={money=(-price)}})
                if params.callback then
                    params.callback()
                end
            else
                tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "RECALL_FAILED_TIP"))
            end
        end,
        function ()
            tx.TopTipManager:showToast(sa.LangUtil.getText("FRIEND", "RECALL_FAILED_TIP"))
        end
    )
end

tx.checkIsEmail = function (str)
    if string.find(str, "^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+%.[a-zA-Z0-9_-]+$") then
        return true
    else
        return false
    end
end

tx.delNumberPreZero = function (str)
    local p1 = "^%d*$" --检测是否为数字
    local p2 = "0*(%d*)" --去掉前导0
    if string.find(str, p1) then
        local num = string.match(str, p2)
        if num == "" then --全部为0
            num = "0"
        end

        return tonumber(num)
    else
        return nil
    end
end

--获取玩牌活动玩牌局数
tx.getPlayPokerNum = function(blind, callback)
    local retryTimes = 3
    local loadPlayPokerNum

    loadPlayPokerNum = function()
        sa.HttpService.POST(
        {
            mod = "Activity",
            act = "getPlayPokerNum",
            blind = blind,
            gameid = tx.runningScene.gameId,
        },
        function(data)
            local callData = json.decode(data)
            if callData.code == 1 then
                tx.userData.playPokerConfig = callData.data
                tx.userData.playPokerNum = tonumber(callData.data.playNum)
                sa.EventCenter:dispatchEvent(tx.eventNames.UPDATE_PLAY_CARD_STATUS)
                if callback then
                    callback()
                end
            else
                retryTimes = retryTimes - 1
                if retryTimes > 0 then
                    loadPlayPokerNum()
                end
            end
        end,
        function()
            retryTimes = retryTimes - 1
            if retryTimes > 0 then
                loadPlayPokerNum()
            end
        end)
    end

    loadPlayPokerNum()
end

tx.getCountryNameById = function (countryId)
    local name = nil
    local countryList = sa.LangUtil.getText("USERINFO", "COUNTRY_LIST")
    for i, v in ipairs(countryList) do
        local startIndex = i*100
        for index, countryName in ipairs(v.list) do
            if countryId == (startIndex + index) then
                name = countryName
                break
            end
        end

        if name then
            break
        end
    end

    return name
end

function updatePlayPokerData()
    _G.playCardSchedule = nil
    tx.userData.playPokerNum = nil
    tx.userData.playPokerConfig.countDown = 0
    tx.userData.playPokerConfig.online = 0
    tx.userData.activityConfig = nil
end

tx.setPlayPokerCountDown = function(countDown)
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    if _G.playCardSchedule then
        scheduler.unscheduleGlobal(_G.playCardSchedule)
        _G.playCardSchedule = nil
    end

    if countDown > 0 then
        _G.playCardSchedule = scheduler.performWithDelayGlobal(function()
            scheduler.unscheduleGlobal(_G.playCardSchedule)
            updatePlayPokerData()
            sa.EventCenter:dispatchEvent(tx.eventNames.UPDATE_PLAY_CARD_STATUS)
        end, countDown)
    else
        updatePlayPokerData()
    end
end

-- 常量设置
tx.widthScale = display.width / RESOLUTION_WIDTH
tx.heightScale = display.height / RESOLUTION_HEIGHT
tx.bgScale = 1
if display.width / display.height > RESOLUTION_WIDTH / RESOLUTION_HEIGHT then
    tx.bgScale = display.width / RESOLUTION_WIDTH
else
    tx.bgScale = display.height / RESOLUTION_HEIGHT
end

-- 公共UI
tx.ui = import(".pokerUI.init")
tx.voiceRecordAnim = import(".pokerUI.VoiceRecordAnim")

-- Socket
tx.socket = {}
tx.socket.ProxySelector = import(".net.ProxySelector")
tx.socket.HallSocket = import(".net.HallSocket").new()    -- 普通游戏大厅
tx.socket.MatchSocket = import(".net.MatchSocket").new()  -- 比赛大厅
tx.matchProxy = import(".module.match.MatchProxy").new()  -- 比赛协议代理

tx.config = import(".config")

-- data keys
tx.dataKeys = import(".keys.DATA_KEYS")
tx.cookieKeys = import(".keys.COOKIE_KEYS")

--公共调度器
tx.schedulerPool = sa.SchedulerPool.new()

-- event names
tx.eventNames = import(".keys.EVENT_NAMES")

-- 声音管理类
tx.SoundManager = import(".manager.SoundManager").new()

-- 弹框管理类
tx.PopupManager = import(".manager.PopupManager").new()

-- 编辑框管理类
tx.EditBoxManager = import(".manager.EditBoxManager").new()

-- test util
tx.TestUtil = import(".util.TestUtil").new()

-- 顶部消息管理类
tx.TopTipManager = import(".manager.TopTipManager").new()

-- 广播走马灯
tx.HorseLamp = import(".manager.HorseLamp").new()

--桌子配置管理类
tx.TableConfigManager = import(".manager.TableConfigManager").new()

--每日任务事件上报类
tx.DailyTasksEventHandler = import(".module.dailytasks.DailyTasksEventHandler").new()

--支付引导管理
tx.PayGuideManager = import(".manager.PayGuideManager").new()

-- 过滤敏感字
-- tx.FilterKey = import(".util.FilterKeyWord").new();

-- 原生桥接
if device.platform == "android" then
    tx.Native = import(".util.LuaJavaBridge").new()
    tx.Push = import("app.module.login.plugins.UniversalPushApi").new()
    tx.ShareSDK = import("app.module.login.plugins.ShareSDKPluginAndroid").new()
    tx.VoiceSDK = import("app.plugins.VoicePluginAndroid").new()
    -- tx.AdvertSDK = import("app.plugins.AdPluginAndroid").new()
    -- tx.SimUtils = import(".util.SimUtils").new()
elseif device.platform == "ios" then
    tx.Native = import(".util.LuaOCBridge").new()
    tx.Push = import("app.module.login.plugins.UniversalPushApi").new()
    tx.ShareSDK = import("app.module.login.plugins.ShareSDKPluginIos").new()
    tx.VoiceSDK = import("app.plugins.VoicePluginIOS").new()
    -- tx.AdvertSDK = import("app.plugins.AdPluginIos").new()
else
    tx.Native = import(".util.LuaBridgeAdapter")
    tx.Facebook = import("app.module.login.plugins.FacebookPluginAdapter").new()
    tx.ShareSDK = import("app.module.login.plugins.ShareSDKPluginAndroid").new()
    tx.VoiceSDK = import("app.plugins.VoicePluginAndroid").new()
    -- tx.AdvertSDK = import("app.plugins.AdPluginAndroid").new()
    tx.LineSDK = import("app.plugins.LinePluginAndroid").new()
end

import(".init_ex")

-- 支持graph api
if tx.Facebook then
    import("app.module.login.plugins.FacebookGraphApi").exportMethods(tx.Facebook)
end

tx.OnOff = import("app.module.login.OnOff").new()

-- 管理加载文字提示信息
tx.EnterTipsManager = import("app.manager.EnterTipsManager").new();

-- 快捷储存自己头像不用在加载 自定义的时候
tx.fastSaveHead = function(url,filePath)
    if url and string.len(url) > 5 and filePath then
        local hash = crypto.md5(url)
        local newPath = device.writablePath .. "cache" .. device.directorySeparator .. "headpics" .. device.directorySeparator .. hash
        -- Android目录移动失败  /storage/emulated/0/temp_head_image1516854581628.jpg
        --==>/data/user/0/com.x3ge.openpoker/files/cache/headpics/57870b423838e33f5e19d6a8bd5a131c
        -- if device.platform == "android" then
            require("lfs")
            if io.exists(filePath) then
                local file = io.open(filePath, "rb")
                if file then
                    local content = file:read("*all")
                    io.close(file)
                    io.writefile(newPath, content, "w+b")
                end
            end
            os.remove(filePath)
        -- else
        --     os.rename(filePath, newPath)
        -- end
    end
end

-- 加载远程图像
tx.ImageLoader = sa.ImageLoader.new()
tx.ImageLoader.CACHE_TYPE_USER_HEAD_IMG = "CACHE_TYPE_USER_HEAD_IMG"
tx.ImageLoader:registerCacheType(tx.ImageLoader.CACHE_TYPE_USER_HEAD_IMG, {
    path = device.writablePath .. "cache" .. device.directorySeparator .. "headpics" .. device.directorySeparator,
    onCacheChanged = function(path)
        require("lfs")
        local fileDic = {}
        local fileIdx = {}
        local MAX_FILE_NUM = 500
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                local f = path.. device.directorySeparator ..file
                local attr = lfs.attributes(f)
                assert(type(attr) == "table")
                if attr.mode ~= "directory" then
                    fileDic[attr.access] = f
                    fileIdx[#fileIdx + 1] = attr.access
                end
            end
        end
        if #fileIdx > MAX_FILE_NUM then
            table.sort(fileIdx)
            repeat
                local file = fileDic[fileIdx[1]]
                print("remove file -> " .. file)
                os.remove(file)
                table.remove(fileIdx, 1)
            until #fileIdx <= MAX_FILE_NUM
        end
    end,
})
tx.ImageLoader.CACHE_TYPE_ACT = "CACHE_TYPE_ACT"
tx.ImageLoader:registerCacheType(tx.ImageLoader.CACHE_TYPE_ACT, {
    path = device.writablePath .. "cache" .. device.directorySeparator .. "act" .. device.directorySeparator,
    onCacheChanged = function(path) 
        require("lfs")
        local fileDic = {}
        local fileIdx = {}
        local MAX_FILE_NUM = 100
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                local f = path.. device.directorySeparator ..file
                local attr = lfs.attributes(f)
                assert(type(attr) == "table")
                if attr.mode ~= "directory" then
                    fileDic[attr.access] = f
                    fileIdx[#fileIdx + 1] = attr.access
                end
            end
        end
        if #fileIdx > MAX_FILE_NUM then
            table.sort(fileIdx)
            repeat
                local file = fileDic[fileIdx[1]]
                print("remove file -> " .. file)
                os.remove(file)
                table.remove(fileIdx, 1)
            until #fileIdx <= MAX_FILE_NUM
        end
    end,
})
tx.ImageLoader.CACHE_TYPE_GIFT = "CACHE_TYPE_GIFT"
tx.ImageLoader:registerCacheType(tx.ImageLoader.CACHE_TYPE_GIFT, {
    path = device.writablePath .. "cache" .. device.directorySeparator .. "gift" .. device.directorySeparator,
    onCacheChanged = function(path) 
        require("lfs")
        local fileDic = {}
        local fileIdx = {}
        local MAX_FILE_NUM = 400
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                local f = path.. device.directorySeparator ..file
                local attr = lfs.attributes(f)
                assert(type(attr) == "table")
                if attr.mode ~= "directory" then
                    fileDic[attr.access] = f
                    fileIdx[#fileIdx + 1] = attr.access
                end
            end
        end
        if #fileIdx > MAX_FILE_NUM then
            table.sort(fileIdx)
            repeat
                local file = fileDic[fileIdx[1]]
                print("remove file -> " .. file)
                os.remove(file)
                table.remove(fileIdx, 1)
            until #fileIdx <= MAX_FILE_NUM
        end
    end,
})
tx.ImageLoader.CACHE_TYPE_ANIMATION = "CACHE_TYPE_ANIMATION"
tx.ImageLoader:registerCacheType(tx.ImageLoader.CACHE_TYPE_ANIMATION, {
    path = device.writablePath .. "cache" .. device.directorySeparator .. "animation" .. device.directorySeparator,
    onCacheChanged = function(path) 
        require("lfs")
        local fileDic = {}
        local fileIdx = {}
        local MAX_FILE_NUM = 400
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                local ftype = 1
                local f = path .. device.directorySeparator .. file
                local ftex = f .. device.directorySeparator .. "skeleton.png"
                
                if io.exists(ftex) then
                    local attr = lfs.attributes(ftex)
                    assert(type(attr) == "table")
                    if attr.mode ~= "directory" then
                        fileDic[attr.access] = {f, file, ftype}
                        fileIdx[#fileIdx + 1] = attr.access
                    end
                end
            end
        end
        -- 
        if #fileIdx > MAX_FILE_NUM then
            table.sort(fileIdx)
            repeat
                local dic = fileDic[fileIdx[1]]
                local fp = dic[1]
                local filename = dic[2]
                local ftype = dic[3]
                local delfiles = {
                    fp .. device.directorySeparator .. "skeleton.png",
                    fp .. device.directorySeparator .. "skeleton.atlas",
                    fp .. device.directorySeparator .. "skeleton.json",
                }
                for _,v in ipairs(delfiles) do
                    -- if io.exists(v) then
                        os.remove(v)
                    -- end
                end
                -- sa.rmdir(fp)
                table.remove(fileIdx, 1)
            until #fileIdx <= MAX_FILE_NUM
        end
    end,
})
if device.platform == "android" then
    tx.ImageLoader.CACHE_TYPE_SHARE = "CACHE_TYPE_SHARE"
    local path_ = "/sdcard/OpenPoker" .. device.directorySeparator .. "share" .. device.directorySeparator
    if not sa.isDirExist(path_) then
        sa.mkdir(path_)
    end
    tx.ImageLoader:registerCacheType(tx.ImageLoader.CACHE_TYPE_SHARE, {
        path = path_,
        -- path = device.writablePath .. "cache" .. device.directorySeparator .. "share" .. device.directorySeparator,
        onCacheChanged = function(path) 
            require("lfs")
            local fileDic = {}
            local fileIdx = {}
            local MAX_FILE_NUM = 100
            for file in lfs.dir(path) do
                if file ~= "." and file ~= ".." then
                    local f = path.. device.directorySeparator ..file
                    local attr = lfs.attributes(f)
                    assert(type(attr) == "table")
                    if attr.mode ~= "directory" then
                        fileDic[attr.access] = f
                        fileIdx[#fileIdx + 1] = attr.access
                    end
                end
            end
            if #fileIdx > MAX_FILE_NUM then
                table.sort(fileIdx)
                repeat
                    local file = fileDic[fileIdx[1]]
                    print("remove file -> " .. file)
                    os.remove(file)
                    table.remove(fileIdx, 1)
                until #fileIdx <= MAX_FILE_NUM
            end
        end,
    })
end

--业务逻辑类
tx.Level = import(".module.level.LevelControl"):getInstance()

sa.ui.ScrollView.defaultScrollBarFactory =  function (direction)
    if direction == sa.ui.ScrollView.DIRECTION_VERTICAL then
        return display.newScale9Sprite("#common/ui_vertical_scroll_bar.png", 0, 0, cc.size(10, 54))
    elseif direction == sa.ui.ScrollView.DIRECTION_HORIZONTAL then
        return display.newScale9Sprite("#common/ui_horizontal_scroll_bar.png", 0, 0, cc.size(54, 10))
    end
end

-- 务必先设置下node的setContentSize(cc.size(100,100))
function display.printscreen(node, args,anchorX,anchorY)
    if not anchorX then
        anchorX = 0
    end
    if not anchorY then
        anchorY = 0
    end
    local sp = true
    local file = nil
    local filters = nil
    local filterParams = nil
    if args then
        if args.sprite ~= nil then sp = args.sprite end
        file = args.file
        filters = args.filters
        filterParams = args.filterParams
    end
    local size = node:getContentSize()
    local __oldAnchor = node:getAnchorPoint()
    local __oldPos = node:getPosition()
    node:setAnchorPoint(ccp(anchorX, anchorY))
    node:setPosition(0,0)
    local canvas = cc.RenderTexture:create(size.width,size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 0x88F0)

    canvas:begin()
    node:visit()
    canvas:endToLua()
    display.immediatelyRender()

    node:setAnchorPoint(__oldAnchor)
    node:setPosition(__oldPos)

    if sp then
        local texture = canvas:getSprite():getTexture()
        if filters then
            sp = display.newFilteredSprite(texture, filters, filterParams)
        else
            sp = display.newSprite(texture)
        end
        sp:flipY(true)
    end
    if file and device.platform ~= "mac" then
        canvas:saveToFile(file)
    end
    return sp, file
end

return tx
