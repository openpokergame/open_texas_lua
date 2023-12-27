-- 框架代码
require("framework.init")

-- 兼容lua string.format 对boolean不支持, 而luajit支持boolean
do
  local strformat = string.format
  function string.format(format, ...)
    local args = {...}
    local match_no = 1
    for pos, type in string.gmatch(format, "()%%.-(%a)") do
      if type == 's' then
        args[match_no] = tostring(args[match_no])
      end
      match_no = match_no + 1
    end
    return strformat(format,
      unpack(args,1,select('#',...)))
  end
end

local CURRENT_MODULE_NAME = ...

local sa         = sa or {}
_G.sa            = sa
sa.PACKAGE_NAME  = string.sub(CURRENT_MODULE_NAME, 1, -6)
sa.Logger        = import(".util.Logger")
sa.HttpService   = import(".http.HttpService")
sa.ImageLoader   = import(".http.ImageLoader")
sa.SocketService = import(".socket.SocketService")
sa.EventCenter   = import(".event.EventCenter")
sa.DataProxy     = import(".proxy.DataProxy")
sa.LangUtil      = import(".lang.LangUtil")
sa.TouchHelper   = import(".util.TouchHelper")
sa.ObjectPool    = import(".util.ObjectPool")
sa.SchedulerPool = import(".util.SchedulerPool")
sa.ui            = import(".ui.init")
sa.TimeUtil      = import(".util.TimeUtil")
sa.DisplayUtil   = import("openpoker.util.DisplayUtil")

import(".util.functions").exportMethods(sa)
import(".functions")
return sa
