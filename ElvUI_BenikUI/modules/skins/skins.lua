local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUIS = E:NewModule('BuiSkins', 'AceHook-3.0', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local S = E:GetModule('Skins');

local SPACING = (E.PixelMode and 1 or 5)

local FreeBlizzFrames = {
	AchievementAlertFrame1, -- test
	AddFriendFrame,
	AddonList,
	AudioOptionsFrame,
	BNToastFrame,
	ChatConfigFrame,
	ClassTrainerFrame,
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
	PetJournalParent,
	PetPaperDollFrame,
	PetStableFrame,
	QuestLogPopupDetailFrame,
	QueueStatusFrame,
	RaidInfoFrame,
	ReadyCheckFrame,
	ReadyCheckListenerFrame,
	RecruitAFriendFrame,
	ReputationDetailFrame,
	ReputationFrame,
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
	TransmogrifyConfirmationPopup,
	VideoOptionsFrame,
	WorldStateScoreScrollFrame, -- check
}

-------------------------------------
-- the style is smaller by 1-2 pixels
-------------------------------------
local FreeBlizzSmallerFrames = {
	ChannelFrameDaughterFrame,
	HelpFrame,
	HelpFrameHeader,
	PVEFrame,
	QuestFrame,
	QuestNPCModel,
	RaidBrowserFrame,
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
	{'Blizzard_Calendar', 'CalendarFrame', 'calendar'},
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
	{'Blizzard_PetJournal', 'PetJournalParent', 'mounts'},
	{'Blizzard_PVPUI', 'PVPUIFrame', 'pvp'},
	{'Blizzard_ItemSocketingUI', 'ItemSocketingFrame', 'socket'},
	{'Blizzard_TalentUI', 'PlayerTalentFrame', 'talent'},
	{'Blizzard_TradeSkillUI', 'TradeSkillFrame', 'trade'},
	{'Blizzard_TrainerUI', 'ClassTrainerFrame', 'trainer'},
	{'Blizzard_VoidStorageUI', 'VoidStorageFrame', 'voidstorage'},
}

function BUI:StyleBlizzard(parent, ...)
	--if E.db.bui.buiStyle ~= true then return end
	local frame = CreateFrame('Frame', parent..'Decor', E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', SPACING, 3)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', -SPACING, 0)
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
						AchievementFrameDecor:Point('TOPLEFT', AchievementFrame, 'TOPLEFT', SPACING, 9)
						AchievementFrameDecor:Point('BOTTOMRIGHT', AchievementFrame, 'TOPRIGHT', -SPACING, 6)			
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

-- Garrison Style
local function styleGarrison()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.garrison ~= true then return end
	if (not GarrisonMissionFrame) then LoadAddOn("Blizzard_GarrisonUI") end
	
	GarrisonMissionFrame.backdrop:Style('Outside')
	GarrisonLandingPage.backdrop:Style('Outside')
	GarrisonBuildingFrame.BuildingLevelTooltip:StripTextures()
	GarrisonBuildingFrame.BuildingLevelTooltip:SetTemplate('Transparent')
	GarrisonBuildingFrame.BuildingLevelTooltip:Style('Outside')
	GarrisonBuildingFrame.backdrop:Style('Outside')
	GarrisonCapacitiveDisplayFrame.backdrop:Style('Outside')
	GarrisonMissionAlertFrame:StripTextures()
	GarrisonMissionAlertFrame:SetTemplate('Transparent')
	GarrisonMissionAlertFrame:Style('Outside')
end

function BUIS:BenikUISkins()

	-- Garrison Style
	styleGarrison()
	
	-- Remove textures from Objective tracker (make an option for it)
	local otFrames = {ObjectiveTrackerBlocksFrame.QuestHeader, ObjectiveTrackerBlocksFrame.AchievementHeader, ObjectiveTrackerBlocksFrame.ScenarioHeader, BONUS_OBJECTIVE_TRACKER_MODULE.Header}
	for _, frame in pairs(otFrames) do
		if frame then
			frame:StripTextures()
		end
	end
	
	if E.db.bui.buiStyle ~= true then return end
	
	-- Blizzard Styles
	styleFreeBlizzardFrames()
	
	-- SpellBook tabs
	styleSpellbook()
	
	-- SpellBook Core abilities tabs
	styleCoreAbilities()
	
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
		QuestMapFrame.QuestsFrame.StoryTooltip:SetTemplate('Transparent')
		QuestMapFrame.QuestsFrame.StoryTooltip:Style('Outside')
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
end

function BUIS:Initialize()
	self:RegisterEvent('ADDON_LOADED', 'BlizzardUI_LOD_Skins')
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'BenikUISkins')
end

E:RegisterModule(BUIS:GetName())
