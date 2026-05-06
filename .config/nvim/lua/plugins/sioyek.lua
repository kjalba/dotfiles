local function open_in_sioyek()
  local pdf_path = vim.fn.expand '%:p:r' .. '.pdf'

  -- 1. Check if the PDF actually exists
  if vim.fn.filereadable(pdf_path) == 0 then
    print '⚠️ PDF not found! Ensure the file is compiled first.'
    return
  end

  -- 2. Use the modern async system call
  vim.system({ 'sioyek', '--reuse-window', pdf_path }, { detach = true }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        print("❌ Sioyek Error: Make sure 'sioyek' is in your $PATH. Code: " .. obj.code)
      end)
    end
  end)
end

-- Global Keymap
-- Notice we removed `buffer = true` so it works anywhere in Neovim
vim.keymap.set('n', '<leader>dr', open_in_sioyek, { silent = true, desc = '[D]ocument [R]ead (Sioyek)' })
