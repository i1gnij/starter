-- Python + Bash via conda/pip on PATH, not Mason and not lang.python extra.

local function exists(path)
  return (vim.uv or vim.loop).fs_stat(path) ~= nil
end

local function has(bin)
  return vim.fn.executable(bin) == 1
end

local function python_bin()
  if vim.env.CONDA_PREFIX and vim.env.CONDA_PREFIX ~= "" then
    local p = vim.env.CONDA_PREFIX .. "/bin/python"
    if exists(p) then
      return p
    end
  end
  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
    local p = vim.env.VIRTUAL_ENV .. "/bin/python"
    if exists(p) then
      return p
    end
  end
  return nil
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      local py = python_bin()
      local has_basedpyright = has("basedpyright-langserver") or has("basedpyright")
      local has_ruff = has("ruff")

      opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, {
        mason = false,
        enabled = has_ruff,
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = { logLevel = "error" },
        },
      })
      opts.servers.ruff_lsp = { enabled = false }
      opts.servers.pyright = { enabled = false, mason = false }

      opts.servers.basedpyright = vim.tbl_deep_extend("force", opts.servers.basedpyright or {}, {
        mason = false,
        enabled = has_basedpyright,
        cmd = has("basedpyright-langserver") and { "basedpyright-langserver", "--stdio" }
          or { "basedpyright", "--stdio" },
        settings = py and {
          python = { pythonPath = py },
        } or nil,
      })

      -- Fallback if basedpyright is not on the whitelist but python-lsp-server is.
      opts.servers.pylsp = vim.tbl_deep_extend("force", opts.servers.pylsp or {}, {
        mason = false,
        enabled = (not has_basedpyright) and has("pylsp"),
        settings = py and {
          pylsp = {
            plugins = {
              -- Ruff covers lint/format when present.
              pycodestyle = { enabled = not has_ruff },
              pyflakes = { enabled = not has_ruff },
            },
          },
        } or nil,
      })

      opts.setup = opts.setup or {}
      opts.setup.ruff = function()
        Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
          client.server_capabilities.hoverProvider = false
        end)
      end
    end,
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
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}
