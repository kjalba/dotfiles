---@diagnostic disable: undefined-global

local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  -- 1. Generic Code Block
  -- Trigger: type "cb" then hit expand
  s(
    'cb',
    fmt(
      [[
        ```{}
        {}
        ```
        ]],
      {
        i(1, 'lang'), -- First, you type the language (e.g., c, python)
        i(0), -- Then jump here to write the code
      }
    )
  ),

  -- 2. Python specific block
  -- Trigger: type "py" then hit expand
  s(
    'py',
    fmt(
      [[
        ```python
        {}
        ```
        ]],
      {
        i(0), -- Jumps immediately inside the block
      }
    )
  ),

  -- 3. C specific block
  -- Trigger: type "cc" then hit expand
  s(
    'cc',
    fmt(
      [[
        ```c
        {}
        ```
        ]],
      {
        i(0),
      }
    )
  ),
}
