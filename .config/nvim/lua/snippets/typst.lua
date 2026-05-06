local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local line_begin = require('luasnip.extras.expand_conditions').line_begin

-- ----------------------------------------------------------------------------
-- HELPERS
-- ----------------------------------------------------------------------------

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

local function in_math()
  return vim.api.nvim_eval 'typst#in_math()' == 1
end

-- ----------------------------------------------------------------------------
-- SNIPPETS (Expanded with Tab)
-- ----------------------------------------------------------------------------

local snippets = {
  -- --- MARKUP / TEXT SNIPPETS ---

  s(
    { trig = 'def', name = 'Definition Box' },
    fmta(
      [[
  #definition("<>")[
    <>
  ]
  <>]],
      { i(1, 'Title'), i(2, 'Content'), i(0) }
    ),
    { condition = line_begin }
  ),

  s(
    { trig = 'ex', name = 'Example Box' },
    fmta(
      [[
  #example("<>")[
    <>
  ]
  <>]],
      { i(1, 'Example Title'), i(2, 'Content'), i(0) }
    ),
    { condition = line_begin }
  ),

  -- FIXED: Escaped the literal Typst label brackets with << and >>
  s(
    { trig = 'fig', name = 'Code Figure' },
    fmta(
      [[
  figure(
    caption: [<>],
  )[
  ```<>
  <>

] <<fcode-<>>>]],
      { i(1, 'caption'), i(2, 'asm'), i(3, 'code'), i(4, 'label') }
    ),
    { condition = line_begin }
  ),

  -- --- MATH SNIPPETS ---

  s({ trig = '//', name = 'Fraction' }, fmta([[(<>)/(<>) <>]], { i(1, 'num'), i(2, 'den'), i(0) }), { condition = in_math }),

  s({ trig = 'sum', name = 'Summation' }, fmta([[sum_(n=<>)^(<>) <>]], { i(1, '0'), i(2, 'infinity'), i(0) }), { condition = in_math }),

  -- --- HPCA SPECIFIC ---

  s({ trig = 'cpif', name = 'CPI Formula' }, t 'CPI = ("Execution Cycles") / ("Instruction Count")', { condition = in_math }),

  s({ trig = 'pipe', name = 'MIPS Pipeline' }, t '#pipeline(("IF", "ID", "EX", "MEM", "WB"))'),

  s({ trig = 'amdahl', name = "Amdahl's Law" }, t 'S_("latency") = 1 / ((1 - f) + f/s)', { condition = in_math }),
}

-- AUTO-SNIPPETS (Expand Instantly)

local autosnippets = {
  -- mk -> ...
  s({ trig = 'mk', name = 'Inline Math' }, fmta([[<> <>]], { i(1), i(0) })),

  -- dm -> display math block
  s(
    { trig = 'dm', name = 'Block Math' },
    fmta(
      [[
<>

<>
]],
      { i(1), i(0) }
    ),
    { condition = line_begin }
  ),

  -- Auto Subscript: (e.g. x1 -> x_1)
  s(
    { trig = '([%a])(%d)', regTrig = true, name = 'Auto Subscript' },
    f(function(args, snip)
      return snip.captures[1] .. '_' .. snip.captures[2]
    end),
    { condition = in_math }
  ),

  s({ trig = 'sq', name = 'Squared' }, t '^2 ', { condition = in_math }),
  s({ trig = 'cb', name = 'Cubed' }, t '^3 ', { condition = in_math }),
  s({ trig = 'inv', name = 'Inverse' }, t '^(-1) ', { condition = in_math }),

  s({ trig = '==', name = 'Aligned Equals' }, t '&= ', { condition = in_math }),
  s({ trig = '=>', name = 'Implies' }, t 'arrow.r ', { condition = in_math }),
  s({ trig = '...', name = 'Dots' }, t 'dots.h '),
}

return snippets, autosnippets
