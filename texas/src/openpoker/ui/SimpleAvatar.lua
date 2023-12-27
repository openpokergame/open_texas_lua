-- 普通头像,默认圆形
local SimpleAvatar  = class("SimpleAvatar", function ()
    return display.newNode()
end)

local DEFAULT_IMG_SIZE = 180 --默认头像图片大小
local ICON_TAG = 10  -- 动画头像添加层级
local COMMON_ACT_NAME = "1"  -- 动画头像默认动画
local WIN_ACT_NAME = "2"  -- 动画头像赢牌动作
local LOSE_ACT_NAME = "3"  -- 动画头像输牌动作
local BONE_FILES = {"skeleton.png","skeleton.atlas", "skeleton.json"}
local IMG_LOADER = 1    --图片加载类型
local ANIM_LOADER = 2   --动画加载类型

function SimpleAvatar:ctor(params)
    self.loadType_ = IMG_LOADER
    self.this_ = self
	self:setNodeEventEnabled(true)
    params = params or {}
    local shapeImg = params.shapeImg or "#common/common_avatar_inside_frame.png"
    local frameImg = params.frameImg or "#common/common_avatar_outer_frame.png"
    local scale9 = params.scale9
    local offsetSize = params.offsetSize or 2

	self.avatarSize_ = params.size or 86
    self.loadCallBack_ = params.loadCallBack  --加载完成后回调

    --是否为矩形头像
    self.maleIconImg_ = "common/icon_male.png"
    self.femaleIconImg_ = "common/icon_female.png"

	local headImgContainer = cc.ClippingNode:create()
    local stencil
    if scale9 then
        stencil = display.newScale9Sprite(shapeImg, 0, 0, cc.size(self.avatarSize_, self.avatarSize_))
        self.avatarWidth_,self.avatarHeight_ = self.avatarSize_, self.avatarSize_
    else
        stencil = display.newSprite(shapeImg)
        self.avatarSize_ = stencil:getContentSize().width
        self.avatarWidth_,self.avatarHeight_ = stencil:getContentSize().width,stencil:getContentSize().height
    end

    headImgContainer:setStencil(stencil)
    headImgContainer:setAlphaThreshold(0.05)
    headImgContainer:addTo(self)

    -- 头像
    self.avatar_ = display.newSprite("#" .. self.maleIconImg_)
        :scale(self.avatarSize_ / DEFAULT_IMG_SIZE)
        :addTo(headImgContainer)
    self.avatarAnim_ = display.newNode()
        :addTo(headImgContainer)
        :hide()

    if frameImg ~= "" then
        if scale9 then
            self.boder = display.newScale9Sprite(frameImg, 0, 0, cc.size(self.avatarWidth_ + offsetSize, self.avatarHeight_ + offsetSize))
                :addTo(self)
        else
            self.boder = display.newSprite(frameImg):addTo(self)
        end
        self.boder:setScale(params.boderScale or 1.01)--头像显示锯齿
    end

    self.userAvatarLoaderId_ = tx.ImageLoader:nextLoaderId()
end

function SimpleAvatar:loadImage(imgUrl)
    self.imgUrl_ = imgUrl
    tx.ImageLoader:cancelJobByLoaderId(self.userAvatarLoaderId_)
    if tx.userData and tx.userData.isUseAnimation == 1 then
        local params = sa.getFileNameByFilePath(imgUrl)
        if params and params["extension"] == "zip" then
            local bg = 1
            if params["bg"] then
               bg = tonumber(params["bg"]) or 1
            end
            if bg<1 or bg>4 then
                bg = 1
            end
            self.loadType_ = IMG_LOADER
            self:onAvatarLoadComplete_(true, display.newSprite("#common/vipbg"..bg..".png"),"isActive")
            self.loadType_ = ANIM_LOADER
            tx.ImageLoader:loadAndCacheAnimation(
                BONE_FILES,
                self.userAvatarLoaderId_,
                imgUrl,
                handler(self, self.onAnimationAvatarLoadComplete_),
                tx.ImageLoader.CACHE_TYPE_ANIMATION
            )
        else
            self.loadType_ = IMG_LOADER
            tx.ImageLoader:loadAndCacheImage(
                self.userAvatarLoaderId_,
                imgUrl,
                handler(self, self.onAvatarLoadComplete_),
                tx.ImageLoader.CACHE_TYPE_USER_HEAD_IMG
            )
        end
    else
        self.loadType_ = IMG_LOADER
        tx.ImageLoader:loadAndCacheImage(
            self.userAvatarLoaderId_,
            imgUrl,
            handler(self, self.onAvatarLoadComplete_),
            tx.ImageLoader.CACHE_TYPE_USER_HEAD_IMG
        )
    end
end

function SimpleAvatar:onAvatarLoadComplete_(success, sprite, isActive)
    if not self.this_ then return; end
    if self.loadType_~=IMG_LOADER then return; end
    if success then
        local tex = sprite:getTexture()
        -- local texSize = tex:getContentSize()
        -- self.avatar_:setTexture(tex)
        -- self.avatar_:setTextureRect(cc.rect(0, 0, texSize.width, texSize.height))
        -- self.avatar_:setScaleX(self.avatarWidth_/texSize.width)
        -- self.avatar_:setScaleY(self.avatarHeight_/texSize.height)
        local rect = sprite:getTextureRect()
        self.avatar_:setTexture(tex)
        self.avatar_:setTextureRect(cc.rect(rect.x, rect.y, rect.width, rect.height))
        self.avatar_:setScaleX(self.avatarWidth_/rect.width)
        self.avatar_:setScaleY(self.avatarHeight_/rect.height)
    end
    self.avatar_:show()
    self.avatarAnim_:hide()
    if isActive~="isActive" then
        if self.loadCallBack_ then
            self.loadCallBack_(success,sprite)
        end
    end
end

-- 移除Icon
function SimpleAvatar:removeTAG_()
    local oldIcon = self.avatarAnim_:getChildByTag(ICON_TAG)
    if oldIcon then
        oldIcon:hide()
        if oldIcon.update then 
            oldIcon:update(0) 
        end
        oldIcon:removeFromParent()
        self.anim_ = nil
    end
end
function SimpleAvatar:onAnimationAvatarLoadComplete_(success, params)
    if not self.this_ then return; end
    if self.loadType_~=ANIM_LOADER then return; end
    if success then
        if self.imgUrl_==self.lastZipUrl_ then  --座位上重复设置为默认头像 然后又设置为动图
            self.avatarAnim_:show()
        else
            self.lastZipUrl_ = self.imgUrl_
            self:removeTAG_()
            local animationName = params["name"]
            local animationScale = params["scale"] or 1 -- scale 动画缩放比例
            local actionName = params["action"] or COMMON_ACT_NAME -- action 为播放的标签名称
            local delay = params["delay"] or -1 -- delay 延迟多久播放动画，-1为不延迟播放动画
            local speed = params["speed"] or -1 -- speed 为动画播放用时
            local offx = params["offx"] or 0    -- offx 为x坐标的偏移量
            local offy = params["offy"] or 0    -- offy 为y坐标的偏移量
            local loop = params["loop"] or 0    -- loop 为播放次数，0为无限播放
            local touchWidth = params["touchWidth"] or -1   -- 点击相应区域宽度
            local touchHeight = params["touchHeight"] or -1 -- 点击相应区域宽度
            local path = device.writablePath.."cache/animation/"..tostring(animationName).."/"
            self.anim_ = sp.SkeletonAnimation:create(path..BONE_FILES[3], path..BONE_FILES[2])
            if self.anim_ and self.anim_:findAnimation(actionName) then
                self.anim_:setAnimation(0, actionName, true)
                self.anim_:addTo(self.avatarAnim_, ICON_TAG, ICON_TAG)
                self.anim_:update(0)  -- 调用一次才能获取到大小getBoundingBox()
                local sz = self.anim_:getBoundingBox()

                -- 添加触摸区域  不设置无法点击
                if touchWidth==-1 then
                    touchWidth = self.avatarWidth_
                end
                if touchHeight==-1 then
                    touchHeight = self.avatarHeight_
                end
                display.newNode():size(cc.size(touchWidth,touchHeight)):pos(-touchWidth*0.5,-touchHeight*0.5):addTo(self.anim_)

                local xscale, yscale = self.avatarWidth_/sz.width, self.avatarHeight_/sz.height
                local fitScale = math.min(xscale, yscale)
                animationScale = animationScale*fitScale
                self.anim_:scale(animationScale)
                self.anim_:pos(offx, offy)
                self.avatarAnim_:show()
                -- 动画监听 胜利啥的 播放完毕回到正常状态
                self.anim_:registerSpineEventHandler(function (event)
                    if event.type == "complete" and event.animation ~= "1" then
                        -- self.anim_:setToSetupPose()
                        self.anim_:initialize()
                        self.anim_:setAnimation(0, actionName, true)
                    end
                end, sp.EventType.ANIMATION_COMPLETE)
            else
                self.lastZipUrl_ = nil
                self.anim_ = nil
            end
        end
    end

    if self.loadCallBack_ then
        self.loadCallBack_(success,self.anim_)
    end
end

-- 设置性别
function SimpleAvatar:setDefaultAvatar(sex)
	if sex == "f" then
	  self:setSpriteFrame(self.femaleIconImg_)
	else
	  self:setSpriteFrame(self.maleIconImg_)
	end
	return self
end

function SimpleAvatar:setSpriteFrame(img)
	self.avatar_:setSpriteFrame(img)
  	self:refreshAvatarIcon()
end

function SimpleAvatar:refreshAvatarIcon()
    if self.avatar_ then
        local sz = self.avatar_:getContentSize()
        local xscale, yscale = self.avatarWidth_/sz.width, self.avatarHeight_/sz.height
        self.avatar_:setScale(math.min(xscale, yscale))
        self.avatar_:show()
        self.avatarAnim_:hide()
    end
end

function SimpleAvatar:playWinAnim()
    if self.anim_ and self.anim_.findAnimation and self.anim_:findAnimation(WIN_ACT_NAME) then
        self.anim_:setAnimation(1, WIN_ACT_NAME, false)
    end
end
function SimpleAvatar:playLoseAnim()
    if self.anim_ and self.anim_.findAnimation and self.anim_:findAnimation(LOSE_ACT_NAME) then
        self.anim_:setAnimation(2, LOSE_ACT_NAME, false)
    end
end

function SimpleAvatar:onCleanup()
	tx.ImageLoader:cancelJobByLoaderId(self.userAvatarLoaderId_)
end

return SimpleAvatar