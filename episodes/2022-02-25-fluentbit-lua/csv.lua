local dquote = ('"'):byte()

local function extract_simple(record, start)
    local index = record:find(',', start)
    local stop_index
    local next_offset
    if index ~= nil then
        stop_index = index - 1
        next_offset = index + 1
    end
    return start, stop_index, next_offset
end

local function extract_quoted(record, start)
    start = start + 1
    local offset = start
    while true do
        local index = record:find('"', offset)
        local next_index = index + 1
        local next_byte = record:byte(next_index)
        if next_byte ~= dquote then
            -- found the end index of the field, return it
            return start, index - 1, index + 2
        end 
        offset = index + 2 -- advance both dquotes
    end
end

local function split_csv(record)
    local rv = {}
    local offset = 1
    while offset ~= nil do
        local start_idx
        local stop_idx
        if record:byte(offset) == dquote then
            start_idx, stop_idx, offset = extract_quoted(record, offset)
        else
            start_idx, stop_idx, offset = extract_simple(record, offset)
        end
        table.insert(rv, record:sub(start_idx, stop_idx))
    end
    return rv
end

-- declare a module variable to hold header
local headers

function process_record(tag, timestamp, record)
    if not headers then
      headers = split_csv(record.log)
      -- return -1 to drop the header
      return -1, timestamp, record
    end
    local data = {}
    local fields = split_csv(record.log)
    for index, header in ipairs(headers) do
      data[header] = fields[index]
    end
    -- return "1" to modify timestamp
    return 1, 0, data
end
