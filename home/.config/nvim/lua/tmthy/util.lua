local M = {}

-- unpack a list-like table, and return all named keys as the
-- first return value
function M.named_unpack(t)
    local named = {}
    local unnamed = {}
    local last = 0
    for i, v in pairs(t) do
        if i == (last + 1) then
            unnamed[i] = v
            last = i
        else
            named[i] = v
        end
    end

    return named, table.unpack(unnamed)
end


return M
