local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');

local select, unpack = select, unpack

local UnitClass = UnitClass
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

function BU:Update_RaidFrames(frame, db)
	frame.db = db

	do

	end

	-- Role Icon
	BU:Configure_RoleIcons(frame)

	if BUI.ShadowMode then
		frame:CreateSoftShadow()
	end

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function BU:InitRaid()
	--hooksecurefunc(UF, 'Update_RaidFrames', BU.Update_RaidFrames)
end

-- raid mouseover classcolor
local function HoverClassColor(self, frame, db)

	if db.classHover ~= true then return; end
	if frame.isMouseOverHooked then return; end

	local health = frame.Health.backdrop

	frame:HookScript("OnEnter", function(self)
		local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
		if (not hover) then return; end
		health:SetBackdropBorderColor( hover.r, hover.g, hover.b )
	end)

	frame:HookScript("OnLeave", function(self)
		health:SetBackdropBorderColor(unpack(E['media'].bordercolor))
	end)

	frame.isMouseOverHooked = true
end

--hooksecurefunc(UF, 'Update_RaidFrames', HoverClassColor)
