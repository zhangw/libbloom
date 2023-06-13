local _M = { _VERSION = '1.0.0' }
local ffi = require "ffi"
ffi.cdef[[
  typedef long time_t;
  typedef struct timeval {
    time_t tv_sec;
    time_t tv_usec;
  } timeval;

  int gettimeofday(struct timeval* t, void* tzp);
]]

local function get_current_time_millis()
    local struct_tv = ffi.new("timeval")
    ffi.C.gettimeofday(struct_tv, nil)
    local tv_sec = tonumber(struct_tv.tv_sec)
    local tv_usec = tonumber(struct_tv.tv_usec)
    return tonumber(tv_sec) * 1000.0 + tonumber(tv_usec) / 1000.0
end

_M.get_current_time_millis = get_current_time_millis

local function random_str(length)
    math.randomseed(os.time())
    local alphabet = "abcdefghijklmnopqrstuvwxyz0123456789";
    local res = ""
    local n = #alphabet
    for i = 1, length do
        res = res .. string.char(string.byte(alphabet, math.random(n)))
    end
    return res
end

_M.random_str = random_str
return _M