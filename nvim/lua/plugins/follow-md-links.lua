return {
  "jghauser/follow-md-links.nvim",
  keys = {
    { "<bs>", "<cmd>edit #<cr>", desc = "Go back to previous file" },
  },
  config = function()
    -- Maps Enter to follow the link under the cursor
    vim.keymap.set("n", "<CR>", ":FollowLink<CR>", { silent = true })
  end
}
