local map = vim.keymap.set

-- Emacs style line navigation in insert mode
map("i", "<C-a>", "<Home>", { desc = "Move to start of line" })
map("i", "<C-e>", "<End>", { desc = "Move to end of line" })

-- VS CODE FAMILIARITY LAYER

-- File Explorer (Ctrl+b)
map("n", "<C-b>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })

-- Save (Ctrl+s)
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Delete Word (Ctrl+d)
map("n", "<C-d>", "diw", { desc = "Delete inner word" })

-- Find Files (Ctrl+p)
map("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })

-- Global Search (Ctrl+Shift+f)
map("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Global Search" })
map("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Global Search" })

-- Toggle Terminal (Ctrl+j)
map("n", "<C-j>", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle Terminal" })
map("t", "<C-j>", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle Terminal" })

-- Comments (Ctrl+/)
map("n", "<C-_>", "gcc", { remap = true, desc = "Comment Line" })
map("v", "<C-_>", "gc", { remap = true, desc = "Comment Selection" })
map("n", "<C-/>", "gcc", { remap = true, desc = "Comment Line" })
map("v", "<C-/>", "gc", { remap = true, desc = "Comment Selection" })

-- Move Lines (Alt + Up/Down)
map("n", "<M-Down>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<M-Up>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<M-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<M-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<M-Down>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<M-Up>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Word Navigation (Alt + Left/Right)
map({ "n", "v", "o" }, "<M-Left>", "b", { desc = "Move back a word" })
map({ "n", "v", "o" }, "<M-Right>", "w", { desc = "Move forward a word" })
map("i", "<M-Left>", "<C-o>b", { desc = "Move back a word" })
map("i", "<M-Right>", "<C-o>w", { desc = "Move forward a word" })
map("c", "<M-Right>", "<S-Right>", { desc = "Move forward a word in command" })
map("c", "<M-Left>", "<S-Left>", { desc = "Move back a word in command" })

-- Manual Terminal Escape Sequence Overrides (Fix for Cursor/VS Code)
map({ "n", "v", "o" }, "<M-f>", "w", { desc = "Move forward a word" })
map({ "n", "v", "o" }, "<M-b>", "b", { desc = "Move back a word" })
map("i", "<M-f>", "<C-o>w", { desc = "Move forward a word" })
map("i", "<M-b>", "<C-o>b", { desc = "Move back a word" })
map("c", "<M-f>", "<S-Right>", { desc = "Move forward a word in command" })
map("c", "<M-b>", "<S-Left>", { desc = "Move back a word in command" })

-- No Highlight (Esc)
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "No Highlight" })

-- LSP rename
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
