local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Actionbars');

local _G = _G
local GameTooltip = _G["GameTooltip"]
local CreateFrame = CreateFrame
local UnitOnTaxi = UnitOnTaxi
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_TimerAfter = C_Timer.After
local TaxiRequestEarlyLanding = TaxiRequestEarlyLanding
local TAXI_CANCEL, TAXI_CANCEL_DESCRIPTION = TAXI_CANCEL, TAXI_CANCEL_DESCRIPTION

-- GLOBALS: selectioncolor, GameTooltip_Hide, BuiTaxiButton, LeaveVehicleButton

local noFlightMapIDs = {
	-- Antoran Wastes (Legion)
	830, -- Krokuun
	831,
	882, -- Mac'Aree
	885, -- Antoran Wastes
	887, -- The Vindicaar
}

function BUI:CheckFlightMapID()
	for _, id in pairs (noFlightMapIDs) do
		local noFlightMapIDs = C_Map_GetBestMapForUnit("player")
		if id == noFlightMapIDs then return true end
	end
end

local function TaxiButton_OnEvent(self)
	local forbiddenArea = BUI:CheckFlightMapID()

	if (UnitOnTaxi("player") and not IsInInstance() and not forbiddenArea) then
		C_TimerAfter(0.05, function() _G.MainMenuBarVehicleLeaveButton:Hide() end)
		E:UIFrameFadeIn(self, 1, 0, 1)
		self:Show()
		self.textHolder.Text:SetFormattedText("%s", TAXI_CANCEL)
		self:Width(self.textHolder.Text:GetStringWidth() + 48)
		self.textHolder.Text:SetTextColor(1, 1, 1, .7)
		self.IconBG.Icon:SetVertexColor(1, 1, 1, .7)
		self:EnableMouse(true)
		--BuiTaxiButton:Width(self:GetWidth() + 42)
	else
		self:Hide()
	end
end

local function TaxiButton_OnClick(self, btn)
	if ( UnitOnTaxi("player") ) and btn == "LeftButton" then
		TaxiRequestEarlyLanding();

		E:UIFrameFadeOut(self.textHolder.Text, 1, 1, 0)

		E:Delay(1, function()
			self.textHolder.Text:SetFormattedText("%s", TAXI_CANCEL_DESCRIPTION)
			self.textHolder.Text:SetTextColor(1, 0.1, 0.1)
			self.textHolder.Text:SetAlpha(0)
			self.IconBG.Icon:SetVertexColor(1, 0.1, 0.1)
			self:Width(self.textHolder.Text:GetStringWidth() + 48)
		end)

		E:Delay(1.2, function()
			E:UIFrameFadeIn(self.textHolder.Text, 1, 0, 1)
		end)

		self:EnableMouse(false)
		
		E:Delay(8, function()
			E:UIFrameFadeOut(self, 1, 1, 0)
		end)
	else
		E:UIFrameFadeOut(self, 1, 1, 0)
		E:Delay(1, function()
			self:Hide()
		end)
	end
end

local function TaxiButton_OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 1, 0)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION, selectioncolor)
	GameTooltip:AddLine(L['LeftClick to Request Stop'], 0.7, 0.7, 1)
	GameTooltip:AddLine(L['RightClick to Hide'], 0.7, 0.7, 1)
	GameTooltip:Show()

	self.IconBG.Icon:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
	self.textHolder.Text:SetTextColor(BUI:unpackColor(E.db.general.valuecolor))
end

local function TaxiButton_OnLeave(self)
	GameTooltip:Hide()
	self.IconBG.Icon:SetVertexColor(1, 1, 1)
	self.textHolder.Text:SetTextColor(1, 1, 1, .7)
end

local fly_icon = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow.tga'

-- TaxiButton
function mod:TaxiButton()
	if not E.db.benikui.actionbars.requestStop then return end

	local tbtn = CreateFrame('Button', 'BuiTaxiButton', E.UIParent)
	tbtn:Size(240, 40)
	tbtn:Point('TOP', E.UIParent, 'TOP', 0, -150)
	tbtn:SetTemplate("Transparent")
	tbtn:BuiStyle('Outside')
	tbtn:RegisterForClicks("AnyUp")

	tbtn.IconBG = CreateFrame('Frame', nil, tbtn)
	tbtn.IconBG:Size(32, 32)
	tbtn.IconBG:Point('LEFT', tbtn, 'LEFT', 4, 0)

	tbtn.IconBG.Icon = tbtn.IconBG:CreateTexture(nil, 'OVERLAY')
	tbtn.IconBG.Icon:SetInside()
	tbtn.IconBG.Icon:SetTexture(fly_icon)
	tbtn.IconBG.Icon:SetVertexColor(1, 1, 1)

	tbtn.textHolder = CreateFrame('Frame', nil, tbtn)
	tbtn.textHolder:Point('TOPLEFT', tbtn.IconBG, 'TOPRIGHT', 4, 0)
	tbtn.textHolder:Point('BOTTOMRIGHT', tbtn, 'BOTTOMRIGHT', -4, 4)

	tbtn.textHolder.Text = tbtn.textHolder:CreateFontString(nil, 'OVERLAY')
	tbtn.textHolder.Text:FontTemplate()
	tbtn.textHolder.Text:Point('CENTER')
	tbtn.textHolder.Text:SetJustifyH('CENTER')

	tbtn:SetScript("OnClick", TaxiButton_OnClick)
	tbtn:SetScript("OnEnter", TaxiButton_OnEnter)
	tbtn:SetScript("OnLeave", TaxiButton_OnLeave)
	tbtn:RegisterEvent("PLAYER_ENTERING_WORLD");
	tbtn:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	tbtn:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR");

	tbtn:SetScript("OnEvent", TaxiButton_OnEvent)

	E:CreateMover(BuiTaxiButton, 'RequestStopButton', L['Request Stop button'], nil, nil, nil, 'ALL,ACTIONBARS,BENIKUI')
end

function mod:LoadRequestButton()
	self:TaxiButton()
end