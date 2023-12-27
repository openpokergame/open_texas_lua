
-- 发布正式版本的时候，打开此标志
local IS_RELEASE = false
if IS_RELEASE then
    DEBUG    = 0 -- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
    CF_DEBUG = 0
    DEBUG_FPS = false
else
    DEBUG    = 5
    CF_DEBUG = 5
	DEBUG_FPS = true
end

--AppStore支付沙盒模式开关
IS_SANDBOX = true

--BLUEPAY是否为测试
-- IS_BLUEPAY_TEST = true

-- webpay方式
-- IS_WEB_BLUEPAY = true

if IS_RELEASE then  --忘记了关开关
	IS_SANDBOX = false
	-- IS_BLUEPAY_TEST = false
end

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

DISABLE_DEPRECATED_WARNING = false

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "landscape"

-- design resolution
CONFIG_SCREEN_WIDTH  = 1280
CONFIG_SCREEN_HEIGHT = 800

SHOW_SCROLLVIEW_BORDER = false --是否显示边框

--游戏效果图宽高，因为CONFIG_SCREEN_WIDTH是会根据屏幕大小改变的，所以重新定义一个全局变量用于背景缩放
RESOLUTION_WIDTH = 1280
RESOLUTION_HEIGHT = 800

-- auto scale mode
local glview = cc.Director:getInstance():getOpenGLView()
local size = glview:getFrameSize()
local w = size.width
local h = size.height
if w / h >= CONFIG_SCREEN_WIDTH / CONFIG_SCREEN_HEIGHT then
    CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
else
    CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
end

