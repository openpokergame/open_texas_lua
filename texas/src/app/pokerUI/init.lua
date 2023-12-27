local pokerUI = {}

pokerUI.PokerCard           = import(".PokerCard")
pokerUI.SimpleButton        = import(".SimpleButton")
pokerUI.Panel               = import(".Panel")
pokerUI.EditPanel           = import(".EditPanel")
pokerUI.Dialog              = import(".Dialog")
pokerUI.RewardDialog        = import(".RewardDialog")
pokerUI.ProgressBar         = import(".ProgressBar")
pokerUI.RoomLoading         = import(".RoomLoading")
pokerUI.TabBarWithIndicator = import(".TabBarWithIndicator")
pokerUI.CommonPopupTabBar   = import(".CommonPopupTabBar")
pokerUI.CheckBoxButtonGroup = import(".CheckBoxButtonGroup")
pokerUI.Juhua               = import(".Juhua")

local NumberEditbox = import("openpoker.ui.NumberEditbox")

local getInnerRect = function(s,autoRect)
	local size = s:getContentSize()
	local rect = cc.rect(autoRect.x, autoRect.y, autoRect.width, autoRect.height)
	if size.width<(rect.x+rect.width) then
		rect.x = size.width*0.5
		rect.width = 1
	end
	if size.height<(rect.y+rect.height) then
		rect.x = size.height*0.5
		rect.height = 1
	end
	return rect
end

-- 添加点击声效
function buttontHandler(obj, method)
    return function(...)
        tx.SoundManager:playSound(tx.SoundManager.CLICK_BUTTON)
        return method(obj, ...)
    end
end

--------------------拖拽还会继续触发点击事件---------------------
cc.Node.setDragClick = function(obj,value)  --可控性
	obj.__isDragClick__ = value
end
cc.Node.originalSetTouchSwallowEnabled__ = cc.Node.setTouchSwallowEnabled
if cc.Node.originalSetTouchSwallowEnabled__ then
	cc.Node.setTouchSwallowEnabled = function(obj,value)
		cc.Node.originalSetTouchSwallowEnabled__(obj,value)
		if obj.setDragClick and type(obj.setDragClick)=="function" then
			if value==false then
				obj.setDragClick(obj,false)
			else
				obj.setDragClick(obj,true)
			end
		end
		return obj
	end
end

function __baseButton__(node)
	if node.addTouchEventListener and node.setSwallowTouches and node.getTouchMovePosition and node.setEnabled then  -- cocos自带控件
		node.__isCocosCPPUI__ = true
	end
	node.onButtonRelease = function(obj,callback)
		obj.__releaseCallback__ = callback
		return obj
	end
	node.onButtonPressed = function(obj,callback)
		obj.__pressedCallback__ = callback
		return obj
	end
	node.onButtonClicked = function(obj,callback)
		obj.__clickedCallback__ = callback
		return obj
	end
	node.onButtonMove = function(obj,callback)
		obj.__moveCallback__ = callback
		return obj
	end
	node.__showEnabled__ = function(obj,value,color)
		if value then
			obj:setColor(cc.c3b(255,255,255))
		else
			if color then
				obj:setColor(color)
			else
				obj:setColor(cc.c3b(120,120,120))
			end
		end
	end
	if node.__isCocosCPPUI__ then
		node.setDragClick = function(obj,value)  --可控性
			obj.__isDragClick__ = value
		end
		node.setTouchSwallowEnabled = function(obj,value)
			obj:setSwallowTouches(value)
			if value==false then
				node.setDragClick(obj,false)
			else
				node.setDragClick(obj,true)
			end
			return obj
		end
	end
	node.setButtonEnabled = function(obj,value,color)
		obj:setTouchEnabled(value)
		if obj.__isDragClick__==false then
			obj:setTouchSwallowEnabled(false)
		else
			obj:setTouchSwallowEnabled(value)
		end
    	obj.__clickedEnabled__ = value
    	if obj.__end1__ and value==false then
			obj.__end1__(obj)
		end
		if obj.__showEnabled__ then
			obj.__showEnabled__(obj,value,color)
		end
    	return obj
	end
	node.isButtonEnabled = function(obj)
		return obj.__clickedEnabled__
	end
	node.__down__ = function(obj,evt)
		if obj.__down1__ then
			obj.__down1__(obj)
		end
		if obj.__pressedCallback__ then
			obj.__pressedCallback__(evt)
		end
	end
	node.__up__ = function(obj,evt)
		if obj.__clickedCallback__ then
			obj.__clickedCallback__(evt)
		end
	end
	node.__end__ = function(obj,evt)
		if obj.__end1__ then
			obj.__end1__(obj)
		end
		if obj.__releaseCallback__ then
			obj.__releaseCallback__(evt)
		end
	end
	node.__move__ = function(obj,evt)
		if obj.__moveCallback__ then
			obj.__moveCallback__(evt)
		end
	end
	node:setButtonEnabled(true)
	if node.__isCocosCPPUI__ then	
		node:addTouchEventListener(function(sender, type)
	        if type==0 then
	        	-- print("ccui.Widget.TOUCH_BEGAN")
	        	local evt = node:getTouchBeganPosition()
	        	evt.target = node
	            node.__beginX__ = evt.x
	        	node.__beginY__ = evt.y
	        	node.__isTouching__ = true
	        	node.__doUpEvent__ = true
	        	node:__down__(evt)
	        elseif type==1 then
	        	-- print("ccui.Widget.TOUCH_MOVED")
	        	local evt = node:getTouchMovePosition()
	        	evt.target = node
	        	node:__move__(evt)
	            if node.__doUpEvent__ then
			        node.__endX__ = evt.x
			        node.__endY__ = evt.y
			        if math.abs(node.__endX__-node.__beginX__)>_G.___BUTTON_CLICK_FLAG___ then
			        	node.__doUpEvent__ = false
			        elseif math.abs(node.__endY__-node.__beginY__)>_G.___BUTTON_CLICK_FLAG___ then
			        	node.__doUpEvent__ = false
			        end
			    end
	        elseif type==2 then
	            -- print("ccui.Widget.TOUCH_ENDED")
	            local evt = node:getTouchEndPosition()
	            evt.target = node
	            node.__isTouching__ = false
		       	if node.__doUpEvent__ or node.__isDragClick__~=false then
		       		node:__up__(evt)
		       	end
		       	node.__doUpEvent__ = false
		       	if node.__end__ then
		       		node:__end__(evt)
		       	end
	        elseif type==3 then
	        	-- print("ccui.Widget.TOUCH_CANCELED")
	        	local evt = node:getTouchEndPosition()
	        	evt.target = node
	            node.__isTouching__ = false
	            node.__doUpEvent__ = false
	            if node.__end__ then
		       		node:__end__(evt)
		       	end
	        end
	    end)
	else
	    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(evt)
	    	local name, x, y, prevX, prevY = evt.name, evt.x, evt.y, evt.prevX, evt.prevY
		    local isTouchInSprite = node:getCascadeBoundingBox():containsPoint(cc.p(x, y))
		    evt.target = node
		    if name == "began" then
		        if isTouchInSprite then
		        	node.__beginX__ = evt.x
		        	node.__beginY__ = evt.y
		        	node.__isTouching__ = true
		        	node.__doUpEvent__ = true
		        	node:__down__(evt)
		            return true
		        else
		            return false
		        end
		    elseif not node.__isTouching__ then
		        return false
		    elseif name == "moved" then
		    	node:__move__(evt)
		    	if node.__doUpEvent__ then
			        node.__endX__ = evt.x
			        node.__endY__ = evt.y
			        if math.abs(node.__endX__-node.__beginX__)>15 then
			        	node.__doUpEvent__ = false
			        	return true
			        elseif math.abs(node.__endY__-node.__beginY__)>15 then
			        	node.__doUpEvent__ = false
			        	return true
			        end
			    end
		    elseif name == "ended"  or name == "cancelled" then
		        node.__isTouching__ = false
		       	if isTouchInSprite and (node.__doUpEvent__ or node.__isDragClick__~=false) then
		       		node:__up__(evt)
		       	end
		       	node.__doUpEvent__ = false
		       	if node.__end__ then
		       		node:__end__(evt)
		       	end
		    end
		    return true
	    end)
	end
	return node
end

function NormalButton(node)
	__baseButton__(node)
	return node
end

function ColorButton(node, color, selected)
	__baseButton__(node)
	if not color then color = cc.c3b(220,220,220) end
	local curColor = node:getColor()
	node.__down1__ = function(obj)
		if not obj.__isSelected__ then
			obj:setColor(color)
		end
	end
	node.__end1__ = function(obj)
		if not obj.__isSelected__ then
			obj:setColor(curColor)
		end
	end
	node.__showEnabled__ = function(obj,value,color)
		if value then
			obj:setColor(curColor)
		else
			if color then
				obj:setColor(color)
			else
				obj:setColor(cc.c3b(120,120,120))
			end
		end
	end
	if selected then
		node.__select__ = function(obj,value)
			if value then
				obj:setColor(selected)
			else
				obj.__end1__(obj)
			end
		end
	end
	return node
end

function ScaleButton(node, scale, selected)
	__baseButton__(node)
	if not scale then scale = 0.96 end
	local curscale = node:getScale()
	scale = curscale*scale
	node.__down1__ = function(obj)
		if not obj.__isSelected__ then
			if obj.__scaleAction__ then
				obj:stopAction(obj.__scaleAction__)
				obj.__scaleAction__ = nil
			end
			obj:setScale(curscale)
			obj.__scaleAction__ = transition.scaleTo(obj, {scale = scale,time = 0.1, onComplete = function()
				obj:setScale(scale)
			end})
			-- obj:setScale(scale)
		end
	end
	node.__end1__ = function(obj)
		if not obj.__isSelected__ then
			if obj.__scaleAction__ then
				obj:stopAction(obj.__scaleAction__)
				obj.__scaleAction__ = nil
			end
			obj.__scaleAction__ = transition.scaleTo(obj, {scale = curscale,time = 0.1, easing = "ELASTICOUT", onComplete = function()
				obj:setScale(curscale)
			end})
			-- obj:setScale(curscale)
		end
	end
	if selected then
		node.__select__ = function(obj,value)
			if value then
				obj:setScale(selected)
			else
				obj.__end1__(obj)
			end
		end
	end
	return node
end
--[[node:节点;frame1:默认状态;frame2:点击状态;selected:选中状态]]
function ImgButton(node, frame1, frame2, selected)
	__baseButton__(node)
	if node.setSpriteFrame and node.getSpriteFrame then   -- Sprite
		node.__down1__ = function(obj)
			if frame2 and not obj.__isSelected__ then
				obj:setSpriteFrame(display.newSprite(frame2):getSpriteFrame())
			end
		end
		node.__end1__ = function(obj)
			if frame1 and not obj.__isSelected__ then
				obj:setSpriteFrame(display.newSprite(frame1):getSpriteFrame())
			end
		end
		if selected then
			node.__select__ = function(obj,value)
				if value then
					obj:setSpriteFrame(display.newSprite(selected):getSpriteFrame())
				else
					obj.__end1__(obj)
				end
			end
		end
		node:__end1__()
	elseif node.setSpriteFrame and node.getCapInsets then   --Scale9Sprite
		node.__capInsets__ = node:getCapInsets()
		node.__size__ = node:getContentSize()

		node.__down1__ = function(obj)
			if frame2 and not obj.__isSelected__ then
				local s = display.newSprite(frame2)
				obj:setSpriteFrame(s:getSpriteFrame(),getInnerRect(s,node.__capInsets__))
				obj:setContentSize(node.__size__)
			end
		end
		node.__end1__ = function(obj)
			if frame1 and not obj.__isSelected__ then
				local s = display.newSprite(frame1)
				obj:setSpriteFrame(s:getSpriteFrame(),getInnerRect(s,node.__capInsets__))
				obj:setContentSize(node.__size__)
			end
		end
		if selected then
			node.__select__ = function(obj,value)
				if value then
					local s = display.newSprite(selected)
					obj:setSpriteFrame(s:getSpriteFrame(),getInnerRect(s,node.__capInsets__))
					obj:setContentSize(node.__size__)
				else
					obj.__end1__(obj)
				end
			end
		end
		node:__end1__()
	elseif node.getCapInsets and node.loadTexture and node.setTextureRect and not node.setPercent then   --ImageView
		node.__capInsets__ = node:getCapInsets()
		-- btn:loadTextures("btn_u.png","btn_u.png","",1)
		-- 最后的那个参数：0表示原始图片，1表示plist里的图片
		-- image:loadTexture("image_gong.png",1)
		-- 最后的那个参数：0表示原始图片，1表示plist里的图片
		local frame1 = frame1
		local frame2 = frame2
		local t1 = 0
		local t2 = 0
		if frame1 and string.byte(frame1) == 35 then
			frame1 = string.sub(frame1, 2)
			t1 = 1 
		end
		if frame2 and string.byte(frame2) == 35 then
			frame2 = string.sub(frame2, 2)
			t2 = 1
		end
		node.__down1__ = function(obj)
			if frame2 and not obj.__isSelected__ then
				obj:loadTexture(frame2, t2)
			end
		end
		node.__end1__ = function(obj)
			if frame1 and not obj.__isSelected__ then
				obj:loadTexture(frame1, t1)
			end
		end
		if selected then
			local selected = selected
			local t3 = 0
			if string.byte(selected) == 35 then
				selected = string.sub(selected, 2)
				t3 = 1
			end
			node.__select__ = function(obj,value)
				if value then
					obj:loadTexture(selected, t3)
				else
					obj.__end1__(obj)
				end
			end
		end
		node:__end1__()
	else
		NormalButton(node)
	end
	return node
end

function ChkBoxButton(node)  -- 通过上面3个按钮装换过来
	if node then
		-- cc(node):addComponent("components.behavior.EventProtocol"):exportMethods()
	else
		return;
	end
	node.onButtonStateChanged = function(obj,callback)
		obj.__stateChangedCallback__ = callback
	end
	node.isButtonSelected = function(obj)
		return obj.__isSelected__
	end
	node.setButtonSelected = function(obj,selected)
		if obj:isButtonSelected() ~= selected then
			obj.__isSelected__ = selected
			if obj.__select__ then
				obj.__select__(obj,selected)
			end
			if obj.__stateChangedCallback__ then
				obj.__stateChangedCallback__({name = "STATE_CHANGED_EVENT",target=obj})
			end
	    end
	end
	node.__isSelected__ = false
	return node
end
-- 全屏进度条
--[[
	{
		direction=1, -- 1 横向; 2 纵向
		type = 1, -- 1 img左边开始显示; 2 img右边开始显示
		bar = "img.png",
		bg = "bg.png"
	}
--]]
function FullProgressBar(params)
	local direction = params and params.direction or 1
	local type = params and params.type or 1
	local node = display.newNode()
	local spriteBg = display.newSprite(params and params.bg)
		:addTo(node)
	local spriteImg = display.newSprite(params and params.bar)
	local size = spriteImg:getContentSize()
	local rect = cc.rect(-size.width*0.5, -size.height*0.5, size.width, size.height)
    local clipNode = display.newClippingRectangleNode(rect)
		:addTo(node)
	spriteImg:addTo(clipNode)
	node.setValue = function(obj,value)
		value = tonumber(value) or 0
		if direction==1 then
			local curWidth = size.width*value
			if type==1 then
				clipNode:setPositionX(-size.width+curWidth)
				spriteImg:setPositionX(size.width-curWidth)
			else
				spriteImg:setPositionX(-size.width+curWidth)
			end
		else
			local curHeight = size.height*value
			if type==1 then
				clipNode:setPositionY(-size.height+curHeight)
				spriteImg:setPositionY(size.height-curHeight)
			else
				spriteImg:setPositionY(-size.height+curHeight)
			end
		end
		return obj
	end
	node.bg = spriteBg
	node.bar = spriteImg
	return node
end
-- 按钮哦
local UIButton = require("framework.cc.ui.UIButton")
cc.ui.UIPushButton.onTouch_ = function(obj,event)
	local name, x, y = event.name, event.x, event.y
    if name == "began" then
    	obj._isClicked_ = true
        obj.touchBeganX = x
        obj.touchBeganY = y
        if not obj:checkTouchInSprite_(x, y) then return false end
        obj.fsm_:doEvent("press")
        obj:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        return true
    end
    
    local touchInTarget = obj:checkTouchInSprite_(obj.touchBeganX, obj.touchBeganY)
                        and obj:checkTouchInSprite_(x, y)
    if name == "moved" then
        if touchInTarget and obj.fsm_:canDoEvent("press") then
            obj.fsm_:doEvent("press")
            obj:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        elseif not touchInTarget and obj.fsm_:canDoEvent("release") then
            obj.fsm_:doEvent("release")
            obj:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = false})
        end
        if math.abs(x-obj.touchBeganX)>_G.___BUTTON_CLICK_FLAG___ then
        	obj._isClicked_ = false
        elseif math.abs(y-obj.touchBeganY)>_G.___BUTTON_CLICK_FLAG___ then
        	obj._isClicked_ = false
        end
    else
        if obj.fsm_:canDoEvent("release") then
            obj.fsm_:doEvent("release")
            obj:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = touchInTarget})
        end
        if name == "ended" and touchInTarget then
            if obj.delayTouchEnabled_ then
                if obj.isTouchEnabled_ then
                    obj.isTouchEnabled_ = false
                    obj:performWithDelay(function()
                        obj.isTouchEnabled_ = true
                    end, 0.5)
                    if obj._isClicked_ or obj.__isDragClick__~=false then
                    	obj:dispatchEvent({name = UIButton.CLICKED_EVENT, x = x, y = y, touchInTarget = true})
                    end
                end
            else
            	if obj._isClicked_ or obj.__isDragClick__~=false then
                	obj:dispatchEvent({name = UIButton.CLICKED_EVENT, x = x, y = y, touchInTarget = true})
                end
            end
        end
    end
end
cc.ui.UICheckBoxButton.onTouch_ = function(obj,event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
    	obj._isClicked_ = true
        obj.touchBeganX = x
        obj.touchBeganY = y
        if not obj:checkTouchInSprite_(x, y) then return false end
        obj.fsm_:doEvent("press")
        obj:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        return true
    end

    local touchInTarget = obj:checkTouchInSprite_(x, y)
    if name == "moved" then
        if touchInTarget and obj.fsm_:canDoEvent("press") then
            obj.fsm_:doEvent("press")
            obj:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        elseif not touchInTarget and obj.fsm_:canDoEvent("release") then
            obj.fsm_:doEvent("release")
            obj:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = false})
        end
        if math.abs(x-obj.touchBeganX)>_G.___BUTTON_CLICK_FLAG___ then
        	obj._isClicked_ = false
        elseif math.abs(y-obj.touchBeganY)>_G.___BUTTON_CLICK_FLAG___ then
        	obj._isClicked_ = false
        end
    else
        if obj.fsm_:canDoEvent("release") then
            obj.fsm_:doEvent("release")
            obj:dispatchEvent({name = UIButton.RELEASE_EVENT, x = x, y = y, touchInTarget = touchInTarget})
        end
        if name == "ended" and touchInTarget then
        	if obj._isClicked_ or obj.__isDragClick__~=false then
	            obj:setButtonSelected(obj.fsm_:canDoEvent("select"))
	            obj:dispatchEvent({name = UIButton.CLICKED_EVENT, x = x, y = y, touchInTarget = true})
	        end
        end
    end
end

-- 覆盖 事件管理机制不一样
local frameWorkNewEditBox = ui.newEditBox
ui.newEditBox = function(...)
	local __editLabel__ = frameWorkNewEditBox(...)
	if tx and tx.EditBoxManager then
    	__editLabel__:setNodeEventEnabled(true)
    	__editLabel__.onCleanup = function()
    		tx.EditBoxManager:removeEditBox(__editLabel__)
    	end
    	tx.EditBoxManager:addEditBox(__editLabel__)

    	--在活动中心会出现，已经派发了DISENABLED_EDITBOX_TOUCH事件，但是编辑框还没创建出来，导致计数不准确，需要手动计数
    	__editLabel__.resetEditBoxManager = function()
    		tx.EditBoxManager:removeEditBox(__editLabel__)
    		tx.EditBoxManager:addEditBox(__editLabel__, 1)
    	end
    end
	return __editLabel__
end

function EditLabel(node,fontColor,fontSize)
	if not node then
		return
	end
	local size = node:getContentSize()
	local inputWidth  = size.width
    local inputHeight = size.height
    local inputContentColor = fontColor or cc.c3b(0x4d, 0x3f, 0x5f)
    local inputContentSize = fontSize or 24
    local inputEditBox_x, inputEditBox_y = size.width*0.5, size.height*0.5
    local editLabel_ = ui.newEditBox({
            image = "#common/transparent.png",
            -- image="common_red_btn_up.png",
            size = cc.size(inputWidth, inputHeight),
            listener = function(evt, editbox)
                local text = editbox:getText()
                if evt == "began" then
                elseif evt == "ended" then
                elseif evt == "return" then
                	if editbox.__returnHandler__ then
                		editbox.__returnHandler__("return")
                	end
                elseif evt == "changed" then
                    local filteredText = tx.keyWordFilter(text)
                    if filteredText ~= text then
                        editbox:setText(filteredText)
                    end
                    if editbox.__returnHandler__ then
                		editbox.__returnHandler__("changed")
                	end
                else
                    
                end
            end
        })
        :align(display.LEFT_CENTER, 0, inputEditBox_y)
        :addTo(node)
    editLabel_:setTouchSwallowEnabled(false)
    editLabel_:setFontColor(inputContentColor)
    editLabel_:setPlaceholderFontColor(inputContentColor)
    editLabel_:setFont(ui.DEFAULT_TTF_FONT, inputContentSize)
    editLabel_:setPlaceholderFont(ui.DEFAULT_TTF_FONT, inputContentSize)
    editLabel_:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editLabel_:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    editLabel_.setReturnHandler = function(obj,callback)
    	obj.__returnHandler__ = callback
    	return obj
    end
    editLabel_.show = function(obj)
    	cc.Node.show(obj)
    	node:show()

    	return obj
    end
    editLabel_.hide = function(obj)
    	cc.Node.hide(obj)
    	node:hide()

    	return obj
    end
    editLabel_.pos = function(obj, x, y)
    	node:pos(x, y)

    	return obj
    end
    return editLabel_
end

function EditNumberLabel(node, params)
	local size = node:getContentSize()
    params.width, params.height = size.width, size.height
    params.img = "#common/transparent.png"
    local editbox = NumberEditbox.new(params)
		:pos(size.width*0.5, size.height*0.5)
		:addTo(node)

    editbox.show = function(obj)
    	cc.Node.show(obj)
    	node:show()

    	return obj
    end

    editbox.hide = function(obj)
    	cc.Node.hide(obj)
    	node:hide()

    	return obj
    end

    editbox.pos = function(obj, x, y)
    	node:pos(x, y)

    	return obj
    end

    return editbox
end

return pokerUI
