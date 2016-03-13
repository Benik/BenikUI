local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BFM = E:NewModule('BUIFlightMode', 'AceTimer-3.0', 'AceEvent-3.0');

local CreateFrame = CreateFrame
local UnitOnTaxi = UnitOnTaxi
local TaxiRequestEarlyLanding = TaxiRequestEarlyLanding

local menuFrame = CreateFrame('Frame', 'BuiGameClickMenu', E.UIParent)
menuFrame:SetTemplate('Transparent', true)
menuFrame:CreateWideShadow()

local SPACING = (E.PixelMode and 1 or 3)
local LOCATION_WIDTH = 400
local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local CAMERA_SPEED = 0.035

local printKeys = {
	["PRINTSCREEN"] = true,
}

if IsMacClient() then
	printKeys[_G["KEY_PRINTSCREEN_MAC"]] = true
end

local menuList = {
	{text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON, func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
	{text = TALENTS_BUTTON,
	func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not GlyphFrame then
			GlyphFrame_LoadUI()
		end

		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = LFG_TITLE, func = function() ToggleLFDParentFrame(); end},
	{text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end},
	{text = REPUTATION, func = function() ToggleCharacter('ReputationFrame') end},
	{text = GARRISON_LANDING_PAGE_TITLE, func = function() GarrisonLandingPageMinimapButton_OnClick() end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
		if IsInGuild() then
			if not GuildFrame then GuildFrame_LoadUI() end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
			if not LookingForGuildFrame then return end
			LookingForGuildFrame_Toggle()
		end
	end},
	{text = L["Calendar"], func = function() GameTimeFrame:Click() end},
	{text = MOUNTS, func = function() ToggleCollectionsJournal(1) end},
	{text = PET_JOURNAL, func = function() ToggleCollectionsJournal(2) end},
	{text = TOY_BOX, func = function() ToggleCollectionsJournal(3) end},
	{text = HEIRLOOMS, func = function() ToggleCollectionsJournal(4) end},
	{text = MACROS, func = function() GameMenuButtonMacros:Click() end},
	{text = ENCOUNTER_JOURNAL, func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},
	{text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame() end},
	{text = MAINMENU_BUTTON,
	func = function()
		if ( not GameMenuFrame:IsShown() ) then
			if ( VideoOptionsFrame:IsShown() ) then
					VideoOptionsFrameCancel:Click();
			elseif ( AudioOptionsFrame:IsShown() ) then
					AudioOptionsFrameCancel:Click();
			elseif ( InterfaceOptionsFrame:IsShown() ) then
					InterfaceOptionsFrameCancel:Click();
			end
			CloseMenus();
			CloseAllWindows()
			PlaySound("igMainMenuOpen");
			ShowUIPanel(GameMenuFrame);
		else
			PlaySound("igMainMenuQuit");
			HideUIPanel(GameMenuFrame);
			MainMenuMicroButton_SetNormal();
		end
	end},
	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end},
	{text = BLIZZARD_STORE, func = function() StoreMicroButton:Click() end},
}

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

local function OnKeyDown(self, key)
	--if(ignoreKeys[key]) then return end
	--if printKeys[key] then
		--Screenshot()
	--else
	if key == "ESCAPE" then
		BFM:SetFlightMode(false)
	elseif printKeys[key] then
		Screenshot()
	end
end

function BFM:CreateCoords()
	local x, y = GetPlayerMapPosition("player")
	
	x = tonumber(E:Round(100 * x))
	y = tonumber(E:Round(100 * y))
	
	return x, y
end

function BFM:UpdateLocation()
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

function BFM:UpdateCoords()
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
		self.FlightMode.top.location.x.text:SetText(x)
		self.FlightMode.top.location.y.text:SetText(y)
	end
end

function BFM:UpdateTimer()
	local time = GetTime() - self.startTime
	self.FlightMode.bottom.timeFlying:SetFormattedText("%02d:%02d", floor(time/60), time % 60)
end

function BFM:SetFlightMode(status)
	if(status) then
		MoveViewLeftStart(CAMERA_SPEED);
		self.FlightMode:Show()
		CloseAllBags()
		if(E.db.benikui.misc.flightMode.frames) then
			UIParent:Hide()
			self.FlightMode.bottom.map:EnableMouse(false)
			self.FlightMode.bottom.menuButton:EnableMouse(false)
		else
			E.UIParent:Hide()
			-- Hide some frames
			if ObjectiveTrackerFrame then ObjectiveTrackerFrame:Hide() end
			if E.private.general.minimap.enable then
				Minimap:Hide()
			end
			self.FlightMode.bottom.map:EnableMouse(true)
			self.FlightMode.bottom.menuButton:EnableMouse(true)
		end
		ZoneTextFrame:UnregisterAllEvents()
		self.startTime = GetTime()
		self.timer = self:ScheduleRepeatingTimer('UpdateTimer', 1)
		self.locationTimer = self:ScheduleRepeatingTimer('UpdateLocation', 0.2)
		self.coordsTimer = self:ScheduleRepeatingTimer('UpdateCoords', 0.2)
		
		self.inFlightMode = true
	elseif(self.inFlightMode) then
		if(E.db.benikui.misc.flightMode.frames) then
			UIParent:Show()
		else
			E.UIParent:Show()
			-- Show hidden frames
			if ObjectiveTrackerFrame then ObjectiveTrackerFrame:Show() end
			if E.private.general.minimap.enable then
				Minimap:Show()
			end
		end
		self.FlightMode:Hide()
		MoveViewLeftStop();
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED")
		self:CancelTimer(self.locationTimer)
		self:CancelTimer(self.coordsTimer)
		self:CancelTimer(self.timer)
		self.FlightMode.bottom.timeFlying:SetText("00:00")

		self.FlightMode.bottom.requestStop:EnableMouse(true)
		self.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)
		self.FlightMode.message:Hide()
		self.FlightMode.message:SetAlpha(1)
		self.FlightMode.message:Width(10)
		self.FlightMode.message.text:SetAlpha(0)

		self.inFlightMode = false
	end
end

function BFM:OnEvent(...)
	if (UnitOnTaxi("player")) then
		self:SetFlightMode(true)
	else
		self:SetFlightMode(false)
	end
end

function BFM:Toggle()
	if(E.db.benikui.misc.flightMode.enable) then
		self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "OnEvent")
		self:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR", "OnEvent")
	else
		self:UnregisterEvent("UPDATE_BONUS_ACTIONBAR")
		self:UnregisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
	end
end

function BFM:Initialize()
	local db = E.db.benikui.colors
	self.FlightMode = CreateFrame("Frame", "BenikUIFlightModeFrame")
	self.FlightMode:SetFrameLevel(1)
	self.FlightMode:SetScale(UIParent:GetScale())
	self.FlightMode:SetAllPoints(UIParent)
	self.FlightMode:Hide()
	self.FlightMode:EnableKeyboard(true)
	self.FlightMode:SetScript("OnKeyDown", OnKeyDown)

	-- Top frame
	self.FlightMode.top = CreateFrame('Frame', nil, self.FlightMode)
	self.FlightMode.top:SetFrameLevel(0)
	self.FlightMode.top:SetPoint("TOP", self.FlightMode, "TOP", 0, E.Border)
	self.FlightMode.top:SetTemplate('Transparent')
	self.FlightMode.top:CreateWideShadow()
	self.FlightMode.top:Width(GetScreenWidth() + (E.Border*2))
	self.FlightMode.top:Height(20)

	-- Location frame
	self.FlightMode.top.location = CreateFrame('Frame', 'FlightModeLocation', self.FlightMode.top)
	self.FlightMode.top.location:SetFrameLevel(1)
	self.FlightMode.top.location:SetTemplate('Transparent')
	self.FlightMode.top.location:CreateWideShadow()
	self.FlightMode.top.location:Point("TOP", self.FlightMode.top, "BOTTOM", 0, (E.PixelMode and -8 or -10))
	self.FlightMode.top.location:Width(LOCATION_WIDTH)
	self.FlightMode.top.location:Height(50)
	
	self.FlightMode.top.location.text = self.FlightMode.top.location:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.text:Point('CENTER')
	self.FlightMode.top.location.text:SetWordWrap(false)
	
	-- Coords X frame
	self.FlightMode.top.location.x = CreateFrame('Frame', nil, self.FlightMode.top.location)
	self.FlightMode.top.location.x:SetTemplate('Transparent')
	self.FlightMode.top.location.x:CreateWideShadow()
	self.FlightMode.top.location.x:Point("RIGHT", self.FlightMode.top.location, "LEFT", (E.PixelMode and -8 or -10), 0)
	self.FlightMode.top.location.x:Width(60)
	self.FlightMode.top.location.x:Height(40)

	self.FlightMode.top.location.x.text = self.FlightMode.top.location.x:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.x.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.x.text:Point('CENTER')	
	
	-- Coords Y frame
	self.FlightMode.top.location.y = CreateFrame('Frame', nil, self.FlightMode.top.location)
	self.FlightMode.top.location.y:SetTemplate('Transparent')
	self.FlightMode.top.location.y:CreateWideShadow()
	self.FlightMode.top.location.y:Point("LEFT", self.FlightMode.top.location, "RIGHT", (E.PixelMode and 8 or 10), 0)
	self.FlightMode.top.location.y:Width(60)
	self.FlightMode.top.location.y:Height(40)
	
	self.FlightMode.top.location.y.text = self.FlightMode.top.location.y:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.top.location.y.text:FontTemplate(nil, 18)
	self.FlightMode.top.location.y.text:Point('CENTER')	

	-- Bottom frame
	self.FlightMode.bottom = CreateFrame("Frame", nil, self.FlightMode)
	self.FlightMode.bottom:SetFrameLevel(0)
	self.FlightMode.bottom:SetTemplate("Transparent")
	self.FlightMode.bottom:CreateWideShadow()
	self.FlightMode.bottom:Point("BOTTOM", self.FlightMode, "BOTTOM", 0, -E.Border)
	self.FlightMode.bottom:Width(GetScreenWidth() + (E.Border*2))
	self.FlightMode.bottom:Height(52)

	-- BenikUI logo
	self.FlightMode.bottom.logo = self.FlightMode:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.logo:Size(256, 128)
	self.FlightMode.bottom.logo:Point("CENTER", self.FlightMode.bottom, "CENTER", 0, 40)
	self.FlightMode.bottom.logo:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')

	-- BenikUI version
	self.FlightMode.bottom.benikui = self.FlightMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.bottom.benikui:FontTemplate(nil, 10)
	self.FlightMode.bottom.benikui:SetFormattedText("v%s", BUI.Version)
	self.FlightMode.bottom.benikui:SetPoint("TOP", self.FlightMode.bottom.logo, "BOTTOM", 0, 24)
	self.FlightMode.bottom.benikui:SetTextColor(1, 1, 1)	

	-- Message frame. Shows when request stop is pressed
	self.FlightMode.message = CreateFrame("Frame", nil, self.FlightMode)
	self.FlightMode.message:SetFrameLevel(0)
	self.FlightMode.message:SetTemplate("Transparent")
	self.FlightMode.message:CreateWideShadow()
	self.FlightMode.message:Point("BOTTOM", self.FlightMode.bottom.logo, "TOP", 0, (E.PixelMode and 8 or 10))
	self.FlightMode.message:Size(10, 30)
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
	
	-- Menu button
	self.FlightMode.bottom.menuButton = CreateFrame('Button', 'FlightModeMenuBtn', self.FlightMode.bottom)
	self.FlightMode.bottom.menuButton:Size(32, 32)
	self.FlightMode.bottom.menuButton:Point("LEFT", self.FlightMode.bottom, "LEFT", 6, 0)

	self.FlightMode.bottom.menuButton.img = self.FlightMode.bottom.menuButton:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.menuButton.img:Point("CENTER")
	self.FlightMode.bottom.menuButton.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\menu.tga')
	self.FlightMode.bottom.menuButton.img:SetVertexColor(1, 1, 1, .7)
	
	self.FlightMode.bottom.menuButton:SetScript('OnEnter', function()
		GameTooltip:SetOwner(self.FlightMode.bottom.menuButton, 'ANCHOR_RIGHT', 1, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['Show an enhanced game menu'], selectioncolor)
		GameTooltip:AddLine(L['Press Esc to exit Flight Mode'], 0.7, 0.7, 1)
		GameTooltip:Show()
		if db.gameMenuColor == 1 then
			self.FlightMode.bottom.menuButton.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif db.gameMenuColor == 2 then
			self.FlightMode.bottom.menuButton.img:SetVertexColor(BUI:unpackColor(E.db.benikui.colors.customGameMenuColor))
		else
			self.FlightMode.bottom.menuButton.img:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end)
	
	self.FlightMode.bottom.menuButton:SetScript('OnLeave', function()
		self.FlightMode.bottom.menuButton.img:SetVertexColor(1, 1, 1, .7)
		GameTooltip:Hide()
	end)
	
	self.FlightMode.bottom.menuButton:SetScript('OnClick', function()
		BUI:Dropmenu(menuList, menuFrame, FlightModeMenuBtn, 'tRight', (E.PixelMode and -38 or -36), (E.PixelMode and 13 or 15), 4, 36)
		PlaySound("igMainMenuOptionCheckBoxOff");
	end)
	
	-- Request Stop button
	self.FlightMode.bottom.requestStop = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.requestStop:Size(32, 32)
	self.FlightMode.bottom.requestStop:Point("LEFT", self.FlightMode.bottom.menuButton, "RIGHT", 10, 0)
	self.FlightMode.bottom.requestStop:EnableMouse(true)
	
	self.FlightMode.bottom.requestStop.img = self.FlightMode.bottom.requestStop:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.requestStop.img:Point("CENTER")
	self.FlightMode.bottom.requestStop.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\arrowDown.tga')
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
		PlaySound("igMainMenuOptionCheckBoxOff");
		TaxiRequestEarlyLanding();
		self.FlightMode.bottom.requestStop:EnableMouse(false)
		self.FlightMode.bottom.requestStop.img:SetVertexColor(1, 0, 0, .7)
		self.FlightMode.message:Show()
		self.FlightMode.message.anim.sizing:SetChange(self.FlightMode.message.text:GetStringWidth() + 24)
		self.FlightMode.message.anim:Play()
		C_Timer.After(.5, function()
			UIFrameFadeIn(self.FlightMode.message.text, 1, 0, 1)
		end)
		C_Timer.After(8, function()
			UIFrameFadeOut(self.FlightMode.message, 1, 1, 0)
		end)
	end)
	
	-- Toggle Location button
	self.FlightMode.bottom.info = CreateFrame('Button', nil, self.FlightMode.bottom)
	self.FlightMode.bottom.info:Size(32, 32)
	self.FlightMode.bottom.info:Point("LEFT", self.FlightMode.bottom.requestStop, "RIGHT", 10, 0)
	
	self.FlightMode.bottom.info.img = self.FlightMode.bottom.info:CreateTexture(nil, 'OVERLAY')
	self.FlightMode.bottom.info.img:Point("CENTER")
	self.FlightMode.bottom.info.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\info.tga')
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
		PlaySound("igMainMenuOptionCheckBoxOff");
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
	self.FlightMode.bottom.map.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\map.tga')
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
		PlaySound("igMainMenuOptionCheckBoxOff");
		ToggleFrame(WorldMapFrame)
	end)
	
	-- Time flying
	self.FlightMode.bottom.timeFlying = self.FlightMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.bottom.timeFlying:FontTemplate(nil, 16)
	self.FlightMode.bottom.timeFlying:SetText("00:00")
	self.FlightMode.bottom.timeFlying:Point("RIGHT", self.FlightMode.bottom, "RIGHT", -10, 0)
	self.FlightMode.bottom.timeFlying:SetTextColor(1, 1, 1)

	self:Toggle()
end

E:RegisterModule(BFM:GetName())