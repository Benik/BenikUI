local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins')

local _G = _G

local function VehicleExit()
	if E.private.actionbar.enable ~= true then
		return
	end
	local f = _G.MainMenuBarVehicleLeaveButton
	f:SetNormalTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	f:SetPushedTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	f:SetHighlightTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	if MasqueGroup and E.private.actionbar.masque.actionbars then return end
	f:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
	f:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
end

function mod:Initialize()
	VehicleExit()

	if E.db.benikui.general.benikuiStyle ~= true then return end

	mod:SkinDecursive()
	mod:SkinStoryline()
end

BUI:RegisterModule(mod:GetName())