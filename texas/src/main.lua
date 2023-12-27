function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    -- if tx and tx.OnOff then
    --     local isReport = tx.OnOff:checkReportError("clientLog")
    --     if isReport and tx.http and tx.http["getDefaultURL"] then
    --             local defaultUrl = tx.http.getDefaultURL()
    --             if defaultUrl ~= nil and (type(defaultUrl) == "string") and string.len(defaultUrl) > 0 then
    --                 local str = (tostring(errorMessage) or "") .. "|" .. (debug.traceback() or "")
    --                 if str and string.len(str) > 0 then
    --                     str = string.gsub(str,"[%c%s]","")
    --                     str = string.gsub(str,"\"","")
    --                     tx.http.reportError(str)
    --                 end

    --             end

    --     end

    -- end

    if CF_DEBUG > 0 and app then
        local errorinfo = tostring(errorMessage).."\n"..debug.traceback("", 2)
        local scene = display.getRunningScene()
        if scene then
            if not errorInfo_ then
                errorInfo_ = ui.newTTFLabel({
                    text = "",
                    font = "Arial.ttf",
                    size = 20,
                    x = display.cx,
                    y = display.cy,
                    color=cc.c3b(0xff,0x00,0x00),
                    align = ui.TEXT_ALIGN_LEFT,
                    dimensions = cc.size(display.width,display.height)
                }):addTo(scene, 9900);
            end
            errorInfo_:setString(errorinfo)
        end    
    end

end

-- 注: 本文件在AppDelegate::applicationDidFinishLaunching() 函数中执行

_G.___BUTTON_CLICK_FLAG___ = 20  -- 按钮点击距离标识  重要

require("umeng_boot")
require("config")
require("framework.init")
require("cocos.init")

--容错
cc.analytics = {};
cc.analytics.doCommand = function( ... )
    -- body
end
cc.analytics.start = function( ... )
    -- body
end

cc.FileUtils:getInstance():setResourceEncryptKeyAndSign("OpenTexas@jackxx", "741x")

_G.appconfig = require("appconfig")
require("welcome.WelcomeController").new()
