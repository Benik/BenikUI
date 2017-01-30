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

local tooltips = {
	FriendsTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	FloatingBattlePetTooltip,
	FloatingPetBattleAbilityTooltip
}

-- Blizzard Styles
local function styleFreeBlizzardFrames()

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
		-- Scale the dressUp frame. A bit.
		if not IsAddOnLoaded('dressingroomfunctions') or not IsAddOnLoaded('Leatrix_Plus') then
			DressUpFrame:Size(500, 620)
			DressUpModel:Size(420, 540)
			DressUpModel:ClearAllPoints()
			DressUpModel:Point("CENTER", DressUpFrame.backdrop, "CENTER")

			DressUpFrameCancelButton:ClearAllPoints()
			DressUpFrameCancelButton:Point("BOTTOMRIGHT", DressUpFrame.backdrop, "BOTTOMRIGHT", -10, 10)

			DressUpModelControlFrame:ClearAllPoints()
			DressUpModelControlFrame:Point("BOTTOM", DressUpFrame.backdrop, "BOTTOM", 0, 10)
			DressUpModelControlFrame:SetFrameLevel(10)

			DressUpFrameOutfitDropDown:ClearAllPoints()
			DressUpFrameOutfitDropDown:Point("TOPRIGHT", DressUpFrame.backdrop, "TOPRIGHT", -(DressUpFrameOutfitDropDown.SaveButton:GetWidth() +10), -40)
		end

		if DressUpFrame.style then
			DressUpFrame.style:Point('TOPLEFT', DressUpFrame, 'TOPLEFT', 6, 4)
			DressUpFrame.style:Point('BOTTOMRIGHT', DressUpFrame, 'TOPRIGHT', -32, -1)
		end
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
		LFGDungeonReadyPopup:Style('Outside')
		LFGDungeonReadyDialog:Style('Outside')
		LFGDungeonReadyStatus:Style('Outside')
		LFGListApplicationDialog:Style('Outside')
		LFGListInviteDialog:Style('Outside')
		PVEFrame.backdrop:Style('Outside')
		PVPReadyDialog:Style('Outside')
		RaidBrowserFrame.backdrop:Style('Outside')
		QuickJoinRoleSelectionFrame:Style('Outside')
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
		MerchantFrame:Style('Outside')
		if MerchantFrame.style then
			MerchantFrame.style:Point('TOPLEFT', MerchantFrame, 'TOPLEFT', 6, 4)
			MerchantFrame.style:Point('BOTTOMRIGHT', MerchantFrame, 'TOPRIGHT', 2, -1)
		end
	end

	if db.misc then
		AudioOptionsFrame:Style('Outside')
		BNToastFrame:Style('Outside')
		ChatConfigFrame:Style('Outside')
		ChatMenu:Style('Outside')
		DropDownList1:Style('Outside') -- Maybe this get replaced with new Lib_Dropdown
		DropDownList2:Style('Outside') -- Maybe this get replaced with new Lib_Dropdown
		Lib_DropDownList1MenuBackdrop:Style('Outside')
		Lib_DropDownList2MenuBackdrop:Style('Outside')
		Lib_DropDownList1Backdrop:Style('Outside')
		Lib_DropDownList2Backdrop:Style('Outside')
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

local function StyleCagedBattlePetTooltip(tooltipFrame)
	if not tooltipFrame.style then
		tooltipFrame:Style('Outside')
	end
end
hooksecurefunc('BattlePetTooltipTemplate_SetBattlePet', StyleCagedBattlePetTooltip)

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
	_G["GarrisonFollowerAbilityWithoutCountersTooltip"]:Style('Outside')
	_G["GarrisonFollowerMissionAbilityWithoutCountersTooltip"]:Style('Outside')
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

local function tweakObjectiveTrackerButtonFont()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true then return end

	local button = _G["ObjectiveTrackerFrame"].HeaderMenu.MinimizeButton
	button:Size(16, 12)
	button.text:FontTemplate(E['media'].buiVisitor, 10)
	button.text:Point('CENTER', button, 'CENTER', 0, 1)
end

-- Map styling fix
local function FixMapStyle()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true then return end
	if not _G["WorldMapFrame"].BorderFrame.backdrop.style then
		_G["WorldMapFrame"].BorderFrame.backdrop:Style('Outside')
	end

	if _G["WorldMapTooltip"] then
		if not _G["WorldMapTooltip"].style then
			_G["WorldMapTooltip"]:Style('Outside')
		end
	end

	for i, tooltip in ipairs(WorldMapTooltip.ItemTooltip.Tooltip.shoppingTooltips) do
		if not tooltip.style then
			tooltip:Style('Outside')
		end
	end

	_G["QuestMapFrame"].QuestsFrame.StoryTooltip:SetTemplate('Transparent')
	if not _G["QuestMapFrame"].QuestsFrame.StoryTooltip.style then
		_G["QuestMapFrame"].QuestsFrame.StoryTooltip:Style('Outside')
	end
end

local function styleAddons()
	
	-- LocationLite
	if IsAddOnLoaded('ElvUI_LocLite') and E.db.benikuiSkins.elvuiAddons.loclite then
		local framestoskin = {_G["LocationLitePanel"], _G["XCoordsLite"], _G["YCoordsLite"]}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end

	-- LocationPlus
	if IsAddOnLoaded('ElvUI_LocPlus') and E.db.benikuiSkins.elvuiAddons.locplus then
		local framestoskin = {_G["LeftCoordDtPanel"], _G["RightCoordDtPanel"], _G["LocationPlusPanel"], _G["XCoordsPanel"], _G["YCoordsPanel"]}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style('Outside')
			end
		end
	end

	-- Shadow & Light
	if IsAddOnLoaded('ElvUI_SLE') and E.db.benikuiSkins.elvuiAddons.sle then
		local sleFrames = {_G["SLE_BG_1"], _G["SLE_BG_2"], _G["SLE_BG_3"], _G["SLE_BG_4"], _G["SLE_DataPanel_1"], _G["SLE_DataPanel_2"], _G["SLE_DataPanel_3"], _G["SLE_DataPanel_4"], _G["SLE_DataPanel_5"], _G["SLE_DataPanel_6"], _G["SLE_DataPanel_7"], _G["SLE_DataPanel_8"], _G["RaidMarkerBar"].backdrop, _G["SLE_SquareMinimapButtonBar"], _G["SLE_LocationPanel"], _G["SLE_LocationPanel_X"], _G["SLE_LocationPanel_Y"], _G["SLE_LocationPanel_RightClickMenu1"], _G["SLE_LocationPanel_RightClickMenu2"], _G["InspectArmory"]}
		for _, frame in pairs(sleFrames) do
			if frame then
				frame:Style('Outside')
			end
		end
	end

	-- SquareMinimapButtons
	if IsAddOnLoaded('SquareMinimapButtons') and E.db.benikuiSkins.elvuiAddons.smb then
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
end

function BUIS:init()
	self:styleAlertFrames()
	styleFreeBlizzardFrames()
	styleAddons()
	styleGarrison()
	tweakObjectiveTrackerButtonFont()

	local reason = select(5, GetAddOnInfo("GarrisonCommander"))
	if reason == "DISABLED" or reason == "MISSING" then 
		styleOrderHall()
	end
	
	_G["WorldMapFrame"]:HookScript('OnShow', FixMapStyle)
	hooksecurefunc('WorldMap_ToggleSizeUp', FixMapStyle)
end

function BUIS:Initialize()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'init')
end

E:RegisterModule(BUIS:GetName())
