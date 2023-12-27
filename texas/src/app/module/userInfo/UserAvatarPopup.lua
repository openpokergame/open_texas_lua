require("lfs")
local SimpleAvatar = import("openpoker.ui.SimpleAvatar")
local UserAvatarPopup = class("UserAvatarPopup", tx.ui.Panel);

local IMG_WIDTH = 760;
local IMG_HEIGHT = 760;
local OFFSET_SIZE = 10

function UserAvatarPopup:ctor()
	UserAvatarPopup.super.ctor(self, {display.width, display.height})
	self:setNodeEventEnabled(true);
	self.background_:setOpacity(0.1);
    self.background_:setTouchEnabled(false)
    self.background_:setTouchSwallowEnabled(false)

    self.avatarBg_ = display.newScale9Sprite("#common/common_progress_bg.png", 0, 0, cc.size(IMG_WIDTH+OFFSET_SIZE, IMG_HEIGHT+OFFSET_SIZE))
        :addTo(self)
    self.avatarIcon_ = SimpleAvatar.new({
            shapeImg = "#common/modal_texture.png",
            frameImg = "#common/transparent.png",
            scale9 = 1,
            offsetSize = OFFSET_SIZE,
            size = IMG_WIDTH,
            loadCallBack = handler(self, self.imageLoadCallback_)
        })
        :addTo(self)
end

function UserAvatarPopup:show(data, isAnimation)
	self.data_ = data;
	self.isAnimation_ = isAnimation
	self:setData();
	self:showPanel_(true, true, true, true);
end

function UserAvatarPopup:setData()
	if self.data_ then
        self.avatarIcon_:setDefaultAvatar(self.data_.sex)
        if string.len(self.data_.img) <= 5 then
    		
		else
            local imgurl = self.data_.img
            self:setLoading(true)
            -- 先显示当前头像的小头像，要不显示的是默认头像
            self.avatarIcon_:loadImage(imgurl)

    	    if string.find(imgurl, "facebook") then
                local middleImgurl = nil
    	        if string.find(imgurl, "?") then
                    middleImgurl = imgurl .. "&width=200&height=200"
    	            imgurl = imgurl .. "&width=600&height=600"
    	        else
                    middleImgurl = imgurl .. "?width=200&height=200"
    	            imgurl = imgurl .. "?width=600&height=600"
    	        end

                -- 房间内有些玩家加载的是中间大的头像...显示中间大小的头像  黑客编码
                if middleImgurl then
                    local config = tx.ImageLoader.cacheConfig_[tx.ImageLoader.CACHE_TYPE_USER_HEAD_IMG]
                    if config and config.path then
                        local hash = crypto.md5(middleImgurl)
                        local path = config.path .. hash
                        if io.exists(path) then
                            self:setLoading(true)
                            self.avatarIcon_:loadImage(middleImgurl)
                        end
                    end
                end
    	    end
    	    if imgurl~=self.data_.img then  -- 有大图
                self:setLoading(true)
                self.avatarIcon_:loadImage(imgurl)
            end
        end
	end
end

function UserAvatarPopup:imageLoadCallback_(success, showView)
    self:setLoading(false)
end

function UserAvatarPopup:onRemovePopup(func)
    local animTS = 0.2
    self:setCascadeOpacityEnabled(true)
    self:runAction(transition.sequence({
        cc.Spawn:create(
            cc.ScaleTo:create(animTS, 0),
            cc.FadeOut:create(animTS)
        ),
        cc.CallFunc:create(func)
    }))
end

return UserAvatarPopup;