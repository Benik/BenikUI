local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local select = select
local CreateFrame = CreateFrame
local UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction = UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

function UFB:Construct_TargetFrame()
	local frame = _G["ElvUF_Target"]
	frame.EmptyBar = self:CreateEmptyBar(frame)
	
	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	if E.db.bui.buiStyle == true then
		frame.Portrait.backdrop:Style('Outside')
		frame.Portrait.backdrop.style:Hide()
	end
	
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f
	
	self:ArrangeTarget()
end

function UFB:RecolorTargetDetachedPortraitStyle()
	local frame = _G["ElvUF_Target"]
	local db = E.db['unitframe']['units'].target
	
	if E.db.ufb.TargetPortraitStyle ~= true or db.portrait.overlay == true then return end
	
	local USE_PORTRAIT = db.portrait.enable
	local targetClass = select(2, UnitClass("target"));

	do
		local portrait = frame.Portrait
		local power = frame.Power

		if USE_PORTRAIT and portrait.backdrop.style and E.db.ufb.TargetPortraitStyle then
			local maxValue = UnitPowerMax("target")
			local pType, pToken, altR, altG, altB = UnitPowerType("target")
			local mu = power.bg.multiplier or 1
			local color = ElvUF['colors'].power[pToken]
			local isPlayer = UnitIsPlayer("target")
			local classColor = RAID_CLASS_COLORS[targetClass]

			if not power.colorClass then
				if maxValue > 0 then
					if color then
						portrait.backdrop.style.color:SetVertexColor(color[1], color[2], color[3])
					else
						portrait.backdrop.style.color:SetVertexColor(altR, altG, altB)
					end
				else
					if color then
						portrait.backdrop.style.color:SetVertexColor(color[1] * mu, color[2] * mu, color[3] * mu)
					end
				end
			else
				local reaction = UnitReaction('target', 'player')
				if maxValue > 0 then
					if isPlayer then
						portrait.backdrop.style.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
					else
						if reaction then
							local tpet = ElvUF.colors.reaction[reaction]
							portrait.backdrop.style.color:SetVertexColor(tpet[1], tpet[2], tpet[3])
						end
					end
				else
					if reaction then
						local t = ElvUF.colors.reaction[reaction]
						portrait.backdrop.style.color:SetVertexColor(t[1] * mu, t[2] * mu, t[3] * mu)
					end
				end
			end	
		end
	end
end

function UFB:ArrangeTarget()
	local frame = _G["ElvUF_Target"]
	local db = E.db['unitframe']['units'].target

	do
		frame.USE_EMPTY_BAR = E.db.ufb.barshow
		frame.EMPTY_BARS_HEIGHT = E.db.ufb.barheight
		frame.EMPTY_BARS_TRANSPARENCY = E.db.ufb.toggleTransparency
		frame.EMPTY_BARS_SHADOW = E.db.ufb.toggleShadow
		
		frame.PORTRAIT_DETACHED = E.db.ufb.detachTargetPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.ufb.TargetPortraitTransparent
		frame.PORTRAIT_SHADOW = E.db.ufb.TargetPortraitShadow
		
		frame.PORTRAIT_STYLING = E.db.ufb.TargetPortraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.ufb.TargetPortraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitWidth or E.db.ufb.TargetPortraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitHeight or E.db.ufb.TargetPortraitHeight
	end
	
	-- Empty Bar
	do
		UFB:Configure_EmptyBar(frame)
	end
	
	-- Portrait
	do
		UFB:Configure_Portrait(frame, false)
	end
	
	--Threat
	do
		UFB:Configure_Threat(frame)
	end

	frame:UpdateAllElements()
end

function UFB:PLAYER_TARGET_CHANGED()
	self:ScheduleTimer('RecolorTargetDetachedPortraitStyle', 0.02)
end

function UFB:InitTarget()
	self:Construct_TargetFrame()
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.ArrangeTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED')
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.RecolorTargetDetachedPortraitStyle)
end