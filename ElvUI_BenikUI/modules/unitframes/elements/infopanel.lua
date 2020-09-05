local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');
local LSM = E.LSM;

function BU:Configure_Infopanel(frame)
	if frame.ORIENTATION == "RIGHT" and not (frame.unitframeType == "arena") then
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.PORTRAIT_WIDTH -UF.BORDER - UF.SPACING, UF.BORDER + UF.SPACING)
		else
			frame.InfoPanel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -UF.BORDER - UF.SPACING, UF.BORDER + UF.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:Point("TOPLEFT", frame.Power.backdrop, "BOTTOMLEFT", UF.BORDER, -(frame.SPACING*3))
		else
			frame.InfoPanel:Point("TOPLEFT", frame.Health.backdrop, "BOTTOMLEFT", UF.BORDER, -(frame.SPACING*3))
		end
	else
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.PORTRAIT_WIDTH +UF.BORDER + UF.SPACING, UF.BORDER + UF.SPACING)
		else
			frame.InfoPanel:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", UF.BORDER + UF.SPACING, UF.BORDER + UF.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:Point("TOPRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", -UF.BORDER, -(UF.SPACING*3))
		else
			frame.InfoPanel:Point("TOPRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", -UF.BORDER, -(UF.SPACING*3))
		end
	end
end

local function GetClassColor(unit)
	local unitReaction = UnitReaction(unit, 'player')
	local unitPlayer = UnitIsPlayer(unit)

	if (unitPlayer) then
		local _, unitClass = UnitClass(unit)
		local classColor = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[unitClass] or RAID_CLASS_COLORS[unitClass])
		return classColor.r, classColor.g, classColor.b
	elseif (unitReaction) then
		local reaction = ElvUF.colors.reaction[unitReaction]
		return reaction[1], reaction[2], reaction[3]
	else
		return 255, 128, 128
	end
end

-- Units
function BU:UnitInfoPanelColor()
	if not E.db.benikui.unitframes.infoPanel.enableColor then return end

	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for unit, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")
		local r, g, b
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.InfoPanel then
			if not unitframe.InfoPanel.color then
				unitframe.InfoPanel.color = unitframe.InfoPanel:CreateTexture(nil, 'OVERLAY')
				unitframe.InfoPanel.color:SetAllPoints()
			end
			unitframe.InfoPanel.color:SetTexture(bar)
			if E.db.benikui.unitframes.infoPanel.customColor == 1 then
				r, g, b = GetClassColor(unit)
			else
				r, g, b = BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color)
			end
			unitframe.InfoPanel.color:SetVertexColor(r, g, b)
		end
	end
end

-- Raid
function BU:RaidInfoPanelColor()
	local header = _G['ElvUF_Raid']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.InfoPanel then
				if not unitbutton.InfoPanel.color then
					unitbutton.InfoPanel.color = unitbutton.InfoPanel:CreateTexture(nil, 'OVERLAY')
					unitbutton.InfoPanel.color:SetAllPoints()
				end
				unitbutton.InfoPanel.color:SetTexture(bar)
				unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.groupColor))
			end
		end
	end
end

-- Raid-40
function BU:Raid40InfoPanelColor()
	local header = _G['ElvUF_Raid40']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.InfoPanel then
				if not unitbutton.InfoPanel.color then
					unitbutton.InfoPanel.color = unitbutton.InfoPanel:CreateTexture(nil, 'OVERLAY')
					unitbutton.InfoPanel.color:SetAllPoints()
				end
				unitbutton.InfoPanel.color:SetTexture(bar)
				unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.groupColor))
			end
		end
	end
end

-- Party
function BU:PartyInfoPanelColor()
	local header = _G['ElvUF_Party']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.InfoPanel then
				if not unitbutton.InfoPanel.color then
					unitbutton.InfoPanel.color = unitbutton.InfoPanel:CreateTexture(nil, 'OVERLAY')
					unitbutton.InfoPanel.color:SetAllPoints()
				end
				unitbutton.InfoPanel.color:SetTexture(bar)
				unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.groupColor))
			end
		end
	end
end

-- Arena
function BU:ArenaInfoPanelColor()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton.InfoPanel then
			if not unitbutton.InfoPanel.color then
				unitbutton.InfoPanel.color = unitbutton.InfoPanel:CreateTexture(nil, 'OVERLAY')
				unitbutton.InfoPanel.color:SetAllPoints()
			end
			unitbutton.InfoPanel.color:SetTexture(bar)
			unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.groupColor))
		end
	end
end

-- Boss
function BU:BossInfoPanelColor()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton.InfoPanel then
			if not unitbutton.InfoPanel.color then
				unitbutton.InfoPanel.color = unitbutton.InfoPanel:CreateTexture(nil, 'OVERLAY')
				unitbutton.InfoPanel.color:SetAllPoints()
			end
			unitbutton.InfoPanel.color:SetTexture(bar)
			unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.groupColor))
		end
	end
end

function BU:UpdateGroupInfoPanelColor()
	if not E.db.benikui.unitframes.infoPanel.enableColor then return end
	self:RaidInfoPanelColor()
	self:Raid40InfoPanelColor()
	self:PartyInfoPanelColor()
	self:ArenaInfoPanelColor()
	self:BossInfoPanelColor()
end

function BU:InfoPanelColor()
	if not E.db.benikui.unitframes.infoPanel.enableColor then return end
	self:UnitInfoPanelColor()
	self:UpdateGroupInfoPanelColor()
	self:RegisterEvent('UNIT_NAME_UPDATE', BU.UnitInfoPanelColor)
	self:RegisterEvent('UNIT_FACTION', BU.UnitInfoPanelColor)
	self:RegisterEvent('INSTANCE_ENCOUNTER_ENGAGE_UNIT', BU.UnitInfoPanelColor)
	hooksecurefunc(UF, 'Update_TargetFrame', BU.UnitInfoPanelColor)
end