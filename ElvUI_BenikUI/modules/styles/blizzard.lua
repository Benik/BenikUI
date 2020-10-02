local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local MAX_STATIC_POPUPS = 4

local function LoadSkin()
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
		_G.ChatConfigFrame.backdrop:Style("Outside")
		_G.InterfaceOptionsFrame.backdrop:Style("Outside")
		_G.ReadyCheckFrame:Style("Outside")
		_G.ReadyCheckListenerFrame:Style("Outside")
		if _G.SplashFrame.backdrop then
			_G.SplashFrame.backdrop:Style("Outside")
		end
		_G.VideoOptionsFrame.backdrop:Style("Outside")
	end
	
	local function repUpdate()
		if _G.ReputationDetailFrame.backdrop then
			_G.ReputationDetailFrame.backdrop:Style("Outside")
		end
	end

	local function tokenUpdate()
		if _G.TokenFramePopup.backdrop then
			_G.TokenFramePopup.backdrop:Style("Outside")
		end
	end

	if db.character then
		_G.GearManagerDialogPopup.backdrop:Style("Outside")
		_G.PaperDollFrame:Style("Outside")
		_G.ReputationFrame:Style("Outside")
		_G.TokenFrame:Style("Outside")
		hooksecurefunc('ReputationFrame_Update', repUpdate)
		hooksecurefunc('TokenFrame_Update', tokenUpdate)
	end

	if db.dressingroom then
		_G.DressUpFrame:Style("Outside")

		if not _G.WardrobeOutfitEditFrame.style then
			_G.WardrobeOutfitEditFrame.backdrop:Style("Outside")
		end
	end

	if db.friends then
		_G.AddFriendFrame.backdrop:Style("Outside")
		_G.FriendsFrame:Style("Outside")
		_G.FriendsFriendsFrame.backdrop:Style("Outside")
		_G.QuickJoinRoleSelectionFrame.backdrop:Style("Outside")
		_G.RecruitAFriendFrame:Style("Outside")
	end

	if db.gossip then
		_G.GossipFrame.backdrop:Style("Outside")
		_G.ItemTextFrame.backdrop:Style("Outside")
	end

	if db.guild then
		_G.GuildInviteFrame.backdrop:Style("Outside")
	end

	if db.guildregistrar then
		_G.GuildRegistrarFrame:Style("Outside")
	end

	if db.help then
		_G.HelpFrame.backdrop:Style("Outside")
	end

	if db.lfg then
		_G.LFGInvitePopup.backdrop:Style("Outside")
		_G.LFGDungeonReadyDialog.backdrop:Style("Outside")
		_G.LFGDungeonReadyStatus.backdrop:Style("Outside")
		_G.LFGListApplicationDialog.backdrop:Style("Outside")
		_G.LFGListInviteDialog.backdrop:Style("Outside")
		_G.PVEFrame:Style("Outside")
		_G.RaidBrowserFrame.backdrop:Style("Outside")

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
		_G.MasterLooterFrame.backdrop:Style("Outside")
		_G.BonusRollFrame.backdrop:Style("Outside")
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
		local ChatMenus = {
			'ChatMenu',
			'EmoteMenu',
			'LanguageMenu',
			'VoiceMacroMenu',
		}

		for i = 1, #ChatMenus do
			_G[ChatMenus[i]]:HookScript('OnShow', function(s)
				if not s.backdrop.style then
					s.backdrop:Style("Outside")
				end
			end)
		end

		_G.BNToastFrame:Style("Outside")
		--_G.CinematicFrameCloseDialog:Style("Outside")
		_G.GameMenuFrame.backdrop:Style("Outside")
		_G.GhostFrame:Style("Outside")
		_G.LFDRoleCheckPopup.backdrop:Style("Outside")
		_G.PlayerReportFrame.backdrop:Style("Outside")
		_G.QueueStatusFrame.backdrop:Style("Outside")
		_G.ReportCheatingDialog.backdrop:Style("Outside")
		_G.SideDressUpFrame.backdrop:Style("Outside")
		_G.StackSplitFrame.backdrop:Style("Outside")
		_G.StaticPopup1.backdrop:Style("Outside")
		_G.StaticPopup2.backdrop:Style("Outside")
		_G.StaticPopup3.backdrop:Style("Outside")
		_G.StaticPopup4.backdrop:Style("Outside")
		_G.TicketStatusFrameButton:Style("Outside")

		hooksecurefunc('UIDropDownMenu_CreateFrames', function(level)
			local listFrame = _G['DropDownList'..level];
			local listFrameName = listFrame:GetName();
			local Backdrop = _G[listFrameName..'Backdrop']
			Backdrop.backdrop:Style("Outside")

			local menuBackdrop = _G[listFrameName..'MenuBackdrop']
			menuBackdrop.backdrop:Style("Outside")
		end)

		for i = 1, MAX_STATIC_POPUPS do
			local frame = _G['ElvUI_StaticPopup'..i]
			frame:Style("Outside")
		end
	end

	if db.nonraid then
		_G.RaidInfoFrame.backdrop:Style("Outside")
	end

	if db.petition then
		_G.PetitionFrame.backdrop:Style("Outside")
	end

	if db.pvp then
		_G.PVPReadyDialog.backdrop:Style("Outside")
	end

	if db.quest then
		_G.QuestFrame:Style("Outside")
		_G.QuestLogPopupDetailFrame:Style("Outside")
		_G.QuestModelScene:Style("Outside")

		--[[if BUI.AS then
			_G.QuestDetailScrollFrame:SetTemplate("Transparent")
			_G.QuestProgressScrollFrame:SetTemplate("Transparent")
			_G.QuestRewardScrollFrame:HookScript(
				"OnUpdate",
				function(self)
					self:SetTemplate("Transparent")
				end
			)
			_G.GossipGreetingScrollFrame:SetTemplate("Transparent")
		end]]
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

	if IsAddOnLoaded('ColorPickerPlus') then return end
	_G.ColorPickerFrame:HookScript('OnShow', function(frame)
		if frame.backdrop and not frame.backdrop.style then
			frame.backdrop:Style("Outside")
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
		mapFrame.backdrop:Style("Outside")
	end
end

function mod:StyleAltPowerBar()
	if E.db.general.altPowerBar.enable ~= true or E.db.benikui.general.benikuiStyle ~= true then
		return
	end

	local bar = _G.ElvUI_AltPowerBar
	bar:Style("Outside")
	if bar.textures then
		bar:StripTextures(true)
	end
end