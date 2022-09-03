local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');
local LSM = E.LSM;

local _G = _G
local select = select

-- Raid
function BU:ChangeRaidHealthBarTexture()
	for i = 1, 3 do
		local header = _G['ElvUF_Raid'..i]
		local bar = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.health)
		for j = 1, header:GetNumChildren() do
			local group = select(j, header:GetChildren())

			for k = 1, group:GetNumChildren() do
				local unitbutton = select(k, group:GetChildren())
				if unitbutton.Health then
					if not unitbutton.Health.isTransparent or (unitbutton.Health.isTransparent and E.db.benikui.unitframes.textures.ignoreTransparency) then
						unitbutton.Health:SetStatusBarTexture(bar)
					end
				end
			end
		end
	end
end
hooksecurefunc(UF, 'Update_RaidFrames', BU.ChangeRaidHealthBarTexture)

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
	BU:ChangePartyHealthBarTexture()
end
hooksecurefunc(UF, 'Update_StatusBars', BU.ChangeHealthBarTexture)