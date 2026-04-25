local BUI, E, L, V, P, G = unpack((select(2, ...)))

function BUI:LoadPawnProfile()
	-- Disable the tooltip item update coloring, cause it doesn't fit with BenikUI style
	PawnCommon["ColorTooltipBorder"] = false
end