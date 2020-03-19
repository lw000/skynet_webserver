package.path = package.path .. ";./service/?.lua;"
package.path = package.path .. ";./service/web_server/?.lua;"
local skynet = require("skynet")
local service = require("skynet.service")
local socket = require "skynet.socket"
local logic = require("web_logic")
require("skynet.manager")
require("common.export")
require("core.define")

local command = {
    servertype = SERVICE.TYPE.WEB,      -- 服务类型
    servername = SERVICE.NAME.WEB,  	-- 服务名
    running = false,                    -- 服务器状态
    port = 8000,                        -- 默认监听端口
    protocol = "http",                  -- 协议
    agents = {},                        -- agent
    balance = 1,
    socketid = -1,
}

-- 服务启动·接口
function command.START(port)
    assert(port ~= nil)
    assert(type(port) == "number")
    assert(port > 0)

    command.port = port

    math.randomseed(os.time())

    command.running = true  -- 服务器状态

    command._run()
    
    return 0
end

-- 服务停止·接口
function command.STOP()
    command.running = false
    socket.close(command.socketid)
    return 0
end

-- 主业务
function command._run()
	for i= 1, 20 do
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