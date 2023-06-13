local bloom = require "bloom"
bloom.show_bloom_ver()
local verbose_add_and_check = function (bloom_instance, key)
    local ok, err = bloom_instance:add(key)
    if ok then
        print("key: "..key.." been added!")
    end
    if err then
        print("key: "..key.." failed to add!!")
    end
    ok, err = bloom_instance:check(key)
    if not err then
        if ok then
            print("key: "..key.." been presented!")
        else
            print("key: "..key.." not been presented!")
        end
    else
        print("key: "..key.." failed to check!!")
    end
end
local bloom_foo = bloom.new(1000, 0.1)
local key1 = "hello bloom!"
verbose_add_and_check(bloom_foo, key1)