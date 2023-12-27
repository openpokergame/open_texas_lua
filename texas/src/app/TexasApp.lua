require("config")
require("cocos.init")
require("framework.init")
require("openpoker.init")
require("app.init")

local TexasApp = class("TexasApp", cc.mvc.AppBase)
local TRANSITION_TIME = 0.6

function TexasApp:ctor()
    -- 游戏配置
    self.GAMES = {
        [1] = {
            name = "texas",
            halltex = {
                [1] = {"texas_hall_texture.plist", "texas_hall_texture.png"},
                [2] = {"texas_hall_city_texture.plist", "texas_hall_city_texture.png"},
            },
            roomtex = {
                [1] = {"commonroom_texture.plist", "commonroom_texture.png"},
                [2] = {"texas_room_texture.plist", "texas_room_texture.png"},
                [3] = {"dealers_texture.plist", "dealers_texture.png"},
                [4] = {"hddj_texture.plist","hddj_texture.png"},
            },
        },
        [2] = {
            name = "match",
            halltex = {
                [1] = {"match_hall_texture.plist", "match_hall_texture.png"},
            },
            roomtex = {
                [1] = {"commonroom_texture.plist", "commonroom_texture.png"},
                [2] = {"texas_room_texture.plist", "texas_room_texture.png"},
                [3] = {"dealers_texture.plist", "dealers_texture.png"},
                [4] = {"hddj_texture.plist","hddj_texture.png"},
                [5] = {"match_room_texture.plist", "match_room_texture.png"},
            },
        },
        [3] = {
            name = "omaha",
            halltex = {
                [1] = {"texas_hall_texture.plist", "texas_hall_texture.png"},
                [2] = {"texas_hall_city_texture.plist", "texas_hall_city_texture.png"},
            },
            roomtex = {
                [1] = {"commonroom_texture.plist", "commonroom_texture.png"},
                [2] = {"texas_room_texture.plist", "texas_room_texture.png"},
                [3] = {"dealers_texture.plist", "dealers_texture.png"},
                [4] = {"hddj_texture.plist","hddj_texture.png"},
            },
        },
        [4] = {
            name = "redblack",
            halltex = {
                
            },
            roomtex = {
                [1] = {"commonroom_texture.plist", "commonroom_texture.png"},
                [2] = {"redblack_room_texture.plist", "redblack_room_texture.png"},
                [3] = {"hddj_texture.plist","hddj_texture.png"},
            },
        },
        [5] = {
            name = "texasmust",
            halltex = {
                [1] = {"texas_hall_texture.plist", "texas_hall_texture.png"},
                [2] = {"texas_hall_city_texture.plist", "texas_hall_city_texture.png"},
            },
            roomtex = {
                [1] = {"commonroom_texture.plist", "commonroom_texture.png"},
                [2] = {"texas_room_texture.plist", "texas_room_texture.png"},
                [3] = {"dealers_texture.plist", "dealers_texture.png"},
                [4] = {"hddj_texture.plist","hddj_texture.png"},
            },
        },
    }
    -- 新手教程
    self.GAMES[0] = clone(self.GAMES[1])
    self.GAMES[0].name = "tutorial",
    
    TexasApp.super.ctor(self)
    tx.app = self
end

function TexasApp:init_analytics()
    -- init analytics
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:start("analytics.UmengAnalytics")
    end
    
    -- 改为真实的应用ID，第二参数为渠道号(可选)
    if device.platform == "android" then
        cc.analytics:doCommand {
            command = "startWithAppkey",
            args = {appKey = appconfig.UMENG_APPKEY_ANDROID, channelId=tx.Native:getChannelId()}
        }
    elseif device.platform == "ios" then
        cc.analytics:doCommand {
            command = "startWithAppkey",
            args = {appKey = appconfig.UMENG_APPKEY_IOS, channelId=tx.Native:getChannelId()}
        }
    end

    --调用SDK提供的游戏事件，让等级上报有效（友盟的坑，不使用提供的游戏事件，不会计算等级上报）
    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand {
            command = "startLevel",
            args = {level = 1}
        }

        cc.analytics:doCommand {
            command = "finishLevel",
            args = {level = 1}
        }

        cc.analytics:doCommand {
            command = "failLevel",
            args = {level = 2}
        }
    end
end

function TexasApp:run()
    self:init_analytics()

    if device.platform == "android" or device.platform == "ios" then
        cc.analytics:doCommand {
            command = "event",
            args = {eventId = "start_game", label = "start_game"}   
        }
    end
    self.isChangingScene_ = true
    self:enterScene("HallScene")
    self.isChangingScene_ = nil
end

function TexasApp:enterMainHall(args)
    if self.isChangingScene_ then return end
    self.isChangingScene_ = true
    tx.socket.HallSocket:pause()
    tx.socket.MatchSocket:pause()
    display.addSpriteFrames("hall_texture.plist", "hall_texture.png", function()        
        self:enterScene("HallScene", args, "FADE", TRANSITION_TIME)
        tx.SoundManager:playSound(tx.SoundManager.REPLACE_SCENE)
        self.isChangingScene_ = nil
    end)
end

function TexasApp:enterRoomScene(args)
    if self.isChangingScene_ then return end
    self.isChangingScene_ = true
    tx.socket.HallSocket:pause()
    tx.socket.MatchSocket:pause()
    self:enterScene("RoomScene", args, "FADE", TRANSITION_TIME)
    tx.SoundManager:playSound(tx.SoundManager.REPLACE_SCENE)
    self.isChangingScene_ = nil
end

function TexasApp:enterGameRoom(gameId,args)
    if self.isChangingScene_ then return end
    self.isChangingScene_ = true
    tx.socket.HallSocket:pause()
    tx.socket.MatchSocket:pause()
    local loaderFun_ = nil
    local loaderFun_ = function(loadList,callBack)
        if not loadList or #loadList<1 then callBack() end
        local index = 0
        for k,v in pairs(loadList) do
            display.addSpriteFrames(v[1], v[2], function()
                index = index+1
                if index>=#loadList then
                    callBack()
                end
            end)
        end
    end

    local loadList = app.GAMES[gameId].roomtex
    local gameName = app.GAMES[gameId].name
    loaderFun_(loadList,function()
        local sceneClass = require("app.games."..gameName..".RoomScene")
        local scene = sceneClass.new(unpack(checktable(args)))
        display.replaceScene(scene, "FADE", TRANSITION_TIME, more)
        tx.SoundManager:playSound(tx.SoundManager.REPLACE_SCENE)
        self.isChangingScene_ = nil
    end)
    loaderFun_ = nil
end

--进入红黑场房间
function TexasApp:enterRedblcakRoom()
    local level = tx.userData.hongheiLevelLimit
    local hallScene = display.getRunningScene()
    if tx.userData.level >= level and hallScene.requestRoom then
        hallScene:requestRoom({gameId=tx.config.REDBLACK_GAME_ID, level=tx.config.REDBLACK_ROOM_LEVEL})
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_LIMIT_LEVEL", level, level))
    end
end

-- function TexasApp:enterGameHall(gameId,args)
--     if self.isChangingScene_ then return end
--     self.isChangingScene_ = true
--     tx.socket.HallSocket:pause()
--     tx.socket.MatchSocket:pause()
--     local loaderFun_ = nil
--     local loaderFun_ = function(loadList,callBack)
--         if not loadList or #loadList<1 then callBack() end
--         local index = 0
--         for k,v in pairs(loadList) do
--             display.addSpriteFrames(v[1], v[2], function()
--                 index = index+1
--                 if index>=#loadList then
--                     callBack()
--                 end
--             end)
--         end
--     end

--     local loadList = app.GAMES[gameId].halltex
--     local gameName = app.GAMES[gameId].name
--     loaderFun_(loadList,function()
--         local sceneClass = require("app.games."..gameName..".HallScene")
--         local scene = sceneClass.new(unpack(checktable(args)))
--         display.replaceScene(scene, "FADE", TRANSITION_TIME, more)
--         tx.SoundManager:playSound(tx.SoundManager.REPLACE_SCENE)
--         self.isChangingScene_ = nil
--     end)
--     loaderFun_ = nil
-- end

function TexasApp:enterGameHall(gameId,args)
    if self.isChangingScene_ then return end
    self.isChangingScene_ = true
    tx.socket.HallSocket:pause()
    tx.socket.MatchSocket:pause()
    local loaderFun_ = nil
    local loaderFun_ = function(loadList,callBack)
        if not loadList or #loadList<1 then callBack() end
        local index = 0
        for k,v in pairs(loadList) do
            display.addSpriteFrames(v[1], v[2], function()
                index = index+1
                if index>=#loadList then
                    callBack()
                end
            end)
        end
    end

    -- 1:德州 2:比赛场 3:奥马哈 4:红黑 5:德州必下场
    local loadList = app.GAMES[gameId].halltex
    local gameName = app.GAMES[gameId].name
    loaderFun_(loadList,function()
        local sceneClass = require("app.module.choosegame.ChooseGameScene")
        if gameId == 2 then
            sceneClass = require("app.games."..gameName..".HallScene")
        end

        if gameId == 1 then
            args = {1}
        elseif gameId == 3 then
            args = {2}
        elseif gameId == 5 then
            args = {3}
        end
        local scene = sceneClass.new(unpack(checktable(args)))
        display.replaceScene(scene, "FADE", TRANSITION_TIME, more)
        tx.SoundManager:playSound(tx.SoundManager.REPLACE_SCENE)
        self.isChangingScene_ = nil
    end)
    loaderFun_ = nil
end

--进入奥马哈选场界面
function TexasApp:enterOmahaHall()
    local level = tx.userData.aomahLevelLimit
    if tx.userData.level >= level then
        self:enterGameHall(3)
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_LIMIT_LEVEL", level, level))
    end
end

--进入德州必下选场界面
function TexasApp:enterTexasMustHall()
    local level = tx.userData.allinLevelLimit
    if tx.userData.level >= level then
        app:enterGameHall(5)
    else
        tx.TopTipManager:showToast(sa.LangUtil.getText("HALL", "CHOOSE_ROOM_LIMIT_LEVEL", level, level))
    end
end

-- 统计停留在游戏不到30秒
local function umeng_check_enter_background_too_short()
    local g = global_statistics_for_umeng
    local t1 = g.enter_foreground_time or g.run_main_timestamp
    local delta = math.abs(os.difftime(os.time(), t1))
    if delta <= 30 then
        cc.analytics:doCommand {
            command = 'eventCustom',
            args = {
                eventId    = 'leave_in_short_time',
                attributes = 'leave_time,' .. delta,
                counter    = 1,
            },
        }
    end
end

-- 统计 loading界面关闭应用的情况
local function umeng_check_close_view()
    local g = global_statistics_for_umeng
    if g.umeng_view == g.Views.login then
        if g.first_enter_login_not_checked then
            g.first_enter_login_not_checked = false

            local nt = network.getInternetConnectionStatus()
            local ns = ({ [0] = 'NA', [1] = 'Wifi', [2] = 'WWAN' })[nt] or 'Unknown'
            local s1 = 'network_type,' .. ns

            -- 友盟限制: 每个事件最多10个参数,每个参数最多1000个取值
            local dt = math.abs(os.difftime(os.time(), g.run_main_timestamp))
            if dt > 999 then dt = 999 end
            local s2 = '|quit_time,' .. dt

            cc.analytics:doCommand {
                command = 'eventCustom',
                args = {
                    eventId    = 'quit_at_login_scene',
                    attributes = s1 .. s2,
                    counter    = 2,
                },
            }
        end
    end
end

function TexasApp:onEnterBackground()
    local curScene = display.getRunningScene()
    if curScene and curScene.onEnterBackground then
        curScene:onEnterBackground()
    end

    if device.platform == "android" or device.platform == "ios" then
        umeng_check_enter_background_too_short()
        umeng_check_close_view()
    end

    TexasApp.super.onEnterBackground(self)
    sa.EventCenter:dispatchEvent(tx.eventNames.APP_ENTER_BACKGROUND)
    audio.stopMusic(true)
end

function TexasApp:onEnterForeground()
    -- IOS这里获取不到数据，因为是先回到引擎再处理推送数据 返回引擎时候获取不到数据
    -- 推送弹窗
    local startType = -1
    if tx and tx.Native and tx.Native.getStartType then
        startType = tx.Native:getStartType()
    end
    local curScene = display.getRunningScene()
    if curScene and curScene.onEnterForeground then
        if device.platform == "android" then -- 在玩别的APP 获取不到数据
            curScene:performWithDelay(function()
                curScene:onEnterForeground(startType)
            end,0.2)
        else
            curScene:onEnterForeground(startType)
        end
    end

    TexasApp.super.onEnterForeground(self)
    sa.EventCenter:dispatchEvent(tx.eventNames.APP_ENTER_FOREGROUND)
    if device.platform == "android" or device.platform == "ios" then
        -- 记录下返回的时间
        global_statistics_for_umeng.enter_foreground_time = os.time()
    end

    self:updateUserMoney_()
end

function TexasApp:updateUserMoney_()
    if tx.userData then
        sa.HttpService.POST({
            mod = "User",
            act = "checkPlayer",
            cuid = tx.userData.uid
        },
        function(data)
            local retData = json.decode(data)
            if retData and retData.code == 1 then
                if retData.info and retData.info.money then -- 个人获取同步资产
                    tx.userData.money = tonumber(retData.info.money) or tx.userData.money
                    tx.userData.diamonds = tonumber(retData.info.diamonds) or tx.userData.diamonds
                end
            end
        end,
        function()
        end
        )
    end
end

function TexasApp:loadOnOffData()
    tx.OnOff:load(function()
        sa.EventCenter:dispatchEvent({name="OnOff_Load"})
    end)
end

-- 文字提示
function TexasApp:tip(itype, val, px, py, needPlay)
    local num = tonumber(val) or 1
    if num == 0 then
        return
    end

    if self.isPlaying and needPlay~=true then
        if not self.catchTipData_ then self.catchTipData_ = {} end
        table.insert(self.catchTipData_,{itype, val, px, py})
        return
    end
    local runScene = display.getRunningScene()
    if runScene == nil then
        self.isPlaying = nil
        self.catchTipData_ = nil
        return
    end

    px = px or 0
    py = py or 0

    local sign
    local offx, offy = 0, 0
    local maxdw = 50
    local info = {}
    info.font = "fonts/xiaohuang.fnt"

    if itype == 1 then -- 筹码
        info.icon = "#common/common_chip_icon.png"
        offx = 2
    elseif itype == 2 then
        info.icon = "#common/common_diamond_icon.png"
        info.font = "fonts/xiaolv.fnt"
        offy = 3
    elseif itype == 3 then --道具
        info.icon = "#common/prop_hddj.png"
        offx = -5
        offy = -5
        maxdw = 70
    elseif itype == 5 then --大喇叭
        info.icon = "#common/prop_laba.png"
        offx = -5
        offy = -5
        maxdw = 70
    else
        self.isPlaying = nil
        self:checkNextTip_()
        return 
    end

    if num > 0 then
        sign = " + "
    else
        sign = " - "
        info.font = "fonts/xiaohong.fnt"
    end

    info.txt = sign .. tostring(sa.formatBigNumber(math.abs(num)))

    local zorder = 9999 + itype
    local node = display.newNode():pos(px, py):addTo(runScene, zorder)
    local label = ui.newBMFontLabel({text = info.txt, font = info.font}):addTo(node)

    local icon = display.newSprite(info.icon):addTo(node)
    local isz = icon:getContentSize()
    local lblSz = label:getContentSize()
    
    local xxscale, yyscale = maxdw/isz.width, maxdw/isz.height
    local s
    if xxscale > yyscale then
        s = xxscale
    else
        s = yyscale
    end

    icon:setScale(s)
    local x = -(isz.width*s*0.5 + lblSz.width*0.5)
    icon:align(display.LEFT_CENTER, x, 0)
    label:align(display.LEFT_CENTER, x + isz.width*s + offx, offy)

    local nextMove = transition.sequence({
            cc.DelayTime:create(0.8),
            cc.CallFunc:create(function() 
                self.isPlaying = nil
                self:checkNextTip_()
            end),
        })
    local move = cc.Spawn:create(
            cc.FadeIn:create(0.5),
            cc.MoveBy:create(0.5, cc.p(0, 90))
        )

    local spawn = cc.Spawn:create(move, nextMove)
    local sequence = transition.sequence({
        spawn,
        cc.DelayTime:create(0.2),
        cc.FadeOut:create(0.3),
        cc.CallFunc:create(function() 
            node:removeSelf()
        end),
    })

    self.isPlaying = true
    node:setCascadeOpacityEnabled(true)
    node:opacity(0)
    node:runAction(sequence)
end

function TexasApp:checkNextTip_()
    if self.catchTipData_ and #self.catchTipData_>0 then
        local data = table.remove(self.catchTipData_,1)
        self:tip(unpack(checktable(data)))
    end
end

--金币下落动画
function TexasApp:playChipsDropAnimation()
    tx.SoundManager:playSound(tx.SoundManager.CHIP_DROP)

    local scene = display.getRunningScene()
    local x, y = display.cx, display.cy
    local max_num = 16
    local index_1 = 0
    local emitter_1 = cc.ParticleSystemQuad:create("particle/ZCJB1.plist")
        :pos(x, y + 400)
        :addTo(scene, 9999)
    emitter_1:setAutoRemoveOnFinish(true)
    emitter_1:schedule(function()
        local id = index_1 % max_num
        local img = "particle/P" .. id .. ".png"
        index_1 = index_1 + 1
        emitter_1:setTexture(cc.Director:getInstance():getTextureCache():addImage(img))
    end, 0.01)

    tx.schedulerPool:delayCall(function()
        local emitter_2 = cc.ParticleSystemQuad:create("particle/ZCJB2.plist")
            :pos(x, y - 400)
            :addTo(scene, 9999)
        emitter_2:setAutoRemoveOnFinish(true)

        local index_2 = 0
        emitter_2:schedule(function()
            local id = index_2 % max_num
            local img = "particle/P" .. id .. ".png"
            index_2 = index_2 + 1
            emitter_2:setTexture(cc.Director:getInstance():getTextureCache():addImage(img))
        end, 0.01)
    end, 0.5)
end

return TexasApp
