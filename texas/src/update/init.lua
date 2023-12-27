local upd = {}

require("update.functions").exportMethods(upd)

upd.conf = require("update.updateConfig")
upd.lang = require("update.LangUtil")
upd.http = require("update.UpdateHttpService")


return upd