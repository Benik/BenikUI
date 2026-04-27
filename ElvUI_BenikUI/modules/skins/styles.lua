local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown

--------------
-- AcePopup --
--------------
function mod:StyleAcePopup()
	if E.private.skins.ace3Enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end

	if not self.style then
		self:BuiStyle()
	end
end
hooksecurefunc(S, "Ace3_StylePopup", mod.StyleAcePopup)

------------------------------------------------------
-- Blizzard_DebugTools for /tableinspect or /fstack --
------------------------------------------------------
local function styleBlizzard_DebugTools()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.debug) or E.db.benikui.general.benikuiStyle ~= true then return end

	_G.TableAttributeDisplay:BuiStyle()
	hooksecurefunc(_G.TableInspectorMixin, 'OnLoad', function(frame)
		if frame.ScrollFrameArt and not frame.style then
			frame:BuiStyle()
		end
	end)

	if E.private.skins.blizzard.tooltip then
		_G.FrameStackTooltip:BuiStyle()
	end
end
S:AddCallbackForAddon("Blizzard_DebugTools", "BenikUI_Blizzard_DebugTools", styleBlizzard_DebugTools)

-------------------------
-- Blizzard_EventTrace --
-------------------------
local function styleEventTrace()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.eventLog) or E.db.benikui.general.benikuiStyle ~= true then return end

	_G.EventTrace.backdrop:BuiStyle()
	_G.EventTraceTooltip:BuiStyle()
end
S:AddCallbackForAddon("Blizzard_EventTrace", "BenikUI_Blizzard_EventTrace", styleEventTrace)

--------------------
-- ElvUIBindPopup --
--------------------
local function StyleElvUIBindPopup()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	local bind = _G.ElvUIBindPopupWindow
	if bind then
		bind:BuiStyle()
		bind.header:OffsetFrameLevel(1, bind.style)
	end
end
S:AddCallback("BenikUI_StyleElvUIBindPopup", StyleElvUIBindPopup)

-------------------
-- ElvUI Options --
-------------------
local function StyleElvUIConfig()
	if E.private.skins.ace3Enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end
	if InCombatLockdown() then return end

	local frame = E:Config_GetWindow()
	if frame and not frame.style then
		frame:BuiStyle()
	end
end

-----------------
-- ElvUIPopups --
-----------------
local function StyleElvUIPopups()
	if E.db.benikui.general.benikuiStyle ~= true then return end

	for i = 1, 4 do
		local frame = _G['ElvUI_StaticPopup'..i]
		if frame and not frame.style then
			frame:BuiStyle()
		end
	end
end
S:AddCallback("BenikUI_StyleElvUIPopups", StyleElvUIPopups)

-----------------
-- ErrorsFrame --
-----------------
local function StyleScriptErrorsFrame()
	local frame = _G.ScriptErrorsFrame
	if not frame.style then
		frame:BuiStyle()
	end
end

local function ScriptErrorsFrame()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.debug) or E.db.benikui.general.benikuiStyle ~= true then return end

	mod:SecureHookScript(_G.ScriptErrorsFrame, 'OnShow', StyleScriptErrorsFrame)
end
S:AddCallback("BenikUI_ScriptErrorsFrame", ScriptErrorsFrame)

function mod:Initialize()
	hooksecurefunc(E, "ToggleOptions", StyleElvUIConfig)

	mod:RegisterEvent("PLAYER_ENTERING_WORLD", function(...)
		mod:styleElvUIPlugins()
		mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end)
end

BUI:RegisterModule(mod:GetName())