local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
UF.LSM = LSM

local _G = _G
local select = select

-- Raid
function UFB:ChangeRaidHealthBarTexture()
	local header = _G['ElvUF_Raid']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.health)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Health and not unitbutton.Health.isTransparent then
				unitbutton.Health:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_RaidFrames', UFB.ChangeRaidHealthBarTexture)

-- Raid-40
function UFB:ChangeRaid40HealthBarTexture()
	local header = _G['ElvUF_Raid40']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.health)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Health and not unitbutton.Health.isTransparent then
				unitbutton.Health:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_Raid40Frames', UFB.ChangeRaid40HealthBarTexture)

-- Party
function UFB:ChangePartyHealthBarTexture()
	local header = _G['ElvUF_Party']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.health)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Health and not unitbutton.Health.isTransparent then
				unitbutton.Health:SetStatusBarTexture(bar)
			end
		end
	end
end
hooksecurefunc(UF, 'Update_PartyFrames', UFB.ChangePartyHealthBarTexture)

function UFB:ChangeHealthBarTexture()
	UFB:ChangeRaidHealthBarTexture()
	UFB:ChangeRaid40HealthBarTexture()
	UFB:ChangePartyHealthBarTexture()
end
hooksecurefunc(UF, 'Update_StatusBars', UFB.ChangeHealthBarTexture)