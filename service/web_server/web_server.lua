package.path = package.path .. ";./service/?.lua;"
local skynet = require("skynet")
local service = require("skynet.service")
local socket = require "skynet.socket"
local logic = require("web_server.web_logic")
require("skynet.manager")
require("common.export")
require("core.define")

local command = {
    servertype = SERVICE_CONF.WEB.TYPE, -- 服务类型
    servername = SERVICE_CONF.WEB.NAME, -- 服务名
    port = 8000,                        -- 默认监听端口
    protocol = "http",                  -- 协议
    agents = {},                        -- agent
    balance = 1,
    socketid = -1,
    maxagent = 20,
}

-- 服务启动·接口
function command.START(port)
    assert(port ~= nil)
    assert(type(port) == "number")
    assert(port > 0)

    command.port = port

    math.randomseed(os.time())

    command._run()
    
    return 0
end

-- 服务停止·接口
function command.STOP()
    socket.close(command.socketid)
    return 0
end

-- 主业务
function command._run()
	for i= 1, command.maxagent do
		command.agents[i] = skynet.newservice("agent", command.protocol)
    end

    -- 监听端口
    command.socketid = socket.listen("0.0.0.0", command.port)
    
    skynet.error(string.format("Listen web port [" .. command.port .. "] protocol:%s", command.protocol))
    
    socket.start(command.socketid, function(id, addr)
        local agent = command.agents[command.balance]
        
        skynet.error(string.format("%s connected, pass it to agent :%08x", addr, agent))
        
        skynet.send(agent, "lua", id)

		command.balance = command.balance + 1
		if command.balance > #command.agents then
			command.balance = 1
		end
    end)
end

local function dispatch()
    skynet.dispatch(
        "lua",
        function(session, address, cmd, ...)
            cmd = cmd:upper()
            local f = command[cmd]
            assert(f)
            if f then
                skynet.ret(skynet.pack(f(...)))
            else
                skynet.error(string.format(command.servername .. " unknown command %s", tostring(cmd)))
            end
        end
    )

    skynet.register(command.servername)
end

skynet.start(dispatch)