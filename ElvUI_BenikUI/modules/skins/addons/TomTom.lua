local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local function TomTom()
	if not (BUI:IsAddOnEnabled('TomTom') and E.db.benikui.skins.variousSkins.tomtom) then return end

	local frameDropDown = _G.MyFrameDropDownBackdrop
	if frameDropDown then
		frameDropDown:StripTextures()
		frameDropDown:SetTemplate("Transparent")

		frameDropDown:BuiStyle()
	end

	local mapDropDown = _G.TomTomWorldMapDropdownBackdrop
	if mapDropDown then
		mapDropDown:StripTextures()
		mapDropDown:SetTemplate("Transparent")

		mapDropDown:BuiStyle()
	end

	local mapDropDown = _G.TomTomDropdownBackdrop
	if mapDropDown then --minimap dropdown
		mapDropDown:StripTextures()
		mapDropDown:SetTemplate("Transparent")

		mapDropDown:BuiStyle()
	end

	local tomTooltip = _G.TomTomTooltip
	if tomTooltip then
		tomTooltip:BuiStyle()
	end
end
S:AddCallbackForAddon("TomTom", "BenikUI_TomTom", TomTom)