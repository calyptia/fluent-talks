local inspect = require('inspect')

function handler(tag, timestamp, record)
  print(inspect(record))
end
