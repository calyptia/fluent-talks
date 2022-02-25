local lpeg = require('lpeg')

-- example CSV grammar from http://www.inf.puc-rio.br/~roberto/lpeg/#CSV
local csv_field = '"' * lpeg.Cs(((lpeg.P(1) - '"') + lpeg.P'""' / '"')^0) * '"' +
                        lpeg.C((1 - lpeg.S',\n"')^0)
local csv_record = csv_field * (',' * csv_field)^0 * (lpeg.P'\n' + -1)

local headers

function process_record(tag, timestamp, record)
    if not headers then
      headers = { lpeg.match(csv_record, record.log) }
      -- return -1 to drop the header
      return -1, timestamp, record
    end
    local data = {}
    local fields = { lpeg.match(csv_record, record.log) }
    for index, header in ipairs(headers) do
      data[header] = fields[index]
    end
    -- return "2" to leave timestamp intact
    return 2, 0, data
end
