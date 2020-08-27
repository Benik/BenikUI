local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('FlightMode', 'AceTimer-3.0', 'AceEvent-3.0');
local LO = E:GetModule('Layout')

local _G = _G
local GetTime = GetTime
local unpack, floor = unpack, floor
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
local ToggleAllBags = ToggleAllBags
local UIFrameFadeIn, UIFrameFadeOut, PlaySound = UIFrameFadeIn, UIFrameFadeOut, PlaySound
local TAXI_CANCEL_DESCRIPTION, UNKNOWN = TAXI_CANCEL_DESCRIPTION, UNKNOWN

-- GLOBALS: UIParent, FlightModeLocation, selectioncolor, LeftChatPanel, ElvUI_ContainerFrame
-- GLOBALS: FlightModeMenuBtn, CreateAnimationGroup, LeftChatMover, BuiDummyChat, Minimap, AddOnSkins
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
	self.FlightMode.top.location.text:SetWidth(LOCATION_WIDTH - 30)
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

local zygorVisible

function mod:SetFlightMode(status)
	if(InCombatLockdown()) then return end

	if(status) then
		self.FlightMode:Show()
		E.UIParent:Hide()

		-- Hide some frames
		if ObjectiveTrackerFrame then ObjectiveTrackerFrame:Hide() end
		if E.private.general.minimap.enable then
			Minimap:Hide()
		end
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
			LeftChatPanel:SetPoint("BOTTOMLEFT", self.FlightMode.bottom, "TOPLEFT", 24, 24)

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
		if (BUI.PA and not BUI.SLE) then
			if SquareMinimapButtonBar then
				_G.SquareMinimapButtons:CancelAllTimers()
				SquareMinimapButtonBar:SetAlpha(0)
			end
		end

		-- Hide Zygor
		if BUI.ZG then
			if ZygorGuidesViewer.db.profile.visible then
				if _G['ZygorGuidesViewerFrame']:IsVisible() then
					zygorVisible = true
				else
					zygorVisible = false
				end

				if _G['ZygorGuidesViewerFrame'] then _G['ZygorGuidesViewerFrame']:Hide() end
			end

			if ZygorGuidesViewer.db.profile.n_nc_enabled then
				if _G['Zygor_Notification_Center'] then _G['Zygor_Notification_Center']:Hide() end
			end
		end

		-- Disable Blizz location messsages
		ZoneTextFrame:UnregisterAllEvents()

		if IsAddOnLoaded("XIV_Databar") then
			XIV_Databar:Hide()
		end

		self.startTime = GetTime()
		self.timer = self:ScheduleRepeatingTimer('UpdateTimer', 1)
		self.locationTimer = self:ScheduleRepeatingTimer('UpdateLocation', 0.2)
		self.coordsTimer = self:ScheduleRepeatingTimer('UpdateCoords', 0.2)
		self.fpsTimer = self:ScheduleRepeatingTimer('UpdateFps', 1)

		self:SkinInFlight()

		self.inFlightMode = true
	elseif(self.inFlightMode) then
		E.UIParent:Show()

		-- Show hidden frames
		if ObjectiveTrackerFrame then ObjectiveTrackerFrame:Show() end
		if E.private.general.minimap.enable then
			Minimap:Show()
		end
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
		self.FlightMode.message:SetAlpha(1)
		self.FlightMode.message:SetWidth(10)
		self.FlightMode.message.text:SetAlpha(0)

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

		-- Show Zygor
		if BUI.ZG then
			if ZygorGuidesViewer.db.profile.visible then
				if zygorVisible then
					if _G['ZygorGuidesViewerFrame'] then _G['ZygorGuidesViewerFrame']:Show() end
				end
			end
			if ZygorGuidesViewer.db.profile.n_nc_enabled then
				if _G['Zygor_Notification_Center'] then _G['Zygor_Notification_Center']:Show() end
			end
		end

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
			LeftChatPanel:SetPoint("BOTTOMLEFT", LeftChatMover, "BOTTOMLEFT")
			LeftChatPanel:SetFrameStrata('BACKGROUND')
			LO:RepositionChatDataPanels()
			LO:ToggleChatPanels()
		end

		-- Show SquareMinimapButtonBar
		if (BUI.PA and not BUI.SLE) then
			if SquareMinimapButtonBar then
				_G.SquareMinimapButtons:ScheduleRepeatingTimer('GrabMinimapButtons', 5)
				SquareMinimapButtonBar:SetAlpha(1)
			end
		end

		if IsAddOnLoaded("XIV_Databar") then
			XIV_Databar:Show()
		end

		BuiTaxiButton:SetParent(E.UIParent)

		self.inFlightMode = false
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
		BUI:LoadInFlightProfile(true)
	else
		self:UnregisterEvent("UPDATE_BONUS_ACTIONBAR")
		self:UnregisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
		self:UnregisterEvent("LFG_PROPOSAL_SHOW")
		self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
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
	self.FlightMode.top:SetPoint("TOP", self.FlightMode, "TOP", 0, E.Border)
	self.FlightMode.top:SetTemplate('Transparent', true, true)
	self.FlightMode.top:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top:CreateWideShadow()
	self.FlightMode.top:SetWidth(GetScreenWidth() + (E.Border*2))
	self.FlightMode.top:SetHeight(40)

	-- Menu button
	self.FlightMode.top.menuButton = CreateFrame('Button', 'FlightModeMenuBtn', self.FlightMode.top)
	self.FlightMode.top.menuButton:SetSize(32, 32)
	self.FlightMode.top.menuButton:SetPoint("LEFT", self.FlightMode.top, "LEFT", 6, 0)

	self.FlightMode.top.menuButton.img = self.FlightMode.top.menuButton:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.top.menuButton.img:SetPoint("CENTER")
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
	self.FlightMode.top.closeButton:SetSize(32, 32)
	self.FlightMode.top.closeButton:SetPoint("RIGHT", self.FlightMode.top, "RIGHT", -6, 0)

	self.FlightMode.top.closeButton.img = self.FlightMode.top.closeButton:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.top.closeButton.img:SetPoint("CENTER")
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

	-- Location frame
	self.FlightMode.top.location = CreateFrame('Frame', 'FlightModeLocation', self.FlightMode.top)
	self.FlightMode.top.location:SetFrameLevel(1)
	self.FlightMode.top.location:SetTemplate('Default', true, true)
	self.FlightMode.top.location:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top.location:CreateWideShadow()
	self.FlightMode.top.location:SetPoint("TOP", self.FlightMode.top, "CENTER", 0, 6)
	self.FlightMode.top.location:SetWidth(LOCATION_WIDTH)
	self.FlightMode.top.location:SetHeight(50)

	self.FlightMode.top.location.text = self.FlightMode.top.location:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.text:SetPoint('CENTER')
	self.FlightMode.top.location.text:SetWordWrap(false)

	-- Coords X frame
	self.FlightMode.top.location.x = CreateFrame('Frame', nil, self.FlightMode.top.location)
	self.FlightMode.top.location.x:SetTemplate('Default', true, true)
	self.FlightMode.top.location.x:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top.location.x:CreateWideShadow()
	self.FlightMode.top.location.x:SetPoint("RIGHT", self.FlightMode.top.location, "LEFT", (E.PixelMode and -4 or -6), 0)
	self.FlightMode.top.location.x:SetWidth(60)
	self.FlightMode.top.location.x:SetHeight(40)

	self.FlightMode.top.location.x.text = self.FlightMode.top.location.x:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.x.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.x.text:SetPoint('CENTER')

	-- Coords Y frame
	self.FlightMode.top.location.y = CreateFrame('Frame', nil, self.FlightMode.top.location)
	self.FlightMode.top.location.y:SetTemplate('Default', true, true)
	self.FlightMode.top.location.y:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.top.location.y:CreateWideShadow()
	self.FlightMode.top.location.y:SetPoint("LEFT", self.FlightMode.top.location, "RIGHT", (E.PixelMode and 4 or 6), 0)
	self.FlightMode.top.location.y:SetWidth(60)
	self.FlightMode.top.location.y:SetHeight(40)

	self.FlightMode.top.location.y.text = self.FlightMode.top.location.y:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.y.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.y.text:SetPoint('CENTER')

	-- Bottom frame
	self.FlightMode.bottom = CreateFrame("Frame", nil, self.FlightMode)
	self.FlightMode.bottom:SetFrameLevel(0)
	self.FlightMode.bottom:SetTemplate('Transparent', true, true)
	self.FlightMode.bottom:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.bottom:CreateWideShadow()
	self.FlightMode.bottom:SetPoint("BOTTOM", self.FlightMode, "BOTTOM", 0, -E.Border)
	self.FlightMode.bottom:SetWidth(GetScreenWidth() + (E.Border*2))
	self.FlightMode.bottom:SetHeight(52)

	-- BenikUI logo
	self.FlightMode.bottom.logo = self.FlightMode:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.logo:SetSize(420, 105)
	self.FlightMode.bottom.logo:SetPoint("BOTTOM", self.FlightMode.bottom, "CENTER", 0, -20)
	self.FlightMode.bottom.logo:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')
	self.FlightMode.bottom.logo:Hide()

	-- WoW logo
	self.FlightMode.bottom.wowlogo = CreateFrame('Frame', nil, mod.FlightMode) -- need this to upper the logo layer
	self.FlightMode.bottom.wowlogo:SetPoint("BOTTOM", self.FlightMode.bottom, "CENTER", 0, -20)
	self.FlightMode.bottom.wowlogo:SetFrameStrata("MEDIUM")
	self.FlightMode.bottom.wowlogo:SetSize(300, 150)
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
	self.FlightMode.bottom.benikui:SetPoint("TOP", self.FlightMode.bottom.logo, "BOTTOM", 0, 12)
	self.FlightMode.bottom.benikui:SetTextColor(1, 1, 1)
	self.FlightMode.bottom.benikui:Hide()

	-- Message frame. Shows when request stop is pressed
	self.FlightMode.message = CreateFrame("Frame", nil, self.FlightMode)
	self.FlightMode.message:SetFrameLevel(0)
	self.FlightMode.message:SetTemplate("Transparent")
	self.FlightMode.message:CreateWideShadow()
	self.FlightMode.message:SetPoint("BOTTOM", self.FlightMode.bottom.logo, "TOP", 0, (E.PixelMode and 8 or 10))
	self.FlightMode.message:SetSize(10, 30)
	self.FlightMode.message:Hide()
	-- Create animation
	self.FlightMode.message.anim = CreateAnimationGroup(self.FlightMode.message)
	self.FlightMode.message.anim.sizing = self.FlightMode.message.anim:CreateAnimation("Width")

	self.FlightMode.message.text = self.FlightMode.message:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.message.text:FontTemplate(nil, 14)
	self.FlightMode.message.text:SetFormattedText("%s", TAXI_CANCEL_DESCRIPTION)
	self.FlightMode.message.text:SetPoint("CENTER")
	self.FlightMode.message.text:SetTextColor(1, 1, 0, .7)
	self.FlightMode.message.text:SetAlpha(0)

	-- Request Stop button
	self.FlightMode.bottom.requestStop = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.requestStop:SetSize(32, 32)
	self.FlightMode.bottom.requestStop:SetPoint("LEFT", self.FlightMode.bottom, "LEFT", 10, 0)
	self.FlightMode.bottom.requestStop:EnableMouse(true)

	self.FlightMode.bottom.requestStop.img = self.FlightMode.bottom.requestStop:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.requestStop.img:SetPoint("CENTER")
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
		self.FlightMode.message.anim.sizing:SetChange(self.FlightMode.message.text:GetStringWidth() + 24)
		self.FlightMode.message.anim:Play()
		C_TimerAfter(.5, function()
			UIFrameFadeIn(self.FlightMode.message.text, 1, 0, 1)
		end)
		C_TimerAfter(8, function()
			UIFrameFadeOut(self.FlightMode.message, 1, 1, 0)
		end)
	end)

	-- Toggle Location button
	self.FlightMode.bottom.info = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.info:SetSize(32, 32)
	self.FlightMode.bottom.info:SetPoint("LEFT", self.FlightMode.bottom.requestStop, "RIGHT", 10, 0)

	self.FlightMode.bottom.info.img = self.FlightMode.bottom.info:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.info.img:SetPoint("CENTER")
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
	self.FlightMode.bottom.map:SetSize(32, 32)
	self.FlightMode.bottom.map:SetPoint("LEFT", self.FlightMode.bottom.info, "RIGHT", 10, 0)

	self.FlightMode.bottom.map.img = self.FlightMode.bottom.map:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.map.img:SetPoint("CENTER")
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
	self.FlightMode.bottom.bags:SetSize(32, 32)
	self.FlightMode.bottom.bags:SetPoint("LEFT", self.FlightMode.bottom.map, "RIGHT", 10, 0)

	self.FlightMode.bottom.bags.img = self.FlightMode.bottom.bags:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.bags.img:SetPoint("CENTER")
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
		ToggleAllBags()
	end)

	-- Time flying
	self.FlightMode.bottom.timeFlying = CreateFrame('Frame', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.timeFlying:SetPoint("RIGHT", self.FlightMode.bottom, "RIGHT", -10, 0)
	self.FlightMode.bottom.timeFlying:SetTemplate("Default", true, true)
	self.FlightMode.bottom.timeFlying:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.bottom.timeFlying:SetSize(70,30)
	self.FlightMode.bottom.timeFlying.txt = self.FlightMode.bottom.timeFlying:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.bottom.timeFlying.txt:FontTemplate(nil, 14)
	self.FlightMode.bottom.timeFlying.txt:SetText("00:00")
	self.FlightMode.bottom.timeFlying.txt:SetPoint("CENTER", self.FlightMode.bottom.timeFlying, "CENTER")
	self.FlightMode.bottom.timeFlying.txt:SetTextColor(1, 1, 1)

	-- fps
	self.FlightMode.bottom.fps = CreateFrame('Frame', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.fps:SetPoint('RIGHT', self.FlightMode.bottom.timeFlying, 'LEFT', -10, 0)
	self.FlightMode.bottom.fps:SetTemplate("Default", true, true)
	self.FlightMode.bottom.fps:SetBackdropBorderColor(.3, .3, .3, 1)
	self.FlightMode.bottom.fps:SetSize(70,30)
	self.FlightMode.bottom.fps.txt = self.FlightMode.bottom.fps:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.bottom.fps.txt:FontTemplate(nil, 14)
	self.FlightMode.bottom.fps.txt:SetPoint('CENTER', self.FlightMode.bottom.fps, 'CENTER')
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
	ToggleWorldMap()
	ToggleWorldMap()
end

BUI:RegisterModule(mod:GetName())