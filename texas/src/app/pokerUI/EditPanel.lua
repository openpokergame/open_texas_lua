local EditPanel = class("Panel", function()
    return display.newNode()
end)

--适配字体,统一设置成系统字体.ccs创建的UIText,俄语每个字符显示间隔特别大
EditPanel.setLabelFont_ = function(view)
	if view then
		local desc = view:getDescription()
	    if desc == "Label" then
	    	view:setFontName(display.DEFAULT_TTF_FONT)
	    end
	end
end

EditPanel.sysElements_ = function(target,parent,str,tindex)
    local index=string.find(str,"%.")
    if index~=nil then
	    local k=string.sub(str,1,index-1)
	   	if not parent then return; end
	    local view=parent:getChildByName(k)
	    if tindex==1 then
	        parent=target
	    end
	    parent[k]=view

	    EditPanel.setLabelFont_(view)

	    local lessStr=string.sub(str,index+1)
	    tindex=tindex+1
	    EditPanel.sysElements_(target,parent[k],lessStr,tindex)
	else
		if not parent then return; end
		local view=parent:getChildByName(str)
	    if tindex==1 then
	        parent=target
	    end

   		parent[str]=view

   		EditPanel.setLabelFont_(view)
    end
end

EditPanel.bindElementsToTarget = function(target,viewName,noSwallowEvent)
	if viewName and type(viewName)=="string" and string.trim(viewName)~="" then
		target.editView = cc.uiloader:load(viewName)
		if not noSwallowEvent then
			target.editView:setTouchEnabled(true)
	        target.editView:setTouchSwallowEnabled(true)
	    end
		local size = target.editView:getContentSize()
		target.editView:addTo(target)
		-- 场景布局 需用到
		target.baseScaleX = display.width/size.width          --满屏适配
    	target.baseScaleY = display.height/size.height        --满屏适配
    	if target.baseScaleX>target.baseScaleY then
	        target.baseOffX = (display.width-size.width)*0.5  --节点错位
        	target.baseOffY = (CONFIG_SCREEN_HEIGHT-size.height)*0.5--节点错位
	    else
    		target.baseOffX = (CONFIG_SCREEN_WIDTH-size.width)*0.5--节点错位
			target.baseOffY = (display.height-size.height)*0.5--节点错位
	    end
		local viewConfig = target.class and target.class.ELEMENTS
		if viewConfig then
			for k,v in ipairs(viewConfig) do
				EditPanel.sysElements_(target,target.editView,v,1)
			end
		end
		return target.editView
	end
	return nil
end

function EditPanel:ctor(viewName)
	self:setNodeEventEnabled(true)
	return EditPanel.bindElementsToTarget(self,viewName)
end

function EditPanel:showPanel_(isModal, isCentered, closeWhenTouchModel, useShowAnimation)
    tx.PopupManager:addPopup(self, isModal ~= false, isCentered ~= false, closeWhenTouchModel ~= false, useShowAnimation ~= false)
    return self
end

function EditPanel:hidePanel_()
    tx.PopupManager:removePopup(self)
end

function EditPanel:setCloseCallback(closeCallback)
    self.closeCallback_ = closeCallback
    return self
end

function EditPanel:onClose()
    self:hidePanel_()
end

function EditPanel:show(isModal, isCentered, closeWhenTouchModel, useShowAnimation)
	self:showPanel_(isModal, isCentered, closeWhenTouchModel, useShowAnimation)
	return self
end

function EditPanel:showPanel()
    self:showPanel_()
end

function EditPanel:hidePanel()
    self:hidePanel_()
end

function EditPanel:onRemovePopup(removeFunc)
    if self.closeCallback_ then
        self.closeCallback_()
    end

    removeFunc()
end

function EditPanel:setLoading(isLoading)
    if isLoading then
        if not self.juhua_ then
            self.juhua_ = tx.ui.Juhua.new()
                :pos(self.loadingX_ or 0, self.loadingY_ or 0)
                :addTo(self)
        end
    else
        if self.juhua_ then
            self.juhua_:removeFromParent()
            self.juhua_ = nil
        end
    end
end

return EditPanel