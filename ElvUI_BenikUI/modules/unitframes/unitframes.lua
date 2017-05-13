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
		unitframe:CreateShadow('Default')
		unitframe.Buffs.PostUpdateIcon = UFB.PostUpdateAura
		unitframe.Buffs.spacing = 3
		unitframe.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
		unitframe.Debuffs.spacing = 3
	end
end

-- Party Shadows
function UFB:PartyShadows()
	local header = _G['ElvUF_Party']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			unitbutton:CreateShadow('Default')
			unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Buffs.spacing = 3
			unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Debuffs.spacing = 3
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
			unitbutton:CreateShadow('Default')
			unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Buffs.spacing = 3
			unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Debuffs.spacing = 3
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
			unitbutton:CreateShadow('Default')
			unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Buffs.spacing = 3
			unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
			unitbutton.Debuffs.spacing = 3
		end
	end
end

-- Boss shadows
function UFB:BossShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		unitbutton:CreateShadow('Default')
		unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
		unitbutton.Buffs.spacing = 3
		unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
		unitbutton.Debuffs.spacing = 3
	end
end

-- Arena shadows
function UFB:ArenaShadows()
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		unitbutton:CreateShadow('Default')
		unitbutton.Buffs.PostUpdateIcon = UFB.PostUpdateAura
		unitbutton.Buffs.spacing = 3
		unitbutton.Debuffs.PostUpdateIcon = UFB.PostUpdateAura
		unitbutton.Debuffs.spacing = 3
	end
end

function UFB:PostUpdateAura(unit, button, index)
	local name, _, _, _, dtype, duration, expiration, _, isStealable = UnitAura(unit, index, button.filter)
	if not button.shadow then
		button:CreateShadow('Default')
	end
	local isFriend = UnitIsFriend('player', unit)
	
	local auras = button:GetParent()
	local frame = auras:GetParent()
	local type = auras.type
	local db = frame.db and frame.db[type]

	if db then
		if db.clickThrough and button:IsMouseEnabled() then
			button:EnableMouse(false)
		elseif not db.clickThrough and not button:IsMouseEnabled() then
			button:EnableMouse(true)
		end
	end

	if button.isDebuff then
		if(not isFriend and button.owner ~= "player" and button.owner ~= "vehicle") --[[and (not E.isDebuffWhiteList[name])]] then
			button:SetBackdropBorderColor(0.9, 0.1, 0.1)
			button.icon:SetDesaturated((unit and not unit:find('arena%d')) and true or false)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			if (name == "Unstable Affliction" or name == "Vampiric Touch") and E.myclass ~= "WARLOCK" then
				button:SetBackdropBorderColor(0.05, 0.85, 0.94)
			else
				button:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			end
			button.icon:SetDesaturated(false)
		end
	else
		if (isStealable) and not isFriend then
			button:SetBackdropBorderColor(237/255, 234/255, 142/255)
		else
			button:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		end
	end

	local size = button:GetParent().size
	if size then
		button:SetSize(size, size)
	end

	button.spell = name
	button.isStealable = isStealable
	button.duration = duration

	if expiration and duration ~= 0 then
		if not button:GetScript('OnUpdate') then
			button.expirationTime = expiration
			button.expiration = expiration - GetTime()
			button.nextupdate = -1
			button:SetScript('OnUpdate', UF.UpdateAuraTimer)
		end
		if (button.expirationTime ~= expiration) or (button.expiration ~= (expiration - GetTime()))  then
			button.expirationTime = expiration
			button.expiration = expiration - GetTime()
			button.nextupdate = -1
		end
	end
	if duration == 0 or expiration == 0 then
		button.expirationTime = nil
		button.expiration = nil
		button.priority = nil
		button.duration = nil
		button:SetScript('OnUpdate', nil)
		if(button.text:GetFont()) then
			button.text:SetText('')
		end
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

	if E.db.benikui.general.shadows then
		self:UnitShadows()
		self:PartyShadows()
		self:RaidShadows()
		self:Raid40Shadows()
		self:BossShadows()
		self:ArenaShadows()
	end

	hooksecurefunc(UF, "Configure_ReadyCheckIcon", UFB.Configure_ReadyCheckIcon)
	self:RegisterEvent("ADDON_LOADED")
end

local function InitializeCallback()
	UFB:Initialize()
end

E:RegisterModule(UFB:GetName(), InitializeCallback)