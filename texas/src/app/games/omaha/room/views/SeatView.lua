local HandCard = import(".HandCard")
local SeatView = import("app.games.texas.room.views.SeatView")
local OmahaSeatView = class("OmahaSeatView", SeatView)

function OmahaSeatView:ctor(ctx, seatId)
    OmahaSeatView.super.ctor(self, ctx, seatId)

    self.handCards_:removeFromParent()
    self.handCards_ = nil
    self.handCards_ = HandCard.new(0.7):addTo(self, 9, 9):hide()
end

function OmahaSeatView:setSeatData(seatData)
	OmahaSeatView.super.setSeatData(self, seatData)
	if not self.showedHandCardAnim_ then
        if seatData and seatData.isSelf then
            self.cardTypeBackground_:pos(126-5, -74)
            self.cardType_:pos(126-5, -74)
            self.cardTypeBGWidth_ = 220
            self.cardTypeBGHeight_ = 38
        else
            self.cardTypeBGWidth_ = 180
            self.cardTypeBGHeight_ = 30
        end
    end
end

return OmahaSeatView