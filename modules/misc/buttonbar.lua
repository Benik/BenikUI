local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local LSM = LibStub("LibSharedMedia-3.0")
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")

local gsub = string.gsub
local upper = string.upper

local menuFrame = CreateFrame("Frame", "BenikGameClickMenu", E.UIParent)
menuFrame:SetTemplate("Transparent", true)

local calendar_string = gsub(SLASH_CALENDAR1, "/", "")
calendar_string = gsub(calendar_string, "^%l", upper)

local menuList = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
	{text = MOUNTS_AND_PETS,
	func = function()
		TogglePetJournal();
	end},
	{text = TALENTS_BUTTON,
	func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not GlyphFrame then
			GlyphFrame_LoadUI()
		end
		
		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = L["Farm Mode"],
	func = FarmMode},
	{text = TIMEMANAGER_TITLE,
	func = function() ToggleFrame(TimeManagerFrame) end},		
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame() end},
	{text = calendar_string,
	func = function() GameTimeFrame:Click() end},
	{text = PLAYER_V_PLAYER,
	func = function()
		if not PVPUIFrame then
			PVP_LoadUI()
		end	
		ToggleFrame(PVPUIFrame) 
	end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
		if IsInGuild() then
			if not GuildFrame then GuildFrame_LoadUI() end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
			if not LookingForGuildFrame then return end
			LookingForGuildFrame_Toggle()
		end
	end},
	{text = LFG_TITLE,
	func = function() PVEFrame_ToggleFrame(); end},
	{text = L["Raid Browser"],
	func = function() ToggleFrame(RaidBrowserFrame); end},
	{text = ENCOUNTER_JOURNAL, 
	func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},
	{text = BLIZZARD_STORE, func = function() StoreMicroButton:Click() end},
	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end}
}

local function BenikGameMenu_OnMouseUp()
	E:DropDown(menuList, menuFrame, 0, 300)
end

local function SetupTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 0)
	GameTooltip:ClearAllPoints()
	GameTooltip:ClearLines()
end

local function BenikButtons_OnLeave()
	GameTooltip:Hide()
end

local BUTTON_HEIGHT = 17
local BUTTON_NUM = 3
local BUTTON_SPACING = 3

local bholder = CreateFrame('Frame', 'BenikButtons', E.UIParent)
bholder:CreateBackdrop('Transparent')
bholder:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, E.mult + 4)
bholder:Size((BUTTON_HEIGHT*BUTTON_NUM)+(BUTTON_NUM*2)+BUTTON_SPACING+2, BUTTON_HEIGHT)
bholder:SetFrameStrata('LOW')
--bholder:EnableMouse(true)
E:BenikStyle('BenikButtonsDecor', BenikButtons)
E.FrameLocks['BenikButtons'] = true;

local function BenikDashboardOnFade()
	BenikDashboard:Hide()
end

local function tholderOnFade()
	tokenHolder:Hide()
end

local bbuttons = {}

for i = 1, BUTTON_NUM do
	bbuttons[i] = CreateFrame('Frame', 'BenikButton_'..i, BenikButtons)
	bbuttons[i]:Point('LEFT', BenikButtons, 'LEFT')
	bbuttons[i]:Size((BenikButtons:GetWidth()/BUTTON_NUM), BUTTON_HEIGHT)
	bbuttons[i]:EnableMouse(true)
	bbuttons[i]:SetScript('OnLeave', BenikButtons_OnLeave)
	bbuttons[i].text = bbuttons[i]:CreateFontString(nil, 'OVERLAY')
	bbuttons[i].text:FontTemplate()
	bbuttons[i].text:SetPoint('CENTER', 2, 0)
	bbuttons[i].text:SetJustifyH('CENTER')
	bbuttons[i].text:SetTextColor(1, 0.5, 0)

	
	if i == 1 then
		bbuttons[i]:Point('LEFT', BenikButtons, 'LEFT')
	else
		bbuttons[i]:Point('LEFT', bbuttons[i-1], 'RIGHT')
	end
	
	if i == 1 then
		bbuttons[i]:SetScript('OnMouseUp', BenikGameMenu_OnMouseUp)
		bbuttons[i].text:SetText('G')
		GameTooltip:AddLine("Game Menu", selectioncolor)
		GameTooltip:Show()
		bbuttons[i]:SetScript('OnEnter', function( self )
			GameTooltip:SetOwner(bbuttons[i], "ANCHOR_TOP", 0, 0 )
			GameTooltip:ClearLines()
			GameTooltip:AddLine("Game Menu", selectioncolor)
			GameTooltip:Show()
		end)
		
	elseif i == 2 then
		bbuttons[i]:SetScript('OnMouseUp', function(self)
			if not BenikDashboard then return end
			if BenikDashboard:IsVisible() then
				UIFrameFadeOut(BenikDashboard, 0.2, BenikDashboard:GetAlpha(), 0)
				BenikDashboard.fadeInfo.finishedFunc = BenikDashboardOnFade
			else
				UIFrameFadeIn(BenikDashboard, 0.2, BenikDashboard:GetAlpha(), 1)
				BenikDashboard:Show()
			end
		end)	
		bbuttons[i].text:SetText('D')
		bbuttons[i]:SetScript('OnEnter', function( self )
			GameTooltip:SetOwner(bbuttons[i], "ANCHOR_TOP", 0, 0 )
			GameTooltip:ClearLines()
			GameTooltip:AddLine("Toggle Dashboard", selectioncolor)
			GameTooltip:Show()
		end)
	elseif i == 3 then
		bbuttons[i]:SetScript("OnMouseUp", function(self)
			if not tokenHolder then return end
			if tokenHolder:IsVisible() then
				UIFrameFadeOut(tokenHolder, 0.2, tokenHolder:GetAlpha(), 0)
				tokenHolder.fadeInfo.finishedFunc = tholderOnFade
			else
				UIFrameFadeIn(tokenHolder, 0.2, tokenHolder:GetAlpha(), 1)
				tokenHolder:Show()
			end
		end)
		bbuttons[i].text:SetText('T')
		bbuttons[i]:SetScript('OnEnter', function( self )
			GameTooltip:SetOwner(bbuttons[i], "ANCHOR_TOP", 0, 0 )
			GameTooltip:ClearLines()
			GameTooltip:AddLine("Toggle Tokens", selectioncolor)
			GameTooltip:Show()
		end)
	end
		
	--[[elseif i == 4 then
		bbuttons[i]:SetScript("OnMouseUp", function(self)
			if not tokenHolder then return end
			if tokenHolder:IsVisible() then
				UIFrameFadeOut(tokenHolder, 0.2, tokenHolder:GetAlpha(), 0)
				tokenHolder.fadeInfo.finishedFunc = tholderOnFade
			else
				UIFrameFadeIn(tokenHolder, 0.2, tokenHolder:GetAlpha(), 1)
				tokenHolder:Show()
			end
		end)
		bbuttons[i].text:SetText('T')
		bbuttons[i]:SetScript('OnEnter', function( self )
			GameTooltip:SetOwner(bbuttons[i], "ANCHOR_TOP", 0, 0 )
			GameTooltip:ClearLines()
			GameTooltip:AddLine("Toggle Tokens", selectioncolor)
			GameTooltip:Show()
		end)
	end]]
end

E:CreateMover(BenikButtons, "BenikButtonsMover", L["Benik Buttons"]) -- temporary