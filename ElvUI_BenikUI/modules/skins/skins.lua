local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs, unpack = pairs, unpack
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local InCombatLockdown = InCombatLockdown

-- GLOBALS: hooksecurefunc

local MAX_STATIC_POPUPS = 4
local SPACING = (E.PixelMode and 1 or 3)

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
	
	if db.blizzardOptions then
		_G.AudioOptionsFrame:Style("Outside")
		_G.ChatConfigFrame:Style("Outside")
		_G.InterfaceOptionsFrame:Style("Outside")
		_G.ReadyCheckFrame:Style("Outside")
		_G.ReadyCheckListenerFrame:Style("Outside")
		if _G.SplashFrame then
			_G.SplashFrame:Style("Outside")
		end
		_G.VideoOptionsFrame:Style("Outside")
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
		_G.DressUpFrame:Style("Outside")

		if not _G.WardrobeOutfitEditFrame.style then
			_G.WardrobeOutfitEditFrame:Style("Outside")
		end
	end

	if db.friends then
		_G.AddFriendFrame.backdrop:Style("Outside")
		_G.FriendsFrame:Style("Outside")
		_G.FriendsFriendsFrame:Style("Outside")
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
	end

	if db.lfg then
		_G.LFGInvitePopup:Style("Outside")
		_G.LFGDungeonReadyDialog:Style("Outside")
		_G.LFGDungeonReadyStatus:Style("Outside")
		_G.LFGListApplicationDialog:Style("Outside")
		_G.LFGListInviteDialog:Style("Outside")
		_G.PVEFrame:Style("Outside")
		_G.PVPReadyDialog:Style("Outside")
		_G.RaidBrowserFrame:Style("Outside")
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
		if _G.MerchantFrame then
			_G.MerchantFrame.backdrop:Style("Outside")
		end
	end

	if db.misc then
		_G.BNToastFrame:Style("Outside")
		_G.ChatMenu:Style("Outside")
		_G.CinematicFrameCloseDialog:Style("Outside")
		_G.DropDownList1MenuBackdrop:Style("Outside")
		_G.DropDownList2MenuBackdrop:Style("Outside")
		_G.EmoteMenu:Style("Outside")
		_G.GameMenuFrame.backdrop:Style("Outside")
		_G.GhostFrame:Style("Outside")
		_G.GuildInviteFrame:Style("Outside")
		_G.LanguageMenu:Style("Outside")
		_G.LFDRoleCheckPopup:Style("Outside")
		_G.QueueStatusFrame:Style("Outside")
		_G.SideDressUpFrame:Style("Outside")
		_G.StackSplitFrame:Style("Outside")
		_G.StaticPopup1.backdrop:Style("Outside")
		_G.StaticPopup2.backdrop:Style("Outside")
		_G.StaticPopup3.backdrop:Style("Outside")
		_G.StaticPopup4.backdrop:Style("Outside")
		_G.TicketStatusFrameButton:Style("Outside")
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
		_G.QuestFrame:Style("Outside")
		_G.QuestLogPopupDetailFrame:Style("Outside")
		_G.QuestModelScene:Style("Outside")

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
		_G.TaxiFrame:Style("Outside")
	end

	if db.trade then
		_G.TradeFrame:Style("Outside")
	end
	
	_G.ColorPickerFrame:Style("Outside")
end
S:AddCallback("BenikUI_styleFreeBlizzardFrames", styleFreeBlizzardFrames)

-- SpellBook tabs shadow
local function styleSpellbook()
	if E.private.skins.blizzard.enable ~= true or BUI.ShadowMode ~= true or E.private.skins.blizzard.spellbook ~= true then
		return
	end

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs",
		function()
			for i = 1, MAX_SKILLLINE_TABS do
				local tab = _G['SpellBookSkillLineTab'..i]
				tab.backdrop:CreateSoftShadow()
			end
		end)
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
end

local function styleAddons()
	-- LocationPlus
	if BUI.LP and E.db.benikuiSkins.elvuiAddons.locplus then
		local framestoskin = {
			_G.LocPlusLeftDT,
			_G.LocPlusRightDT,
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
			_G.SLE_RaidMarkerBar,
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
			_G.MinimapButtonBar:Style("Outside")
		end

		if _G.RaidMarkerBar then
			_G.RaidMarkerBar:Style("Outside")
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
	bar:Style("Outside")
	if bar.textures then
		bar:StripTextures(true)
	end
end

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

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function StyleElvUIConfig()
	if not E.private.skins.ace3Enable or InCombatLockdown() then return end

	local frame = E:Config_GetWindow()
	if frame and not frame.style then
		frame:Style("Outside")
	end
end

function mod:StyleAcePopup()
	if not self.backdrop.style then
		self.backdrop:Style('Outside')
	end
end

local function StyleScriptErrorsFrame()
	local frame = _G.ScriptErrorsFrame
	if not frame.backdrop.style then
		frame.backdrop:Style('Outside')
	end
end

local function ScriptErrorsFrame()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.debug) then return end

	mod:SecureHookScript(_G.ScriptErrorsFrame, 'OnShow', StyleScriptErrorsFrame)
end
--S:AddCallback("BenikUI_ScriptErrorsFrame", ScriptErrorsFrame)

function mod:Initialize()
	VehicleExit()

	if E.db.benikui.general.benikuiStyle ~= true then return end

	mod:SkinDecursive()
	mod:SkinStoryline()

	StyleAltPowerBar()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ADDON_LOADED", "LoD_AddOns")
	hooksecurefunc(S, "Ace3_StylePopup", mod.StyleAcePopup)
	hooksecurefunc(E, "ToggleOptionsUI", StyleElvUIConfig)
end

BUI:RegisterModule(mod:GetName())