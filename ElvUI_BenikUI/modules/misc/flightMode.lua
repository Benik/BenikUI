local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('FlightMode')
local AB = E:GetModule('ActionBars')
local LO = E:GetModule('Layout')
local M = E:GetModule('WorldMap')

local _G = _G
local GetTime = GetTime
local unpack, floor, pairs, tinsert, twipe = unpack, floor, pairs, table.insert, table.wipe
local join = string.join

local GameTooltip = _G["GameTooltip"]
local C_TimerAfter = C_Timer.After
local CreateFrame = CreateFrame
local UnitOnTaxi, IsAddOnLoaded = UnitOnTaxi, IsAddOnLoaded
local GetRealZoneText, GetMinimapZoneText, GetZonePVPInfo = GetRealZoneText, GetMinimapZoneText, GetZonePVPInfo
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local GetScreenWidth = GetScreenWidth
local InCombatLockdown = InCombatLockdown
local TaxiRequestEarlyLanding = TaxiRequestEarlyLanding
local UIFrameFadeIn, UIFrameFadeOut, PlaySound = UIFrameFadeIn, UIFrameFadeOut, PlaySound
local TAXI_CANCEL_DESCRIPTION, UNKNOWN = TAXI_CANCEL_DESCRIPTION, UNKNOWN
local MinimapCluster = _G.MinimapCluster

-- GLOBALS: UIParent, FlightModeLocation, selectioncolor, LeftChatPanel, ElvUI_ContainerFrame
-- GLOBALS: FlightModeMenuBtn, LeftChatMover, BuiDummyChat, Minimap, AddOnSkins
-- GLOBALS: ObjectiveTrackerFrame, ZoneTextFrame

local menuFrame = CreateFrame('Frame', 'BuiGameClickMenu', E.UIParent)
menuFrame:SetTemplate('Transparent', true)
menuFrame:CreateWideShadow()

local LOCATION_WIDTH = 399
local classColor = E:ClassColor(E.myclass, true)

local function AutoColoring()
	local pvpType = GetZonePVPInfo()

	if (pvpType == "sanctuary") then
		return 0.41, 0.8, 0.94
	elseif(pvpType == "arena") then
		return 1, 0.1, 0.1
	elseif(pvpType == "friendly") then
		return 0.1, 1, 0.1
	elseif(pvpType == "hostile") then
		return 1, 0.1, 0.1
	elseif(pvpType == "contested") then
		return 1, 0.7, 0.10
	elseif(pvpType == "combat" ) then
		return 1, 0.1, 0.1
	else
		return 1, 1, 0
	end
end

function mod:CreateCoords()
	local mapID = C_Map_GetBestMapForUnit("player")
	local mapPos = mapID and C_Map_GetPlayerMapPosition(mapID, "player")
	if mapPos then x, y = mapPos:GetXY() end

	x = (mapPos and x) and E:Round(100 * x) or 0
	y = (mapPos and y) and E:Round(100 * y) or 0

	return x, y
end

function mod:UpdateLocation()
	local subZoneText = GetMinimapZoneText() or ""
	local zoneText = GetRealZoneText() or UNKNOWN;
	local displayLine

	if (subZoneText ~= "") and (subZoneText ~= zoneText) then
		displayLine = zoneText .. ": " .. subZoneText
	else
		displayLine = subZoneText
	end

	local r, g, b = AutoColoring()
	mod.FlightMode.top.location.text:SetText(displayLine)
	mod.FlightMode.top.location.text:SetTextColor(r, g, b)
	mod.FlightMode.top.location.text:Width(LOCATION_WIDTH - 30)
end

function mod:UpdateCoords()
	local x, y = mod.CreateCoords()
	local xt,yt

	if x == 0 and y == 0 then
		mod.FlightMode.top.location.x.text:SetText("-")
		mod.FlightMode.top.location.y.text:SetText("-")
	else
		if x < 10 then
			xt = "0"..x
		else
			xt = x
		end

		if y < 10 then
			yt = "0"..y
		else
			yt = y
		end
		mod.FlightMode.top.location.x.text:SetText(xt)
		mod.FlightMode.top.location.y.text:SetText(yt)
	end
end

function mod:UpdateTimer()
	local time = GetTime() - mod.startTime
	mod.FlightMode.bottom.timeFlying.txt:SetFormattedText("%02d:%02d", floor(time/60), time % 60)

	local createdTime = BUI:createTime()
	mod.FlightMode.top.timeText:SetFormattedText(createdTime)
end

local statusColors = {
	'|cff0CD809',	-- green
	'|cffE8DA0F',	-- yellow
	'|cffD80909'	-- red
}

function mod:UpdateFps()
	local value = floor(GetFramerate())
	local fpscolor = 3
	local max = 120

	if(value * 100 / max >= 45) then
		fpscolor = 1
	elseif value * 100 / max < 45 and value * 100 / max > 30 then
		fpscolor = 2
	else
		fpscolor = 3
	end
	local displayFormat = join('', statusColors[fpscolor], '%d|rFps')
	mod.FlightMode.bottom.fps.txt:SetFormattedText(displayFormat, value)
end

function mod:SetFrameParent()
	if E.db.benikui.misc.flightMode.enable ~= true then return end

	local WorldMapFrame = _G.WorldMapFrame
	if mod.inFlightMode == true then
		WorldMapFrame:SetParent(_G.UIParent)
		if BUI.PA then
			if SquareMinimapButtonBar then
				SquareMinimapButtonBar:SetParent(E.UIParent)
			end
		end
	else
		WorldMapFrame:SetParent(E.UIParent)
		if BUI.PA then
			if SquareMinimapButtonBar then
				SquareMinimapButtonBar:SetParent(_G.UIParent)
			end
		end
	end
end

local isInFlightLoaded = false

function mod:SkinInFlight()
	if not isInFlightLoaded then
		if not BUI.IF then
			LoadAddOn("InFlight") -- LOD addon
			isInFlightLoaded = true
		end
	end

	local frame = _G["InFlightBar"]
	if frame then
		if not frame.isSkinned then
			frame:CreateBackdrop('Transparent', true, true)
			frame.backdrop:SetOutside(frame, 2, 2)
			frame.backdrop:SetBackdropBorderColor(.3, .3, .3, 1)
			frame.backdrop:CreateWideShadow()
			frame.isSkinned = true
		end
	end
end

local DCR = _G.LibStub('AceAddon-3.0'):GetAddon('Decursive', true)
local function Decursive(hide)
	if not DCR then return end
	if hide then
		DcrMUFsContainer:Hide()
	else
		if DCR.profile.ShowDebuffsFrame == true then
			DcrMUFsContainer:Show()
		end
	end
end

local AddonsToHide = {
	-- addon, frame
	{'ZygorGuidesViewer', 'ZygorGuidesViewerFrame'},
	{'ZygorGuidesViewer', 'Zygor_Notification_Center'},
	{'ZygorGuidesViewer', 'ZygorGuidesViewer_ActionBar'},
	{'WorldQuestTracker', 'WorldQuestTrackerScreenPanel'},
	{'WorldQuestTracker', 'WorldQuestTrackerFinderFrame'},
	{'XIV_Databar', 'XIV_Databar'},
	{'VuhDo', 'VuhDoBuffWatchMainFrame'},
	{'WeakAuras', 'WeakAurasFrame'},
	{'HeroRotation','HeroRotation_ToggleIconFrame'},
	{'!KalielsTracker','!KalielsTrackerFrame'},
	{'!KalielsTracker','!KalielsTrackerButtons'},
	{'RareTrackerCore','RT'},
}

local AllTheThingsFrames = {}
local VisibleFrames = {}

function mod:SetFlightMode(status)
	if(InCombatLockdown()) then return end
	local tracking = MinimapCluster.TrackingFrame and MinimapCluster.TrackingFrame.Button or _G.MiniMapTrackingFrame or _G.MiniMapTracking

	if(status) then
		mod.inFlightMode = true
		mod.FlightMode:Show()
		mod:SetFrameParent()

		E.UIParent:Hide()

		-- Hide some frames
		if ObjectiveTrackerFrame then ObjectiveTrackerFrame:Hide() end
		if E.private.general.minimap.enable then
			Minimap:Hide()
		end

		if _G.ZoneAbilityFrame and _G.ZoneAbilityFrame:GetParent() then
			_G.ZoneAbilityFrame:GetParent():Hide()
		end

		if not E.db.general.addonCompartment.hide then
			_G.AddonCompartmentFrame:Hide()
		end

		C_TimerAfter(0.05, function()
			_G.MainMenuBarVehicleLeaveButton:Hide()
			tracking:SetAlpha(0)
		end)

		mod.FlightMode.bottom.map:EnableMouse(true)
		mod.FlightMode.top.menuButton:EnableMouse(true)

		-- Bags
		if ElvUI_ContainerFrame then
			ElvUI_ContainerFrame:SetParent(mod.FlightMode)
			if ElvUI_ContainerFrame.wideshadow then
				ElvUI_ContainerFrame.wideshadow:Show()
			end
			if ElvUI_ContainerFrame.shadow then
				ElvUI_ContainerFrame.shadow:Hide()
			end
		end

		-- Left Chat
		if E.private.chat.enable then
			BuiDummyChat:SetParent(mod.FlightMode)
			LeftChatPanel:SetParent(mod.FlightMode)
			if LeftChatPanel.backdrop.shadow then
				LeftChatPanel.backdrop.shadow:Hide()
			end
			LeftChatPanel.backdrop.wideshadow:Show()
			LeftChatPanel.backdrop.wideshadow:SetFrameStrata('BACKGROUND') -- it loses its framestrata somehow. Needs digging
			LeftChatPanel:ClearAllPoints()
			LeftChatPanel:Point("BOTTOMLEFT", mod.FlightMode.bottom, "TOPLEFT", 24, 24)

			if LeftChatPanel.backdrop.style then
				LeftChatPanel.backdrop.style:SetFrameStrata('BACKGROUND')
				LeftChatPanel.backdrop.style:SetFrameLevel(2)
				if LeftChatPanel.backdrop.style.styleShadow then
					LeftChatPanel.backdrop.style.styleShadow:SetFrameStrata('BACKGROUND')
					LeftChatPanel.backdrop.style.styleShadow:SetFrameLevel(0)
				end
			end
			_G.LeftChatDataPanel:Hide()
		end

		-- Hide SquareMinimapButtonBar
		if BUI.PA then
			if SquareMinimapButtonBar then
				SquareMinimapButtonBar:Hide()
			end
		end

		for i, v in ipairs(AddonsToHide) do
			local addon, frame = unpack(v)
			if IsAddOnLoaded(addon) then
				if _G[frame] then
					if _G[frame]:IsVisible() then
						VisibleFrames[frame] = true
						_G[frame]:Hide()
					end
				end
			end
		end

		-- special handling for VuhDo panels
		if IsAddOnLoaded('VuhDo') then
			if VUHDO_CONFIG["SHOW_PANELS"] then
				VisibleFrames['VuhDoHealPanels'] = true
				VUHDO_slashCmd('hide')
			end
		end

		--AllTheThings
		if IsAddOnLoaded('AllTheThings') then
			for _, Instance in pairs({ 'Prime', 'CurrentInstance' }) do
				local Window = AllTheThings:GetWindow(Instance)
				if Window:IsShown() then
					tinsert(AllTheThingsFrames, Window)
				end
				Window:Hide()
			end
		end

		-- special handling for Elkano Buff Bars
		if IsAddOnLoaded('ElkBuffBars') then
			ElkBuffBars:PET_BATTLE_OPENING_START()
		end

		-- Decursive
		Decursive(true)

		-- Handle ActionBars. This needs to be done if Global Fade is active
		for _, bar in pairs(AB.handledBars) do
			if bar then
				if bar:GetParent() == AB.fadeParent then
					bar:SetAlpha(0)
				end
			end
		end

		-- Disable Blizz location messsages
		ZoneTextFrame:UnregisterAllEvents()

		mod.startTime = GetTime()
		mod.timer = mod:ScheduleRepeatingTimer('UpdateTimer', 1)
		mod.locationTimer = mod:ScheduleRepeatingTimer('UpdateLocation', 0.2)
		mod.coordsTimer = mod:ScheduleRepeatingTimer('UpdateCoords', 0.2)
		mod.fpsTimer = mod:ScheduleRepeatingTimer('UpdateFps', 1)

		mod:SkinInFlight()
	elseif(mod.inFlightMode) then
		mod.inFlightMode = false
		_G.MainMenuBarVehicleLeaveButton:SetParent(_G.UIParent)
		mod:SetFrameParent()

		E.UIParent:Show()

		-- Show hidden frames
		if ObjectiveTrackerFrame then ObjectiveTrackerFrame:Show() end
		if E.private.general.minimap.enable then
			Minimap:Show()
		end

		tracking:SetAlpha(1)

		if _G.ZoneAbilityFrame and _G.ZoneAbilityFrame:GetParent() then
			_G.ZoneAbilityFrame:GetParent():Show()
		end

		if not E.db.general.addonCompartment.hide then
			_G.AddonCompartmentFrame:Show()
		end

		_G.MainMenuBarVehicleLeaveButton:SetScript('OnShow', nil)

		mod.FlightMode:Hide()

		-- Enable Blizz location messsages.
		-- Added support for LocationPlus & NutsAndBolts LocationLite
		if (BUI.LP and E.db.locplus.zonetext) or (BUI.NB and not E.db.NutsAndBolts.LocationLite.hideDefaultZonetext) then
			ZoneTextFrame:UnregisterAllEvents()
		else
			ZoneTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			ZoneTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
			ZoneTextFrame:RegisterEvent("ZONE_CHANGED")
		end

		mod:CancelAllTimers()

		mod.FlightMode.bottom.timeFlying.txt:SetText("00:00")
		mod.FlightMode.bottom.requestStop:EnableMouse(true)
		mod.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)
		mod.FlightMode.message:Hide()

		-- Revert Bags
		if ElvUI_ContainerFrame then
			ElvUI_ContainerFrame:SetParent(E.UIParent)
			if ElvUI_ContainerFrame.wideshadow then
				ElvUI_ContainerFrame.wideshadow:Hide()
			end
			if ElvUI_ContainerFrame.shadow then
				ElvUI_ContainerFrame.shadow:Show()
			end
		end

		for i, v in ipairs(AddonsToHide) do
			local addon, frame = unpack(v)
			if IsAddOnLoaded(addon) then
				if _G[frame] then
					if VisibleFrames[frame] then
						_G[frame]:Show()
					end
				end
			end
		end

		-- special handling for VuhDo panels
		if IsAddOnLoaded('VuhDo') then
			if VisibleFrames['VuhDoHealPanels'] then
				VUHDO_slashCmd('show')
			end
		end

		--AllTheThings
		if IsAddOnLoaded('AllTheThings') then
			for _, frame in pairs(AllTheThingsFrames) do
				frame:Show()
			end
			twipe(AllTheThingsFrames)
		end

		-- special handling for Elkano Buff Bars
		if IsAddOnLoaded('ElkBuffBars') then
			ElkBuffBars:PET_BATTLE_CLOSE()
		end

		-- Decursive
		Decursive(false)

		-- revert Left Chat
		if E.private.chat.enable then
			BuiDummyChat:SetParent(E.UIParent)
			LeftChatPanel:SetParent(E.UIParent)
			if LeftChatPanel.backdrop.shadow then
				LeftChatPanel.backdrop.shadow:Show()
				LeftChatPanel.backdrop.shadow:SetFrameStrata('BACKGROUND') -- it loses its framestrata somehow. Needs digging
				LeftChatPanel.backdrop.shadow:SetFrameLevel(0)
			end
			if LeftChatPanel.backdrop.style then
				LeftChatPanel.backdrop.style:SetFrameStrata('BACKGROUND')
				LeftChatPanel.backdrop.style:SetFrameLevel(2)
				if LeftChatPanel.backdrop.style.styleShadow then
					LeftChatPanel.backdrop.style.styleShadow:SetFrameStrata('BACKGROUND')
					LeftChatPanel.backdrop.style.styleShadow:SetFrameLevel(0)
				end
			end
			LeftChatPanel.backdrop.wideshadow:Hide()
			LeftChatPanel:ClearAllPoints()
			LeftChatPanel:Point("BOTTOMLEFT", LeftChatMover, "BOTTOMLEFT")
			LeftChatPanel:SetFrameStrata('BACKGROUND')
			LO:RepositionChatDataPanels()
			LO:ToggleChatPanels()
		end

		-- revert Actionbars
		for barName in pairs(AB.handledBars) do
			AB:PositionAndSizeBar(barName)
		end

		-- Show SquareMinimapButtonBar
		if BUI.PA then
			if SquareMinimapButtonBar then
				SquareMinimapButtonBar:Show()
			end
		end

		if _G.BuiTaxiButton then
			_G.BuiTaxiButton:SetParent(E.UIParent)
		end
	end
end

function mod:OnEvent(event, ...)
	local forbiddenArea = BUI:CheckFlightMapID()

	if forbiddenArea then return end

	if(event == "LFG_PROPOSAL_SHOW" or event == "UPDATE_BATTLEFIELD_STATUS") then
		if(event == "UPDATE_BATTLEFIELD_STATUS") then
			local status = GetBattlefieldStatus(...);
			if ( status == "confirm" ) then
				mod:SetFlightMode(false)
			end
		else
			mod:SetFlightMode(false)
		end
		return
	end

	if IsInInstance() then return end

	if (UnitOnTaxi("player")) then
		mod:SetFlightMode(true)
	else
		mod:SetFlightMode(false)
	end
end

function mod:ToggleLogo()
	if E.db.benikui.misc.flightMode.enable ~= true then return end
	local db = E.db.benikui.misc.flightMode.logo

	if db == 'WOW' then
		mod.FlightMode.bottom.wowlogo:Show()
		mod.FlightMode.bottom.benikui:Hide()
		mod.FlightMode.bottom.logo:Hide()
	elseif db == 'BENIKUI' then
		mod.FlightMode.bottom.wowlogo:Hide()
		mod.FlightMode.bottom.benikui:Show()
		mod.FlightMode.bottom.logo:Show()
	else
		mod.FlightMode.bottom.wowlogo:Hide()
		mod.FlightMode.bottom.benikui:Hide()
		mod.FlightMode.bottom.logo:Hide()
	end
end

function mod:Toggle()
	if(E.db.benikui.misc.flightMode.enable) then
		mod:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "OnEvent")
		mod:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR", "OnEvent")
		mod:RegisterEvent("LFG_PROPOSAL_SHOW", "OnEvent")
		mod:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", "OnEvent")
		mod:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
		BUI:LoadInFlightProfile(true)
	else
		mod:UnregisterEvent("UPDATE_BONUS_ACTIONBAR")
		mod:UnregisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
		mod:UnregisterEvent("LFG_PROPOSAL_SHOW")
		mod:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
		mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
		BUI:LoadInFlightProfile(false)
	end
end

function mod:Initialize()
	local db = E.db.benikui.colors
	mod.FlightMode = CreateFrame("Frame", "BenikUIFlightModeFrame", UIParent)
	mod.FlightMode:SetFrameLevel(1)
	mod.FlightMode:SetFrameStrata('BACKGROUND')
	mod.FlightMode:SetAllPoints(UIParent)
	mod.FlightMode:Hide()

	-- Top frame
	mod.FlightMode.top = CreateFrame('Frame', nil, mod.FlightMode)
	mod.FlightMode.top:SetFrameLevel(0)
	mod.FlightMode.top:SetFrameStrata("HIGH")
	mod.FlightMode.top:Point("TOP", mod.FlightMode, "TOP", 0, E.Border)
	mod.FlightMode.top:SetTemplate('Transparent', true, true)
	mod.FlightMode.top:SetBackdropBorderColor(.3, .3, .3, 1)
	mod.FlightMode.top:CreateWideShadow()
	mod.FlightMode.top:Width(GetScreenWidth() + (E.Border*2))
	mod.FlightMode.top:Height(40)

	-- Menu button
	mod.FlightMode.top.menuButton = CreateFrame('Button', 'FlightModeMenuBtn', mod.FlightMode.top)
	mod.FlightMode.top.menuButton:Size(32, 32)
	mod.FlightMode.top.menuButton:Point("LEFT", mod.FlightMode.top, "LEFT", 6, 0)

	mod.FlightMode.top.menuButton.img = mod.FlightMode.top.menuButton:CreateTexture(nil, 'OVERLAY')
	mod.FlightMode.top.menuButton.img:Point("CENTER")
	mod.FlightMode.top.menuButton.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\menu.tga')
	mod.FlightMode.top.menuButton.img:SetVertexColor(1, 1, 1, .7)

	mod.FlightMode.top.menuButton:SetScript('OnEnter', function()
		GameTooltip:SetOwner(mod.FlightMode.top.menuButton, 'ANCHOR_BOTTOMRIGHT', 4, -4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Show an enhanced game menu'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			mod.FlightMode.top.menuButton.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			mod.FlightMode.top.menuButton.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			mod.FlightMode.top.menuButton.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	mod.FlightMode.top.menuButton:SetScript('OnLeave', function()
		mod.FlightMode.top.menuButton.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	mod.FlightMode.top.menuButton:SetScript('OnClick', function()
		BUI:Dropmenu(BUI.MenuList, menuFrame, FlightModeMenuBtn, 'bRight', (E.PixelMode and -32 or -30), (E.PixelMode and -13 or -15), 4, 36)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end)

	-- Close button
	mod.FlightMode.top.closeButton = CreateFrame('Button', nil, mod.FlightMode.top)
	mod.FlightMode.top.closeButton:Size(32, 32)
	mod.FlightMode.top.closeButton:Point("RIGHT", mod.FlightMode.top, "RIGHT", -6, 0)

	mod.FlightMode.top.closeButton.img = mod.FlightMode.top.closeButton:CreateTexture(nil, 'OVERLAY')
	mod.FlightMode.top.closeButton.img:Point("CENTER")
	mod.FlightMode.top.closeButton.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\close.tga')
	mod.FlightMode.top.closeButton.img:SetVertexColor(1, 1, 1, .7)

	mod.FlightMode.top.closeButton:SetScript('OnEnter', function()
		GameTooltip:SetOwner(mod.FlightMode.top.closeButton, 'ANCHOR_BOTTOMLEFT', -4, -4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Exit FlightMode'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			mod.FlightMode.top.closeButton.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			mod.FlightMode.top.closeButton.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			mod.FlightMode.top.closeButton.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	mod.FlightMode.top.closeButton:SetScript('OnLeave', function()
		mod.FlightMode.top.closeButton.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	mod.FlightMode.top.closeButton:SetScript('OnClick', function()
		mod:SetFlightMode(false)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end)

	-- Time
	mod.FlightMode.top.timeText = mod.FlightMode.top:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.top.timeText:FontTemplate(nil, 14)
	mod.FlightMode.top.timeText:Point('RIGHT', mod.FlightMode.top.closeButton, 'LEFT', -10, 0)
	mod.FlightMode.top.timeText:SetTextColor(classColor.r, classColor.g, classColor.b)
	mod.FlightMode.top.timeText:SetText("")

	-- Location frame
	mod.FlightMode.top.location = CreateFrame('Frame', 'FlightModeLocation', mod.FlightMode.top)
	mod.FlightMode.top.location:SetFrameLevel(1)
	mod.FlightMode.top.location:SetTemplate('Default', true, true)
	mod.FlightMode.top.location:SetBackdropBorderColor(.3, .3, .3, 1)
	mod.FlightMode.top.location:CreateWideShadow()
	mod.FlightMode.top.location:Point("TOP", mod.FlightMode.top, "CENTER", 0, 6)
	mod.FlightMode.top.location:Width(LOCATION_WIDTH)
	mod.FlightMode.top.location:Height(50)

	mod.FlightMode.top.location.text = mod.FlightMode.top.location:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.top.location.text:FontTemplate(nil, 18)
	mod.FlightMode.top.location.text:Point('CENTER')
	mod.FlightMode.top.location.text:SetWordWrap(false)

	-- Coords X frame
	mod.FlightMode.top.location.x = CreateFrame('Frame', nil, mod.FlightMode.top.location)
	mod.FlightMode.top.location.x:SetTemplate('Default', true, true)
	mod.FlightMode.top.location.x:SetBackdropBorderColor(.3, .3, .3, 1)
	mod.FlightMode.top.location.x:CreateWideShadow()
	mod.FlightMode.top.location.x:Point("RIGHT", mod.FlightMode.top.location, "LEFT", (E.PixelMode and -4 or -6), 0)
	mod.FlightMode.top.location.x:Width(60)
	mod.FlightMode.top.location.x:Height(40)

	mod.FlightMode.top.location.x.text = mod.FlightMode.top.location.x:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.top.location.x.text:FontTemplate(nil, 18)
	mod.FlightMode.top.location.x.text:Point('CENTER')

	-- Coords Y frame
	mod.FlightMode.top.location.y = CreateFrame('Frame', nil, mod.FlightMode.top.location)
	mod.FlightMode.top.location.y:SetTemplate('Default', true, true)
	mod.FlightMode.top.location.y:SetBackdropBorderColor(.3, .3, .3, 1)
	mod.FlightMode.top.location.y:CreateWideShadow()
	mod.FlightMode.top.location.y:Point("LEFT", mod.FlightMode.top.location, "RIGHT", (E.PixelMode and 4 or 6), 0)
	mod.FlightMode.top.location.y:Width(60)
	mod.FlightMode.top.location.y:Height(40)

	mod.FlightMode.top.location.y.text = mod.FlightMode.top.location.y:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.top.location.y.text:FontTemplate(nil, 18)
	mod.FlightMode.top.location.y.text:Point('CENTER')

	-- Bottom frame
	mod.FlightMode.bottom = CreateFrame("Frame", nil, mod.FlightMode)
	mod.FlightMode.bottom:SetFrameLevel(0)
	mod.FlightMode.bottom:SetTemplate('Transparent', true, true)
	mod.FlightMode.bottom:SetBackdropBorderColor(.3, .3, .3, 1)
	mod.FlightMode.bottom:CreateWideShadow()
	mod.FlightMode.bottom:Point("BOTTOM", mod.FlightMode, "BOTTOM", 0, -E.Border)
	mod.FlightMode.bottom:Width(GetScreenWidth() + (E.Border*2))
	mod.FlightMode.bottom:Height(52)

	-- BenikUI logo
	mod.FlightMode.bottom.logo = mod.FlightMode:CreateTexture(nil, 'OVERLAY')
	mod.FlightMode.bottom.logo:Size(420, 105)
	mod.FlightMode.bottom.logo:Point("BOTTOM", mod.FlightMode.bottom, "CENTER", 0, -20)
	mod.FlightMode.bottom.logo:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')
	mod.FlightMode.bottom.logo:Hide()

	-- WoW logo
	mod.FlightMode.bottom.wowlogo = CreateFrame('Frame', nil, mod.FlightMode) -- need this to upper the logo layer
	mod.FlightMode.bottom.wowlogo:Point("BOTTOM", mod.FlightMode.bottom, "CENTER", 0, -20)
	mod.FlightMode.bottom.wowlogo:SetFrameStrata("MEDIUM")
	mod.FlightMode.bottom.wowlogo:Size(300, 150)
	mod.FlightMode.bottom.wowlogo.tex = mod.FlightMode.bottom.wowlogo:CreateTexture(nil, 'OVERLAY')
	local currentExpansionLevel = GetClampedCurrentExpansionLevel();
	local expansionDisplayInfo = GetExpansionDisplayInfo(currentExpansionLevel);
	if expansionDisplayInfo then
		mod.FlightMode.bottom.wowlogo.tex:SetTexture(expansionDisplayInfo.logo)
	end
	mod.FlightMode.bottom.wowlogo.tex:SetInside()
	mod.FlightMode.bottom.wowlogo:Hide()

	-- BenikUI version
	mod.FlightMode.bottom.benikui = mod.FlightMode.bottom:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.bottom.benikui:FontTemplate(nil, 10)
	mod.FlightMode.bottom.benikui:SetFormattedText("v%s", BUI.Version)
	mod.FlightMode.bottom.benikui:Point("TOP", mod.FlightMode.bottom.logo, "BOTTOM", 0, 12)
	mod.FlightMode.bottom.benikui:SetTextColor(1, 1, 1)
	mod.FlightMode.bottom.benikui:Hide()

	-- Message frame. Shows when request stop is pressed
	mod.FlightMode.message = CreateFrame("Frame", nil, mod.FlightMode)
	mod.FlightMode.message:SetFrameLevel(0)
	mod.FlightMode.message:Point("CENTER", UIParent, "CENTER")
	mod.FlightMode.message:Size(10, 30)
	mod.FlightMode.message:Hide()

	mod.FlightMode.message.text = mod.FlightMode.message:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.message.text:FontTemplate(nil, 18)
	mod.FlightMode.message.text:SetFormattedText("%s", TAXI_CANCEL_DESCRIPTION)
	mod.FlightMode.message.text:Point("CENTER")
	mod.FlightMode.message.text:SetTextColor(1, 1, 0, .7)
	mod.FlightMode.message.text:SetAlpha(0)

	-- Request Stop button
	mod.FlightMode.bottom.requestStop = CreateFrame('Button', nil, mod.FlightMode.bottom)
	mod.FlightMode.bottom.requestStop:Size(32, 32)
	mod.FlightMode.bottom.requestStop:Point("LEFT", mod.FlightMode.bottom, "LEFT", 10, 0)
	mod.FlightMode.bottom.requestStop:EnableMouse(true)

	mod.FlightMode.bottom.requestStop.img = mod.FlightMode.bottom.requestStop:CreateTexture(nil, 'OVERLAY')
	mod.FlightMode.bottom.requestStop.img:Point("CENTER")
	mod.FlightMode.bottom.requestStop.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow.tga')
	mod.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)

	mod.FlightMode.bottom.requestStop:SetScript('OnEnter', function()
		GameTooltip:SetOwner(mod.FlightMode.bottom.requestStop, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION, selectioncolor)
		GameTooltip:AddLine(L['LeftClick to Request Stop'], 0.7, 0.7, 1)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			mod.FlightMode.bottom.requestStop.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			mod.FlightMode.bottom.requestStop.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			mod.FlightMode.bottom.requestStop.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	mod.FlightMode.bottom.requestStop:SetScript('OnLeave', function()
		mod.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	mod.FlightMode.bottom.requestStop:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		TaxiRequestEarlyLanding();
		mod.FlightMode.bottom.requestStop:EnableMouse(false)
		mod.FlightMode.bottom.requestStop.img:SetVertexColor(1, 0, 0, .7)
		mod.FlightMode.message:Show()
		C_TimerAfter(.5, function()
			UIFrameFadeIn(mod.FlightMode.message.text, 1, 0, 1)
		end)
		C_TimerAfter(8, function()
			UIFrameFadeOut(mod.FlightMode.message, 1, 1, 0)
		end)
	end)

	-- Toggle Location button
	mod.FlightMode.bottom.info = CreateFrame('Button', nil, mod.FlightMode.bottom)
	mod.FlightMode.bottom.info:Size(32, 32)
	mod.FlightMode.bottom.info:Point("LEFT", mod.FlightMode.bottom.requestStop, "RIGHT", 10, 0)

	mod.FlightMode.bottom.info.img = mod.FlightMode.bottom.info:CreateTexture(nil, 'OVERLAY')
	mod.FlightMode.bottom.info.img:Point("CENTER")
	mod.FlightMode.bottom.info.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\info.tga')
	mod.FlightMode.bottom.info.img:SetVertexColor(1, 1, 1, .7)

	mod.FlightMode.bottom.info:SetScript('OnEnter', function()
		GameTooltip:SetOwner(mod.FlightMode.bottom.info, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Toggle Location and Coords'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			mod.FlightMode.bottom.info.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			mod.FlightMode.bottom.info.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			mod.FlightMode.bottom.info.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	mod.FlightMode.bottom.info:SetScript('OnLeave', function()
		mod.FlightMode.bottom.info.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	mod.FlightMode.bottom.info:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		if FlightModeLocation:GetAlpha() == 1 then
			UIFrameFadeOut(FlightModeLocation, 0.2, 1, 0)
		else
			UIFrameFadeIn(FlightModeLocation, 0.2, 0, 1)
		end
	end)

	-- Toggle Map button
	mod.FlightMode.bottom.map = CreateFrame('Button', nil, mod.FlightMode.bottom)
	mod.FlightMode.bottom.map:Size(32, 32)
	mod.FlightMode.bottom.map:Point("LEFT", mod.FlightMode.bottom.info, "RIGHT", 10, 0)

	mod.FlightMode.bottom.map.img = mod.FlightMode.bottom.map:CreateTexture(nil, 'OVERLAY')
	mod.FlightMode.bottom.map.img:Point("CENTER")
	mod.FlightMode.bottom.map.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\map.tga')
	mod.FlightMode.bottom.map.img:SetVertexColor(1, 1, 1, .7)

	mod.FlightMode.bottom.map:SetScript('OnEnter', function()
		GameTooltip:SetOwner(mod.FlightMode.bottom.map, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Toggle World Map'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			mod.FlightMode.bottom.map.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			mod.FlightMode.bottom.map.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			mod.FlightMode.bottom.map.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	mod.FlightMode.bottom.map:SetScript('OnLeave', function()
		mod.FlightMode.bottom.map.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	mod.FlightMode.bottom.map:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		ToggleWorldMap()
	end)

	-- Toggle bags button
	mod.FlightMode.bottom.bags = CreateFrame('Button', nil, mod.FlightMode.bottom)
	mod.FlightMode.bottom.bags:Size(32, 32)
	mod.FlightMode.bottom.bags:Point("LEFT", mod.FlightMode.bottom.map, "RIGHT", 10, 0)

	mod.FlightMode.bottom.bags.img = mod.FlightMode.bottom.bags:CreateTexture(nil, 'OVERLAY')
	mod.FlightMode.bottom.bags.img:Point("CENTER")
	mod.FlightMode.bottom.bags.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\bags.tga')
	mod.FlightMode.bottom.bags.img:SetVertexColor(1, 1, 1, .7)

	mod.FlightMode.bottom.bags:SetScript('OnEnter', function()
		GameTooltip:SetOwner(mod.FlightMode.bottom.bags, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Toggle Bags'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			mod.FlightMode.bottom.bags.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			mod.FlightMode.bottom.bags.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			mod.FlightMode.bottom.bags.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	mod.FlightMode.bottom.bags:SetScript('OnLeave', function()
		mod.FlightMode.bottom.bags.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	mod.FlightMode.bottom.bags:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		_G.ToggleAllBags()
	end)

	-- Time flying
	mod.FlightMode.bottom.timeFlying = CreateFrame('Frame', nil, mod.FlightMode.bottom)
	mod.FlightMode.bottom.timeFlying:Point("RIGHT", mod.FlightMode.bottom, "RIGHT", -10, 0)
	mod.FlightMode.bottom.timeFlying:SetTemplate("Default", true, true)
	mod.FlightMode.bottom.timeFlying:SetBackdropBorderColor(.3, .3, .3, 1)
	mod.FlightMode.bottom.timeFlying:Size(70,30)
	mod.FlightMode.bottom.timeFlying.txt = mod.FlightMode.bottom.timeFlying:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.bottom.timeFlying.txt:FontTemplate(nil, 14)
	mod.FlightMode.bottom.timeFlying.txt:SetText("00:00")
	mod.FlightMode.bottom.timeFlying.txt:Point("CENTER", mod.FlightMode.bottom.timeFlying, "CENTER")
	mod.FlightMode.bottom.timeFlying.txt:SetTextColor(1, 1, 1)

	-- fps
	mod.FlightMode.bottom.fps = CreateFrame('Frame', nil, mod.FlightMode.bottom)
	mod.FlightMode.bottom.fps:Point('RIGHT', mod.FlightMode.bottom.timeFlying, 'LEFT', -10, 0)
	mod.FlightMode.bottom.fps:SetTemplate("Default", true, true)
	mod.FlightMode.bottom.fps:SetBackdropBorderColor(.3, .3, .3, 1)
	mod.FlightMode.bottom.fps:Size(70,30)
	mod.FlightMode.bottom.fps.txt = mod.FlightMode.bottom.fps:CreateFontString(nil, 'OVERLAY')
	mod.FlightMode.bottom.fps.txt:FontTemplate(nil, 14)
	mod.FlightMode.bottom.fps.txt:Point('CENTER', mod.FlightMode.bottom.fps, 'CENTER')
	mod.FlightMode.bottom.fps.txt:SetText("")

	-- Add Shadow at the bags
	if ElvUI_ContainerFrame then
		ElvUI_ContainerFrame:CreateWideShadow()
		ElvUI_ContainerFrame.wideshadow:Hide()
	end

	-- Add Shadow at the left chat
	LeftChatPanel.backdrop:CreateWideShadow()
	LeftChatPanel.backdrop.wideshadow:Hide()
	LeftChatPanel.backdrop.wideshadow:SetFrameLevel(LeftChatPanel.backdrop:GetFrameLevel() - 1)

	mod:Toggle()
	mod:ToggleLogo()

	hooksecurefunc(M, "SetLargeWorldMap", mod.SetFrameParent)
	hooksecurefunc(M, "SetSmallWorldMap", mod.SetFrameParent)
	
	-- force databars parent. This should fix databars showing after a Pet Battle
	E.FrameLocks['ElvUI_ExperienceBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_ReputationBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_HonorBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_AzeriteBar'] = { parent = E.UIParent }
end

BUI:RegisterModule(mod:GetName())