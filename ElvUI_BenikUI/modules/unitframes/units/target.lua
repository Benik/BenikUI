local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');

local _G = _G
local select = select
local CreateFrame = CreateFrame
local UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction = UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction

-- GLOBALS: hooksecurefunc, ElvUF

function BU:Construct_TargetFrame()
	local frame = _G["ElvUF_Target"]

	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	if E.db.benikui.general.benikuiStyle == true then
		frame.Portrait.backdrop:Style('Inside')
		frame.Portrait.backdrop.style:Hide()
	end

	if BUI.ShadowMode then
		frame.Power.backdrop:CreateSoftShadow()
		frame.Power.backdrop.shadow:Hide()
	end

	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangeTarget()
end

function BU:RecolorTargetDetachedPortraitStyle()
	local frame = _G["ElvUF_Target"]
	local db = E.db['unitframe']['units'].target

	if E.db.benikui.unitframes.target.portraitStyle ~= true or db.portrait.overlay == true then return end

	local targetClass = select(2, UnitClass("target"));

	do
		local portrait = frame.Portrait
		local power = frame.Power
		local r, g, b

		if frame.USE_PORTRAIT and portrait.backdrop.style and E.db.benikui.unitframes.target.portraitStyle then
			local maxValue = UnitPowerMax("target")
			local _, pToken, altR, altG, altB = UnitPowerType("target")
			local mu = power.BG.multiplier or 1
			local color = ElvUF['colors'].power[pToken]
			local isPlayer = UnitIsPlayer("target")
			local classColor = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[targetClass] or RAID_CLASS_COLORS[targetClass])

			if not power.colorClass then
				if maxValue > 0 then
					if color then
						r, g, b = color[1], color[2], color[3]
					else
						r, g, b = altR, altG, altB
					end
				else
					if color and mu then
						r, g, b = color[1] * mu, color[2] * mu, color[3] * mu
					end
				end
			else
				local reaction = UnitReaction('target', 'player')
				if maxValue > 0 then
					if isPlayer then
						r, g, b = classColor.r, classColor.g, classColor.b
					else
						if reaction then
							local tpet = ElvUF.colors.reaction[reaction]
							r, g, b = tpet[1], tpet[2], tpet[3]
						end
					end
				else
					if reaction and mu then
						local t = ElvUF.colors.reaction[reaction]
						r, g, b = t[1] * mu, t[2] * mu, t[3] * mu
					end
				end
			end
			portrait.backdrop.style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
		end
	end
end

function BU:RecolorTargetInfoPanel()
	local frame = _G["ElvUF_Target"]
	if not frame.USE_INFO_PANEL then return end
	local targetClass = select(2, UnitClass("target"));

	do
		local panel = frame.InfoPanel
		local isPlayer = UnitIsPlayer("target")
		local classColor = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[targetClass] or RAID_CLASS_COLORS[targetClass])
		local reaction = UnitReaction('target', 'player')
		local r, g, b

		if isPlayer then
			if E.db.benikui.unitframes.infoPanel.customColor == 1 then
				r, g, b = classColor.r, classColor.g, classColor.b
			else
				r, g, b = BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color)
			end
		else
			if reaction then
				local tpet = ElvUF.colors.reaction[reaction]
				if E.db.benikui.unitframes.infoPanel.customColor == 1 then
					r, g, b = tpet[1], tpet[2], tpet[3]
				else
					r, g, b = BUI:unpackColor(E.db.benikui.unitframes.infoPanel.color)
				end
			end
		end

		panel.color:SetVertexColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
	end
end

function BU:ArrangeTarget()
	local frame = _G["ElvUF_Target"]
	local db = E.db['unitframe']['units'].target

	do
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.target.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.target.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.target.portraitShadow
		frame.PORTRAIT_BACKDROP = E.db.benikui.unitframes.target.portraitBackdrop
		
		frame.PORTRAIT_STYLING = E.db.benikui.unitframes.target.portraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.benikui.unitframes.target.portraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.target.getPlayerPortraitSize and E.db.benikui.unitframes.player.portraitWidth or E.db.benikui.unitframes.target.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.target.getPlayerPortraitSize and E.db.benikui.unitframes.player.portraitHeight or E.db.benikui.unitframes.target.portraitHeight
		frame.DETACHED_PORTRAIT_STRATA = E.db.benikui.unitframes.target.portraitFrameStrata

		frame.PORTRAIT_AND_INFOPANEL = E.db.benikui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
		frame.POWER_VERTICAL = db.power.vertical
	end

	-- Power
	BU:Configure_Power(frame)

	-- InfoPanel
	BU:Configure_Infopanel(frame)

	-- Portrait
	BU:Configure_Portrait(frame, false)

	-- AuraBars shadows
	BU:Configure_AuraBars(frame)

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function BU:PLAYER_TARGET_CHANGED()
	self:ScheduleTimer('RecolorTargetDetachedPortraitStyle', 0.02)
	self:ScheduleTimer('RecolorTargetInfoPanel', 0.02)
end

function BU:InitTarget()
	if not E.db.unitframe.units.target.enable then return end
	self:Construct_TargetFrame()
	hooksecurefunc(UF, 'Update_TargetFrame', BU.ArrangeTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED')
	hooksecurefunc(UF, 'Update_TargetFrame', BU.RecolorTargetDetachedPortraitStyle)
	hooksecurefunc(UF, 'Update_TargetFrame', BU.RecolorTargetInfoPanel)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "target" then
			BU:Configure_Portrait(frame, false)
		end
	end)
end