local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Actionbars')
local AB = E:GetModule('ActionBars')
local T = E:GetModule('TotemTracker')

if E.private.actionbar.enable ~= true then return end

local _G = _G
local pairs = pairs
local MAX_TOTEMS = MAX_TOTEMS
local MAX_STANCES = GetNumShapeshiftForms()
local Masque = E.Masque
local MasqueGroup = Masque and E.private.actionbar.masque.actionbars

local classColor = E:ClassColor(E.myclass, true)

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar, ElvUI_MicroBar}

function mod:StyleBackdrops()
	for _, bar in pairs(AB.handledBars) do
		if bar then
			bar.backdrop:BuiStyle('Outside', nil, true, true)

			if BUI.ShadowMode and not MasqueGroup then
				for _, button in ipairs(bar.buttons) do
					if button then
						button:CreateSoftShadow()
					end
				end
			end
		end
	end

	-- Other bar backdrops
	for _, frame in pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:BuiStyle('Outside', nil, true, true)
		end
	end
end

function mod:ToggleStyle()
	local db = E.db.benikui.actionbars.style

	for i = 1, 10 do
		if _G['ElvUI_Bar'..i].backdrop.style then
			_G['ElvUI_Bar'..i].backdrop.style:SetShown(db['bar'..i])
		end
	end

	for i = 13, 15 do
		if _G['ElvUI_Bar'..i].backdrop.style then
			_G['ElvUI_Bar'..i].backdrop.style:SetShown(db['bar'..i])
		end
	end

	-- Other bar backdrops
	if _G.ElvUI_BarPet.backdrop.style then
		_G.ElvUI_BarPet.backdrop.style:SetShown(db.petbar)
	end

	if _G.ElvUI_StanceBar.backdrop.style then
		_G.ElvUI_StanceBar.backdrop.style:SetShown(db.stancebar)
	end

	if _G.ElvUI_MicroBar.backdrop.style then
		_G.ElvUI_MicroBar.backdrop.style:SetShown(db.microbar)
	end
end

local r, g, b = 0, 0, 0
function mod:StyleColor()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	local db = E.db.benikui.colors

	for _, bar in pairs(AB.handledBars) do
		if bar then
			if db.abStyleColor == 1 then
				r, g, b = classColor.r, classColor.g, classColor.b
			elseif db.abStyleColor == 2 then
				r, g, b = BUI:unpackColor(db.customAbStyleColor)
			elseif db.abStyleColor == 3 then
				r, g, b = BUI:unpackColor(E.db.general.valuecolor)
			elseif E.db.benikui.colors.StyleColor == 4 then
				r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
			else
				r, g, b = BUI:unpackColor(E.db.general.classColors[E.myclass])
			end
			if bar.backdrop.style then
				bar.backdrop.style:SetBackdropColor(r, g, b, db.abAlpha or 1)
			end
		end
	end

	for _, frame in pairs(styleOtherBacks) do
		local name = _G[frame:GetName()].backdrop.style

		if db.abStyleColor == 1 then
			r, g, b = classColor.r, classColor.g, classColor.b
		elseif db.abStyleColor == 2 then
			r, g, b = BUI:unpackColor(db.customAbStyleColor)
		elseif db.abStyleColor == 3 then
			r, g, b = BUI:unpackColor(E.db.general.valuecolor)
		else
			r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
		end
		if name then
			name:SetBackdropColor(r, g, b, db.abAlpha or 1)
		end
	end
end

function mod:PetShadows()
	-- Pet Buttons
	for i = 1, _G.NUM_PET_ACTION_SLOTS do
		local button = _G['PetActionButton'..i]
		if (button and BUI.ShadowMode) and not MasqueGroup then
			button:CreateSoftShadow()
		end
	end
end

function mod:StancebarShadows()
	for i = 1, MAX_STANCES do
		local button = _G['ElvUI_StanceBarButton'..i]
		if (button and BUI.ShadowMode) and not MasqueGroup then
			button:CreateSoftShadow()
		end
	end
end

function mod:TotemShadows()
	if not E.private.general.totemTracker then return end
	for i = 1, MAX_TOTEMS do
		local button = T.bar[i]
		button:BuiStyle("Outside")
	end
end

local function ApplyFlyoutShadows(btn)
	if not btn.shadow then
		btn:CreateSoftShadow()
	end
end

function mod.FlyoutShadows()
	local btn, i = _G['LABFlyoutButton1'], 1
	while btn do
		if btn.shadow then break end
		ApplyFlyoutShadows(btn)

		i = i + 1
		btn = _G['LABFlyoutButton'..i]
	end
end

function mod:ExtraAB() -- shadows
	if not E.private.actionbar.enable then return end
	hooksecurefunc(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function(button)
		for spellButton in button.SpellButtonContainer:EnumerateActive() do
			if spellButton and not spellButton.hasShadow then
				spellButton:CreateSoftShadow()
				spellButton.hasShadow = true
			end
		end
	end)

	for i = 1, _G.ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton"..i]
		if button then
			button:CreateSoftShadow()
		end
	end
end

local function VehicleExit()
	if E.db.actionbar.vehicleExitButton.enable ~= true then
		return
	end

	if not MasqueGroup then
		local f = _G.MainMenuBarVehicleLeaveButton
		local arrow = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow"
		f:SetNormalTexture(arrow)
		f:SetPushedTexture(arrow)
		f:SetHighlightTexture(arrow)

		f:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
		f:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
		f.backdrop:CreateSoftShadow()
	end
end

function mod:Initialize()
	mod:StyleBackdrops()
	mod:PetShadows()
	mod:StyleColor()
	mod:LoadToggleButtons()
	mod:ToggleStyle()
	mod:TotemShadows()
	mod:StancebarShadows()

	VehicleExit()

	mod:LoadRequestButton()
	mod:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "StyleColor")

	hooksecurefunc(BUI, "SetupColorThemes", mod.StyleColor)

	if not BUI.ShadowMode then return end
	mod:FlyoutShadows()
	mod:ExtraAB()
end

BUI:RegisterModule(mod:GetName())