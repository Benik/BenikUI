local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UF = E:GetModule('UnitFrames');

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