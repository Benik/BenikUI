local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins')

local _G = _G




-- GLOBALS: hooksecurefunc

-- SpellBook tabs shadow
local function styleSpellbook()
	if E.private.skins.blizzard.enable ~= true or BUI.ShadowMode ~= true or E.private.skins.blizzard.spellbook ~= true then
		return
	end

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs",
		function()
			for i = 1, MAX_SKILLLINE_TABS do
				local tab = _G['SpellBookSkillLineTab'..i]
				tab.backdrop:CreateSoftShadow()
			end
		end)
end
S:AddCallback("BenikUI_Spellbook", styleSpellbook)

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

function mod:PLAYER_ENTERING_WORLD(...)



	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	VehicleExit()

	if E.db.benikui.general.benikuiStyle ~= true then return end

	mod:SkinDecursive()
	mod:SkinStoryline()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

BUI:RegisterModule(mod:GetName())