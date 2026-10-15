local M = {}

function M.apply(flavour)
	flavour = flavour or require("catppuccin").flavour

	-- The group modules take the options (O), palette (C) and colour utils (U)
	-- as `get(C, O, U)` arguments. Upstream borrowed them as globals for the
	-- duration of this call instead.
	local O = require("catppuccin").options
	local C = require("catppuccin.palettes").get_palette(flavour)
	local U = require "catppuccin.utils.colors"

	C.none = "NONE"

	local dim_percentage = O.dim_inactive.percentage
	C.dim = O.dim_inactive.shade == "dark"
			and U.vary_color(
				{ latte = U.darken(C.base, dim_percentage, C.mantle) },
				U.darken(C.base, dim_percentage, C.mantle)
			)
		or U.vary_color(
			{ latte = U.lighten("#FBFCFD", dim_percentage, C.base) },
			U.lighten(C.surface0, dim_percentage, C.base)
		)

	local theme = {}
	theme.editor = vim.tbl_deep_extend(
		"force",
		require("catppuccin.groups.editor").get(C, O, U),
		require("catppuccin.groups.lsp").get(C, O, U)
	)

	theme.syntax = {}
	local syntax_modules = { "syntax", "semantic_tokens", "treesitter" }
	for i = 1, #syntax_modules do
		theme.syntax =
			vim.tbl_deep_extend("force", theme.syntax, require("catppuccin.groups." .. syntax_modules[i]).get(C, O, U))
	end

	theme.bemtvi = require("catppuccin.groups.bemtvi").get(C, O, U) -- bemtvi native UI surfaces

	-- Plugin integrations whose highlight groups we keep defined unconditionally
	-- so custom plugins can link to / reuse their names. Statusline/tabline plugins
	-- that consume a theme table rather than `:hi` groups (lualine, feline,
	-- bufferline) live under catppuccin.special / catppuccin.utils, not here.
	theme.integrations = {}
	local integration_modules =
		{ "cmp", "blink_cmp", "coc_nvim", "copilot_vim", "barbar", "buffon", "nvimtree", "telescope" }
	for i = 1, #integration_modules do
		theme.integrations = vim.tbl_deep_extend(
			"force",
			theme.integrations,
			require("catppuccin.groups.integrations." .. integration_modules[i]).get(C, O, U)
		)
	end

	theme.terminal = require("catppuccin.groups.terminal").get(C, O, U) -- terminal colors
	local user_highlights = O.highlight_overrides
	if type(user_highlights[flavour]) == "function" then user_highlights[flavour] = user_highlights[flavour](C) end
	theme.custom_highlights = vim.tbl_deep_extend(
		"keep",
		user_highlights[flavour] or {},
		type(user_highlights.all) == "function" and user_highlights.all(C) or user_highlights.all or {}
	)

	return theme
end

return M
