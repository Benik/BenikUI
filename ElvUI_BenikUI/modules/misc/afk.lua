local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AFK = E:GetModule('AFK')
local LSM = LibStub('LibSharedMedia-3.0')

local format, random, lower, upper = string.format, random, lower, string.upper
local showTime = 5

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
	328,	-- Total gold acquired
	333,	-- Gold looted
	338,	-- Vanity pets owned
	339,	-- Mounts owned
	349,	-- Flight paths taken
	377,	-- Most factions at Exalted
	588,	-- Total Honorable Kills
	837,	-- Arenas won
	838,	-- Arenas played
	839,	-- Battlegrounds played
	840,	-- Battlegrounds won
	932,	-- Total 5-player dungeons entered
	933,	-- Total 10-player raids entered
	934,	-- Total 25-player raids entered
	1042,	-- Number of hugs
	1045,	-- Total cheers
	1047,	-- Total facepalms
	1066,	-- Total times LOL'd
	1197,	-- Total kills
	1198,	-- Total kills that grant experience or honor
	1487,	-- Killing Blows
	1491,	-- Battleground Killing Blows
	1518,	-- Fish caught
	1716,	-- Battleground with the most Killing Blows
	5692,	-- Rated battlegrounds played
	5694,	-- Rated battlegrounds won
	7399,	-- Challenge mode dungeons completed
	8278,	-- Pet Battles won at max level
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

-- simple timer
local total = 0
local function onUpdate(self,elapsed)
	total = total + elapsed
	if total >= showTime then
		local createdStat = createStats()
		self:AddMessage(createdStat)
		total = 0
	end
end

AFK.InitializeBuiAfk = AFK.Initialize
function AFK:Initialize()
	self:InitializeBuiAfk()

	local level = UnitLevel('player')
	local nonCapClass = handleClass()
	
	-- Style the bottom frame
	self.AFKMode.bottom:Style('Outside')
	self.AFKMode.bottom.style:SetFrameLevel(self.AFKMode.bottom:GetFrameLevel())

	-- Add more info in the name
	self.AFKMode.bottom.name:SetText(E.myname.." - "..E.myrealm.."\n"..LEVEL.." "..level.." "..E.myrace.." "..nonCapClass)
	self.AFKMode.bottom.name:SetJustifyH("LEFT")
	self.AFKMode.bottom.name:FontTemplate(nil, 16)	

	-- Lower the guild text size a bit
	self.AFKMode.bottom.guild:FontTemplate(nil, 12)
	self.AFKMode.bottom.guild:SetJustifyH("LEFT")
	
	-- Reduce ElvUI logo size a bit
	self.AFKMode.bottom.logo:SetSize(280, 130)
	self.AFKMode.bottom.logo:SetPoint("CENTER", self.AFKMode.bottom, "CENTER", 0, 60)
	
	-- Add BenikUI logo
	self.AFKMode.bottom.builogo = self.AFKMode.bottom:CreateTexture(nil, 'OVERLAY')
	self.AFKMode.bottom.builogo:SetSize(160, 75)
	self.AFKMode.bottom.builogo:SetPoint("RIGHT", self.AFKMode.bottom, "RIGHT", -20, 8)
	self.AFKMode.bottom.builogo:SetTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga")
	-- and text
	self.AFKMode.bottom.styled = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.styled:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	self.AFKMode.bottom.styled:SetText("- styled -")
	self.AFKMode.bottom.styled:SetPoint("TOP", self.AFKMode.bottom.builogo, "BOTTOM", 5, 15)
	self.AFKMode.bottom.styled:SetTextColor(0.7, 0.7, 0.7)

	-- Random stats frame
	self.AFKMode.bottom.info = CreateFrame("ScrollingMessageFrame", nil, self.AFKMode.bottom)
	self.AFKMode.bottom.info:FontTemplate(nil, 18)
	self.AFKMode.bottom.info:SetPoint("TOP", self.AFKMode.bottom.logo, "BOTTOM", 0, 10)
	self.AFKMode.bottom.info:SetSize(500, 24)
	self.AFKMode.bottom.info:SetFading(true)
	self.AFKMode.bottom.info:SetFadeDuration(1)
	self.AFKMode.bottom.info:SetTimeVisible(3)
	self.AFKMode.bottom.info:SetJustifyH("CENTER")
	self.AFKMode.bottom.info:SetTextColor(0.7, 0.7, 0.7)
	self.AFKMode.bottom.info:SetScript("OnUpdate", onUpdate)
	
	self.AFKMode.bottom.time:SetJustifyH("LEFT")
end