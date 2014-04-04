local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');
local M = E:GetModule('Misc');

local SPACING = E.Spacing;
local BORDER = E.Border;

local frame = _G["ElvUF_Player"]

local function playerbar_onEnter(self)
	if InCombatLockdown() then return end
	if E.db.xprep.show == 'XP' then
		if UnitLevel('player') ~= MAX_PLAYER_LEVEL and E.db.general.experience.enable and not IsXPUserDisabled() then
			ElvUI_ExperienceBar.statusBar:Show()
			ElvUI_ExperienceBar.rested:Show()

			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -6)
			
			local cur, max = M:GetXP('player')
			local level = UnitLevel('player')
			
			GameTooltip:AddLine((LEVEL..format(' : %d', level)), 0, 1, 0)
			GameTooltip:AddLine(' ')
			
			GameTooltip:AddDoubleLine(XP.." :", format(' %d / %d (%d%%)', cur, max, cur/max * 100), 1, 1, 1)
			GameTooltip:AddDoubleLine(L['Remaining :'], format(' %d (%d%% - %d '..L['Bars']..')', max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)	
			
			if rested then
				GameTooltip:AddDoubleLine(L['Rested:'], format('+%d (%d%%)', rested, rested / max * 100), 1, 1, 1)
			end
			GameTooltip:Show()
		end
	elseif E.db.xprep.show == 'REP' then
		local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
		if E.db.general.reputation.enable and name then
			ElvUI_ReputationBar.statusBar:Show()
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -6)

			local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
			if name then
				GameTooltip:AddLine(name)
				GameTooltip:AddLine(' ')
				
				GameTooltip:AddDoubleLine(STANDING..' :', friendID and friendTextLevel or _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
				GameTooltip:AddDoubleLine(REPUTATION..' :', format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100), 1, 1, 1)
			end
			GameTooltip:Show()
		end
	end
end

local function playerbar_onLeave(self)
	if E.db.xprep.show == 'XP' then
		ElvUI_ExperienceBar.statusBar:Hide()
		if ElvUI_ExperienceBar.rested then ElvUI_ExperienceBar.rested:Hide() end
		GameTooltip:Hide()
	elseif E.db.xprep.show == 'REP' then
		ElvUI_ReputationBar.statusBar:Hide()
		GameTooltip:Hide()
	end
end

function UFB:ApplyPlayerChanges()

	local playerbar = _G["BUI_PlayerBar"] or CreateFrame('Frame', 'BUI_PlayerBar', E.UIParent)
	playerbar:SetTemplate('Transparent')
	playerbar:SetParent(frame)
	playerbar:SetFrameStrata('BACKGROUND')
	playerbar:SetScript('OnEnter', playerbar_onEnter)
	playerbar:SetScript('OnLeave', playerbar_onLeave)
	
	--Create a frame we can anchor portrait.backdrop to.
	--This frame is persistent regardless of portrait style and will fix the issue of portrait not following mover when changing style.
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangePlayer()
end

function UFB:ArrangePlayer()
	local EMPTY_BARS_HEIGHT = E.db.ufb.barheight
	local PlayerBar = BUI_PlayerBar
	local db = E.db['unitframe']['units'].player
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local PORTRAIT_DETACHED = E.db.ufb.detachPlayerPortrait

	local USE_POWERBAR = db.power.enable
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local POWERBAR_DETACHED = db.power.detachFromFrame
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR and not POWERBAR_DETACHED
	local POWERBAR_OFFSET = db.power.offset
	local POWERBAR_HEIGHT = db.power.height
	local POWERBAR_WIDTH = POWERBAR_DETACHED and db.power.detachedWidth or (db.width - (BORDER*2))

	local USE_CLASSBAR = db.classbar.enable and CAN_HAVE_CLASSBAR
	local USE_MINI_CLASSBAR = db.classbar.fill == "spaced" and USE_CLASSBAR and db.classbar.detachFromFrame ~= true
	local CLASSBAR_HEIGHT = db.classbar.height
	local CLASSBAR_WIDTH = db.width - (BORDER*2)
	
	local USE_EMPTY_BAR = E.db.ufb.barshow
	local PLAYER_PORTRAIT_WIDTH = E.db.ufb.PlayerPortraitWidth
	local PLAYER_PORTRAIT_HEIGHT = E.db.ufb.PlayerPortraitHeight
	
	-- Empty Bar
	do
		local health = frame.Health
		local power = frame.Power
		if USE_EMPTY_BAR then
			PlayerBar:Show()
			
			if USE_POWERBAR_OFFSET then
				PlayerBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, 0)
				PlayerBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)		
			elseif USE_MINI_POWERBAR or USE_INSET_POWERBAR then
				PlayerBar:Point('TOPLEFT', health, 'BOTTOMLEFT', -BORDER, 0)
				PlayerBar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif POWERBAR_DETACHED or not USE_POWERBAR then
				PlayerBar:Point('TOPLEFT', health.backdrop, 'BOTTOMLEFT', 0, BORDER)
				PlayerBar:Point('BOTTOMRIGHT', health.backdrop, 'BOTTOMRIGHT', 0, -EMPTY_BARS_HEIGHT)		
			else
				PlayerBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, BORDER)
				PlayerBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			end
		else
			PlayerBar:Hide()
		end
	end
	
	-- Portrait
	do	
		local portrait = frame.Portrait --Need to make them local here, since frame.Portrait changes whether you use 2D or 3D. It needs to update when executed.
		if USE_PORTRAIT then
			if not USE_PORTRAIT_OVERLAY then
				if not portrait.backdrop.shadow then
					portrait.backdrop:CreateSoftShadow()
					portrait.backdrop.shadow:SetAlpha(0)
				end
				
				if E.db.ufb.PlayerPortraitTransparent then
					portrait.backdrop:SetTemplate('Transparent')
				else
					portrait.backdrop:SetTemplate('Default', true)
				end

				if E.db.ufb.PlayerPortraitShadow and PORTRAIT_DETACHED then
					portrait.backdrop.shadow:SetAlpha(1)
				else
					portrait.backdrop.shadow:SetAlpha(0)
				end

				if PORTRAIT_DETACHED then
					frame.portraitmover:Width(PLAYER_PORTRAIT_WIDTH)
					frame.portraitmover:Height(PLAYER_PORTRAIT_HEIGHT)
					portrait.backdrop:SetAllPoints(frame.portraitmover)

					if not frame.portraitmover.mover then
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:Point('TOPRIGHT', frame, 'TOPLEFT', -BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PlayerPortraitMover', 'Player Portrait', nil, nil, nil, 'ALL,SOLO')
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
					else
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")		
					end
				else
					portrait.backdrop:ClearAllPoints()
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", BORDER, 0)

					if USE_EMPTY_BAR then
						portrait.backdrop:Point("BOTTOMRIGHT", PlayerBar, "BOTTOMLEFT", E.PixelMode and 1 or -SPACING, 0)
					elseif USE_MINI_POWERBAR or USE_POWERBAR_OFFSET or not USE_POWERBAR or USE_INSET_POWERBAR or POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", E.PixelMode and 1 or -SPACING, 0)
					else
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", E.PixelMode and 1 or -SPACING, 0)
					end
					
					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameLevel(frame.Power:GetFrameLevel() + 1)
					end
				end
				portrait:ClearAllPoints()
				portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', BORDER, BORDER)		
				portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and db.portrait.style == '3D' and BORDER*2 or BORDER), -BORDER) --Fix portrait overlapping border when pixel mode and 3D style is enabled
			end
		end
	end
	frame:UpdateAllElements()
end

function UFB:InitPlayer()
	self:ApplyPlayerChanges()
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)
end