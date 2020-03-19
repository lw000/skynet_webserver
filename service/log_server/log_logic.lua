local skynet = require("skynet")
local cjson = require("cjson")
local skyhelper = require("skycommon.helper")
require("common.export")
require("core.define")

local logic = {

}

-- 记录请求日志
function logic.onWriteLog(content)
    skyhelper.sendLocal(SERVICE_CONF.REDIS.NAME, "message", REDIS_CMD.MDM_REDIS, REDIS_CMD.SUB_LOG, content)
end

return logic