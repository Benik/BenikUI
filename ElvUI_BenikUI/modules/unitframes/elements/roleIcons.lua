local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');


local pairs, select, random = pairs, select, random

-- GLOBALS: hooksecurefunc

local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsConnected = UnitIsConnected

local rolePaths = {
	TANK = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\tank.tga]],
	HEALER = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\healer.tga]],
	DAMAGER = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\dps.tga]]
}

function BU:UpdateRoleIcon()
	local lfdrole = self.GroupRoleIndicator
	if not self.db then return; end
	local db = self.db.roleIcon;
	if (not db) or (db and not db.enable) then
		lfdrole:Hide()
		return
	end

	local role = UnitGroupRolesAssigned(self.unit)
	if self.isForced and role == 'NONE' then
		local rnd = random(1, 3)
		role = rnd == 1 and "TANK" or (rnd == 2 and "HEALER" or (rnd == 3 and "DAMAGER"))
	end

	if (self.isForced or UnitIsConnected(self.unit)) and ((role == "DAMAGER" and db.damager) or (role == "HEALER" and db.healer) or (role == "TANK" and db.tank)) then
		lfdrole:SetTexture(rolePaths[role])
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

local function SetRoleIcons()
	for _, header in pairs(UF.headers) do

		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			for j = 1, group:GetNumChildren() do
				local unitbutton = select(j, group:GetChildren())
				if unitbutton.GroupRoleIndicator and unitbutton.GroupRoleIndicator.Override then
					unitbutton.GroupRoleIndicator.Override = BU.UpdateRoleIcon
					unitbutton:UnregisterEvent("UNIT_CONNECTION")
					unitbutton:RegisterEvent("UNIT_CONNECTION", BU.UpdateRoleIcon)
				end
			end
		end
	end
	UF:UpdateAllHeaders()
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)

	if BUI.SLE or E.db.benikui.unitframes.misc.svui == false then return end
	SetRoleIcons()
end)
