local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

-- Autocomplete
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert"
  },
  preselect = "item",

  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer",  keyword_length = 3 },
    { name = "path",    option = { trailing_slash = true, label_trailing_slash = true } },
    { name = "rg",      keyword_length = 2 },
  },

  mapping = cmp.mapping.preset.insert({
    -- Navigate suggestions.
    ["<Up>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<Down>"] = cmp.mapping.select_next_item(cmp_select),

    -- Autocomplete - behaviour configured to emulate IntelliJ.
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    }),

    ["<Tab>"] = cmp.mapping(
      function(fallback)
        -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          end
          cmp.confirm()
        else
          fallback()
        end
      end,
      { "i", "s", "c", }
    ),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = "path" } },
    { { name = "cmdline" } }
  ),
})
