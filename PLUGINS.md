# LazyVim Starter 插件说明

本仓库是 [LazyVim](https://github.com/LazyVim/LazyVim) 的起步模板，本身几乎不声明插件。
真正生效的插件来自 `LazyVim/LazyVim` 的 `import = "lazyvim.plugins"`。

当前默认核心约 34 个插件（随 LazyVim 版本变化）。新增语言/工具请用 `:LazyExtras`，不要把 extras 写进本文件当“已启用清单”。

## 本仓库如何加载插件

启动链：

1. `init.lua` → `require("config.lazy")`
2. `lua/config/lazy.lua` 安装并启动 [lazy.nvim](https://github.com/folke/lazy.nvim)
3. spec 顺序（必须保持这个顺序）：
   - `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }`：发行版默认插件 + 默认 extras
   - `{ import = "plugins" }`：本仓库 `lua/plugins/*.lua` 的覆盖/增补

自定义入口：

| 文件 | 作用 |
| --- | --- |
| `lua/config/options.lua` | 在 lazy 启动前加载的 Neovim 选项（目前为空，沿用 LazyVim 默认） |
| `lua/config/keymaps.lua` | `VeryLazy` 时加载的快捷键（目前为空） |
| `lua/config/autocmds.lua` | `VeryLazy` 时加载的自动命令（目前为空） |
| `lua/plugins/example.lua` | **未生效**：文件开头 `if true then return {} end`，后面全是示例 |

lazy.nvim 自身相关设置（见 `lua/config/lazy.lua`）：

- 自定义插件默认 `lazy = false`（启动时加载）；LazyVim 自带插件仍按各自 spec 懒加载
- `version = false`：跟 git HEAD，不锁 semver
- 安装时优先配色：`tokyonight`，失败则 `habamax`
- 定期检查更新，但不弹通知
- 关闭部分 Neovim 自带 runtime 插件以加快启动：`gzip`、`tarPlugin`、`tohtml`、`tutor`、`zipPlugin`

`.neoconf.json` 给 Lua 语言服务器提供 Neovim/插件 API 补全提示，不是运行时插件列表。

---

## 一、框架与发行版

| 插件 | 作用 |
| --- | --- |
| [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | 插件管理器：安装、懒加载、更新检查、`:Lazy` UI |
| [LazyVim/LazyVim](https://github.com/LazyVim/LazyVim) | 发行版：默认 options/keymaps/autocmds、插件 spec、格式化/LSP 胶水、extras 系统 |

---

## 二、默认 extras（新安装会自动开）

LazyVim 会在「同类功能」里只启用一套。新安装默认是：

| 类别 | 默认 extra | 实际插件 / 模块 | 作用 |
| --- | --- | --- | --- |
| 补全 | `coding.blink` | [saghen/blink.cmp](https://github.com/saghen/blink.cmp) | 补全引擎（LSP、路径、缓冲、snippet、命令行等） |
| 选择器 | `editor.snacks_picker` | `snacks.nvim` picker | 文件/文本/LSP 符号等模糊查找（替代 Telescope / fzf-lua） |
| 文件树 | `editor.snacks_explorer` | `snacks.nvim` explorer | 侧边栏文件浏览器（`<leader>e` / `<leader>fe`） |

若要用旧方案，在 `:LazyExtras` 里改：

- 补全 → `coding.nvim-cmp`
- 选择器 → `editor.fzf` 或 `editor.telescope`
- 文件树 → `editor.neo-tree`

---

## 三、Coding

| 插件 | 作用 |
| --- | --- |
| [nvim-mini/mini.pairs](https://github.com/nvim-mini/mini.pairs) | 自动补全括号/引号；会跳过字符串、避免不平衡配对 |
| [folke/ts-comments.nvim](https://github.com/folke/ts-comments.nvim) | 按 Treesitter 处理多语言注释，改善 `gc` 注释/取消注释 |
| [nvim-mini/mini.ai](https://github.com/nvim-mini/mini.ai) | 扩展 `a`/`i` 文本对象：函数、类、参数、引号、标签、数字等 |
| [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim) | 编辑 Neovim Lua 配置时增强 LuaLS：补全 `vim.*`、`LazyVim`、`Snacks` 等 |

---

## 四、配色

| 插件 | 作用 |
| --- | --- |
| [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | 默认配色，LazyVim 使用 `moon` 风格 |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | 备选配色，并预置与 bufferline、gitsigns、which-key 等的集成 |

在 `lua/plugins/` 里改 `LazyVim` 的 `opts.colorscheme` 即可切换。

---

## 五、编辑器能力

| 插件 | 作用 |
| --- | --- |
| [MagicDuck/grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | 多文件搜索替换（`<leader>sr`），可按当前文件扩展名预填过滤器 |
| [folke/flash.nvim](https://github.com/folke/flash.nvim) | 增强跳转：标签跳转、Treesitter 选择、操作符模式下的远程跳转 |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | 按键提示弹窗，Helix 风格；给 `<leader>` 分组（code/git/search/ui 等） |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | 行内 git 变更标记；hunk 暂存/撤销/预览/blame（`<leader>gh*`） |
| [folke/trouble.nvim](https://github.com/folke/trouble.nvim) | 诊断、符号、LSP 引用、quickfix/loclist 的结构化列表 |
| [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | 收集 `TODO`/`FIXME`/`HACK` 等注释，可跳转或送进 Trouble |

---

## 六、LSP、格式化、检查

| 插件 | 作用 |
| --- | --- |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 客户端配置；LazyVim 默认启用 `lua_ls`，并接上跳转/改名/code action 等键位 |
| [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) | 安装 LSP/格式化/linter 等外部工具；默认确保 `stylua`、`shfmt` |
| [mason-org/mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | 把 Mason 安装的语言服务器接到 Neovim LSP |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | 格式化调度；Lua 用 stylua，shell 用 shfmt，失败时回退 LSP format |
| [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) | 异步 linter，结果走 `vim.diagnostic`；默认几乎不绑语言（fish 除外） |

---

## 七、Treesitter

| 插件 | 作用 |
| --- | --- |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮、缩进、折叠；默认安装 lua/js/ts/python/json/yaml 等一批 parser |
| [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | 按语法节点跳转：函数/类/参数（`]f` `[c` 等） |
| [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | HTML/JSX 自动补全闭合标签 |

---

## 八、UI

| 插件 | 作用 |
| --- | --- |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | 顶部 buffer 标签，带诊断图标、钉住、左右关闭 |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏：模式、分支、诊断、路径、diff、插件更新提示、时钟 |
| [folke/noice.nvim](https://github.com/folke/noice.nvim) | 替换消息、命令行、补全弹窗 UI；LSP hover/签名更好看 |
| [nvim-mini/mini.icons](https://github.com/nvim-mini/mini.icons) | 文件/文件类型图标；并 mock `nvim-web-devicons` 以兼容旧插件 |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI 组件库，供 noice 等插件使用（一般不单独操作） |

---

## 九、工具库与会话（含 snacks 模块）

| 插件 | 作用 |
| --- | --- |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim) | LazyVim 的多功能底座，见下表 |
| [folke/persistence.nvim](https://github.com/folke/persistence.nvim) | 自动保存/恢复会话（打开的 buffer 和窗口布局） |
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | 许多插件依赖的 Lua 工具库 |

`snacks.nvim` 在默认配置里启用的模块：

| 模块 | 作用 |
| --- | --- |
| `dashboard` | 启动页（找文件、恢复会话、打开 Lazy/Extras） |
| `indent` | 缩进线 |
| `input` | 替代 vim.ui.input 的输入框 |
| `notifier` | 通知（替代 nvim-notify） |
| `scope` | 基于缩进/Treesitter 的 scope 文本对象 |
| `scroll` | 平滑滚动 |
| `words` | LSP 引用高亮与 `]]`/`[[` 跳转 |
| `bigfile` | 超大文件时关掉重功能，避免卡顿 |
| `quickfile` | 尽快打开文件，减少启动等待 |
| `terminal` | 内置终端，默认底部 split |
| `toggle` | UI 开关映射（缩进线、动画、zen 等） |
| `scratch` | 临时草稿 buffer（`<leader>.`） |
| `picker` / `explorer` | 由默认 extras 打开，见第二节 |

---

## 十、本仓库示例里提到、但当前未加载的插件

`lua/plugins/example.lua` 在文件顶部直接 `return {}`，因此下面这些 **不会安装**。它们只是覆盖写法的示例：

| 示例 | 说明 |
| --- | --- |
| `ellisonleao/gruvbox.nvim` | 换配色 |
| `hrsh7th/nvim-cmp` + `hrsh7th/cmp-emoji` | 旧补全栈上加 emoji 源 |
| `nvim-telescope/telescope.nvim` | 旧模糊查找；现可用 extra `editor.telescope` |
| `jose-elias-alvarez/typescript.nvim` | 旧 TS 工具；现应用 extra `lang.typescript` |
| `lazyvim.plugins.extras.lang.typescript` | 打开 TS 语言 extra |
| `lazyvim.plugins.extras.ui.mini-starter` | 用 mini.starter 替代 snacks dashboard |
| `lazyvim.plugins.extras.lang.json` | JSON LSP + schema + treesitter |
| Mason `ensure_installed`：`shellcheck` / `flake8` | 额外命令行工具示例 |

---

## 如何增删插件

在 `lua/plugins/` 新建 lua 文件并 `return { ... }`：

```lua
-- 新增
{ "owner/repo" }

-- 关掉 LazyVim 默认插件
{ "folke/trouble.nvim", enabled = false }

-- 合并覆盖 opts
{
  "folke/trouble.nvim",
  opts = { use_diagnostic_signs = true },
}

-- 打开官方 extra（写在 lazy.lua 的 spec 里，且必须夹在 LazyVim 与自己的 plugins 之间）
{ import = "lazyvim.plugins.extras.lang.json" }
```

更省事：Neovim 里执行 `:LazyExtras`。
