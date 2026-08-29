local function exists(path)
  return (vim.uv or vim.loop).fs_stat(path) ~= nil
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local vendor_lazy = vim.fn.stdpath("config") .. "/vendor/lazy.nvim"

-- NVIM_ONLINE=1  → allow git clone / :Lazy sync (bootstrap machine)
-- NVIM_OFFLINE=1 → never clone or auto-install (air-gapped server)
-- default       → online until lazy.nvim exists, then stay offline so a copied
--                 data dir never tries to reach GitHub
if vim.g.nvim_offline == nil then
  if vim.env.NVIM_OFFLINE == "1" then
    vim.g.nvim_offline = true
  elseif vim.env.NVIM_ONLINE == "1" then
    vim.g.nvim_offline = false
  else
    vim.g.nvim_offline = exists(lazypath) or exists(vendor_lazy)
  end
end

if not exists(lazypath) then
  if exists(vendor_lazy) then
    lazypath = vendor_lazy
  elseif vim.g.nvim_offline then
    vim.api.nvim_echo({
      { "lazy.nvim is missing and offline mode is on.\n", "ErrorMsg" },
      { "Copy lazy.nvim to:\n  " .. lazypath .. "\nor\n  " .. vendor_lazy .. "\n", "WarningMsg" },
      { "See OFFLINE.md. Press any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  else
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    -- Air-gapped hosts cannot git clone. Sync plugins on a networked machine, then copy the data dir.
    missing = not vim.g.nvim_offline,
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    enabled = not vim.g.nvim_offline,
    notify = false,
  },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
