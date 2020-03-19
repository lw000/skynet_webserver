# skynet_webserver

# web服务器：

## 说明
    1. 该程序单节点部署，内部包含（WEB服务，日志服务，REDIS服务，DB服务）子服务。
    2. WEB服务，记录日志发送到log服务，log服务根据业务类型，转发到redis服务或者db服务。
    3. redis服务负责数据存储到redis, redis服务定时把数据同步到DB服务。
    4. db服务负责数据存储到到mysql。

## 部署
    1. 安装redis
    2. 导入数据库脚本sql/webserver.sql

##  启动
    cd skynet_webserver
    bin/skynet conf/config

## 代码结构

##### 1. main.lua     -- 单节点服务启动入口

##### .
##### ├── common
##### │   ├── core.lua
##### │   ├── dump.lua
##### │   ├── export.lua
##### │   ├── function.lua
##### │   ├── trackback.lua
##### │   └── utils.lua
##### ├── config
##### │   └── config.lua
##### ├── core
##### │   └── define.lua
##### ├── db_server
##### │   ├── database
##### │   │   └── database.lua
##### │   ├── db_logic.lua
##### │   ├── db_manager.lua
##### │   └── db_server.lua
##### ├── log_server
##### │   ├── log_logic.lua
##### │   ├── log_manager.lua
##### │   └── log_server.lua
##### ├── main_db.lua
##### ├── main_log.lua
##### ├── main.lua
##### ├── main_redis.lua
##### ├── main_web.lua
##### ├── network
##### │   ├── packet.lua
##### │   └── ws.lua
##### ├── redis_server
##### │   ├── redis_logic.lua
##### │   ├── redis_manager.lua
##### │   └── redis_server.lua
##### ├── skycommon
##### │   └── helper.lua
##### └── web_server
#####     ├── agent.lua
#####     ├── web_logic.lua
#####     └── web_server.lua