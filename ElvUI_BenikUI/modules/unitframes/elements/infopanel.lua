local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local BUI = E:GetModule('BenikUI');
local UFB = E:GetModule('BuiUnits');
local LSM = LibStub("LibSharedMedia-3.0");
UF.LSM = LSM

function UFB:Configure_Infopanel(frame)
	if frame.ORIENTATION == "RIGHT" and not (frame.unitframeType == "arena") then
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.PORTRAIT_WIDTH -frame.BORDER - frame.SPACING, frame.BORDER + frame.SPACING)
		else
			frame.InfoPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.BORDER - frame.SPACING, frame.BORDER + frame.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:SetPoint("TOPLEFT", frame.Power.backdrop, "BOTTOMLEFT", frame.BORDER, -(frame.SPACING*3))
		else
			frame.InfoPanel:SetPoint("TOPLEFT", frame.Health.backdrop, "BOTTOMLEFT", frame.BORDER, -(frame.SPACING*3))
		end
	else
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.PORTRAIT_WIDTH +frame.BORDER + frame.SPACING, frame.BORDER + frame.SPACING)			
		else
			frame.InfoPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.BORDER + frame.SPACING, frame.BORDER + frame.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:SetPoint("TOPRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", -frame.BORDER, -(frame.SPACING*3))
		else
			frame.InfoPanel:SetPoint("TOPRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER, -(frame.SPACING*3))
		end
	end
end

-- Units
function UFB:UnitInfoPanelColor()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.InfoPanel then
			if not unitframe.InfoPanel.color then
				unitframe.InfoPanel.color = unitframe.InfoPanel:CreateTexture(nil, 'OVERLAY')
				unitframe.InfoPanel.color:SetAllPoints()
			end
			unitframe.InfoPanel.color:SetTexture(bar)
			unitframe.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color))
		end
	end
end

-- Raid
function UFB:RaidInfoPanelColor()
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
				unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color))
			end
		end
	end
end

-- Raid-40
function UFB:Raid40InfoPanelColor()
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
				unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color))
			end
		end
	end
end

-- Party
function UFB:PartyInfoPanelColor()
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
				unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color))
			end
		end
	end
end

-- Arena
function UFB:ArenaInfoPanelColor()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton.InfoPanel then
			if not unitbutton.InfoPanel.color then
				unitbutton.InfoPanel.color = unitbutton.InfoPanel:CreateTexture(nil, 'OVERLAY')
				unitbutton.InfoPanel.color:SetAllPoints()
			end
			unitbutton.InfoPanel.color:SetTexture(bar)
			unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color))
		end
	end
end

-- Boss
function UFB:BossInfoPanelColor()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.infoPanel.texture)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton.InfoPanel then
			if not unitbutton.InfoPanel.color then
				unitbutton.InfoPanel.color = unitbutton.InfoPanel:CreateTexture(nil, 'OVERLAY')
				unitbutton.InfoPanel.color:SetAllPoints()
			end
			unitbutton.InfoPanel.color:SetTexture(bar)
			unitbutton.InfoPanel.color:SetVertexColor(BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color))
		end
	end
end

function UFB:InfoPanelColor()
	UFB:UnitInfoPanelColor()
	UFB:RaidInfoPanelColor()
	UFB:Raid40InfoPanelColor()
	UFB:PartyInfoPanelColor()
	UFB:ArenaInfoPanelColor()
	UFB:BossInfoPanelColor()
end