local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local BUI = E:GetModule('BenikUI');
local BUIT = E:NewModule('BuiTokensDashboard', 'AceEvent-3.0', 'AceHook-3.0')
local LSM = LibStub('LibSharedMedia-3.0')

if E.db.utils == nil then E.db.utils = {} end

local DASH_HEIGHT = 20
local DASH_WIDTH = E.db.utils.twidth or 150
local DASH_SPACING = 3
local SPACING = (E.PixelMode and 1 or 5)

local Tokens = {}

local BUIcurrency = {
	241,	-- Champion's Seal
	361,	-- Illustrious Jewelcrafter's Token
	390,	-- Conquest Points
	391,	-- Tol Barad Commendation
	392,	-- Honor Points
	395,	-- Justice Points
	396,	-- Valor Points
	402,	-- Ironpaw Token
	416,	-- Mark of the World Tree
	515,	-- Darkmoon Prize Ticket
	61,		-- Dalaran Jewelcrafter's Token
	614,	-- Mote of Darkness
	615,	-- Essence of Corrupted Deathwing
	697,	-- Elder Charm of Good Fortune
	738,	-- Lesser Charm of Good Fortune
	752,	-- Mogu Rune of Fate
	776,	-- Warforged Seal
	777,	-- Timeless Coin
	789,	-- Bloody Coin
	81,		-- Epicurean's Award
	402,	-- Ironpaw Token
	384,	-- Dwarf Archaeology Fragment
	385,	-- Troll Archaeology Fragment
	393,	-- Fossil Archaeology Fragment
	394,	-- Night Elf Archaeology Fragment
	397,	-- Orc Archaeology Fragment
	398,	-- Draenei Archaeology Fragment
	399,	-- Vrykul Archaeology Fragment
	400,	-- Nerubian Archaeology Fragment
	401,	-- Tol'vir Archaeology Fragment	
	676,	-- Pandaren Archaeology Fragment
	677,	-- Mogu Archaeology Fragment
	754,	-- Mantid Archaeology Fragment
}

local function tholderOnFade()
	tokenHolder:Hide()
end

function BUIT:CreateTokensHolder()
	local tholder
	if not tholder then
		tholder = CreateFrame('Frame', 'tokenHolder', E.UIParent)
		tholder:CreateBackdrop('Transparent')
		tholder:Width(DASH_WIDTH)
		tholder:Point('TOPLEFT', BuiDashboard, 'BOTTOMLEFT', 0, -10)
		tholder.backdrop:Style('Outside')
		tholder.backdrop:Hide()
	end
	
	if E.db.utils.Tcombat then
		tholder:SetScript('OnEvent',function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self.fadeInfo.finishedFunc = tholderOnFade
			elseif event == 'PLAYER_REGEN_ENABLED' then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end	
		end)
	end

	self:UpdateTokens()
	self:UpdateTHolderDimensions()
	self:EnableDisableCombat()
	E.FrameLocks['tokenHolder'] = true;
	E:CreateMover(tokenHolder, 'tokenHolderMover', L['Tokens'])
end

function BUIT:EnableDisableCombat()
	if E.db.utils.Tcombat then
		tokenHolder:RegisterEvent('PLAYER_REGEN_DISABLED')
		tokenHolder:RegisterEvent('PLAYER_REGEN_ENABLED')	
	else
		tokenHolder:UnregisterEvent('PLAYER_REGEN_DISABLED')
		tokenHolder:UnregisterEvent('PLAYER_REGEN_ENABLED')	
	end
end

function BUIT:UpdateTokens()
	if( Tokens[1] ) then
		for i = 1, getn( Tokens ) do
			Tokens[i]:Kill()
		end
		wipe( Tokens )
		tokenHolder.backdrop:Hide()
	end

	for i, id in ipairs(BUIcurrency) do
		local name, amount, icon, _, _, totalMax, isDiscovered = GetCurrencyInfo(id)
		
		if name then
			-- max fix
			if id == 392 or id == 395 then
				totalMax = 4000
			elseif id == 396 then
				totalMax = 3000
			end
			
			if isDiscovered == false then E.db.utils[name] = false end
			
			if E.db.utils[name] == true then
				if E.db.utils.Tshow or amount > 0 then
					tokenHolder:Height(((DASH_HEIGHT + SPACING) * (#Tokens + 1)) + SPACING)
					tokenHolder.backdrop:Show()
					
					local TokensFrame = CreateFrame('Frame', 'Tokens' .. id, tokenHolder)
					TokensFrame:Height(DASH_HEIGHT)
					TokensFrame:Width(DASH_WIDTH)
					TokensFrame:Point('TOPLEFT', tokenHolder, 'TOPLEFT', SPACING, -SPACING)
					TokensFrame:EnableMouse(true)

					TokensFrame.dummy = CreateFrame('Frame', 'TokensDummy' .. id, TokensFrame)
					TokensFrame.dummy:Point('BOTTOMLEFT', TokensFrame, 'BOTTOMLEFT', 2, 2)
					TokensFrame.dummy:Point('BOTTOMRIGHT', TokensFrame, 'BOTTOMRIGHT', -24, 0)
					TokensFrame.dummy:Height(3)

					TokensFrame.dummy.dummyStatus = TokensFrame.dummy:CreateTexture(nil, 'OVERLAY')
					TokensFrame.dummy.dummyStatus:SetInside()
					TokensFrame.dummy.dummyStatus:SetTexture(E['media'].BuiFlat)
					TokensFrame.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

					TokensFrame.Status = CreateFrame('StatusBar', 'TokensStatus' .. id, TokensFrame.dummy)
					TokensFrame.Status:SetStatusBarTexture(E['media'].BuiFlat)
					if totalMax == 0 then
						TokensFrame.Status:SetMinMaxValues(0, amount)
					else
						TokensFrame.Status:SetMinMaxValues(0, totalMax)
					end
					TokensFrame.Status:SetValue(amount)
					TokensFrame.Status:SetStatusBarColor(1, 180 / 255, 0, 1)
					TokensFrame.Status:SetInside()
					
					TokensFrame.spark = TokensFrame.Status:CreateTexture(nil, 'OVERLAY', nil);
					TokensFrame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
					TokensFrame.spark:SetSize(12, 6);
					TokensFrame.spark:SetBlendMode('ADD');
					TokensFrame.spark:SetPoint('CENTER', TokensFrame.Status:GetStatusBarTexture(), 'RIGHT')

					TokensFrame.Text = TokensFrame.Status:CreateFontString(nil, 'OVERLAY')
					if E.db.utils.dtfont then
						TokensFrame.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
					else
						TokensFrame.Text:FontTemplate(LSM:Fetch('font', E.db.utils.dbfont), E.db.utils.dbfontsize, E.db.utils.dbfontflags)
					end
					TokensFrame.Text:Point('CENTER', TokensFrame, 'CENTER', -10, 1)
					TokensFrame.Text:Width(TokensFrame:GetWidth() - 20)
					TokensFrame.Text:SetWordWrap(false)

					if totalMax == 0 then
						TokensFrame.Text:SetText(format('%s', amount))
					else
						TokensFrame.Text:SetText(format('%s / %s', amount, totalMax))
					end

					TokensFrame.IconBG = CreateFrame('Frame', 'TokensIconBG' .. id, TokensFrame)
					TokensFrame.IconBG:SetTemplate('Transparent')
					TokensFrame.IconBG:Size(18)
					TokensFrame.IconBG:Point('BOTTOMRIGHT', TokensFrame, 'BOTTOMRIGHT', -SPACING*2, SPACING)

					TokensFrame.Icon = TokensFrame.IconBG:CreateTexture(nil, 'ARTWORK')
					TokensFrame.Icon:Point('TOPLEFT', TokensFrame.IconBG, 'TOPLEFT', SPACING, -SPACING)
					TokensFrame.Icon:Point('BOTTOMRIGHT', TokensFrame.IconBG, 'BOTTOMRIGHT', -SPACING, SPACING)
					TokensFrame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					TokensFrame.Icon:SetTexture(icon)

					TokensFrame:SetScript('OnEnter', function(self)
						TokensFrame.Text:SetText(format('%s', name))
						if E.db.utils.Ttooltip then
							GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 3, 0);
							GameTooltip:SetCurrencyByID(id)
						end
					end)
					
					-- Flash
					if E.db.utils.Tflash then
						E:Flash(TokensFrame, 0.2)
					end
			
					TokensFrame:SetScript('OnLeave', function(self)
						if totalMax == 0 then
							TokensFrame.Text:SetText(format('%s', amount))
						else
							TokensFrame.Text:SetText(format('%s / %s', amount, totalMax))
						end				
						GameTooltip:Hide()
					end)

					tinsert(Tokens, TokensFrame)
				end
			end
		end
	end

	for key, frame in ipairs(Tokens) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point( 'TOPLEFT', tokenHolder, 'TOPLEFT', 0, -SPACING)
		else
			frame:Point('TOP', Tokens[key - 1], 'BOTTOM', 0, -SPACING)
		end
	end
end

function BUIT:TokenEvents()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateTokens')
	self:RegisterEvent('PLAYER_HONOR_GAIN', 'UpdateTokens')
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'UpdateTokens')
	self:SecureHook('BackpackTokenFrame_Update', 'UpdateTokens')
	self:SecureHook('TokenFrame_Update', 'UpdateTokens')
end

function BUIT:UpdateTHolderDimensions()
	tokenHolder:Width(E.db.utils.twidth)

	for _, frame in pairs(Tokens) do
		frame:Width(E.db.utils.twidth)
	end
end

function BUIT:TokenDefaults()
	if E.db.utils.twidth == nil then E.db.utils.twidth = 150 end
end

function BUIT:Initialize()
	if E.db.utils.enableTokens ~= true then return end
	self:TokenDefaults()
	self:CreateTokensHolder()
	self:TokenEvents()
	self:UpdateTHolderDimensions()
end

E:RegisterModule(BUIT:GetName())