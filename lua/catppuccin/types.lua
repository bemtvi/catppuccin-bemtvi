-- LuaLS type annotations for catppuccin-bemtvi. They describe exactly what this port
-- reads; see `doc/catppuccin-bemtvi.md` (`:help catppuccin-bemtvi`) for the prose.

---@class Catppuccin
---@field options CatppuccinOptions The options in effect (defaults merged with `setup`).
---@field default_options CatppuccinOptions
---@field flavours table<CtpFlavour, integer> The flavour names, in latte..mocha order.
---@field flavour CtpFlavour? The flavour loaded last.
---@field setup fun(opts: CatppuccinOptions?)
---@field load fun(flavour: CtpFlavour?) Load a flavour (`nil` picks one like plain `:colorscheme catppuccin`).

---@alias CtpFlavour "latte" | "frappe" | "macchiato" | "mocha"
---@alias CtpColor "rosewater" | "flamingo" | "pink" | "mauve" | "red" | "maroon" | "peach" | "yellow" | "green" | "teal" | "sky" | "sapphire" | "blue" | "lavender" | "text" | "subtext1" | "subtext0" | "overlay2" | "overlay1" | "overlay0" | "surface2" | "surface1" | "surface0" | "base" | "mantle" | "crust"
---@class CtpFlavours<T>: { all: T, latte: T, frappe: T, macchiato: T, mocha: T }
-- A palette: each colour name to a `"#rrggbb"` string. Inside `custom_highlights` and
-- `highlight_overrides` functions it also carries `none = "NONE"`.
---@class CtpColors<T>: { rosewater: T, flamingo: T, pink: T, mauve: T, red: T, maroon: T, peach: T, yellow: T, green: T, teal: T, sky: T, sapphire: T, blue: T, lavender: T, text: T, subtext1: T, subtext0: T, overlay2: T, overlay1: T, overlay0: T, surface2: T, surface1: T, surface0: T, base: T, mantle: T, crust: T, none: T? }

---@class CatppuccinOptions
-- The flavour plain `catppuccin` loads; `"auto"` defers to `background`.
---@field flavour CtpFlavour | "auto" | nil
-- The flavour plain `catppuccin` uses for each `btv.o.background` value.
---@field background CtpBackground?
-- Drop the background of `Normal`, `NormalNC`, `Folded`, the popup menu, the
-- statusline and the diagnostic virtual text.
---@field transparent_background boolean?
---@field float CtpFloatOpts?
-- Set `btv.g.terminal_color_0` .. `btv.g.terminal_color_15` from the palette.
---@field term_colors boolean?
-- Nudge each palette colour's blue channel by one step, so kitty does not treat a
-- background that matches its own as transparent.
---@field kitty boolean?
---@field dim_inactive CtpDimInactive?
-- Strip italic from every group.
---@field no_italic boolean?
-- Strip bold from every group.
---@field no_bold boolean?
-- Strip underline from every group.
---@field no_underline boolean?
-- Attributes for the syntax and treesitter groups.
---@field styles CtpStyles?
-- Attributes for the diagnostic and LSP groups.
---@field lsp_styles CtpLspStyles?
-- Replace palette colours, for every flavour (`all`) or one.
---@field color_overrides CtpColorOverrides?
-- Override groups per flavour (`all` for every flavour).
---@field highlight_overrides CtpHighlightOverrides?
-- Override groups in every flavour; takes the place of `highlight_overrides.all`.
---@field custom_highlights CtpHighlightOverrideFn | CtpHighlightTable | nil
---@field integrations CtpIntegrations?

---@class CtpBackground
-- The flavour for `btv.o.background = "dark"`.
---@field dark CtpFlavour?
-- The flavour for `btv.o.background = "light"`.
---@field light CtpFlavour?

---@class CtpFloatOpts
-- Drop the float background while `btv.o.winblend` is `0`.
---@field transparent boolean?
-- Paint float, popup-menu and picker borders in the background colour.
---@field solid boolean?

---@class CtpDimInactive
-- Give inactive windows (`NormalNC`) their own background.
---@field enabled boolean?
-- Darken or lighten that background.
---@field shade "dark" | "light" | nil
-- How much to shade it, from 0 to 1.
---@field percentage number?

---@class CtpStyles
---@field comments CtpHighlightArgs[]?
---@field conditionals CtpHighlightArgs[]?
---@field loops CtpHighlightArgs[]?
---@field functions CtpHighlightArgs[]?
---@field keywords CtpHighlightArgs[]?
---@field strings CtpHighlightArgs[]?
---@field variables CtpHighlightArgs[]?
---@field numbers CtpHighlightArgs[]?
---@field booleans CtpHighlightArgs[]?
---@field properties CtpHighlightArgs[]?
---@field types CtpHighlightArgs[]?
---@field operators CtpHighlightArgs[]?
-- `@module` and `@tag.attribute` (italic when unset).
---@field miscs CtpHighlightArgs[]?

---@class CtpLspStyles
-- Attributes for the `Diagnostic*` and `DiagnosticVirtualText*` groups.
---@field virtual_text CtpLspDiagnosticStyles?
-- Attributes for the `DiagnosticUnderline*` groups.
---@field underlines CtpLspDiagnosticStyles?
---@field inlay_hints CtpLspStylesInlayHints?

---@class CtpLspDiagnosticStyles
---@field errors CtpHighlightArgs[]?
---@field hints CtpHighlightArgs[]?
---@field warnings CtpHighlightArgs[]?
---@field information CtpHighlightArgs[]?
---@field ok CtpHighlightArgs[]?

---@class CtpLspStylesInlayHints
-- Give `LspInlayHint` a background.
---@field background boolean?

---@alias CtpColorOverrides CtpFlavours<CtpColors<string>>

---@class CtpIntegrations
---@field blink_cmp CtpIntegrationBlinkCmp?
-- Overrides for the `lualine.themes.catppuccin-*` tables bemtvi-line reads, or `false`.
---@field lualine CtpIntegrationLualine | false | nil

---@class CtpIntegrationBlinkCmp
-- `"bordered"` (the default) also defines `BlinkCmpMenuBorder` and `BlinkCmpDocBorder`.
---@field style "bordered" | "solid" | nil

---@alias CtpIntegrationLualine CtpFlavours<CtpIntegrationLualineOverride | CtpIntegrationLualineOverrideFn>
---@alias CtpIntegrationLualineOverride CtpIntegrationLualineModes<CtpIntegrationLualineSections<CtpIntegrationLualineSectionOverride>>
---@alias CtpIntegrationLualineOverrideFn fun(colors: CtpColors<string>): CtpIntegrationLualineOverride
---@class CtpIntegrationLualineModes<T>: { normal: T, insert: T, visual: T, replace: T, command: T, terminal: T, inactive: T }
---@class CtpIntegrationLualineSections<T>: { a: T, b: T, c: T }
---@class CtpIntegrationLualineSectionOverride
---@field fg string?
---@field bg string?
-- Attributes as a comma-separated string, e.g. `"bold,italic"`.
---@field gui string?

-- The attributes `btv.hl.define` honours.
---@alias CtpHighlightArgs "bold" | "italic" | "underline" | "undercurl" | "strikethrough" | "reverse"
---@alias CtpHighlightTable { [string]: CtpHighlight }
---@alias CtpHighlightOverrideFn fun(colors: CtpColors<string>): CtpHighlightTable
---@alias CtpHighlightOverrides CtpFlavours<CtpHighlightOverrideFn | CtpHighlightTable>

-- A group spec, as handed to `btv.hl.define` (a `style` list is expanded into the
-- boolean attributes first).
---@class CtpHighlight
---@field fg string?
---@field bg string?
---@field sp string?
---@field link string?
---@field style CtpHighlightArgs[]?
---@field bold boolean?
---@field italic boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field strikethrough boolean?
---@field reverse boolean?
