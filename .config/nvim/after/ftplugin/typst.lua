-- 1. SET EDITOR OPTIONS
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-------------------------------------------------------------------------------
-- 2. HELPER FUNCTIONS (GIT ROOT & WATCH)
-------------------------------------------------------------------------------

local function get_git_root()
  local dot_git = vim.fn.finddir('.git', '.;')
  if dot_git ~= '' then
    return vim.fn.fnamemodify(dot_git, ':h')
  end
  return vim.fn.getcwd()
end

local function typst_watch()
  local root = get_git_root()
  local current_file = vim.fn.expand '%'

  -- Open a vertical split on the right
  vim.cmd 'botright vsplit'
  vim.cmd 'vertical resize 30'

  -- Run the watch command in a terminal buffer
  -- We use shellescape to handle spaces in filenames
  local cmd = 'typst watch --root ' .. root .. ' ' .. vim.fn.shellescape(current_file)
  vim.cmd('term ' .. cmd)

  -- Move cursor back to the main editor window
  vim.cmd 'wincmd h'
end

-------------------------------------------------------------------------------
-- 3. EXPORT LOGIC
-------------------------------------------------------------------------------
local export_types = { 'pdf', 'png', 'svg', 'html' }

local function export(args)
  local target
  if vim.tbl_contains(export_types, args[1]) then
    target = args[1]
  elseif args[1] == nil then
    target = 'pdf'
  else
    print "Unsupported filetype. Use 'pdf' or 'png'."
    return
  end

  local filetype = vim.bo.filetype
  if filetype ~= 'typst' then
    print 'Current buffer is not a typst file'
    return
  end

  local current_file = vim.fn.expand '%:p'
  local cmd = 'typst compile --format ' .. target .. ' ' .. vim.fn.shellescape(current_file)

  print('Running: ' .. cmd)
  vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    print 'Typst compilation failed.'
  else
    print('Successfully exported to ' .. target)
  end
end

-------------------------------------------------------------------------------
-- 4. TELESCOPE PICKER LOGIC
-------------------------------------------------------------------------------
local function export_picker()
  local filetype = vim.bo.filetype
  if filetype ~= 'typst' then
    print 'Current buffer is not a typst file'
    return
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = 'Select Export Format',
      finder = finders.new_table {
        results = export_types,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          export { selection[1] }
        end)
        return true
      end,
    })
    :find()
end

-------------------------------------------------------------------------------
-- 5. COMMANDS & KEYMAPS
-------------------------------------------------------------------------------

-- Commands
vim.api.nvim_create_user_command('Export', export, {
  nargs = '?',
  complete = function()
    return export_types
  end,
})
vim.api.nvim_create_user_command('ExportPicker', export_picker, {})

-- Keymaps
local opts = { buffer = true, silent = true }

-- Preview (Plugin-based)
vim.keymap.set('n', '<leader>dp', ':TypstPreview<CR>', vim.tbl_extend('force', opts, { desc = '[P]review Typst [D]ocument' }))

-- Export Picker
vim.keymap.set('n', '<leader>de', ':ExportPicker<CR>', vim.tbl_extend('force', opts, { desc = '[E]xport [D]ocument' }))

-- Watch in side terminal
vim.keymap.set('n', '<leader>dw', typst_watch, vim.tbl_extend('force', opts, { desc = '[D]ocument [W]atch' }))

