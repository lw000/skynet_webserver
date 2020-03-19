require("common.export")

-------------------------------------------------------------------------------------
SERVICE = {
    -- 服务器类型
    TYPE = {
        WEB     = 1,    -- WEB服务
        REDIS   = 2,    -- REDIS缓存服务
        DB      = 3,    -- DB服务
        LOG     = 4,    -- 日志服务
    },
    -- 服务名字
    NAME = {
        WEB     = ".web_server",        -- WEB服务
        REDIS   = ".redis_server",      -- REDIS缓存服务
        DB      = ".db_server",         -- DB服务
        LOG     = ".log_server",        -- 日志服务
    }
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

-- dump(SERVICE, "SERVICE")
-- dump(DB_CMD, "DB_CMD")
-- dump(LOG_CMD, "LOG_CMD")
-- dump(REDIS_CMD, "REDIS_CMD")
