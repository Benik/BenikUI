local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Units')
local UF = E:GetModule('UnitFrames')
local NP = E:GetModule('NamePlates')
local AB = E:GetModule('ActionBars')

local DebuffColors = E.Libs.Dispel:GetDebuffTypeColor()
local BleedList = E.Libs.Dispel:GetBleedList()
local BadDispels = E.Libs.Dispel:GetBadList()

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
	local db = E.db.unitframe.units

	if db.player.enable then
		mod:ArrangePlayer()
	end

	if db.target.enable then
		mod:ArrangeTarget()
	end

	if db.focus.enable then
		mod:ArrangeFocus()
	end

	if db.pet.enable then
		mod:ArrangePet()
	end

	if db.targettarget.enable then
		mod:ArrangeTargetTarget()
	end

	if db.party.enable then
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
	for _, frame in pairs(UF.units) do
		if frame and not frame.shadow then
			frame:CreateSoftShadow()
			frame.Health.backdrop:CreateSoftShadow()
			frame.Health.backdrop.shadow:Hide()
			frame.Power.backdrop:CreateSoftShadow()
			frame.Power.backdrop.shadow:Hide()
			frame.Buffs.PostUpdateButton = mod.PostUpdateAura
			frame.Debuffs.PostUpdateButton = mod.PostUpdateAura
		end
	end
end

-- Fix unit Power Shadows
function mod:UnitPowerShadows(frame)
	if frame and frame.shadow and frame.Health.backdrop.shadow and frame.Power.backdrop.shadow then
		local power = frame.Power
		local health = frame.Health
		
		if frame.USE_POWERBAR then
			if frame.USE_POWERBAR_OFFSET or frame.USE_MINI_POWERBAR then
				frame.shadow:Hide()
				health.backdrop.shadow:Show()
				power.backdrop.shadow:Show()
			elseif frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
				frame.shadow:Show()
				health.backdrop.shadow:Hide()
				power.backdrop.shadow:Show()
			else
				frame.shadow:Show()
				health.backdrop.shadow:Hide()
				power.backdrop.shadow:Hide()
			end
		else
			frame.shadow:Show()
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
				unitbutton.Buffs.PostUpdateButton = mod.PostUpdateAura
				unitbutton.Debuffs.PostUpdateButton = mod.PostUpdateAura
			end
		end
	end
end

-- Raid Shadows
function mod:RaidShadows()
	for i = 1, 3 do
		local header = _G['ElvUF_Raid'..i]

		for j = 1, header:GetNumChildren() do
			local group = select(j, header:GetChildren())

			for k = 1, group:GetNumChildren() do
				local unitbutton = select(k, group:GetChildren())
				if unitbutton then
					unitbutton:CreateSoftShadow()
					unitbutton.Buffs.PostUpdateButton = mod.PostUpdateAura
					unitbutton.Debuffs.PostUpdateButton = mod.PostUpdateAura
				end
			end
		end
	end
end

-- Boss shadows
local MAX_BOSS_FRAMES = 8
function mod:BossShadows()
	for i = 1, MAX_BOSS_FRAMES do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton then
			unitbutton:CreateSoftShadow()
			unitbutton.Buffs.PostUpdateButton = mod.PostUpdateAura
			unitbutton.Debuffs.PostUpdateButton = mod.PostUpdateAura
		end
	end
end

-- Arena shadows
function mod:ArenaShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton then
			unitbutton:CreateSoftShadow()
			unitbutton.Buffs.PostUpdateButton = mod.PostUpdateAura
			unitbutton.Debuffs.PostUpdateButton = mod.PostUpdateAura
		end
	end
end

-- Tank shadows
function mod:TankShadows()
	for i = 1, 2 do
		local unitbutton = _G["ElvUF_TankUnitButton"..i]
		if unitbutton then
			unitbutton:CreateSoftShadow()
			unitbutton.Buffs.PostUpdateButton = mod.PostUpdateAura
			unitbutton.Debuffs.PostUpdateButton = mod.PostUpdateAura
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

function mod:PostUpdateAura(_, button)
	local db = (self.isNameplate and NP.db.colors) or UF.db.colors
	local enemyNPC = not button.isFriend and not button.isPlayer

	if not button.shadow then
		button:CreateSoftShadow()
	end

	local r, g, b
	if button.isDebuff then
		if enemyNPC then
			if db.auraByType then
				r, g, b = .9, .1, .1
			end
		elseif db.auraByDispels and button.debuffType and BadDispels[button.spellID] and E:IsDispellableByMe(button.debuffType) then
			r, g, b = .05, .85, .94
		elseif db.auraByType then
			local color = _G.DebuffTypeColor[button.debuffType] or _G.DebuffTypeColor.none
			r, g, b = color.r * 0.6, color.g * 0.6, color.b * 0.6
		end
	elseif db.auraByDispels and button.isStealable and not button.isFriend then
		r, g, b = .93, .91, .55
	end

	if not r then
		r, g, b = unpack((self.isNameplate and E.media.bordercolor) or E.media.unitframeBorderColor)
	end

	button:SetBackdropBorderColor(r, g, b)
	button.Icon:SetDesaturated(button.isDebuff and enemyNPC and button.canDesaturate)

	if button.needsButtonTrim then
		AB:TrimIcon(button)
		button.needsButtonTrim = nil
	end

	if button.needsUpdateCooldownPosition and (button.Cooldown and button.Cooldown.timer and button.Cooldown.timer.text) then
		UF:UpdateAuraCooldownPosition(button)
	end
end

function mod:ChangeDefaultOptions()
	E.Options.args.unitframe.args.individualUnits.args.player.args.power.args.height.max = 300
	E.Options.args.unitframe.args.individualUnits.args.player.args.power.args.detachGroup.args.detachedWidth.min = ((E.db.unitframe.thinBorders or E.PixelMode) and 3 or 7)
	E.Options.args.unitframe.args.individualUnits.args.target.args.power.args.height.max = 300
	E.Options.args.unitframe.args.individualUnits.args.target.args.power.args.detachGroup.args.detachedWidth.min = ((E.db.unitframe.thinBorders or E.PixelMode) and 3 or 7)
end

function mod:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Options" then return end
	mod:UnregisterEvent(event)
	mod:ChangeDefaultOptions()
end

function mod:Setup()
	mod:UnitDefaults()
	mod:InitPlayer()
	mod:InitTarget()
	mod:InitFocus()
	mod:InitPet()
	mod:InitTargetTarget()

	mod:InitParty()
	mod:InitRaid()

	mod:ChangePowerBarTexture()
	mod:ChangeHealthBarTexture()
	mod:InfoPanelColor()

	mod:Configure_RoleIcons()

	if BUI.ShadowMode then
		mod:UnitShadows()
		
		mod:PartyShadows()
		mod:RaidShadows()
		mod:BossShadows()
		mod:ArenaShadows()
		mod:TankShadows()
		mod:TankTargetShadows()

		for _, frame in pairs(UF.units) do
			if frame then
				mod:UnitPowerShadows(frame)
			end
		end

		-- AuraBars Shadows
		hooksecurefunc(UF, 'Configure_AuraBars', mod.Configure_AuraBars)
	end

	-- Group Health textures hooks
	if E.db.benikui.unitframes.textures.enableHealth then
		hooksecurefunc(UF, 'Update_PartyFrames', mod.ChangePartyHealthBarTexture)
		hooksecurefunc(UF, 'Update_RaidFrames', mod.ChangeRaidHealthBarTexture)
		hooksecurefunc(UF, 'Update_StatusBars', mod.ChangeHealthBarTexture)
	end

	-- Group Power textures hooks
	if E.db.benikui.unitframes.textures.enablePower then
		hooksecurefunc(UF, 'Update_AllFrames', mod.ChangeUnitPowerBarTexture)
		hooksecurefunc(UF, 'Update_RaidFrames', mod.ChangeRaidPowerBarTexture)
		hooksecurefunc(UF, 'Update_PartyFrames', mod.ChangePartyPowerBarTexture)
		hooksecurefunc(UF, 'Update_ArenaFrames', mod.ChangeArenaPowerBarTexture)
		hooksecurefunc(UF, 'Update_BossFrames', mod.ChangeBossPowerBarTexture)
		hooksecurefunc(UF, 'Update_StatusBars', mod.ChangePowerBarTexture)
	end

	-- ShapeShift fix
	hooksecurefunc(AB, 'StyleShapeShift', mod.ChangeUnitPowerBarTexture)
end


function mod:Initialize()
	if E.private.unitframe.enable ~= true then return end

	hooksecurefunc(UF, "LoadUnits", mod.Setup)
	hooksecurefunc(UF, "Configure_ReadyCheckIcon", mod.Configure_ReadyCheckIcon)

	self:RegisterEvent("ADDON_LOADED")
end

BUI:RegisterModule(mod:GetName())
