-- trying to issue Segmentation fault
-- TODO: it seems the gc will cause carsh
-- collectgarbage("stop")
-- jit.off()
local util = require "util"
local bloom = require "bloom"
local check_set_benchmark = function (entries, e)
    local key = util.random_str(64)
    local bloom_instance = bloom.new(entries, e)
    print("===entries: ".. entries .. " error: "..e)
    local begin = util.get_current_time_millis()
    for j = 1, entries, 1 do
        local ok, err = bloom_instance:add(key)
        if err then
            error("fatal error when add", 2)
        end
    end
    local ended = util.get_current_time_millis()
    print("add cost ms: " .. (ended - begin))
    begin = util.get_current_time_millis()
    for k = 1, entries, 1 do
        local existed, err = bloom_instance:check(key)
        if err then
            error("error when check", 2)
        end
    end
    ended = util.get_current_time_millis()
    print("check cost ms: " .. (ended - begin))
end

for i = 1, 10, 1 do
    check_set_benchmark(100000, 0.01)
    check_set_benchmark(100000, 0.001)

    check_set_benchmark(1000000, 0.01)
    check_set_benchmark(1000000, 0.001)

    check_set_benchmark(10000000, 0.01)
    check_set_benchmark(10000000, 0.001)

    check_set_benchmark(100000000, 0.01)
    check_set_benchmark(100000000, 0.001)
    -- trying to verify if the bloom gc crashed would be fixed
    collectgarbage("collect")
end