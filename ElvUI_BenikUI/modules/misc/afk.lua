local BUI, E, L, V, P, G = unpack(select(2, ...))
local AFK = E:GetModule('AFK')

local format, random, lower, tonumber, date, floor = string.format, random, string.lower, tonumber, date, floor

local CreateFrame = CreateFrame
local GetGameTime = GetGameTime
local GetScreenHeight, GetScreenWidth = GetScreenHeight, GetScreenWidth
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local GetAchievementInfo = GetAchievementInfo
local GetStatistic = GetStatistic
local IsXPUserDisabled = IsXPUserDisabled
local IsPlayerAtEffectiveMaxLevel = IsPlayerAtEffectiveMaxLevel
local UnitXP, UnitXPMax = UnitXP, UnitXPMax
local UnitLevel = UnitLevel
local InCombatLockdown = InCombatLockdown
local GetSpecialization = GetSpecialization
local GetActiveSpecGroup = GetActiveSpecGroup
local GetSpecializationInfo = GetSpecializationInfo
local GetAverageItemLevel = GetAverageItemLevel
local GetClampedCurrentExpansionLevel = GetClampedCurrentExpansionLevel
local GetExpansionDisplayInfo = GetExpansionDisplayInfo

local TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME = TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME
local LEVEL, NONE = LEVEL, NONE
local ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY = ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY

local classColor = E:ClassColor(E.myclass, true)

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
	115,	-- Deaths from fire and lava
	319,	-- Duels won
	320,	-- Duels lost
	326,	-- Gold from quest rewards
	328,	-- Total gold acquired
	329,	-- Auctions posted
	331,	-- Most expensive bid on auction
	332,	-- Most expensive auction sold
	333,	-- Gold looted
	334,	-- Most gold ever owned
	338,	-- Vanity pets owned
	345,	-- Health potions consumed
	349,	-- Flight paths taken
	353,	-- Number of times hearthed
	588,	-- Total Honorable Kills
	812,	-- Healthstones used
	837,	-- Arenas won
	838,	-- Arenas played
	839,	-- Battlegrounds played
	840,	-- Battlegrounds won
	919,	-- Gold earned from auctions
	932,	-- Total 5-player dungeons entered
	933,	-- Total 10-player raids entered
	934,	-- Total 25-player raids entered
	1042,	-- Number of hugs
	1045,	-- Total cheers
	1047,	-- Total facepalms
	1065,	-- Total waves
	1066,	-- Total times LOL'd
	1197,	-- Total kills
	1198,	-- Total kills that grant experience or honor
	1336,	-- Creature type killed the most
	1339,	-- Mage portal taken most
	1487,	-- Total Killing Blows
	1491,	-- Battleground Killing Blows
	1518,	-- Fish caught
	1776,	-- Food eaten most
	2277,	-- Summons accepted
	5692,	-- Rated battlegrounds played
	5693,	-- Rated battleground played the most
	5695,	-- Rated battleground won the most
	5694,	-- Rated battlegrounds won
	7399,	-- Challenge mode dungeons completed
	8278,	-- Pet Battles won at max level
}

-- Create Time
local function createTime()
	local hour, hour24, minute, ampm = tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = GetGameTime()

	local localTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

	if E.global.datatexts.settings.Time.localTime then
		if E.global.datatexts.settings.Time.time24 == true then
			return localTime24
		else
			return localTime
		end
	else
		if E.global.datatexts.settings.Time.time24 == true then
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
	local date = C_DateAndTime_GetCurrentCalendarTime();
	local presentWeekday = date.weekday;
	local presentMonth = date.month;
	local presentDay = date.monthDay;
	local presentYear = date.year;
	AFK.AFKMode.top.date:SetFormattedText("%s, %s %d, %d", daysAbr[presentWeekday], monthAbr[presentMonth], presentDay, presentYear)
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
		ilvl = format('%s: %d', ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, equipped)
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

local function UpdateTimer()
	if E.db.benikui.misc.afkMode ~= true then return end

	local createdTime = createTime()

	-- Set time
	AFK.AFKMode.top.time:SetFormattedText(createdTime)

	-- Set Date
	createDate()

	-- Don't need the default timer
	AFK.AFKMode.bottom.time:SetText(nil)
end
hooksecurefunc(AFK, "UpdateTimer", UpdateTimer)

-- XP string
local function GetXPinfo()
	if IsPlayerAtEffectiveMaxLevel() or IsXPUserDisabled() then return end

	local cur, max = UnitXP('player'), UnitXPMax('player')
	if max <= 0 then max = 1 end
	local curlvl = UnitLevel('player')
	return format('|cfff0ff00%d%%|r (%s) %s |cfff0ff00%d|r', (max - cur) / max * 100, E:ShortValue(max - cur), L["remaining till level"], curlvl + 1)
end

AFK.SetAFKBui = AFK.SetAFK
function AFK:SetAFK(status)
	self:SetAFKBui(status)
	if E.db.benikui.misc.afkMode ~= true then return end

	if(status) then
		local xptxt = GetXPinfo()
		local level = UnitLevel('player')
		local race = UnitRace('player')
		local localizedClass = UnitClass('player')
		local spec = getSpec()
		local ilvl = getItemLevel()
		local displayline = ""

		self.AFKMode.top:Height(0)
		self.AFKMode.top.anim.height:Play()
		self.AFKMode.bottom:Height(0)
		self.AFKMode.bottom.anim.height:Play()
		self.startTime = GetTime()
		self.statsTimer = self:ScheduleRepeatingTimer("UpdateStatMessage", 5)
		self.logoffTimer = self:ScheduleRepeatingTimer("UpdateLogOff", 1)

		if xptxt then
			self.AFKMode.xp:Show()
			self.AFKMode.xp.text:SetText(xptxt)
		else
			self.AFKMode.xp:Hide()
			self.AFKMode.xp.text:SetText("")
		end

		displayline = (format("%s - %s\n%s %s %s %s %s\n%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl))
	
		self.AFKMode.bottom.name:SetText(displayline)
		self.isAFK = true
	else
		self:CancelTimer(self.statsTimer)
		self:CancelTimer(self.logoffTimer)

		self.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
		self.AFKMode.statMsg.info:SetFormattedText("|cffb3b3b3%s|r", L["Random Stats"])
		self.isAFK = false
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
	--if not IsFoolsDay() then return end

	if(status) then

	end
end
--hooksecurefunc(AFK, "SetAFK", prank)

local function Initialize()
	if E.db.benikui.misc.afkMode ~= true then return end

	local level = UnitLevel('player')
	local race = UnitRace('player')
	local localizedClass = UnitClass('player')
	local className = E.myclass
	local spec = getSpec()
	local ilvl = getItemLevel()

	-- Shadow overlay
	AFK.AFKMode.screenShadow = AFK.AFKMode:CreateTexture()
	AFK.AFKMode.screenShadow:SetTexture([[Interface\Addons\ElvUI_BenikUI\media\textures\screenShadow]])
	AFK.AFKMode.screenShadow:SetAllPoints(AFK.AFKMode)

	-- Create Top frame
	AFK.AFKMode.top = CreateFrame('Frame', nil, AFK.AFKMode)
	AFK.AFKMode.top:SetFrameLevel(2)
	AFK.AFKMode.top:SetTemplate('Transparent', true, true)
	AFK.AFKMode.top:SetBackdropBorderColor(.3, .3, .3, 1)
	AFK.AFKMode.top:CreateWideShadow()
	AFK.AFKMode.top:ClearAllPoints()
	AFK.AFKMode.top:Point("TOP", AFK.AFKMode, "TOP", 0, E.Border)
	AFK.AFKMode.top:Width(GetScreenWidth() + (E.Border*2))

	--Top Animation
	AFK.AFKMode.top.anim = CreateAnimationGroup(AFK.AFKMode.top)
	AFK.AFKMode.top.anim.height = AFK.AFKMode.top.anim:CreateAnimation("Height")
	AFK.AFKMode.top.anim.height:SetChange(GetScreenHeight() * (1 / 20))
	AFK.AFKMode.top.anim.height:SetDuration(1)
	AFK.AFKMode.top.anim.height:SetEasing("Bounce")

	-- move the chat lower
	AFK.AFKMode.chat:ClearAllPoints()
	AFK.AFKMode.chat:Point("TOPLEFT", AFK.AFKMode.top, "BOTTOMLEFT", 4, -10)

	-- WoW logo
	AFK.AFKMode.top.wowlogo = CreateFrame('Frame', nil, AFK.AFKMode) -- need this to upper the logo layer
	AFK.AFKMode.top.wowlogo:Point("TOP", AFK.AFKMode.top, "TOP", 0, -5)
	AFK.AFKMode.top.wowlogo:SetFrameStrata("MEDIUM")
	AFK.AFKMode.top.wowlogo:SetFrameLevel(10)
	AFK.AFKMode.top.wowlogo:Size(300, 150)
	AFK.AFKMode.top.wowlogo.tex = AFK.AFKMode.top.wowlogo:CreateTexture(nil, 'OVERLAY')
	local currentExpansionLevel = GetClampedCurrentExpansionLevel();
	local expansionDisplayInfo = GetExpansionDisplayInfo(currentExpansionLevel);
	if expansionDisplayInfo then
		AFK.AFKMode.top.wowlogo.tex:SetTexture(expansionDisplayInfo.logo)
	end
	AFK.AFKMode.top.wowlogo.tex:SetInside()

	-- Server/Local Time text
	AFK.AFKMode.top.time = AFK.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.top.time:FontTemplate(nil, 16)
	AFK.AFKMode.top.time:SetText("")
	AFK.AFKMode.top.time:Point("RIGHT", AFK.AFKMode.top, "RIGHT", -20, 0)
	AFK.AFKMode.top.time:SetJustifyH("LEFT")
	AFK.AFKMode.top.time:SetTextColor(classColor.r, classColor.g, classColor.b)

	-- Date text
	AFK.AFKMode.top.date = AFK.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.top.date:FontTemplate(nil, 16)
	AFK.AFKMode.top.date:SetText("")
	AFK.AFKMode.top.date:Point("LEFT", AFK.AFKMode.top, "LEFT", 20, 0)
	AFK.AFKMode.top.date:SetJustifyH("RIGHT")
	AFK.AFKMode.top.date:SetTextColor(classColor.r, classColor.g, classColor.b)

	-- Statusbar on Top frame decor showing time to log off (30mins)
	AFK.AFKMode.top.Status = CreateFrame('StatusBar', nil, AFK.AFKMode.top)
	AFK.AFKMode.top.Status:SetStatusBarTexture((E["media"].normTex))
	AFK.AFKMode.top.Status:SetMinMaxValues(0, 1800)
	AFK.AFKMode.top.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b, 1)
	AFK.AFKMode.top.Status:SetFrameLevel(3)
	AFK.AFKMode.top.Status:Point('TOPRIGHT', AFK.AFKMode.top, 'BOTTOMRIGHT', 0, E.PixelMode and 3 or 5)
	AFK.AFKMode.top.Status:Point('BOTTOMLEFT', AFK.AFKMode.top, 'BOTTOMLEFT', 0, E.PixelMode and 1 or 2)
	AFK.AFKMode.top.Status:SetValue(0)

	AFK.AFKMode.bottom:SetTemplate('Transparent', true, true)
	AFK.AFKMode.bottom:SetBackdropBorderColor(.3, .3, .3, 1)
	AFK.AFKMode.bottom:SetFrameLevel(2)
	AFK.AFKMode.bottom:CreateWideShadow()
	AFK.AFKMode.bottom.modelHolder:SetFrameLevel(7)

	-- Bottom Frame Animation
	AFK.AFKMode.bottom.anim = CreateAnimationGroup(AFK.AFKMode.bottom)
	AFK.AFKMode.bottom.anim.height = AFK.AFKMode.bottom.anim:CreateAnimation("Height")
	AFK.AFKMode.bottom.anim.height:SetChange(GetScreenHeight() * (1 / 9))
	AFK.AFKMode.bottom.anim.height:SetDuration(1)
	AFK.AFKMode.bottom.anim.height:SetEasing("Bounce")

	-- Move the factiongroup sign to the center
	AFK.AFKMode.bottom.factionb = CreateFrame('Frame', nil, AFK.AFKMode) -- need this to upper the faction logo layer
	AFK.AFKMode.bottom.factionb:Point("BOTTOM", AFK.AFKMode.bottom, "TOP", 0, -40)
	AFK.AFKMode.bottom.factionb:SetFrameStrata("MEDIUM")
	AFK.AFKMode.bottom.factionb:SetFrameLevel(10)
	AFK.AFKMode.bottom.factionb:Size(220, 220)
	AFK.AFKMode.bottom.faction:ClearAllPoints()
	AFK.AFKMode.bottom.faction:SetParent(AFK.AFKMode.bottom.factionb)
	AFK.AFKMode.bottom.faction:SetInside()
	-- Apply class texture rather than the faction
	AFK.AFKMode.bottom.faction:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\classIcons\\CLASS-'..className)

	-- Add more info in the name and position it to the center
	AFK.AFKMode.bottom.name:ClearAllPoints()
	AFK.AFKMode.bottom.name:Point("TOP", AFK.AFKMode.bottom.factionb, "BOTTOM", 0, 5)
	AFK.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s %s%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl)
	AFK.AFKMode.bottom.name:SetJustifyH("CENTER")
	AFK.AFKMode.bottom.name:FontTemplate(nil, 18)

	-- Lower the guild text size a bit
	AFK.AFKMode.bottom.guild:ClearAllPoints()
	AFK.AFKMode.bottom.guild:Point("TOP", AFK.AFKMode.bottom.name, "BOTTOM", 0, -6)
	AFK.AFKMode.bottom.guild:FontTemplate(nil, 12)
	AFK.AFKMode.bottom.guild:SetJustifyH("CENTER")

	-- Add ElvUI name
	AFK.AFKMode.bottom.logotxt = AFK.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.bottom.logotxt:FontTemplate(nil, 24)
	AFK.AFKMode.bottom.logotxt:SetText("ElvUI")
	AFK.AFKMode.bottom.logotxt:Point("LEFT", AFK.AFKMode.bottom, "LEFT", 25, 8)
	AFK.AFKMode.bottom.logotxt:SetTextColor(classColor.r, classColor.g, classColor.b)
	-- and ElvUI version
	AFK.AFKMode.bottom.etext = AFK.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.bottom.etext:FontTemplate(nil, 10)
	AFK.AFKMode.bottom.etext:SetFormattedText("v%s", E.version)
	AFK.AFKMode.bottom.etext:Point("TOP", AFK.AFKMode.bottom.logotxt, "BOTTOM")
	AFK.AFKMode.bottom.etext:SetTextColor(0.7, 0.7, 0.7)
	-- Hide ElvUI logo
	AFK.AFKMode.bottom.LogoTop:Hide()
	AFK.AFKMode.bottom.LogoBottom:Hide()

	-- Add BenikUI name
	AFK.AFKMode.bottom.benikui = AFK.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.bottom.benikui:FontTemplate(nil, 24)
	AFK.AFKMode.bottom.benikui:SetText("BenikUI")
	AFK.AFKMode.bottom.benikui:Point("RIGHT", AFK.AFKMode.bottom, "RIGHT", -25, 8)
	AFK.AFKMode.bottom.benikui:SetTextColor(classColor.r, classColor.g, classColor.b)
	-- and version
	AFK.AFKMode.bottom.btext = AFK.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.bottom.btext:FontTemplate(nil, 10)
	AFK.AFKMode.bottom.btext:SetFormattedText("v%s", BUI.Version)
	AFK.AFKMode.bottom.btext:Point("TOP", AFK.AFKMode.bottom.benikui, "BOTTOM")
	AFK.AFKMode.bottom.btext:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats decor (taken from install routine)
	AFK.AFKMode.statMsg = CreateFrame("Frame", nil, AFK.AFKMode)
	AFK.AFKMode.statMsg:Size(418, 72)
	AFK.AFKMode.statMsg:Point("CENTER", 0, 200)

	AFK.AFKMode.statMsg.bg = AFK.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.statMsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.statMsg.bg:Point('BOTTOM')
	AFK.AFKMode.statMsg.bg:Size(326, 103)
	AFK.AFKMode.statMsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFK.AFKMode.statMsg.bg:SetVertexColor(1, 1, 1, 0.7)

	AFK.AFKMode.statMsg.lineTop = AFK.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.statMsg.lineTop:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.statMsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.statMsg.lineTop:Point("TOP")
	AFK.AFKMode.statMsg.lineTop:Size(418, 7)
	AFK.AFKMode.statMsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	AFK.AFKMode.statMsg.lineBottom = AFK.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.statMsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.statMsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.statMsg.lineBottom:Point("BOTTOM")
	AFK.AFKMode.statMsg.lineBottom:Size(418, 7)
	AFK.AFKMode.statMsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	AFK.AFKMode.statMsg.crest = AFK.AFKMode.statMsg:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.statMsg.crest:SetDrawLayer('BACKGROUND', 2)

	-- Countdown decor
	AFK.AFKMode.countd = CreateFrame("Frame", nil, AFK.AFKMode)
	AFK.AFKMode.countd:Size(418, 36)
	AFK.AFKMode.countd:Point("TOP", AFK.AFKMode.statMsg.lineBottom, "BOTTOM")

	AFK.AFKMode.countd.bg = AFK.AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.countd.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.countd.bg:Point('BOTTOM')
	AFK.AFKMode.countd.bg:Size(326, 56)
	AFK.AFKMode.countd.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFK.AFKMode.countd.bg:SetVertexColor(1, 1, 1, 0.7)

	AFK.AFKMode.countd.lineBottom = AFK.AFKMode.countd:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.countd.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.countd.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.countd.lineBottom:Point('BOTTOM')
	AFK.AFKMode.countd.lineBottom:Size(418, 7)
	AFK.AFKMode.countd.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	-- 30 mins countdown text
	AFK.AFKMode.countd.text = AFK.AFKMode.countd:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.countd.text:FontTemplate(nil, 12)
	AFK.AFKMode.countd.text:Point("CENTER", AFK.AFKMode.countd, "CENTER")
	AFK.AFKMode.countd.text:SetJustifyH("CENTER")
	AFK.AFKMode.countd.text:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
	AFK.AFKMode.countd.text:SetTextColor(0.7, 0.7, 0.7)

	AFK.AFKMode.bottom.time:Hide()

	local xptxt = GetXPinfo()
	-- XP info
	AFK.AFKMode.xp = CreateFrame("Frame", nil, AFK.AFKMode)
	AFK.AFKMode.xp:Size(418, 36)
	AFK.AFKMode.xp:Point("TOP", AFK.AFKMode.countd.lineBottom, "BOTTOM")
	AFK.AFKMode.xp.bg = AFK.AFKMode.xp:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.xp.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.xp.bg:Point('BOTTOM')
	AFK.AFKMode.xp.bg:Size(326, 56)
	AFK.AFKMode.xp.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	AFK.AFKMode.xp.bg:SetVertexColor(1, 1, 1, 0.7)
	AFK.AFKMode.xp.lineBottom = AFK.AFKMode.xp:CreateTexture(nil, 'BACKGROUND')
	AFK.AFKMode.xp.lineBottom:SetDrawLayer('BACKGROUND', 2)
	AFK.AFKMode.xp.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	AFK.AFKMode.xp.lineBottom:Point('BOTTOM')
	AFK.AFKMode.xp.lineBottom:Size(418, 7)
	AFK.AFKMode.xp.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	AFK.AFKMode.xp.text = AFK.AFKMode.xp:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.xp.text:FontTemplate(nil, 12)
	AFK.AFKMode.xp.text:Point("CENTER", AFK.AFKMode.xp, "CENTER")
	AFK.AFKMode.xp.text:SetJustifyH("CENTER")
	AFK.AFKMode.xp.text:SetText(xptxt)
	AFK.AFKMode.xp.text:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats frame
	AFK.AFKMode.statMsg.info = AFK.AFKMode.statMsg:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.statMsg.info:FontTemplate(nil, 18)
	AFK.AFKMode.statMsg.info:Point("CENTER", AFK.AFKMode.statMsg, "CENTER", 0, -2)
	AFK.AFKMode.statMsg.info:SetText(format("|cffb3b3b3%s|r", L["Random Stats"]))
	AFK.AFKMode.statMsg.info:SetJustifyH("CENTER")
	AFK.AFKMode.statMsg.info:SetTextColor(0.7, 0.7, 0.7)
end

hooksecurefunc(AFK, "Initialize", Initialize)
