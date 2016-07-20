local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local select = select
local CreateFrame = CreateFrame
local UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction = UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS

-- GLOBALS: hooksecurefunc, ElvUF

function UFB:Construct_TargetFrame()
	local frame = _G["ElvUF_Target"]
	
	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	if E.db.benikui.general.benikuiStyle == true then
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
	
	if E.db.benikui.unitframes.target.portraitStyle ~= true or db.portrait.overlay == true then return end
	
	local targetClass = select(2, UnitClass("target"));

	do
		local portrait = frame.Portrait
		local power = frame.Power

		if frame.USE_PORTRAIT and portrait.backdrop.style and E.db.benikui.unitframes.target.portraitStyle then
			local maxValue = UnitPowerMax("target")
			local pType, pToken, altR, altG, altB = UnitPowerType("target")
			local mu = power.bg.multiplier or 1
			local color = ElvUF['colors'].power[pToken]
			local isPlayer = UnitIsPlayer("target")
			local classColor = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[targetClass] or RAID_CLASS_COLORS[targetClass])

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
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.target.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.target.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.target.portraitShadow
		
		frame.PORTRAIT_STYLING = E.db.benikui.unitframes.target.portraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.benikui.unitframes.target.portraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.target.getPlayerPortraitSize and E.db.benikui.unitframes.player.portraitWidth or E.db.benikui.unitframes.target.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.target.getPlayerPortraitSize and E.db.benikui.unitframes.player.ortraitHeight or E.db.benikui.unitframes.target.portraitHeight
	
		frame.PORTRAIT_AND_INFOPANEL = E.db.benikui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
		frame.POWER_VERTICAL = db.power.vertical
	end
	
	-- Power
	UFB:Configure_Power(frame)
	
	-- InfoPanel
	UFB:Configure_Infopanel(frame)
	
	-- Portrait
	UFB:Configure_Portrait(frame, false)

	frame:UpdateAllElements()
end

function UFB:PLAYER_TARGET_CHANGED()
	self:ScheduleTimer('RecolorTargetDetachedPortraitStyle', 0.02)
end

-- Needed for some post updates
hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
	local unitframeType = frame.unitframeType

	if unitframeType == "target" then
		UFB:Configure_Portrait(frame, false)
	end
end)

function UFB:InitTarget()
	self:Construct_TargetFrame()
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.ArrangeTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED')
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.RecolorTargetDetachedPortraitStyle)
end