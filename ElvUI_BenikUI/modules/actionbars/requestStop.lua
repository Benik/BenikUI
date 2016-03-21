local E, L, V, P, G = unpack(ElvUI);
local BAB = E:GetModule('BuiActionbars');

local _G = _G
local unpack = unpack
local GameTooltip = _G["GameTooltip"]
local CreateFrame = CreateFrame
local UnitOnTaxi = UnitOnTaxi
local TaxiRequestEarlyLanding = TaxiRequestEarlyLanding

-- GLOBALS: TAXI_CANCEL, TAXI_CANCEL_DESCRIPTION, selectioncolor, GameTooltip_Hide, CreateAnimationGroup, BuiTaxiButton

local function TaxiButton_OnEvent(self, event)
	if ( UnitOnTaxi("player") ) then
		_G["LeaveVehicleButton"]:Hide() -- Hide ElvUI minimap button
		E:UIFrameFadeIn(self, 1, 0, 1)
		self:Show()
		self.textHolder.Text:SetFormattedText("%s", TAXI_CANCEL)
		self:Width(self.textHolder.Text:GetStringWidth() + 48)
		self.textHolder.Text:SetTextColor(1, 1, 1)
		self.IconBG:SetBackdropColor(unpack(E['media'].backdropcolor))
		self.IconBG.Icon:SetAlpha(0.5)
		self:EnableMouse(true)
		_G["BuiTaxiButton"]:SetWidth(self:GetWidth() + 42)
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
			self.textHolder.Text:SetTextColor(1, 0, 0)
			self.textHolder.Text:SetAlpha(0)
			
			self.anim.sizing:SetChange(self.textHolder.Text:GetStringWidth() + 56)
			self.anim:Play()
		end)
		
		E:Delay(1.2, function()
			E:UIFrameFadeIn(self.textHolder.Text, 1, 0, 1)
		end)

		self.IconBG.Icon:SetVertexColor(1, 0.1, 0.1)
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
end

local fly_icon = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow.tga'

-- TaxiButton
function BAB:TaxiButton()
	if not E.db.benikui.actionbars.requestStop then return end

	local tbtn = CreateFrame('Button', 'BuiTaxiButton', E.UIParent)
	tbtn:Size(240, 40)
	tbtn:SetPoint('TOP', E.UIParent, 'TOP', 0, -150)
	tbtn:SetTemplate("Transparent")
	tbtn:Style('Outside')
	tbtn:RegisterForClicks("AnyUp")
	
	tbtn.anim = CreateAnimationGroup(tbtn)
	tbtn.anim.sizing = tbtn.anim:CreateAnimation("Width")
	
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

	tbtn.textHolder.Text = tbtn.textHolder:CreateFontString(nil, 'LOW')
	tbtn.textHolder.Text:FontTemplate()
	tbtn.textHolder.Text:Point('CENTER')
	tbtn.textHolder.Text:SetJustifyH('CENTER')
	
	tbtn:SetScript("OnClick", TaxiButton_OnClick)
	tbtn:SetScript("OnEnter", TaxiButton_OnEnter)
	tbtn:SetScript("OnLeave", GameTooltip_Hide)
	tbtn:RegisterEvent("PLAYER_ENTERING_WORLD");
	tbtn:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	tbtn:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR");
	
	tbtn:SetScript("OnEvent", TaxiButton_OnEvent)

	E:CreateMover(BuiTaxiButton, 'RequestStopButton', L['Request Stop button'], nil, nil, nil, 'ALL,ACTIONBARS');
end

function BAB:LoadRequestButton()
	self:TaxiButton()
end