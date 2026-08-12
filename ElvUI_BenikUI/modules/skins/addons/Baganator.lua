local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G

local function Baganator() --credits go to plusmouse here https://github.com/Benik/BenikUI/issues/62
	if not (BUI:IsAddOnEnabled('Baganator') and E.db.benikui.skins.variousSkins.baganator) then return end

	local baganator = _G["Baganator"]
	baganator.API.Skins.RegisterListener(function(details)
		if details.regionType == "ButtonFrame" and baganator.API.Skins.GetCurrentSkin() == "elvui" then
			details.region:BuiStyle()
		end
	end)

	if baganator.API.Skins.GetCurrentSkin() == "elvui" then
		for _, details in ipairs(baganator.API.Skins.GetAllFrames()) do
			if details.regionType == "ButtonFrame" then
				details.region:BuiStyle()
			end
		end
	end
end
S:AddCallbackForAddon("Baganator", "BenikUI_Baganator", Baganator)