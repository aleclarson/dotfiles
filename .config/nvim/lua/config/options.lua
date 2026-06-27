vim.opt.relativenumber = false 
vim.opt.number = true
vim.opt.clipboard = "unnamedplus" 
vim.opt.cursorline = true 
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true 
vim.opt.scrolloff = 8 
vim.opt.wrap = false 

-- Display artifact test fixes: remove this block if these don't help.
-- Goal: hide non-file filler/whitespace characters that may appear after EOL.
vim.opt.list = false -- LazyVim enables this by default to show whitespace.
vim.opt.fillchars = {
  eob = " ",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  vert = " ",
  vertleft = " ",
  vertright = " ",
  verthoriz = " ",
}

vim.api.nvim_set_hl(0, "NonText", { link = "Normal" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { link = "Normal" })
-- End display artifact test fixes.
