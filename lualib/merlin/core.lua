
local utils = require 'merlin.utils'
--local db = require 'merlin.mysql'
local mysql = require "resty.mysql"
local cjson = require 'cjson'

local _M = {}
_M.name = "merlin core: " .. "coreName"


local function initConn()
    local db, err = mysql:new()
    if not db then
        ngx.say("failed to instantiate mysql: ", err)
        return nil,err
    end

    db:set_timeout(1000) -- 1 sec

    local ok, err, errcode, sqlstate = db:connect{
        host = "192.168.99.100",
        port = 32768,
        database = "mall",
        user = "root",
        password = "123456",
        charset = "utf8",
        max_packet_size = 1024 * 1024,
    }

    if not ok then
        ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
        return nil,err
    end
    return db,nil
end



function _M.query()
    local conn,err = initConn()
    if err ~= nil then
        ngx.say(err)
        return 
    end

    local res, err, errcode, sqlstate =
        conn:query("select * from mall_notice")
    if not res then
        ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
        return
    end
    local data = {}
    data.name = 'sss中文测试'
    data.content = res
    ngx.say("result: ", cjson.encode(data))
    --for i,v in pairs(res) do
    --        ngx.say(i ..': '.. v.title)
    --end
end


function _M.httpRequest()
    local http = require "http.http"
    local httpc = http.new()
    local res, err = httpc:request_uri("https://www.baidu.com/s?wd=a", {
        ssl_verify = false,
        method = "POST",
        body = "wd=a",
        headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        }
    })

    if not res then
        ngx.say("failed to request: ", err)
        return
    end

    -- In this simple form, there is no manual connection step, so the body is read
    -- all in one go, including any trailers, and the connection closed or keptalive
    -- for you.
    ngx.status = res.status

    for k,v in pairs(res.headers) do
            ngx.say(k .. ": " .. v)
    end
    ngx.say(res.body)
end

function _M.get_sum_result()
    local args = ngx.req.get_uri_args()
    return args.a + args.b
end

_M.utils = utils

return _M


