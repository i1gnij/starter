# 内网服务器：conda/pip 白名单 + Neovim 插件离线拷贝

GitHub 仍不可达时，**Lua 插件继续整包拷贝**。语言工具改走你们已经放开的 **conda / pip 软件源**，不要用 Mason。

- 还没有 `~/.local/share/nvim/lazy/lazy.nvim` 时，允许 git clone（在能访问 GitHub 的机器上首次安装）
- 插件目录一旦存在（包括从 tar 解开之后），默认不再访问 GitHub
- 强制用 GitHub 更新插件：`NVIM_ONLINE=1 nvim`
- 强制离线：`NVIM_OFFLINE=1 nvim`

先 `conda activate` 再开 Neovim。配置会把 `$CONDA_PREFIX/bin` 插到 `PATH` 前面，并让 basedpyright/pylsp 使用该环境的 `python`。

## 两套来源，不要混用 Mason

| 东西 | 从哪来 | 不要用 |
| --- | --- | --- |
| lazy.nvim、LazyVim、blink、treesitter 等 | 联网机 `:Lazy sync` 后拷 `~/.local/share/nvim/lazy` | 服务器上 `:Lazy update` |
| Treesitter parser（`.so`） | 联网机 `:TSInstall` 后跟插件一起拷 | 服务器上 `:TSInstall` |
| `ruff`、`basedpyright`、`shfmt`、`shellcheck` | **conda 或 pip 白名单源** | Mason / GitHub release |

## 服务器上装语言工具

专用环境（推荐，避免和业务环境抢依赖）：

```bash
conda env create -f conda/nvim-tools.yaml
conda activate nvim-tools
```

或在当前业务环境里用 pip（换成你们的 index）：

```bash
pip install -r requirements-nvim.txt --index-url https://your-pypi.example/simple
```

白名单里没有的包就删掉对应行，缺哪个工具 Neovim 就跳过哪个 LSP，不会硬启动。

| 包 | 作用 | 没有时 |
| --- | --- | --- |
| **ruff** | Python 诊断、整理 import、格式化 | 不启 ruff LSP / ruff format |
| **basedpyright** | 跳转定义、类型检查 | 若有 `pylsp` 则用 python-lsp-server |
| **shfmt** | Bash 格式化 | conform 跳过 |
| **shellcheck** | Bash 静态检查 | nvim-lint 跳过 |

`bash-language-server` 需要 Node，只有 conda 源里有 `nodejs` 且你们愿意装时才值得加；日常 `shellcheck` + `shfmt` + Treesitter 够用。

项目环境与编辑器环境分离时：用**项目的 conda env** 开 nvim（里面也装上 ruff），这样补全/跳转会跟对那个环境的包。不要用 Mason 的 pyright。

## 插件怎么选（仍然要拷，conda 装不了 Lua 插件）

保留 LazyVim 默认编辑器插件即可：lazy、snacks、blink、treesitter、lspconfig、conform、nvim-lint、flash、which-key、gitsigns、trouble、tokyonight、lualine、noice 等。

已关掉、不必拷：catppuccin、nvim-ts-autotag。Mason 保留插件但 `ensure_installed = {}`。

不要为了 Python/Bash 再拷：

- `lang.python` extra（venv-selector / neotest / DAP）——换环境用 `conda activate` 即可
- telescope / nvim-cmp / neo-tree（已有 snacks + blink）
- 用 npm 装的 pyright、bash-language-server

## 联网机器：只同步 Neovim 插件

```bash
export NVIM_ONLINE=1
nvim --headless \
  "+Lazy! sync" \
  "+TSInstall bash python lua vim vimdoc query json yaml markdown markdown_inline regex" \
  +qa
./scripts/export-nvim-bundle.sh /tmp/nvim-airgap.tar.gz
```

服务器上解开：

- `bundle/config` → `~/.config/nvim`
- `bundle/data/lazy` → `~/.local/share/nvim/lazy`

不必把 ruff 等放进 tar；在服务器上 conda/pip 安装。也不要在内网执行 `:Lazy update` / `:MasonInstall` / `:TSInstall`。
