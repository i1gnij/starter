# 无外网服务器：插件怎么选、怎么拷

行为：

- 还没有 `~/.local/share/nvim/lazy/lazy.nvim` 时，允许 git clone（方便在能上网的机器上第一次安装）
- 插件目录一旦存在（包括从 tar 解开之后），默认不再联网
- 强制上网更新：`NVIM_ONLINE=1 nvim`
- 强制离线：`NVIM_OFFLINE=1 nvim`

## 选择原则

1. **少插件**：每个插件都要 clone、对齐版本、整包拷贝。能用二进制工具解决的，不要再加插件。
2. **语言能力用 PATH 上的程序**，不要用 Mason 现下。Mason 会访问 GitHub。
3. **不要开 `lang.python` extra**：会多装 venv-selector，并顺带 neotest/DAP。跳转/检查用 `ruff` + `basedpyright` 即可。
4. **Bash 不要依赖 `bash-language-server`**：那是 Node 程序，内网很难带。用 `shellcheck` + `shfmt` + Treesitter 足够日常改脚本。
5. **Parser 也要一起拷**：Treesitter 语法高亮的 `.so` 在能上网时装好，离线后 `ensure_installed` 为空，避免再去拉 GitHub。

## 建议保留的插件（LazyVim 默认里）

这些是编辑器本身，拷一次就行，和 Python/Bash 无关：

| 用途 | 插件 |
| --- | --- |
| 管理器 / 发行版 | lazy.nvim、LazyVim、snacks.nvim |
| 补全 | blink.cmp |
| 语法 | nvim-treesitter、textobjects |
| LSP 接线 | nvim-lspconfig |
| 格式化 / lint | conform.nvim、nvim-lint |
| 跳转 / 键位 / git | flash、which-key、gitsigns |
| 诊断列表 | trouble、todo-comments |
| UI | tokyonight、bufferline、lualine、noice、mini.icons、nui |
| 其它 | mini.pairs、mini.ai、ts-comments、lazydev、grug-far、persistence、plenary |

本配置已关掉、不必拷的：

- **catppuccin**（只留 tokyonight）
- **nvim-ts-autotag**（HTML/JSX）
- **Mason 自动安装列表**（仍保留 mason 插件，避免 LazyVim 依赖断掉，但 `ensure_installed = {}`）

不要为了 Python/Bash 再加的：

- telescope / fzf-lua（已有 snacks picker）
- nvim-cmp 全家桶（已有 blink）
- neo-tree（已有 snacks explorer）
- neotest、nvim-dap、debugpy（调试再单独拷二进制和 extra）
- venv-selector（在项目里 `source .venv` 或设 `PATH` 即可）
- pyright 的 npm 包（改用单文件/少依赖的 **ruff** + **basedpyright**）

## 语言工具（不是 Neovim 插件，请拷二进制或内网包）

| 语言 | 工具 | 作用 | 怎么带进去 |
| --- | --- | --- | --- |
| Python | **ruff** | LSP 诊断 + import 整理 + format | 静态二进制，优先拷这个 |
| Python | **basedpyright** | 类型检查、跳转定义（可选） | 有 `basedpyright-langserver` 才启用 |
| Bash | **shfmt** | 格式化 | 静态二进制 |
| Bash | **shellcheck** | 静态检查 | 静态二进制或系统包 |
| 配置 Lua | lua-language-server、stylua | 只有还要改 Neovim 配置时才需要 | 没有则自动禁用 lua_ls |

配置会检测 `executable()`：没有对应命令就不会去启动 LSP，避免报错刷屏。

## 联网机器上的一次同步

```bash
export NVIM_ONLINE=1
nvim --headless \
  "+Lazy! sync" \
  "+TSInstall bash python lua vim vimdoc query json yaml markdown markdown_inline regex" \
  +qa
./scripts/export-nvim-bundle.sh /tmp/nvim-airgap.tar.gz
```

把包拷到服务器后：

- `bundle/config` → `~/.config/nvim`（或你们的 `XDG_CONFIG_HOME/nvim`）
- `bundle/data/lazy` → `~/.local/share/nvim/lazy`
- 可选 `bundle/data/mason` → `~/.local/share/nvim/mason`
- 把 `ruff`、`shfmt`、`shellcheck` 放到 `PATH`

服务器上**不要**设 `NVIM_ONLINE=1`。缺 lazy.nvim 时不会去 git clone，会提示拷贝路径。

也可把 `lazy.nvim` 放到配置仓库的 `vendor/lazy.nvim`，启动脚本会回退使用它。

## 日常更新（只能在能上网的机器做）

1. `NVIM_ONLINE=1 nvim` → `:Lazy sync`
2. 需要的话再 `:TSUpdate`
3. 更新 ruff/shfmt/shellcheck 二进制
4. 重新打 tar 覆盖服务器上的 `lazy/`（和可选的 `mason/`）

不要在内网执行 `:Lazy update` / `:MasonInstall` / `:TSInstall`。
