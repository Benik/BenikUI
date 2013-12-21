local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local M = E:GetModule('Misc');
local LSM = LibStub("LibSharedMedia-3.0")

FACTION_STANDING_LABEL100 = UNKNOWN

local format = string.format
local min, max = math.min, math.max

local SPACING = (E.PixelMode and 1 or 5)

function M:BenikGetXP(unit)
	if(unit == 'pet') then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

function M:BenikUpdateExperience(event)
	local bar = self.BexpBar

	if(UnitLevel('player') == MAX_PLAYER_LEVEL) or IsXPUserDisabled() then
		bar:Hide()
	else
		bar:Show()
		
		local cur, max = self:BenikGetXP('player')
		bar.statusBar:SetMinMaxValues(0, max)
		bar.statusBar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
		bar.statusBar:SetValue(cur)
		
		local rested = GetXPExhaustion()
		local text = ''
		local textFormat = E.db.bmisc.xptextFormat
		bar.text:SetTextColor(1, 0.5, 0.1)
		
		if rested and rested > 0 then
			bar.rested:SetMinMaxValues(0, max)
			bar.rested:SetValue(math.min(cur + rested, max))
			
			if textFormat == 'PERCENT' then
				text = string.format('%d%% R:%d%%', cur / max * 100, rested / max * 100)
			elseif textFormat == 'CURMAX' then
				text = string.format('%s - %s R:%s', E:ShortValue(cur), E:ShortValue(max), E:ShortValue(rested))
			elseif textFormat == 'CURPERC' then
				text = string.format('%s - %d%% R:%s [%d%%]', E:ShortValue(cur), cur / max * 100, E:ShortValue(rested), rested / max * 100)
			end
		else
			bar.rested:SetMinMaxValues(0, 1)
			bar.rested:SetValue(0)	

			if textFormat == 'PERCENT' then
				text = string.format('%d%%', cur / max * 100)
			elseif textFormat == 'CURMAX' then
				text = string.format('%s - %s', E:ShortValue(cur), E:ShortValue(max))
			elseif textFormat == 'CURPERC' then
				text = string.format('%s - %d%%', E:ShortValue(cur), cur / max * 100)
			end			
		end
		
		bar.text:SetText(text)
	end
	
end

function M:BenikUpdateReputation(event)
	local bar = self.BrepBar

	local ID = 100
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local numFactions = GetNumFactions();

	if not name then
		bar:Hide()
	else
		bar:Show()

		local text = ''
		local textFormat = E.db.bmisc.reptextFormat
		--if E.db.bmisc.reptextColor == REP then
			local color = FACTION_BAR_COLORS[reaction]
			--bar.text:SetTextColor(color.r, color.g, color.b)
		--elseif E.db.bmisc.reptextColor == DEF then
			bar.text:SetTextColor(1, 0.5, 0)
		--end
		--bar.text:SetTextColor(1, 0.5, 0.1)
		bar.statusBar:SetStatusBarColor(1, 0.5, 0.1)
		
		bar.statusBar:SetMinMaxValues(min, max)
		bar.statusBar:SetValue(value)
		
		for i=1, numFactions do
			local factionName, _, standingID = GetFactionInfo(i);
			if factionName == name then
				ID = standingID
			end
		end
		--("|cff%02x%02x%02x%s|r"):format(color.r, color.g, color.b, _G['FACTION_STANDING_LABEL'..ID])
		
		--local faction = ("|cff%02x%02x%02x%s|r"):string.format(color.r, color.g, color.b, _G['FACTION_STANDING_LABEL'..ID])
		
		if textFormat == 'PERCENT' then
			text = string.format('%s: %d%% [%s]', name, ((value - min) / (max - min) * 100), _G['FACTION_STANDING_LABEL'..ID])
		elseif textFormat == 'CURMAX' then
			text = string.format('%s: %s - %s [%s]', name, E:ShortValue(value - min), E:ShortValue(max - min), _G['FACTION_STANDING_LABEL'..ID])
		elseif textFormat == 'CURPERC' then
			text = string.format('%s: %s - %d%% [%s]', name, E:ShortValue(value - min), ((value - min) / (max - min) * 100), _G['FACTION_STANDING_LABEL'..ID])
		end					

		bar.text:SetText(text)		
	end
	
end

--[[function M:BenikUpdateRepTextColor()
	if E.db.bmisc.reptextColor == REP then
		local color = FACTION_BAR_COLORS[reaction]
		self.BrepBar.text:SetTextColor(color.r, color.g, color.b)
	elseif E.db.bmisc.reptextColor == DEF then
		self.BrepBar.text:SetTextColor(1, 0.5, 0)
	end	
end]]

local function ExperienceBar_OnEnter(self)
	if( InCombatLockdown() ) then
		return
	end
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, SPACING)
	
	local cur, max = M:GetXP('player')
	local rested = GetXPExhaustion()
	GameTooltip:AddLine(L['Experience'])
	GameTooltip:AddLine(' ')
	
	GameTooltip:AddDoubleLine(L['XP:'], string.format(' %d / %d (%d%%)', cur, max, cur/max * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine(L['Remaining:'], string.format(' %d (%d%% - %d '..L['Bars']..')', max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)	
	
	if rested then
		GameTooltip:AddDoubleLine(L['Rested:'], string.format('+%d (%d%%)', rested, rested / max * 100), 1, 1, 1)	
	end
	
	GameTooltip:Show()
end

local function ReputationBar_OnEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -SPACING)
	
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	if name then
		GameTooltip:AddLine(name)
		GameTooltip:AddLine(' ')
		
		GameTooltip:AddDoubleLine(STANDING..':', _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
		GameTooltip:AddDoubleLine(REPUTATION..':', format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100), 1, 1, 1)
	end
	GameTooltip:Show()
end

local function OnLeave(self)
	GameTooltip:Hide()
end

function M:BenikUpdateExpRepTextStyle()
	E["media"].xprepFont = LSM:Fetch("font", E.db.bmisc.xprepfont)
	self.BrepBar.text:FontTemplate(E["media"].xprepFont, E.db.bmisc.xprepFontsize, E.db.bmisc.xprepFontflags)
	self.BexpBar.text:FontTemplate(E["media"].xprepFont, E.db.bmisc.xprepFontsize, E.db.bmisc.xprepFontflags)
end

function M:BenikEnableDisable_ExperienceBar()
	if UnitLevel('player') ~= MAX_PLAYER_LEVEL and E.db.bmisc.xpenable then
		self:RegisterEvent('PLAYER_XP_UPDATE', 'BenikUpdateExperience')
		self:RegisterEvent('PLAYER_LEVEL_UP', 'BenikUpdateExperience')
		self:RegisterEvent("DISABLE_XP_GAIN", 'BenikUpdateExperience')
		self:RegisterEvent("ENABLE_XP_GAIN", 'BenikUpdateExperience')
		self:RegisterEvent('UPDATE_EXHAUSTION', 'BenikUpdateExperience')
		self:BenikUpdateExperience()	
	else
		self:UnregisterEvent('PLAYER_XP_UPDATE')
		self:UnregisterEvent('PLAYER_LEVEL_UP')
		self:UnregisterEvent("DISABLE_XP_GAIN")
		self:UnregisterEvent("ENABLE_XP_GAIN")
		self:UnregisterEvent('UPDATE_EXHAUSTION')
		self.BexpBar:Hide()
	end
end

function M:BenikEnableDisable_ReputationBar()
	if E.db.bmisc.repenable then
		self:RegisterEvent('UPDATE_FACTION', 'BenikUpdateReputation')
		self:BenikUpdateReputation()
	else
		self:UnregisterEvent('UPDATE_FACTION')
		self.BrepBar:Hide()
	end
end

function M:BenikLoadExpRepBar()
	local DASH_WIDTH = 150
	local DASH_HEIGHT = 20
	local DASH_SPACING = 3
	
	-- xp bar (on actionbar)
	self.BexpBar = CreateFrame('Frame', 'Benik_ExperienceBar', E.UIParent)
	self.BexpBar:SetTemplate('Default', true)
	self.BexpBar:Point('TOPLEFT', ElvUI_Bar2, 'TOPLEFT', -SPACING, SPACING + 5)
	self.BexpBar:Point('BOTTOMRIGHT', ElvUI_Bar2, 'TOPRIGHT', SPACING, 0)
	self.BexpBar:SetParent(ElvUI_Bar2)
	self.BexpBar:EnableMouse(true)
	self.BexpBar:SetScript('OnEnter', ExperienceBar_OnEnter)
	self.BexpBar:SetScript('OnLeave', OnLeave)
	--self.BexpBar:SetFrameStrata('LOW')
	self.BexpBar:Hide()

	--[[ xp bar (Working on Right Chat)
	self.BexpBar = CreateFrame('Frame', 'Benik_ExperienceBar', E.UIParent)
	self.BexpBar:SetTemplate('Transparent')
	self.BexpBar:Point('TOPLEFT', RightChatPanel, 'TOPLEFT', 0, SPACING + 8)
	self.BexpBar:Point('BOTTOMRIGHT', RightChatPanel, 'TOPRIGHT', 0, SPACING)
	self.BexpBar:SetParent(RightChatPanel)
	self.BexpBar:EnableMouse(true)
	self.BexpBar:SetScript('OnEnter', ExperienceBar_OnEnter)
	self.BexpBar:SetScript('OnLeave', OnLeave)
	self.BexpBar:SetFrameStrata('LOW')
	self.BexpBar:Hide()]]
	
	--[[ dummy xp
	self.BexpBarDummy = CreateFrame("StatusBar", "dummyXpStatus", self.BexpBar)
	self.BexpBarDummy:SetInside()
	self.BexpBarDummy:SetStatusBarTexture(E.media.normTex)
	self.BexpBarDummy:SetStatusBarColor(1, 1, 1, .2)]]
	
	-- xp bar status
	self.BexpBar.statusBar = CreateFrame('StatusBar', nil, self.BexpBar)
	--self.BexpBar.statusBar:SetReverseFill(true)
	self.BexpBar.statusBar:SetInside()
	self.BexpBar.statusBar:SetStatusBarTexture(E.media.normTex)
	self.BexpBar.statusBar:SetStatusBarColor(1, 0.5, 0.1) -- orange
	--self.BexpBar.statusBar:SetStatusBarColor(0, 0.4, 1, .8) elv
	
	-- xp bar spark
	--self.BexpBar.spark = self.BexpBar.statusBar:CreateTexture(nil, "OVERLAY", nil);
	--self.BexpBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
	--self.BexpBar.spark:SetSize(12, 6);
	--self.BexpBar.spark:SetBlendMode("ADD");
	--self.BexpBar.spark:SetPoint('CENTER', self.BexpBar.statusBar:GetStatusBarTexture(), 'RIGHT')
	
	-- xp bar text
	self.BexpBar.text = self.BexpBar.statusBar:CreateFontString(nil, 'OVERLAY')
	self.BexpBar.text:SetPoint('CENTER', Benik_ExperienceBar, 'CENTER', 0, 1)
	self.BexpBar.text:SetShadowColor(0, 0, 0)
	self.BexpBar.text:SetShadowOffset(1.25, -1.25)
	--self.BexpBar.text:Width(XpRepHolder:GetWidth() - 4)
	
	--xp bar rested bar
	self.BexpBar.rested = CreateFrame('StatusBar', nil, self.BexpBar)
	--self.BexpBar.rested:SetReverseFill(true)
	self.BexpBar.rested:SetInside()
	self.BexpBar.rested:SetStatusBarTexture(E.media.normTex)
	self.BexpBar.rested:SetStatusBarColor(1, 0.5, 0.1, 0.5) -- orange
	--self.BexpBar.rested:SetStatusBarColor(1, 0, 1, 0.2) elv

	-- rep bar (Under MiniMap)
	self.BrepBar = CreateFrame('Frame', 'Benik_ReputationBar', E.UIParent)
	self.BrepBar:SetTemplate('Default', true)
	self.BrepBar:Point('TOPLEFT', MMHolder, 'BOTTOMLEFT', SPACING, 0)
	self.BrepBar:Point('BOTTOMRIGHT', MMHolder, 'BOTTOMRIGHT', -SPACING, -SPACING -5)
	--self.BrepBar:SetParent(LeftChatPanel)
	self.BrepBar:EnableMouse(true)
	self.BrepBar:SetScript('OnEnter', ReputationBar_OnEnter)
	self.BrepBar:SetScript('OnLeave', OnLeave)
	self.BrepBar:SetFrameStrata('LOW')
	self.BrepBar:Hide()

	--[[ rep bar (Working on left chat)
	self.BrepBar = CreateFrame('Frame', 'Benik_ReputationBar', E.UIParent)
	self.BrepBar:SetTemplate('Transparent')
	self.BrepBar:Point('TOPLEFT', LeftChatPanel, 'TOPLEFT', 0, SPACING + 8)
	self.BrepBar:Point('BOTTOMRIGHT', LeftChatPanel, 'TOPRIGHT', 0, SPACING)
	self.BrepBar:SetParent(LeftChatPanel)
	self.BrepBar:EnableMouse(true)
	self.BrepBar:SetScript('OnEnter', ReputationBar_OnEnter)
	self.BrepBar:SetScript('OnLeave', OnLeave)
	self.BrepBar:SetFrameStrata('LOW')
	self.BrepBar:Hide()]]
	
	--[[ dummy rep
	self.BrepBarDummy = CreateFrame("StatusBar", "dummyRepStatus", self.BrepBar)
	self.BrepBarDummy:SetInside()
	self.BrepBarDummy:SetStatusBarTexture(E.media.normTex)
	self.BrepBarDummy:SetStatusBarColor(1, 1, 1, .2)]]
	
	-- rep bar status
	self.BrepBar.statusBar = CreateFrame('StatusBar', nil, self.BrepBar)
	--self.BrepBar.statusBar:SetReverseFill(true)
	self.BrepBar.statusBar:SetInside()
	self.BrepBar.statusBar:SetStatusBarTexture(E.media.normTex)
	
	-- rep spark
	--self.BrepBar.spark = self.BrepBar.statusBar:CreateTexture(nil, "OVERLAY", nil);
	--self.BrepBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
	--self.BrepBar.spark:SetSize(12, 6);
	--self.BrepBar.spark:SetBlendMode("ADD");
	--self.BrepBar.spark:SetPoint('CENTER', self.BrepBar.statusBar:GetStatusBarTexture(), 'RIGHT')
	
	-- rep bar text
	self.BrepBar.text = self.BrepBar.statusBar:CreateFontString(nil, 'OVERLAY')
	--self.BrepBar.text:SetPoint('TOPLEFT', 20, 12)
	self.BrepBar.text:SetPoint('TOP', Benik_ReputationBar, 'CENTER', 0, -SPACING)
	self.BrepBar.text:SetShadowColor(0, 0, 0)
	self.BrepBar.text:SetShadowOffset(1.25, -1.25)
	self.BrepBar.text:Width(self.BrepBar:GetWidth() - 4)

	--BenikUpdatePositions()
	ElvUI_ExperienceBar:Kill()
	ElvUI_ReputationBar:Kill()
	--self:BenikUpdateRepTextColor()
	self:BenikUpdateExpRepTextStyle()
	self:BenikEnableDisable_ExperienceBar()
	self:BenikEnableDisable_ReputationBar()
	
end
