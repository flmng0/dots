local wk = require("which-key")
wk.add({{"<leader>f", group = "Finders"}, {"<leader>c", group = "Code Actions"}, {"<leader>d", group = "Debugging"}})
do
  local wk_8_auto = require("which-key")
  wk_8_auto.add({{"<Esc>", "<Cmd>nohl<CR>", desc = "Clear highlight", mode = "n"}, {"U", "<C-r>", desc = "Redo", mode = "n"}})
end
do
  local wk_8_auto = require("which-key")
  local function _1_()
    return require("fzf-lua").files()
  end
  local function _2_()
    return require("fzf-lua").helptags()
  end
  local function _3_()
    return require("fzf-lua").keymaps()
  end
  local function _4_()
    return require("fzf-lua").oldfiles()
  end
  local function _5_()
    return require("fzf-lua").live_grep()
  end
  wk_8_auto.add({{"<leader><space>", _1_, desc = "Fuzzy find files", mode = "n"}, {"<leader>fh", _2_, desc = "Search help pages", mode = "n"}, {"<leader>fk", _3_, desc = "Search key mappings", mode = "n"}, {"<leader>fr", _4_, desc = "Search recently opened files", mode = "n"}, {"<leader>/", _5_, desc = "Live grep", mode = "n"}})
end
do
  local wk_8_auto = require("which-key")
  local function _6_()
    return require("oil").open()
  end
  local function _7_()
    return require("conform").format()
  end
  wk_8_auto.add({{"-", _6_, desc = "Open Oil.nvim in current directory", mode = "n"}, {"<leader>cf", _7_, desc = "Format current file", mode = "n"}})
end
local function lsp_attach(_8_)
  local buf = _8_["buf"]
  local wk_8_auto = require("which-key")
  local function _9_()
    return require("fzf-lua").lsp_references()
  end
  local function _10_()
    return require("fzf-lua").lsp_type_definitions()
  end
  local function _11_()
    return require("fzf-lua").lsp_definitions()
  end
  local function _12_()
    return require("fzf-lua").lsp_document_symbols()
  end
  local function _13_()
    return require("fzf-lua").lsp_workspace_symbols()
  end
  return wk_8_auto.add({{"<leader>ca", vim.lsp.buf.code_action, buffer = buf, desc = "[LSP] List code actions", mode = "nv"}, {"<leader>cr", vim.lsp.buf.rename, buffer = buf, desc = "[LSP] Rename symbol", mode = "n"}, {"gr", _9_, buffer = buf, desc = "[LSP] Goto or find symbol's references", mode = "n"}, {"gt", _10_, buffer = buf, desc = "[LSP] Goto or find symbol's type definition", mode = "n"}, {"gd", _11_, buffer = buf, desc = "[LSP] Goto or find symbol's definition", mode = "n"}, {"gD", vim.lsp.buf.declaration, buffer = buf, desc = "[LSP] Goto symbol declaration", mode = "n"}, {"<leader>fs", _12_, buffer = buf, desc = "[LSP] Find symbols in current document", mode = "n"}, {"<leader>fw", _13_, buffer = buf, desc = "[LSP] Find symbols in workspace", mode = "n"}})
end
local group = vim.api.nvim_create_augroup("tmthy.keys.lsp", {clear = true})
return vim.api.nvim_create_autocmd("LspAttach", {group = group, callback = lsp_attach})