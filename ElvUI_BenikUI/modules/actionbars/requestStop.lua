local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local BAB = E:GetModule('BuiActionbars');

local function TaxiButton_OnEvent(self, event)
	if ( UnitOnTaxi("player") ) then
		LeaveVehicleButton:Hide() -- Hide ElvUI minimap button
		E:UIFrameFadeIn(self, 1, 0, 1)
		self:Show()
		self.Text:SetFormattedText("%s", TAXI_CANCEL)
		self:Width(self.Text:GetStringWidth() + 48)
		self.Text:SetTextColor(1, 1, 1)
		self.IconBG:SetBackdropColor(unpackColor(E.db.general.backdropcolor))
		self.IconBG.Icon:SetAlpha(0.5)
		self:EnableMouse(true)
		BuiTaxiButtonHolder:SetWidth(self:GetWidth() + 42)
	else
		self:Hide()
	end
end

local function TaxiButton_OnClick(self, btn)
	if ( UnitOnTaxi("player") ) and btn == "LeftButton" then
		TaxiRequestEarlyLanding();
		
		E:UIFrameFadeOut(self.Text, 1, 1, 0)
		
		E:Delay(1, function()
			self.Text:SetFormattedText("%s", TAXI_CANCEL_DESCRIPTION)
			self.Text:SetTextColor(1, 0, 0)
			self.Text:SetAlpha(0)			
			
			self.anim.sizing:SetChange(self.Text:GetStringWidth() + 24)
			self.anim:Play()
		end)
		
		E:Delay(1.2, function()
			E:UIFrameFadeIn(self.Text, 1, 0, 1)
		end)

		self.IconBG.anim.grad:SetChange(0.7, 0, 0)
		self.IconBG.anim:Play()
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

local fly_icon = "Interface\\ICONS\\ABILITY_MOUNT_GOLDENGRYPHON"

-- TaxiButton
function BAB:TaxiButton()
	if not E.db.bab.requestStop then return end
	
	local holder = CreateFrame('Frame', 'BuiTaxiButtonHolder', E.UIParent)
	holder:Point('TOP', E.UIParent, 'TOP', 0, -150)
	holder:Size(200, 40)
	
	local tbtn = CreateFrame('Button', 'BuiTaxiButton', holder)
	tbtn:Height(40)
	tbtn:SetPoint('CENTER', holder, 'CENTER')
	tbtn:SetTemplate("Transparent")
	tbtn:Style('Outside')
	tbtn:RegisterForClicks("AnyUp")
	
	tbtn.anim = CreateAnimationGroup(tbtn)
	tbtn.anim.sizing = tbtn.anim:CreateAnimation("Width")
	
	tbtn.Text = tbtn:CreateFontString(nil, 'LOW')
	tbtn.Text:FontTemplate()
	tbtn.Text:SetPoint('CENTER')
	tbtn.Text:SetJustifyH('CENTER')
	
	tbtn.IconBG = CreateFrame('Frame', 'BuiTaxiButtonIcon', tbtn)
	tbtn.IconBG:Size(40, 40)
	tbtn.IconBG:Point('RIGHT', tbtn, 'LEFT', E.PixelMode and -1 or -2, 0)
	tbtn.IconBG:SetTemplate("Transparent")
	tbtn.IconBG:Style('Outside')
	
	tbtn.IconBG.anim = CreateAnimationGroup(tbtn.IconBG)
	tbtn.IconBG.anim.grad = tbtn.IconBG.anim:CreateAnimation("Color")
	
	tbtn.IconBG.Icon = tbtn.IconBG:CreateTexture(nil, 'ARTWORK')
	tbtn.IconBG.Icon:SetInside()
	tbtn.IconBG.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	tbtn.IconBG.Icon:SetTexture(fly_icon)
	tbtn.IconBG.Icon:SetDesaturated(true)
	
	tbtn:SetScript("OnClick", TaxiButton_OnClick)
	tbtn:SetScript("OnEnter", TaxiButton_OnEnter)
	tbtn:SetScript("OnLeave", GameTooltip_Hide)
	tbtn:RegisterEvent("PLAYER_ENTERING_WORLD");
	tbtn:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	tbtn:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR");
	
	tbtn:SetScript("OnEvent", TaxiButton_OnEvent)

	E:CreateMover(holder, 'RequestStopButton', L['Request Stop button'], nil, nil, nil, 'ALL,ACTIONBARS');
end

function BAB:LoadRequestButton()
	self:TaxiButton()
end