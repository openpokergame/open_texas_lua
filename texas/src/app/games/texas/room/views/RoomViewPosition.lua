local RoomViewPosition = {}
local P = RoomViewPosition

local paddingLeft = (display.width - 1130) * 0.5 -- 1130为设计布局宽度(去掉阴影)  无论何种都是居中的
local paddingBottom = (display.height - 514) * 0.534965 --下半部分占比  头部为 800 = 153 + 514 + 133
-- 座位位置
P.SeatPosition = {
    cc.p(904 + paddingLeft, 547 + paddingBottom), 
    cc.p(1107 + paddingLeft, 420 + paddingBottom), 
    cc.p(1107 + paddingLeft, 156  + paddingBottom), 
    cc.p(904 + paddingLeft, 37  + paddingBottom), 
    cc.p(565 + paddingLeft, 37  + paddingBottom), 
    cc.p(226  + paddingLeft, 37 + paddingBottom), 
    cc.p(23  + paddingLeft, 156 + paddingBottom), 
    cc.p(23 + paddingLeft, 420 + paddingBottom), 
    cc.p(226 + paddingLeft, 547 + paddingBottom),
    cc.p(565 + paddingLeft, 530 + paddingBottom),
}
P.StandardSeatPosition = P.SeatPosition

-- 桌子的位置
P.TablePosition = cc.p(565 + paddingLeft, 514 + paddingBottom)
P.StandardTablePosition = P.TablePosition

-- 下注位置
P.BetPosition = {
    cc.p(912 + paddingLeft, 425 + paddingBottom), 
    cc.p(978 + paddingLeft, 344 + paddingBottom), 
    cc.p(978 + paddingLeft, 229  + paddingBottom), 
    cc.p(912 + paddingLeft, 159  + paddingBottom), 
    cc.p(573 + paddingLeft, 159  + paddingBottom),
    cc.p(234 + paddingLeft, 159 + paddingBottom), 
    cc.p(152 + paddingLeft, 229 + paddingBottom), 
    cc.p(152 + paddingLeft, 344 + paddingBottom), 
    cc.p(234 + paddingLeft, 425 + paddingBottom),
    cc.p(698 + paddingLeft, 159 + paddingBottom),  -- 自己座位下注位置
}
P.StandardBetPosition = P.BetPosition

-- 奖池位置
P.PotPosition = {
    cc.p(565 + paddingLeft, 398 + paddingBottom), 
    cc.p(455 + paddingLeft, 398 + paddingBottom), 
    cc.p(675 + paddingLeft, 398  + paddingBottom), 
    cc.p(345 + paddingLeft, 398  + paddingBottom), 
    cc.p(785 + paddingLeft, 398  + paddingBottom), 
    cc.p(510  + paddingLeft, 434 + paddingBottom), 
    cc.p(620  + paddingLeft, 434 + paddingBottom), 
    cc.p(400 + paddingLeft, 434 + paddingBottom), 
    cc.p(730 + paddingLeft, 434 + paddingBottom),
}
P.StandardPotPosition = P.PotPosition

-- 公共牌的位置
P.PubCardPosition = {
    cc.p(317 + paddingLeft, 291 + paddingBottom), 
    cc.p(441 + paddingLeft, 291 + paddingBottom), 
    cc.p(565 + paddingLeft, 291 + paddingBottom), 
    cc.p(689 + paddingLeft, 291 + paddingBottom), 
    cc.p(813 + paddingLeft, 291 + paddingBottom), 
}
P.StandardPubCardPosition = P.PubCardPosition

-- 发牌位置（10号位为荷官发牌位置）
P.DealCardPosition = {
    cc.p(966 + paddingLeft, 516 + paddingBottom), 
    cc.p(1169 + paddingLeft, 391 + paddingBottom), 
    cc.p(1169 + paddingLeft, 127 + paddingBottom), 
    cc.p(966 + paddingLeft, 8 + paddingBottom), 
    cc.p(627 + paddingLeft, 8 + paddingBottom), 
    cc.p(164 + paddingLeft, 8 + paddingBottom), 
    cc.p(-39 + paddingLeft, 127 + paddingBottom), 
    cc.p(-39 + paddingLeft, 391 + paddingBottom), 
    cc.p(164 + paddingLeft, 516 + paddingBottom), 
    cc.p(display.cx               , P.SeatPosition[10].y - 100)
}
P.StandardDealCardPosition = P.DealCardPosition

-- 亮牌位置
P.ShowCardPosition = {
    cc.p(904 + paddingLeft - 90, 438 + paddingBottom + 140),
    cc.p(1020 + paddingLeft + 30, 360 + paddingBottom + 110),
    cc.p(1020 + paddingLeft + 30, 232  + paddingBottom + 80),
    cc.p(904 + paddingLeft, 151  + paddingBottom + 10), 
    cc.p(565 + paddingLeft, 151  + paddingBottom + 10), 
    cc.p(226 + paddingLeft, 151 + paddingBottom + 10), 
    cc.p(110 + paddingLeft - 35, 232 + paddingBottom + 80),
    cc.p(110 + paddingLeft - 35, 360 + paddingBottom + 110), 
    cc.p(226 + paddingLeft + 90, 438 + paddingBottom + 140),
    cc.p(753 + paddingLeft, 216  + paddingBottom), 
    -- 旋转角度
    0,--180,
    0,---90,
    0,---90,
    0,
    0,
    0,
    0,--90,
    0,--90,
    0,--180,
    15,
    -- 缩放  自己的小一点吧
    0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.6
}
P.StandardShowCardPosition = P.ShowCardPosition

-- dealer位置
P.DealerPosition = {
    cc.p(822 + paddingLeft, 454 + paddingBottom), 
    cc.p(1057 + paddingLeft, 310 + paddingBottom), 
    cc.p(1057 + paddingLeft, 266  + paddingBottom), 
    cc.p(816 + paddingLeft, 114 + paddingBottom), 
    cc.p(477 + paddingLeft, 114 + paddingBottom), 
    cc.p(314  + paddingLeft, 114 + paddingBottom), 
    cc.p(73  + paddingLeft, 266 + paddingBottom), 
    cc.p(73 + paddingLeft, 310 + paddingBottom), 
    cc.p(308 + paddingLeft, 454 + paddingBottom),
    cc.p(477 + paddingLeft, 454 + paddingBottom),
}
P.StandardDealerPosition = P.DealerPosition

-- 自己坐标的偏移 变化
P.SelfOffsetX = -48
P.SelfOffsetY = 22
P.GiftX = 65
P.SelfGiftOffsetX = -65
P.SelfScale = 1.29
P.SelfDealerOffsetX = -85

P.StandardSelfOffsetX = P.SelfOffsetX
P.StandardSelfOffsetY = P.SelfOffsetY
P.StandardGiftX = P.GiftX
P.StandardSelfGiftOffsetX = P.SelfGiftOffsetX
P.StandardSelfScale = P.SelfScale
P.StandardSelfDealerOffsetX = P.SelfDealerOffsetX
-- 设置标准配置  德州  运行时设置
local setStandardConfig=function()
    P.SeatPosition = P.StandardSeatPosition
    P.TablePosition = P.StandardTablePosition
    P.BetPosition = P.StandardBetPosition
    P.PotPosition = P.StandardPotPosition
    P.PubCardPosition = P.StandardPubCardPosition
    P.DealCardPosition = P.StandardDealCardPosition
    P.ShowCardPosition = P.StandardShowCardPosition
    P.DealerPosition = P.StandardDealerPosition

    P.SelfOffsetX = P.StandardSelfOffsetX
    P.SelfOffsetY = P.StandardSelfOffsetY 
    P.GiftX = P.StandardGiftX
    P.SelfGiftOffsetX = P.StandardSelfGiftOffsetX
    P.SelfScale = P.StandardSelfScale
    P.SelfDealerOffsetX = P.StandardSelfDealerOffsetX
end
-- 德州
P.setTexas = function()
    setStandardConfig()
end
-- 奥马哈
P.setOmaha = function()
    setStandardConfig()
    if not P.OmahaBetPosition then
        P.OmahaSelfOffsetX = P.StandardSelfOffsetX - 33
        P.OmahaSelfGiftOffsetX = P.StandardSelfGiftOffsetX - 33
        P.OmahaSelfDealerOffsetX = P.StandardSelfDealerOffsetX - 20
        P.OmahaBetPosition = clone(P.StandardBetPosition)
        P.OmahaBetPosition[10].x = P.OmahaBetPosition[10].x - 7
    end
    P.BetPosition = P.OmahaBetPosition
    P.SelfOffsetX = P.OmahaSelfOffsetX
    P.SelfGiftOffsetX = P.OmahaSelfGiftOffsetX
    P.SelfDealerOffsetX = P.OmahaSelfDealerOffsetX
end
-- 三公
P.setNineke = function()
    P.setOmaha()
    if not P.NinekePotPosition then
        P.NinekePotPosition = clone(P.StandardPotPosition)
        for k,v in pairs(P.NinekePotPosition) do
            v.y = v.y - 110
        end
    end
    P.PotPosition = P.NinekePotPosition
end
-- 博定
P.setPokdeng = function(bankerId)
    P.setNineke()
    bankerId = bankerId or 101
    if not P.PokdengSeatPosition then
        P.PokdengSeatPosition = clone(P.StandardSeatPosition)
        P.PokdengBetPosition = clone(P.StandardBetPosition)
        P.PokdengDealCardPosition = clone(P.StandardDealCardPosition)
        P.PokdengShowCardPosition = clone(P.StandardShowCardPosition)
        P.PokdengDealerPosition = clone(P.StandardDealerPosition)
        for i=4,6,1 do
            P.PokdengSeatPosition[i].y = P.PokdengSeatPosition[i].y + 10
            P.PokdengBetPosition[i].y = P.PokdengBetPosition[i].y + 10
            P.PokdengDealCardPosition[i].y = P.PokdengDealCardPosition[i].y + 10
            P.PokdengShowCardPosition[i].y = P.PokdengShowCardPosition[i].y + 10
            P.PokdengDealerPosition[i].y = P.PokdengDealerPosition[i].y + 10
        end
        P.PokdengBetPosition[10].y = P.PokdengBetPosition[10].y + 10  -- 自己下注也得加
        -- 庄家位置坐标处理  --客户端座位默认会 ＋ 1
        P.PokdengSeatPosition[bankerId],P.PokdengSeatPosition[bankerId+1] = P.PokdengSeatPosition[10],P.PokdengSeatPosition[10]
        P.PokdengBetPosition[bankerId],P.PokdengBetPosition[bankerId+1] = P.PokdengBetPosition[10],P.PokdengBetPosition[10]
        P.PokdengDealCardPosition[bankerId],P.PokdengDealCardPosition[bankerId+1] = P.PokdengDealCardPosition[10],P.PokdengDealCardPosition[10]
        P.PokdengShowCardPosition[bankerId],P.PokdengShowCardPosition[bankerId+1] = P.PokdengShowCardPosition[10],P.PokdengShowCardPosition[10]
        P.PokdengDealerPosition[bankerId],P.PokdengDealerPosition[bankerId+1] = P.PokdengDealerPosition[10],P.PokdengDealerPosition[10]
    end
    P.SeatPosition = P.PokdengSeatPosition
    P.BetPosition = P.PokdengBetPosition
    P.DealCardPosition = P.PokdengDealCardPosition
    P.ShowCardPosition = P.PokdengShowCardPosition
    P.DealerPosition = P.PokdengDealerPosition
end

return RoomViewPosition