local RoomViewPosition = {}
local P = RoomViewPosition

-- 公共牌的位置
local pubCardX, pubCardY = display.cx, display.height - 145
local pubCardDir = 90
P.PubCardPosition = {
    cc.p(pubCardX - pubCardDir*2, pubCardY), 
    cc.p(pubCardX - pubCardDir, pubCardY), 
    cc.p(pubCardX, pubCardY), 
    cc.p(pubCardX + pubCardDir, pubCardY), 
    cc.p(pubCardX + pubCardDir*2, pubCardY), 
}

--押注位置
local betTypeX, betTypeY = display.cx, display.height*0.743
P.BET_TYPE_X = betTypeX
P.BET_TYPE_Y = betTypeY
P.BetTypePosition = {
    cc.p(betTypeX - 325, betTypeY - 74),  --银像赢
    cc.p(betTypeX, betTypeY - 74),        --平局
    cc.p(betTypeX + 325, betTypeY - 74),  --金像赢
    cc.p(betTypeX - 406, betTypeY - 236), --同花
    cc.p(betTypeX - 244, betTypeY - 236), --连牌
    cc.p(betTypeX - 83, betTypeY - 236),  --对子
    cc.p(betTypeX - 366, betTypeY - 356), --同花连牌
    cc.p(betTypeX - 124, betTypeY - 356), --对A
    cc.p(betTypeX + 83, betTypeY - 236),  --高牌/一对
    cc.p(betTypeX + 244, betTypeY - 236), --两对
    cc.p(betTypeX + 406, betTypeY - 236), --三条/顺子/同花
    cc.p(betTypeX + 124, betTypeY - 356), --葫芦
    cc.p(betTypeX + 366, betTypeY - 356), --金刚/同花顺/皇家
}

--牌局记录点y坐标
P.HISTORY_Y = betTypeY - 440

--押注标题位置
P.BetTypeTitlePosition = {
    cc.p(betTypeX - 245, betTypeY - 165),  --任一手牌
    cc.p(betTypeX + 245, betTypeY - 165),  --获胜牌型
}

--押注区域
P.BetTypeArea = {
    cc.size(318, 138),
    cc.size(324, 138),
    cc.size(318, 138),
    cc.size(156, 114),
    cc.size(158, 114),
    cc.size(156, 114),
    cc.size(238, 114),
    cc.size(238, 114),
    cc.size(156, 114),
    cc.size(158, 114),
    cc.size(156, 114),
    cc.size(238, 114),
    cc.size(238, 114)
}

-- 座位位置
local leftSeatX = 72
local rightSeatX = display.width - leftSeatX
local seatY = betTypeY + 28
local seatDir = 140
P.SeatPosition = {
    cc.p(leftSeatX, seatY), 
    cc.p(leftSeatX, seatY - seatDir), 
    cc.p(leftSeatX, seatY - seatDir*2), 
    cc.p(leftSeatX, seatY - seatDir*3), 
    cc.p(rightSeatX, seatY), 
    cc.p(rightSeatX, seatY - seatDir), 
    cc.p(rightSeatX, seatY - seatDir*2), 
    cc.p(rightSeatX, seatY - seatDir*3),
    cc.p(65, 65),--自己
    cc.p(148, display.height - 58),--其他看见的玩家
}

-- 发牌位置(3号位为发牌位置)
local dealCardY = display.height - 110
P.DealCardPosition = {
    cc.p(295, dealCardY), 
    cc.p(display.width - 295, dealCardY), 
    cc.p(display.cx, display.height + 60), 
}

return RoomViewPosition