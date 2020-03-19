require("common.export")

-- -------------------------------------------------------------------------------------
-- 服务配置
SERVICE_CONF = {
    WEB =   { TYPE= 1, NAME= ".web_server",      DESC= "web服务器" },
    REDIS = { TYPE= 2, NAME= ".redis_server",    DESC= "缓存服务器" },
    DB =    { TYPE= 3, NAME= ".db_server",       DESC= "数据服务器" },
    LOG =   { TYPE= 4, NAME= ".log_server",      DESC= "日志服务器" },
}

-- 服务内部协议指令
-------------------------------------------------------------------------------------
-- REDIS服务·命令
REDIS_CMD = {
    MDM_REDIS = 0x0002,                         -- REDIS服务·主命令
    SUB_LOG = 0x0001,                           -- 请求日志
}

-- DB服务·命令
DB_CMD = {
    MDM_DB = 0x0003,                            -- DB服务·主命令
    SUB_LOG = 0x0001,                           -- 请求日志
}

-- 日志服务·命令
LOG_CMD = {
    MDM_LOG = 0x0004,                           -- 日志服务·主命令
    SUB_LOG = 0x0001,                           -- 请求日志
}

-- dump(DB_CMD, "DB_CMD")
-- dump(LOG_CMD, "LOG_CMD")
-- dump(REDIS_CMD, "REDIS_CMD")
-- dump(SERVICE_CONF, "SERVICE_CONF")