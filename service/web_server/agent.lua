package.path = package.path .. ";./service/?.lua;"
package.path = package.path .. ";./service/web_server/?.lua;"
local skynet = require("skynet")
local service = require("skynet.service")
local socket = require("skynet.socket")
local httpd = require("http.httpd")
local sockethelper = require( "http.sockethelper")
local urllib = require("http.url")
local cjson = require("cjson")
local logic = require("web_logic")
require("skynet.manager")

local table = table
local string = string

local protocol = "http"

local function response(id, write, ...)
	local ok, err = httpd.write_response(write, ...)
	if not ok then
		-- if err == sockethelper.socket_error , that means socket closed.
		skynet.error(string.format("fd = %d, %s", id, err))
	end
end

local SSLCTX_SERVER = nil
local function gen_interface(protocol, fd)
	if protocol == "http" then
		return {
			init = nil,
			close = nil,
			read = sockethelper.readfunc(fd),
			write = sockethelper.writefunc(fd),
		}
	elseif protocol == "https" then
		local tls = require "http.tlshelper"
		if not SSLCTX_SERVER then
			SSLCTX_SERVER = tls.newctx()
			-- gen cert and key
			-- openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -keyout server-key.pem -out server-cert.pem
			local certfile = skynet.getenv("certfile") or "./server-cert.pem"
			local keyfile = skynet.getenv("keyfile") or "./server-key.pem"
			print(certfile, keyfile)
			SSLCTX_SERVER:set_cert(certfile, keyfile)
		end
		local tls_ctx = tls.newtls("server", SSLCTX_SERVER)
		return {
			init = tls.init_responsefunc(fd, tls_ctx),
			close = tls.closefunc(tls_ctx),
			read = tls.readfunc(fd, tls_ctx),
			write = tls.writefunc(fd, tls_ctx),
		}
	else
		error(string.format("invalid protocol: %s", protocol))
	end
end

local function dispatch()
    skynet.dispatch("lua", function (_, _, id)
		socket.start(id)
		local interface = gen_interface(protocol, id)
		if interface.init then
			interface.init()
		end
		-- limit request body size to 8192 (you can pass nil to unlimit)
		local code, url, method, header, body = httpd.read_request(interface.read, 8192)
		if code then
			if code ~= 200 then
				response(id, interface.write, code)
			else
				local tmp = {}
				if header.host then
					table.insert(tmp, string.format("host: %s", header.host))
				end
				
				local path, query = urllib.parse(url)
				table.insert(tmp, string.format("path: %s", path))
				if query then
					local q = urllib.parse_query(query)
					for k, v in pairs(q) do
						table.insert(tmp, string.format("query: %s= %s", k,v))
					end
				end

				table.insert(tmp, "-----header----")
				local tmp_header = {}
				for k,v in pairs(header) do
					table.insert(tmp, string.format("%s = %s",k,v))
					tmp_header[k] = v
				end
				table.insert(tmp, "-----body----\n" .. body)
				
				local logInfo = {
					clientIp= header.host,
					header= tmp_header,
					body= tmp or ""
				}
				logic.writeLog(logInfo)

				local jsonstr = cjson.encode(logInfo)

				-- response(id, interface.write, code, table.concat(tmp,"\n"))
				response(id, interface.write, code, jsonstr)
			end
		else
			if url == sockethelper.socket_error then
				skynet.error("socket closed")
			else
				skynet.error(url)
			end
		end
		socket.close(id)
		if interface.close then
			interface.close()
		end
    end)

    skynet.register(".agent")
end

skynet.start(dispatch)
