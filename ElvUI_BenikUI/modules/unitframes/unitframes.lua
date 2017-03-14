local E, L, V, P, G = unpack(ElvUI);
local UFB = E:NewModule('BuiUnits', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');

function UFB:UnitDefaults()
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

function UFB:UpdateUF()
	if E.db.unitframe.units.player.enable then
		UFB:ArrangePlayer()
	end
	
	if E.db.unitframe.units.target.enable then
		UFB:ArrangeTarget()
	end
	
	if E.db.unitframe.units.party.enable then
		UF:CreateAndUpdateHeaderGroup('party')
	end
end

function UFB:Configure_ReadyCheckIcon(frame)
	local tex = frame.ReadyCheck

	tex.readyTexture = [[Interface\AddOns\ElvUI_BenikUI\media\textures\ready]]
	tex.notReadyTexture = [[Interface\AddOns\ElvUI_BenikUI\media\textures\notready]]
	tex.waitingTexture = [[Interface\AddOns\ElvUI_BenikUI\media\textures\waiting]]
end

-- Unit Shadows
function UFB:UnitShadows()
	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if E.db.benikui.general.shadows then
			unitframe:CreateShadow('Default')
			unitframe.Buffs.PostUpdateIcon = UFB.PostUpdateAura
			unitframe.Buffs.spacing = 3
			unitframe.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
			unitframe.Debuffs.spacing = 3
		end
	end
end

-- Party Shadows
function UFB:PartyShadows()
	local header = _G['ElvUF_Party']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if E.db.benikui.general.shadows then
				unitbutton:CreateShadow('Default')
				unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
				unitbutton.Buffs.spacing = 3
				unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
				unitbutton.Debuffs.spacing = 3
			end
		end
	end
end

-- Raid Shadows
function UFB:RaidShadows()
	local header = _G['ElvUF_Raid']

	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if E.db.benikui.general.shadows then
				unitbutton:CreateShadow('Default')
				unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
				unitbutton.Buffs.spacing = 3
				unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
				unitbutton.Debuffs.spacing = 3
			end
		end
	end
end

-- Raid-40 Shadows
function UFB:Raid40Shadows()
	local header = _G['ElvUF_Raid40']

	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if E.db.benikui.general.shadows then
				unitbutton:CreateShadow('Default')
				unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
				unitbutton.Buffs.spacing = 3
				unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
				unitbutton.Debuffs.spacing = 3
			end
		end
	end
end

-- Boss shadows
function UFB:BossShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if E.db.benikui.general.shadows then
			unitbutton:CreateShadow('Default')
			unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Buffs.spacing = 3
			unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Debuffs.spacing = 3
		end
	end
end

-- Arena shadows
function UFB:ArenaShadows()

	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if E.db.benikui.general.shadows then
			unitbutton:CreateShadow('Default')
			unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Buffs.spacing = 3
			unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Debuffs.spacing = 3
		end
	end
end

function UFB:PostUpdateAura(unit, button, index)
	if not button.shadow then
		button:CreateShadow('Default')
	end
end


function UFB:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end
	UFB:UnregisterEvent(event)
	UFB:ChangeDefaultOptions()
end

function UFB:ChangeDefaultOptions()
	E.Options.args.unitframe.args.player.args.power.args.height.max = 300
	E.Options.args.unitframe.args.player.args.power.args.detachedWidth.min = ((E.db.unitframe.thinBorders or E.PixelMode) and 3 or 7)
	E.Options.args.unitframe.args.target.args.power.args.height.max = 300
	E.Options.args.unitframe.args.target.args.power.args.detachedWidth.min = ((E.db.unitframe.thinBorders or E.PixelMode) and 3 or 7)
end

function UFB:Initialize()
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
	
	self:UnitShadows()
	self:PartyShadows()
	self:RaidShadows()
	self:Raid40Shadows()
	self:BossShadows()
	self:ArenaShadows()

	hooksecurefunc(UF, "Configure_ReadyCheckIcon", UFB.Configure_ReadyCheckIcon)
	--hooksecurefunc(UF, "PostUpdateAura", UFB.PostUpdateAura)

	self:RegisterEvent("ADDON_LOADED")
end

E:RegisterModule(UFB:GetName())