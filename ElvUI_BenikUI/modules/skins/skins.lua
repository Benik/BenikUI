local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0")
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local InCombatLockdown = InCombatLockdown
local GetQuestLogTitle = GetQuestLogTitle

-- GLOBALS: hooksecurefunc

local MAX_STATIC_POPUPS = 4
local SPACING = (E.PixelMode and 1 or 3)

local WarCampaignTooltip = QuestScrollFrame.WarCampaignTooltip

local tooltips = {
	EmbeddedItemTooltip,
	FriendsTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	FloatingBattlePetTooltip,
	FloatingPetBattleAbilityTooltip,
	FloatingGarrisonFollowerAbilityTooltip,
	WarCampaignTooltip,
	GameTooltip
}

local overlayedTooltips = {
	GameTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3
}

local function tooltipOverlay(tt) -- Create a blank frame to position the GameTooltip.TopOverlay texture
	if not tt.style then
		return
	end

	if tt.style.blank then
		return
	end

	tt.style.blank = CreateFrame("Frame", nil, tt.style)
	tt.style.blank:Size(6, 6)
	tt.style.blank:Point("BOTTOM", tt.style, "TOP")

	if tt.TopOverlay then
		tt.TopOverlay:SetParent(tt.style.blank)
		tt.TopOverlay:ClearAllPoints()
		tt.TopOverlay:Point("CENTER", tt.style.blank, "CENTER")
	end
end

-- Blizzard Styles
local function styleFreeBlizzardFrames()
	if E.db.benikui.general.benikuiStyle ~= true then return end

	if E.private.skins.blizzard.enable ~= true then
		return
	end

	local db = E.private.skins.blizzard

	if db.addonManager then
		_G.AddonList:Style("Outside")
	end

	if db.bgscore then
		if not _G.PVPMatchScoreboard then
			LoadAddOn("Blizzard_PVPMatch")
		end
		_G.PVPMatchScoreboard:Style("Outside")
		_G.PVPMatchResults:Style("Outside")
	end
	if db.character then
		_G.GearManagerDialogPopup:Style("Outside")
		_G.PaperDollFrame:Style("Outside")
		_G.ReputationDetailFrame:Style("Outside")
		_G.ReputationFrame:Style("Outside")
		_G.TokenFrame:Style("Outside")
		_G.TokenFramePopup:Style("Outside")
	end

	if db.dressingroom then
		_G.DressUpFrame.backdrop:Style("Outside")

		if not _G.WardrobeOutfitEditFrame.style then
			_G.WardrobeOutfitEditFrame:Style("Outside")
		end
	end

	if db.friends then
		_G.AddFriendFrame:Style("Outside")
		_G.FriendsFrame:Style("Outside")
		_G.FriendsFriendsFrame.backdrop:Style("Outside")
		_G.RecruitAFriendFrame:Style("Outside")
	end

	if db.gossip then
		_G.GossipFrame:Style("Outside")
		_G.ItemTextFrame:Style("Outside")
	end

	if db.guildregistrar then
		_G.GuildRegistrarFrame:Style("Outside")
	end

	if db.help then
		_G.HelpFrame.backdrop:Style("Outside")
		_G.HelpFrame.Header.backdrop:Style("Outside")
	end

	if db.lfg then
		_G.LFGInvitePopup:Style("Outside")
		_G.LFGDungeonReadyDialog:Style("Outside")
		_G.LFGDungeonReadyStatus:Style("Outside")
		_G.LFGListApplicationDialog:Style("Outside")
		_G.LFGListInviteDialog:Style("Outside")
		_G.PVEFrame.backdrop:Style("Outside")
		_G.PVPReadyDialog:Style("Outside")
		_G.RaidBrowserFrame.backdrop:Style("Outside")
		_G.QuickJoinRoleSelectionFrame:Style("Outside")

		local function forceTabFont(button)
			if button.isSkinned then
				return
			end
			local text = button:GetFontString()
			if text then
				text:FontTemplate(nil, 11)
			end
			button.isSkinned = true
		end
		forceTabFont(_G.LFGListFrame.ApplicationViewer.NameColumnHeader)
		forceTabFont(_G.LFGListFrame.ApplicationViewer.RoleColumnHeader)
		forceTabFont(_G.LFGListFrame.ApplicationViewer.ItemLevelColumnHeader)
	end

	if db.loot then
		_G.LootFrame:Style("Outside")
		_G.MasterLooterFrame:Style("Outside")
		_G.BonusRollFrame:Style("Outside")
	end

	if db.mail then
		_G.MailFrame:Style("Outside")
		_G.OpenMailFrame:Style("Outside")
	end

	if db.merchant then
		if _G.MerchantFrame.backdrop then
			_G.MerchantFrame.backdrop:Style("Outside")
		end
	end

	if db.misc then
		_G.AudioOptionsFrame:Style("Outside")
		_G.BNToastFrame:Style("Outside")
		_G.ChatConfigFrame:Style("Outside")
		_G.ChatMenu:Style("Outside")
		_G.CinematicFrameCloseDialog:Style("Outside")
		_G.DropDownList1MenuBackdrop:Style("Outside")
		_G.DropDownList2MenuBackdrop:Style("Outside")
		_G.EmoteMenu:Style("Outside")
		_G.GameMenuFrame:Style("Outside")
		_G.GhostFrame:Style("Outside")
		_G.GuildInviteFrame:Style("Outside")
		_G.InterfaceOptionsFrame:Style("Outside")
		_G.LanguageMenu:Style("Outside")
		_G.LFDRoleCheckPopup:Style("Outside")
		_G.QueueStatusFrame:Style("Outside")
		_G.ReadyCheckFrame:Style("Outside")
		_G.ReadyCheckListenerFrame:Style("Outside")
		_G.SideDressUpFrame:Style("Outside")
		_G.SplashFrame.backdrop:Style("Outside")
		_G.StackSplitFrame:Style("Outside")
		_G.StaticPopup1:Style("Outside")
		_G.StaticPopup2:Style("Outside")
		_G.StaticPopup3:Style("Outside")
		_G.StaticPopup4:Style("Outside")
		_G.TicketStatusFrameButton:Style("Outside")
		_G.VideoOptionsFrame:Style("Outside")
		_G.VoiceMacroMenu:Style("Outside")

		for i = 1, MAX_STATIC_POPUPS do
			local frame = _G['ElvUI_StaticPopup'..i]
			frame:Style("Outside")
		end
	end

	if db.nonraid then
		_G.RaidInfoFrame:Style("Outside")
	end

	if db.petition then
		_G.PetitionFrame:Style("Outside")
	end

	if db.quest then
		_G.QuestFrame.backdrop:Style("Outside")
		_G.QuestLogPopupDetailFrame:Style("Outside")
		_G.QuestModelScene.backdrop:Style("Outside")

		if BUI.AS then
			_G.QuestDetailScrollFrame:SetTemplate("Transparent")
			_G.QuestProgressScrollFrame:SetTemplate("Transparent")
			_G.QuestRewardScrollFrame:HookScript(
				"OnUpdate",
				function(self)
					self:SetTemplate("Transparent")
				end
			)
			_G.GossipGreetingScrollFrame:SetTemplate("Transparent")
		end
	end

	if db.stable then
		_G.PetStableFrame:Style("Outside")
	end

	if db.spellbook then
		_G.SpellBookFrame:Style("Outside")
	end

	if db.tabard then
		_G.TabardFrame:Style("Outside")
	end

	if db.taxi then
		_G.TaxiFrame.backdrop:Style("Outside")
	end

	if db.tooltip then
		for _, frame in pairs(tooltips) do
			if frame and not frame.style then
				frame:Style("Outside")
			end
		end

		for _, tooltip in pairs(overlayedTooltips) do
			if tooltip then
				tooltipOverlay(tooltip)
			end
		end
	end

	if db.trade then
		_G.TradeFrame:Style("Outside")
	end
	
	_G.ColorPickerFrame:Style("Outside")
end
S:AddCallback("BenikUI_styleFreeBlizzardFrames", styleFreeBlizzardFrames)

local function StyleCagedBattlePetTooltip(tooltipFrame)
	if not tooltipFrame.style then
		tooltipFrame:Style("Outside")
	end
end

-- SpellBook tabs
local function styleSpellbook()
	if
		E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true or
			E.private.skins.blizzard.spellbook ~= true
	 then
		return
	end

	hooksecurefunc(
		"SpellBookFrame_UpdateSkillLineTabs",
		function()
			for i = 1, MAX_SKILLLINE_TABS do
				local tab = _G['SpellBookSkillLineTab'..i]
				if not tab.style then
					tab:Style("Inside")
					tab.style:SetFrameLevel(5)
					if tab:GetNormalTexture() then
						tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
						tab:GetNormalTexture():SetInside()
					end
				end
			end
		end
	)
end
S:AddCallback("BenikUI_Spellbook", styleSpellbook)

-- WorldMap
local function styleWorldMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true then
		return
	end

	local mapFrame = _G.WorldMapFrame
	if not mapFrame.backdrop.style then
		mapFrame.backdrop:Style("Outside")
	end

	if E.private.skins.blizzard.tooltip ~= true then
		return
	end

	local questFrame = _G.QuestMapFrame
	questFrame.QuestsFrame.StoryTooltip:SetTemplate("Transparent")
	if not questFrame.QuestsFrame.StoryTooltip.style then
		questFrame.QuestsFrame.StoryTooltip:Style("Outside")
	end

	local shoppingTooltips = {_G.WorldMapCompareTooltip1, _G.WorldMapCompareTooltip2}
	for i, tooltip in pairs(shoppingTooltips) do
		if not tooltip.style then
			tooltip:Style("Outside")
		end
	end
end

local function styleAddons()
	-- LocationPlus
	if BUI.LP and E.db.benikuiSkins.elvuiAddons.locplus then
		local framestoskin = {
			_G.LeftCoordDtPanel,
			_G.RightCoordDtPanel,
			_G.LocationPlusPanel,
			_G.XCoordsPanel,
			_G.YCoordsPanel
		}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style("Outside")
			end
		end
	end

	-- Shadow & Light
	if BUI.SLE and E.db.benikuiSkins.elvuiAddons.sle then
		local sleFrames = {
			_G.SLE_BG_1,
			_G.SLE_BG_2,
			_G.SLE_BG_3,
			_G.SLE_BG_4,
			_G.SLE_DataPanel_1,
			_G.SLE_DataPanel_2,
			_G.SLE_DataPanel_3,
			_G.SLE_DataPanel_4,
			_G.SLE_DataPanel_5,
			_G.SLE_DataPanel_6,
			_G.SLE_DataPanel_7,
			_G.SLE_DataPanel_8,
			_G.SLE_RaidMarkerBar.backdrop,
			_G.SLE_SquareMinimapButtonBar,
			_G.SLE_LocationPanel,
			_G.SLE_LocationPanel_X,
			_G.SLE_LocationPanel_Y,
			_G.SLE_LocationPanel_RightClickMenu1,
			_G.SLE_LocationPanel_RightClickMenu2,
			_G.InspectArmory
		}
		for _, frame in pairs(sleFrames) do
			if frame then
				frame:Style("Outside")
			end
		end
	end

	-- SquareMinimapButtons
	if BUI.PA and E.db.benikuiSkins.elvuiAddons.pa then
		local smbFrame = _G.SquareMinimapButtonBar
		if smbFrame then
			smbFrame:Style("Outside")
		end
	end

	-- ElvUI_Enhanced
	if IsAddOnLoaded("ElvUI_Enhanced") and E.db.benikuiSkins.elvuiAddons.enh then
		if _G.MinimapButtonBar then
			_G.MinimapButtonBar.backdrop:Style("Outside")
		end

		if _G.RaidMarkerBar.backdrop then
			_G.RaidMarkerBar.backdrop:Style("Outside")
		end
	end

	-- ElvUI_DTBars2
	if IsAddOnLoaded("ElvUI_DTBars2") and E.db.benikuiSkins.elvuiAddons.dtb2 then
		for panelname, data in pairs(E.global.dtbars) do
			if panelname then
				_G[panelname]:Style("Outside")
			end
		end
	end

	-- stAddonManager
	if BUI.PA and E.db.benikuiSkins.elvuiAddons.pa then
		local stFrame = _G.stAMFrame
		if stFrame then
			stFrame:Style("Outside")
			stAMAddOns:SetTemplate("Transparent")
		end
	end
end

local function skinDecursive()
	if not IsAddOnLoaded("Decursive") or not E.db.benikuiSkins.variousSkins.decursive then
		return
	end

	-- Main Buttons
	_G.DecursiveMainBar:StripTextures()
	_G.DecursiveMainBar:SetTemplate("Default", true)
	_G.DecursiveMainBar:Height(20)

	local mainButtons = {_G.DecursiveMainBarPriority, _G.DecursiveMainBarSkip, _G.DecursiveMainBarHide}
	for i, button in pairs(mainButtons) do
		S:HandleButton(button)
		button:SetTemplate("Default", true)
		button:ClearAllPoints()
		if (i == 1) then
			button:Point("LEFT", _G.DecursiveMainBar, "RIGHT", SPACING, 0)
		else
			button:Point("LEFT", mainButtons[i - 1], "RIGHT", SPACING, 0)
		end
	end

	-- Priority List Frame
	_G.DecursivePriorityListFrame:StripTextures()
	_G.DecursivePriorityListFrame:CreateBackdrop("Transparent")
	_G.DecursivePriorityListFrame.backdrop:Style("Outside")

	local priorityButton = {
		_G.DecursivePriorityListFrameAdd,
		_G.DecursivePriorityListFramePopulate,
		_G.DecursivePriorityListFrameClear,
		_G.DecursivePriorityListFrameClose
	}
	for i, button in pairs(priorityButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if (i == 1) then
			button:Point("TOP", _G.DecursivePriorityListFrame, "TOPLEFT", 54, -20)
		else
			button:Point("LEFT", priorityButton[i - 1], "RIGHT", SPACING, 0)
		end
	end

	_G.DecursivePopulateListFrame:StripTextures()
	_G.DecursivePopulateListFrame:CreateBackdrop("Transparent")
	_G.DecursivePopulateListFrame.backdrop:Style("Outside")

	for i = 1, 8 do
		local groupButton = _G['DecursivePopulateListFrameGroup'..i]
		S:HandleButton(groupButton)
	end

	local classPop = {
		"Warrior",
		"Priest",
		"Mage",
		"Warlock",
		"Hunter",
		"Rogue",
		"Druid",
		"Shaman",
		"Monk",
		"Paladin",
		"Deathknight",
		"Close"
	}
	for _, classBtn in pairs(classPop) do
		local btnName = _G['DecursivePopulateListFrame' .. classBtn]
		S:HandleButton(btnName)
	end

	-- Skip List Frame
	_G.DecursiveSkipListFrame:StripTextures()
	_G.DecursiveSkipListFrame:CreateBackdrop("Transparent")
	_G.DecursiveSkipListFrame.backdrop:Style("Outside")

	local skipButton = {
		_G.DecursiveSkipListFrameAdd,
		_G.DecursiveSkipListFramePopulate,
		_G.DecursiveSkipListFrameClear,
		_G.DecursiveSkipListFrameClose
	}
	for i, button in pairs(skipButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if (i == 1) then
			button:Point("TOP", _G.DecursiveSkipListFrame, "TOPLEFT", 54, -20)
		else
			button:Point("LEFT", skipButton[i - 1], "RIGHT", SPACING, 0)
		end
	end

	-- Tooltip
	if E.private.skins.blizzard.tooltip then
		_G.DcrDisplay_Tooltip:StripTextures()
		_G.DcrDisplay_Tooltip:CreateBackdrop("Transparent")
		_G.DcrDisplay_Tooltip.backdrop:Style("Outside")
	end
end

local function skinStoryline()
	if not IsAddOnLoaded("Storyline") or not E.db.benikuiSkins.variousSkins.storyline then
		return
	end
	_G.Storyline_NPCFrame:StripTextures()
	_G.Storyline_NPCFrame:CreateBackdrop("Transparent")
	_G.Storyline_NPCFrame.backdrop:Style("Outside")
	S:HandleCloseButton(_G.Storyline_NPCFrameClose)
	_G.Storyline_NPCFrameChat:StripTextures()
	_G.Storyline_NPCFrameChat:CreateBackdrop("Transparent")
end

local function StyleDBM_Options()
	if not E.db.benikuiSkins.addonSkins.dbm or not BUI.AS then
		return
	end

	DBM_GUI_OptionsFrame:HookScript(
		"OnShow",
		function()
			DBM_GUI_OptionsFrame:Style("Outside")
		end
	)
end

local function StyleAltPowerBar()
	if E.db.general.altPowerBar.enable ~= true then
		return
	end

	local bar = _G.ElvUI_AltPowerBar
	bar.backdrop:Style("Outside")
	if bar.textures then
		bar:StripTextures(true)
	end
end

local function ObjectiveTrackerQuests()
	local function QuestNumString()
		local questNum, q, o
		local block = _G.ObjectiveTrackerBlocksFrame
		local frame = _G.ObjectiveTrackerFrame

		if not InCombatLockdown() then
			questNum = select(2, GetNumQuestLogEntries())
			if questNum >= (MAX_QUESTS - 5) then -- go red
				q = format("|cffff0000%d/%d|r %s", questNum, MAX_QUESTS, TRACKER_HEADER_QUESTS)
				o = format("|cffff0000%d/%d|r %s", questNum, MAX_QUESTS, OBJECTIVES_TRACKER_LABEL)
			else
				q = format("%d/%d %s", questNum, MAX_QUESTS, TRACKER_HEADER_QUESTS)
				o = format("%d/%d %s", questNum, MAX_QUESTS, OBJECTIVES_TRACKER_LABEL)
			end
			block.QuestHeader.Text:SetText(q)
			frame.HeaderMenu.Title:SetText(o)
		end
	end
	hooksecurefunc("ObjectiveTracker_Update", QuestNumString)
end
S:AddCallback("BenikUI_ObjectiveTracker", ObjectiveTrackerQuests)

local function StyleInFlight()
	if E.db.benikuiSkins.variousSkins.inflight ~= true or E.db.benikui.misc.flightMode == true then
		return
	end

	local frame = _G.InFlightBar
	if frame then
		if not frame.isStyled then
			frame:CreateBackdrop("Transparent")
			frame.backdrop:Style("Outside")
			frame.isStyled = true
		end
	end
end

local function LoadInFlight()
	local f = CreateFrame("Frame")
	f:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	f:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
	f:SetScript(
		"OnEvent",
		function(self, event)
			if event then
				StyleInFlight()
				f:UnregisterEvent(event)
			end
		end
	)
end

local function VehicleExit()
	if E.private.actionbar.enable ~= true then
		return
	end
	local f = _G.MainMenuBarVehicleLeaveButton
	f:SetNormalTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	f:SetPushedTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	f:SetHighlightTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	if MasqueGroup and E.private.actionbar.masque.actionbars then return end
	f:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
	f:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
end

function mod:StyleAdibagsBank()
	if not E.db.benikuiSkins.addonSkins.adibags or not BUI.AS then
		return
	end
	E:Delay(
		0.2,
		function()
			if AdiBagsContainer2 then
				AdiBagsContainer2:Style("Inside")
			end
		end
	)
end

local function StyleAdibags()
	if not E.db.benikuiSkins.addonSkins.adibags or not BUI.AS then
		return
	end
	E:Delay(
		1.1,
		function()
			if AdiBagsContainer1 then
				AdiBagsContainer1:Style("Outside")
			end
		end
	)
end

function mod:LoD_AddOns(_, addon)
	if addon == "DBM-GUI" then
		StyleDBM_Options()
	end
	if addon == "InFlight" then
		LoadInFlight()
	end
end

function mod:PLAYER_ENTERING_WORLD(...)
	self:styleAlertFrames()
	styleAddons()
	styleWorldMap()
	StyleAdibags()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function StyleElvUIConfig()
	if not E.private.skins.ace3.enable then return end

	local frame = E:Config_GetWindow()
	if not frame.style then
		frame:Style("Outside")
	end
end

local function StyleAceTooltip(self)
	if not self or self:IsForbidden() then return end
	if not self.style then
		self:Style('Outside')
	end
end

function mod:Initialize()
	VehicleExit()
	if E.db.benikui.general.benikuiStyle ~= true then return end

	skinDecursive()
	skinStoryline()
	StyleAltPowerBar()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ADDON_LOADED", "LoD_AddOns")
	self:RegisterEvent("BANKFRAME_OPENED", "StyleAdibagsBank")

	if E.private.skins.blizzard.tooltip ~= true then
		return
	end
	hooksecurefunc(E, "ToggleOptionsUI", StyleElvUIConfig)
	hooksecurefunc("BattlePetTooltipTemplate_SetBattlePet", StyleCagedBattlePetTooltip)
	hooksecurefunc(S, "Ace3_StyleTooltip", StyleAceTooltip)
end

BUI:RegisterModule(mod:GetName())