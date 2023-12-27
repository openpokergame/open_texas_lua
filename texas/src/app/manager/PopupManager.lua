--[[
    用法：
    tx.PopupManager:addPopup(StorePopup.new())，默认模态、居中、点击模态关闭
]]
local PopupManager = class("PopupManager")
local Z_ORDER = 1000

local DoDialogEndFun = function(dialog)
    if dialog.initViews then  -- 编辑的界面
        dialog:initViews()
    end
    if dialog.requestDatas then  -- 依赖服务器数据
        dialog:requestDatas()
    end
    if dialog.onShowed then
        dialog:onShowed()
    end
end

function PopupManager:ctor()
    -- 数据容器
    self.popupStack_ = {}

    -- 视图容器
    self.container_ = display.newNode()
    self.container_:retain()
    self.container_:setNodeEventEnabled(true)
    self.container_.nodeCleanup_ = true
    self.container_.onCleanup = handler(self, function (obj)
        -- 移除模态
        if obj.modal_ then
            obj.modal_:removeFromParent()
            obj.modal_ = nil
        end

        if obj.blurLayer_ and #obj.popupStack_ == 0 then
            obj.blurLayer_:removeFromParent()
            obj.blurLayer_ = nil
        end

        -- 移除所有弹框
        for k, popupData in pairs(obj.popupStack_) do
            if popupData.popup then
                popupData.popup:removeFromParent()
            end
            obj.popupStack_[k] = nil
        end
        self.zOrder_ = 2
    end)

    -- zOrder
    self.zOrder_ = 2
end

function PopupManager:onModalTouch_()
    if not self.modalIsRemovePopup_ then
        return
    end

    -- 获取最上层的弹框
    local popupData = self.popupStack_[#self.popupStack_]
    if popupData and popupData.popup and popupData.closeWhenTouchModel then
        tx.SoundManager:playSound(tx.SoundManager.CLOSE_BUTTON)
        self:removePopup(popupData.popup)
    end
end

-- 添加一个弹框
function PopupManager:addPopup(popup, isModal, isCentered, closeWhenTouchModel, useShowAnimation, modalRes, scaleVal, isBlur)
    self.modalIsRemovePopup_ = true
    if isModal == nil then isModal = true end
    if isCentered == nil then isCentered = true end
    if not isModal then
        closeWhenTouchModel = false
    elseif closeWhenTouchModel == nil then
        closeWhenTouchModel = true
    end

    if isBlur then
        self:addBlurLayer_()
    end

    -- 添加模态
    if isModal and not self.modal_ then
        self.modal_ = display.newScale9Sprite(modalRes or "#common/modal_texture.png", 0, 0, cc.size(display.width, display.height))
            :pos(display.cx, display.cy)
            :addTo(self.container_)
        self.modal_:setTouchEnabled(true)
        self.modal_:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onModalTouch_))
    end

    -- 居中弹框
    if isCentered then
        popup:pos(display.cx, display.cy)
    end

    -- 添加至场景
    if self:hasPopup(popup) then
        self:removePopup(popup)
    end

    table.insert(self.popupStack_, {popup = popup, closeWhenTouchModel = closeWhenTouchModel, isModal = isModal})
    if useShowAnimation ~= false then
        popup:scale(0.2)
        transition.scaleTo(popup, {time = 0.4, easing = "BACKOUT", scale = scaleVal or 1, onComplete=function() 
            DoDialogEndFun(popup)
        end})
    end
    popup:addTo(self.container_, self.zOrder_)
    self.zOrder_ = self.zOrder_ + 2
    if not self.container_:getParent() then
        self.container_:addTo(tx.runningScene, Z_ORDER)
    end

    -- 更改模态的zOrder
    if isModal then
        self.modal_:setLocalZOrder(popup:getLocalZOrder() - 1)
    end

    if popup.onShowPopup then
        popup:onShowPopup()
    end
    if useShowAnimation == false then
        DoDialogEndFun(popup)
    end
    sa.EventCenter:dispatchEvent(tx.eventNames.DISENABLED_EDITBOX_TOUCH)
end

function PopupManager:addBlurLayer_()
    if self.blurLayer_ and self.blurLayer_:getParent() then
        return
    end

    local curScene = display.getRunningScene()
    if not curScene then
        return
    end

    local sceneName = curScene.name
    local viewStatus = sa.DataProxy:getData(tx.dataKeys.CURRENT_HALL_VIEW)
    -- 获取缓存的模糊背景背景
    self.blurLayer_ = self:getBlurLayer(sceneName, viewStatus)
        :addTo(self.container_, self.zOrder_)
        -- :addTo(tx.runningScene, Z_ORDER-1)
        :center()
end

function PopupManager:getBlurLayer(sceneName, viewStatus)
    self.allBlurLayers_ = self.allBlurLayers_ or {}
    if not self.allBlurLayers_[sceneName] then
        self.allBlurLayers_[sceneName] = {}
    end

    local blurLayer
    if not self.allBlurLayers_[sceneName][viewStatus] then
        local filename = tostring(sceneName).."_"..tostring(viewStatus)..".png"
        blurLayer = sa.createBlurBg(tx.runningScene, filename, 0.1)
        blurLayer:retain()        
        self.allBlurLayers_[sceneName][viewStatus] = blurLayer
    else
        blurLayer = self.allBlurLayers_[sceneName][viewStatus]
    end

    return blurLayer
end

-- 移除指定弹框
function PopupManager:removePopup(popup)
    if popup then
        -- 从场景移除，删除数据
        sa.EventCenter:dispatchEvent(tx.eventNames.ENABLED_EDITBOX_TOUCH)
        local removePopupFunc = function()
            popup:removeFromParent()
            self.zOrder_ = self.zOrder_ - 2
            local bool, index = self:hasPopup(popup)
            table.remove(self.popupStack_, index)
            if #self.popupStack_ == 0 then
                if self.modal_ then
                    self.modal_:removeFromParent()
                    self.modal_ = nil
                end

                self.container_:removeFromParent()

                self.blurLayer_ = nil
            else
                -- 有时候删除框有动画的话，后面的窗口会先弹出来，导致层级错乱了
                local popupData = nil
                for i=1,#self.popupStack_,1 do
                    popupData = self.popupStack_[i]
                    popupData.popup:setLocalZOrder(i*2)
                end
                -- 更改模态的zOrder
                local needModal = false
                for i=#self.popupStack_,1,-1 do
                    popupData = self.popupStack_[i]
                    if popupData.isModal then
                        needModal = true
                        self.modal_:setLocalZOrder(popupData.popup:getLocalZOrder() - 1)
                        break
                    end
                end
                if not needModal and self.modal_ then
                    self.modal_:removeFromParent()
                    self.modal_ = nil
                end

                if self.blurLayer_ and #self.popupStack_ == 0 then
                    self.blurLayer_:removeFromParent()
                    self.blurLayer_ = nil
                end
            end
        end
        if popup.onRemovePopup then
            popup:onRemovePopup(removePopupFunc)
        else
            removePopupFunc()
        end
    end
end

-- 移除所有弹框
function PopupManager:removeAllPopup()
    self.container_:removeFromParent()
end

-- Determines if a popup is contained in popup stack
function PopupManager:hasPopup(popup)
    for i, popupData in ipairs(self.popupStack_) do
        if popupData.popup == popup then
            return true, i
        end
    end
    return false, 0
end

-- Determines if a popup is the top-most pop-up.
function PopupManager:isTopLevelPopUp(popup)
    if self.popupStack_[#self.popupStack_].popup == popup then
        return true
    else
        return false
    end
end

function PopupManager:removeTopPopupIf()
    if #self.popupStack_ > 0 then
        local p = self.popupStack_[#self.popupStack_]
        if p.closeWhenTouchModel then
            self:removePopup(p.popup)
            return true
        elseif p.popup.onReback then
            p.popup:onReback()
            return true
        end
    end
    return false
end

function PopupManager:isHasPopup()
    if self.popupStack_ and #self.popupStack_ > 0 then
        return true
    end
    return false
end

--设置模态触摸是否可以关闭弹窗，默认为true
function PopupManager:setModalIsRemovePopup(enable)
    self.modalIsRemovePopup_ = enable
end

return PopupManager
