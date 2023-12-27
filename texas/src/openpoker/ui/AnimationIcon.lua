local AnimationIcon = class("AnimationIcon", function()
	return display.newNode()
end)

local ICON_TAG = 10
local BONE_FILES = {"skeleton.png","skeleton.atlas", "skeleton.json"}

AnimationIcon.MAX_GIFT_DW = 100
AnimationIcon.MAX_GIFT_DH = 100
--[[
loadingImg:为默认加载图片资源
imgScale:为加载图片资源缩放值
animScale:为骨骼动画加载完成后的缩放值
clickCallback:为Click事件
]]--
function AnimationIcon:ctor(loadingImg, imgScale, animScale, clickCallback, btnDW, btnDH, loadingImgScale)
	self.this_ = self
	self:setNodeEventEnabled(true)

	self.loadingImg_ = loadingImg
	self.imgScale_ = imgScale or 0.5
	self.animScale_ = animScale or 0.5
	self.loadingImgScale_ = loadingImgScale or 1
	self.btnDW_ = btnDW or 60
	self.btnDH_ = btnDH or 60

	cc.GameObject.extend(self)
	self:addComponent("components.behavior.EventProtocol"):exportMethods()

	if self.loadingImg_ and string.len(self.loadingImg_) > 5 then
		self.loading_ = display.newSprite(self.loadingImg_)
			:addTo(self)
			:scale(self.loadingImgScale_)
	end

	if clickCallback then
		sa.TouchHelper.new(self, function(target, evtName)
			if evtName==sa.TouchHelper.CLICK then
		        clickCallback()
		    end
		end)
	end

	self:getNextLoaderId_()
end

--设置最大宽高
function AnimationIcon:onData(imgUrl, maxDW, maxDH, callback, diffVal)
	self.imgUrl_ = imgUrl
	self.maxDW_ = maxDW
	self.maxDH_ = maxDH
	self.diffVal_ = diffVal or 0
	self.callback_ = callback
	self.lastImgScale_ = self.imgScale_

	if not self.imgUrl_ then
		if self.loading_ then
			self.loading_:show()
		end
		self:removeTAG_()
		self.lastImgUrl_ = nil
		return
	end

	if self.imgUrl_ ~= self.lastImgUrl_ then
		if self.loading_ then
			self.loading_:show()
		end
		self:loadImage_(self.imgUrl_)
		self.lastImgUrl_ = self.imgUrl_
	else
		if self.callback_ then
	    	self.callback_(true, nil)
	    end
	end
end

function AnimationIcon:getNextLoaderId_()
	self.loaderId_ = tx.ImageLoader:nextLoaderId()
end

function AnimationIcon:cancelLoaderId()
	if self.loaderId_ then
		tx.ImageLoader:cancelJobByLoaderId(self.loaderId_)
		self.loaderId_ = nil
	end
end

function AnimationIcon:loadImage_(imgUrl)
	tx.ImageLoader:cancelJobByLoaderId(self.loaderId_)
	if tx.userData and tx.userData.isUseAnimation == 1 then
		local params = sa.getFileNameByFilePath(imgUrl)
		if params and params["extension"] == "zip" then
			tx.ImageLoader:loadAndCacheAnimation(
				BONE_FILES,
				self.loaderId_,
				imgUrl,
				handler(self, self.onAnimationLoadCallback_),
				tx.ImageLoader.CACHE_TYPE_ANIMATION
			)
		else
			tx.ImageLoader:loadAndCacheImage(self.loaderId_,
				imgUrl,
				handler(self, self.onGiftImageLoadCallback_),
				tx.ImageLoader.CACHE_TYPE_GIFT
			)
		end
	else
		tx.ImageLoader:loadAndCacheImage(self.loaderId_,
			imgUrl,
			handler(self, self.onGiftImageLoadCallback_),
			tx.ImageLoader.CACHE_TYPE_GIFT
		)
	end
end

function AnimationIcon:onAnimationLoadCallback_(success, params, loaderId)
	if not self.this_ then return; end
	if success then
		if self.loading_ then
			self.loading_:hide()
		end

		self:removeTAG_()

		local animationName = params["name"]
		local animationScale = params["scale"] or 1 -- scale 动画缩放比例
		local actionName = params["action"] or "1" -- action 为播放的标签名称
		local delay = params["delay"] or -1 -- delay 延迟多久播放动画，-1为不延迟播放动画
		local speed = params["speed"] or -1	-- speed 为动画播放用时
		local offx = params["offx"] or 0 	-- offx 为x坐标的偏移量
		local offy = params["offy"] or 0 	-- offy 为y坐标的偏移量
		local loop = params["loop"] or 0 	-- loop 为播放次数，0为无限播放
		local touchWidth = params["touchWidth"] or -1 	-- 点击相应区域宽度
		local touchHeight = params["touchHeight"] or -1 -- 点击相应区域宽度
		local path = device.writablePath.."cache/animation/"..tostring(animationName).."/"
		self.anim_ = sp.SkeletonAnimation:create(path..BONE_FILES[3], path..BONE_FILES[2])
		if self.anim_:findAnimation(actionName) then
			self.anim_:setAnimation(0, actionName, true)
			self.anim_:addTo(self, ICON_TAG, ICON_TAG)
			self.anim_:update(0)  -- 调用一次才能获取到大小getBoundingBox()
			local sz = self.anim_:getBoundingBox()

			-- 添加触摸区域  不设置无法点击
			if touchWidth==-1 then
				touchWidth = sz.width
			end
			if touchHeight==-1 then
				touchHeight = sz.height
			end
			display.newNode():size(cc.size(touchWidth,touchHeight)):pos(-touchWidth*0.5,-touchHeight*0.5):addTo(self.anim_)

			if self.maxDW_ and self.maxDH_ then
	    		local fitScale = sa.getFitScale(self.maxDW_+self.diffVal_, self.maxDH_+self.diffVal_, sz)
    			animationScale = fitScale * animationScale
	    		offy = offy - self.diffVal_*0.5
	    	end

			self.anim_:scale(animationScale)
			self.anim_:pos(offx, offy)
		end
	    self.animScale_ = animationScale
	end

    if self.callback_ then
    	local tex = nil
    	self.callback_(success, tex)
    end
end

function AnimationIcon:onGiftImageLoadCallback_(success, sprite, loaderId)
	if not self.this_ then return; end
    if success then
    	if self.loading_ then
			self.loading_:hide()
		end
		-- 
    	self:removeTAG_()
        sprite:addTo(self, ICON_TAG, ICON_TAG)
        if self.maxDW_ and self.maxDH_ then
        	local sz = sprite:getContentSize()
    		local scaleVal = sa.getFitScale(self.maxDW_, self.maxDH_, sz)
    		if self.lastImgScale_ > scaleVal then
    			self.lastImgScale_ = scaleVal
    		end
    	end
        sprite:scale(self.lastImgScale_)
        self.animScale_ = self.lastImgScale_
    end

    if self.callback_ then
    	local tex = nil
    	if sprite and type(sprite)~="number" then
    		tex = sprite:getTexture()
    	end
    	self.callback_(success, tex)
    end
end

-- 移除Icon
function AnimationIcon:removeTAG_()
	local oldIcon = self:getChildByTag(ICON_TAG)
	if oldIcon then
		oldIcon:removeFromParent()
	end

	local oldAvatar = self:getChildByTag(ICON_TAG)
    if oldAvatar then
        oldAvatar:removeFromParent()
    end
end

function AnimationIcon:play(actionName)
	if not actionName then actionName = "1" end
	if self.anim_ and self.anim_.findAnimation and self.anim_:findAnimation(actionName) then
		self.anim_:setAnimation(0, actionName, true)
	end
end

function AnimationIcon:playWinAnim()

end

function AnimationIcon:playLoseAnim()
	
end

function AnimationIcon:onCleanup()
	self:cancelLoaderId()
end

return AnimationIcon