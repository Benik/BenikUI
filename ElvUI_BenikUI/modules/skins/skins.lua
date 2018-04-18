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

local MAX_STATIC_POPUPS = 4
local SPACING = (E.PixelMode and 1 or 3)

local tooltips = {
	FriendsTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	FloatingBattlePetTooltip,
	FloatingPetBattleAbilityTooltip,
	FloatingGarrisonFollowerAbilityTooltip
}

-- Blizzard Styles
local function styleFreeBlizzardFrames()

	ColorPickerFrame:Style('Outside')
	MinimapRightClickMenu:Style('Outside')

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
		if db.tooltip then
			ReputationParagonTooltip:Style('Outside')
		end
		TokenFrame:Style('Outside')
		TokenFramePopup:Style('Outside')
	end

	if db.dressingroom then
		DressUpFrame.backdrop:Style('Outside')

		if not WardrobeOutfitEditFrame.style then
			WardrobeOutfitEditFrame:Style('Outside')
		end
	end

	if db.friends then
		AddFriendFrame:Style('Outside')
		ChannelFrameDaughterFrame.backdrop:Style('Outside')
		FriendsFrame:Style('Outside')
		FriendsFriendsFrame.backdrop:Style('Outside')
		RecruitAFriendFrame:Style('Outside')
		RecruitAFriendSentFrame:Style('Outside')
		RecruitAFriendSentFrame.MoreDetails.Text:FontTemplate()
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
		LFGInvitePopup:Style('Outside')
		LFGDungeonReadyDialog:Style('Outside')
		LFGDungeonReadyStatus:Style('Outside')
		LFGListApplicationDialog:Style('Outside')
		LFGListInviteDialog:Style('Outside')
		PVEFrame.backdrop:Style('Outside')
		PVPReadyDialog:Style('Outside')
		RaidBrowserFrame.backdrop:Style('Outside')
		QuickJoinRoleSelectionFrame:Style('Outside')

		local function forceTabFont(button)
			if button.isSkinned then return end
			local text = button:GetFontString()
			if text then
				text:FontTemplate(nil, 11)
			end
			button.isSkinned = true
		end
		forceTabFont(LFGListFrame.ApplicationViewer.NameColumnHeader)
		forceTabFont(LFGListFrame.ApplicationViewer.RoleColumnHeader)
		forceTabFont(LFGListFrame.ApplicationViewer.ItemLevelColumnHeader)
	end

	if db.loot then
		LootFrame:Style('Outside')
		MasterLooterFrame:Style('Outside')
		BonusRollFrame:Style('Outside')
	end

	if db.mail then
		MailFrame:Style('Outside')
		OpenMailFrame:Style('Outside')
	end

	if db.merchant then
		if MerchantFrame.backdrop then
			MerchantFrame.backdrop:Style('Outside')
		end
	end

	if db.misc then
		AudioOptionsFrame:Style('Outside')
		BNToastFrame:Style('Outside')
		ChatConfigFrame:Style('Outside')
		ChatMenu:Style('Outside')
		CinematicFrameCloseDialog:Style('Outside')
		DropDownList1:Style('Outside') -- Maybe this get replaced with new Lib_Dropdown
		DropDownList2:Style('Outside') -- Maybe this get replaced with new Lib_Dropdown
		L_DropDownList1MenuBackdrop:Style('Outside')
		L_DropDownList2MenuBackdrop:Style('Outside')
		L_DropDownList1Backdrop:Style('Outside')
		L_DropDownList2Backdrop:Style('Outside')
		EmoteMenu:Style('Outside')
		GameMenuFrame:Style('Outside')
		GhostFrame:Style('Outside')
		GuildInviteFrame:Style('Outside')
		InterfaceOptionsFrame:Style('Outside')
		LanguageMenu:Style('Outside')
		LFDRoleCheckPopup:Style('Outside')
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

	if db.quest then
		QuestFrame.backdrop:Style('Outside')
		QuestLogPopupDetailFrame:Style('Outside')
		QuestNPCModel.backdrop:Style('Outside')
		
		if BUI.AS then
			QuestDetailScrollFrame:SetTemplate('Transparent')
			QuestProgressScrollFrame:SetTemplate('Transparent')
			QuestRewardScrollFrame:HookScript('OnUpdate', function(self)
				self:SetTemplate('Transparent')
			end)
			GossipGreetingScrollFrame:SetTemplate('Transparent')
		end
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
	
	if db.tooltip then
		for _, frame in pairs(tooltips) do
			if frame and not frame.style then
				frame:Style('Outside')
			end
		end
	end

	if db.trade then
		TradeFrame:Style('Outside')
	end

end

local function StyleCagedBattlePetTooltip(tooltipFrame)
	if not tooltipFrame.style then
		tooltipFrame:Style('Outside')
	end
end

-- SpellBook tabs
local function styleSpellbook()
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true or E.private.skins.blizzard.spellbook ~= true then return end

	hooksecurefunc('SpellBookFrame_UpdateSkillLineTabs', function()
		for i = 1, MAX_SKILLLINE_TABS do
			local tab = _G['SpellBookSkillLineTab'..i]
			if not tab.style then
				tab:Style('Inside')
				tab.style:SetFrameLevel(5)
				if tab:GetNormalTexture() then
					tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
					tab:GetNormalTexture():SetInside()
				end
			end
		end
	end)
end
S:AddCallback("BenikUI_Spellbook", styleSpellbook)

-- Order Hall
local function styleOrderHall()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true then return end
	if (not _G["OrderHallMissionFrame"]) then LoadAddOn("Blizzard_OrderHallUI") end

	_G["OrderHallMissionFrame"]:Style('Small')
	if _G["AdventureMapQuestChoiceDialog"].backdrop then
		_G["AdventureMapQuestChoiceDialog"].backdrop:Style('Outside')
	end
	_G["OrderHallTalentFrame"]:Style('Outside')
	if E.private.skins.blizzard.tooltip then
		_G["GarrisonFollowerAbilityWithoutCountersTooltip"]:Style('Outside')
		_G["GarrisonFollowerMissionAbilityWithoutCountersTooltip"]:Style('Outside')
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

	-- ShipYard
	_G["GarrisonShipyardFrame"].backdrop:Style('Outside')
	-- Tooltips
	if E.private.skins.blizzard.tooltip then
		_G["GarrisonShipyardMapMissionTooltip"]:Style('Outside')
		_G["GarrisonBonusAreaTooltip"]:StripTextures()
		_G["GarrisonBonusAreaTooltip"]:CreateBackdrop('Transparent')
		_G["GarrisonBonusAreaTooltip"].backdrop:Style('Outside')
		_G["GarrisonMissionMechanicFollowerCounterTooltip"]:Style('Outside')
		_G["GarrisonMissionMechanicTooltip"]:Style('Outside')
		_G["FloatingGarrisonShipyardFollowerTooltip"]:Style('Outside')
		_G["GarrisonShipyardFollowerTooltip"]:Style('Outside')
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
	end

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

-- Map styling fix
local function FixMapStyle()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true then return end

	local mapFrame = _G["WorldMapFrame"]
	if not mapFrame.BorderFrame.backdrop.style then
		mapFrame.BorderFrame.backdrop:Style('Outside')
	end

	mapFrame.UIElementsFrame.BountyBoard.BountyName:FontTemplate(nil, 12, 'OUTLINE')

	if E.private.skins.blizzard.tooltip ~= true then return end

	local questFrame = _G["QuestMapFrame"]
	questFrame.QuestsFrame.StoryTooltip:SetTemplate('Transparent')
	if not questFrame.QuestsFrame.StoryTooltip.style then
		questFrame.QuestsFrame.StoryTooltip:Style('Outside')
	end

	local mapTooltip = _G["WorldMapTooltip"]
	if mapTooltip then
		if not mapTooltip.style then
			mapTooltip:Style('Outside')
		end
	end

	local shoppingTooltips = {_G["WorldMapCompareTooltip1"], _G["WorldMapCompareTooltip2"]}
	for i, tooltip in pairs(shoppingTooltips) do
		if not tooltip.style then
			tooltip:Style('Outside')
		end
	end
end

local function styleAddons()
	-- LocationLite
	if BUI.LL and E.db.benikuiSkins.elvuiAddons.loclite then
		local framestoskin = {_G["LocationLitePanel"], _G["XCoordsLite"], _G["YCoordsLite"]}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end

	-- LocationPlus
	if BUI.LP and E.db.benikuiSkins.elvuiAddons.locplus then
		local framestoskin = {_G["LeftCoordDtPanel"], _G["RightCoordDtPanel"], _G["LocationPlusPanel"], _G["XCoordsPanel"], _G["YCoordsPanel"]}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end

	-- Shadow & Light
	if BUI.SLE and E.db.benikuiSkins.elvuiAddons.sle then
		local sleFrames = {_G["SLE_BG_1"], _G["SLE_BG_2"], _G["SLE_BG_3"], _G["SLE_BG_4"], _G["SLE_DataPanel_1"], _G["SLE_DataPanel_2"], _G["SLE_DataPanel_3"], _G["SLE_DataPanel_4"], _G["SLE_DataPanel_5"], _G["SLE_DataPanel_6"], _G["SLE_DataPanel_7"], _G["SLE_DataPanel_8"], _G["SLE_RaidMarkerBar"].backdrop, _G["SLE_SquareMinimapButtonBar"], _G["SLE_LocationPanel"], _G["SLE_LocationPanel_X"], _G["SLE_LocationPanel_Y"], _G["SLE_LocationPanel_RightClickMenu1"], _G["SLE_LocationPanel_RightClickMenu2"], _G["InspectArmory"]}
		for _, frame in pairs(sleFrames) do
			if frame then
				frame:Style('Outside')
			end
		end
	end

	-- SquareMinimapButtons
	if BUI.PA and _G.ProjectAzilroka.db['SMB'] and E.db.benikuiSkins.elvuiAddons.smb then
		local smbFrame = _G["SquareMinimapButtonBar"]
		if smbFrame then
			smbFrame:Style('Outside')
		end
	end

	-- ElvUI_Enhanced
	if IsAddOnLoaded('ElvUI_Enhanced') and E.db.benikuiSkins.elvuiAddons.enh then
		if _G["MinimapButtonBar"] then
			_G["MinimapButtonBar"].backdrop:Style('Outside')
		end
		
		if _G["RaidMarkerBar"].backdrop then
			_G["RaidMarkerBar"].backdrop:Style('Outside')
		end
	end

	-- ElvUI_DTBars2
	if IsAddOnLoaded('ElvUI_DTBars2') and E.db.benikuiSkins.elvuiAddons.dtb2 then
		for panelname, data in pairs(E.global.dtbars) do
			if panelname then
				_G[panelname]:Style('Outside')
			end
		end
	end

	-- stAddonManager
	if BUI.PA and _G.ProjectAzilroka.db['stAM'] and E.db.benikuiSkins.elvuiAddons.stam then
		local stFrame = _G["stAMFrame"]
		if stFrame then
			stFrame:Style('Outside')
		end
	end
end

local function skinDecursive()
	if not IsAddOnLoaded('Decursive') or not E.db.benikuiSkins.variousSkins.decursive then return end

	-- Main Buttons
	_G["DecursiveMainBar"]:StripTextures()
	_G["DecursiveMainBar"]:SetTemplate('Default', true)
	_G["DecursiveMainBar"]:Height(20)

	local mainButtons = {_G["DecursiveMainBarPriority"], _G["DecursiveMainBarSkip"], _G["DecursiveMainBarHide"]}
	for i, button in pairs(mainButtons) do
		S:HandleButton(button)
		button:SetTemplate('Default', true)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('LEFT', _G["DecursiveMainBar"], 'RIGHT', SPACING, 0)
		else
			button:Point('LEFT', mainButtons[i - 1], 'RIGHT', SPACING, 0)
		end
	end

	-- Priority List Frame
	_G["DecursivePriorityListFrame"]:StripTextures()
	_G["DecursivePriorityListFrame"]:CreateBackdrop('Transparent')
	_G["DecursivePriorityListFrame"].backdrop:Style('Outside')

	local priorityButton = {_G["DecursivePriorityListFrameAdd"], _G["DecursivePriorityListFramePopulate"], _G["DecursivePriorityListFrameClear"], _G["DecursivePriorityListFrameClose"]}
	for i, button in pairs(priorityButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('TOP', _G["DecursivePriorityListFrame"], 'TOPLEFT', 54, -20)
		else
			button:Point('LEFT', priorityButton[i - 1], 'RIGHT', SPACING, 0)
		end
	end

	_G["DecursivePopulateListFrame"]:StripTextures()
	_G["DecursivePopulateListFrame"]:CreateBackdrop('Transparent')
	_G["DecursivePopulateListFrame"].backdrop:Style('Outside')

	for i = 1, 8 do
		local groupButton = _G["DecursivePopulateListFrameGroup"..i]
		S:HandleButton(groupButton)
	end

	local classPop = {'Warrior', 'Priest', 'Mage', 'Warlock', 'Hunter', 'Rogue', 'Druid', 'Shaman', 'Monk', 'Paladin', 'Deathknight', 'Close'}
	for _, classBtn in pairs(classPop) do
		local btnName = _G["DecursivePopulateListFrame"..classBtn]
		S:HandleButton(btnName)
	end

	-- Skip List Frame
	_G["DecursiveSkipListFrame"]:StripTextures()
	_G["DecursiveSkipListFrame"]:CreateBackdrop('Transparent')
	_G["DecursiveSkipListFrame"].backdrop:Style('Outside')

	local skipButton = {_G["DecursiveSkipListFrameAdd"], _G["DecursiveSkipListFramePopulate"], _G["DecursiveSkipListFrameClear"], _G["DecursiveSkipListFrameClose"]}
	for i, button in pairs(skipButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('TOP', _G["DecursiveSkipListFrame"], 'TOPLEFT', 54, -20)
		else
			button:Point('LEFT', skipButton[i - 1], 'RIGHT', SPACING, 0)
		end
	end

	-- Tooltip
	if E.private.skins.blizzard.tooltip then
		_G["DcrDisplay_Tooltip"]:StripTextures()
		_G["DcrDisplay_Tooltip"]:CreateBackdrop('Transparent')
		_G["DcrDisplay_Tooltip"].backdrop:Style('Outside')
	end
end

local function skinStoryline()
	if not IsAddOnLoaded('Storyline') or not E.db.benikuiSkins.variousSkins.storyline then return end
	_G["Storyline_NPCFrame"]:StripTextures()
	_G["Storyline_NPCFrame"]:CreateBackdrop('Transparent')
	_G["Storyline_NPCFrame"].backdrop:Style('Outside')
	S:HandleCloseButton(_G["Storyline_NPCFrameClose"])
	_G["Storyline_NPCFrameChat"]:StripTextures()
	_G["Storyline_NPCFrameChat"]:CreateBackdrop('Transparent')
end

local function StyleDBM_Options()
	if not E.db.benikuiSkins.addonSkins.dbm or not BUI.AS then return end

	DBM_GUI_OptionsFrame:HookScript('OnShow', function()
		DBM_GUI_OptionsFrame:Style('Outside')
	end)
end

function BUIS:LoD_AddOns(_, addon)
	if addon == "DBM-GUI" then
		StyleDBM_Options()
	end
end

function BUIS:PLAYER_ENTERING_WORLD(...)
	self:styleAlertFrames()
	styleFreeBlizzardFrames()
	styleAddons()
	styleGarrison()

	local reason = select(5, GetAddOnInfo("GarrisonCommander"))
	if reason == "DISABLED" or reason == "MISSING" then 
		styleOrderHall()
	end

	_G["WorldMapFrame"]:HookScript('OnShow', FixMapStyle)
	hooksecurefunc('WorldMap_ToggleSizeUp', FixMapStyle)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function BUIS:Initialize()
	if E.db.benikui.general.benikuiStyle ~= true then return end

	skinDecursive()
	skinStoryline()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ADDON_LOADED", "LoD_AddOns")

	if E.private.skins.blizzard.tooltip ~= true then return end
	hooksecurefunc('BattlePetTooltipTemplate_SetBattlePet', StyleCagedBattlePetTooltip)
end

local function InitializeCallback()
	BUIS:Initialize()
end

E:RegisterModule(BUIS:GetName(), InitializeCallback)