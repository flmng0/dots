return {
  "hrsh7th/nvim-cmp",

  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    opts.completion.completeopt = "menu,menuone,noinsert,noselect"

    opts.preselect = cmp.PreselectMode.None

    opts.mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = function(fallback)
        if cmp.get_active_entry() then
          fallback()
          return
        end

        if not cmp.visible() then
          cmp.complete({ reason = cmp.ContextReason.Manual })
        end
        cmp.select_next_item({ behaviour = cmp.SelectBehavior.Select })
      end,

      ["<Tab>"] = function(fallback)
        local active = cmp.get_active_entry()

        if active == nil then
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
          return
        end

        local entries = cmp.get_entries()
        local length = #entries

        if active == entries[length] then
          cmp.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
            count = length - 1,
          })
        else
          cmp.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
          })
        end
      end,

      ["<S-Tab>"] = function(fallback)
        local active = cmp.get_active_entry()

        if active == nil then
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
          return
        end

        local entries = cmp.get_entries()
        local length = #entries

        if active == entries[1] then
          cmp.select_next_item({
            behavior = cmp.SelectBehavior.Insert,
            count = length - 1,
          })
        else
          cmp.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
          })
        end
      end,

      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),

      ["<CR>"] = cmp.mapping.confirm({
        behaviour = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
    })
  end,
}
