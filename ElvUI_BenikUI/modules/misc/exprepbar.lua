local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BXR = E:NewModule('BUIExpRep', 'AceHook-3.0', 'AceEvent-3.0')
local M = E:GetModule('Misc')
local LSM = LibStub('LibSharedMedia-3.0')

local frame = _G['ElvUF_Player']
local min_yOffset = -10

local function XpRepMouseOverText()

	if E.db.unitframe.units.player.health.yOffset < min_yOffset then
		frame.Health.value:SetAlpha(0)
	end
	
	if E.db.unitframe.units.player.power.yOffset < min_yOffset then
		frame.Power.value:SetAlpha(0)
	end

	if E.db.unitframe.units.player.name.yOffset < min_yOffset then
		frame.Name:SetAlpha(0)
	end	
	
	if E.db.unitframe.units.player.customTexts == {} then
		for objectName, _ in pairs(E.db.unitframe.units.player.customTexts) do
			if E.db.unitframe.units.player.customTexts[objectName].yOffset < min_yOffset then
				frame[objectName]:SetAlpha(0)
			end
		end
	end

end

local function xp_onEnter(self)
	if InCombatLockdown() then return end
	if E.db.xprep.text.mouseOver then
		XpRepMouseOverText()
	end
	self:SetAlpha(0.8)

	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -7)
	
	local cur, max = BXR:GetXP('player')
	local level = UnitLevel('player')
	
	GameTooltip:AddLine((LEVEL..format(' : %d', level)), 0, 1, 0)
	GameTooltip:AddLine(' ')
	
	GameTooltip:AddDoubleLine(XP..' :', format(' %d / %d (%d%%)', cur, max, cur/max * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine(L['Remaining :'], format(' %d (%d%% - %d '..L['Bars']..')', max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)	
	
	if rested then
		GameTooltip:AddDoubleLine(L['Rested:'], format('+%d (%d%%)', rested, rested / max * 100), 1, 1, 1)
	end
	GameTooltip:Show()
end

local function rep_onEnter(self)
	if InCombatLockdown() then return end
	if E.db.xprep.text.mouseOver then
		XpRepMouseOverText()
	end
	self:SetAlpha(0.6)
	
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -7)
	
	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
	local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
	if name then
		GameTooltip:AddLine(name)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(STANDING..' :', friendID and friendTextLevel or _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
		GameTooltip:AddDoubleLine(REPUTATION..' :', format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100), 1, 1, 1)
	end
	GameTooltip:Show()
end

local function bars_onLeave(self)
	self:SetAlpha(0)
	GameTooltip:Hide()
	if frame.Health.value:GetAlpha() == 0 then
		frame.Health.value:SetAlpha(1)
	end
	if frame.Power.value:GetAlpha() == 0 then
		frame.Power.value:SetAlpha(1)
	end
	if frame.Name:GetAlpha() == 0 then
		frame.Name:SetAlpha(1)
	end	
	if E.db.unitframe.units.player.customTexts == {} then
		for objectName, _ in pairs(E.db.unitframe.units.player.customTexts) do
			if frame[objectName]:GetAlpha() == 0 then
				frame[objectName]:SetAlpha(1)
			end
		end
	end
end

function BXR:GetXP(unit)
	if(unit == 'pet') then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

function BXR:UpdateExperience(event)

	local bar = self.xpbar

	if(UnitLevel('player') == MAX_PLAYER_LEVEL) or IsXPUserDisabled() then
		bar:Hide()
	else
		bar:Show()
		
		local cur, max = self:GetXP('player')
		bar:SetMinMaxValues(0, max)
		bar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
		bar:SetValue(cur)
		
		local rested = GetXPExhaustion()
		local text = ''
		local textFormat = E.db.xprep.text.tformat
		
		if rested and rested > 0 then
			bar.rested:SetMinMaxValues(0, max)
			bar.rested:SetValue(min(cur + rested, max))
			
			if textFormat == 'PERCENT' then
				text = format('%d%% R:%d%%', cur / max * 100, rested / max * 100)
			elseif textFormat == 'CURMAX' then
				text = format('%s - %s R:%s', E:ShortValue(cur), E:ShortValue(max), E:ShortValue(rested))
			elseif textFormat == 'CURPERC' then
				text = format('%s - %d%% R:%s [%d%%]', E:ShortValue(cur), cur / max * 100, E:ShortValue(rested), rested / max * 100)
			end
		else
			bar.rested:SetMinMaxValues(0, 1)
			bar.rested:SetValue(0)	

			if textFormat == 'PERCENT' then
				text = format('%d%%', cur / max * 100)
			elseif textFormat == 'CURMAX' then
				text = format('%s - %s', E:ShortValue(cur), E:ShortValue(max))
			elseif textFormat == 'CURPERC' then
				text = format('%s - %d%%', E:ShortValue(cur), cur / max * 100)
			end			
		end
		self:ChangeRepXpFont()
		bar.text:SetText(text)
	end

end

local backupColor = FACTION_BAR_COLORS[1]
function BXR:UpdateReputation(event)

	local bar = self.repbar
	
	local ID = 100
	local isFriend, friendText
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local numFactions = GetNumFactions();

	if not name then
		bar:Hide()
	else
		bar:Show()

		local text = ''
		local textFormat = E.db.xprep.text.tFormat		

		bar:SetMinMaxValues(min, max)
		bar:SetValue(value)
		
		for i=1, numFactions do
			local factionName, _, standingID,_,_,_,_,_,_,_,_,_,_, factionID = GetFactionInfo(i);
			local friendID, friendRep, friendMaxRep, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
			if factionName == name then
				if friendID ~= nil then
					isFriend = true
					friendText = friendTextLevel
				else
					ID = standingID
				end
			end
		end
		
		if textFormat == 'PERCENT' then
			text = format('%s: %d%% [%s]', name, ((value - min) / (max - min) * 100), isFriend and friendText or _G['FACTION_STANDING_LABEL'..ID])
		elseif textFormat == 'CURMAX' then
			text = format('%s: %s - %s [%s]', name, E:ShortValue(value - min), E:ShortValue(max - min), isFriend and friendText or _G['FACTION_STANDING_LABEL'..ID])
		elseif textFormat == 'CURPERC' then
			text = format('%s: %s - %d%% [%s]', name, E:ShortValue(value - min), ((value - min) / (max - min) * 100), isFriend and friendText or _G['FACTION_STANDING_LABEL'..ID])
		end
		self:ChangeRepColor()
		self:ChangeRepXpFont()
		bar.text:SetText(text)		
	end

end

function BXR:EnableDisable_ExperienceBar()

	if UnitLevel('player') ~= MAX_PLAYER_LEVEL and E.db.ufb.barshow and E.db.xprep.show == 'XP' then
		self:RegisterEvent('PLAYER_XP_UPDATE', 'UpdateExperience')
		self:RegisterEvent('PLAYER_LEVEL_UP', 'UpdateExperience')
		self:RegisterEvent('DISABLE_XP_GAIN', 'UpdateExperience')
		self:RegisterEvent('ENABLE_XP_GAIN', 'UpdateExperience')
		self:RegisterEvent('UPDATE_EXHAUSTION', 'UpdateExperience')
		self:UpdateExperience()	
	else
		self:UnregisterEvent('PLAYER_XP_UPDATE')
		self:UnregisterEvent('PLAYER_LEVEL_UP')
		self:UnregisterEvent('DISABLE_XP_GAIN')
		self:UnregisterEvent('ENABLE_XP_GAIN')
		self:UnregisterEvent('UPDATE_EXHAUSTION')
		self.xpbar:Hide()
	end
end

function BXR:EnableDisable_ReputationBar()

	if E.db.ufb.barshow and E.db.xprep.show == 'REP' then
		self:RegisterEvent('UPDATE_FACTION', 'UpdateReputation')
		self:UpdateReputation()
	else
		self:UnregisterEvent('UPDATE_FACTION')
		self.repbar:Hide()
	end
end

function BXR:ChangeRepXpFont()
	local bar
	if E.db.xprep.show == 'REP' then
		bar = self.repbar
	elseif E.db.xprep.show == 'XP' then
		bar = self.xpbar
	else return
	end
	if E.db.xprep.text.tStyle == 'DTS' then
		bar.text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	elseif E.db.xprep.text.tStyle == 'UNIT' then
		bar.text:FontTemplate(LSM:Fetch('font', E.db.unitframe.font), E.db.unitframe.fontSize, E.db.unitframe.fontOutline)
	else
		bar.text:FontTemplate(nil, E.db.general.reputation.textSize)
	end
end

-- Style ElvUI default XP/Rep bars
local SPACING = (E.PixelMode and 1 or 5)

local function xp_OnFade(self)
	ElvUI_ExperienceBar:Hide()
end

local function rep_OnFade(self)
	ElvUI_ReputationBar:Hide()
end

local function XpRepButton_OnShow(self)
	GameTooltip:Hide()
	
	if E.db[self.parent:GetName()..'Faded'] then
		E.db[self.parent:GetName()..'Faded'] = nil
		UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
		UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	else
		E.db[self.parent:GetName()..'Faded'] = true
		UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
end

local function StyleXpRepBars()
	-- Xp Bar
	local xp = ElvUI_ExperienceBar
	xp:SetParent(LeftChatPanel)
	xp.fadeFunc = xp_OnFade
	-- top decor
	xp.ft = CreateFrame('Frame', nil, xp)
	xp.ft:SetTemplate('Default', true)
	xp.ft:Point('TOPLEFT', xp, 'TOPLEFT', 0, 4)
	xp.ft:Point('BOTTOMRIGHT', xp, 'TOPRIGHT')
	
	-- bottom decor/button
	xp.fb = CreateFrame('Button', nil, xp)
	xp.fb:SetTemplate('Default', true)
	xp.fb:CreateSoftGlow()
	xp.fb.sglow:Hide()
	xp.fb:Point('TOPLEFT', xp, 'BOTTOMLEFT', 0, -SPACING)
	xp.fb:Point('BOTTOMRIGHT', xp, 'BOTTOMRIGHT', 0, -20)
	xp.fb:SetScript('OnEnter', function(self)
		self.sglow:Show()
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(SPELLBOOK_ABILITIES_BUTTON, selectioncolor)
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)
	
	xp.fb:SetScript('OnLeave', function(self)
		self.sglow:Hide()
		GameTooltip:Hide()
	end)
	
	xp.fb:SetScript('OnClick', function(self)
		if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end
	end)
	
	-- Rep bar
	local rp = ElvUI_ReputationBar
	rp:SetParent(RightChatPanel)
	rp.fadeFunc = rp_OnFade
	-- top decor
	rp.ft = CreateFrame('Frame', nil, rp)
	rp.ft:SetTemplate('Default', true)
	rp.ft:Point('TOPLEFT', rp, 'TOPLEFT', 0, 4)
	rp.ft:Point('BOTTOMRIGHT', rp, 'TOPRIGHT')
	
	-- bottom decor/button	
	rp.fb = CreateFrame('Button', nil, rp)
	rp.fb:SetTemplate('Default', true)
	rp.fb:CreateSoftGlow()
	rp.fb.sglow:Hide()
	rp.fb:Point('TOPLEFT', rp, 'BOTTOMLEFT', 0, -SPACING)
	rp.fb:Point('BOTTOMRIGHT', rp, 'BOTTOMRIGHT', 0, -20)

	rp.fb:SetScript('OnEnter', function(self)
		self.sglow:Show()
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(BINDING_NAME_TOGGLECHARACTER2, selectioncolor)
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)
	
	rp.fb:SetScript('OnLeave', function(self)
		self.sglow:Hide()
		GameTooltip:Hide()
	end)
	
	rp.fb:SetScript('OnClick', function(self)
		ToggleCharacter("ReputationFrame")
	end)
end

function BXR:ApplyXpRepStyling()
	local xp = ElvUI_ExperienceBar
	if E.db.general.experience.enable == true then
		if E.db.general.experience.orientation == 'VERTICAL' then
			xp.ft:Show()
			xp.fb:Show()
		else
			xp.ft:Hide()
			xp.fb:Hide()
		end
	end	
	
	local rp = ElvUI_ReputationBar
	if E.db.general.reputation.enable == true then
		if E.db.general.reputation.orientation == 'VERTICAL' then
			rp.ft:Show()
			rp.fb:Show()
		else
			rp.ft:Hide()
			rp.fb:Hide()
		end
	end
end

-- Custom color
local color = { r = 1, g = 1, b = 1, a = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b, color.a
end

function BXR:LoadBars()
	self.xpbar = CreateFrame('StatusBar', nil, BUI_PlayerBar)
	self.xpbar:SetInside()
	self.xpbar:SetStatusBarTexture(E['media'].BuiFlat)
	self.xpbar:SetAlpha(0)

	self.xpbar.text = self.xpbar:CreateFontString(nil, 'OVERLAY')
	self.xpbar.text:SetPoint('CENTER')	
				
	self.xpbar.rested = CreateFrame('StatusBar', nil, self.xpbar)
	self.xpbar.rested:SetInside(BUI_PlayerBar)
	self.xpbar.rested:SetStatusBarTexture(E['media'].BuiFlat)
	self.xpbar.rested:SetFrameLevel(self.xpbar:GetFrameLevel() - 1)
	self.xpbar:SetScript('OnEnter', xp_onEnter)
	self.xpbar:SetScript('OnLeave', bars_onLeave)

	self.repbar = CreateFrame('StatusBar', nil, BUI_PlayerBar)
	self.repbar:SetInside()
	self.repbar:SetStatusBarTexture(E['media'].BuiFlat)
	self.repbar:SetAlpha(0)
	self.repbar.text = self.repbar:CreateFontString(nil, 'OVERLAY')
	self.repbar.text:SetPoint('CENTER')
	self.repbar.text:Width(BUI_PlayerBar:GetWidth() - 20)
	self.repbar.text:SetWordWrap(false)
	self.repbar:SetScript('OnEnter', rep_onEnter)
	self.repbar:SetScript('OnLeave', bars_onLeave)
	
	self:ChangeXPcolor()

	self:EnableDisable_ExperienceBar()
	self:EnableDisable_ReputationBar()
end

function BXR:ChangeXPcolor()
	local db = E.db.xprep.color.experience
	local elvxpstatus = ElvUI_ExperienceBar.statusBar
	local elvrestedstatus = ElvUI_ExperienceBar.rested
	
	if db.default then
		self.xpbar:SetStatusBarColor(0, 0.4, 1, .8)
		self.xpbar.rested:SetStatusBarColor(1, 0, 1, 0.2)
		if db.applyInElvUI then
			elvxpstatus:SetStatusBarColor(0, 0.4, 1, .8)
			elvrestedstatus:SetStatusBarColor(1, 0, 1, 0.2)
		end
	else
		self.xpbar:SetStatusBarColor(unpackColor(db.xp))
		self.xpbar.rested:SetStatusBarColor(unpackColor(db.rested))
		if db.applyInElvUI then
			elvxpstatus:SetStatusBarColor(unpackColor(db.xp))
			elvrestedstatus:SetStatusBarColor(unpackColor(db.rested))
		else
			elvxpstatus:SetStatusBarColor(0, 0.4, 1, .8)
			elvrestedstatus:SetStatusBarColor(1, 0, 1, 0.2)		
		end
	end
end

function BXR:ChangeRepColor()
	local db = E.db.xprep.color.reputation
	local _, reaction = GetWatchedFactionInfo()
	local color = FACTION_BAR_COLORS[reaction] or backupColor
	local elvstatus = ElvUI_ReputationBar.statusBar
	
	if db.default then
		self.repbar:SetStatusBarColor(color.r, color.g, color.b)
		if db.applyInElvUI then
			elvstatus:SetStatusBarColor(color.r, color.g, color.b)
		end
	else 
		if reaction >= 5 then
			self.repbar:SetStatusBarColor(unpackColor(db.friendly))
			if db.applyInElvUI then
				elvstatus:SetStatusBarColor(unpackColor(db.friendly))
			end
		elseif reaction == 4 then
			self.repbar:SetStatusBarColor(unpackColor(db.neutral))
			if db.applyInElvUI then
				elvstatus:SetStatusBarColor(unpackColor(db.neutral))
			end
		elseif reaction == 3 then
			self.repbar:SetStatusBarColor(unpackColor(db.unfriendly))
			if db.applyInElvUI then
				elvstatus:SetStatusBarColor(unpackColor(db.unfriendly))
			end
		elseif reaction < 3 then
			self.repbar:SetStatusBarColor(unpackColor(db.hated))
			if db.applyInElvUI then
				elvstatus:SetStatusBarColor(unpackColor(db.hated))
			end
		end
		if not db.applyInElvUI then elvstatus:SetStatusBarColor(color.r, color.g, color.b) end
	end
end

function BXR:Initialize()
	if E.db.ufb.barshow ~= true or E.db.xprep.enable ~= true then return end
	self:LoadBars()
	StyleXpRepBars()
	self:ApplyXpRepStyling()
	hooksecurefunc(M, 'UpdateExpRepDimensions', BXR.ApplyXpRepStyling)
end

E:RegisterModule(BXR:GetName())