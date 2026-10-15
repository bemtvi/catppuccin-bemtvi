local expect = btv.test.expect

-- Requiring the module registers `:Catppuccin`. Do it at load time so the command
-- is part of the baseline every test starts from (a command a test adds is
-- removed again before the next test, and the module would not re-register it).
require "catppuccin"

-- Reference hex values from the Catppuccin style guide, written out here rather
-- than read from `catppuccin.palettes` so a palette regression can't hide itself.
local PALETTES = {
	latte = { base = "#eff1f5", text = "#4c4f69", mantle = "#e6e9ef", overlay2 = "#7c7f93", red = "#d20f39" },
	frappe = { base = "#303446", text = "#c6d0f5", mantle = "#292c3c", overlay2 = "#949cbb", red = "#e78284" },
	macchiato = { base = "#24273a", text = "#cad3f5", mantle = "#1e2030", overlay2 = "#939ab7", red = "#ed8796" },
	mocha = {
		base = "#1e1e2e",
		text = "#cdd6f4",
		mantle = "#181825",
		overlay2 = "#9399b2",
		red = "#f38ba8",
		blue = "#89b4fa",
		mauve = "#cba6f7",
		flamingo = "#f2cdcd",
		surface1 = "#45475a",
	},
}

local function rgb(hex) return tonumber(hex:sub(2), 16) end
local function hl(name) return btv.hl.get(0, { name = name }) end

-- The plugin keeps its options in module state, which the per-test baseline
-- can't restore, so every test starts from a fresh `setup()` (or its own).
local function setup(opts) require("catppuccin").setup(opts or {}) end

btv.test.describe("catppuccin flavours", function()
	btv.test.before_each(function() setup() end)

	for flavour, p in pairs(PALETTES) do
		btv.test.it(":colorscheme catppuccin-" .. flavour .. " applies its palette", function(t)
			t:cmd("colorscheme catppuccin-" .. flavour)
			expect(btv.g.colors_name).to_equal("catppuccin-" .. flavour)
			expect(btv.o.background).to_equal(flavour == "latte" and "light" or "dark")
			expect(hl("Normal").fg).to_equal(rgb(p.text))
			expect(hl("Normal").bg).to_equal(rgb(p.base))
			expect(hl("Comment").fg).to_equal(rgb(p.overlay2))
			expect(hl("Comment").italic).to_be(true)
			expect(hl("DiagnosticError").fg).to_equal(rgb(p.red))
		end)
	end

	btv.test.it("bare `catppuccin` picks latte on a light background", function(t)
		btv.o.background = "light"
		t:cmd "colorscheme catppuccin"
		expect(btv.g.colors_name).to_equal "catppuccin-latte"
		expect(hl("Normal").bg).to_equal(rgb(PALETTES.latte.base))
	end)

	btv.test.it("bare `catppuccin` picks mocha on a dark background", function(t)
		btv.o.background = "dark"
		t:cmd "colorscheme catppuccin"
		expect(btv.g.colors_name).to_equal "catppuccin-mocha"
		expect(hl("Normal").bg).to_equal(rgb(PALETTES.mocha.base))
	end)

	btv.test.it("`background` maps to the configured flavours", function(t)
		setup { background = { light = "latte", dark = "frappe" } }
		btv.o.background = "dark"
		t:cmd "colorscheme catppuccin"
		expect(btv.g.colors_name).to_equal "catppuccin-frappe"
	end)

	btv.test.it("a fixed `flavour` wins over `background`", function(t)
		setup { flavour = "macchiato" }
		btv.o.background = "light"
		t:cmd "colorscheme catppuccin"
		expect(btv.g.colors_name).to_equal "catppuccin-macchiato"
	end)

	btv.test.it(":Catppuccin switches flavour", function(t)
		t:cmd "colorscheme catppuccin-mocha"
		t:cmd "Catppuccin frappe"
		expect(btv.g.colors_name).to_equal "catppuccin-frappe"
		expect(hl("Normal").bg).to_equal(rgb(PALETTES.frappe.base))
	end)

	btv.test.it(":Catppuccin completes flavour names in order", function()
		local fn = btv.user_command.get().Catppuccin.complete
		expect(fn {}).to_equal { "latte", "frappe", "macchiato", "mocha" }
		expect(fn { "m" }).to_equal { "macchiato", "mocha" }
	end)

	btv.test.it(":Catppuccin without an argument keeps the current flavour", function(t)
		t:cmd "colorscheme catppuccin-mocha"
		t:cmd "Catppuccin"
		expect(btv.g.colors_name).to_equal "catppuccin-mocha"
		expect(t:message()).to_contain "missing flavour"
	end)

	btv.test.it("load() fires ColorScheme with the new name", function(t)
		local seen
		btv.autocmd.create("ColorScheme", { callback = function(ev) seen = ev.match end })
		t:exec(function() require("catppuccin").load "latte" end)
		t:wait_for(function() return seen end)
		expect(seen).to_equal "catppuccin-latte"
	end)

	btv.test.it("get_palette returns the flavour's colours", function()
		local mocha = require("catppuccin.palettes").get_palette "mocha"
		expect(mocha.base).to_equal(PALETTES.mocha.base)
		expect(require("catppuccin.palettes").get_palette("latte").base).to_equal(PALETTES.latte.base)
	end)
end)

btv.test.describe("catppuccin options", function()
	local p = PALETTES.mocha

	btv.test.it("transparent_background clears Normal's background", function(t)
		setup { transparent_background = true }
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("Normal").fg).to_equal(rgb(p.text))
		expect(hl("Normal").bg).to_be_nil()
	end)

	btv.test.it("float.transparent clears the float background", function(t)
		setup()
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("NormalFloat").bg).to_equal(rgb(p.mantle))
		setup { float = { transparent = true } }
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("NormalFloat").bg).to_be_nil()
	end)

	btv.test.it("dim_inactive gives NormalNC its own background", function(t)
		setup()
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("NormalNC").bg).to_equal(rgb(p.base))
		setup { dim_inactive = { enabled = true } }
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("NormalNC").bg).to_be_truthy()
		expect(hl("NormalNC").bg).never.to_equal(rgb(p.base))
	end)

	btv.test.it("term_colors sets btv.g.terminal_color_*", function(t)
		setup()
		btv.g.terminal_color_1 = nil
		t:cmd "colorscheme catppuccin-mocha"
		expect(btv.g.terminal_color_1).to_be_nil()
		setup { term_colors = true }
		t:cmd "colorscheme catppuccin-mocha"
		expect(btv.g.terminal_color_1).to_equal(p.red)
	end)

	btv.test.it("styles and no_italic shape the syntax groups", function(t)
		setup { styles = { functions = { "bold" } } }
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("Function").bold).to_be(true)
		setup { no_italic = true }
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("Comment").italic).to_be_falsy()
	end)

	btv.test.it("color_overrides replace palette entries", function(t)
		setup { color_overrides = { all = { text = "#ffffff" }, mocha = { base = "#000000" } } }
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("Normal").fg).to_equal(0xffffff)
		expect(hl("Normal").bg).to_equal(0)
		t:cmd "colorscheme catppuccin-frappe"
		expect(hl("Normal").fg).to_equal(0xffffff)
		expect(hl("Normal").bg).to_equal(rgb(PALETTES.frappe.base))
	end)

	btv.test.it("custom_highlights overrides any group", function(t)
		setup {
			custom_highlights = function(c) return { Comment = { fg = c.flamingo }, WhichKeyGroup = { fg = c.red } } end,
		}
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("Comment").fg).to_equal(rgb(p.flamingo))
		expect(hl("WhichKeyGroup").fg).to_equal(rgb(p.red))
	end)

	btv.test.it("highlight_overrides apply per flavour", function(t)
		setup {
			highlight_overrides = {
				mocha = function(c) return { Comment = { fg = c.red } } end,
			},
		}
		t:cmd "colorscheme catppuccin-mocha"
		expect(hl("Comment").fg).to_equal(rgb(p.red))
		t:cmd "colorscheme catppuccin-frappe"
		expect(hl("Comment").fg).to_equal(rgb(PALETTES.frappe.overlay2))
	end)
end)

btv.test.describe("catppuccin bemtvi and plugin groups", function()
	btv.test.before_each(function() setup() end)

	btv.test.it("themes the which-key popup and statusline segments", function(t)
		t:cmd "colorscheme catppuccin-mocha"
		local p = PALETTES.mocha
		expect(hl("WhichKeyGroup").fg).to_equal(rgb(p.blue))
		expect(hl("WhichKey").link).to_equal "NormalFloat"
		expect(hl("StatusLineMode").bg).to_equal(rgb(p.mauve))
		expect(hl("StatusLineMode").bold).to_be(true)
	end)

	btv.test.it("defines the integration groups", function(t)
		t:cmd "colorscheme catppuccin-mocha"
		local p = PALETTES.mocha
		expect(hl("NvimTreeFolderName").fg).to_equal(rgb(p.blue))
		expect(hl("TelescopeBorder").link).to_equal "FloatBorder"
		expect(hl("CmpItemAbbr").fg).to_equal(rgb(p.overlay2))
		expect(hl("BlinkCmpMenu").link).to_equal "Pmenu"
		expect(hl("BufferCurrent").bg).to_equal(rgb(p.surface1))
	end)

	btv.test.it("lualine theme tables follow the flavour", function()
		local theme = require "lualine.themes.catppuccin-mocha"
		expect(theme.normal.a.bg).to_equal(PALETTES.mocha.blue)
		expect(theme.normal.c.bg).to_equal(PALETTES.mocha.mantle)
	end)
end)
