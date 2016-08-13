local E, L, V, P, G = unpack(ElvUI);
local BUIS = E:NewModule('BuiSkins', 'AceHook-3.0', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local S = E:GetModule('Skins');

local _G = _G
local pairs, unpack = pairs, unpack
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn

-- GLOBALS: hooksecurefunc

function BUIS:BlizzardUI_LOD_Skins(event, addon)
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end

	if (event == 'ADDON_LOADED') then
		if addon == 'Blizzard_AchievementUI' and E.private.skins.blizzard.achievement == true then
			local frame = _G["AchievementFrame"]
			frame:Style('Outside')
			if frame.style then
				frame.style:ClearAllPoints()
				frame.style:Point('TOPLEFT', frame, 'TOPLEFT', 0, (E.PixelMode and 7 or 9))
				frame.style:Point('BOTTOMRIGHT', frame, 'TOPRIGHT', 0, (E.PixelMode and 2 or 4))
			end
		end

		if addon == 'Blizzard_ArchaeologyUI' and E.private.skins.blizzard.archaeology == true then
			local frame = _G["ArchaeologyFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_ArtifactUI' and E.private.skins.blizzard.artifact == true then
			local frame = _G["ArtifactFrame"]
			frame:Style('Small')
			frame.CloseButton:ClearAllPoints()
			frame.CloseButton:SetPoint("TOPRIGHT", ArtifactFrame, "TOPRIGHT", 2, 2)
		end

		if addon == 'Blizzard_AuctionUI' and E.private.skins.blizzard.auctionhouse == true then
			local frame = _G["AuctionFrame"]
			frame:Style('Outside')
			if not _G["AuctionProgressFrame"].style then
				_G["AuctionProgressFrame"]:Style('Outside')
			end
			if not _G["WowTokenGameTimeTutorial"].style then
				_G["WowTokenGameTimeTutorial"]:Style('Small')
			end
		end
		
		if addon == 'Blizzard_BarbershopUI' and E.private.skins.blizzard.barber == true then
			local frame = _G["BarberShopFrame"]
			frame:Style('Outside')
			_G["BarberShopAltFormFrame"]:Style('Outside')
		end
		
		if addon == 'Blizzard_BattlefieldMinimap' and E.private.skins.blizzard.bgmap == true then
			local frame = _G["BattlefieldMinimap"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_BindingUI' and E.private.skins.blizzard.binding == true then
			local frame = _G["KeyBindingFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_BlackMarketUI' and E.private.skins.blizzard.bmah == true then
			local frame = _G["BlackMarketFrame"]
			frame:Style('Outside')
		end

		if addon == 'Blizzard_Calendar' and E.private.skins.blizzard.calendar == true then
			_G["CalendarFrame"]:Style('Outside')
			_G["CalendarViewEventFrame"]:Style('Outside')
			_G["CalendarViewHolidayFrame"]:Style('Outside')
			_G["CalendarCreateEventFrame"]:Style('Outside')
			_G["CalendarContextMenu"]:Style('Outside')
		end

		if addon == 'Blizzard_Collections' and E.private.skins.blizzard.mounts == true then
			local frame = _G["CollectionsJournal"]
			frame:Style('Outside')
		end

		if addon == 'Blizzard_DeathRecap' and E.private.skins.blizzard.deathRecap == true then
			local frame = _G["DeathRecapFrame"]
			frame:Style('Outside')
		end

		if addon == 'Blizzard_GuildBankUI' and E.private.skins.blizzard.gbank == true then
			local frame = _G["GuildBankFrame"]
			frame:Style('Outside')
			for i = 1, 8 do
				local button = _G['GuildBankTab'..i..'Button']
				local texture = _G['GuildBankTab'..i..'ButtonIconTexture']
				if not button.style then
					button:Style('Inside')
					texture:SetTexCoord(unpack(BUI.TexCoords))
				end
			end
		end

		if addon == 'Blizzard_GuildUI' and E.private.skins.blizzard.guild == true then
			local frame = _G["GuildFrame"]
			frame:Style('Outside')
			local GuildFrames = {_G["GuildMemberDetailFrame"], _G["GuildTextEditFrame"], _G["GuildLogFrame"], _G["GuildNewsFiltersFrame"]}
			for _, frame in pairs(GuildFrames) do
				if frame and not frame.style then
					frame:Style('Outside')
				end
			end
		end

		if addon == 'Blizzard_GuildControlUI' and E.private.skins.blizzard.guildcontrol == true then
			local frame = _G["GuildControlUI"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_InspectUI' and E.private.skins.blizzard.inspect == true then
			local frame = _G["InspectFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_ItemAlterationUI' and E.private.skins.blizzard.transmogrify == true then
			local frame = _G["TransmogrifyFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_ItemUpgradeUI' and E.private.skins.blizzard.itemUpgrade == true then
			local frame = _G["ItemUpgradeFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_ItemSocketingUI' and E.private.skins.blizzard.socket == true then
			local frame = _G["ItemSocketingFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_LookingForGuildUI' and E.private.skins.blizzard.lfguild == true then
			local frame = _G["LookingForGuildFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_MacroUI' and E.private.skins.blizzard.macro == true then
			local frame = _G["MacroFrame"]
			frame:Style('Outside')
		end

		if addon == 'Blizzard_TalentUI' and E.private.skins.blizzard.talent == true then
			local frame = _G["PlayerTalentFrame"]
			frame:Style('Outside')
			for i = 1, 2 do
				local tab = _G['PlayerSpecTab'..i]
				if not tab.style then
					tab:Style('Inside')
					tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
					tab:GetNormalTexture():SetInside()
				end
			end
		end

		if addon == 'Blizzard_TradeSkillUI' and E.private.skins.blizzard.trade == true then
			local frame = _G["TradeSkillFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_TrainerUI' and E.private.skins.blizzard.trainer == true then
			local frame = _G["ClassTrainerFrame"]
			frame:Style('Outside')
		end
		
		if addon == 'Blizzard_VoidStorageUI' and E.private.skins.blizzard.voidstorage == true then
			local frame = _G["VoidStorageFrame"]
			frame:Style('Outside')
			for i = 1, 2 do
				local tab = _G["VoidStorageFrame"]["Page"..i]
				if not tab.style then
					tab:Style('Inside')
					tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
					tab:GetNormalTexture():SetInside()
				end
			end
		end
	end
	
	if addon == 'Blizzard_EncounterJournal' and E.private.skins.blizzard.encounterjournal == true then
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
	
	-- The Style bar is in the wrong place, we must have a deeper look at this.
	if addon == 'Blizzard_TalkingHeadUI' and E.private.skins.blizzard.talkinghead == true then
		local frame = _G["TalkingHeadFrame"]
		frame:SetTemplate('Transparent')
		frame:Style('Outside')
		if frame.style then
			frame.style:ClearAllPoints()
			frame.style:Point('TOPLEFT', frame, 'TOPLEFT', -(E.PixelMode and 0 or 2), (E.PixelMode and 5 or 7))
			frame.style:Point('BOTTOMRIGHT', frame, 'TOPRIGHT', (E.PixelMode and -1 or 1), (E.PixelMode and 0 or 2))
		end
	end
	
	
	if addon == 'Blizzard_QuestChoice' and E.private.skins.blizzard.questChoice == true then
		if not _G["QuestChoiceFrame"].style then
			_G["QuestChoiceFrame"]:Style('Small')
		end
	end
	
	if addon == 'Blizzard_FlightMap' and E.private.skins.blizzard.taxi == true then
		_G["FlightMapFrame"]:Style('Small')
	end

	if addon == 'Blizzard_TimeManager' and E.private.skins.blizzard.timemanager == true then
		if not _G["TimeManagerFrame"].style then
			_G["TimeManagerFrame"]:Style('Outside')
		end
		
		if not _G["StopwatchFrame"].backdrop.style then
			_G["StopwatchFrame"].backdrop:Style('Outside')
		end
	end

	if addon == 'Blizzard_PVPUI' and E.private.skins.blizzard.pvp == true then
		if not _G["PVPRewardTooltip"].style then
			_G["PVPRewardTooltip"]:Style('Outside')
		end
	end
end

local MAX_STATIC_POPUPS = 4

local tooltips = {
	FriendsTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
}

-- Blizzard Styles
local function styleFreeBlizzardFrames()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	
	ColorPickerFrame:Style('Outside')
	MinimapRightClickMenu:Style('Outside')
	
	for _, frame in pairs(tooltips) do
		if frame and not frame.style then
			frame:Style('Outside')
		end
	end

	if E.private.skins.blizzard.enable ~= true then return end
	
	local db = E.private.skins.blizzard
	
	if db.addonManager then
		AddonList:Style('Outside')
	end
	
	if db.bgscore then
		WorldStateScoreFrame:Style('Outside')
	end
	
	if db.character then
		GearManagerDialogPopup:Style('Outside')
		PaperDollFrame:Style('Outside')
		ReputationDetailFrame:Style('Outside')
		ReputationFrame:Style('Outside')
		TokenFrame:Style('Outside')
		TokenFramePopup:Style('Outside')
	end
	
	if db.dressingroom then
		DressUpFrame:Style('Outside')
	end

	if db.friends then
		AddFriendFrame:Style('Outside')
		ChannelFrameDaughterFrame.backdrop:Style('Outside')
		FriendsFrame:Style('Outside')
		FriendsFriendsFrame.backdrop:Style('Outside')
		RecruitAFriendFrame:Style('Outside')
	end
	
	if db.gossip then
		GossipFrame:Style('Outside')
		ItemTextFrame:Style('Outside')
	end
	
	if db.guildregistrar then
		GuildRegistrarFrame:Style('Outside')
	end

	if db.help then
		HelpFrame.backdrop:Style('Outside')
		HelpFrameHeader.backdrop:Style('Outside')
	end

	if db.lfg then
		LFGDungeonReadyPopup:Style('Outside')
		LFGDungeonReadyDialog:Style('Outside')
		LFGDungeonReadyStatus:Style('Outside')
		LFGListApplicationDialog:Style('Outside')
		LFGListInviteDialog:Style('Outside')
		PVEFrame.backdrop:Style('Outside')
		PVPReadyDialog:Style('Outside')
		RaidBrowserFrame.backdrop:Style('Outside')
	end
	
	if db.loot then
		LootFrame:Style('Outside')
		MasterLooterFrame:Style('Outside')
	end
	
	if db.mail then
		MailFrame:Style('Outside')
		OpenMailFrame:Style('Outside')
	end
	
	if db.merchant then
		MerchantFrame:Style('Outside')
	end
	
	if db.misc then
		AudioOptionsFrame:Style('Outside')
		BNToastFrame:Style('Outside')
		ChatConfigFrame:Style('Outside')
		ChatMenu:Style('Outside')
		DropDownList1:Style('Outside')
		DropDownList2:Style('Outside')
		EmoteMenu:Style('Outside')
		GameMenuFrame:Style('Outside')
		InterfaceOptionsFrame:Style('Outside')
		LanguageMenu:Style('Outside')
		QueueStatusFrame:Style('Outside')
		ReadyCheckFrame:Style('Outside')
		ReadyCheckListenerFrame:Style('Outside')
		SideDressUpFrame:Style('Outside')
		SplashFrame.backdrop:Style('Outside')
		StackSplitFrame:Style('Outside')
		StaticPopup1:Style('Outside')
		StaticPopup2:Style('Outside')
		StaticPopup3:Style('Outside')
		StaticPopup4:Style('Outside')
		TicketStatusFrameButton:Style('Outside')
		VideoOptionsFrame:Style('Outside')
		VoiceMacroMenu:Style('Outside')
		
		for i = 1, MAX_STATIC_POPUPS do
			local frame = _G["ElvUI_StaticPopup"..i]
			frame:Style('Outside')
		end
	end
	
	if db.nonraid then
		RaidInfoFrame:Style('Outside')
	end
	
	if db.petition then
		PetitionFrame:Style('Outside')
	end
	
	if db.petpattle then
		FloatingBattlePetTooltip:Style('Outside')
	end
	
	if db.quest then
		QuestFrame.backdrop:Style('Outside')
		QuestLogPopupDetailFrame:Style('Outside')
		QuestNPCModel.backdrop:Style('Outside')
	end
	
	if db.stable then
		PetStableFrame:Style('Outside')
	end
	
	if db.spellbook then
		SpellBookFrame:Style('Outside')
	end
	
	if db.tabard then
		TabardFrame:Style('Outside')
	end
	
	if db.taxi then
		TaxiFrame.backdrop:Style('Outside')
	end
	
	if db.trade then
		TradeFrame:Style('Outside')
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
				-- This causing a lua error after you enter a portal or using your hearthstone
				-- 3x ElvUI_BenikUI\modules\skins\skins.lua:419: attempt to index a nil value
				--[[tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
				tab:GetNormalTexture():SetInside()]]
			end
		end
	end)
end

-- Alert Frames
local staticAlertFrames = {
	ScenarioLegionInvasionAlertFrame,
	BonusRollMoneyWonFrame,
	BonusRollLootWonFrame,
	GarrisonBuildingAlertFrame,
	GarrisonMissionAlertFrame,
	GarrisonShipMissionAlertFrame,
	GarrisonRandomMissionAlertFrame,
	WorldQuestCompleteAlertFrame,
	GarrisonFollowerAlertFrame,
	LegendaryItemAlertFrame,
}

local function styleAlertFrames()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.alertframes ~= true then return end
	
	local function StyleAchievementAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end
	hooksecurefunc(AchievementAlertSystem, "setUpFunction", StyleAchievementAlert) -- needs testing
	
	local function StyleCriteriaAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
			frame.Icon.Texture.b:Style('Outside')
		end
	end		
	hooksecurefunc(CriteriaAlertSystem, "setUpFunction", StyleCriteriaAlert)
	
	local function StyleDungeonCompletionAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end		
	hooksecurefunc(DungeonCompletionAlertSystem, "setUpFunction", StyleDungeonCompletionAlert)
	
	local function StyleGuildChallengeAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end		
	hooksecurefunc(GuildChallengeAlertSystem, "setUpFunction", StyleGuildChallengeAlert)
	
	local function StyleScenarioAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end		
	hooksecurefunc(ScenarioAlertSystem, "setUpFunction", StyleScenarioAlert)
	
	local function StyleGarrisonFollowerAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end		
	hooksecurefunc(GarrisonFollowerAlertSystem, "setUpFunction", StyleGarrisonFollowerAlert)
	
	local function StyleLegendaryItemAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end	
	hooksecurefunc(LegendaryItemAlertSystem, "setUpFunction", StyleLegendaryItemAlert)
	
	local function StyleLootWonAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end		
	hooksecurefunc(LootAlertSystem, "setUpFunction", StyleLootWonAlert)
	
	local function StyleLootUpgradeAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end	
	hooksecurefunc(LootUpgradeAlertSystem, "setUpFunction", StyleLootUpgradeAlert)
	
	local function StyleMoneyWonAlert(frame)
		if not frame.backdrop.style then
			frame.backdrop:Style('Outside')
		end
	end
	hooksecurefunc(MoneyWonAlertSystem, "setUpFunction", StyleMoneyWonAlert)
	
	for _, frame in pairs(staticAlertFrames) do
		if frame then
			frame.backdrop:Style('Outside')
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
		local sleFrames = {_G["SLE_BG_1"], _G["SLE_BG_2"], _G["SLE_BG_3"], _G["SLE_BG_4"], _G["SLE_DataPanel_1"], _G["SLE_DataPanel_2"], _G["SLE_DataPanel_3"], _G["SLE_DataPanel_4"], _G["SLE_DataPanel_5"], _G["SLE_DataPanel_6"], _G["SLE_DataPanel_7"], _G["SLE_DataPanel_8"], _G["RaidMarkerBar"].backdrop, _G["SLE_SquareMinimapButtonBar"], _G["SLE_LocationPanel"], _G["SLE_LocationPanel_X"], _G["SLE_LocationPanel_Y"], _G["SLE_LocationPanel_RightClickMenu1"], _G["SLE_LocationPanel_RightClickMenu2"]}
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
end

E:RegisterModule(BUIS:GetName())
