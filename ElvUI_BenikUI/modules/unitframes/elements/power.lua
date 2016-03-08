local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
UF.LSM = LSM

-- Units
function UFB:ChangeUnitPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.powerbar.statusBar)
	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.Power then unitframe.Power:SetStatusBarTexture(bar) end
	end
end
hooksecurefunc(UF, "Update_AllFrames", UFB.ChangeUnitPowerBarTexture)

-- Raid
function UFB:ChangeRaidPowerBarTexture()
	local header = _G['ElvUF_Raid']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.powerbar.statusBar)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Power then
				unitbutton.Power:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_RaidFrames', UFB.ChangeRaidPowerBarTexture)

-- Raid-40
function UFB:ChangeRaid40PowerBarTexture()
	local header = _G['ElvUF_Raid40']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.powerbar.statusBar)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Power then
				unitbutton.Power:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_Raid40Frames', UFB.ChangeRaid40PowerBarTexture)

-- Party
function UFB:ChangePartyPowerBarTexture()
	local header = _G['ElvUF_Party']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.powerbar.statusBar)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Power then
				unitbutton.Power:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_PartyFrames', UFB.ChangePartyPowerBarTexture)

-- Arena
function UFB:ChangeArenaPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.powerbar.statusBar)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Arena"..i]
		if unitbutton.Power then
			unitbutton.Power:SetStatusBarTexture(bar)
		end
	end
end
hooksecurefunc(UF, 'Update_ArenaFrames', UFB.ChangeArenaPowerBarTexture)

-- Boss
function UFB:ChangeBossPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.powerbar.statusBar)
	for i = 1, 5 do
		local unitbutton = _G["ElvUF_Boss"..i]
		if unitbutton.Power then
			unitbutton.Power:SetStatusBarTexture(bar)
		end
	end
end
hooksecurefunc(UF, 'Update_BossFrames', UFB.ChangeBossPowerBarTexture)


function UFB:ChangePowerBarTexture()
	self:ChangeUnitPowerBarTexture()
	self:ChangeRaidPowerBarTexture()
	self:ChangeRaid40PowerBarTexture()
	self:ChangePartyPowerBarTexture()
	self:ChangeArenaPowerBarTexture()
	self:ChangeBossPowerBarTexture()
end
hooksecurefunc(UF, 'Update_StatusBars', UFB.ChangePowerBarTexture)