return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      
      -- Setup fallback formatting: first oxfmt, then prettier. 
      -- oxfmt is the actual formatter for oxlint.
      opts.formatters_by_ft.javascript = { "oxfmt", "prettier", stop_after_first = true }
      opts.formatters_by_ft.typescript = { "oxfmt", "prettier", stop_after_first = true }
      opts.formatters_by_ft.javascriptreact = { "oxfmt", "prettier", stop_after_first = true }
      opts.formatters_by_ft.typescriptreact = { "oxfmt", "prettier", stop_after_first = true }
    end,
  },
}

