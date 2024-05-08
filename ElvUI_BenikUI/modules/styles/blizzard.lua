local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs
local C_TimerAfter = C_Timer.After

local MAX_STATIC_POPUPS = 4

local function LoadSkin()
	if E.db.benikui.general.benikuiStyle ~= true then return end

	if E.private.skins.blizzard.enable ~= true then
		return
	end

	local db = E.private.skins.blizzard

	if db.addonManager then
		_G.AddonList:BuiStyle("Outside")
	end

	if db.blizzardOptions then
		_G.SettingsPanel.backdrop:BuiStyle("Outside")
		_G.ChatConfigFrame:BuiStyle("Outside")
		_G.ReadyCheckFrame:BuiStyle("Outside")
		_G.ReadyCheckListenerFrame:BuiStyle("Outside")
		_G.SplashFrame:CreateBackdrop("Transparent")
		_G.SplashFrame.backdrop:BuiStyle("Outside")
	end

	local function repUpdate()
		if _G.ReputationDetailFrame then
			_G.ReputationDetailFrame:BuiStyle("Outside")
		end
	end

	local function tokenUpdate()
		_G.TokenFramePopup:BuiStyle("Outside")
	end

	if db.character then
		_G.PaperDollFrame:BuiStyle("Outside")
		_G.ReputationFrame:BuiStyle("Outside")
		_G.TokenFrame:BuiStyle("Outside")
		hooksecurefunc('ReputationFrame_Update', repUpdate)
		hooksecurefunc('TokenFrame_Update', tokenUpdate)
	end

	if db.dressingroom then
		_G.DressUpFrame:BuiStyle("Outside")
		_G.DressUpFrame.OutfitDetailsPanel:BuiStyle("Outside")
		_G.WardrobeOutfitEditFrame:BuiStyle("Outside")
	end

	if db.editor then
		_G.EditModeManagerFrame.backdrop:BuiStyle("Outside")
		_G.EditModeNewLayoutDialog.backdrop:BuiStyle("Outside")
		_G.EditModeUnsavedChangesDialog.backdrop:BuiStyle("Outside")
		_G.EditModeImportLayoutDialog.backdrop:BuiStyle("Outside")
		_G.EditModeSystemSettingsDialog.backdrop:BuiStyle("Outside")
	end

	if db.friends then
		_G.AddFriendFrame:BuiStyle("Outside")
		_G.FriendsFrame:BuiStyle("Outside")
		_G.FriendsFriendsFrame:BuiStyle("Outside")
		_G.QuickJoinRoleSelectionFrame:BuiStyle("Outside")
		_G.RecruitAFriendFrame:BuiStyle("Outside")
	end

	if db.gossip then
		_G.GossipFrame:BuiStyle("Outside")
		_G.ItemTextFrame:BuiStyle("Outside")
	end

	if db.guild then
		_G.GuildInviteFrame:BuiStyle("Outside")
	end

	if db.guildregistrar then
		_G.GuildRegistrarFrame:BuiStyle("Outside")
	end

	if db.help then
		_G.HelpFrame.backdrop:BuiStyle("Outside")
	end

	if db.lfg then
		_G.LFGInvitePopup:BuiStyle("Outside")
		_G.LFGDungeonReadyDialog:BuiStyle("Outside")
		_G.LFGDungeonReadyStatus:BuiStyle("Outside")
		_G.LFGListApplicationDialog:BuiStyle("Outside")
		_G.LFGListInviteDialog:BuiStyle("Outside")
		_G.PVEFrame:BuiStyle("Outside")

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
		_G.LootFrame:BuiStyle("Outside")
		_G.MasterLooterFrame:BuiStyle("Outside")
		_G.BonusRollFrame:BuiStyle("Outside")
		_G.GroupLootHistoryFrame:BuiStyle("Outside")
		_G.GroupLootHistoryFrame.ResizeButton:CreateSoftShadow()
	end

	if db.mail then
		_G.MailFrame:BuiStyle("Outside")
		_G.OpenMailFrame:BuiStyle("Outside")
	end

	if db.merchant then
		if _G.MerchantFrame then
			_G.MerchantFrame:BuiStyle("Outside")
		end
	end

	if db.misc then
		local ChatMenus = {
			_G.ChatMenu,
			_G.EmoteMenu,
			_G.LanguageMenu,
			_G.VoiceMacroMenu,
		}

		for _, menu in pairs(ChatMenus) do
			if menu then
				menu:BuiStyle('Outside')
			end
		end

		_G.BNToastFrame:BuiStyle("Outside")
		--_G.CinematicFrameCloseDialog:BuiStyle("Outside")
		_G.GameMenuFrame:BuiStyle("Outside")
		_G.GhostFrame:BuiStyle("Outside")
		_G.LFDRoleCheckPopup:BuiStyle("Outside")
		_G.ReportFrame:BuiStyle("Outside")
		_G.QueueStatusFrame:BuiStyle("Outside")
		_G.ReportCheatingDialog:BuiStyle("Outside")
		_G.SideDressUpFrame:BuiStyle("Outside")
		_G.StackSplitFrame:BuiStyle("Outside")
		_G.StaticPopup1:BuiStyle("Outside")
		_G.StaticPopup2:BuiStyle("Outside")
		_G.StaticPopup3:BuiStyle("Outside")
		_G.StaticPopup4:BuiStyle("Outside")
		_G.TicketStatusFrameButton:BuiStyle("Outside")

		hooksecurefunc('UIDropDownMenu_CreateFrames', function(level)
			local listFrame = _G['DropDownList'..level];
			local listFrameName = listFrame:GetName();
			local Backdrop = _G[listFrameName..'Backdrop']
			Backdrop:BuiStyle("Outside")

			local menuBackdrop = _G[listFrameName..'MenuBackdrop']
			menuBackdrop:BuiStyle("Outside")
		end)

		local function StylePopups()
			for i = 1, MAX_STATIC_POPUPS do
				local frame = _G['ElvUI_StaticPopup'..i]
				if frame and not frame.style then
					frame:BuiStyle("Outside")
				end
			end
		end
		C_TimerAfter(1, StylePopups)
	end

	if db.nonraid then
		_G.RaidInfoFrame:BuiStyle("Outside")
	end

	if db.petition then
		_G.PetitionFrame:BuiStyle("Outside")
	end

	if db.pvp then
		_G.PVPReadyDialog:BuiStyle("Outside")
	end

	if db.quest then
		_G.QuestFrame:BuiStyle("Outside")
		_G.QuestLogPopupDetailFrame:BuiStyle("Outside")
		_G.QuestModelScene.backdrop:BuiStyle("Outside")

		_G.QuestNPCModelTextFrame:ClearAllPoints()
		_G.QuestNPCModelTextFrame:Point("TOP", _G.QuestModelScene.backdrop, "BOTTOM", 0, -4)
		_G.QuestNPCModelTextFrame.backdrop:CreateSoftShadow()
		_G.QuestNPCModelTextFrame.backdrop.shadow:SetShown(E.db.benikui.general.shadows)
	end

	if db.stable then
		_G.StableFrame:BuiStyle("Outside")
	end

	if db.spellbook then
		_G.SpellBookFrame:BuiStyle("Outside")
	end

	if db.tabard then
		_G.TabardFrame:BuiStyle("Outside")
	end

	if db.talkinghead then
		local TalkingHeadFrame = _G.TalkingHeadFrame

		if E.db.general.talkingHeadFrameBackdrop then
			TalkingHeadFrame:BuiStyle("Outside")
		else
			TalkingHeadFrame.MainFrame.Model.backdrop:BuiStyle("Outside")
		end
	end

	if db.taxi then
		_G.TaxiFrame:BuiStyle("Outside")
	end

	if db.trade then
		_G.TradeFrame:BuiStyle("Outside")
	end

	if IsAddOnLoaded('ColorPickerPlus') then return end
	_G.ColorPickerFrame:HookScript('OnShow', function(frame)
		if frame and not frame.style then
			frame:BuiStyle("Outside")
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
		mapFrame.backdrop:BuiStyle("Outside")
	end
end