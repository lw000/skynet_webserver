local skynet = require("skynet")
local cjson = require("cjson")
local skyhelper = require("skycommon.helper")
require("common.export")
require("core.define")

local logic = {}

-- 写日志
function logic.writeLog(content)
    assert(content ~= nil)
    skyhelper.sendLocal(SERVICE.NAME.LOG, "message", LOG_CMD.MDM_LOG, LOG_CMD.SUB_LOG, content)
end

return logic