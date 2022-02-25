function handler(tag, timestamp, record)
  local fields = {}
  for field in record.log:gmatch('[^,]+') do
    table.insert(fields, field)
  end
  -- return "2" to only modify the record and leave timestamp untouched
  return 1, 0, { fields = fields }
end
