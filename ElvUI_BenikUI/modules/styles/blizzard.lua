local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs

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
		_G.AudioOptionsFrame:BuiStyle("Outside")
		_G.ChatConfigFrame.backdrop:BuiStyle("Outside")
		_G.InterfaceOptionsFrame.backdrop:BuiStyle("Outside")
		_G.ReadyCheckFrame:BuiStyle("Outside")
		_G.ReadyCheckListenerFrame:BuiStyle("Outside")
		if _G.SplashFrame.backdrop then
			_G.SplashFrame.backdrop:BuiStyle("Outside")
		end
		_G.VideoOptionsFrame.backdrop:BuiStyle("Outside")
	end

	local function repUpdate()
		if _G.ReputationDetailFrame.backdrop then
			_G.ReputationDetailFrame.backdrop:BuiStyle("Outside")
		end
	end

	local function tokenUpdate()
		if _G.TokenFramePopup.backdrop then
			_G.TokenFramePopup.backdrop:BuiStyle("Outside")
		end
	end

	if db.character then
		_G.GearManagerDialogPopup.backdrop:BuiStyle("Outside")
		_G.PaperDollFrame:BuiStyle("Outside")
		_G.ReputationFrame:BuiStyle("Outside")
		_G.TokenFrame:BuiStyle("Outside")
		hooksecurefunc('ReputationFrame_Update', repUpdate)
		hooksecurefunc('TokenFrame_Update', tokenUpdate)
	end

	if db.dressingroom then
		_G.DressUpFrame:BuiStyle("Outside")

		if not _G.WardrobeOutfitEditFrame.style then
			_G.WardrobeOutfitEditFrame.backdrop:BuiStyle("Outside")
		end
	end

	if db.friends then
		_G.AddFriendFrame.backdrop:BuiStyle("Outside")
		_G.FriendsFrame:BuiStyle("Outside")
		_G.FriendsFriendsFrame.backdrop:BuiStyle("Outside")
		_G.QuickJoinRoleSelectionFrame.backdrop:BuiStyle("Outside")
		_G.RecruitAFriendFrame:BuiStyle("Outside")
	end

	if db.gossip then
		_G.GossipFrame.backdrop:BuiStyle("Outside")
		_G.ItemTextFrame.backdrop:BuiStyle("Outside")
	end

	if db.guild then
		_G.GuildInviteFrame.backdrop:BuiStyle("Outside")
	end

	if db.guildregistrar then
		_G.GuildRegistrarFrame:BuiStyle("Outside")
	end

	if db.help then
		_G.HelpFrame.backdrop:BuiStyle("Outside")
	end

	if db.lfg then
		_G.LFGInvitePopup.backdrop:BuiStyle("Outside")
		_G.LFGDungeonReadyDialog.backdrop:BuiStyle("Outside")
		_G.LFGDungeonReadyStatus.backdrop:BuiStyle("Outside")
		_G.LFGListApplicationDialog.backdrop:BuiStyle("Outside")
		_G.LFGListInviteDialog.backdrop:BuiStyle("Outside")
		_G.PVEFrame:BuiStyle("Outside")
		_G.RaidBrowserFrame.backdrop:BuiStyle("Outside")

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
		_G.MasterLooterFrame.backdrop:BuiStyle("Outside")
		_G.BonusRollFrame.backdrop:BuiStyle("Outside")
	end

	if db.mail then
		_G.MailFrame:BuiStyle("Outside")
		_G.OpenMailFrame:BuiStyle("Outside")
	end

	if db.merchant then
		if _G.MerchantFrame then
			_G.MerchantFrame.backdrop:BuiStyle("Outside")
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
		_G.GameMenuFrame.backdrop:BuiStyle("Outside")
		_G.GhostFrame:BuiStyle("Outside")
		_G.LFDRoleCheckPopup.backdrop:BuiStyle("Outside")
		_G.PlayerReportFrame.backdrop:BuiStyle("Outside")
		_G.QueueStatusFrame.backdrop:BuiStyle("Outside")
		_G.ReportCheatingDialog.backdrop:BuiStyle("Outside")
		_G.SideDressUpFrame.backdrop:BuiStyle("Outside")
		_G.StackSplitFrame.backdrop:BuiStyle("Outside")
		_G.StaticPopup1.backdrop:BuiStyle("Outside")
		_G.StaticPopup2.backdrop:BuiStyle("Outside")
		_G.StaticPopup3.backdrop:BuiStyle("Outside")
		_G.StaticPopup4.backdrop:BuiStyle("Outside")
		_G.TicketStatusFrameButton:BuiStyle("Outside")

		hooksecurefunc('UIDropDownMenu_CreateFrames', function(level)
			local listFrame = _G['DropDownList'..level];
			local listFrameName = listFrame:GetName();
			local Backdrop = _G[listFrameName..'Backdrop']
			Backdrop.backdrop:BuiStyle("Outside")

			local menuBackdrop = _G[listFrameName..'MenuBackdrop']
			menuBackdrop.backdrop:BuiStyle("Outside")
		end)

		for i = 1, MAX_STATIC_POPUPS do
			local frame = _G['ElvUI_StaticPopup'..i]
			frame:BuiStyle("Outside")
		end
	end

	if db.nonraid then
		_G.RaidInfoFrame.backdrop:BuiStyle("Outside")
	end

	if db.petition then
		_G.PetitionFrame.backdrop:BuiStyle("Outside")
	end

	if db.pvp then
		_G.PVPReadyDialog.backdrop:BuiStyle("Outside")
	end

	if db.quest then
		_G.QuestFrame:BuiStyle("Outside")
		_G.QuestLogPopupDetailFrame:BuiStyle("Outside")
		_G.QuestModelScene:BuiStyle("Outside")
	end

	if db.stable then
		_G.PetStableFrame:BuiStyle("Outside")
	end

	if db.spellbook then
		_G.SpellBookFrame:BuiStyle("Outside")
	end

	if db.tabard then
		_G.TabardFrame:BuiStyle("Outside")
	end

	if db.taxi then
		_G.TaxiFrame:BuiStyle("Outside")
	end

	if db.trade then
		_G.TradeFrame:BuiStyle("Outside")
	end

	if IsAddOnLoaded('ColorPickerPlus') then return end
	_G.ColorPickerFrame:HookScript('OnShow', function(frame)
		if frame.backdrop and not frame.backdrop.style then
			frame.backdrop:BuiStyle("Outside")
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