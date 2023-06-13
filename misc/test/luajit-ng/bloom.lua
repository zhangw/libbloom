local ffi = require "ffi"
local bl = ffi.load('bloom')
local ffi_str = ffi.string
local ffi_new = ffi.new
local ffi_gc = ffi.gc
local type = type
local tostring = tostring
local error = error
local setmetatable = setmetatable

local bloom_init
local bloom_version
local bloom_free
local bloom_add
local bloom_check
ffi.cdef[[
    struct bloom
    {
        unsigned int entries;
        unsigned long int bits;
        unsigned long int bytes;
        unsigned char hashes;
        double error;
        unsigned char ready;
        unsigned char major;
        unsigned char minor;
        double bpe;
        unsigned char * bf;
    };
    int bloom_init2(struct bloom * bloom, unsigned int entries, double error);
    void bloom_free(struct bloom * bloom);
    int bloom_add(struct bloom * bloom, const void * buffer, int len);
    int bloom_check(struct bloom * bloom, const void * buffer, int len);
    const char * bloom_version();
]]
bloom_init = bl.bloom_init2
bloom_free = bl.bloom_free
bloom_add = bl.bloom_add
bloom_check = bl.bloom_check
bloom_version = bl.bloom_version
local _M = { _VERSION = '1.0.0' }
local mt = { __index = _M }

_M.show_bloom_ver = function ()
    local ver = ffi_str(bloom_version())
    print("ffi bloom version: "..ver)
end

_M.new = function (entries, false_positive_error)
    local bloom_obj = ffi_new("struct bloom[1]")
    local ret = bloom_init(bloom_obj, entries, false_positive_error)
    if ret ~= 0 then
        error("bloom init failed", 2)
    end
    ffi_gc(bloom_obj, bloom_free)
    return setmetatable({ bloom_obj = bloom_obj }, mt)
end

local check_instance = function (self)
    if type(self) ~= "table" or type(self.bloom_obj) ~= "cdata" then
        error("invalid bloom instance", 2)
    end
end

local check_key = function (s)
    if type(s) ~= 'string' then
        if not s then
            return ''
        else
            return tostring(s)
        end
    end
    return s
end

_M.add = function (self, key)
    check_instance(self)
    local obj = self.bloom_obj
    local key_str = check_key(key)
    local ret = bloom_add(obj, key_str, #key_str)
    if ret ~= -1 then
        return true
    else
        return nil, "add failed"
    end
end

_M.check = function (self, key)
    check_instance(self)
    local obj = self.bloom_obj
    local key_str = check_key(key)
    local ret = bloom_check(obj, key_str, #key_str)
    if ret == 0 then
        return false
    end
    if ret == 1 then
        return true
    end
    return nil, "check failed"
end

return _M