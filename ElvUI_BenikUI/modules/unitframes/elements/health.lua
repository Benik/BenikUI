local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');
local LSM = E.LSM;

local _G = _G
local select = select

-- Raid
function BU:ChangeRaidHealthBarTexture()
	local header = _G['ElvUF_Raid']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.health)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Health then
				if not unitbutton.Health.isTransparent or (unitbutton.Health.isTransparent and E.db.benikui.unitframes.textures.ignoreTransparency) then
					unitbutton.Health:SetStatusBarTexture(bar)
				end
			end
		end
	end
end
hooksecurefunc(UF, 'Update_RaidFrames', BU.ChangeRaidHealthBarTexture)

-- Raid-40
function BU:ChangeRaid40HealthBarTexture()
	local header = _G['ElvUF_Raid40']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.health)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Health then
				if not unitbutton.Health.isTransparent or (unitbutton.Health.isTransparent and E.db.benikui.unitframes.textures.ignoreTransparency) then
					unitbutton.Health:SetStatusBarTexture(bar)
				end
			end
		end
	end
end
hooksecurefunc(UF, 'Update_Raid40Frames', BU.ChangeRaid40HealthBarTexture)

-- Party
function BU:ChangePartyHealthBarTexture()
	local header = _G['ElvUF_Party']
	local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.health)
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if unitbutton.Health then
				if not unitbutton.Health.isTransparent or (unitbutton.Health.isTransparent and E.db.benikui.unitframes.textures.ignoreTransparency) then
					unitbutton.Health:SetStatusBarTexture(bar)
				end
			end
		end
	end
end
hooksecurefunc(UF, 'Update_PartyFrames', BU.ChangePartyHealthBarTexture)

function BU:ChangeHealthBarTexture()
	BU:ChangeRaidHealthBarTexture()
	BU:ChangeRaid40HealthBarTexture()
	BU:ChangePartyHealthBarTexture()
end
hooksecurefunc(UF, 'Update_StatusBars', BU.ChangeHealthBarTexture)