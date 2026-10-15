# Changelog

All notable changes to catppuccin-bemtvi, the [bemtvi](https://github.com/bemtvi/bemtvi)
port of Catppuccin.

This repository forks [catppuccin/nvim](https://github.com/catppuccin/nvim) at upstream
[v2.0.0](https://github.com/catppuccin/nvim/releases/tag/v2.0.0) plus the commits up to
[`49a9266`](https://github.com/catppuccin/nvim/commit/49a926655a2f5579e9c276470fc300baaa49e524)
(2026-06-14). The port's version numbers start over at 1.0.0 and are unrelated to
upstream's. For upstream's history before the fork, see
[catppuccin/nvim's changelog](https://github.com/catppuccin/nvim/blob/main/CHANGELOG.md).

## 1.0.0

First release of the port.

### Features

- Runs natively on bemtvi's `btv.*` API: every highlight group is defined with
  `btv.hl.define` when a flavour loads, and `ColorScheme` fires afterwards so plugins
  that derive colours from the theme repaint.
- The four flavours as `catppuccin-latte`, `catppuccin-frappe`, `catppuccin-macchiato`
  and `catppuccin-mocha`; plain `catppuccin` picks one from `background`.
- `:Catppuccin {flavour}` switches flavour, with completion.
- Groups for bemtvi's own UI: the picker (`Telescope*`), the completion popup, the
  statusline mode badge and modified flag, bemtvi-tree (`NvimTree*`) and
  bemtvi-keys-helper (`WhichKey*`).
- `lualine.themes.catppuccin-*` tables, which bemtvi-line's `theme = "auto"` picks up.
- The nvim-cmp, blink.cmp, coc.nvim, copilot.vim, barbar and buffon groups are kept for
  plugins and configs that link to them.
- Help generated from `doc/catppuccin-bemtvi.md` (`:help catppuccin-bemtvi`).
- `btv.test` specs covering every flavour, the `setup` options and the integration
  groups (`bemtvi --test-plugin .`).

### Removed relative to catppuccin/nvim

- The bytecode compiler and its cache: `compile_path` and `:CatppuccinCompile` are gone.
- The integrations for neovim plugins with no bemtvi counterpart, and the
  `default_integrations` / `auto_integrations` options.
- neovim version checks, deprecation shims and automatic kitty detection (`kitty` is an
  explicit option).
- Every `vim.*` call: the code targets `btv.*` only.
