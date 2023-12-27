local NetworkSprite = class("NetworkSprite", function()
    return display.newSprite()
end)

function NetworkSprite:ctor(callback)
    self.this_ = self
    self:setNodeEventEnabled(true)
    self.imageLoaderId_ = tx.ImageLoader:nextLoaderId()
    self.callback_ = callback
end

function NetworkSprite:loadAndCacheImage(url, cacheType)
    tx.ImageLoader:cancelJobByLoaderId(self.imageLoaderId_)

    tx.ImageLoader:loadAndCacheImage(
        self.imageLoaderId_, 
        url, 
        handler(self, self.onImageLoadComplete_),
        cacheType
    )

    return self
end

function NetworkSprite:onImageLoadComplete_(success, sprite, loadId)
    if not self.this_ then return; end
    if success then
        local tex = sprite:getTexture()
        local texSize = tex:getContentSize()
        self:setTexture(tex)
        self:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))

        if self.callback_ then
            self.callback_()
        end
    end
end

function NetworkSprite:onCleanup()
    tx.ImageLoader:cancelJobByLoaderId(self.imageLoaderId_)
end

return NetworkSprite