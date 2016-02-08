local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

function UFB:Update_RaidFrames(frame, db)
	frame.db = db

	do
		frame.USE_EMPTY_BAR = db.emptybar.enable
		frame.EMPTY_BARS_HEIGHT = db.emptybar.height
		frame.EMPTY_BARS_TRANSPARENCY = db.emptybar.transparent
		frame.EMPTY_BARS_SHADOW = db.emptybar.shadow
		frame.EMPTY_BAR_THREAT = db.emptybar.threat
	end

	-- EmptyBar
	do
		UFB:Configure_EmptyBar(frame)
	end
	
	-- Portrait
	do
		UFB:Configure_SimplePortrait(frame)
	end

	--Threat
	do
		UFB:Configure_Threat(frame)
	end
	
	-- Target Glow
	do
		UFB:Configure_TargetGlow(frame)
	end
	
	-- Role Icon
	do
		UFB:Configure_RoleIcons(frame)
	end

	frame:UpdateAllElements()
end

function UFB:InitRaid()
	hooksecurefunc(UF, 'Update_RaidFrames', UFB.Update_RaidFrames)
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