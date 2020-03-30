local BUI, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded

-- AchievementUI
local function style_AchievementUI()
	if E.private.skins.blizzard.achievement ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.AchievementFrame
	if frame.backdrop then
		frame.backdrop:Style("Outside")
	end
end
S:AddCallbackForAddon("Blizzard_AchievementUI", "BenikUI_AchievementUI", style_AchievementUI)

-- AlliedRacesUI
local function style_AlliedRacesUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.AlliedRaces ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.AlliedRacesFrame
	if frame.backdrop then
		frame.backdrop:Style("Outside")
	end
end
S:AddCallbackForAddon("Blizzard_AlliedRacesUI", "BenikUI_AlliedRaces", style_AlliedRacesUI)

-- ArchaeologyUI
local function style_ArchaeologyUI()
	if E.private.skins.blizzard.archaeology ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ArchaeologyFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_ArchaeologyUI", "BenikUI_ArchaeologyUI", style_ArchaeologyUI)

-- ArtifactUI
local function style_ArtifactUI()
	if E.private.skins.blizzard.artifact ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.ArtifactFrame
	frame.backdrop:Style("Outside")
	frame.CloseButton:ClearAllPoints()
	frame.CloseButton:SetPoint("TOPRIGHT", ArtifactFrame, "TOPRIGHT", 2, 2)
end
S:AddCallbackForAddon("Blizzard_ArtifactUI", "BenikUI_ArtifactUI", style_ArtifactUI)

-- AuctionHouseUI
local function style_AuctionHouseUI()
	if E.private.skins.blizzard.auctionhouse ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local Frame = _G.AuctionHouseFrame
	Frame:Style("Outside")
	Frame.WoWTokenResults.GameTimeTutorial.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_AuctionHouseUI", "BenikUI_AuctionHouseUI", style_AuctionHouseUI)

-- AzeriteEssenceUI
local function style_AzeriteEssenceUI()
	if E.private.skins.blizzard.AzeriteEssence ~= true or E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end

	_G.AzeriteEssenceUI:Style('Outside')
end
S:AddCallbackForAddon("Blizzard_AzeriteEssenceUI", "BenikUI_AzeriteEssenceUI", style_AzeriteEssenceUI)

-- AzeriteUI
local function style_AzeriteUI()
	if E.private.skins.blizzard.AzeriteUI ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.AzeriteEmpoweredItemUI.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_AzeriteUI", "BenikUI_AzeriteUI", style_AzeriteUI)

-- AzeriteRespecFrame
local function style_AzeriteRespecUI()
	if E.private.skins.blizzard.AzeriteRespec ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.AzeriteRespecFrame
	frame:Style("Inside")

	local CloseButton = frame.CloseButton
	CloseButton:ClearAllPoints()
	CloseButton:Point("TOPRIGHT", frame, "TOPRIGHT", -2, -6)

	AzeriteRespecFrameTitleText:ClearAllPoints()
	AzeriteRespecFrameTitleText:Point("TOP", frame, "TOP", 0, -12)

	frame.ButtonFrame.AzeriteRespecButton:ClearAllPoints()
	frame.ButtonFrame.AzeriteRespecButton:Point("TOP", frame.ItemSlot, "BOTTOM", 0, -20)
end
S:AddCallbackForAddon("Blizzard_AzeriteRespecUI", "BenikUI_AzeriteRespecUI", style_AzeriteRespecUI)

-- BarbershopUI
local function style_BarbershopUI()
	if E.private.skins.blizzard.barber ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.BarberShopFrame:Style("Outside")
	_G.BarberShopAltFormFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_BarbershopUI", "BenikUI_BarbershopUI", style_BarbershopUI)

-- BattlefieldMap
local function style_BattlefieldMap()
	if E.private.skins.blizzard.bgmap ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.BattlefieldMapFrame.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_BattlefieldMap", "BenikUI_BattlefieldMap", style_BattlefieldMap)

-- BindingUI
local function style_BindingUI()
	if E.private.skins.blizzard.binding ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.KeyBindingFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_BindingUI", "BenikUI_BindingUI", style_BindingUI)

-- BlackMarketUI
local function style_BlackMarketUI()
	if E.private.skins.blizzard.bmah ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.BlackMarketFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_BlackMarketUI", "BenikUI_BlackMarketUI", style_BlackMarketUI)

-- Calendar
local function style_Calendar()
	if E.private.skins.blizzard.calendar ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.CalendarFrame:Style("Outside")
	_G.CalendarViewEventFrame:Style("Outside")
	_G.CalendarViewHolidayFrame:Style("Outside")
	_G.CalendarCreateEventFrame:Style("Outside")
	_G.CalendarContextMenu:Style("Outside")
	_G.CalendarViewRaidFrame:Style("Outside")

	if not BUI.AS then
		return
	end
	for i = 1, 42 do
		_G["CalendarDayButton" .. i]:SetTemplate("Transparent")
	end
end
S:AddCallbackForAddon("Blizzard_Calendar", "BenikUI_Calendar", style_Calendar)

-- ChallengesUI
local function style_ChallengesUI()
	if E.private.skins.blizzard.lfg ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ChallengesKeystoneFrame.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_ChallengesUI", "BenikUI_ChallengesUI", style_ChallengesUI)

-- Channels
local function style_Channels()
	if E.private.skins.blizzard.Channels ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ChannelFrame.backdrop:Style("Outside")
	_G.CreateChannelPopup:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_Channels", "BenikUI_Channels", style_Channels)

-- Collections
local function style_Collections()
	if E.private.skins.blizzard.collections ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.CollectionsJournal:Style("Outside")
	_G.WardrobeFrame:Style("Outside")
	_G.WardrobeOutfitEditFrame.backdrop:Style("Outside")
	if E.private.skins.blizzard.tooltip then
		PetJournalPrimaryAbilityTooltip:Style("Outside")
	end
end
S:AddCallbackForAddon("Blizzard_Collections", "BenikUI_Collections", style_Collections)

-- Communities
local function style_Communities()
	if E.private.skins.blizzard.Communities ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.CommunitiesFrame
	if frame then
		frame.backdrop:Style("Outside")
		frame.GuildMemberDetailFrame.backdrop:Style("Outside")
		frame.NotificationSettingsDialog.backdrop:Style("Outside")
	end
	_G.CommunitiesGuildLogFrame.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_Communities", "BenikUI_Communities", style_Communities)

-- Contribution
local function style_Contribution()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Contribution ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.ContributionCollectionFrame
	if not frame.backdrop then
		frame:CreateBackdrop("Transparent")
	end

	if frame.backdrop then
		frame.backdrop:Style("Outside")
	end

	-- Not sure about this tooltip tho -- Merathilis
	if E.private.skins.blizzard.tooltip ~= true then
		return
	end
	ContributionBuffTooltip:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_Contribution", "BenikUI_Contribution", style_Contribution)

-- DeathRecap
local function style_DeathRecap()
	if E.private.skins.blizzard.deathRecap ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.DeathRecapFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_DeathRecap", "BenikUI_DeathRecap", style_DeathRecap)

-- EncounterJournal
local function style_EncounterJournal()
	if E.private.skins.blizzard.encounterjournal ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.EncounterJournal:Style("Small")

	local Buttons = {
		_G.EncounterJournalInstanceSelectSuggestTab,
		_G.EncounterJournalInstanceSelectDungeonTab,
		_G.EncounterJournalInstanceSelectRaidTab,
		_G.EncounterJournalInstanceSelectLootJournalTab
	}

	for _, Button in pairs(Buttons) do
		if Button then
			local text = Button:GetFontString()
			if text then
				text:ClearAllPoints()
				text:Point("CENTER", Button, "CENTER", 0, 2)
				text:FontTemplate(nil, 12)
			end
		end
	end

	if E.private.skins.blizzard.tooltip ~= true then
		return
	end
	_G.EncounterJournalTooltip:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_EncounterJournal", "BenikUI_EncounterJournal", style_EncounterJournal)

-- FlightMap
local function style_FlightMap()
	if E.private.skins.blizzard.taxi ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.FlightMapFrame.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_FlightMap", "BenikUI_FlightMap", style_FlightMap)

-- Garrison Style
local fRecruits = {}
local function style_GarrisonUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.garrison ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.OrderHallMissionFrame:Style("Small")
	if _G.AdventureMapQuestChoiceDialog.backdrop then
		_G.AdventureMapQuestChoiceDialog.backdrop:Style("Outside")
	end

	_G.BFAMissionFrame.backdrop:Style("Outside")

	GarrisonCapacitiveDisplayFrame.IncrementButton:ClearAllPoints()
	GarrisonCapacitiveDisplayFrame.IncrementButton:Point("LEFT", GarrisonCapacitiveDisplayFrame.Count, "RIGHT", 4, 0)
	if E.private.skins.blizzard.tooltip then
		_G.GarrisonFollowerAbilityWithoutCountersTooltip:Style("Outside")
		_G.GarrisonFollowerMissionAbilityWithoutCountersTooltip:Style("Outside")
	end

	_G.GarrisonMissionFrame.backdrop:Style("Outside")
	_G.GarrisonLandingPage.backdrop:Style("Outside")
	_G.GarrisonBuildingFrame.backdrop:Style("Outside")
	_G.GarrisonCapacitiveDisplayFrame.backdrop:Style("Outside")

	-- ShipYard
	_G.GarrisonShipyardFrame.backdrop:Style("Outside")
	-- Tooltips
	if E.private.skins.blizzard.tooltip then
		_G.GarrisonShipyardMapMissionTooltip:Style("Outside")
		_G.GarrisonBonusAreaTooltip:StripTextures()
		_G.GarrisonBonusAreaTooltip:CreateBackdrop("Transparent")
		_G.GarrisonBonusAreaTooltip.backdrop:Style("Outside")
		_G.GarrisonMissionMechanicFollowerCounterTooltip:Style("Outside")
		_G.GarrisonMissionMechanicTooltip:Style("Outside")
		_G.FloatingGarrisonShipyardFollowerTooltip:Style("Outside")
		_G.GarrisonShipyardFollowerTooltip:Style("Outside")
		_G.GarrisonBuildingFrame.BuildingLevelTooltip:Style("Outside")
		_G.GarrisonFollowerAbilityTooltip:Style("Outside")
		_G.GarrisonMissionMechanicTooltip:StripTextures()
		_G.GarrisonMissionMechanicTooltip:CreateBackdrop("Transparent")
		_G.GarrisonMissionMechanicTooltip.backdrop:Style("Outside")
		_G.GarrisonMissionMechanicFollowerCounterTooltip:StripTextures()
		_G.GarrisonMissionMechanicFollowerCounterTooltip:CreateBackdrop("Transparent")
		_G.GarrisonMissionMechanicFollowerCounterTooltip.backdrop:Style("Outside")
		_G.FloatingGarrisonFollowerTooltip:Style("Outside")
		_G.GarrisonFollowerTooltip:Style("Outside")
	end

	-- Garrison Monument
	local GMonument = _G.GarrisonMonumentFrame
	GMonument:StripTextures()
	GMonument:CreateBackdrop("Transparent")
	GMonument:Style("Small")
	GMonument:ClearAllPoints()
	GMonument:Point("CENTER", E.UIParent, "CENTER", 0, -200)
	GMonument:Height(70)
	GMonument.RightBtn:Size(25, 25)
	GMonument.LeftBtn:Size(25, 25)

	-- Follower recruiting (available at the Inn)
	_G.GarrisonRecruiterFrame.backdrop:Style("Outside")
	S:HandleDropDownBox(_G.GarrisonRecruiterFramePickThreatDropDown)
	local rBtn = _G.GarrisonRecruiterFrame.Pick.ChooseRecruits
	rBtn:ClearAllPoints()
	rBtn:Point("BOTTOM", _G.GarrisonRecruiterFrame.backdrop, "BOTTOM", 0, 30)
	S:HandleButton(rBtn)

	local GRecruitSelect = _G.GarrisonRecruitSelectFrame
	GRecruitSelect:StripTextures()
	GRecruitSelect:CreateBackdrop("Transparent")
	GRecruitSelect.backdrop:Style("Outside")
	S:HandleCloseButton(GRecruitSelect.CloseButton)
	S:HandleEditBox(GRecruitSelect.FollowerList.SearchBox)

	GRecruitSelect.FollowerList:StripTextures()
	S:HandleScrollBar(_G.GarrisonRecruitSelectFrameListScrollFrameScrollBar)
	GRecruitSelect.FollowerSelection:StripTextures()

	GRecruitSelect.FollowerSelection.Recruit1:CreateBackdrop()
	GRecruitSelect.FollowerSelection.Recruit1:ClearAllPoints()
	GRecruitSelect.FollowerSelection.Recruit1:Point("LEFT", GRecruitSelect.FollowerSelection, "LEFT", 6, 0)
	GRecruitSelect.FollowerSelection.Recruit2:CreateBackdrop()
	GRecruitSelect.FollowerSelection.Recruit2:ClearAllPoints()
	GRecruitSelect.FollowerSelection.Recruit2:Point("LEFT", GRecruitSelect.FollowerSelection.Recruit1, "RIGHT", 6, 0)
	GRecruitSelect.FollowerSelection.Recruit3:CreateBackdrop()
	GRecruitSelect.FollowerSelection.Recruit3:ClearAllPoints()
	GRecruitSelect.FollowerSelection.Recruit3:Point("LEFT", GRecruitSelect.FollowerSelection.Recruit2, "RIGHT", 6, 0)

	for i = 1, 3 do
		fRecruits[i] = CreateFrame("Frame", nil, E.UIParent)
		fRecruits[i]:SetTemplate("Default", true)
		fRecruits[i]:Size(190, 60)
		if i == 1 then
			fRecruits[i]:SetParent(GRecruitSelect.FollowerSelection.Recruit1)
			fRecruits[i]:Point("TOP", GRecruitSelect.FollowerSelection.Recruit1.backdrop, "TOP")
			fRecruits[i]:SetFrameLevel(GRecruitSelect.FollowerSelection.Recruit1:GetFrameLevel())
			GRecruitSelect.FollowerSelection.Recruit1.Class:Size(60, 58)
		elseif i == 2 then
			fRecruits[i]:SetParent(GRecruitSelect.FollowerSelection.Recruit2)
			fRecruits[i]:Point("TOP", GRecruitSelect.FollowerSelection.Recruit2.backdrop, "TOP")
			fRecruits[i]:SetFrameLevel(GRecruitSelect.FollowerSelection.Recruit2:GetFrameLevel())
			GRecruitSelect.FollowerSelection.Recruit2.Class:Size(60, 58)
		elseif i == 3 then
			fRecruits[i]:SetParent(GRecruitSelect.FollowerSelection.Recruit3)
			fRecruits[i]:Point("TOP", GRecruitSelect.FollowerSelection.Recruit3.backdrop, "TOP")
			fRecruits[i]:SetFrameLevel(GRecruitSelect.FollowerSelection.Recruit3:GetFrameLevel())
			GRecruitSelect.FollowerSelection.Recruit3.Class:Size(60, 58)
		end
	end
	S:HandleButton(GRecruitSelect.FollowerSelection.Recruit1.HireRecruits)
	S:HandleButton(GRecruitSelect.FollowerSelection.Recruit2.HireRecruits)
	S:HandleButton(GRecruitSelect.FollowerSelection.Recruit3.HireRecruits)
end
S:AddCallbackForAddon("Blizzard_GarrisonUI", "BenikUI_GarrisonUI", style_GarrisonUI)

-- GuildBankUI
local function style_GuildBankUI()
	if E.private.skins.blizzard.gbank ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.GuildBankFrame:Style("Outside")
	for i = 1, 8 do
		local button = _G["GuildBankTab" .. i .. "Button"]
		local texture = _G["GuildBankTab" .. i .. "ButtonIconTexture"]
		button:Style("Inside")
		texture:SetTexCoord(unpack(BUI.TexCoords))
	end
end
S:AddCallbackForAddon("Blizzard_GuildBankUI", "BenikUI_GuildBankUI", style_GuildBankUI)

-- GuildUI
local function style_GuildUI()
	if E.private.skins.blizzard.guild ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local GuildFrames = {
		_G.GuildFrame,
		_G.GuildMemberDetailFrame,
		_G.GuildTextEditFrame,
		_G.GuildLogFrame,
		_G.GuildNewsFiltersFrame
	}
	for _, frame in pairs(GuildFrames) do
		if frame and not frame.style then
			frame:Style("Outside")
		end
	end
end
S:AddCallbackForAddon("Blizzard_GuildUI", "BenikUI_GuildUI", style_GuildUI)

-- GuildControlUI
local function style_GuildControlUI()
	if E.private.skins.blizzard.guildcontrol ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.GuildControlUI:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_GuildControlUI", "BenikUI_GuildControlUI", style_GuildControlUI)

-- IslandsQueueUI
local function style_IslandsQueueUI()
	if E.private.skins.blizzard.IslandQueue ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.IslandsQueueFrame.backdrop:Style("Outside")

	-- tooltip
	if E.private.skins.blizzard.tooltip ~= true then
		return
	end
	_G.IslandsQueueFrameTooltip:GetParent():GetParent():HookScript(
		"OnShow",
		function(self)
			if not self.style then
				self:Style("Outside")
			end
		end
	)
end
S:AddCallbackForAddon("Blizzard_IslandsQueueUI", "BenikUI_IslandsQueueUI", style_IslandsQueueUI)

-- InspectUI
local function style_InspectUI()
	if E.private.skins.blizzard.inspect ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.InspectFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_InspectUI", "BenikUI_InspectUI", style_InspectUI)

-- ItemInteractionUI
local function style_ItemInteractionUI()
	if E.private.skins.blizzard.ItemInteraction ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ItemInteractionFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_ItemInteractionUI", "BenikUI_ItemInteractionUI", style_ItemInteractionUI)

-- ItemSocketingUI
local function style_ItemSocketingUI()
	if E.private.skins.blizzard.socket ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ItemSocketingFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_ItemSocketingUI", "BenikUI_ItemSocketingUI", style_ItemSocketingUI)

-- ItemUpgradeUI
local function style_ItemUpgradeUI()
	if E.private.skins.blizzard.itemUpgrade ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ItemUpgradeFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_ItemUpgradeUI", "BenikUI_ItemUpgradeUI", style_ItemUpgradeUI)

-- LookingForGuildUI
local function style_LookingForGuildUI()
	if E.private.skins.blizzard.lfguild ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.LookingForGuildFrame:Style("Outside")
end

local function LoadStyle()
	if LookingForGuildFrame then
		--Frame already created
		style_LookingForGuildUI()
	else
		--Frame not created yet, wait until it is
		hooksecurefunc("LookingForGuildFrame_CreateUIElements", style_LookingForGuildUI)
	end
end
S:AddCallbackForAddon("Blizzard_LookingForGuildUI", "BenikUI_LookingForGuildUI", LoadStyle)

-- MacroUI
local function style_MacroUI()
	if E.private.skins.blizzard.macro ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.MacroFrame:Style("Outside")
	_G.MacroPopupFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_MacroUI", "BenikUI_MacroUI", style_MacroUI)

-- ObliterumUI
local function style_ObliterumUI()
	if E.private.skins.blizzard.Obliterum ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ObliterumForgeFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_ObliterumUI", "BenikUI_ObliterumUI", style_ObliterumUI)

-- OrderHallUI
local function style_OrderHallUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.OrderHallTalentFrame:HookScript(
		"OnShow",
		function(self)
			if self.styled then
				return
			end
			self:Style("Outside")
			self.styled = true
		end
	)
end
S:AddCallbackForAddon("Blizzard_OrderHallUI", "BenikUI_OrderHallUI", style_OrderHallUI)

-- PVPUI
local function style_PVPUI()
	if E.private.skins.blizzard.pvp ~= true or E.private.skins.blizzard.tooltip ~= true or
		E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ConquestTooltip:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_PVPUI", "BenikUI_PVPUI", style_PVPUI)

-- QuestChoice
local function style_QuestChoice()
	if E.private.skins.blizzard.questChoice ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.QuestChoiceFrame:Style("Small")
end
S:AddCallbackForAddon("Blizzard_QuestChoice", "BenikUI_QuestChoice", style_QuestChoice)

-- ScrappingMachine
local function style_ScrappingMachineUI()
	if E.private.skins.blizzard.Scrapping ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ScrappingMachineFrame.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_ScrappingMachineUI", "BenikUI_ScrappingMachineUI", style_ScrappingMachineUI)

-- TalentUI
local function style_TalentUI()
	if E.private.skins.blizzard.talent ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.PlayerTalentFrame:Style("Outside")
	for i = 1, 2 do
		local tab = _G["PlayerSpecTab" .. i]
		if tab then
			tab:Style("Inside")
			tab.style:SetFrameLevel(5)
			tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
			tab:GetNormalTexture():SetInside()
		end
	end
	PlayerTalentFrameTalents.PvpTalentFrame.TalentList.backdrop:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_TalentUI", "BenikUI_TalentUI", style_TalentUI)

-- TalkingHeadUI
local function style_TalkingHeadUI()
	if E.private.skins.blizzard.talkinghead ~= true or E.db.benikuiSkins.variousSkins.talkingHead ~= true or
		E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.TalkingHeadFrame
	if frame then
		-- Hide ElvUI's backdrop
		if frame.backdrop then
			frame.backdrop:Hide()
		end

		frame.BackgroundFrame:CreateBackdrop("Transparent")
		frame.BackgroundFrame.backdrop:SetAllPoints()
		frame.BackgroundFrame.backdrop:CreateWideShadow() -- to hide the borders not showing due to scaling

		frame.BackgroundFrame:Style("Inside")
		if frame.BackgroundFrame.style then
			frame.BackgroundFrame.style:ClearAllPoints()
			frame.BackgroundFrame.style:Point("TOPLEFT", frame, "TOPLEFT", -(E.PixelMode and 0 or 2), (E.PixelMode and -5 or -7))
			frame.BackgroundFrame.style:Point(
				"BOTTOMRIGHT",
				frame,
				"TOPRIGHT",
				(E.PixelMode and -1 or 1),
				(E.PixelMode and 0 or -2)
			)
		end
	end
end
S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "BenikUI_TalkingHeadUI", style_TalkingHeadUI)

-- TimeManager (although is LOD in ElvUI, the style color doesn't apply)
local function style_TimeManager()
	if E.private.skins.blizzard.timemanager ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.TimeManagerFrame:Style("Outside")
	_G.StopwatchFrame.backdrop:Style("Outside")
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript(
	"OnEvent",
	function(self, event)
		self:UnregisterEvent(event)
		style_TimeManager()
	end
)

-- TradeSkillUI
local function style_TradeSkillUI()
	if E.private.skins.blizzard.trade ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.TradeSkillFrame
	frame:Style("Outside")
	frame.DetailsFrame.GuildFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_TradeSkillUI", "BenikUI_TradeSkillUI", style_TradeSkillUI)

-- TrainerUI
local function style_TrainerUI()
	if E.private.skins.blizzard.trainer ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	_G.ClassTrainerFrame:Style("Outside")
end
S:AddCallbackForAddon("Blizzard_TrainerUI", "BenikUI_TrainerUI", style_TrainerUI)

-- VoidStorageUI
local function style_VoidStorageUI()
	if E.private.skins.blizzard.voidstorage ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.VoidStorageFrame
	frame:Style("Outside")
	for i = 1, 2 do
		local tab = frame["Page" .. i]
		if not tab.style then
			tab:Style("Inside")
			tab:GetNormalTexture():SetTexCoord(unpack(BUI.TexCoords))
			tab:GetNormalTexture():SetInside()
		end
	end
end
S:AddCallbackForAddon("Blizzard_VoidStorageUI", "BenikUI_VoidStorageUI", style_VoidStorageUI)

-- WarboardUI
local function style_WarboardUI()
	if E.private.skins.blizzard.Warboard ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	local frame = _G.WarboardQuestChoiceFrame
	frame.backdrop:Style("Outside")
	frame.backdrop.style:SetFrameLevel(1)
end
S:AddCallbackForAddon("Blizzard_WarboardUI", "BenikUI_WarboardUI", style_WarboardUI)

-- UIWidgets
local function style_UIWidgets()
	if E.private.skins.blizzard.Warboard ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end
end
S:AddCallbackForAddon("Blizzard_UIWidgets", "BenikUI_UIWidgets", style_UIWidgets)
