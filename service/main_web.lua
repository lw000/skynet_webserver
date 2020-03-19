package.path = ";./service/?.lua;" .. package.path
local skynet = require("skynet")
local conf = require("config.config")
require("common.export")

skynet.start(
    function()    
        local web_server = skynet.newservice("web_server")
        local ret, err = skynet.call(web_server, "lua", "start", conf.httpPort)
        if err ~= nil then
            skynet.error(ret, err)
            return
        end
        skynet.exit()
    end
)
