---
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.svg')
---

# Fluent-bit + Lua

An introduction on how to use Lua with Fluent-bit

---

### Lua programming language

- Dynamically typed
- Simple, but powerful syntax
- Multiple programming paradigms (object-oriented, functional...)
- Efficient, faster than most scripting languages
- Embeddable, widely used as scripting language for games
- Few batteries included

---

### LuaJIT

- Alternative implementation of Lua 5.1
- JIT compiles Lua to machine code
- A very fast scripting language implementation
- Used by Fluent-bit

---

### Basic data types

```lua
a_boolean = true -- booleans
a_number = 5.3  -- numbers, which are represented by double-precision floating points
a_string = 'some string'  -- strings which are 8-bit clean, may be enclosed in single quotes
a_string_2 = "some string" -- or double quotes
multiline_string = [[this
is a
multiline string
]]  -- multline strings are enclosed by "[[" and "]]"
if a_boolean then
  print(multiline_string)
end
if a_number > 6 or a_string:len() > 1 then
  print(('This is a string: "%s". This is a number: %d'):format(a_string, a_number))
  -- prints: This is a string: "some string". This is a number: 5
end
```
---

### Tables

```lua
empty = { }
list = { 'one', 'two', 'three' }
-- append an item at the end of the list:
table.insert(list, 'four')
-- iterate
for index, item in ipairs(list) do
  print(index, item)
end
map = { name = 'Lua', type = 'programming language' }
-- assign an arbitrary key/value to a table:
map.version = '5.1'
-- iterate over keys/values
for key, value in pairs(map) do
  print(('key: %s, value: %s'):format(key, value))
end
```
---

### Function definitions

```lua
-- define a function to compute factorial of number and print fact(5) 
function fact (n)
  if n == 0 then
    return 1
  else
    return n * fact(n-1)
  end
end
print(fact(5))
```

---

### Luarocks

- Package manager for Lua
- Allows easy installation of popular Lua modules 

Example:

```sh
sudo luarocks install inspect
```

Modules are importable through the "require" function

```lua
-- use the "inspect" module:
local inspect = require('inspect')
print(inspect({ 1, 2, { 4, 5 } }))
```

---

### Fluent-bit Lua filters

<br />

- Full power of Lua to transform fluent-bit records
- Modify records based on any criteria
- Split/drop records
- Luarocks packages available through "require"

---

### Example

```lua
-- log.lua
local inspect = require('inspect')

function handler(tag, timestamp, record)
  print(inspect(record))
  -- returning "0" means the record will not be modified
  return 0, timestamp, record
end
```

Run with:

```sh
fluent-bit -i cpu -F lua -m '*' -p script=log.lua -p call=handler -o null
```

---

### Example

```lua
-- csv_simple.lua
function handler(tag, timestamp, record)
  local fields = {}
  for field in record.log:gmatch('[^,]+') do
    table.insert(fields, field)
  end
  -- return "2" to only modify the record and leave timestamp untouched
  return 1, 0, { fields = fields }
end
```

Run with:

```sh
fluent-bit -i tail -p read_from_head=true -p exit_on_eof=true -p path=cities.csv -F lua -m '*' -p script=csv_simple.lua -p call=handler -o stdout
```

---

### More information:

- Lua 5.1 reference manual: https://www.lua.org/manual/5.1/
- Programming in Lua: https://www.lua.org/pil/
- Fluent-bit manual: https://docs.fluentbit.io/manual
