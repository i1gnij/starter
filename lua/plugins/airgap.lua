-- Keep the plugin set small and stop LazyVim from reaching the network.
-- Language servers and formatters come from PATH (see lua/plugins/python-bash.lua).

local function has(bin)
  return vim.fn.executable(bin) == 1
end

return {
  -- Second colorscheme; tokyonight is enough and one less repo to vendor.
  { "catppuccin/nvim", enabled = false },

  -- HTML/JSX closer; not used for Python/Bash.
  { "windwp/nvim-ts-autotag", enabled = false },

  -- Do not download LSP/formatters. Empty list also drops LazyVim's stylua/shfmt ensure_installed.
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {},
    },
  },

  -- Only enable a server when the binary is already on PATH (copied or OS package).
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        stylua = { enabled = false },
        lua_ls = {
          mason = false,
          enabled = has("lua-language-server"),
        },
        bashls = {
          mason = false,
          enabled = has("bash-language-server"),
        },
      },
    },
  },

  -- Do not fetch parsers on the air-gapped host. Copy them with the plugin bundle
  -- after `:TSInstall` on a networked machine (see OFFLINE.md).
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if vim.g.nvim_offline then
        opts.ensure_installed = {}
      else
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "python",
        })
      end
    end,
  },
}
