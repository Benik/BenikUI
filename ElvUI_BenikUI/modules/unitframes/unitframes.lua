local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('Units', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');
local LSM = E.LSM

local find = string.find

function mod:UnitDefaults()
	if E.db.benikui.unitframes.player.portraitWidth == nil then
		E.db.benikui.unitframes.player.portraitWidth = 110
	end
	if E.db.benikui.unitframes.player.portraitHeight == nil then
		E.db.benikui.unitframes.player.portraitHeight = 85
	end
	if E.db.benikui.unitframes.target.portraitWidth == nil then
		E.db.benikui.unitframes.target.portraitWidth = 110
	end
	if E.db.benikui.unitframes.target.portraitHeight == nil then
		E.db.benikui.unitframes.target.portraitHeight = 85
	end
end

function mod:UpdateUF()
	if E.db.unitframe.units.player.enable then
		mod:ArrangePlayer()
	end

	if E.db.unitframe.units.target.enable then
		mod:ArrangeTarget()
	end

	if E.db.unitframe.units.party.enable then
		UF:CreateAndUpdateHeaderGroup('party')
	end
end

function mod:Configure_ReadyCheckIcon(frame)
	local tex = frame.ReadyCheckIndicator

	tex.readyTexture = [[Interface\AddOns\ElvUI_BenikUI\media\textures\ready]]
	tex.notReadyTexture = [[Interface\AddOns\ElvUI_BenikUI\media\textures\notready]]
	tex.waitingTexture = [[Interface\AddOns\ElvUI_BenikUI\media\textures\waiting]]
end

-- Unit Shadows
function mod:UnitShadows()
	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe then
			unitframe:CreateSoftShadow()
			unitframe.Buffs.PostUpdateIcon = mod.PostUpdateAura
			unitframe.Debuffs.PostUpdateIcon = mod.PostUpdateAura
		end
	end
end

-- Party Shadows
function mod:PartyShadows()
	local header = _G['ElvUF_Party']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton then
				unitbutton:CreateSoftShadow()
				unitbutton.Buffs.PostUpdateIcon = mod.PostUpdateAura
				unitbutton.Debuffs.PostUpdateIcon = mod.PostUpdateAura
			end
		end
	end
end

-- Raid Shadows
function mod:RaidShadows()
	local header = _G['ElvUF_Raid']

	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton then
				unitbutton:CreateSoftShadow()
				unitbutton.Buffs.PostUpdateIcon = mod.PostUpdateAura
				unitbutton.Debuffs.PostUpdateIcon = mod.PostUpdateAura
			end
		end
	end
end

-- Raid-40 Shadows
function mod:Raid40Shadows()
	local header = _G['ElvUF_Raid40']

	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton then
				unitbutton:CreateSoftShadow()
				unitbutton.Buffs.PostUpdateIcon = mod.PostUpdateAura
				unitbutton.Debuffs.PostUpdateIcon = mod.PostUpdateAura
			end
		end
	end
end

-- Boss shadows
function mod:BossShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton then
			unitbutton:CreateSoftShadow()
			unitbutton.Buffs.PostUpdateIcon = mod.PostUpdateAura
			unitbutton.Debuffs.PostUpdateIcon = mod.PostUpdateAura
		end
	end
end

-- Arena shadows
function mod:ArenaShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton then
			unitbutton:CreateSoftShadow()
			unitbutton.Buffs.PostUpdateIcon = mod.PostUpdateAura
			unitbutton.Debuffs.PostUpdateIcon = mod.PostUpdateAura
		end
	end
end

-- Tank shadows
function mod:TankShadows()
	for i = 1, 2 do
		local unitbutton = _G["ElvUF_TankUnitButton"..i]
		if unitbutton then
			unitbutton:CreateSoftShadow()
			unitbutton.Buffs.PostUpdateIcon = mod.PostUpdateAura
			unitbutton.Debuffs.PostUpdateIcon = mod.PostUpdateAura
		end
	end
end

-- TankTarget shadows
function mod:TankTargetShadows()
	for i = 1, 2 do
		local unitbutton = _G["ElvUF_TankUnitButton"..i.."Target"]
		if unitbutton then
			unitbutton:CreateSoftShadow()
		end
	end
end

function mod:PostUpdateAura(unit, button)
	if not button.shadow then
		button:CreateSoftShadow()
	end

	if button.isDebuff then
		if(not button.isFriend and not button.isPlayer) then --[[and (not E.isDebuffWhiteList[name])]]
			button:SetBackdropBorderColor(0.9, 0.1, 0.1)
			button.icon:SetDesaturated((unit and not strfind(unit, 'arena%d')) and true or false)
		else
			local color = (button.dtype and _G.DebuffTypeColor[button.dtype]) or _G.DebuffTypeColor.none
			if button.name and (button.name == "Unstable Affliction" or button.name == "Vampiric Touch") and E.myclass ~= "WARLOCK" then
				button:SetBackdropBorderColor(0.05, 0.85, 0.94)
			else
				button:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			end
			button.icon:SetDesaturated(false)
		end
	else
		if button.isStealable and not button.isFriend then
			button:SetBackdropBorderColor(0.93, 0.91, 0.55, 1.0)
		else
			button:SetBackdropBorderColor(unpack(E.media.unitframeBorderColor))
		end
	end

	if button.needsUpdateCooldownPosition and (button.cd and button.cd.timer and button.cd.timer.text) then
		UF:UpdateAuraCooldownPosition(button)
	end
end

function mod:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end
	mod:UnregisterEvent(event)
	mod:ChangeDefaultOptions()
end

function mod:ChangeDefaultOptions()
	E.Options.args.unitframe.args.player.args.power.args.height.max = 300
	E.Options.args.unitframe.args.player.args.power.args.detachedWidth.min = ((E.db.unitframe.thinBorders or E.PixelMode) and 3 or 7)
	E.Options.args.unitframe.args.target.args.power.args.height.max = 300
	E.Options.args.unitframe.args.target.args.power.args.detachedWidth.min = ((E.db.unitframe.thinBorders or E.PixelMode) and 3 or 7)
end

function mod:Initialize()
	if E.private.unitframe.enable ~= true then return end
	self:UnitDefaults()
	self:InitPlayer()
	self:InitTarget()
	self:InitFocus()
	self:InitPet()
	self:InitTargetTarget()

	self:InitParty()
	self:InitRaid()
	self:InitRaid40()
	
	self:ChangePowerBarTexture()
	self:ChangeHealthBarTexture()
	self:InfoPanelColor()

	if BUI.ShadowMode then
		self:UnitShadows()
		self:PartyShadows()
		self:RaidShadows()
		self:Raid40Shadows()
		self:BossShadows()
		self:ArenaShadows()
		self:TankShadows()
		self:TankTargetShadows()
	end

	hooksecurefunc(UF, "Configure_ReadyCheckIcon", mod.Configure_ReadyCheckIcon)
	self:RegisterEvent("ADDON_LOADED")
end

BUI:RegisterModule(mod:GetName())