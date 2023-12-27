local CardType = class("CardType")

function CardType:ctor(type, point)  --  point 已没用
    self.type_ = type
    self.point_ = point
end

function CardType:getCardTypeValue()
    return self.type_
end

function CardType:getCardPointValue()
    return self.point_
end

function CardType:getLabel()
    return sa.LangUtil.getText("COMMON", "CARD_TYPE")[self.type_]
end

function CardType:compareTo(cardType)
    return CardType.comparetorAsc_(self, cardType)
end

function CardType.comparetor(asc)
    if not asc then
        return CardType.comparetorDesc_
    else
        return CardType.comparetorDesc_
    end
end

function CardType:isLargeCardType()
    return self.type_ == consts.CARD_TYPE.ROYAL or self.type_ == consts.CARD_TYPE.STRAIGHT_FLUSH or self.type_ == consts.CARD_TYPE.THREE_KIND
end

function CardType:isGoodType()
    return self.type_ >= consts.CARD_TYPE.STRAIGHT and self.type_ <= consts.CARD_TYPE.THREE_KIND
end

function CardType:isBadType()
    -- return self.type_ == consts.CARD_TYPE.POINT_CARD
    return self.type_ <= 4
end

function CardType.comparetorAsc_(cardType1, cardType2)
    if cardType1.type_ == consts.CARD_TYPE.POINT_CARD and cardType1.type_ == cardType2.type_ then
        return cardType1.point_ - cardType2.point_
    else
        return cardType1.type_ - cardType2.type_
    end
end

function CardType.comparetorDesc_(cardType1, cardType2)
    if cardType1.type_ == consts.CARD_TYPE.POINT_CARD and cardType1.type_ == cardType2.type_ then
        return cardType2.point_ - cardType1.point_
    else
        return cardType2.type_ - cardType1.type_
    end
end

return CardType