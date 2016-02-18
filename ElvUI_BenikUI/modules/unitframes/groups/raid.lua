local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

function UFB:Update_RaidFrames(frame, db)
	frame.db = db

	do
		--frame.USE_EMPTY_BAR = db.emptybar.enable
		--frame.EMPTY_BARS_HEIGHT = db.emptybar.height
		--frame.EMPTY_BARS_TRANSPARENCY = db.emptybar.transparent
		--frame.EMPTY_BARS_SHADOW = db.emptybar.shadow
		--frame.EMPTY_BAR_THREAT = db.emptybar.threat
	end

	-- EmptyBar
	--UFB:Configure_EmptyBar(frame)
	
	-- Portrait
	--UFB:Configure_Portrait(frame)

	--Threat
	--UFB:Configure_Threat(frame)
	
	-- Target Glow
	--UFB:Configure_TargetGlow(frame)
	
	-- Role Icon
	UFB:Configure_RoleIcons(frame)

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