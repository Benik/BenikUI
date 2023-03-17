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
	self.FlightMode.top.location.text:SetText(displayLine)
	self.FlightMode.top.location.text:SetTextColor(r, g, b)
	self.FlightMode.top.location.text:Width(LOCATION_WIDTH - 30)
end

function mod:UpdateCoords()
	local x, y = self.CreateCoords()
	local xt,yt

	if x == 0 and y == 0 then
		self.FlightMode.top.location.x.text:SetText("-")
		self.FlightMode.top.location.y.text:SetText("-")
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
		self.FlightMode.top.location.x.text:SetText(xt)
		self.FlightMode.top.location.y.text:SetText(yt)
	end
end

function mod:UpdateTimer()
	local time = GetTime() - self.startTime
	self.FlightMode.bottom.timeFlying.txt:SetFormattedText("%02d:%02d", floor(time/60), time % 60)

	local createdTime = BUI:createTime()
	self.FlightMode.top.timeText:SetFormattedText(createdTime)
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
	self.FlightMode.bottom.fps.txt:SetFormattedText(displayFormat, value)
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
	local tracking = MinimapCluster.Tracking and MinimapCluster.Tracking.Button or _G.MiniMapTrackingFrame or _G.MiniMapTracking

	if(status) then
		self.inFlightMode = true
		self.FlightMode:Show()
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

		C_TimerAfter(0.05, function()
			_G.MainMenuBarVehicleLeaveButton:Hide()
			tracking:SetAlpha(0)
		end)

		self.FlightMode.bottom.map:EnableMouse(true)
		self.FlightMode.top.menuButton:EnableMouse(true)

		-- Bags
		if ElvUI_ContainerFrame then
			ElvUI_ContainerFrame:SetParent(self.FlightMode)
			if ElvUI_ContainerFrame.wideshadow then
				ElvUI_ContainerFrame.wideshadow:Show()
			end
			if ElvUI_ContainerFrame.shadow then
				ElvUI_ContainerFrame.shadow:Hide()
			end
		end

		-- Left Chat
		if E.private.chat.enable then
			BuiDummyChat:SetParent(self.FlightMode)
			LeftChatPanel:SetParent(self.FlightMode)
			if LeftChatPanel.backdrop.shadow then
				LeftChatPanel.backdrop.shadow:Hide()
			end
			LeftChatPanel.backdrop.wideshadow:Show()
			LeftChatPanel.backdrop.wideshadow:SetFrameStrata('BACKGROUND') -- it loses its framestrata somehow. Needs digging
			LeftChatPanel:ClearAllPoints()
			LeftChatPanel:Point("BOTTOMLEFT", self.FlightMode.bottom, "TOPLEFT", 24, 24)

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

		self.startTime = GetTime()
		self.timer = self:ScheduleRepeatingTimer('UpdateTimer', 1)
		self.locationTimer = self:ScheduleRepeatingTimer('UpdateLocation', 0.2)
		self.coordsTimer = self:ScheduleRepeatingTimer('UpdateCoords', 0.2)
		self.fpsTimer = self:ScheduleRepeatingTimer('UpdateFps', 1)

		self:SkinInFlight()
	elseif(self.inFlightMode) then
		self.inFlightMode = false
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

		_G.MainMenuBarVehicleLeaveButton:SetScript('OnShow', nil)

		self.FlightMode:Hide()

		-- Enable Blizz location messsages.
		-- Added support for LocationPlus & NutsAndBolts LocationLite
		if (BUI.LP and E.db.locplus.zonetext) or (BUI.NB and not E.db.NutsAndBolts.LocationLite.hideDefaultZonetext) then
			ZoneTextFrame:UnregisterAllEvents()
		else
			ZoneTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			ZoneTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
			ZoneTextFrame:RegisterEvent("ZONE_CHANGED")
		end

		self:CancelAllTimers()

		self.FlightMode.bottom.timeFlying.txt:SetText("00:00")
		self.FlightMode.bottom.requestStop:EnableMouse(true)
		self.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)
		self.FlightMode.message:Hide()

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

		if BUI.AS then
			local AS = unpack(AddOnSkins) or nil
			if AS.db.EmbedSystem or AS.db.EmbedSystemDual then AS:Embed_Show() end
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
				self:SetFlightMode(false)
			end
		else
			self:SetFlightMode(false)
		end
		return
	end

	if IsInInstance() then return end

	if (UnitOnTaxi("player")) then
		self:SetFlightMode(true)
	else
		self:SetFlightMode(false)
	end
end

function mod:ToggleLogo()
	if E.db.benikui.misc.flightMode.enable ~= true then return end
	local db = E.db.benikui.misc.flightMode.logo

	if db == 'WOW' then
		self.FlightMode.bottom.wowlogo:Show()
		self.FlightMode.bottom.benikui:Hide()
		self.FlightMode.bottom.logo:Hide()
	elseif db == 'BENIKUI' then
		self.FlightMode.bottom.wowlogo:Hide()
		self.FlightMode.bottom.benikui:Show()
		self.FlightMode.bottom.logo:Show()
	else
		self.FlightMode.bottom.wowlogo:Hide()
		self.FlightMode.bottom.benikui:Hide()
		self.FlightMode.bottom.logo:Hide()
	end
end

function mod:Toggle()
	if(E.db.benikui.misc.flightMode.enable) then
		self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "OnEvent")
		self:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR", "OnEvent")
		self:RegisterEvent("LFG_PROPOSAL_SHOW", "OnEvent")
		self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", "OnEvent")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
		BUI:LoadInFlightProfile(true)
	else
		self:UnregisterEvent("UPDATE_BONUS_ACTIONBAR")
		self:UnregisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
		self:UnregisterEvent("LFG_PROPOSAL_SHOW")
		self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		BUI:LoadInFlightProfile(false)
	end
end

function mod:Initialize()
	local db = E.db.benikui.colors
	self.FlightMode = CreateFrame("Frame", "BenikUIFlightModeFrame", UIParent)
	self.FlightMode:SetFrameLevel(1)
	self.FlightMode:SetFrameStrata('BACKGROUND')
	self.FlightMode:SetAllPoints(UIParent)
	self.FlightMode:Hide()

	-- Top frame
	self.FlightMode.top = CreateFrame('Frame', nil, self.FlightMode)
	self.FlightMode.top:SetFrameLevel(0)
	self.FlightMode.top:SetFrameStrata("HIGH")
	self.FlightMode.top:Point("TOP", self.FlightMode, "TOP", 0, E.Border)
	self.FlightMode.top:SetTemplate('Transparent', true, true)
	self.FlightMode.top:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top:CreateWideShadow()
	self.FlightMode.top:Width(GetScreenWidth() + (E.Border*2))
	self.FlightMode.top:Height(40)

	-- Menu button
	self.FlightMode.top.menuButton = CreateFrame('Button', 'FlightModeMenuBtn', self.FlightMode.top)
	self.FlightMode.top.menuButton:Size(32, 32)
	self.FlightMode.top.menuButton:Point("LEFT", self.FlightMode.top, "LEFT", 6, 0)

	self.FlightMode.top.menuButton.img = self.FlightMode.top.menuButton:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.top.menuButton.img:Point("CENTER")
	self.FlightMode.top.menuButton.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\menu.tga')
	self.FlightMode.top.menuButton.img:SetVertexColor(1, 1, 1, .7)

	self.FlightMode.top.menuButton:SetScript('OnEnter', function()
		GameTooltip:SetOwner(self.FlightMode.top.menuButton, 'ANCHOR_BOTTOMRIGHT', 4, -4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Show an enhanced game menu'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			self.FlightMode.top.menuButton.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			self.FlightMode.top.menuButton.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			self.FlightMode.top.menuButton.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	self.FlightMode.top.menuButton:SetScript('OnLeave', function()
		self.FlightMode.top.menuButton.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	self.FlightMode.top.menuButton:SetScript('OnClick', function()
		BUI:Dropmenu(BUI.MenuList, menuFrame, FlightModeMenuBtn, 'bRight', (E.PixelMode and -32 or -30), (E.PixelMode and -13 or -15), 4, 36)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end)

	-- Close button
	self.FlightMode.top.closeButton = CreateFrame('Button', nil, self.FlightMode.top)
	self.FlightMode.top.closeButton:Size(32, 32)
	self.FlightMode.top.closeButton:Point("RIGHT", self.FlightMode.top, "RIGHT", -6, 0)

	self.FlightMode.top.closeButton.img = self.FlightMode.top.closeButton:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.top.closeButton.img:Point("CENTER")
	self.FlightMode.top.closeButton.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\close.tga')
	self.FlightMode.top.closeButton.img:SetVertexColor(1, 1, 1, .7)

	self.FlightMode.top.closeButton:SetScript('OnEnter', function()
		GameTooltip:SetOwner(self.FlightMode.top.closeButton, 'ANCHOR_BOTTOMLEFT', -4, -4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Exit FlightMode'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			self.FlightMode.top.closeButton.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			self.FlightMode.top.closeButton.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			self.FlightMode.top.closeButton.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	self.FlightMode.top.closeButton:SetScript('OnLeave', function()
		self.FlightMode.top.closeButton.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	self.FlightMode.top.closeButton:SetScript('OnClick', function()
		mod:SetFlightMode(false)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end)

	-- Time
	self.FlightMode.top.timeText = self.FlightMode.top:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.timeText:FontTemplate(nil, 14)
	self.FlightMode.top.timeText:Point('RIGHT', self.FlightMode.top.closeButton, 'LEFT', -10, 0)
	self.FlightMode.top.timeText:SetTextColor(classColor.r, classColor.g, classColor.b)
	self.FlightMode.top.timeText:SetText("")

	-- Location frame
	self.FlightMode.top.location = CreateFrame('Frame', 'FlightModeLocation', self.FlightMode.top)
	self.FlightMode.top.location:SetFrameLevel(1)
	self.FlightMode.top.location:SetTemplate('Default', true, true)
	self.FlightMode.top.location:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top.location:CreateWideShadow()
	self.FlightMode.top.location:Point("TOP", self.FlightMode.top, "CENTER", 0, 6)
	self.FlightMode.top.location:Width(LOCATION_WIDTH)
	self.FlightMode.top.location:Height(50)

	self.FlightMode.top.location.text = self.FlightMode.top.location:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.text:Point('CENTER')
	self.FlightMode.top.location.text:SetWordWrap(false)

	-- Coords X frame
	self.FlightMode.top.location.x = CreateFrame('Frame', nil, self.FlightMode.top.location)
	self.FlightMode.top.location.x:SetTemplate('Default', true, true)
	self.FlightMode.top.location.x:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top.location.x:CreateWideShadow()
	self.FlightMode.top.location.x:Point("RIGHT", self.FlightMode.top.location, "LEFT", (E.PixelMode and -4 or -6), 0)
	self.FlightMode.top.location.x:Width(60)
	self.FlightMode.top.location.x:Height(40)

	self.FlightMode.top.location.x.text = self.FlightMode.top.location.x:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.x.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.x.text:Point('CENTER')

	-- Coords Y frame
	self.FlightMode.top.location.y = CreateFrame('Frame', nil, self.FlightMode.top.location)
	self.FlightMode.top.location.y:SetTemplate('Default', true, true)
	self.FlightMode.top.location.y:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top.location.y:CreateWideShadow()
	self.FlightMode.top.location.y:Point("LEFT", self.FlightMode.top.location, "RIGHT", (E.PixelMode and 4 or 6), 0)
	self.FlightMode.top.location.y:Width(60)
	self.FlightMode.top.location.y:Height(40)

	self.FlightMode.top.location.y.text = self.FlightMode.top.location.y:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.y.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.y.text:Point('CENTER')

	-- Bottom frame
	self.FlightMode.bottom = CreateFrame("Frame", nil, self.FlightMode)
	self.FlightMode.bottom:SetFrameLevel(0)
	self.FlightMode.bottom:SetTemplate('Transparent', true, true)
	self.FlightMode.bottom:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.bottom:CreateWideShadow()
	self.FlightMode.bottom:Point("BOTTOM", self.FlightMode, "BOTTOM", 0, -E.Border)
	self.FlightMode.bottom:Width(GetScreenWidth() + (E.Border*2))
	self.FlightMode.bottom:Height(52)

	-- BenikUI logo
	self.FlightMode.bottom.logo = self.FlightMode:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.logo:Size(420, 105)
	self.FlightMode.bottom.logo:Point("BOTTOM", self.FlightMode.bottom, "CENTER", 0, -20)
	self.FlightMode.bottom.logo:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')
	self.FlightMode.bottom.logo:Hide()

	-- WoW logo
	self.FlightMode.bottom.wowlogo = CreateFrame('Frame', nil, mod.FlightMode) -- need this to upper the logo layer
	self.FlightMode.bottom.wowlogo:Point("BOTTOM", self.FlightMode.bottom, "CENTER", 0, -20)
	self.FlightMode.bottom.wowlogo:SetFrameStrata("MEDIUM")
	self.FlightMode.bottom.wowlogo:Size(300, 150)
	self.FlightMode.bottom.wowlogo.tex = self.FlightMode.bottom.wowlogo:CreateTexture(nil, 'OVERLAY')
	local currentExpansionLevel = GetClampedCurrentExpansionLevel();
	local expansionDisplayInfo = GetExpansionDisplayInfo(currentExpansionLevel);
	if expansionDisplayInfo then
		self.FlightMode.bottom.wowlogo.tex:SetTexture(expansionDisplayInfo.logo)
	end
	self.FlightMode.bottom.wowlogo.tex:SetInside()
	self.FlightMode.bottom.wowlogo:Hide()

	-- BenikUI version
	self.FlightMode.bottom.benikui = self.FlightMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.bottom.benikui:FontTemplate(nil, 10)
	self.FlightMode.bottom.benikui:SetFormattedText("v%s", BUI.Version)
	self.FlightMode.bottom.benikui:Point("TOP", self.FlightMode.bottom.logo, "BOTTOM", 0, 12)
	self.FlightMode.bottom.benikui:SetTextColor(1, 1, 1)
	self.FlightMode.bottom.benikui:Hide()

	-- Message frame. Shows when request stop is pressed
	self.FlightMode.message = CreateFrame("Frame", nil, self.FlightMode)
	self.FlightMode.message:SetFrameLevel(0)
	self.FlightMode.message:Point("CENTER", UIParent, "CENTER")
	self.FlightMode.message:Size(10, 30)
	self.FlightMode.message:Hide()

	self.FlightMode.message.text = self.FlightMode.message:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.message.text:FontTemplate(nil, 18)
	self.FlightMode.message.text:SetFormattedText("%s", TAXI_CANCEL_DESCRIPTION)
	self.FlightMode.message.text:Point("CENTER")
	self.FlightMode.message.text:SetTextColor(1, 1, 0, .7)
	self.FlightMode.message.text:SetAlpha(0)

	-- Request Stop button
	self.FlightMode.bottom.requestStop = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.requestStop:Size(32, 32)
	self.FlightMode.bottom.requestStop:Point("LEFT", self.FlightMode.bottom, "LEFT", 10, 0)
	self.FlightMode.bottom.requestStop:EnableMouse(true)

	self.FlightMode.bottom.requestStop.img = self.FlightMode.bottom.requestStop:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.requestStop.img:Point("CENTER")
	self.FlightMode.bottom.requestStop.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow.tga')
	self.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)

	self.FlightMode.bottom.requestStop:SetScript('OnEnter', function()
		GameTooltip:SetOwner(self.FlightMode.bottom.requestStop, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION, selectioncolor)
		GameTooltip:AddLine(L['LeftClick to Request Stop'], 0.7, 0.7, 1)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			self.FlightMode.bottom.requestStop.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			self.FlightMode.bottom.requestStop.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			self.FlightMode.bottom.requestStop.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	self.FlightMode.bottom.requestStop:SetScript('OnLeave', function()
		self.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	self.FlightMode.bottom.requestStop:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		TaxiRequestEarlyLanding();
		self.FlightMode.bottom.requestStop:EnableMouse(false)
		self.FlightMode.bottom.requestStop.img:SetVertexColor(1, 0, 0, .7)
		self.FlightMode.message:Show()
		C_TimerAfter(.5, function()
			UIFrameFadeIn(self.FlightMode.message.text, 1, 0, 1)
		end)
		C_TimerAfter(8, function()
			UIFrameFadeOut(self.FlightMode.message, 1, 1, 0)
		end)
	end)

	-- Toggle Location button
	self.FlightMode.bottom.info = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.info:Size(32, 32)
	self.FlightMode.bottom.info:Point("LEFT", self.FlightMode.bottom.requestStop, "RIGHT", 10, 0)

	self.FlightMode.bottom.info.img = self.FlightMode.bottom.info:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.info.img:Point("CENTER")
	self.FlightMode.bottom.info.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\info.tga')
	self.FlightMode.bottom.info.img:SetVertexColor(1, 1, 1, .7)

	self.FlightMode.bottom.info:SetScript('OnEnter', function()
		GameTooltip:SetOwner(self.FlightMode.bottom.info, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Toggle Location and Coords'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			self.FlightMode.bottom.info.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			self.FlightMode.bottom.info.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			self.FlightMode.bottom.info.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	self.FlightMode.bottom.info:SetScript('OnLeave', function()
		self.FlightMode.bottom.info.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	self.FlightMode.bottom.info:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		if FlightModeLocation:GetAlpha() == 1 then
			UIFrameFadeOut(FlightModeLocation, 0.2, 1, 0)
		else
			UIFrameFadeIn(FlightModeLocation, 0.2, 0, 1)
		end
	end)

	-- Toggle Map button
	self.FlightMode.bottom.map = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.map:Size(32, 32)
	self.FlightMode.bottom.map:Point("LEFT", self.FlightMode.bottom.info, "RIGHT", 10, 0)

	self.FlightMode.bottom.map.img = self.FlightMode.bottom.map:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.map.img:Point("CENTER")
	self.FlightMode.bottom.map.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\map.tga')
	self.FlightMode.bottom.map.img:SetVertexColor(1, 1, 1, .7)

	self.FlightMode.bottom.map:SetScript('OnEnter', function()
		GameTooltip:SetOwner(self.FlightMode.bottom.map, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Toggle World Map'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			self.FlightMode.bottom.map.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			self.FlightMode.bottom.map.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			self.FlightMode.bottom.map.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	self.FlightMode.bottom.map:SetScript('OnLeave', function()
		self.FlightMode.bottom.map.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	self.FlightMode.bottom.map:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		ToggleWorldMap()
	end)

	-- Toggle bags button
	self.FlightMode.bottom.bags = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.bags:Size(32, 32)
	self.FlightMode.bottom.bags:Point("LEFT", self.FlightMode.bottom.map, "RIGHT", 10, 0)

	self.FlightMode.bottom.bags.img = self.FlightMode.bottom.bags:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.bags.img:Point("CENTER")
	self.FlightMode.bottom.bags.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\bags.tga')
	self.FlightMode.bottom.bags.img:SetVertexColor(1, 1, 1, .7)

	self.FlightMode.bottom.bags:SetScript('OnEnter', function()
		GameTooltip:SetOwner(self.FlightMode.bottom.bags, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Toggle Bags'], selectioncolor)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			self.FlightMode.bottom.bags.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			self.FlightMode.bottom.bags.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			self.FlightMode.bottom.bags.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)

	self.FlightMode.bottom.bags:SetScript('OnLeave', function()
		self.FlightMode.bottom.bags.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)

	self.FlightMode.bottom.bags:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		_G.ToggleAllBags()
	end)

	-- Time flying
	self.FlightMode.bottom.timeFlying = CreateFrame('Frame', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.timeFlying:Point("RIGHT", self.FlightMode.bottom, "RIGHT", -10, 0)
	self.FlightMode.bottom.timeFlying:SetTemplate("Default", true, true)
	self.FlightMode.bottom.timeFlying:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.bottom.timeFlying:Size(70,30)
	self.FlightMode.bottom.timeFlying.txt = self.FlightMode.bottom.timeFlying:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.bottom.timeFlying.txt:FontTemplate(nil, 14)
	self.FlightMode.bottom.timeFlying.txt:SetText("00:00")
	self.FlightMode.bottom.timeFlying.txt:Point("CENTER", self.FlightMode.bottom.timeFlying, "CENTER")
	self.FlightMode.bottom.timeFlying.txt:SetTextColor(1, 1, 1)

	-- fps
	self.FlightMode.bottom.fps = CreateFrame('Frame', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.fps:Point('RIGHT', self.FlightMode.bottom.timeFlying, 'LEFT', -10, 0)
	self.FlightMode.bottom.fps:SetTemplate("Default", true, true)
	self.FlightMode.bottom.fps:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.bottom.fps:Size(70,30)
	self.FlightMode.bottom.fps.txt = self.FlightMode.bottom.fps:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.bottom.fps.txt:FontTemplate(nil, 14)
	self.FlightMode.bottom.fps.txt:Point('CENTER', self.FlightMode.bottom.fps, 'CENTER')
	self.FlightMode.bottom.fps.txt:SetText("")

	-- Add Shadow at the bags
	if ElvUI_ContainerFrame then
		ElvUI_ContainerFrame:CreateWideShadow()
		ElvUI_ContainerFrame.wideshadow:Hide()
	end

	-- Add Shadow at the left chat
	LeftChatPanel.backdrop:CreateWideShadow()
	LeftChatPanel.backdrop.wideshadow:Hide()
	LeftChatPanel.backdrop.wideshadow:SetFrameLevel(LeftChatPanel.backdrop:GetFrameLevel() - 1)

	self:Toggle()
	self:ToggleLogo()

	hooksecurefunc(M, "SetLargeWorldMap", mod.SetFrameParent)
	hooksecurefunc(M, "SetSmallWorldMap", mod.SetFrameParent)
	
	-- force databars parent. This should fix databars showing after a Pet Battle
	E.FrameLocks['ElvUI_ExperienceBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_ReputationBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_HonorBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_AzeriteBar'] = { parent = E.UIParent }
end

BUI:RegisterModule(mod:GetName())
