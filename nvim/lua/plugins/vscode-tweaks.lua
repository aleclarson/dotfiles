return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>", 
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    cmd = "ToggleTerm",
    keys = { { "<C-j>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" } },
  }
}
