
local _M = {}

local digest = ngx.md5(str)

_M.name = "merlin-utils: " .. digest

function _M.alert_msg(msg)
    ngx.say("merlin-utils: msg " .. msg)
end

--ngx.header["Trace-ID"] = ngx.md5('123456')
--ngx.header['Set-Cookie'] = {'a=32; path=/', 'b=4; path=/'}
function _M.setHeader(key,val)
    ngx.header[key] = val
end

return _M