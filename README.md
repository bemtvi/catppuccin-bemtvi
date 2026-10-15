<h3 align="center">
    <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
    Catppuccin for bemtvi
</h3>

<p align="center">
A native <a href="https://github.com/catppuccin/">Catppuccin</a> port for <b>bemtvi</b>: the soothing pastel theme, rewritten against the <code>btv.*</code> plugin API instead of neovim's runtime.
</p>

This is a fork of [catppuccin/nvim](https://github.com/catppuccin/nvim) that runs
natively on [bemtvi](https://github.com/bemtvi/bemtvi). The four flavours (🌻 Latte,
🪴 Frappé, 🌺 Macchiato, 🌿 Mocha), the palettes and the highlight-group definitions
are upstream's. The neovim machinery is replaced: groups are defined directly with
`btv.hl.define` on load, so there is no compile step or cache.

## Installation

```lua
btv.plugins({
  {
    "bemtvi/catppuccin-bemtvi",
    config = function()
      require("catppuccin").setup({}) -- optional; see the docs for options
      btv.cmd("colorscheme catppuccin-mocha")
    end,
  },
})
```

Then run `:PluginSync`.

## Usage

```vim
" catppuccin (follows background), catppuccin-latte, catppuccin-frappe,
" catppuccin-macchiato, catppuccin-mocha
colorscheme catppuccin-mocha
" switch flavour, with completion
Catppuccin latte
```

Besides the standard and treesitter groups, every flavour themes bemtvi's picker,
completion popup and statusline, [bemtvi-tree](https://github.com/bemtvi/bemtvi-tree),
[bemtvi-keys-helper](https://github.com/bemtvi/bemtvi-keys-helper), and
[bemtvi-line](https://github.com/bemtvi/bemtvi-line)'s `theme = "auto"`.

## Documentation

Options, overrides, the palette API and the full list of integrations are in
[`doc/catppuccin-bemtvi.md`](doc/catppuccin-bemtvi.md), also available in the editor
as `:help catppuccin-bemtvi`.

## Development

```sh
bemtvi --test-plugin .     # run the btv.test specs
bash scripts/gen-vimdoc.sh # regenerate doc/catppuccin-bemtvi.txt after editing the .md
pre-commit install --hook-type pre-commit --hook-type pre-push
```

The palette files under `lua/catppuccin/palettes/` are generated from the official
Catppuccin palette by [whiskers](https://github.com/catppuccin/whiskers):
`whiskers palettes.tera`.

## Credits

Based on [catppuccin/nvim](https://github.com/catppuccin/nvim) and the wider
[Catppuccin](https://github.com/catppuccin/catppuccin) project. Licensed under
[MIT](LICENSE.md).
