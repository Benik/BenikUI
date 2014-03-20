local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

local SPACING = (E.PixelMode and 1 or 5)
-- to do/check PetBattle frames (petbattle.lua)
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



-- Minor fixes
local function AchievFixes()
	
	if AchievementFrameCloseButton then
		AchievementFrameCloseButton:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", 4, 5) -- reposition the button a bit
	end
	
	if AchievementFrameFilterDropDown then
		AchievementFrameFilterDropDown:Point("TOPRIGHT", AchievementFrame, "TOPRIGHT", -44, 2) -- reposition the dropdown a bit
	end
end

local function GuildBankFixes()
	for i = 1, 8 do
		local button = _G["GuildBankTab"..i.."Button"]
		local texture = _G["GuildBankTab"..i.."ButtonIconTexture"]
		button:StyleInFrame()
		texture:SetTexCoord(unpack(BUI.TexCoords))
	end
end

local function PlayerTalentFixes()
	for i = 1, 2 do
		local tab = _G['PlayerSpecTab'..i]
		tab:StyleInFrame()
	end
end

local function GuildFrames()
	GuildMemberDetailFrame:StyleSkins()
end

local BuiBlizz = CreateFrame("Frame")
BuiBlizz:RegisterEvent("ADDON_LOADED")
BuiBlizz:SetScript("OnEvent",function(self, event, addon)
	for i, v in ipairs( BlizzUiFrames ) do
	local blizzAddon, blizzFrame, elvoption = unpack( v )
		if event == "ADDON_LOADED" and addon == blizzAddon then
			if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard[elvoption] ~= true then return end
			if blizzFrame then
				BUI:StyleBlizSkins(nil, blizzFrame) -- Style them all
				-- Fixes
				if addon == "Blizzard_AchievementUI" then AchievFixes() end
				if addon == "Blizzard_GuildBankUI" then GuildBankFixes() end
				if addon == "Blizzard_TalentUI" then PlayerTalentFixes() end
				if addon == "Blizzard_GuildUI" then GuildFrames() end
			end
		end
	end
	if addon == "Blizzard_EncounterJournal" then
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true then return end
		BUI:StyleSmallerFrames(nil, EncounterJournal)
	end
end)
