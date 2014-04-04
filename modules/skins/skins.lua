local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUIS = E:NewModule('BuiSkins', "AceHook-3.0", 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local AS = E:GetModule('AddOnSkins', true)

local SPACING = (E.PixelMode and 1 or 5)

-----------------------------------------------

local FreeBlizzFrames = {
	AudioOptionsFrame,
	BNToastFrame,
	ChatConfigFrame,
	ClassTrainerFrame,
	ConsolidatedBuffsTooltip, -- check
	DressUpFrame,
	ElvUI_StaticPopup1,
	ElvUI_StaticPopup2,
	ElvUI_StaticPopup3,
	FriendsFrame,
	GameMenuFrame,
	GossipFrame,
	GuildRegistrarFrame,
	InterfaceOptionsFrame,
	ItemRefTooltip,
	LFGDungeonReadyPopup,
	LFGDungeonReadyDialog,
	LFGDungeonReadyStatus,
	MailFrame,
	MerchantFrame,
	OpenMailFrame,
	PaperDollItemsFrame,
	PetitionFrame, -- check
	PetJournalParent,
	PetPaperDollFrame,
	PetStableFrame,
	QuestLogDetailFrame,
	QuestLogFrame,
	QueueStatusFrame,
	RaidInfoFrame,
	ReadyCheckFrame,
	ReadyCheckListenerFrame,
	ReputationDetailFrame,
	ReputationFrame,
	SpellBookFrame,
	StackSplitFrame,
	StaticPopup1,
	StaticPopup2,
	StaticPopup3,
	TabardFrame,
	TicketStatusFrameButton, -- check
	TokenFrame,
	TokenFramePopup,
	TradeFrame, -- check
	TransmogrifyConfirmationPopup,
	VideoOptionsFrame,
	WorldMapFrame, -- checked not loading on big map
	WorldStateScoreScrollFrame, -- check
}

-------------------------------------
-- the style is smaller by 1-2 pixels
-------------------------------------
local FreeBlizzSmallerFrames = {
	HelpFrame,
	PVEFrame,
	QuestFrame,
	QuestNPCModel,
	RaidBrowserFrame,
	TaxiFrame,
}

local BlizzUiFrames = {
	--{"BlizzUIname, "FrameToBeStyled, "ElvUIdisableSkinOption"}
	{"Blizzard_AchievementUI", "AchievementFrame", "achievement"},
	{"Blizzard_ArchaeologyUI", "ArchaeologyFrame", "archaeology"},
	{"Blizzard_AuctionUI", "AuctionFrame", "auctionhouse"},
	{"Blizzard_BarbershopUI", "BarberShopFrame", "barber"},
	{"Blizzard_BattlefieldMinimap", "BattlefieldMinimap", "bgmap"}, -- check
	{"Blizzard_BindingUI", "KeyBindingFrame", "binding"},
	{"Blizzard_BlackMarketUI", "BlackMarketFrame", "bmah"}, -- check
	{"Blizzard_Calendar", "CalendarFrame", "calendar"},
	{"Blizzard_Calendar", "CalendarViewEventFrame", "calendar"},
	{"Blizzard_Calendar", "CalendarViewHolidayFrame", "calendar"},
	{"Blizzard_GuildBankUI", "GuildBankFrame", "gbank"},
	{"Blizzard_GuildUI", "GuildFrame", "guild"}, -- check
	{"Blizzard_GuildControlUI", "GuildControlUI", "guildcontrol"}, -- check
	{"Blizzard_InspectUI", "InspectFrame", "inspect"},
	{"Blizzard_ItemAlterationUI", "TransmogrifyFrame", "transmogrify"},
	{"Blizzard_ItemUpgradeUI", "ItemUpgradeFrame", "itemUpgrade"},
	{"Blizzard_LookingForGuildUI", "LookingForGuildFrame", "lfguild"},
	{"Blizzard_MacroUI", "MacroFrame", "macro"},
	{"Blizzard_PetJournal", "PetJournalParent", "mounts"},
	{"Blizzard_PVPUI", "PVPUIFrame", "pvp"},
	{"Blizzard_ReforgingUI", "ReforgingFrame", "reforge"},
	{"Blizzard_ItemSocketingUI", "ItemSocketingFrame", "socket"},
	{"Blizzard_TalentUI", "PlayerTalentFrame", "talent"},
	{"Blizzard_TimeManager", "TimeManagerFrame", "timemanager"},
	{"Blizzard_TradeSkillUI", "TradeSkillFrame", "trade"},
	{"Blizzard_TrainerUI", "ClassTrainerFrame", "trainer"},
	{"Blizzard_VoidStorageUI", "VoidStorageFrame", "voidstorage"},
}

function BUI:StyleBlizzard(parent, ...)
	local frame = CreateFrame('Frame', parent..'Decor', E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', SPACING, 5)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', -SPACING, 0)
end

function BUIS:BlizzardUI_LOD_Skins(event, addon)
	for i, v in ipairs(BlizzUiFrames) do
		local blizzAddon, blizzFrame, elvoption = unpack( v )
		if (event == "ADDON_LOADED" and addon == blizzAddon) then
			if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard[elvoption] ~= true then return end
			if blizzFrame then
				BUI:StyleBlizzard(blizzFrame)
				-- Fixes
				if addon == "Blizzard_AchievementUI" then
					if AchievementFrameCloseButton then
						AchievementFrameCloseButton:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", 4, 5) -- reposition the button a bit
					end
					if AchievementFrameFilterDropDown then
						AchievementFrameFilterDropDown:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", -44, 2) -- reposition the dropdown a bit
					end
				end
				if addon == "Blizzard_GuildBankUI" then
					for i = 1, 8 do
						local button = _G["GuildBankTab"..i.."Button"]
						local texture = _G["GuildBankTab"..i.."ButtonIconTexture"]
						button:Style('Inside')
						texture:SetTexCoord(unpack(BUI.TexCoords))
					end
				end
				if addon == "Blizzard_TalentUI" then 
					for i = 1, 2 do
						_G['PlayerSpecTab'..i]:Style('Inside')
					end
				end
				if addon == "Blizzard_GuildUI" then
					GuildMemberDetailFrame:Style('Outside')
				end
			end
		end
	end
	if addon == "Blizzard_EncounterJournal" then
		if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true then return end
		EncounterJournal:Style('Small')
	end
end

function BUIS:BenikUISkins()
	-- Blizzard Styles
	for _, frame in pairs(FreeBlizzFrames) do
		if frame then
			frame:Style('Outside')
		end
	end

	for _, frame in pairs(FreeBlizzSmallerFrames) do
		if frame then
			frame:Style('Small')
		end
	end

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
		for i = 1, MAX_SKILLLINE_TABS do
			local tab = _G["SpellBookSkillLineTab"..i]
			tab:Style('Inside')
		end
	end)

	-- Style Changes
	DressUpFrame.style:Point('TOPLEFT', DressUpFrame, 'TOPLEFT', 6, 5)
	DressUpFrame.style:Point('BOTTOMRIGHT', DressUpFrame, 'TOPRIGHT', -32, -1)

	MerchantFrame.style:Point('TOPLEFT', MerchantFrame, 'TOPLEFT', 6, 5)
	MerchantFrame.style:Point('BOTTOMRIGHT', MerchantFrame, 'TOPRIGHT', 2, -1)
	
	WorldMapFrame.style:Point('TOPLEFT', WorldMapFrame, 'TOPLEFT', 2, 6)
	WorldMapFrame.style:Point('BOTTOMRIGHT', WorldMapFrame, 'TOPRIGHT', 2, 1)

	-- AddOn Styles
	if IsAddOnLoaded('ElvUI_LocLite') then
		local framestoskin = {LocationLitePanel, XCoordsLite, YCoordsLite}
		for _, frame in pairs(framestoskin) do
			frame:Style('Outside')
		end
	end
	if IsAddOnLoaded('ElvUI_LocPlus') then
		local framestoskin = {LeftCoordDtPanel, RightCoordDtPanel, LocationPlusPanel, XCoordsPanel, YCoordsPanel}
		for _, frame in pairs(framestoskin) do
			frame:Style('Outside')
		end
	end
	if IsAddOnLoaded('ElvUI_SLE') then
		local bgs = {BottomBG, LeftBG, RightBG, ActionBG,}		
		for _, frame in pairs(bgs) do
			frame:Style('Outside')
		end
		
		local dts = {DP_1, DP_2, Top_Center, DP_3, DP_4, DP_5, Bottom_Panel, DP_6}
		for _, frame in pairs(dts) do
			frame:Style('Outside')
		end
		
		local other = {Main_Flares, Mark_Menu}
		for _, frame in pairs(other) do
			frame:Style('Outside')
		end
	end
end

function BUIS:Initialize()
	if AS then return end
	self:RegisterEvent('ADDON_LOADED', 'BlizzardUI_LOD_Skins')
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'BenikUISkins')
end


if AS then
	V['addonskins']['BenikUI'] = true -- Default added

	local function SkadaDecor()
		hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(self, win)
			local skada = win.bargroup
			skada.backdrop:Style('Outside')
			if win.db.enabletitle then
				skada.button:StripTextures()
			end
			if not skada.backdrop.ishooked then
				hooksecurefunc(AS, 'Embed_Check', function(self, message) -- Hook in a hook :P
					if E.private.addonskins.EmbedSystem and E.private.addonskins.EmbedSkada then
						skada.backdrop.style:Hide()
					else
						skada.backdrop.style:Show()
					end
				end)
				skada.backdrop.ishooked = true
			end
		end)
	end
	
	local function StyleRecount(name, parent, ...)
		local recountdecor = CreateFrame('Frame', name, E.UIParent)
		recountdecor:SetTemplate('Default', true)
		recountdecor:SetParent(parent)
		recountdecor:Point('TOPLEFT', parent, 'TOPLEFT', 0, -SPACING)
		recountdecor:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, -7)

		return recountdecor
	end

	local function RecountDecor()
	StyleRecount('recountMain', Recount_MainWindow)
	Recount_MainWindow.TitleBackground:StripTextures()
	Recount_ConfigWindow.TitleBackground:StripTextures()
	StyleRecount(nil, Recount_ConfigWindow)
	hooksecurefunc(Recount, 'ShowReport', function(self)
		if Recount_ReportWindow.TitleBackground then
			Recount_ReportWindow.TitleBackground:StripTextures()
			StyleRecount(nil, Recount_ReportWindow)
		end
	end)
	Recount_DetailWindow.TitleBackground:StripTextures()
	StyleRecount(nil, Recount_DetailWindow)
		hooksecurefunc(AS, 'Embed_Check', function(self, message)
			if E.private.addonskins.EmbedSystem and E.private.addonskins.EmbedRecount then
				recountMain:Hide()
			else
				recountMain:Show()
			end
		end)
	end
	
	local function TinyDPSDecor()
		tdpsFrame:Style('Outside')
	end
	
	local function AtlasLootDecor()
		if AtlasLootDefaultFrame then
			AtlasLootDefaultFrame:HookScript('OnShow', function(self) self:Style('Outside') end)
		end
	end
	
	local function AltoholicDecor()
		AltoholicFrame:Style('Outside')
	end

	local function BenikUISkins(self, event, addon)
		if event == 'ADDON_LOADED' then
			BUIS:BlizzardUI_LOD_Skins(event, addon)
		else
			BUIS:BenikUISkins()
		end
	end

    AS:RegisterSkin('BenikUI', BenikUISkins, 'ADDON_LOADED')
	if AS:CheckAddOn('Skada') then AS:RegisterSkin('SkadaSkin', SkadaDecor, 2) end
	if AS:CheckAddOn('Recount') then AS:RegisterSkin('RecountSkin', RecountDecor, 2) end
	if AS:CheckAddOn('TinyDPS') then AS:RegisterSkin('TinyDPSSkin', TinyDPSDecor, 2) end
	if AS:CheckAddOn('AtlasLoot') then AS:RegisterSkin('AtlasLootSkin', AtlasLootDecor, 2) end
	if AS:CheckAddOn('Altoholic') then AS:RegisterSkin('AltoholicSkin', AltoholicDecor, 2) end
end

E:RegisterModule(BUIS:GetName())
