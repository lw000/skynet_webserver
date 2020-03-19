package.path = ";./service/?.lua;" .. package.path
local skynet = require("skynet")
local dns = require("skynet.dns")
local datacenter = require("skynet.datacenter")
local conf = require("config.config")
require("common.export")

-- local resolve_list = {
-- 	"github.com",
-- 	"stackoverflow.com",
--     "lua.com",
--     "www.baidu.com",
-- }

skynet.start(
    function()
        -- datacenter.set("debug", 1)
        -- datacenter.set("release", 0)
        -- datacenter.set("config", {
        --     debug = 1,
        --     release = 0,
        -- })

        -- for _ , name in ipairs(resolve_list) do
        --     local ip, ips = dns.resolve(name)
        --     for k,v in ipairs(ips) do
        --         print(name,v)
        --     end
        --     skynet.sleep(500)	-- sleep 5 sec
        -- end

        -- 0. DEBUG服务
        skynet.newservice("debug_console", conf.debug_port)
        
         -- 1. LOG服务
        local log_server = skynet.newservice("log_server")
        local ret, err = skynet.call(log_server, "lua", "start")
        if err ~= nil then
            skynet.error(ret, err)
            return
        end

        -- 2. DB服务器
        local db_server = skynet.newservice("db_server")
        local ret, err = skynet.call(db_server, "lua", "start", conf.db)
        if err ~= nil then
            skynet.error(ret, err)
            return
        end

        -- 3. REDIS服务器
        local redis_server = skynet.newservice("redis_server")
        local ret, err = skynet.call(redis_server, "lua", "start", conf.redis)
        if err ~= nil then
            skynet.error(ret, err)
            return
        end

        -- 4. WEB服务器
        local web_server = skynet.newservice("web_server")
        local ret, err = skynet.call(web_server, "lua", "start", conf.httpPort)
        if err ~= nil then
            skynet.error(ret, err)
            return
        end

        skynet.exit()
    end
)
