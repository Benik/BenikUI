local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUIS = E:NewModule('BuiSkins', 'AceHook-3.0', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local S = E:GetModule('Skins');

local SPACING = (E.PixelMode and 1 or 2)

local FreeBlizzFrames = {
	AddFriendFrame,
	AddonList,
	AudioOptionsFrame,
	BNToastFrame,
	ChatConfigFrame,
	ClassTrainerFrame,
	ColorPickerFrame,
	ConsolidatedBuffsTooltip,
	DressUpFrame,
	DropDownList1,
	DropDownList2,
	ElvUI_StaticPopup1,
	ElvUI_StaticPopup2,
	ElvUI_StaticPopup3,
	FloatingBattlePetTooltip,
	FriendsFrame,
	GameMenuFrame,
	GearManagerDialogPopup,
	GossipFrame,
	GuildRegistrarFrame,
	InterfaceOptionsFrame,
	ItemRefTooltip,
	ItemTextFrame,
	LFGDungeonReadyPopup,
	LFGDungeonReadyDialog,
	LFGDungeonReadyStatus,
	LFGListApplicationDialog,
	LFGListInviteDialog,
	LootFrame,
	MailFrame,
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
	{'Blizzard_AuctionUI', 'AuctionFrame', 'auctionhouse'},
	{'Blizzard_BarbershopUI', 'BarberShopFrame', 'barber'},
	{'Blizzard_BattlefieldMinimap', 'BattlefieldMinimap', 'bgmap'},
	{'Blizzard_BindingUI', 'KeyBindingFrame', 'binding'},
	{'Blizzard_BlackMarketUI', 'BlackMarketFrame', 'bmah'},
	{'Blizzard_Calendar', 'CalendarFrame', 'calendar'}, -- issues non pixel perfect
	{'Blizzard_Calendar', 'CalendarViewEventFrame', 'calendar'},
	{'Blizzard_Calendar', 'CalendarViewHolidayFrame', 'calendar'},
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

local classColor = RAID_CLASS_COLORS[E.myclass]

local color = { r = 1, g = 0.5, b = 0 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

function BUI:StyleBlizzard(parent, ...)
	local frame = CreateFrame('Frame', parent..'Decor', E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', SPACING, (E.PixelMode and 3 or 5))
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', -SPACING, (E.PixelMode and 0 or 3))
	
	frame.backdrop.color = frame.backdrop:CreateTexture(nil, 'OVERLAY')
	frame.backdrop.color:SetInside()
	frame.backdrop.color:SetTexture(E['media'].BuiFlat)
	if E.db.bui.StyleColor == 1 then
		frame.backdrop.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
	elseif E.db.bui.StyleColor == 2 then
		frame.backdrop.color:SetVertexColor(unpackColor(E.db.bui.customStyleColor))
	elseif E.db.bui.StyleColor == 3 then
		frame.backdrop.color:SetVertexColor(unpackColor(E.db.general.valuecolor))
	else
		frame.backdrop.color:SetVertexColor(unpackColor(E.db.general.backdropcolor))
	end
end

function BUIS:BlizzardUI_LOD_Skins(event, addon)
	if E.private.skins.blizzard.enable ~= true or E.db.bui.buiStyle ~= true then return end
	for i, v in ipairs(BlizzUiFrames) do
		local blizzAddon, blizzFrame, elvoption = unpack( v )
		if (event == 'ADDON_LOADED' and addon == blizzAddon) then
			if E.private.skins.blizzard[elvoption] ~= true then return end
			if blizzFrame then
				BUI:StyleBlizzard(blizzFrame)

				-- Fixes/Style tabs, buttons, etc
				if addon == 'Blizzard_AchievementUI' then
					if AchievementFrameDecor then
						AchievementFrameDecor:ClearAllPoints()
						AchievementFrameDecor:Point('TOPLEFT', AchievementFrame, 'TOPLEFT', (E.PixelMode and 1 or 2), (E.PixelMode and 9 or 11))
						AchievementFrameDecor:Point('BOTTOMRIGHT', AchievementFrame, 'TOPRIGHT', -(E.PixelMode and 1 or 2), (E.PixelMode and 6 or 9))			
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
					local GuildFrames = {GuildMemberDetailFrame, GuildTextEditFrame, GuildLogFrame}
					for _, frame in pairs(GuildFrames) do
						if frame and not frame.style then
							frame:Style('Outside')
						end
					end
				end
				
				if addon == 'Blizzard_VoidStorageUI' then
					for i = 1, 2 do
						local tab = VoidStorageFrame["Page"..i]
						if not tab.style then
							tab:Style('Inside')
							tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
							tab:GetNormalTexture():SetInside()
						end						
					end
				end
				
				if addon == 'Blizzard_BarbershopUI' then
					BarberShopAltFormFrame.backdrop:Style('Outside')
				end
				
			end
		end
	end
	
	if addon == 'Blizzard_EncounterJournal' then
		if E.private.skins.blizzard.encounterjournal == true then
			if not EncounterJournal.style then
				EncounterJournal:Style('Small')
			end
			EncounterJournalTooltip:Style('Outside')
		end
	end
	
	if addon == 'Blizzard_QuestChoice' and E.private.skins.blizzard.questChoice then
		if not QuestChoiceFrame.style then
			QuestChoiceFrame:Style('Small')
		end
	end
	
	if addon == 'Blizzard_AuctionUI' then
		if not WowTokenGameTimeTutorial.style then
			WowTokenGameTimeTutorial:Style('Small')
		end
	end

	if E.private.skins.blizzard.timemanager == true then
		if not TimeManagerFrame.style then
			TimeManagerFrame:Style('Outside')
		end
		
		if not StopwatchFrame.backdrop.style then
			StopwatchFrame.backdrop:Style('Outside')
		end
	end
end

-- Blizzard Styles
local function styleFreeBlizzardFrames()
	if E.private.skins.blizzard.enable ~= true or E.db.bui.buiStyle ~= true then return end
	
	for _, frame in pairs(FreeBlizzFrames) do
		if frame and not frame.style then
			frame:Style('Skin')
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
				tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
			end
		end
	end)
end

-- SpellBook Core abilities tabs
local function styleCoreAbilities()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true then return end
	hooksecurefunc('SpellBook_GetCoreAbilitySpecTab', function(index)
		local button = SpellBookCoreAbilitiesFrame.SpecTabs[index]
		if not button.style then
			button:Style('Inside')
			button:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
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

	hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", function(anchorFrame)
		for i = 1, DUNGEON_COMPLETION_MAX_REWARDS do
			local frame = _G["DungeonCompletionAlertFrame"..i]
			if frame then
				frame.backdrop:Style('Outside')
			end
		end
	end)
	
	hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", function(anchorFrame)
		local frame = GuildChallengeAlertFrame
		if frame then
			frame.backdrop:Style('Outside')
		end
	end)

	hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function(anchorFrame)
		local frame = ChallengeModeAlertFrame1
		if frame then
			frame.backdrop:Style('Outside')
		end
	end)

	hooksecurefunc("AlertFrame_SetScenarioAnchors", function(anchorFrame)
		local frame = ScenarioAlertFrame1
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
	end)

	BonusRollFrame:Style('Outside')
	BonusRollMoneyWonFrame.backdrop:Style('Outside')
	BonusRollLootWonFrame.backdrop:Style('Outside')
	
	GarrisonBuildingAlertFrame.backdrop:Style('Outside')
	GarrisonMissionAlertFrame.backdrop:Style('Outside')
	GarrisonFollowerAlertFrame.backdrop:Style('Outside')
	GarrisonShipMissionAlertFrame:StripTextures()
	GarrisonShipMissionAlertFrame:CreateBackdrop('Transparent')
	GarrisonShipMissionAlertFrame.backdrop:Style('Outside')
	GarrisonShipFollowerAlertFrame:StripTextures()
	GarrisonShipFollowerAlertFrame:CreateBackdrop('Transparent')
	GarrisonShipFollowerAlertFrame.backdrop:Style('Outside')
end

function BUIS:AlertFrame_SetAchievementAnchors()
	if ( AchievementAlertFrame1 ) then
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
	if (not GarrisonMissionFrame) then LoadAddOn("Blizzard_GarrisonUI") end
	
	GarrisonMissionFrame.backdrop:Style('Outside')
	GarrisonLandingPage.backdrop:Style('Outside')
	GarrisonBuildingFrame.backdrop:Style('Outside')
	GarrisonCapacitiveDisplayFrame.backdrop:Style('Outside')
	GarrisonBuildingFrame.BuildingLevelTooltip:Style('Outside')
	GarrisonFollowerAbilityTooltip:Style('Outside')
	GarrisonMissionMechanicTooltip:StripTextures()
	GarrisonMissionMechanicTooltip:CreateBackdrop('Transparent')	
	GarrisonMissionMechanicTooltip.backdrop:Style('Outside')
	GarrisonMissionMechanicFollowerCounterTooltip:StripTextures()
	GarrisonMissionMechanicFollowerCounterTooltip:CreateBackdrop('Transparent')
	GarrisonMissionMechanicFollowerCounterTooltip.backdrop:Style('Outside')
	FloatingGarrisonFollowerTooltip:Style('Outside')
	GarrisonFollowerTooltip:Style('Outside')
	
	-- ShipYard
	GarrisonShipyardFrame.backdrop:Style('Outside')
	-- Tooltips
	GarrisonShipyardMapMissionTooltip:Style('Outside')
	GarrisonBonusAreaTooltip:StripTextures()
	GarrisonBonusAreaTooltip:CreateBackdrop('Transparent')
	GarrisonBonusAreaTooltip.backdrop:Style('Outside')
	GarrisonMissionMechanicFollowerCounterTooltip:Style('Outside')
	GarrisonMissionMechanicTooltip:Style('Outside')
	FloatingGarrisonShipyardFollowerTooltip:Style('Outside')
	GarrisonShipyardFollowerTooltip:Style('Outside')
	
	-- Garrison Monument
	GarrisonMonumentFrame:StripTextures()
	GarrisonMonumentFrame:CreateBackdrop('Transparent')
	GarrisonMonumentFrame:Style('Small')
	GarrisonMonumentFrame:ClearAllPoints()
	GarrisonMonumentFrame:Point('CENTER', E.UIParent, 'CENTER', 0, -200)
	GarrisonMonumentFrame:Height(70)
	GarrisonMonumentFrame.RightBtn:Size(25, 25)
	GarrisonMonumentFrame.LeftBtn:Size(25, 25)
	
	-- Follower recruiting (available at the Inn)
	GarrisonRecruiterFrame.backdrop:Style('Outside')
	S:HandleDropDownBox(GarrisonRecruiterFramePickThreatDropDown)
	local rBtn = GarrisonRecruiterFrame.Pick.ChooseRecruits
	rBtn:ClearAllPoints()
	rBtn:Point('BOTTOM', GarrisonRecruiterFrame.backdrop, 'BOTTOM', 0, 30)
	S:HandleButton(rBtn)
	
	GarrisonRecruitSelectFrame:StripTextures()
	GarrisonRecruitSelectFrame:CreateBackdrop('Transparent')
	GarrisonRecruitSelectFrame.backdrop:Style('Outside')
	S:HandleCloseButton(GarrisonRecruitSelectFrame.CloseButton)
	S:HandleEditBox(GarrisonRecruitSelectFrame.FollowerList.SearchBox)

	GarrisonRecruitSelectFrame.FollowerList:StripTextures()
	S:HandleScrollBar(GarrisonRecruitSelectFrameListScrollFrameScrollBar)
	GarrisonRecruitSelectFrame.FollowerSelection:StripTextures()

	GarrisonRecruitSelectFrame.FollowerSelection.Recruit1:CreateBackdrop()
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit1:ClearAllPoints()
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit1:Point('LEFT', GarrisonRecruitSelectFrame.FollowerSelection, 'LEFT', 6, 0)
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit2:CreateBackdrop()
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit2:ClearAllPoints()
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit2:Point('LEFT', GarrisonRecruitSelectFrame.FollowerSelection.Recruit1, 'RIGHT', 6, 0)
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit3:CreateBackdrop()
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit3:ClearAllPoints()
	GarrisonRecruitSelectFrame.FollowerSelection.Recruit3:Point('LEFT', GarrisonRecruitSelectFrame.FollowerSelection.Recruit2, 'RIGHT', 6, 0)

	for i = 1, 3 do
		fRecruits[i] = CreateFrame('Frame', nil, E.UIParent)
		fRecruits[i]:SetTemplate('Default', true)
		fRecruits[i]:Size(190, 60)
		if i == 1 then
			fRecruits[i]:SetParent(GarrisonRecruitSelectFrame.FollowerSelection.Recruit1)
			fRecruits[i]:Point('TOP', GarrisonRecruitSelectFrame.FollowerSelection.Recruit1.backdrop, 'TOP')
			fRecruits[i]:SetFrameLevel(GarrisonRecruitSelectFrame.FollowerSelection.Recruit1:GetFrameLevel())
			GarrisonRecruitSelectFrame.FollowerSelection.Recruit1.Class:Size(60, 58)
		elseif i == 2 then
			fRecruits[i]:SetParent(GarrisonRecruitSelectFrame.FollowerSelection.Recruit2)
			fRecruits[i]:Point('TOP', GarrisonRecruitSelectFrame.FollowerSelection.Recruit2.backdrop, 'TOP')
			fRecruits[i]:SetFrameLevel(GarrisonRecruitSelectFrame.FollowerSelection.Recruit2:GetFrameLevel())
			GarrisonRecruitSelectFrame.FollowerSelection.Recruit2.Class:Size(60, 58)		
		elseif i == 3 then
			fRecruits[i]:SetParent(GarrisonRecruitSelectFrame.FollowerSelection.Recruit3)
			fRecruits[i]:Point('TOP', GarrisonRecruitSelectFrame.FollowerSelection.Recruit3.backdrop, 'TOP')
			fRecruits[i]:SetFrameLevel(GarrisonRecruitSelectFrame.FollowerSelection.Recruit3:GetFrameLevel())
			GarrisonRecruitSelectFrame.FollowerSelection.Recruit3.Class:Size(60, 58)		
		end
	end
	S:HandleButton(GarrisonRecruitSelectFrame.FollowerSelection.Recruit1.HireRecruits)
	S:HandleButton(GarrisonRecruitSelectFrame.FollowerSelection.Recruit2.HireRecruits)
	S:HandleButton(GarrisonRecruitSelectFrame.FollowerSelection.Recruit3.HireRecruits)
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
	if not E.db.buiVariousSkins.objectiveTracker then return end
	
	local button = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	S:HandleButton(button)
	button:Size(16, 12)
	button.Text = button:CreateFontString(nil, 'OVERLAY')
	button.Text:FontTemplate(nil, 11)
	button.Text:Point('CENTER', button, 'CENTER')
	button.Text:SetJustifyH('CENTER')
	button.Text:SetText('-')
	button:HookScript('OnClick', MinimizeButton_OnClick)
	
	-- Remove textures from Objective tracker
	local otFrames = {ObjectiveTrackerBlocksFrame.QuestHeader, ObjectiveTrackerBlocksFrame.AchievementHeader, ObjectiveTrackerBlocksFrame.ScenarioHeader, BONUS_OBJECTIVE_TRACKER_MODULE.Header}
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
	
	if E.db.bui.buiStyle ~= true then return end 
	
	-- Blizzard Styles
	styleFreeBlizzardFrames()
	
	-- SpellBook tabs
	styleSpellbook()
	
	-- SpellBook Core abilities tabs
	styleCoreAbilities()
	
	-- Alert Frames
	styleAlertFrames()
	
	-- Style Changes
	if DressUpFrame.style then
		DressUpFrame.style:Point('TOPLEFT', DressUpFrame, 'TOPLEFT', 6, 5)
		DressUpFrame.style:Point('BOTTOMRIGHT', DressUpFrame, 'TOPRIGHT', -32, -1)
	end

	if MerchantFrame.style then
		MerchantFrame.style:Point('TOPLEFT', MerchantFrame, 'TOPLEFT', 6, 5)
		MerchantFrame.style:Point('BOTTOMRIGHT', MerchantFrame, 'TOPRIGHT', 2, -1)
	end

	-- Map styling fix
	local function FixMapStyle()
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true then return end
		if not WorldMapFrame.BorderFrame.backdrop.style then
			WorldMapFrame.BorderFrame.backdrop:Style('Outside')
		end
		
		if not WorldMapTooltip.style then
			WorldMapTooltip:Style('Outside')
		end

		QuestMapFrame.QuestsFrame.StoryTooltip:SetTemplate('Transparent')
		if not QuestMapFrame.QuestsFrame.StoryTooltip.style then
			QuestMapFrame.QuestsFrame.StoryTooltip:Style('Outside')
		end
	end
	
	WorldMapFrame:HookScript('OnShow', FixMapStyle)
	hooksecurefunc('WorldMap_ToggleSizeUp', FixMapStyle)

	-- AddOn Styles
	if IsAddOnLoaded('ElvUI_LocLite') and E.db.elvuiaddons.loclite then
		local framestoskin = {LocationLitePanel, XCoordsLite, YCoordsLite}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end
	
	if IsAddOnLoaded('ElvUI_LocPlus') and E.db.elvuiaddons.locplus then
		local framestoskin = {LeftCoordDtPanel, RightCoordDtPanel, LocationPlusPanel, XCoordsPanel, YCoordsPanel}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end
	
	if IsAddOnLoaded('ElvUI_SLE') and E.db.elvuiaddons.sle then
		local sleFrames = {BottomBG, LeftBG, RightBG, ActionBG, DP_1, DP_2, Top_Center, DP_3, DP_4, DP_5, Bottom_Panel, DP_6, Main_Flares, Mark_Menu, SquareMinimapButtonBar}		
		for _, frame in pairs(sleFrames) do
			if frame then
				frame:Style('Outside')
			end
		end
	end
	
	if IsAddOnLoaded('SquareMinimapButtons') and E.db.elvuiaddons.smb then
		local smbFrame = SquareMinimapButtonBar
		if smbFrame then
			smbFrame:Style('Outside')
		end
	end
	
	if IsAddOnLoaded('ElvUI_Enhanced') and E.db.elvuiaddons.enh then
		if MinimapButtonBar then
			MinimapButtonBar.backdrop:Style('Outside')
		end
		
		if RaidMarkerBar.backdrop then
			RaidMarkerBar.backdrop:Style('Outside')
		end
	end
	
	if IsAddOnLoaded('ElvUI_DTBars2') and E.db.elvuiaddons.dtb2 then
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
	self:SecureHook('AlertFrame_SetAchievementAnchors')
end

E:RegisterModule(BUIS:GetName())
