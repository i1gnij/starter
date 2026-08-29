-- Python + Bash using local binaries, not Mason and not the full lang.python extra
-- (that extra also pulls venv-selector / optional neotest+DAP).

local function has(bin)
  return vim.fn.executable(bin) == 1
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          mason = false,
          enabled = has("ruff"),
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = { logLevel = "error" },
          },
        },
        ruff_lsp = { enabled = false },
        pyright = { enabled = false, mason = false },
        basedpyright = {
          mason = false,
          enabled = has("basedpyright-langserver") or has("basedpyright"),
          cmd = has("basedpyright-langserver") and { "basedpyright-langserver", "--stdio" }
            or { "basedpyright", "--stdio" },
        },
      },
      setup = {
        ruff = function()
          Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
            -- Hover/docs come from basedpyright when it is installed.
            client.server_capabilities.hoverProvider = false
          end)
        end,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        lua = { "stylua" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- Ruff LSP already publishes diagnostics when `ruff` is on PATH.
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}
