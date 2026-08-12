local BUI, E, L, V, P, G = unpack((select(2, ...)))
local ElvUF = E.oUF
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local UnitClass = UnitClass
local UnitPowerMax = UnitPowerMax
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

local CUSTOM_CLASS_COLORS = _G.CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS

function BU:Construct_TargetFrame()
	local frame = _G["ElvUF_Target"]

	if E.db.benikui.general.shadows then
		if not frame.Portrait.backdrop.shadow then
			frame.Portrait.backdrop:CreateSoftShadow()
			frame.Portrait.backdrop.shadow:Hide()
		end
	end

	if E.db.benikui.general.benikuiStyle == true then
		frame.Portrait.backdrop:BuiStyle('Inside')
		frame.Portrait.backdrop.style:Hide()
	end

	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangeTarget()
end

function BU:RecolorTargetDetachedPortraitStyle()
	local frame = _G["ElvUF_Target"]
	local db = E.db['unitframe']['units'].target

	if E.db.benikui.unitframes.target.portraitStyle ~= true or db.portrait.overlay == true then return end

	do
		local portrait = frame.Portrait
		local power = frame.Power
		local r, g, b = 0, 0, 0

		if frame.USE_PORTRAIT and portrait and portrait.backdrop and portrait.backdrop.style and E.db.benikui.unitframes.target.portraitStyle then
			local maxValue = UnitPowerMax("target")
			local mu = power and power.bg and power.bg.multiplier or 1
			local isPlayer = UnitIsPlayer("target") or UnitInPartyIsAI("target")
			local _, targetClass = UnitClass("target")
			local reaction = UnitReaction("target", "player")

			if E:NotSecretValue(maxValue) and maxValue > 0 then
				if isPlayer then
					local classColor = E:NotSecretValue(targetClass) and (ElvUF.colors.class[targetClass] or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[targetClass]) or RAID_CLASS_COLORS[targetClass])
					if classColor then
						r, g, b = classColor.r, classColor.g, classColor.b
					end
				else
					if E:NotSecretValue(reaction) and ElvUF.colors.reaction[reaction] then
						local tpet = ElvUF.colors.reaction[reaction]
						r, g, b = tpet.r or tpet[1] or 0, tpet.g or tpet[2] or 0, tpet.b or tpet[3] or 0
					end
				end
			else
				if E:NotSecretValue(reaction) and ElvUF.colors.reaction[reaction] and mu then
					local t = ElvUF.colors.reaction[reaction]
					local tr, tg, tb = t.r or t[1] or 0, t.g or t[2] or 0, t.b or t[3] or 0
					r, g, b = tr * mu, tg * mu, tb * mu
				end
			end

			portrait.backdrop.style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
		end
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

		frame.IS_ELTREUM = BUI.ELT and frame.InfoPanelOnTop
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
	BU:RecolorTargetDetachedPortraitStyle()
end

function BU:InitTarget()
	if not E.db.unitframe.units.target.enable then return end
	self:Construct_TargetFrame()
	hooksecurefunc(UF, 'Update_TargetFrame', BU.ArrangeTarget)
	hooksecurefunc(UF, 'Update_TargetFrame', BU.RecolorTargetDetachedPortraitStyle)
	
	self:RegisterEvent('PLAYER_TARGET_CHANGED')

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "target" then
			BU:Configure_Portrait(frame, false)
		end
	end)

	hooksecurefunc(UF, "Configure_Power", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "target" then
			BU:UnitPowerShadows(frame)
		end
	end)
end