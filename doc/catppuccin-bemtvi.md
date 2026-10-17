<!-- DO NOT EDIT doc/catppuccin-bemtvi.txt BY HAND. It is generated from this file by
panvimdoc — run `scripts/gen-vimdoc.sh` after editing. -->

Catppuccin for bemtvi: the soothing pastel theme in four flavours, ported from
<https://github.com/catppuccin/nvim> to bemtvi's native `btv.*` API.

The palettes and highlight-group definitions are upstream's. The loader is
bemtvi's own: every group is defined directly with `btv.hl.define` when the
colorscheme loads, so there is no compile step and no cache directory.

<!-- Passed through verbatim so `:help catppuccin-bemtvi` and `:help catppuccin`
     land on this page (panvimdoc derives per-section tags but no bare project tag). -->
```vimdoc
                                                *catppuccin-bemtvi* *catppuccin*
```

# Flavours

- `latte`: the light flavour
- `frappe`: a less vibrant dark flavour
- `macchiato`: medium-contrast dark flavour
- `mocha`: the darkest flavour

# Installation

Declare it with the built-in plugin manager in your `init.lua`:

```lua
btv.plugins({
  {
    "bemtvi/catppuccin-bemtvi",
    config = function()
      require("catppuccin").setup({})
      btv.cmd("colorscheme catppuccin-mocha")
    end,
  },
})
```

Then run `:PluginSync` to clone it. A local checkout works too: put its
directory on the runtimepath (`btv.o.runtimepath = btv.o.runtimepath .. ",/path/to/catppuccin-bemtvi"`).

# Usage

## Colorschemes

```vim
colorscheme catppuccin-latte
colorscheme catppuccin-frappe
colorscheme catppuccin-macchiato
colorscheme catppuccin-mocha
colorscheme catppuccin
```

The plain `catppuccin` picks a flavour when it loads: the `flavour` option if
you set one, otherwise the flavour that `background` maps the current
`btv.o.background` to (`dark` gives `mocha`, `light` gives `latte` by default).
Changing `background` later (`:set background=light`, or a write to
`btv.o.background`) makes bemtvi reload the loaded theme, as vim does, and the
reload switches to the flavour `background` maps the new value to: `mocha`
becomes `latte` and back again.

```lua
btv.o.background = "light"
btv.cmd("colorscheme catppuccin") -- loads catppuccin-latte
```

Loading a flavour sets `btv.g.colors_name` to `catppuccin-<flavour>`, sets
`btv.o.background` to match it, and fires the `ColorScheme` event, so plugins
that derive their colours from the theme repaint.

## :Catppuccin

`:Catppuccin {flavour}` switches to another flavour. `<Tab>` completes the
flavour names. Without an argument it reports an error and changes nothing.

## Lua

`require("catppuccin").load(flavour)` loads a flavour directly (`nil` picks
one the way plain `catppuccin` does) and fires `ColorScheme` like
`:colorscheme` does.

# Configuration

Calling `setup` is optional; the defaults below apply without it. Call it
before selecting the colorscheme, or select the colorscheme again afterwards.

```lua
require("catppuccin").setup({
  flavour = "auto", -- "latte", "frappe", "macchiato", "mocha", or "auto"
  background = { -- the flavour plain `catppuccin` uses per background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  float = {
    transparent = false,
    solid = false,
  },
  term_colors = false,
  kitty = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = { "italic" }, -- `@module` and `@tag.attribute`
  },
  lsp_styles = {
    virtual_text = {
      errors = { "italic" },
      hints = { "italic" },
      warnings = { "italic" },
      information = { "italic" },
      ok = { "italic" },
    },
    underlines = {
      errors = { "underline" },
      hints = { "underline" },
      warnings = { "underline" },
      information = { "underline" },
      ok = { "underline" },
    },
    inlay_hints = {
      background = true,
    },
  },
  color_overrides = {},
  highlight_overrides = {},
  custom_highlights = {},
  integrations = {
    blink_cmp = { style = "bordered" },
    lualine = false,
  },
})
```

## flavour

The flavour plain `catppuccin` loads. `"auto"` (the default) defers to
`background`.

## background

Maps `btv.o.background` (`light` or `dark`) to a flavour for plain
`catppuccin` when `flavour` is `"auto"`.

## transparent_background

Drops the background of `Normal`, `NormalNC`, `Folded`, the popup menu (while
`btv.o.pumblend` is `0`), `StatusLine`, `TabLineFill` and the diagnostic
virtual text, so the terminal's own background shows through.

## float

`float.transparent` drops the background of `NormalFloat`, `FloatBorder` and
`FloatTitle` (only while `btv.o.winblend` is `0`). `float.solid` paints float,
popup-menu and picker borders in the background colour, so the border reads as
solid padding, and gives float titles a lavender block.

## term_colors

Sets `btv.g.terminal_color_0` through `btv.g.terminal_color_15` from the
palette, for the built-in terminal.

## kitty

Nudges every palette colour's blue channel by one step. Kitty treats a
background that exactly matches its own as transparent; this keeps the editor
opaque there.

## dim_inactive

`enabled` gives `NormalNC` (inactive windows) its own background: darker than
`base` with `shade = "dark"`, lighter with `shade = "light"`, by `percentage`
(0 to 1).

## Attribute toggles

`no_italic`, `no_bold` and `no_underline` strip that attribute from every
group, whatever `styles` says.

## styles

Each key takes a list of attributes applied to the matching syntax and
treesitter groups: `"bold"`, `"italic"`, `"underline"`, `"undercurl"`,
`"strikethrough"` or `"reverse"`, the ones `btv.hl.define` honours. `miscs`
covers `@module` and `@tag.attribute`, which are italic when it is unset.

## lsp_styles

`virtual_text` styles the `Diagnostic*` text groups, `underlines` the
`DiagnosticUnderline*` groups. `inlay_hints.background = false` drops the
background of `LspInlayHint`.

## color_overrides

Replaces palette colours, for every flavour (`all`) or one:

```lua
require("catppuccin").setup({
  color_overrides = {
    all = { text = "#ffffff" },
    latte = { base = "#ff0000" },
    mocha = { base = "#000000" },
  },
})
```

## custom_highlights

Overrides any group, in every flavour. A table, or a function that receives
the active flavour's palette:

```lua
require("catppuccin").setup({
  custom_highlights = function(colors)
    return {
      Comment = { fg = colors.flamingo },
      Pmenu = { bg = colors.none },
      NvimTreeFolderName = { fg = colors.mauve },
    }
  end,
})
```

A group spec takes `fg`, `bg`, `sp`, `link`, and either boolean attributes
(`bold = true`) or a `style` list (`style = { "bold", "italic" }`).

## highlight_overrides

The same, per flavour, with `all` for every flavour. `custom_highlights`
takes the place of `highlight_overrides.all` when both are given.

```lua
require("catppuccin").setup({
  highlight_overrides = {
    mocha = function(mocha)
      return { Comment = { fg = mocha.flamingo } }
    end,
  },
})
```

## integrations

`integrations.blink_cmp.style = "bordered"` (the default) also defines
`BlinkCmpMenuBorder` and `BlinkCmpDocBorder`; any other value leaves them out.
`integrations.lualine` overrides the statusline theme tables (see "Statusline
theme" below): a table or a function of the palette,
keyed by `all` or a flavour, then by mode (`normal`, `insert`, `visual`,
`replace`, `command`, `terminal`, `inactive`) and section (`a`, `b`, `c`).

```lua
require("catppuccin").setup({
  integrations = {
    lualine = {
      all = function(colors)
        return { normal = { a = { bg = colors.mauve } } }
      end,
    },
  },
})
```

# Plugin integrations

Every flavour defines the groups below unconditionally; there is nothing to
enable.

## bemtvi UI

- The fuzzy picker reads `TelescopeNormal`, `TelescopeSelection`,
  `TelescopeMatching`, `TelescopeBorder`, `TelescopePromptPrefix`,
  `TelescopeTitle`, `TelescopePreviewNormal` and `TelescopePreviewBorder`.
- The completion popup reads `Pmenu`, `PmenuSel`, `CmpItemAbbrMatch` and
  `FloatBorder`.
- The statusline reads `StatusLineMode` (the mode badge) and
  `StatusLineModified` (the `[+]` flag).

## bemtvi plugins

- bemtvi-tree: the `NvimTree*` groups (folders, files, git status, indent
  markers).
- bemtvi-keys-helper: `WhichKey`, `WhichKeyGroup`, `WhichKeyDesc` and
  `WhichKeySeparator` (`WhichKeyBorder` and `WhichKeyValue` are defined too).

## Statusline theme

bemtvi-line's `theme = "auto"` loads `lualine.themes.<colors_name>`, which
this plugin ships for every flavour (`catppuccin-latte`, `catppuccin-frappe`,
`catppuccin-macchiato`, `catppuccin-mocha`, plus `catppuccin-nvim` for the
active one). The bar follows the flavour with no extra configuration.

## Other groups

The groups for nvim-cmp (`CmpItem*`), blink.cmp (`BlinkCmp*`), coc.nvim,
copilot.vim, barbar (`Buffer*`) and buffon are kept so a bemtvi plugin or
your own config can link to them. `catppuccin.special.bufferline` and
`catppuccin.special.feline` still return upstream's theme tables for those
plugins; no bemtvi plugin reads them today.

# Palettes

`require("catppuccin.palettes").get_palette(flavour)` returns a flavour's
colours (`rosewater`, `flamingo`, `pink`, `mauve`, `red`, `maroon`, `peach`,
`yellow`, `green`, `teal`, `sky`, `sapphire`, `blue`, `lavender`, `text`,
`subtext1`, `subtext0`, `overlay2`, `overlay1`, `overlay0`, `surface2`,
`surface1`, `surface0`, `base`, `mantle`, `crust`) as `"#rrggbb"` strings,
with `color_overrides` applied. Without an argument it returns the active
flavour's.

```lua
local mocha = require("catppuccin.palettes").get_palette("mocha")
btv.hl.define(0, "MyGroup", { fg = mocha.mauve })
```

# Differences

- No compiler or cache: no `compile_path` and no `:CatppuccinCompile`.
- No `integrations` toggles beyond the two above, and no
  `default_integrations` or `auto_integrations`. The 60-odd integrations for
  neovim plugins that have no bemtvi counterpart are gone.
- No neovim version checks and no automatic kitty detection: upstream read
  `KITTY_WINDOW_ID`, here `kitty` is an explicit option.
- `:set background` is not an ex option in bemtvi yet; set it from Lua with
  `btv.o.background`.
