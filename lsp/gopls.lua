return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  
  -- This root_dir is specifically for CORE3.
  -- Generic: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/gopls.lua
  root_dir = function(fname)
    local go_mod_root = lspconfig_util.root_pattern("go.mod")(fname)
    if go_mod_root then
      return go_mod_root
    end
    local plz_root = lspconfig_util.root_pattern(".plzconfig")(fname)
    local gopath_root = lspconfig_util.root_pattern("src")(fname)
    if plz_root and gopath_root then vim.env.GOPATH = string.format("%s:%s/plz-out/go", gopath_root, plz_root)
      vim.env.GO111MODULE = "off"
    end
    return vim.fn.getcwd()
  end,

  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      directoryFilters = {
        "-" .. vim.fn.getcwd() .. "/plz-out",
        "+" .. vim.fn.getcwd() .. "/plz-out/go",
      },
      linksInHover = false,
      staticcheck = true,
      -- gofumpt = true,  -- a stricter gofmt
    },
  },
}
