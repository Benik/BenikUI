local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

local select, unpack = select, unpack

local UnitClass = UnitClass
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

function UFB:Update_RaidFrames(frame, db)
	frame.db = db

	do

	end
	
	-- Role Icon
	UFB:Configure_RoleIcons(frame)

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function UFB:InitRaid()
	--hooksecurefunc(UF, 'Update_RaidFrames', UFB.Update_RaidFrames)
end

-- raid, raid40 mouseover classcolor
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

hooksecurefunc(UF, 'Update_RaidFrames', HoverClassColor)
hooksecurefunc(UF, 'Update_Raid40Frames', HoverClassColor)