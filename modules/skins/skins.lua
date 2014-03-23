local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUIS = E:NewModule('BuiSkins', "AceHook-3.0", 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');

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
	ElvUITutorialWindow, -- nope
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
	PetStableFrame, -- check
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
	TradeFrame, -- check
	TransmogrifyConfirmationPopup,
	VideoOptionsFrame,
	--WorldMapFrame, -- checked not loading on big map, only small but decor shifts to the left
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

function BUIS:BlizzardUI_LOD_Skins(event, addon)
	for i, v in ipairs(BlizzUiFrames) do
		local blizzAddon, blizzFrame, elvoption = unpack( v )
		--if (event == "ADDON_LOADED" and addon == blizzAddon) or (blizzFrame and not blizzFrame.style) then
		if (event == "ADDON_LOADED" and addon == blizzAddon) then--or (blizzFrame and not blizzFrame.style) then
			if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard[elvoption] ~= true then return end
			if blizzFrame then
				--blizzFrame:Style('Skin') -- Style them all
				BUI:StyleBlizSkins(nil, blizzFrame)
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
	DressUpFrame.style:Point('TOPLEFT', DressUpFrame, 'TOPLEFT', 7, 5)
	DressUpFrame.style:Point('BOTTOMRIGHT', DressUpFrame, 'TOPRIGHT', -33, 0)

	MerchantFrame.style:Point('TOPLEFT', MerchantFrame, 'TOPLEFT', 7, 7)
	MerchantFrame.style:Point('BOTTOMRIGHT', MerchantFrame, 'TOPRIGHT', SPACING, 2)

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
end

function BUIS:Initialize()
	local AS = E:GetModule('AddOnSkins', true)
	--if not AS then  -- Integrate into AddOnSkins otherwise run the skin changes.
		--self:RegisterEvent('ADDON_LOADED', 'BlizzardUI_LOD_Skins')
		--self:RegisterEvent('PLAYER_ENTERING_WORLD', 'BenikUISkins')
		--return
	--end

	--[[
	-- If you want the Decor on always then you will have to uncomment and adjust the resize function for the embed otherwise just delete this comment section.
	function AS:EmbedSystem_WindowResize()
		if InCombatLockdown() then return end
		local DataTextSize = AS:CheckOption('EmbedLeftChat') and E.db.datatexts.leftChatPanel and LeftChatDataPanel:GetHeight() or E.db.datatexts.rightChatPanel and RightChatDataPanel:GetHeight() or 0
		local ChatTabSize = AS:CheckOption('EmbedBelowTop') and RightChatTab:GetHeight() or 0
		local Width = E.PixelMode and 6 or 10
		local Height = E.PixelMode and 2 or 4
		local Spacing = E.PixelMode and 6 or 8
		local Total = AS.SLE and (Spacing + ChatTabSize + (E.PixelMode and 3 or 5)) or ((E.PixelMode and 11 or 16) + ChatTabSize + DataTextSize)

		local ChatPanel = AS:CheckOption('EmbedLeftChat') and LeftChatPanel or RightChatPanel

		EmbedSystem_MainWindow:SetParent(ChatPanel)

		EmbedSystem_MainWindow:SetSize(ChatPanel:GetWidth() - Width, ChatPanel:GetHeight() - Total)
		EmbedSystem_LeftWindow:SetSize(AS:CheckOption('EmbedLeftWidth'), EmbedSystem_MainWindow:GetHeight())
		EmbedSystem_RightWindow:SetSize((EmbedSystem_MainWindow:GetWidth() - AS:CheckOption('EmbedLeftWidth')) - 1, EmbedSystem_MainWindow:GetHeight())

		EmbedSystem_LeftWindow:SetPoint('LEFT', EmbedSystem_MainWindow, 'LEFT', 0, 0)
		EmbedSystem_RightWindow:SetPoint('RIGHT', EmbedSystem_MainWindow, 'RIGHT', 0, 0)
		EmbedSystem_MainWindow:SetPoint('BOTTOM', ChatPanel, 'BOTTOM', 0, (AS.SLE and (Spacing - 1) or (Spacing + DataTextSize)))

		-- Dynamic Range
		if IsAddOnLoaded('ElvUI_Config') then
			E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.min = floor(EmbedSystem_MainWindow:GetWidth() * .25)
			E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.max = floor(EmbedSystem_MainWindow:GetWidth() * .75)
		end
	end]]
	

	local function SkadaDecor()
		if not AS:CheckAddOn('Skada') then return end
		hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(self, win)
			local skada = win.bargroup
			skada.backdrop:Style('Outside', 'skadaDecor')
			if win.db.enabletitle then
				skada.button:StripTextures()
			end
		end)
		hooksecurefunc(AS, 'Embed_Check', function(self, message)
			if E.private.addonskins.EmbedSystem and E.private.addonskins.EmbedSkada then
				skadaDecor:Hide()
			else
				skadaDecor:Show()
			end
		end)
	end

	local function RecountDecor()
		if not AS:CheckAddOn('Recount') then return end
		Recount_MainWindow.TitleBackground:StripTextures()
		Recount_ConfigWindow.TitleBackground:StripTextures()
		Recount_ConfigWindow:Style('Outside')
		hooksecurefunc(Recount, 'ShowReport', function(self)
			Recount_ReportWindow.TitleBackground:StripTextures()
			Recount_ReportWindow:Style('Outside')
		end)
		Recount_DetailWindow.TitleBackground:StripTextures()
		Recount_DetailWindow:Style('Outside')
		Recount_MainWindow:Style('Outside', 'RecountDecor')
		RecountDecor:Point('TOPLEFT', Recount_MainWindow, 'TOPLEFT', 0, -SPACING)
		RecountDecor:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, -7)
		hooksecurefunc(AS, 'Embed_Check', function(self, message)
			if E.private.addonskins.EmbedSystem and E.private.addonskins.EmbedRecount then
				RecountDecor:Hide()
			else
				RecountDecor:Show()
			end
		end)
	end

	local function BenikUISkins(event, addon)
		if event == 'ADDON_LOADED' then
			BUIS:BlizzardUI_LOD_Skins(event, addon)
		else
			BUIS:BenikUISkins()
		end
	end
	self:RegisterEvent('ADDON_LOADED', 'BlizzardUI_LOD_Skins')
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'BenikUISkins')
	AS:RegisterSkin('BenikUI', BenikUISkins, 'ADDON_LOADED')
	AS:RegisterSkin('SkadaSkin', SkadaDecor, 2) -- Priority 2 will run after my skin.
	AS:RegisterSkin('RecountSkin', RecountDecor, 2) -- Priority 2 will run after my skin.
end

E:RegisterModule(BUIS:GetName())
