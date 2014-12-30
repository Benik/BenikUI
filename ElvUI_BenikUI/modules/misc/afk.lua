local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AFK = E:GetModule('AFK')
local LSM = LibStub('LibSharedMedia-3.0')
local BUI = E:GetModule('BenikUI');

local format, random, lower, upper = string.format, random, lower, string.upper
local SPACING = (E.PixelMode and 1 or 5)

-- Source wowhead.com
local stats = {
	60,		-- Total deaths
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
	1088,	-- Kael'thas Sunstrider kills (Tempest Keep)
	1149,	-- Talent tree respecs
	1197,	-- Total kills
	1098,	-- Onyxia kills (Onyxia's Lair)
	1198,	-- Total kills that grant experience or honor
	1487,	-- Killing Blows
	1491,	-- Battleground Killing Blows
	1518,	-- Fish caught
	1716,	-- Battleground with the most Killing Blows
	4687,	-- Victories over the Lich King (Icecrown 25 player)
	5692,	-- Rated battlegrounds played
	5694,	-- Rated battlegrounds won
	6167,	-- Deathwing kills (Dragon Soul)
	7399,	-- Challenge mode dungeons completed
	8278,	-- Pet Battles won at max level
	8632,	-- Garrosh Hellscream (LFR Siege of Orgrimmar)
}

-- Remove capitals from class except first letter
local function handleClass()
	local lowclass = E.myclass:lower()
    local firstclass = lowclass:gsub("^%l", upper)
	return firstclass
end

-- Create random stats
local function createStats()
	local id = stats[random( #stats )]
	local _, name = GetAchievementInfo(id)
	local result = GetStatistic(id)
	if result == "--" then result = NONE end
	return format("%s: |cfff0ff00%s|r", name, result)
end

-- Create Time
local function createTime()
	local hour, minute, ampm = tonumber(date("%I")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = GetGameTime()
	
	if E.db.datatexts.localtime then
		return format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	else
		sHour = sHour - 12
		return format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	end
end

-- Create Date
local curDate = date("%a, %b %d, %Y")
local function createDate()
	local today = date("%a, %b %d, %Y")
	-- stop if the date is the same
	if today == curDate then return end
	-- update if not
	AFK.AFKMode.top.date:SetText(today)
end

-- simple timer
local showTime = 5
local total = 0
local function onUpdate(self, elapsed)
	total = total + elapsed
	if total >= showTime then
		local createdStat = createStats()
		self:AddMessage(createdStat)
		E:UIFrameFadeIn(self, 1, 0, 1)
		total = 0
	end
end

AFK.UpdateTimerBui = AFK.UpdateTimer
function AFK:UpdateTimer()
	self:UpdateTimerBui()

	local time = GetTime() - self.startTime
	local createdTime = createTime()
	local minutes = floor(time/60)
	local neg_seconds = -time % 60

	-- Set the value on log off statusbar
	self.AFKMode.top.style.Status:SetValue(floor(time))
	
	-- Set time
	self.AFKMode.top.time:SetText(createdTime)
	
	-- Set Date
	createDate()
	
	-- Set the 35 mins countdown. 60 secs before log out will go red. 30 secs will flash
	if (minutes -34 >= 0) and (neg_seconds >= 0) then
		self.AFKMode.countd.text:SetText(format("|cffff8000"..CAMP_TIMER.."|r", neg_seconds, L["sec"]))
		if neg_seconds <= 30 then
			E:Flash(self.AFKMode.countd.text, 0.5, true)
		else
			E:StopFlash(self.AFKMode.countd.text)
		end
	else
		self.AFKMode.countd.text:SetText(format("%s: |cfff0ff00%02d:%02d|r", L["Logout Timer"], minutes -34, neg_seconds))
	end
	
	-- Don't need the default timer
	self.AFKMode.bottom.time:SetText(nil)
end

AFK.InitializeBuiAfk = AFK.Initialize
function AFK:Initialize()
	self:InitializeBuiAfk()

	local level = UnitLevel('player')
	local nonCapClass = handleClass()
	
	-- Create Top frame
	self.AFKMode.top = CreateFrame('Frame', nil, self.AFKMode)
	self.AFKMode.top:SetFrameLevel(0)
	self.AFKMode.top:SetTemplate('Transparent')
	self.AFKMode.top:SetPoint("TOP", self.AFKMode, "TOP", 0, E.Border)
	self.AFKMode.top:SetWidth(GetScreenWidth() + (E.Border*2))
	self.AFKMode.top:SetHeight(GetScreenHeight() * (1 / 20))

	--Style the top frame
	self.AFKMode.top.style = CreateFrame('Frame', nil, self.AFKMode)
	self.AFKMode.top.style:SetTemplate('Default', true)
	self.AFKMode.top.style:SetFrameStrata("BACKGROUND")
	self.AFKMode.top.style:Point('TOPLEFT', self.AFKMode.top, 'BOTTOMLEFT', 0, SPACING)
	self.AFKMode.top.style:Point('BOTTOMRIGHT', self.AFKMode.top, 'BOTTOMRIGHT', 0, -4)
	
	-- WoW logo
	self.AFKMode.top.wowlogo = self.AFKMode.top:CreateTexture(nil, 'OVERLAY')
	self.AFKMode.top.wowlogo:SetPoint("TOP", self.AFKMode.top, "TOP", 0, -5)
	self.AFKMode.top.wowlogo:SetTexture("Interface\\Glues\\Common\\GLUES-WOW-WODLOGO")
	self.AFKMode.top.wowlogo:SetSize(300, 150)	
	
	-- Server/Local Time text
	self.AFKMode.top.time = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.top.time:FontTemplate(nil, 16)
	self.AFKMode.top.time:SetText("")
	self.AFKMode.top.time:SetPoint("RIGHT", self.AFKMode.top, "RIGHT", -20, 0)
	self.AFKMode.top.time:SetJustifyH("LEFT")
	self.AFKMode.top.time:SetTextColor(1, 0.5, 0.1)
	
	-- Date text
	self.AFKMode.top.date = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.top.date:FontTemplate(nil, 16)
	self.AFKMode.top.date:SetText(curDate)
	self.AFKMode.top.date:SetPoint("LEFT", self.AFKMode.top, "LEFT", 20, 0)
	self.AFKMode.top.date:SetJustifyH("RIGHT")
	self.AFKMode.top.date:SetTextColor(1, 0.5, 0.1)
	
	-- Statusbar on Top frame decor showing time to log off (35mins)
	self.AFKMode.top.style.Status = CreateFrame('StatusBar', nil, self.AFKMode.top.style)
	self.AFKMode.top.style.Status:SetStatusBarTexture((E["media"].normTex))
	self.AFKMode.top.style.Status:SetMinMaxValues(0, 2100)
	self.AFKMode.top.style.Status:SetStatusBarColor(1, 0.5, 0.1, 1)
	self.AFKMode.top.style.Status:SetInside()
	self.AFKMode.top.style.Status:SetValue(0)
	
	-- Style the bottom frame
	self.AFKMode.bottom:Style('Outside')
	if self.AFKMode.bottom.style then
		self.AFKMode.bottom.style:SetFrameStrata("BACKGROUND")
	end
	
	-- Move the factiongroup sign to the center
	self.AFKMode.bottom.faction:ClearAllPoints()
	self.AFKMode.bottom.faction:SetPoint("CENTER", self.AFKMode.bottom, "CENTER", 0, 80)
	
	-- Add more info in the name and position it to the center
	self.AFKMode.bottom.name:ClearAllPoints()	
	self.AFKMode.bottom.name:SetPoint("TOP", self.AFKMode.bottom.faction, "BOTTOM", 0, 15)
	self.AFKMode.bottom.name:SetText(E.myname.." - "..E.myrealm.."\n"..LEVEL.." "..level.." "..E.myrace.." "..nonCapClass)
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
	self.AFKMode.bottom.logotxt:SetTextColor(1, 0.5, 0.1)
	-- and ElvUI version
	self.AFKMode.bottom.etext = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.etext:FontTemplate(nil, 10)
	self.AFKMode.bottom.etext:SetText(format("v%s", E.version))
	self.AFKMode.bottom.etext:SetPoint("TOP", self.AFKMode.bottom.logotxt, "BOTTOM")
	self.AFKMode.bottom.etext:SetTextColor(0.7, 0.7, 0.7)
	-- Hide ElvUI logo
	self.AFKMode.bottom.logo:Hide()
	
	-- Add BenikUI name
	self.AFKMode.bottom.benikui = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.benikui:FontTemplate(nil, 24)
	self.AFKMode.bottom.benikui:SetText("BenikUI")
	self.AFKMode.bottom.benikui:SetPoint("RIGHT", self.AFKMode.bottom, "RIGHT", -25, 8)
	self.AFKMode.bottom.benikui:SetTextColor(1, 0.5, 0.1)
	-- and version
	self.AFKMode.bottom.btext = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.btext:FontTemplate(nil, 10)
	self.AFKMode.bottom.btext:SetText(format("v%s", BUI.Version))
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

	-- 35 mins countdown text
	self.AFKMode.countd.text = self.AFKMode.countd:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.countd.text:FontTemplate(nil, 12)
	self.AFKMode.countd.text:SetPoint("CENTER", self.AFKMode.countd, "CENTER")
	self.AFKMode.countd.text:SetJustifyH("CENTER")
	self.AFKMode.countd.text:SetText(format("%s: |cfff0ff00-35:00|r", L["Logout Timer"]))
	self.AFKMode.countd.text:SetTextColor(0.7, 0.7, 0.7)
	
	self.AFKMode.bottom.time:Hide()
	
	-- Random stats frame
	self.AFKMode.statMsg.info = CreateFrame("ScrollingMessageFrame", nil, self.AFKMode.statMsg)
	self.AFKMode.statMsg.info:FontTemplate(nil, 18)
	self.AFKMode.statMsg.info:SetPoint("CENTER", self.AFKMode.statMsg, "CENTER", 0, 0)
	self.AFKMode.statMsg.info:SetSize(800, 24)
	self.AFKMode.statMsg.info:AddMessage(format("|cffb3b3b3%s|r", L["Random Stats"]))
	self.AFKMode.statMsg.info:SetFading(true)
	self.AFKMode.statMsg.info:SetFadeDuration(1)
	self.AFKMode.statMsg.info:SetTimeVisible(4)
	self.AFKMode.statMsg.info:SetJustifyH("CENTER")
	self.AFKMode.statMsg.info:SetTextColor(0.7, 0.7, 0.7)
	self.AFKMode.statMsg.info:SetScript("OnUpdate", onUpdate)

end