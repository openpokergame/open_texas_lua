local T = require("openpoker.socket.PACKET_DATA_TYPE")
local P = clone(require("app.games.texas.net.PROTOCOL"))
local MATCH_PROTOCOL = P   -- 1 德州扑克普通玩法
P.GAMEID  = 2 -- 游戏ID 每个游戏不一样  
-- 覆盖之前的协议
P.SEND[P.CLI_LOGIN] = {
    ver = 1,
    fmt = {
        { name = "tid", type = T.UINT },   -- 用户ID
        { name = "uid", type = T.UINT },   -- 用户ID
        { name = "info" , type = T.STRING }, -- 用户信息，json格式
        { name = "mtkey" , type = T.STRING }, -- 密钥 用户mtkey
        { name = "matchid", type = T.STRING }, -- 比赛ID
    }
}

return MATCH_PROTOCOL