local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

local CURRENT_PAGE = 0
local MAX_PAGE = 9

local function SetupBuiLayout()
	
	-- General
	do
		E.db.general.font = 'Bui Prototype'
		E.db.general.fontSize = 10
		E.db.general.stickyFrames = true
		E.db.general.topPanel = false
		E.db.general.bottomPanel = false
		E.db.general.minimap.locationText = 'HIDE'
		E.db.general.minimap.size = 150
		E.global.general.smallerWorldMap = false
		E.db.general.backdropfadecolor.r = 0.054
		E.db.general.backdropfadecolor.g = 0.054
		E.db.general.backdropfadecolor.b = 0.054
		E.db.general.valuecolor.a = 1
		E.db.general.valuecolor.r = 1
		E.db.general.valuecolor.g = 0.5
		E.db.general.valuecolor.b = 0
		E.db.general.experience.enable = false
		E.db.general.experience.textFormat = 'NONE'
		E.db.general.experience.height = 147
		E.db.general.experience.width = 8
		E.db.general.experience.textSize = 9
		E.db.general.reputation.orientation = 'VERTICAL'
		E.db.general.reputation.enable = false
		E.db.general.reputation.textFormat = 'NONE'
		E.db.general.reputation.height = 147
		E.db.general.reputation.width = 8
		E.db.general.reputation.textSize = 9
		E.db.general.reputation.orientation = 'VERTICAL'
		E.private.general.namefont = 'Bui Prototype'
		E.private.general.dmgfont = 'Bui Prototype'
		E.private.skins.blizzard.alertframes = true
		E.private.skins.blizzard.questChoice = true
		E.db.datatexts.leftChatPanel = false
		E.db.datatexts.rightChatPanel = false
		E.db.bags.itemLevelFont = 'Bui Prototype'
		E.db.bags.itemLevelFontSize = 10
		E.db.bags.itemLevelFontOutline = 'OUTLINE'
	end
	
	-- Tooltip
	do
		E.db.tooltip.healthBar.font = 'Bui Prototype'
		E.db.tooltip.healthBar.fontSize = 9
		E.db.tooltip.healthBar.fontOutline = 'OUTLINE'
	end
	
	-- Nameplates
	do
		E.db.nameplate.font = 'Bui Visitor1'
		E.db.nameplate.fontSize = 7
		E.db.nameplate.fontOutline = 'MONOCHROMEOUTLINE'
		E.db.nameplate.debuffs.font = 'Bui Visitor1'
		E.db.nameplate.debuffs.fontSize = 7
		E.db.nameplate.debuffs.fontOutline = 'MONOCHROMEOUTLINE'
		E.db.nameplate.buffs.font = 'Bui Visitor1'
		E.db.nameplate.buffs.fontSize = 7
		E.db.nameplate.buffs.fontOutline = 'MONOCHROMEOUTLINE'
	end
	
	-- movers
	if E.db.movers == nil then E.db.movers = {} end -- prevent a lua error when running the install after a profile gets deleted.
	do
		E.db.movers.AlertFrameMover = 'TOPElvUIParentTOP0-140'
		E.db.movers.BNETMover = 'TOPRIGHTElvUIParentTOPRIGHT-181-182'
		E.db.movers.BuiDashboardMover = 'TOPLEFTElvUIParentTOPLEFT4-8'
		E.db.movers.DigSiteProgressBarMover = 'BOTTOMElvUIParentBOTTOM0315'
		E.db.movers.GMMover = 'TOPLEFTElvUIParentTOPLEFT158-38'
		E.db.movers.LeftChatMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT222'
		E.db.movers.MicrobarMover = 'TOPLEFTElvUIParentTOPLEFT158-5'
		E.db.movers.MinimapMover = 'TOPRIGHTElvUIParentTOPRIGHT-4-5'
		E.db.movers.ReputationBarMover = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-41522'
		E.db.movers.ExperienceBarMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT41522'
		E.db.movers.RightChatMover = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-222'
		E.db.movers.VehicleSeatMover = 'TOPLEFTElvUIParentTOPLEFT155-81'
		E.db.movers.WatchFrameMover = 'TOPRIGHTElvUIParentTOPRIGHT-122-292'
		E.db.movers.tokenHolderMover = 'TOPLEFTElvUIParentTOPLEFT4-121'
		E.db.movers.ProfessionsMover = 'TOPRIGHTElvUIParentTOPRIGHT-3-184'
	end
	
	-- LocationPlus
	if E.db.locplus == nil then E.db.locplus = {} end
	E.db.locplus.lpfont = 'Bui Visitor1'
	E.db.locplus.lpfontsize = 10
	E.db.locplus.lpfontflags = 'MONOCROMEOUTLINE'
	E.db.locplus.dtheight = 16
	E.db.locplus.lpwidth = 220
	E.db.locplus.dtwidth = 120
	E.db.locplus.trunc = true
	E.db.locplus.lpauto = false
	E.db.locplus.both = false
	E.db.locplus.hidecoords = false
	E.db.locplus.displayOther = 'NONE'
	E.db.movers.LocationMover = 'TOPElvUIParentTOP0-7'

	-- LocationLite
	if E.db.loclite == nil then E.db.loclite = {} end
	E.db.loclite.lpfont = 'Bui Visitor1'
	E.db.loclite.lpfontflags = 'MONOCROMEOUTLINE'
	E.db.loclite.lpfontsize = 10
	E.db.loclite.dtheight = 16
	E.db.loclite.lpwidth = 220
	E.db.loclite.trunc = true
	E.db.loclite.lpauto = false
	E.db.movers.LocationLiteMover = 'TOPElvUIParentTOP0-7'
	
	if(UnitLevel('player') == MAX_PLAYER_LEVEL) then
		E.db.xprep.show = 'REP'
	else
		E.db.xprep.show = 'XP'
	end
	E.db.xprep.textFormat = 'CURMAX'
	E.db.xprep.textStyle = 'UNIT'

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Layout Set']
		InstallStepComplete:Show()		
	end
	E:UpdateAll(true)
end

function BUI:BuiColorThemes(color)
	-- Colors
	do
		if color == 'Diablo' then
			E.db.general.backdropfadecolor.a = 0.80
			E.db.general.backdropfadecolor.r = 0.1254901960784314
			E.db.general.backdropfadecolor.g = 0.05490196078431373
			E.db.general.backdropfadecolor.b = 0.05098039215686274
			E.db.general.backdropcolor.r = 0.1058823529411765
			E.db.general.backdropcolor.g = 0.05490196078431373
			E.db.general.backdropcolor.b = 0.0392156862745098
			E.db.bui.colorTheme = 'Diablo'
		elseif color == 'Hearthstone' then
			E.db.general.backdropfadecolor.a = 0.80
			E.db.general.backdropfadecolor.r = 0.08627450980392157
			E.db.general.backdropfadecolor.g = 0.1098039215686275
			E.db.general.backdropfadecolor.b = 0.1490196078431373
			E.db.general.backdropcolor.r = 0.07058823529411765
			E.db.general.backdropcolor.g = 0.08627450980392157
			E.db.general.backdropcolor.b = 0.1176470588235294
			E.db.bui.colorTheme = 'Hearthstone'
		elseif color == 'Mists' then
			E.db.general.backdropfadecolor.a = 0.80
			E.db.general.backdropfadecolor.r = 0.04313725490196078
			E.db.general.backdropfadecolor.g = 0.1019607843137255
			E.db.general.backdropfadecolor.b = 0.1019607843137255
			E.db.general.backdropcolor.r = 0.02745098039215686
			E.db.general.backdropcolor.g = 0.06274509803921569
			E.db.general.backdropcolor.b = 0.06274509803921569
			E.db.bui.colorTheme = 'Mists'
		elseif color == 'Elv' then
			E.db.general.backdropfadecolor.a = 0.80
			E.db.general.backdropfadecolor.r = 0.05490196078431373
			E.db.general.backdropfadecolor.g = 0.05490196078431373
			E.db.general.backdropfadecolor.b = 0.05490196078431373
			E.db.general.backdropcolor.r = 0.1019607843137255
			E.db.general.backdropcolor.g = 0.1019607843137255
			E.db.general.backdropcolor.b = 0.1019607843137255
			E.db.bui.colorTheme = 'Elv'
		end
	end
	E:UpdateAll(true)
end

function E:SetupBuiColors()
	BUI:BuiColorThemes()
	
	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Color Theme Set']
		InstallStepComplete:Show()		
	end
end

local function SetupBuiChat()

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format('ChatFrame%s', i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)
		
		FCF_SetChatWindowFontSize(nil, frame, 10)
		
		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if i == 3 and chatName == LOOT..' / '..TRADE then
			FCF_UnDockFrame(frame)
			frame:ClearAllPoints()
			frame:Point('BOTTOMLEFT', LeftChatToggleButton, 'TOPLEFT', 1, 3)
			FCF_DockFrame(frame)
			FCF_SetLocked(frame, 1)
			frame:Show()
		end
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end
	
	do
		E.db.chat.tabFont = 'Bui Visitor1'
		E.db.chat.tabFontSize = 10
		E.db.chat.tabFontOutline = 'MONOCROMEOUTLINE'
		E.db.chat.font = 'Bui Prototype'
		E.db.chat.panelHeight = 150
	end
	
	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Chat Set']
		InstallStepComplete:Show()		
	end
	E:UpdateAll(true)
end

local function SetupBuiAbs()
	-- Actionbars
	do
		E.db.actionbar.bar1.backdrop = false;
		E.db.actionbar.bar1.buttons = 12;
		E.db.actionbar.bar1.buttonspacing = 4;
		E.db.actionbar.bar1.buttonsize = 30;
		E.db.actionbar.bar2.enabled = true;
		E.db.actionbar.bar2.backdrop = true;
		E.db.actionbar.bar2.buttons = 12;
		E.db.actionbar.bar2.buttonspacing = 4;
		E.db.actionbar.bar2.heightMult = 2;
		E.db.actionbar.bar2.buttonsize = 30;
		E.db.actionbar.bar3.backdrop = true;
		E.db.actionbar.bar3.buttons = 10;
		E.db.actionbar.bar3.buttonsPerRow = 5;
		E.db.actionbar.bar3.buttonspacing = 4;
		E.db.actionbar.bar3.buttonsize = 30;
		E.db.actionbar.bar4.backdrop = true;
		E.db.actionbar.bar4.buttons = 12;
		E.db.actionbar.bar4.buttonspacing = 4;
		E.db.actionbar.bar4.buttonsize = 26;
		E.db.actionbar.bar5.backdrop = true;
		E.db.actionbar.bar5.buttons = 10;
		E.db.actionbar.bar5.buttonsPerRow = 5;
		E.db.actionbar.bar5.buttonspacing = 4;
		E.db.actionbar.bar5.buttonsize = 30;
		
		E.db.actionbar.barPet.buttonspacing = 4;
		E.db.actionbar.barPet.buttonsPerRow = 10;
		E.db.actionbar.barPet.buttonsize = 22;
		E.db.actionbar.barPet.backdrop = true;
		
		E.db.actionbar.stanceBar.buttonspacing = 2
		E.db.actionbar.stanceBar.backdrop = false
		E.db.actionbar.stanceBar.buttonsize = 24
		
		E.db.actionbar.font = 'Bui Visitor1';
		E.db.actionbar.fontOutline = 'MONOCROMEOUTLINE';
		E.db.actionbar.fontSize = 10;
		
		E.db.bab.enable = true
	end
	
	-- movers
	do
		E.db.movers.ArenaHeaderMover = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-56346'
		E.db.movers.BossButton = 'BOTTOMElvUIParentBOTTOM0283'
		E.db.movers.BossHeaderMover = 'TOPRIGHTElvUIParentTOPRIGHT-56-397'
		E.db.movers.BuffsMover = 'TOPRIGHTElvUIParentTOPRIGHT-181-3'
		E.db.movers.DebuffsMover = 'TOPRIGHTElvUIParentTOPRIGHT-181-134'
		E.db.movers.ElvAB_1 = 'BOTTOMElvUIParentBOTTOM092'
		E.db.movers.ElvAB_2 = 'BOTTOMElvUIParentBOTTOM058'
		E.db.movers.ElvAB_3 = 'BOTTOMElvUIParentBOTTOM29558'
		E.db.movers.ElvAB_5 = 'BOTTOMElvUIParentBOTTOM-29558'	
		E.db.movers.PetAB = 'BOTTOMElvUIParentBOTTOM022'
		E.db.movers.ShiftAB = 'BOTTOMElvUIParentBOTTOM0134'
	end

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Actionbars Set']
		InstallStepComplete:Show()		
	end
	E:UpdateAll(true)
end

local function SetupBuiUfs()
	-- Empty Bars
	do
		E.db.ufb.barheight = 15
		E.db.ufb.barshow = true
	end

	-- Auras
	do
		E.db.auras.timeXOffset = -1
		E.db.auras.font = 'Bui Visitor1'
		E.db.auras.fontSize = 10
		E.db.auras.fontOutline = 'MONOCROMEOUTLINE'
		E.db.auras.fadeThreshold = 10
		E.db.auras.buffs.horizontalSpacing = 3
		E.db.auras.buffs.size = 30
		E.db.auras.consolidatedBuffs.font = 'Bui Visitor1'
		E.db.auras.consolidatedBuffs.fontSize = 10
		E.db.auras.consolidatedBuffs.fontOutline = 'MONOCROMEOUTLINE'
		E.db.auras.debuffs.size = 30
	end
	
	-- Units
	do
	-- general
		E.db.unitframe.font = 'Bui Visitor1'
		E.db.unitframe.fontSize = 10
		E.db.unitframe.fontOutline = 'MONOCROMEOUTLINE'
		E.db.unitframe.colors.transparentAurabars = true
		E.db.unitframe.colors.transparentCastbar = true
		E.db.unitframe.colors.castClassColor = true
		E.db.unitframe.smoothbars = true
		
		E.db.unitframe.colors.healthclass = false
		E.db.unitframe.colors.power.MANA.r = 1
		E.db.unitframe.colors.power.MANA.g = 0.5
		E.db.unitframe.colors.power.MANA.b = 0
		E.db.unitframe.statusbar = 'BuiFlat'
	-- player
		E.db.unitframe.units.player.debuffs.attachTo = 'BUFFS'
		E.db.unitframe.units.player.debuffs.sizeOverride = 32
		E.db.unitframe.units.player.debuffs.yOffset = 2
		E.db.unitframe.units.player.portrait.enable = true
		E.db.unitframe.units.player.portrait.overlay = true
		E.db.unitframe.units.player.castbar.icon = false
		E.db.unitframe.units.player.castbar.width = 300
		E.db.unitframe.units.player.castbar.height = 18
		E.db.unitframe.units.player.classbar.detachFromFrame = true
		E.db.unitframe.units.player.classbar.detachedWidth = 140
		E.db.unitframe.units.player.classbar.fill = 'spaced'
		E.db.unitframe.units.player.width = 300
		E.db.unitframe.units.player.health.xOffset = 2
		E.db.unitframe.units.player.health.yOffset = -25
		E.db.unitframe.units.player.height = 33
		E.db.unitframe.units.player.buffs.enable = true
		E.db.unitframe.units.player.buffs.sizeOverride = 30
		E.db.unitframe.units.player.buffs.attachTo = 'FRAME'
		E.db.unitframe.units.player.buffs.yOffset = 2
		E.db.unitframe.units.player.threatStyle = 'ICONTOPRIGHT'
		E.db.unitframe.units.player.power.height = 5
		E.db.unitframe.units.player.power.width = 'fill'
		E.db.unitframe.units.player.power.detachedWidth = 298
		E.db.unitframe.units.player.power.detachFromFrame = false
		E.db.unitframe.units.player.power.yOffset = -25
	-- target
		E.db.unitframe.units.target.health.xOffset = -40
		E.db.unitframe.units.target.health.yOffset = -25
		E.db.unitframe.units.target.health.text_format = ''
		E.db.unitframe.units.target.name.xOffset = 8
		E.db.unitframe.units.target.name.yOffset = -25
		E.db.unitframe.units.target.name.position = 'RIGHT'
		E.db.unitframe.units.target.name.text_format = '[healthcolor][health:current-percent] [namecolor][name:medium] [difficultycolor][smartlevel] [shortclassification]'
		E.db.unitframe.units.target.debuffs.anchorPoint = 'TOPLEFT'
		E.db.unitframe.units.target.portrait.enable = true
		E.db.unitframe.units.target.portrait.overlay = true
		E.db.unitframe.units.target.power.xOffset = 2
		E.db.unitframe.units.target.power.detachedWidth = 298
		E.db.unitframe.units.target.power.detachFromFrame = false
		E.db.unitframe.units.target.power.hideonnpc = false
		E.db.unitframe.units.target.power.height = 5
		E.db.unitframe.units.target.power.width = 'fill'
		E.db.unitframe.units.target.power.yOffset = -25
		E.db.unitframe.units.target.width = 300
		E.db.unitframe.units.target.castbar.icon = false
		E.db.unitframe.units.target.castbar.width = 300
		E.db.unitframe.units.target.height = 33
		E.db.unitframe.units.target.threatStyle = 'ICONTOPLEFT'
		E.db.unitframe.units.target.buffs.anchorPoint = 'TOPLEFT'
		E.db.unitframe.units.target.buffs.sizeOverride = 30
		E.db.unitframe.units.target.buffs.yOffset = 2
	-- pet
		E.db.unitframe.units.pet.height = 24
		E.db.unitframe.units.pet.power.height = 5
		E.db.unitframe.units.pet.power.width = 'fill'
	-- focus
		E.db.unitframe.units.focus.power.height = 5
		E.db.unitframe.units.focus.power.width = 'fill'
		E.db.unitframe.units.focus.width = 122
		E.db.unitframe.units.focus.castbar.height = 6
		E.db.unitframe.units.focus.castbar.width = 122
	-- targettarget
		E.db.unitframe.units.targettarget.height = 24
		E.db.unitframe.units.targettarget.power.height = 5
		E.db.unitframe.units.targettarget.power.width = 'fill'
	-- raid
		E.db.unitframe.units.raid.power.enable = false
	-- raid 40
		E.db.unitframe.units.raid40.power.enable = false
	-- colors
		E.db.unitframe.colors.castClassColor = true
	end
	
	-- Movers
	do
		E.db.movers.AltPowerBarMover = 'TOPElvUIParentTOP0-66'
		E.db.movers.ElvUF_AssistMover = 'TOPLEFTElvUIParentTOPLEFT4-392'
		E.db.movers.ElvUF_FocusMover = 'BOTTOMRIGHTElvUIParentBOTTOMRIGHT-442178'
		E.db.movers.ElvUF_PartyMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT2178'
		E.db.movers.ElvUF_PetMover = 'BOTTOMElvUIParentBOTTOM0191'
		E.db.movers.ElvUF_PlayerCastbarMover = 'BOTTOMElvUIParentBOTTOM-231147'
		E.db.movers.ElvUF_PlayerMover = 'BOTTOMElvUIParentBOTTOM-231182'
		E.db.movers.ElvUF_RaidMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT2178'
		E.db.movers.ElvUF_Raid40Mover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT2178'
		E.db.movers.ElvUF_RaidpetMover = 'TOPLEFTElvUIParentTOPLEFT4-444'
		E.db.movers.ElvUF_TankMover = 'TOPLEFTElvUIParentTOPLEFT4-292'
		E.db.movers.ElvUF_TargetCastbarMover = 'BOTTOMElvUIParentBOTTOM231147'
		E.db.movers.ElvUF_TargetMover = 'BOTTOMElvUIParentBOTTOM231182'
		E.db.movers.ElvUF_TargetTargetMover = 'BOTTOMElvUIParentBOTTOM0164'
		E.db.movers.PlayerPowerBarMover = 'BOTTOMElvUIParentBOTTOM-231215'
		E.db.movers.TargetPowerBarMover = 'BOTTOMElvUIParentBOTTOM231215'
		E.db.movers.ClassBarMover = 'BOTTOMElvUIParentBOTTOM-1349'
		E.db.movers.ExperienceBarMover = 'BOTTOMLEFTElvUIParentBOTTOMLEFT41522'
	end
	
	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Unitframes Set']
		InstallStepComplete:Show()		
	end
	E:UpdateAll(true)
end

local function SetupAddOnSkins()
	if IsAddOnLoaded('AddOnSkins') then
		-- reset the embeds in case of Skada/Recount swap
		E.private['addonskins']['EmbedSystem'] = nil
		E.private['addonskins']['EmbedSystemDual'] = nil
		E.private['addonskins']['EmbedBelowTop'] = nil
		E.private['addonskins']['TransparentEmbed'] = nil
		E.private['addonskins']['EmbedMain'] = nil
		E.private['addonskins']['EmbedLeft'] = nil
		E.private['addonskins']['EmbedRight'] = nil
		
		if IsAddOnLoaded('Recount') then
			E.private['addonskins']['EmbedMain'] = 'Recount'
			E.private['addonskins']['EmbedSystem'] = true
			E.private['addonskins']['EmbedSystemDual'] = false
			E.private['addonskins']['RecountBackdrop'] = false
			E.private['addonskins']['EmbedBelowTop'] = false
			E.private['addonskins']['TransparentEmbed'] = true
		end
		
		if IsAddOnLoaded('Skada') then
    		E.private['addonskins']['EmbedSystem'] = false
			E.private['addonskins']['EmbedSystemDual'] = true
			E.private['addonskins']['EmbedBelowTop'] = false
			E.private['addonskins']['TransparentEmbed'] = true
			E.private['addonskins']['EmbedMain'] = 'Skada'
			E.private['addonskins']['EmbedLeft'] = 'Skada'
			E.private['addonskins']['EmbedRight'] = 'Skada'
		end
		
		if IsAddOnLoaded('DBM-Core') then
			E.private['addonskins']['DBMFont'] = 'Bui Prototype'
			E.private['addonskins']['DBMFontSize'] = 10
			E.private['addonskins']['DBMFontFlag'] = 'OUTLINE'
		end
	end
end

local recountName = GetAddOnMetadata('Recount', 'Title')
local skadaName = GetAddOnMetadata('Skada', 'Title')
local dbmName = GetAddOnMetadata('DBM-Core', 'Title')

local function SetupBuiAddons()
	-- Recount Profile
	if IsAddOnLoaded('Recount') then
		print(BUI.Title..format(L['- %s profile successfully created!'], recountName))
		RecountDB['profiles']['BenikUI'] = {
			['Colors'] = {
				['Other Windows'] = {
					['Title Text'] = {
						['g'] = 0.5,
						['b'] = 0,
					},
				},
				['Window'] = {
					['Title Text'] = {
						['g'] = 0.5,
						['b'] = 0,
					},
				},
				['Bar'] = {
					['Bar Text'] = {
						['a'] = 1,
					},
					['Total Bar'] = {
						['a'] = 1,
					},
				},
			},
			['DetailWindowY'] = 0,
			['DetailWindowX'] = 0,
			['GraphWindowX'] = 0,
			['Locked'] = true,
			['FrameStrata'] = '2-LOW',
			['BarTextColorSwap'] = true,
			['BarTexture'] = 'BuiEmpty',
			['CurDataSet'] = 'OverallData',
			['ClampToScreen'] = true,
			['Font'] = 'Bui Visitor1',	
		}
	end

	-- Skada Profile
	if IsAddOnLoaded('Skada') then
		print(BUI.Title..format(L['- %s profile successfully created!'], skadaName))
		SkadaDB['profiles']['BenikUI'] = {
			["windows"] = {
				{
					["barheight"] = 14,
					["classicons"] = false,
					["barslocked"] = true,
					["barfont"] = "Bui Prototype",
					["title"] = {
						["font"] = "Bui Visitor1",
						["fontsize"] = 10,
						["height"] = 18,
					},
					["classcolortext"] = true,
					["barcolor"] = {
						["r"] = 1,
						["g"] = 0.5,
						["b"] = 0,
					},
					["mode"] = "DPS",
					["spark"] = false,
					["barwidth"] = 196.000061035156,
					["barfontsize"] = 10,
					["background"] = {
						["height"] = 122,
					},
					["classcolorbars"] = false,
					["bartexture"] = "BuiOnePixel",
					["point"] = "TOPRIGHT",
				}, -- [1]
				{
					["titleset"] = true,
					["barheight"] = 14,
					["classicons"] = false,
					["barslocked"] = true,
					["enabletitle"] = true,
					["wipemode"] = "",
					["set"] = "current",
					["hidden"] = false,
					["barfont"] = "Bui Prototype",
					["name"] = "Skada 2",
					["display"] = "bar",
					["barfontflags"] = "",
					["classcolortext"] = true,
					["scale"] = 1,
					["reversegrowth"] = false,
					["returnaftercombat"] = false,
					["roleicons"] = false,
					["barorientation"] = 1,
					["snapto"] = true,
					["version"] = 1,
					["modeincombat"] = "",
					["clickthrough"] = false,
					["spark"] = false,
					["bartexture"] = "BuiOnePixel",
					["barwidth"] = 201.000091552734,
					["barspacing"] = 0,
					["barfontsize"] = 10,
					["title"] = {
						["color"] = {
							["a"] = 0.8,
							["b"] = 0.3,
							["g"] = 0.1,
							["r"] = 0.1,
						},
						["bordertexture"] = "None",
						["font"] = "Bui Visitor1",
						["borderthickness"] = 2,
						["fontsize"] = 10,
						["fontflags"] = "",
						["height"] = 18,
						["margin"] = 0,
						["texture"] = "Aluminium",
					},
					["background"] = {
						["borderthickness"] = 0,
						["height"] = 122,
						["color"] = {
							["a"] = 0.2,
							["b"] = 0.5,
							["g"] = 0,
							["r"] = 0,
						},
						["bordertexture"] = "None",
						["margin"] = 0,
						["texture"] = "Solid",
					},
					["barcolor"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0.5,
						["b"] = 0,
					},
					["barbgcolor"] = {
						["a"] = 0.6,
						["b"] = 0.3,
						["g"] = 0.3,
						["r"] = 0.3,
					},
					["classcolorbars"] = false,
					["buttons"] = {
						["segment"] = true,
						["menu"] = true,
						["mode"] = true,
						["report"] = true,
						["reset"] = true,
					},
					["point"] = "TOPRIGHT",
					["mode"] = "Healing",
				}, -- [2]
			},		
		}
	end

	-- DBM Profile
	if IsAddOnLoaded('DBM-Core') then
		print(BUI.Title..format(L['- %s profile successfully created!'], dbmName))
		DBM:CreateProfile('BenikUI')
		
		-- Warnings
		DBM_AllSavedOptions["BenikUI"]["WarningFont"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
		DBM_AllSavedOptions["BenikUI"]["SpecialWarningFont"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
		DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontShadow"] = true
		DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontStyle"] = "NONE"
		
		-- Bars
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["Texture"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Flat.tga"
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["Font"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["Scale"] = 1
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["FontSize"] = 12
		DBT_AllPersistentOptions["BenikUI"]["DBM"]["HugeScale"] = 1
		
		DBM:ApplyProfile('BenikUI')
	end

	do
		-- ElvUI_VisualAuraTimers
		if E.db.VAT == nil then E.db.VAT = {} end
		if IsAddOnLoaded('ElvUI_VisualAuraTimers') then
			E.db.VAT.enableStaticColor = true
			E.db.VAT.barHeight = 6
			E.db.VAT.spacing = -6
			E.db.VAT.staticColor.r = 1
			E.db.VAT.staticColor.g = 0.5
			E.db.VAT.staticColor.b = 0
			E.db.VAT.showText = true
			E.db.VAT.colors.minutesIndicator.r = 1
			E.db.VAT.colors.minutesIndicator.g = 0.5
			E.db.VAT.colors.minutesIndicator.b = 0
			E.db.VAT.colors.hourminutesIndicator.r = 1
			E.db.VAT.colors.hourminutesIndicator.g = 0.5
			E.db.VAT.colors.hourminutesIndicator.b = 0
			E.db.VAT.colors.expireIndicator.r = 1
			E.db.VAT.colors.expireIndicator.g = 0.5
			E.db.VAT.colors.expireIndicator.b = 0
			E.db.VAT.colors.secondsIndicator.r = 1
			E.db.VAT.colors.secondsIndicator.g = 0.5
			E.db.VAT.colors.secondsIndicator.b = 0
			E.db.VAT.colors.daysIndicator.r = 1
			E.db.VAT.colors.daysIndicator.g = 0.5
			E.db.VAT.colors.daysIndicator.b = 0
			E.db.VAT.colors.hoursIndicator.r = 1
			E.db.VAT.colors.hoursIndicator.r = 0.5
			E.db.VAT.colors.hoursIndicator.r = 0
			E.db.VAT.statusbarTexture = 'BuiFlat'
			E.db.VAT.position = 'TOP'
		end
	end

	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['Addons Set']
		InstallStepComplete:Show()		
	end
	E:UpdateAll(true)
end

function E:SetupBuiDts(role)
	-- Data Texts
	do
		E.db.datatexts.panelTransparency = true
		E.db.datatexts.font = 'Bui Visitor1'
		E.db.datatexts.fontOutline = 'MONOCROMEOUTLINE'
		E.db.datatexts.fontSize = 10
		E.db.datatexts.panels.BuiLeftChatDTPanel.right = 'BuiMail'
		if IsAddOnLoaded('ElvUI_LocPlus') then
			E.db.datatexts.panels.RightCoordDtPanel = 'Time'
			if IsAddOnLoaded('AtlasLoot') then
				E.db.datatexts.panels.LeftCoordDtPanel = 'AtlasLoot'
			else
				E.db.datatexts.panels.LeftCoordDtPanel = 'Talent/Loot Specialization'
			end
		end
		if role == 'tank' then
			E.db.datatexts.panels.BuiLeftChatDTPanel.left = 'Avoidance'
			E.db.datatexts.panels.BuiLeftChatDTPanel.middle = 'Resolve'
		elseif role == 'dpsMelee' then
			E.db.datatexts.panels.BuiLeftChatDTPanel.left = 'Attack Power'
			E.db.datatexts.panels.BuiLeftChatDTPanel.middle = 'Haste'
		elseif role == 'healer' or 'dpsCaster' then
			E.db.datatexts.panels.BuiLeftChatDTPanel.left = 'Spell/Heal Power'
			E.db.datatexts.panels.BuiLeftChatDTPanel.middle = 'Haste'
		end
		E.db.datatexts.panels.BuiRightChatDTPanel.right = 'Gold'
		E.db.datatexts.panels.BuiRightChatDTPanel.middle = 'Bags'
		E.db.datatexts.panels.BuiRightChatDTPanel.left = 'Mastery'
	end
	
	if InstallStepComplete then
		InstallStepComplete.message = BUI.Title..L['DataTexts Set']
		InstallStepComplete:Show()		
	end
	E:UpdateAll(true)
end

local function ResetAll()
	InstallNextButton:Disable()
	InstallPrevButton:Disable()
	InstallOption1Button:Hide()
	InstallOption1Button:SetScript('OnClick', nil)
	InstallOption1Button:SetText('')
	InstallOption2Button:Hide()
	InstallOption2Button:SetScript('OnClick', nil)
	InstallOption2Button:SetText('')
	InstallOption3Button:Hide()
	InstallOption3Button:SetScript('OnClick', nil)
	InstallOption3Button:SetText('')	
	InstallOption4Button:Hide()
	InstallOption4Button:SetScript('OnClick', nil)
	InstallOption4Button:SetText('')
	BUIInstallFrame.SubTitle:SetText('')
	BUIInstallFrame.Desc1:SetText('')
	BUIInstallFrame.Desc2:SetText('')
	BUIInstallFrame.Desc3:SetText('')
	BUIInstallFrame:Size(550, 400)
end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.bui.installed = true
	
	if GetCVarBool('Sound_EnableMusic') then
		StopMusic()
	end
	
	ReloadUI()
end

local function SetPage(PageNum)
	CURRENT_PAGE = PageNum
	ResetAll()
	InstallStatus:SetValue(PageNum)
	
	local f = BUIInstallFrame
	
	if PageNum == MAX_PAGE then
		InstallNextButton:Disable()
	else
		InstallNextButton:Enable()
	end
	
	if PageNum == 1 then
		InstallPrevButton:Disable()
	else
		InstallPrevButton:Enable()
	end

	if PageNum == 1 then
		f.SubTitle:SetText(format(L['Welcome to BenikUI version %s, for ElvUI %s.'], BUI.Version, E.version))
		f.Desc1:SetText(L["By pressing the Continue button, BenikUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
		f.Desc2:SetText(BUI:cOption(L['BenikUI options are marked with light blue color, inside ElvUI options.']))
		f.Desc3:SetText(L['Please press the continue button to go onto the next step.'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetText(L['Skip Process'])			
	elseif PageNum == 2 then
		f.SubTitle:SetText(L['Layout'])
		f.Desc1:SetText(L['This part of the installation changes the default ElvUI look. This is why you downloaded BenikUI :)'])
		f.Desc2:SetText(L['Please click the button below to apply the new layout.'])
		f.Desc3:SetText(L['Importance: |cff07D400High|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', SetupBuiLayout)
		InstallOption1Button:SetText(L['Setup Layout'])
	elseif PageNum == 3 then
		f.SubTitle:SetText(L['Color Themes'])
		f.Desc1:SetText(L['This part of the installation will apply a Color Theme'])
		f.Desc2:SetText(L['Please click a button below to apply a color theme.'])
		f.Desc3:SetText(L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E:SetupBuiColors(); BUI:BuiColorThemes('Elv'); end)
		InstallOption1Button:SetText(L['ElvUI'])
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E:SetupBuiColors(); BUI:BuiColorThemes('Diablo'); end)
		InstallOption2Button:SetText(L['Diablo'])
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() E:SetupBuiColors(); BUI:BuiColorThemes('Mists'); end)
		InstallOption3Button:SetText(L['Mists'])
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() E:SetupBuiColors(); BUI:BuiColorThemes('Hearthstone'); end)
		InstallOption4Button:SetText(L['Hearthstone'])	
	elseif PageNum == 4 then
		f.SubTitle:SetText(L['Chat'])
		f.Desc1:SetText(L['This part of the installation process sets up your chat fonts and colors.'])
		f.Desc2:SetText(L['Please click the button below to setup your chat windows.'])
		f.Desc3:SetText(L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', SetupBuiChat)
		InstallOption1Button:SetText(L['Setup Chat'])
	elseif PageNum == 5 then
		f.SubTitle:SetText(L['UnitFrames'])
		f.Desc1:SetText(L["This part of the installation process will reposition your Unitframes and will enable the EmptyBars.\r|cffff8000This doesn't touch your current raid/party layout|r"])
		f.Desc2:SetText(L['Please click the button below to setup your Unitframes.'])
		f.Desc3:SetText(L['Importance: |cff07D400High|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', SetupBuiUfs)
		InstallOption1Button:SetText(L['Setup Unitframes'])		
	elseif PageNum == 6 then
		f.SubTitle:SetText(L['ActionBars'])
		f.Desc1:SetText(L['This part of the installation process will reposition your Actionbars and will enable backdrops'])
		f.Desc2:SetText(L['Please click the button below to setup your actionbars.'])
		f.Desc3:SetText(L['Importance: |cff07D400High|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', SetupBuiAbs)
		InstallOption1Button:SetText(L['Setup ActionBars'])
	elseif PageNum == 7 then
		f.SubTitle:SetText(L['DataTexts'])
		f.Desc1:SetText(L["This part of the installation process will fill BenikUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"])
		f.Desc2:SetText(L['Please click the button below to setup your datatexts.'])
		f.Desc3:SetText(L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; E:SetupBuiDts('tank') end)
		InstallOption1Button:SetText(TANK)
		InstallOption2Button:Show()
		InstallOption2Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; E:SetupBuiDts('healer') end)
		InstallOption2Button:SetText(HEALER)
		InstallOption3Button:Show()
		InstallOption3Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; E:SetupBuiDts('dpsMelee') end)
		InstallOption3Button:SetText(L['Physical DPS'])
		InstallOption4Button:Show()
		InstallOption4Button:SetScript('OnClick', function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; E:SetupBuiDts('dpsCaster') end)
		InstallOption4Button:SetText(L['Caster DPS'])
	elseif PageNum == 8 then
		f.SubTitle:SetText(ADDONS)
		f.Desc1:SetText(L['This part of the installation process will apply changes to the addons like Recount, DBM and ElvUI plugins'])
		f.Desc2:SetText(L['Please click the button below to setup your addons.'])
		f.Desc3:SetText(L['Importance: |cffD3CF00Medium|r'])
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', function() SetupBuiAddons(); SetupAddOnSkins(); end)
		InstallOption1Button:SetText(L['Setup Addons'])	
	elseif PageNum == 9 then
		f.SubTitle:SetText(L['Installation Complete'])
		f.Desc1:SetText(L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'])
		f.Desc2:SetText(L['Please click the button below so you can setup variables and ReloadUI.'])			
		InstallOption1Button:Show()
		InstallOption1Button:SetScript('OnClick', InstallComplete)
		InstallOption1Button:SetText(L['Finished'])				
		BUIInstallFrame:Size(550, 350)
		if InstallStepComplete then
			InstallStepComplete.message = BUI.Title..L['Installed']
			InstallStepComplete:Show()		
		end
	end
end

local function NextPage()	
	if CURRENT_PAGE ~= MAX_PAGE then
		CURRENT_PAGE = CURRENT_PAGE + 1
		SetPage(CURRENT_PAGE)
	end
end

local function PreviousPage()
	if CURRENT_PAGE ~= 1 then
		CURRENT_PAGE = CURRENT_PAGE - 1
		SetPage(CURRENT_PAGE)
	end
end

function E:SetupBui()	
	if not InstallStepComplete then
		local imsg = CreateFrame('Frame', 'InstallStepComplete', E.UIParent)
		imsg:Size(418, 72)
		imsg:Point('TOP', 0, -190)
		imsg:Hide()
		imsg:SetScript('OnShow', function(self)
			if self.message then 
				PlaySoundFile([[Sound\Interface\LevelUp.ogg]])
				self.text:SetText(self.message)
				UIFrameFadeOut(self, 3.5, 1, 0)
				E:Delay(4, function() self:Hide() end)	
				self.message = nil
			else
				self:Hide()
			end
		end)
		
		imsg.firstShow = false
		
		imsg.bg = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.bg:SetPoint('BOTTOM')
		imsg.bg:Size(326, 103)
		imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
		imsg.bg:SetVertexColor(1, 1, 1, 0.6)
		
		imsg.lineTop = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
		imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineTop:SetPoint('TOP')
		imsg.lineTop:Size(418, 7)
		imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
		
		imsg.lineBottom = imsg:CreateTexture(nil, 'BACKGROUND')
		imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
		imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
		imsg.lineBottom:SetPoint('BOTTOM')
		imsg.lineBottom:Size(418, 7)
		imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
		
		imsg.text = imsg:CreateFontString(nil, 'ARTWORK')
		imsg.text:FontTemplate(nil, 32)
		imsg.text:Point('CENTER', 0, -4)
		imsg.text:SetTextColor(1, 0.82, 0)
		imsg.text:SetJustifyH('CENTER')
	end

	--Create Frame
	if not BUIInstallFrame then
		local f = CreateFrame('Button', 'BUIInstallFrame', E.UIParent)
		f.SetPage = SetPage
		f:Size(550, 400)
		f:SetTemplate('Transparent')
		f:SetPoint('CENTER')
		f:SetFrameStrata('TOOLTIP')
		f:Style('Outside')
		
		f.Title = f:CreateFontString(nil, 'OVERLAY')
		f.Title:FontTemplate(nil, 17, nil)
		f.Title:Point('TOP', 0, -5)
		f.Title:SetText(BUI.Title..L['Installation'])
		
		f.Next = CreateFrame('Button', 'InstallNextButton', f, 'UIPanelButtonTemplate')
		f.Next:StripTextures()
		f.Next:SetTemplate('Default', true)
		f.Next:Size(110, 25)
		f.Next:Point('BOTTOMRIGHT', -5, 5)
		f.Next:SetText(CONTINUE)
		f.Next:Disable()
		f.Next:SetScript('OnClick', NextPage)
		E.Skins:HandleButton(f.Next, true)
		
		f.Prev = CreateFrame('Button', 'InstallPrevButton', f, 'UIPanelButtonTemplate')
		f.Prev:StripTextures()
		f.Prev:SetTemplate('Default', true)
		f.Prev:Size(110, 25)
		f.Prev:Point('BOTTOMLEFT', 5, 5)
		f.Prev:SetText(PREVIOUS)	
		f.Prev:Disable()
		f.Prev:SetScript('OnClick', PreviousPage)
		E.Skins:HandleButton(f.Prev, true)
		
		f.Status = CreateFrame('StatusBar', 'InstallStatus', f)
		f.Status:SetFrameLevel(f.Status:GetFrameLevel() + 2)
		f.Status:CreateBackdrop('Default')
		f.Status:SetStatusBarTexture(E['media'].normTex)
		f.Status:SetStatusBarColor(unpack(E['media'].rgbvaluecolor))
		f.Status:SetMinMaxValues(0, MAX_PAGE)
		f.Status:Point('TOPLEFT', f.Prev, 'TOPRIGHT', 6, -2)
		f.Status:Point('BOTTOMRIGHT', f.Next, 'BOTTOMLEFT', -6, 2)
		f.Status.text = f.Status:CreateFontString(nil, 'OVERLAY')
		f.Status.text:FontTemplate()
		f.Status.text:SetPoint('CENTER')
		f.Status.text:SetText(CURRENT_PAGE..' / '..MAX_PAGE)
		f.Status:SetScript('OnValueChanged', function(self)
			self.text:SetText(self:GetValue()..' / '..MAX_PAGE)
		end)
		
		f.Option1 = CreateFrame('Button', 'InstallOption1Button', f, 'UIPanelButtonTemplate')
		f.Option1:StripTextures()
		f.Option1:Size(160, 30)
		f.Option1:Point('BOTTOM', 0, 45)
		f.Option1:SetText('')
		f.Option1:Hide()
		E.Skins:HandleButton(f.Option1, true)
		
		f.Option2 = CreateFrame('Button', 'InstallOption2Button', f, 'UIPanelButtonTemplate')
		f.Option2:StripTextures()
		f.Option2:Size(110, 30)
		f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45)
		f.Option2:SetText('')
		f.Option2:Hide()
		f.Option2:SetScript('OnShow', function() f.Option1:SetWidth(110); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45) end)
		f.Option2:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45) end)
		E.Skins:HandleButton(f.Option2, true)		
		
		f.Option3 = CreateFrame('Button', 'InstallOption3Button', f, 'UIPanelButtonTemplate')
		f.Option3:StripTextures()
		f.Option3:Size(100, 30)
		f.Option3:Point('LEFT', f.Option2, 'RIGHT', 4, 0)
		f.Option3:SetText('')
		f.Option3:Hide()
		f.Option3:SetScript('OnShow', function() f.Option1:SetWidth(100); f.Option1:ClearAllPoints(); f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); f.Option2:SetWidth(100); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOM', f, 'BOTTOM', 0, 45)  end)
		f.Option3:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
		E.Skins:HandleButton(f.Option3, true)			
		
		f.Option4 = CreateFrame('Button', 'InstallOption4Button', f, 'UIPanelButtonTemplate')
		f.Option4:StripTextures()
		f.Option4:Size(100, 30)
		f.Option4:Point('LEFT', f.Option3, 'RIGHT', 4, 0)
		f.Option4:SetText('')
		f.Option4:Hide()
		f.Option4:SetScript('OnShow', function() 
			f.Option1:Width(100)
			f.Option2:Width(100)
			
			f.Option1:ClearAllPoints(); 
			f.Option1:Point('RIGHT', f.Option2, 'LEFT', -4, 0); 
			f.Option2:ClearAllPoints(); 
			f.Option2:Point('BOTTOMRIGHT', f, 'BOTTOM', -4, 45)  
		end)
		f.Option4:SetScript('OnHide', function() f.Option1:SetWidth(160); f.Option1:ClearAllPoints(); f.Option1:Point('BOTTOM', 0, 45); f.Option2:SetWidth(110); f.Option2:ClearAllPoints(); f.Option2:Point('BOTTOMLEFT', f, 'BOTTOM', 4, 45) end)
		E.Skins:HandleButton(f.Option4, true)			

		f.SubTitle = f:CreateFontString(nil, 'OVERLAY')
		f.SubTitle:FontTemplate(nil, 15, nil)		
		f.SubTitle:Point('TOP', 0, -40)
		
		f.Desc1 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc1:FontTemplate()	
		f.Desc1:Point('TOPLEFT', 20, -75)	
		f.Desc1:Width(f:GetWidth() - 40)
		
		f.Desc2 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc2:FontTemplate()	
		f.Desc2:Point('TOPLEFT', 20, -125)		
		f.Desc2:Width(f:GetWidth() - 40)
		
		f.Desc3 = f:CreateFontString(nil, 'OVERLAY')
		f.Desc3:FontTemplate()	
		f.Desc3:Point('TOPLEFT', 20, -175)	
		f.Desc3:Width(f:GetWidth() - 40)
	
		local close = CreateFrame('Button', 'InstallCloseButton', f, 'UIPanelCloseButton')
		close:SetPoint('TOPRIGHT', f, 'TOPRIGHT')
		close:SetScript('OnClick', function()
			f:Hide()
		end)		
		E.Skins:HandleCloseButton(close)
		
		f.tutorialImage = f:CreateTexture('InstallTutorialImage', 'OVERLAY')
		f.tutorialImage:Size(256, 128)
		f.tutorialImage:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')
		f.tutorialImage:Point('BOTTOM', 0, 70)

	end
	
	BUIInstallFrame:Show()
	NextPage()
end