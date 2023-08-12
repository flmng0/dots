return {
  "echasnovski/mini.files",
  opts = {
    options = {
      use_as_default_explorer = true,
    },
  },
  keys = {
    {
      "<leader>E",
      function()
        require("mini.files").open(nil, false)
      end,
      desc = "Opem mini.files in CWD",
    },
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files local to file",
    },
  },
}
