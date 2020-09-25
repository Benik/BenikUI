local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local InCombatLockdown = InCombatLockdown

local function StyleElvUIConfig()
	if E.private.skins.ace3Enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end
	if InCombatLockdown() then return end

	local frame = E:Config_GetWindow()
	if frame and not frame.style then
		frame:Style("Outside")
	end
end

function mod:StyleAcePopup()
	if E.private.skins.ace3Enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end

	if not self.backdrop.style then
		self.backdrop:Style('Outside')
	end
end

local function StyleScriptErrorsFrame()
	local frame = _G.ScriptErrorsFrame
	if not frame.backdrop.style then
		frame.backdrop:Style('Outside')
	end
end

local function StyleElvUIBindPopup()
	local bind = _G.ElvUIBindPopupWindow
	bind:Style("Outside")
	bind.header:SetFrameLevel(bind.style:GetFrameLevel() + 1)
end

local function ScriptErrorsFrame()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.debug) or E.db.benikui.general.benikuiStyle ~= true then return end

	mod:SecureHookScript(_G.ScriptErrorsFrame, 'OnShow', StyleScriptErrorsFrame)
end
S:AddCallback("BenikUI_ScriptErrorsFrame", ScriptErrorsFrame)

function mod:PLAYER_ENTERING_WORLD(...)
	mod:styleAlertFrames()
	mod:stylePlugins()
	mod:styleWorldMap()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	mod:InitializeObjectiveTracker()
	mod:StyleAltPowerBar()

	StyleElvUIBindPopup()

	hooksecurefunc(S, "Ace3_StylePopup", mod.StyleAcePopup)
	hooksecurefunc(E, "ToggleOptionsUI", StyleElvUIConfig)

	mod:RegisterEvent("PLAYER_ENTERING_WORLD")
	mod:RegisterEvent("ADDON_LOADED", "LoD_AddOns")
end

BUI:RegisterModule(mod:GetName())