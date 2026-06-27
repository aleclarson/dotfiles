return {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 999,
  config = function()
    require("everforest").setup({
      background = "soft",
      italics = true,
    })
  end,
}
