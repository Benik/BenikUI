local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded

local function LoadSkin()
	if E.db.benikui.general.benikuiStyle ~= true then return end

	if E.private.skins.blizzard.enable ~= true then
		return
	end

	local db = E.private.skins.blizzard

	if db.addonManager then
		_G.AddonList:BuiStyle()
	end

	if db.blizzardOptions then
		_G.SettingsPanel.backdrop:BuiStyle()
		_G.ChatConfigFrame:BuiStyle()
		_G.ReadyCheckFrame:BuiStyle()
		_G.ReadyCheckListenerFrame:BuiStyle()
		_G.SplashFrame:CreateBackdrop("Transparent")
		_G.SplashFrame.backdrop:BuiStyle()
	end

	if db.character then
		_G.PaperDollFrame:BuiStyle()
		_G.ReputationFrame:BuiStyle()
		_G.TokenFrame:BuiStyle()
		_G.CurrencyTransferLog:BuiStyle()
		_G.TokenFramePopup:BuiStyle()
	end

	if db.dressingroom then
		_G.DressUpFrame:BuiStyle()
		_G.DressUpFrame.SetSelectionPanel:BuiStyle()
	end

	if db.editor then
		_G.EditModeManagerFrame.backdrop:BuiStyle()
		_G.EditModeUnsavedChangesDialog.backdrop:BuiStyle()
		_G.EditModeImportLayoutDialog.backdrop:BuiStyle()
		_G.EditModeSystemSettingsDialog.backdrop:BuiStyle()
	end

	if db.friends then
		_G.AddFriendFrame:BuiStyle()
		_G.FriendsFrame:BuiStyle()
		_G.FriendsFrame.IgnoreListWindow:BuiStyle()
		_G.FriendsFriendsFrame:BuiStyle()
		_G.QuickJoinRoleSelectionFrame:BuiStyle()
		_G.RecruitAFriendFrame:BuiStyle()
	end

	if db.gossip then
		_G.GossipFrame:BuiStyle()
		_G.ItemTextFrame:BuiStyle()
	end

	if db.guild then
		_G.GuildInviteFrame:BuiStyle()
	end

	if db.guildregistrar then
		_G.GuildRegistrarFrame:BuiStyle()
	end

	if db.help then
		_G.HelpFrame.backdrop:BuiStyle()
	end

	if db.lfg then
		_G.LFGInvitePopup:BuiStyle()
		_G.LFGDungeonReadyDialog:BuiStyle()
		_G.LFGDungeonReadyStatus:BuiStyle()
		_G.LFGListApplicationDialog:BuiStyle()
		_G.LFGListInviteDialog:BuiStyle()
		_G.PVEFrame:BuiStyle()

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
		_G.LootFrame:BuiStyle()
		_G.MasterLooterFrame:BuiStyle()
		_G.BonusRollFrame:BuiStyle()
		_G.GroupLootHistoryFrame:BuiStyle()

		if BUI.ShadowMode then
			_G.GroupLootHistoryFrame.ResizeButton:CreateSoftShadow()
		end
	end

	if db.mail then
		_G.MailFrame:BuiStyle()
		_G.OpenMailFrame:BuiStyle()
	end

	if db.merchant then
		if _G.MerchantFrame then
			_G.MerchantFrame:BuiStyle()
		end
	end

	if db.misc then
		local ChatMenus = {
			_G.ChatMenu,
			_G.EmoteMenu,
			_G.LanguageMenu,
			_G.VoiceMacroMenu,
		}

		for _, menu in next, ChatMenus do
			if menu then
				menu:BuiStyle()
			end
		end

		_G.BNToastFrame:BuiStyle()
		_G.GameMenuFrame:BuiStyle()
		_G.GhostFrame:BuiStyle()
		_G.LFDRoleCheckPopup:BuiStyle()
		_G.ReportFrame:BuiStyle()
		_G.QueueStatusFrame:BuiStyle()
		_G.ReportCheatingDialog:BuiStyle()
		_G.SideDressUpFrame:BuiStyle()
		_G.StackSplitFrame:BuiStyle()
		_G.StaticPopup1:BuiStyle()
		_G.StaticPopup2:BuiStyle()
		_G.StaticPopup3:BuiStyle()
		_G.StaticPopup4:BuiStyle()
		_G.TicketStatusFrameButton:BuiStyle()

		hooksecurefunc('UIDropDownMenu_CreateFrames', function(level)
			local listFrame = _G['DropDownList'..level];
			local listFrameName = listFrame:GetName();
			local Backdrop = _G[listFrameName..'Backdrop']
			Backdrop:BuiStyle()

			local menuBackdrop = _G[listFrameName..'MenuBackdrop']
			menuBackdrop:BuiStyle()
		end)
	end

	if db.nonraid then
		_G.RaidInfoFrame:BuiStyle()
	end

	if db.petition then
		_G.PetitionFrame:BuiStyle()
	end

	if db.pvp then
		_G.PVPReadyDialog:BuiStyle()
	end

	if db.quest then
		_G.QuestFrame:BuiStyle()
		_G.QuestLogPopupDetailFrame:BuiStyle()

		local questModelScene = _G.QuestModelScene
		questModelScene.backdrop:BuiStyle()
		questModelScene.ModelTextFrame:ClearAllPoints()
		questModelScene.ModelTextFrame:Point("TOP", questModelScene.backdrop, "BOTTOM", 0, -4)

		if E.db.benikui.general.shadows then
			questModelScene.ModelTextFrame.backdrop:CreateSoftShadow()
		end
	end

	if db.stable then
		_G.StableFrame:BuiStyle()
	end

	if db.tabard then
		_G.TabardFrame:BuiStyle()
	end

	if db.talkinghead then
		local talkingHeadFrame = _G.TalkingHeadFrame

		if E.db.general.talkingHeadFrameBackdrop then
			talkingHeadFrame:BuiStyle()
		else
			talkingHeadFrame.MainFrame.Model.backdrop:BuiStyle()
		end
	end

	if db.taxi then
		_G.TaxiFrame:BuiStyle()
	end

	if db.trade then
		_G.TradeFrame:BuiStyle()
	end

	if db.worldmap then
		local questMapFrame = _G.QuestMapFrame
		local tabs = {
			questMapFrame.QuestsTab,
			questMapFrame.EventsTab,
			questMapFrame.MapLegendTab
		}
		for _, tab in next, tabs do
			tab.backdrop:SetTemplate('Transparent')

			if E.db.benikui.general.shadows then
				tab.backdrop:CreateSoftShadow()
			end
		end
	end

	if IsAddOnLoaded('ColorPickerPlus') then return end
	_G.ColorPickerFrame:HookScript('OnShow', function(frame)
		if frame and not frame.style then
			frame:BuiStyle()
		end
	end)
end
S:AddCallback("BenikUI_styleFreeBlizzardFrames", LoadSkin)

-- WorldMap
function mod:styleWorldMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.db.benikui.general.benikuiStyle ~= true then
		return
	end

	local mapFrame = _G.WorldMapFrame
	if not mapFrame.backdrop.style then
		mapFrame.backdrop:BuiStyle()
	end
end