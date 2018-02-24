local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AFK = E:GetModule('AFK')
local BUI = E:GetModule('BenikUI');

local format, random, lower, tonumber, date, floor = string.format, random, string.lower, tonumber, date, floor

local CreateFrame = CreateFrame
local GetGameTime = GetGameTime
local GetScreenHeight, GetScreenWidth = GetScreenHeight, GetScreenWidth
local CalendarGetDate = CalendarGetDate
local GetAchievementInfo = GetAchievementInfo
local GetStatistic = GetStatistic
local IsXPUserDisabled = IsXPUserDisabled
local UnitLevel = UnitLevel
local InCombatLockdown = InCombatLockdown
local GetSpecialization = GetSpecialization
local GetActiveSpecGroup = GetActiveSpecGroup
local GetSpecializationInfo = GetSpecializationInfo
local GetAverageItemLevel = GetAverageItemLevel

local TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME, MAX_PLAYER_LEVEL_TABLE = TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME, MAX_PLAYER_LEVEL_TABLE
local LEVEL, NONE = LEVEL, NONE
local ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY = ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY

-- GLOBALS: CreateAnimationGroup, UIParent

-- Source wowhead.com
local stats = {
	60,		-- Total deaths
	94,		-- Quests abandoned
	97,		-- Daily quests completed
	98,		-- Quests completed
	107,	-- Creatures killed
	112,	-- Deaths from drowning
	114,	-- Deaths from falling
	319,	-- Duels won
	320,	-- Duels lost
	321,	-- Total raid and dungeon deaths
	326,	-- Gold from quest rewards
	328,	-- Total gold acquired
	333,	-- Gold looted
	334,	-- Most gold ever owned
	338,	-- Vanity pets owned
	339,	-- Mounts owned
	342,	-- Epic items acquired
	349,	-- Flight paths taken
	353,	-- Number of times hearthed
	377,	-- Most factions at Exalted
	588,	-- Total Honorable Kills
	837,	-- Arenas won
	838,	-- Arenas played
	839,	-- Battlegrounds played
	840,	-- Battlegrounds won
	919,	-- Gold earned from auctions
	931,	-- Total factions encountered
	932,	-- Total 5-player dungeons entered
	933,	-- Total 10-player raids entered
	934,	-- Total 25-player raids entered
	1042,	-- Number of hugs
	1045,	-- Total cheers
	1047,	-- Total facepalms
	1065,	-- Total waves
	1066,	-- Total times LOL'd
	1149,	-- Talent tree respecs
	1197,	-- Total kills
	1198,	-- Total kills that grant experience or honor
	1339,	-- Mage portal taken most
	1487,	-- Killing Blows
	1491,	-- Battleground Killing Blows
	1518,	-- Fish caught
	1716,	-- Battleground with the most Killing Blows
	2277,	-- Summons accepted
	5692,	-- Rated battlegrounds played
	5694,	-- Rated battlegrounds won
	7399,	-- Challenge mode dungeons completed
	8278,	-- Pet Battles won at max level
	10060,	-- Garrison Followers recruited
	10181,	-- Garrision Missions completed
	10184,	-- Garrision Rare Missions completed
	11234,	-- Class Hall Champions recruited
	11235,	-- Class Hall Troops recruited
	11236,	-- Class Hall Missions completed
	11237,	-- Class Hall Rare Missions completed
}

-- Create Time
local function createTime()
	local hour, hour24, minute, ampm = tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = GetGameTime()

	local localTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

	if E.db.datatexts.localtime then
		if E.db.datatexts.time24 then
			return localTime24
		else
			return localTime
		end
	else
		if E.db.datatexts.time24 then
			return realmTime24
		else
			return realmTime
		end
	end
end

local monthAbr = {
	[1] = L["Jan"],
	[2] = L["Feb"],
	[3] = L["Mar"],
	[4] = L["Apr"],
	[5] = L["May"],
	[6] = L["Jun"],
	[7] = L["Jul"],
	[8] = L["Aug"],
	[9] = L["Sep"],
	[10] = L["Oct"],
	[11] = L["Nov"],
	[12] = L["Dec"],
}

local daysAbr = {
	[1] = L["Sun"],
	[2] = L["Mon"],
	[3] = L["Tue"],
	[4] = L["Wed"],
	[5] = L["Thu"],
	[6] = L["Fri"],
	[7] = L["Sat"],
}

-- Create Date
local function createDate()
	local curDayName, curMonth, curDay, curYear = CalendarGetDate()
	AFK.AFKMode.top.date:SetFormattedText("%s, %s %d, %d", daysAbr[curDayName], monthAbr[curMonth], curDay, curYear)
end

-- Create random stats
local function createStats()
	local id = stats[random( #stats )]
	local _, name = GetAchievementInfo(id)
	local result = GetStatistic(id)
	if result == "--" then result = NONE end
	return format("%s: |cfff0ff00%s|r", name, result)
end

local active
local function getSpec()
	local specIndex = GetSpecialization();
	if not specIndex then return end

	active = GetActiveSpecGroup()

	local talent = ''
	local i = GetSpecialization(false, false, active)
	if i then
		i = select(2, GetSpecializationInfo(i))
		if(i) then
			talent = format('%s', i)
		end
	end

	return format('%s', talent)
end

local function getItemLevel()
	local level = UnitLevel("player");
	local _, equipped = GetAverageItemLevel()
	local ilvl = ''
	if (level >= MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY) then
		ilvl = format('\n%s: %d', ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, equipped)
	end
	return ilvl
end

function AFK:UpdateStatMessage()
	E:UIFrameFadeIn(self.AFKMode.statMsg.info, 1, 1, 0)
	local createdStat = createStats()
	self.AFKMode.statMsg.info:SetText(createdStat)
	E:UIFrameFadeIn(self.AFKMode.statMsg.info, 1, 0, 1)
end

function AFK:UpdateLogOff()
	local timePassed = GetTime() - self.startTime
	local minutes = floor(timePassed/60)
	local neg_seconds = -timePassed % 60

	self.AFKMode.top.Status:SetValue(floor(timePassed))

	if minutes - 29 == 0 and floor(neg_seconds) == 0 then
		self:CancelTimer(self.logoffTimer)
		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff0000:00|r", L["Logout Timer"])
	else
		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00%02d:%02d|r", L["Logout Timer"], minutes -29, neg_seconds)
	end
end

AFK.UpdateTimerBui = AFK.UpdateTimer
function AFK:UpdateTimer()
	self:UpdateTimerBui()

	if E.db.benikui.misc.afkMode ~= true then return end

	local createdTime = createTime()

	-- Set time
	self.AFKMode.top.time:SetFormattedText(createdTime)

	-- Set Date
	createDate()

	-- Don't need the default timer
	self.AFKMode.bottom.time:SetText(nil)
end

-- XP string
local M = E:GetModule('DataBars');
local function GetXPinfo()
	local maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()];
	if(UnitLevel('player') == maxLevel) or IsXPUserDisabled() then return end

	local cur, max = M:GetXP('player')
	local curlvl = UnitLevel('player')
	return format('|cfff0ff00%d%%|r (%s) %s |cfff0ff00%d|r', (max - cur) / max * 100, E:ShortValue(max - cur), L["remaining till level"], curlvl + 1)
end

AFK.BUISetAFK = AFK.SetAFK
function AFK:SetAFK(status)
	self:BUISetAFK(status)

	if E.db.benikui.misc.afkMode ~= true then return end

	if(status) then
		local xptxt = GetXPinfo()
		local level = UnitLevel('player')
		local race = UnitRace('player')
		local localizedClass = UnitClass('player')
		local spec = getSpec()
		local ilvl = getItemLevel()
		self.AFKMode.top:SetHeight(0)
		self.AFKMode.top.anim.height:Play()
		self.AFKMode.bottom:SetHeight(0)
		self.AFKMode.bottom.anim.height:Play()
		self.statsTimer = self:ScheduleRepeatingTimer("UpdateStatMessage", 5)
		self.logoffTimer = self:ScheduleRepeatingTimer("UpdateLogOff", 1)
		if xptxt then
			self.AFKMode.xp:Show()
			self.AFKMode.xp.text:SetText(xptxt)
		else
			self.AFKMode.xp:Hide()
			self.AFKMode.xp.text:SetText("")
		end
		self.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s %s%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl)
	else
		self:CancelTimer(self.statsTimer)
		self:CancelTimer(self.logoffTimer)

		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
		self.AFKMode.statMsg.info:SetFormattedText("|cffb3b3b3%s|r", L["Random Stats"])
	end
end

local find = string.find

local function IsFoolsDay()
	if find(date(), '04/01/') then
		return true;
	else
		return false;
	end
end

local function prank(self, status)
	if(InCombatLockdown()) then return end
	if not IsFoolsDay() then return end

	if(status) then

	end
end
--hooksecurefunc(AFK, "SetAFK", prank)

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

AFK.InitializeBuiAfk = AFK.Initialize
function AFK:Initialize()
	self:InitializeBuiAfk()

	if E.db.benikui.misc.afkMode ~= true then return end

	local level = UnitLevel('player')
	local race = UnitRace('player')
	local localizedClass = UnitClass('player')
	local className = E.myclass
	local spec = getSpec()
	local ilvl = getItemLevel()

	-- Create Top frame
	self.AFKMode.top = CreateFrame('Frame', nil, self.AFKMode)
	self.AFKMode.top:SetFrameLevel(0)
	self.AFKMode.top:SetTemplate('Transparent')
	self.AFKMode.top:ClearAllPoints()
	self.AFKMode.top:SetPoint("TOP", self.AFKMode, "TOP", 0, E.Border)
	self.AFKMode.top:SetWidth(GetScreenWidth() + (E.Border*2))

	--Style the top frame
	self.AFKMode.top:Style('Under', _, true)

	--Top Animation
	self.AFKMode.top.anim = CreateAnimationGroup(self.AFKMode.top)
	self.AFKMode.top.anim.height = self.AFKMode.top.anim:CreateAnimation("Height")
	self.AFKMode.top.anim.height:SetChange(GetScreenHeight() * (1 / 20))
	self.AFKMode.top.anim.height:SetDuration(1)
	self.AFKMode.top.anim.height:SetSmoothing("Bounce")

	-- move the chat lower
	self.AFKMode.chat:SetPoint("TOPLEFT", self.AFKMode.top.style, "TOPLEFT", 4, -4)

	-- WoW logo
	self.AFKMode.top.wowlogo = CreateFrame('Frame', nil, self.AFKMode) -- need this to upper the logo layer
	self.AFKMode.top.wowlogo:SetPoint("TOP", self.AFKMode.top, "TOP", 0, -5)
	self.AFKMode.top.wowlogo:SetFrameStrata("MEDIUM")
	self.AFKMode.top.wowlogo:SetSize(300, 150)
	self.AFKMode.top.wowlogo.tex = self.AFKMode.top.wowlogo:CreateTexture(nil, 'OVERLAY')
	self.AFKMode.top.wowlogo.tex:SetAtlas("Glues-WoW-LegionLogo")
	self.AFKMode.top.wowlogo.tex:SetInside()

	-- Server/Local Time text
	self.AFKMode.top.time = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.top.time:FontTemplate(nil, 16)
	self.AFKMode.top.time:SetText("")
	self.AFKMode.top.time:SetPoint("RIGHT", self.AFKMode.top, "RIGHT", -20, 0)
	self.AFKMode.top.time:SetJustifyH("LEFT")
	self.AFKMode.top.time:SetTextColor(classColor.r, classColor.g, classColor.b)

	-- Date text
	self.AFKMode.top.date = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.top.date:FontTemplate(nil, 16)
	self.AFKMode.top.date:SetText("")
	self.AFKMode.top.date:SetPoint("LEFT", self.AFKMode.top, "LEFT", 20, 0)
	self.AFKMode.top.date:SetJustifyH("RIGHT")
	self.AFKMode.top.date:SetTextColor(classColor.r, classColor.g, classColor.b)

	-- Statusbar on Top frame decor showing time to log off (30mins)
	self.AFKMode.top.Status = CreateFrame('StatusBar', nil, self.AFKMode.top)
	self.AFKMode.top.Status:SetStatusBarTexture((E["media"].normTex))
	self.AFKMode.top.Status:SetMinMaxValues(0, 1800)
	self.AFKMode.top.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b, 1)
	self.AFKMode.top.Status:SetFrameLevel(2)
	if E.db.benikui.general.benikuiStyle and self.AFKMode.top.style then
		self.AFKMode.top.Status:SetInside(self.AFKMode.top.style)
	else
		self.AFKMode.top.Status:Point('TOPRIGHT', self.AFKMode.top, 'BOTTOMRIGHT', 0, E.PixelMode and 5 or 7)
		self.AFKMode.top.Status:Point('BOTTOMLEFT', self.AFKMode.top, 'BOTTOMLEFT', 0, E.PixelMode and 1 or 2)
	end
	self.AFKMode.top.Status:SetValue(0)

	-- Style the bottom frame
	self.AFKMode.bottom:Style('Inside', _, true)
	if self.AFKMode.bottom.style then
		self.AFKMode.bottom.style:SetFrameLevel(5)
	end
	
	self.AFKMode.bottom.modelHolder:SetFrameLevel(7)

	-- Bottom Frame Animation
	self.AFKMode.bottom.anim = CreateAnimationGroup(self.AFKMode.bottom)
	self.AFKMode.bottom.anim.height = self.AFKMode.bottom.anim:CreateAnimation("Height")
	self.AFKMode.bottom.anim.height:SetChange(GetScreenHeight() * (1 / 9))
	self.AFKMode.bottom.anim.height:SetDuration(1)
	self.AFKMode.bottom.anim.height:SetSmoothing("Bounce")

	-- Move the factiongroup sign to the center
	self.AFKMode.bottom.factionb = CreateFrame('Frame', nil, self.AFKMode) -- need this to upper the faction logo layer
	self.AFKMode.bottom.factionb:SetPoint("BOTTOM", self.AFKMode.bottom, "TOP", 0, -40)
	self.AFKMode.bottom.factionb:SetFrameStrata("MEDIUM")
	self.AFKMode.bottom.factionb:SetFrameLevel(10)
	self.AFKMode.bottom.factionb:SetSize(220, 220)
	self.AFKMode.bottom.faction:ClearAllPoints()
	self.AFKMode.bottom.faction:SetParent(self.AFKMode.bottom.factionb)
	self.AFKMode.bottom.faction:SetInside()
	-- Apply class texture rather than the faction
	self.AFKMode.bottom.faction:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\classIcons\\CLASS-'..className)

	-- Add more info in the name and position it to the center
	self.AFKMode.bottom.name:ClearAllPoints()
	self.AFKMode.bottom.name:SetPoint("TOP", self.AFKMode.bottom.factionb, "BOTTOM", 0, 5)
	self.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s %s%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl)
	self.AFKMode.bottom.name:SetJustifyH("CENTER")
	self.AFKMode.bottom.name:FontTemplate(nil, 18)

	-- Lower the guild text size a bit
	self.AFKMode.bottom.guild:ClearAllPoints()
	self.AFKMode.bottom.guild:SetPoint("TOP", self.AFKMode.bottom.name, "BOTTOM", 0, -6)
	self.AFKMode.bottom.guild:FontTemplate(nil, 12)
	self.AFKMode.bottom.guild:SetJustifyH("CENTER")

	-- Add ElvUI name
	self.AFKMode.bottom.logotxt = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.logotxt:FontTemplate(nil, 24)
	self.AFKMode.bottom.logotxt:SetText("ElvUI")
	self.AFKMode.bottom.logotxt:SetPoint("LEFT", self.AFKMode.bottom, "LEFT", 25, 8)
	self.AFKMode.bottom.logotxt:SetTextColor(classColor.r, classColor.g, classColor.b)
	-- and ElvUI version
	self.AFKMode.bottom.etext = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.etext:FontTemplate(nil, 10)
	self.AFKMode.bottom.etext:SetFormattedText("v%s", E.version)
	self.AFKMode.bottom.etext:SetPoint("TOP", self.AFKMode.bottom.logotxt, "BOTTOM")
	self.AFKMode.bottom.etext:SetTextColor(0.7, 0.7, 0.7)
	-- Hide ElvUI logo
	self.AFKMode.bottom.logo:Hide()

	-- Add BenikUI name
	self.AFKMode.bottom.benikui = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.benikui:FontTemplate(nil, 24)
	self.AFKMode.bottom.benikui:SetText("BenikUI")
	self.AFKMode.bottom.benikui:SetPoint("RIGHT", self.AFKMode.bottom, "RIGHT", -25, 8)
	self.AFKMode.bottom.benikui:SetTextColor(classColor.r, classColor.g, classColor.b)
	-- and version
	self.AFKMode.bottom.btext = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.btext:FontTemplate(nil, 10)
	self.AFKMode.bottom.btext:SetFormattedText("v%s", BUI.Version)
	self.AFKMode.bottom.btext:SetPoint("TOP", self.AFKMode.bottom.benikui, "BOTTOM")
	self.AFKMode.bottom.btext:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats decor (taken from install routine)
	self.AFKMode.statMsg = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.statMsg:Size(418, 72)
	self.AFKMode.statMsg:Point("CENTER", 0, 200)

	self.AFKMode.statMsg.bg = self.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.statMsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	self.AFKMode.statMsg.bg:SetPoint('BOTTOM')
	self.AFKMode.statMsg.bg:Size(326, 103)
	self.AFKMode.statMsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	self.AFKMode.statMsg.bg:SetVertexColor(1, 1, 1, 0.7)

	self.AFKMode.statMsg.lineTop = self.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.statMsg.lineTop:SetDrawLayer('BACKGROUND', 2)
	self.AFKMode.statMsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	self.AFKMode.statMsg.lineTop:SetPoint("TOP")
	self.AFKMode.statMsg.lineTop:Size(418, 7)
	self.AFKMode.statMsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	self.AFKMode.statMsg.lineBottom = self.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.statMsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
	self.AFKMode.statMsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	self.AFKMode.statMsg.lineBottom:SetPoint("BOTTOM")
	self.AFKMode.statMsg.lineBottom:Size(418, 7)
	self.AFKMode.statMsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	-- Countdown decor
	self.AFKMode.countd = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.countd:Size(418, 36)
	self.AFKMode.countd:Point("TOP", self.AFKMode.statMsg.lineBottom, "BOTTOM")

	self.AFKMode.countd.bg = self.AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.countd.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	self.AFKMode.countd.bg:SetPoint('BOTTOM')
	self.AFKMode.countd.bg:Size(326, 56)
	self.AFKMode.countd.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	self.AFKMode.countd.bg:SetVertexColor(1, 1, 1, 0.7)

	self.AFKMode.countd.lineBottom = self.AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.countd.lineBottom:SetDrawLayer('BACKGROUND', 2)
	self.AFKMode.countd.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	self.AFKMode.countd.lineBottom:SetPoint('BOTTOM')
	self.AFKMode.countd.lineBottom:Size(418, 7)
	self.AFKMode.countd.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	-- 30 mins countdown text
	self.AFKMode.countd.text = self.AFKMode.countd:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.countd.text:FontTemplate(nil, 12)
	self.AFKMode.countd.text:SetPoint("CENTER", self.AFKMode.countd, "CENTER")
	self.AFKMode.countd.text:SetJustifyH("CENTER")
	self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
	self.AFKMode.countd.text:SetTextColor(0.7, 0.7, 0.7)

	self.AFKMode.bottom.time:Hide()

	local xptxt = GetXPinfo()
	-- XP info
	self.AFKMode.xp = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.xp:Size(418, 36)
	self.AFKMode.xp:Point("TOP", self.AFKMode.countd.lineBottom, "BOTTOM")
	self.AFKMode.xp.bg = self.AFKMode.xp:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.xp.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	self.AFKMode.xp.bg:SetPoint('BOTTOM')
	self.AFKMode.xp.bg:Size(326, 56)
	self.AFKMode.xp.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	self.AFKMode.xp.bg:SetVertexColor(1, 1, 1, 0.7)
	self.AFKMode.xp.lineBottom = self.AFKMode.xp:CreateTexture(nil, 'BACKGROUND')
	self.AFKMode.xp.lineBottom:SetDrawLayer('BACKGROUND', 2)
	self.AFKMode.xp.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	self.AFKMode.xp.lineBottom:SetPoint('BOTTOM')
	self.AFKMode.xp.lineBottom:Size(418, 7)
	self.AFKMode.xp.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	self.AFKMode.xp.text = self.AFKMode.xp:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.xp.text:FontTemplate(nil, 12)
	self.AFKMode.xp.text:SetPoint("CENTER", self.AFKMode.xp, "CENTER")
	self.AFKMode.xp.text:SetJustifyH("CENTER")
	self.AFKMode.xp.text:SetText(xptxt)
	self.AFKMode.xp.text:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats frame
	self.AFKMode.statMsg.info = self.AFKMode.statMsg:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.statMsg.info:FontTemplate(nil, 18)
	self.AFKMode.statMsg.info:Point("CENTER", self.AFKMode.statMsg, "CENTER", 0, -2)
	self.AFKMode.statMsg.info:SetText(format("|cffb3b3b3%s|r", L["Random Stats"]))
	self.AFKMode.statMsg.info:SetJustifyH("CENTER")
	self.AFKMode.statMsg.info:SetTextColor(0.7, 0.7, 0.7)
end