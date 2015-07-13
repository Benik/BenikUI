local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AB = E:GetModule('ActionBars');
local BAB = E:NewModule('BuiActionbars');
local BUI = E:GetModule('BenikUI');

if E.private.actionbar.enable ~= true then return; end

local SPACING = (E.PixelMode and 1 or 5)

local classColor = RAID_CLASS_COLORS[E.myclass]

local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

if E.db.bab == nil then E.db.bab = {} end

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar, ElvUI_TotemBar}

function BAB:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, 10 do
		local styleBacks = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(styleBacks) do
			if frame.backdrop then
				frame.backdrop:Style('Outside', frame:GetName()..'_Bui')
			end
		end
	end
	
	-- Other bar backdrops
	for _, frame in pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:Style('Outside', frame:GetName()..'_Bui')
		end
	end
end

function BAB:ColorBackdrops()
	if E.db.bui.buiStyle ~= true then return end
	for i = 1, 10 do
		local styleBacks = {_G['ElvUI_Bar'..i..'_Bui']}
		for _, frame in pairs(styleBacks) do
			frame.backdropTexture:SetTexture(E['media'].BuiFlat)
			if E.db.bui.abStyleColor == 1 then
				frame.backdropTexture:SetVertexColor(classColor.r, classColor.g, classColor.b)
			elseif E.db.bui.abStyleColor == 2 then
				frame.backdropTexture:SetVertexColor(unpackColor(E.db.bui.customAbStyleColor))
			elseif E.db.bui.abStyleColor == 3 then
				frame.backdropTexture:SetVertexColor(unpackColor(E.db.general.valuecolor))
			else
				frame.backdropTexture:SetVertexColor(unpackColor(E.db.general.backdropcolor))
			end
		end
	end
	
	for _, frame in pairs(styleOtherBacks) do
		local name = _G[frame:GetName()..'_Bui']
		name.backdropTexture:SetTexture(E['media'].BuiFlat)
		if E.db.bui.abStyleColor == 1 then
			name.backdropTexture:SetVertexColor(classColor.r, classColor.g, classColor.b)
		elseif E.db.bui.abStyleColor == 2 then
			name.backdropTexture:SetVertexColor(unpackColor(E.db.bui.customAbStyleColor))
		elseif E.db.bui.abStyleColor == 3 then
			name.backdropTexture:SetVertexColor(unpackColor(E.db.general.valuecolor))
		else
			name.backdropTexture:SetVertexColor(unpackColor(E.db.general.backdropcolor))
		end
	end
end

-- from ElvUI_TrasparentBackdrops plugin
function BAB:TransparentBackdrops()
	-- Actionbar backdrops
	for i = 1, 10 do
		local transBars = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(transBars) do
			if frame.backdrop then
				if E.db.bab.transBack then
					frame.backdrop:SetTemplate('Transparent')
				else
					frame.backdrop:SetTemplate('Default')
				end
			end
		end	
		
		-- Buttons
		for k = 1, 12 do
			local buttonBars = {_G['ElvUI_Bar'..i..'Button'..k]}
			for _, button in pairs(buttonBars) do
				if button.backdrop then
					if E.db.bab.transBack then
						button.backdrop:SetTemplate('Transparent')
					else
						button.backdrop:SetTemplate('Default', true)
					end
				end
			end
		end	
	end

	-- Other bar backdrops
	local transOtherBars = {ElvUI_BarPet, ElvUI_StanceBar, ElvUI_TotemBar, ElvUIBags}
	for _, frame in pairs(transOtherBars) do
		if frame.backdrop then
			if E.db.bab.transBack then
				frame.backdrop:SetTemplate('Transparent')
			else
				frame.backdrop:SetTemplate('Default')
			end
		end
	end
	
	-- Pet Buttons
	for i=1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in pairs(petButtons) do
			if button.backdrop then
				if E.db.bab.transBack then
					button.backdrop:SetTemplate('Transparent')
				else
					button.backdrop:SetTemplate('Default', true)
				end
			end
		end
	end
end

local function ab3_OnClick(self)
	if E.db.actionbar.bar3.enabled == true then
		E.db.actionbar.bar3.enabled = false
	elseif E.db.actionbar.bar3.enabled == false then
		E.db.actionbar.bar3.enabled = true
	end
	AB:UpdateButtonSettings('bar3');
end

local function ab5_OnClick(self)
	if E.db.actionbar.bar5.enabled == true then
		E.db.actionbar.bar5.enabled = false
	elseif E.db.actionbar.bar5.enabled == false then
		E.db.actionbar.bar5.enabled = true
	end
	AB:UpdateButtonSettings('bar5');
end

-- Switch ABs buttons
local abtn = {}
function BAB:CreateButtons()
	for i = 1, 2 do
		abtn[i] = CreateFrame('Button', 'BuiABbutton_'..i, E.UIParent)
		abtn[i]:Size(10, 5)
		abtn[i].color = abtn[i]:CreateTexture(nil, 'OVERLAY')
		abtn[i].color:SetInside()
		abtn[i].color:SetTexture(E['media'].BuiFlat)
		abtn[i].color:SetVertexColor(1, 0.5, 0.1, 1)
		abtn[i]:SetAlpha(0)

		abtn[i]:SetScript('OnEnter', function(self)
			abtn[i]:SetAlpha(1)
			GameTooltip:SetOwner(self, 'ANCHOR_CURSOR')
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L['Toggle Bar'], selectioncolor)
			GameTooltip:Show()
			if InCombatLockdown() then GameTooltip:Hide() end
			if i == 1 then
				abtn[i]:SetScript('OnClick', ab3_OnClick)
			else
				abtn[i]:SetScript('OnClick', ab5_OnClick)
			end
		end)

		abtn[i]:SetScript('OnLeave', function(self)
			abtn[i]:SetAlpha(0)
			GameTooltip:Hide()
		end)
	end
	self:ShowButtons()
end

function BAB:ShowButtons()
	local bar1 = ElvUI_Bar1_Bui
	local bar2 = ElvUI_Bar2_Bui
	
	for i = 1, 2 do
		abtn[i]:ClearAllPoints()
		if E.db.bab.chooseAb == 'BAR2' then
			abtn[i]:SetParent(bar2)
			if i == 1 then
				abtn[i]:Point('RIGHT', bar2, 'RIGHT')
			else
				abtn[i]:Point('LEFT', bar2, 'LEFT')
			end
		else
			abtn[i]:SetParent(bar1)
			if i == 1 then
				abtn[i]:Point('RIGHT', bar1, 'RIGHT')
			else
				abtn[i]:Point('LEFT', bar1, 'LEFT')
			end
		end
		
		if E.db.bab.enable then
			abtn[i]:Show()
		else
			abtn[i]:Hide()
		end
	end
end

local function TaxiButton_OnEvent(self, event)
	if ( UnitOnTaxi("player") ) then
		LeaveVehicleButton:Hide() -- Hide ElvUI minimap button
		self:Run('Alpha', 1, 0, 1)
		self:Show()
		self.Text:SetText(TAXI_CANCEL)
		self:Width(self.Text:GetStringWidth() + 48)
		self.Text:SetTextColor(1, 1, 1)
		self.IconBG:SetBackdropColor(unpackColor(E.db.general.backdropcolor))
		self.IconBG.Icon:SetAlpha(0.5)
		self:EnableMouse(true)
	else
		self:Hide()
	end
end

local function TaxiButton_OnClick(self, btn)
	if ( UnitOnTaxi("player") ) and btn == "LeftButton" then
		TaxiRequestEarlyLanding();
		
		self.Text:Run('Alpha', 1, 1, 0)
		
		E:Delay(1, function()
			self.Text:SetText(TAXI_CANCEL_DESCRIPTION)
			self.Text:SetTextColor(1, 0, 0)
			self.Text:SetAlpha(0)			
			self:Run("Width", 0.5, (self.Text:GetStringWidth() + 48))
		end)
		
		E:Delay(1.2, function()
			self.Text:Run('Alpha', 1, 0, 1)
		end)

		self.IconBG:Run("Gradient", "backdrop", 1, .7, 0, 0)
		self:EnableMouse(false)

		E:Delay(8, function()
			self:Run('Alpha', 1, 1, 0)
		end)
	else
		self:Run('Alpha', 1, 1, 0)
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
	local tbtn = CreateFrame('Button', 'BuiTaxiButton', E.UIParent)
	tbtn:Height(40)
	tbtn:Point('CENTER', E.UIParent, 'CENTER', 0, 150)
	tbtn:SetTemplate("Transparent")
	tbtn:Style('Outside')
	tbtn:RegisterForClicks("AnyUp")
	
	tbtn.Text = tbtn:CreateFontString(nil, 'LOW')
	tbtn.Text:FontTemplate()
	tbtn.Text:SetPoint('CENTER')
	tbtn.Text:SetJustifyH('CENTER')
	
	tbtn.IconBG = CreateFrame('Frame', 'BuiTaxiButtonIcon', tbtn)
	tbtn.IconBG:Size(40, 40)
	tbtn.IconBG:Point('RIGHT', tbtn, 'LEFT', E.PixelMode and -1 or -2, 0)
	tbtn.IconBG:SetTemplate("Transparent")
	tbtn.IconBG:Style('Outside')
	
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
end

 -- Support for ElvUI_ExtraActionBars
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent",function(self, event)
	if event then
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		BAB:ColorBackdrops()
		if IsAddOnLoaded("ElvUI_ExtraActionBars") then
			-- must call them again (till I find a more elegant way)
			BAB:StyleBackdrops()
			BAB:TransparentBackdrops()
			BAB:ColorBackdrops()
		end
	end
end)

function BAB:Initialize()
	self:StyleBackdrops()
	self:TransparentBackdrops()
	self:CreateButtons()
	self:TaxiButton()
	if IsAddOnLoaded('ElvUI_TB') then DisableAddOn('ElvUI_TB') end
end

E:RegisterModule(BAB:GetName())