local E, L, V, P, G = unpack(ElvUI);
local BUIS = E:NewModule('BuiSkins', 'AceHook-3.0', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local S = E:GetModule('Skins');

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn

local DUNGEON_COMPLETION_MAX_REWARDS, MAX_SKILLLINE_TABS, MAX_ACHIEVEMENT_ALERTS = DUNGEON_COMPLETION_MAX_REWARDS, MAX_SKILLLINE_TABS, MAX_ACHIEVEMENT_ALERTS

-- GLOBALS: hooksecurefunc

local SPACING = (E.PixelMode and 1 or 2)

local FreeBlizzFrames = {
	AddFriendFrame,
	AddonList,
	AudioOptionsFrame,
	BNToastFrame,
	ChatConfigFrame,
	ChatMenu,
	ClassTrainerFrame,
	ColorPickerFrame,
	DressUpFrame,
	DropDownList1,
	DropDownList2,
	ElvUI_StaticPopup1,
	ElvUI_StaticPopup2,
	ElvUI_StaticPopup3,
	EmoteMenu,
	FloatingBattlePetTooltip,
	FriendsFrame,
	FriendsTooltip,
	GameMenuFrame,
	GearManagerDialogPopup,
	GossipFrame,
	GuildRegistrarFrame,
	InterfaceOptionsFrame,
	ItemRefTooltip,
	ItemTextFrame,
	LanguageMenu,
	LFGDungeonReadyPopup,
	LFGDungeonReadyDialog,
	LFGDungeonReadyStatus,
	LFGListApplicationDialog,
	LFGListInviteDialog,
	LootFrame,
	MailFrame,
	MasterLooterFrame,
	MerchantFrame,
	MinimapRightClickMenu,
	OpenMailFrame,
	PaperDollFrame,
	PetitionFrame, -- check
	PetPaperDollFrame,
	PetStableFrame,
	PVPReadyDialog,
	QuestLogPopupDetailFrame,
	QueueStatusFrame,
	RaidInfoFrame,
	ReadyCheckFrame,
	ReadyCheckListenerFrame,
	RecruitAFriendFrame,
	ReputationDetailFrame,
	ReputationFrame,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	SideDressUpFrame,
	SpellBookFrame,
	StackSplitFrame,
	StaticPopup1,
	StaticPopup2,
	StaticPopup3,
	TabardFrame,
	TicketStatusFrameButton, -- check
	TokenFrame,
	TokenFramePopup,
	TradeFrame,
	VideoOptionsFrame,
	VoiceMacroMenu,
	WorldStateScoreFrame,
}

-------------------------------------
-- the style is smaller by 1-2 pixels
-------------------------------------
local FreeBlizzSmallerFrames = {
	ChannelFrameDaughterFrame,
	FriendsFriendsFrame,
	HelpFrame,
	HelpFrameHeader,
	PVEFrame,
	QuestFrame,
	QuestNPCModel,
	RaidBrowserFrame,
	SplashFrame,
	TaxiFrame,
}

local BlizzUiFrames = {
	--{'BlizzUIname, 'FrameToBeStyled, 'ElvUIdisableSkinOption'}
	{'Blizzard_AchievementUI', 'AchievementFrame', 'achievement'},
	{'Blizzard_ArchaeologyUI', 'ArchaeologyFrame', 'archaeology'},
	{'Blizzard_ArtifactUI', 'ArtifactFrame', 'artifact'},
	{'Blizzard_AuctionUI', 'AuctionFrame', 'auctionhouse'},
	{'Blizzard_BarbershopUI', 'BarberShopFrame', 'barber'},
	{'Blizzard_BattlefieldMinimap', 'BattlefieldMinimap', 'bgmap'},
	{'Blizzard_BindingUI', 'KeyBindingFrame', 'binding'},
	{'Blizzard_BlackMarketUI', 'BlackMarketFrame', 'bmah'},
	{'Blizzard_Calendar', 'CalendarFrame', 'calendar'}, -- issues non pixel perfect
	{'Blizzard_Calendar', 'CalendarViewEventFrame', 'calendar'},
	{'Blizzard_Calendar', 'CalendarViewHolidayFrame', 'calendar'},
	{'Blizzard_Calendar', 'CalendarCreateEventFrame', 'calendar'},
	{'Blizzard_FlightMap', 'FlightMapFrame', 'taxi'},
	{'Blizzard_GuildBankUI', 'GuildBankFrame', 'gbank'},
	{'Blizzard_GuildUI', 'GuildFrame', 'guild'},
	{'Blizzard_GuildControlUI', 'GuildControlUI', 'guildcontrol'},
	{'Blizzard_InspectUI', 'InspectFrame', 'inspect'},
	{'Blizzard_ItemAlterationUI', 'TransmogrifyFrame', 'transmogrify'},
	{'Blizzard_ItemUpgradeUI', 'ItemUpgradeFrame', 'itemUpgrade'},
	{'Blizzard_LookingForGuildUI', 'LookingForGuildFrame', 'lfguild'},
	{'Blizzard_MacroUI', 'MacroFrame', 'macro'},
	{'Blizzard_DeathRecap', 'DeathRecapFrame', 'deathRecap'},
	{'Blizzard_Collections', 'CollectionsJournal', 'mounts'},
	{'Blizzard_ItemSocketingUI', 'ItemSocketingFrame', 'socket'},
	{'Blizzard_TalentUI', 'PlayerTalentFrame', 'talent'},
	{'Blizzard_TradeSkillUI', 'TradeSkillFrame', 'trade'},
	{'Blizzard_TrainerUI', 'ClassTrainerFrame', 'trainer'},
	{'Blizzard_VoidStorageUI', 'VoidStorageFrame', 'voidstorage'},
}

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

function BUI:StyleBlizzard(parent, ...)
	local frame = CreateFrame('Frame', parent..'Decor', E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', SPACING, (E.PixelMode and 3 or 5))
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', -SPACING, (E.PixelMode and 0 or 3))
	
	frame.backdrop.color = frame.backdrop:CreateTexture(nil, 'OVERLAY')
	frame.backdrop.color:SetInside()
	frame.backdrop.color:SetTexture(E['media'].BuiFlat)
	if E.db.benikui.colors.StyleColor == 1 then
		frame.backdrop.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
	elseif E.db.benikui.colors.StyleColor == 2 then
		frame.backdrop.color:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customStyleColor))
	elseif E.db.benikui.colors.StyleColor == 3 then
		frame.backdrop.color:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
	else
		frame.backdrop.color:SetVertexColor(BUI:unpackColor(E.db.general.backdropcolor))
	end
end

function BUIS:BlizzardUI_LOD_Skins(event, addon)
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end
	for i, v in ipairs(BlizzUiFrames) do
		local blizzAddon, blizzFrame, elvoption = unpack( v )
		if (event == 'ADDON_LOADED' and addon == blizzAddon) then
			if E.private.skins.blizzard[elvoption] ~= true then return end
			if blizzFrame then
				BUI:StyleBlizzard(blizzFrame)

				-- Fixes/Style tabs, buttons, etc
				if addon == 'Blizzard_AchievementUI' then
					if _G["AchievementFrameDecor"] then
						_G["AchievementFrameDecor"]:ClearAllPoints()
						_G["AchievementFrameDecor"]:Point('TOPLEFT', _G["AchievementFrame"], 'TOPLEFT', (E.PixelMode and 1 or 2), (E.PixelMode and 9 or 11))
						_G["AchievementFrameDecor"]:Point('BOTTOMRIGHT', _G["AchievementFrame"], 'TOPRIGHT', -(E.PixelMode and 1 or 2), (E.PixelMode and 6 or 9))			
					end
				end
				
				if addon == 'Blizzard_GuildBankUI' then
					for i = 1, 8 do
						local button = _G['GuildBankTab'..i..'Button']
						local texture = _G['GuildBankTab'..i..'ButtonIconTexture']
						if not button.style then
							button:Style('Inside')
							texture:SetTexCoord(unpack(BUI.TexCoords))
						end
					end
				end
				
				if addon == 'Blizzard_TalentUI' then
					for i = 1, 2 do
						local tab = _G['PlayerSpecTab'..i]
						if not tab.style then
							tab:Style('Inside')
							tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
							tab:GetNormalTexture():SetInside()
						end
					end
				end
				
				if addon == 'Blizzard_GuildUI' then
					local GuildFrames = {_G["GuildMemberDetailFrame"], _G["GuildTextEditFrame"], _G["GuildLogFrame"], _G["GuildNewsFiltersFrame"]}
					for _, frame in pairs(GuildFrames) do
						if frame and not frame.style then
							frame:Style('Outside')
						end
					end
				end
				
				if addon == 'Blizzard_VoidStorageUI' then
					for i = 1, 2 do
						local tab = _G["VoidStorageFrame"]["Page"..i]
						if not tab.style then
							tab:Style('Inside')
							tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
							tab:GetNormalTexture():SetInside()
						end
					end
				end
				
				if addon == 'Blizzard_BarbershopUI' then
					_G["BarberShopAltFormFrame"]:Style('Outside')
				end
				
			end
		end
	end
	
	if addon == 'Blizzard_EncounterJournal' then
		if E.private.skins.blizzard.encounterjournal == true then
			if not _G["EncounterJournal"].style then
				_G["EncounterJournal"]:Style('Small')
			end
			_G["EncounterJournalTooltip"]:Style('Outside')
			local Tabs = {
				_G["EncounterJournalEncounterFrameInfoBossTab"],
				_G["EncounterJournalEncounterFrameInfoLootTab"],
				_G["EncounterJournalEncounterFrameInfoModelTab"],
				_G["EncounterJournalEncounterFrameInfoOverviewTab"]
			}
			
			for _, Tab in pairs(Tabs) do
				if Tab.backdrop then
					Tab.backdrop:Style('Outside')
				end
			end
		end
	end
	
	if addon == 'Blizzard_QuestChoice' and E.private.skins.blizzard.questChoice then
		if not _G["QuestChoiceFrame"].style then
			_G["QuestChoiceFrame"]:Style('Small')
		end
	end
	
	if addon == 'Blizzard_AuctionUI' then
		if not _G["AuctionProgressFrame"].style then
			_G["AuctionProgressFrame"]:Style('Outside')
		end
		if not _G["WowTokenGameTimeTutorial"].style then
			_G["WowTokenGameTimeTutorial"]:Style('Small')
		end
	end
	
	if addon == 'Blizzard_ArtifactUI' then
		_G["ArtifactFrame"]:Style('Small')
		ArtifactFrame.CloseButton:ClearAllPoints()
		ArtifactFrame.CloseButton:SetPoint("TOPRIGHT", ArtifactFrame, "TOPRIGHT", 2, 2)
	end
	
	if addon == 'Blizzard_FlightMap' then
		_G["FlightMapFrame"]:Style('Small')
	end

	if E.private.skins.blizzard.timemanager == true then
		if not _G["TimeManagerFrame"].style then
			_G["TimeManagerFrame"]:Style('Outside')
		end
		
		if not _G["StopwatchFrame"].backdrop.style then
			_G["StopwatchFrame"].backdrop:Style('Outside')
		end
	end
end

-- Blizzard Styles
local function styleFreeBlizzardFrames()
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end
	
	for _, frame in pairs(FreeBlizzFrames) do
		if frame and not frame.style then
			frame:Style('Outside')
		end
	end

	for _, frame in pairs(FreeBlizzSmallerFrames) do
		if frame and not frame.style then
			frame:Style('Small')
		end
	end
end

-- SpellBook tabs
local function styleSpellbook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true then return end
	
	hooksecurefunc('SpellBookFrame_UpdateSkillLineTabs', function()
		for i = 1, MAX_SKILLLINE_TABS do
			local tab = _G['SpellBookSkillLineTab'..i]
			if not tab.style then
				tab:Style('Inside')
			end
		end
	end)
end

-- Alert Frames
local function styleAlertFrames()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.alertframes ~= true then return end
	hooksecurefunc('LootWonAlertFrame_SetUp', function(frame)
		if frame then
			frame.backdrop:Style('Outside')
		end
	end)
	
	hooksecurefunc('MoneyWonAlertFrame_SetUp', function(frame)
		if frame then
			frame.backdrop:Style('Outside')
		end	
	end)
	
	hooksecurefunc('LootUpgradeFrame_SetUp', function(frame)
		if frame then
			frame.backdrop:Style('Outside')
		end	
	end)

	--[[hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function(anchorFrame)
		for i = 1, DUNGEON_COMPLETION_MAX_REWARDS do
			local frame = _G["DungeonCompletionAlertFrame"..i]
			if frame then
				frame.backdrop:Style('Outside')
			end
		end
	end)
	
	hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", function(anchorFrame)
		local frame = _G["GuildChallengeAlertFrame"]
		if frame then
			frame.backdrop:Style('Outside')
		end
	end)

	hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function(anchorFrame)
		local frame = _G["ChallengeModeAlertFrame1"]
		if frame then
			frame.backdrop:Style('Outside')
		end
	end)

	hooksecurefunc("AlertFrame_SetScenarioAnchors", function(anchorFrame)
		local frame = _G["ScenarioAlertFrame1"]
		if frame then
			frame.backdrop:Style('Outside')
		end
	end)

	hooksecurefunc('AlertFrame_SetCriteriaAnchors', function()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G['CriteriaAlertFrame'..i]
			if frame then
				frame.backdrop:Style('Outside')
			end
		end
	end)]]

	_G["BonusRollFrame"]:Style('Outside')
	--[[_G["BonusRollMoneyWonFrame"].backdrop:Style('Outside')
	_G["BonusRollLootWonFrame"].backdrop:Style('Outside')
	
	_G["GarrisonBuildingAlertFrame"].backdrop:Style('Outside')
	_G["GarrisonMissionAlertFrame"].backdrop:Style('Outside')
	_G["GarrisonFollowerAlertFrame"]:StripTextures()
	_G["GarrisonFollowerAlertFrame"].backdrop:Style('Outside')
	
	_G["GarrisonShipMissionAlertFrame"]:StripTextures()
	_G["GarrisonShipMissionAlertFrame"]:CreateBackdrop('Transparent')
	_G["GarrisonShipMissionAlertFrame"].backdrop:Style('Outside')
	
	_G["GarrisonShipFollowerAlertFrame"]:StripTextures()
	_G["GarrisonShipFollowerAlertFrame"]:CreateBackdrop('Transparent')
	_G["GarrisonShipFollowerAlertFrame"].backdrop:Style('Outside')
	
	_G["GarrisonRandomMissionAlertFrame"]:StripTextures()
	_G["GarrisonRandomMissionAlertFrame"]:CreateBackdrop('Transparent')
	_G["GarrisonRandomMissionAlertFrame"].backdrop:Style('Outside')]]
end

function BUIS:AlertFrame_SetAchievementAnchors()
	if ( _G["AchievementAlertFrame1"] ) then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i];
			if ( frame and frame:IsShown() ) then
				if frame.backdrop then
					frame.backdrop:Style('Outside')
				end
			end
		end
	end
end

-- Garrison Style
local fRecruits = {}
local function styleGarrison()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.garrison ~= true then return end
	if (not _G["GarrisonMissionFrame"]) then LoadAddOn("Blizzard_GarrisonUI") end
	
	_G["GarrisonMissionFrame"].backdrop:Style('Outside')
	_G["GarrisonLandingPage"].backdrop:Style('Outside')
	_G["GarrisonBuildingFrame"].backdrop:Style('Outside')
	_G["GarrisonCapacitiveDisplayFrame"].backdrop:Style('Outside')
	_G["GarrisonBuildingFrame"].BuildingLevelTooltip:Style('Outside')
	_G["GarrisonFollowerAbilityTooltip"]:Style('Outside')
	_G["GarrisonMissionMechanicTooltip"]:StripTextures()
	_G["GarrisonMissionMechanicTooltip"]:CreateBackdrop('Transparent')
	_G["GarrisonMissionMechanicTooltip"].backdrop:Style('Outside')
	_G["GarrisonMissionMechanicFollowerCounterTooltip"]:StripTextures()
	_G["GarrisonMissionMechanicFollowerCounterTooltip"]:CreateBackdrop('Transparent')
	_G["GarrisonMissionMechanicFollowerCounterTooltip"].backdrop:Style('Outside')
	_G["FloatingGarrisonFollowerTooltip"]:Style('Outside')
	_G["GarrisonFollowerTooltip"]:Style('Outside')
	
	-- ShipYard
	_G["GarrisonShipyardFrame"].backdrop:Style('Outside')
	-- Tooltips
	_G["GarrisonShipyardMapMissionTooltip"]:Style('Outside')
	_G["GarrisonBonusAreaTooltip"]:StripTextures()
	_G["GarrisonBonusAreaTooltip"]:CreateBackdrop('Transparent')
	_G["GarrisonBonusAreaTooltip"].backdrop:Style('Outside')
	_G["GarrisonMissionMechanicFollowerCounterTooltip"]:Style('Outside')
	_G["GarrisonMissionMechanicTooltip"]:Style('Outside')
	_G["FloatingGarrisonShipyardFollowerTooltip"]:Style('Outside')
	_G["GarrisonShipyardFollowerTooltip"]:Style('Outside')
	
	-- Garrison Monument
	_G["GarrisonMonumentFrame"]:StripTextures()
	_G["GarrisonMonumentFrame"]:CreateBackdrop('Transparent')
	_G["GarrisonMonumentFrame"]:Style('Small')
	_G["GarrisonMonumentFrame"]:ClearAllPoints()
	_G["GarrisonMonumentFrame"]:Point('CENTER', E.UIParent, 'CENTER', 0, -200)
	_G["GarrisonMonumentFrame"]:Height(70)
	_G["GarrisonMonumentFrame"].RightBtn:Size(25, 25)
	_G["GarrisonMonumentFrame"].LeftBtn:Size(25, 25)
	
	-- Follower recruiting (available at the Inn)
	_G["GarrisonRecruiterFrame"].backdrop:Style('Outside')
	S:HandleDropDownBox(_G["GarrisonRecruiterFramePickThreatDropDown"])
	local rBtn = _G["GarrisonRecruiterFrame"].Pick.ChooseRecruits
	rBtn:ClearAllPoints()
	rBtn:Point('BOTTOM', _G["GarrisonRecruiterFrame"].backdrop, 'BOTTOM', 0, 30)
	S:HandleButton(rBtn)
	
	_G["GarrisonRecruitSelectFrame"]:StripTextures()
	_G["GarrisonRecruitSelectFrame"]:CreateBackdrop('Transparent')
	_G["GarrisonRecruitSelectFrame"].backdrop:Style('Outside')
	S:HandleCloseButton(_G["GarrisonRecruitSelectFrame"].CloseButton)
	S:HandleEditBox(_G["GarrisonRecruitSelectFrame"].FollowerList.SearchBox)

	_G["GarrisonRecruitSelectFrame"].FollowerList:StripTextures()
	S:HandleScrollBar(_G["GarrisonRecruitSelectFrameListScrollFrameScrollBar"])
	_G["GarrisonRecruitSelectFrame"].FollowerSelection:StripTextures()

	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1:CreateBackdrop()
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1:ClearAllPoints()
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1:Point('LEFT', _G["GarrisonRecruitSelectFrame"].FollowerSelection, 'LEFT', 6, 0)
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2:CreateBackdrop()
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2:ClearAllPoints()
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2:Point('LEFT', _G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1, 'RIGHT', 6, 0)
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3:CreateBackdrop()
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3:ClearAllPoints()
	_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3:Point('LEFT', _G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2, 'RIGHT', 6, 0)

	for i = 1, 3 do
		fRecruits[i] = CreateFrame('Frame', nil, E.UIParent)
		fRecruits[i]:SetTemplate('Default', true)
		fRecruits[i]:Size(190, 60)
		if i == 1 then
			fRecruits[i]:SetParent(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1)
			fRecruits[i]:Point('TOP', _G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1.backdrop, 'TOP')
			fRecruits[i]:SetFrameLevel(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1:GetFrameLevel())
			_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1.Class:Size(60, 58)
		elseif i == 2 then
			fRecruits[i]:SetParent(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2)
			fRecruits[i]:Point('TOP', _G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2.backdrop, 'TOP')
			fRecruits[i]:SetFrameLevel(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2:GetFrameLevel())
			_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2.Class:Size(60, 58)
		elseif i == 3 then
			fRecruits[i]:SetParent(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3)
			fRecruits[i]:Point('TOP', _G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3.backdrop, 'TOP')
			fRecruits[i]:SetFrameLevel(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3:GetFrameLevel())
			_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3.Class:Size(60, 58)
		end
	end
	S:HandleButton(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit1.HireRecruits)
	S:HandleButton(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit2.HireRecruits)
	S:HandleButton(_G["GarrisonRecruitSelectFrame"].FollowerSelection.Recruit3.HireRecruits)
end

-- Objective Tracker Button
local function MinimizeButton_OnClick(self)
	local text = self.Text
	local symbol = text:GetText()
	
	if (symbol and symbol == '-') then
		text:SetText('+')
	else
		text:SetText('-')
	end
end

local function SkinObjeciveTracker()
	if not E.db.benikuiSkins.variousSkins.objectiveTracker then return end
	
	local button = _G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton
	S:HandleButton(button)
	button:Size(16, 12)
	button.Text = button:CreateFontString(nil, 'OVERLAY')
	button.Text:FontTemplate(E['media'].buiVisitor, 10)
	button.Text:Point('CENTER', button, 'CENTER', 0, 1)
	button.Text:SetJustifyH('CENTER')
	button.Text:SetText('-')
	button:HookScript('OnClick', MinimizeButton_OnClick)
	
	-- Remove textures from Objective tracker
	local otFrames = {_G["ObjectiveTrackerBlocksFrame"].QuestHeader, _G["ObjectiveTrackerBlocksFrame"].AchievementHeader, _G["ObjectiveTrackerBlocksFrame"].ScenarioHeader, _G["BONUS_OBJECTIVE_TRACKER_MODULE"].Header}
	for _, frame in pairs(otFrames) do
		if frame then
			frame:StripTextures()
		end
	end
end

function BUIS:BenikUISkins()

	-- Garrison Style
	styleGarrison()

	-- Objective Tracker Button
	SkinObjeciveTracker()
	
	if E.db.benikui.general.benikuiStyle ~= true then return end 
	
	-- Blizzard Styles
	styleFreeBlizzardFrames()
	
	-- SpellBook tabs
	styleSpellbook()
	
	-- Alert Frames
	styleAlertFrames()
	
	-- Style Changes
	if _G["DressUpFrame"].style then
		_G["DressUpFrame"].style:Point('TOPLEFT', _G["DressUpFrame"], 'TOPLEFT', 6, 4)
		_G["DressUpFrame"].style:Point('BOTTOMRIGHT', _G["DressUpFrame"], 'TOPRIGHT', -32, -1)
	end

	if _G["MerchantFrame"].style then
		_G["MerchantFrame"].style:Point('TOPLEFT', _G["MerchantFrame"], 'TOPLEFT', 6, 4)
		_G["MerchantFrame"].style:Point('BOTTOMRIGHT', _G["MerchantFrame"], 'TOPRIGHT', 2, -1)
	end

	-- Map styling fix
	local function FixMapStyle()
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true then return end
		if not _G["WorldMapFrame"].BorderFrame.backdrop.style then
			_G["WorldMapFrame"].BorderFrame.backdrop:Style('Outside')
		end
		
		if not _G["WorldMapTooltip"].style then
			_G["WorldMapTooltip"]:Style('Outside')
		end

		_G["QuestMapFrame"].QuestsFrame.StoryTooltip:SetTemplate('Transparent')
		if not _G["QuestMapFrame"].QuestsFrame.StoryTooltip.style then
			_G["QuestMapFrame"].QuestsFrame.StoryTooltip:Style('Outside')
		end
	end
	
	_G["WorldMapFrame"]:HookScript('OnShow', FixMapStyle)
	hooksecurefunc('WorldMap_ToggleSizeUp', FixMapStyle)

	-- AddOn Styles
	if IsAddOnLoaded('ElvUI_LocLite') and E.db.benikuiSkins.elvuiAddons.loclite then
		local framestoskin = {_G["LocationLitePanel"], _G["XCoordsLite"], _G["YCoordsLite"]}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end
	
	if IsAddOnLoaded('ElvUI_LocPlus') and E.db.benikuiSkins.elvuiAddons.locplus then
		local framestoskin = {_G["LeftCoordDtPanel"], _G["RightCoordDtPanel"], _G["LocationPlusPanel"], _G["XCoordsPanel"], _G["YCoordsPanel"]}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end
	
	if IsAddOnLoaded('ElvUI_SLE') and E.db.benikuiSkins.elvuiAddons.sle then
		local sleFrames = {_G["BottomBG"], _G["LeftBG"], _G["RightBG"], _G["ActionBG"], _G["DP_1"], _G["DP_2"], _G["Top_Center"], _G["DP_3"], _G["DP_4"], _G["DP_5"], _G["Bottom_Panel"], _G["DP_6"], _G["Main_Flares"], _G["Mark_Menu"], _G["SquareMinimapButtonBar"]}
		for _, frame in pairs(sleFrames) do
			if frame then
				frame:Style('Outside')
			end
		end
	end
	
	if IsAddOnLoaded('SquareMinimapButtons') and E.db.benikuiSkins.elvuiAddons.smb then
		local smbFrame = _G["SquareMinimapButtonBar"]
		if smbFrame then
			smbFrame:Style('Outside')
		end
	end
	
	if IsAddOnLoaded('ElvUI_Enhanced') and E.db.benikuiSkins.elvuiAddons.enh then
		if _G["MinimapButtonBar"] then
			_G["MinimapButtonBar"].backdrop:Style('Outside')
		end
		
		if _G["RaidMarkerBar"].backdrop then
			_G["RaidMarkerBar"].backdrop:Style('Outside')
		end
	end
	
	if IsAddOnLoaded('ElvUI_DTBars2') and E.db.benikuiSkins.elvuiAddons.dtb2 then
		for panelname, data in pairs(E.global.dtbars) do
			if panelname then
				_G[panelname]:Style('Outside')
			end
		end
	end
end

function BUIS:Initialize()
	self:RegisterEvent('ADDON_LOADED', 'BlizzardUI_LOD_Skins')
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'BenikUISkins')
	--self:SecureHook('AlertFrame_SetAchievementAnchors')
end

E:RegisterModule(BUIS:GetName())
