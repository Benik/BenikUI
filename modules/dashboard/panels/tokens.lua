local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local BUI = E:GetModule('BenikUI');
local BUIT = E:NewModule('BuiTokensDashboard', 'AceEvent-3.0', 'AceHook-3.0')
local LSM = LibStub("LibSharedMedia-3.0")

local DASH_HEIGHT = 20
local DASH_WIDTH = E.db.utils.twidth or E.db.utils.dwidth or 150
local DASH_SPACING = 3
local SPACING = (E.PixelMode and 1 or 5)

local Tokens = {}
local currency = {
	{ 395, 4000 },	-- Justice Points
	{ 396, 3000 },	-- Valor Points
	{ 777, 0},		-- Timeless Coins
	{ 697, 20 },	-- Elder Charm of Good Fortune
	{ 738, 0 },		-- Lesser Charm of Good Fortune
	--{ 390, 10200 },	-- Conquest Points
	--{ 392, 4000 },	-- Honor Points
	--{ 515, 0 },		-- Darkmoon Prize Ticket
	{ 402, 0 },		-- Ironpaw Token
	{ 776, 10 },	-- Warforged Seal

	--[[{ 241, 250 },
	{ 390, 2200 },
	{ 61, 250 },
	{ 515, 250 },
	{ 398, 200 },
	{ 384, 200 },
	{ 697, 10 },
	{ 81, 250 },
	{ 615, 250 },
	{ 393, 250 },
	{ 392, 4000 },
	{ 361, 250 },
	{ 402, 250 },
	{ 395, 4000 },
	{ 738, 1000000 },
	{ 416, 250 },
	{ 677, 200 },
	{ 614, 250 },
	{ 400, 200 },
	{ 394, 200 },
	{ 397, 200 },
	{ 676, 200 },
	{ 391, 2000 },
	{ 401, 200 },
	{ 385, 200 },
	{ 396, 3000 },
	{ 399, 200 },
	{ 698, 250 }]]
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
	
	tholder:SetScript("OnEvent",function(self, event)
		if event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			self.fadeInfo.finishedFunc = tholderOnFade
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			self:Show()
		end	
	end)

	local num = 0
	for i, v in ipairs( currency ) do
		local id, max = unpack( v )
		local name, amount = GetCurrencyInfo( id )

		if( name and amount > 0 ) then
			num = num + 1
			tholder:Height(((DASH_HEIGHT + SPACING) * num) + SPACING)
			tholder.backdrop:Show()
		end
	end
	self:UpdateTHolderDimensions()
	tokenHolder:RegisterEvent("PLAYER_REGEN_DISABLED")
	tokenHolder:RegisterEvent("PLAYER_REGEN_ENABLED")
	E.FrameLocks['tokenHolder'] = true;
	E:CreateMover(tokenHolder, "tokenHolderMover", L["tokenHolder"])
end

function BUIT:UpdateTokens()
	if( Tokens[1] ) then
		for i = 1, getn( Tokens ) do
			Tokens[i]:Kill()
		end
		wipe( Tokens )
	end

	for i, v in ipairs(currency) do
		local id, max = unpack(v)
		local name, amount, icon = GetCurrencyInfo(id)

		if(name and amount > 0) then
			local TokensFrame = CreateFrame("Frame", "Tokens" .. id, tokenHolder)
			TokensFrame:Height(DASH_HEIGHT)
			TokensFrame:Width(DASH_WIDTH)
			TokensFrame:Point("TOPLEFT", tokenHolder, "TOPLEFT", SPACING, -SPACING)
			TokensFrame:EnableMouse(true)

			TokensFrame.dummy = CreateFrame("Frame", "TokensDummy" .. id, TokensFrame)
			TokensFrame.dummy:Point("BOTTOMLEFT", TokensFrame, "BOTTOMLEFT", 2, 2)
			TokensFrame.dummy:Point("BOTTOMRIGHT", TokensFrame, "BOTTOMRIGHT", -24, 0)
			TokensFrame.dummy:Height(3)

			TokensFrame.dummy.dummyStatus = TokensFrame.dummy:CreateTexture(nil, 'OVERLAY')
			TokensFrame.dummy.dummyStatus:SetInside()
			TokensFrame.dummy.dummyStatus:SetTexture(E["media"].BuiFlat)
			TokensFrame.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

			TokensFrame.Status = CreateFrame("StatusBar", "TokensStatus" .. id, TokensFrame.dummy)
			TokensFrame.Status:SetStatusBarTexture(E["media"].BuiFlat)
			if max == 0 then
				TokensFrame.Status:SetMinMaxValues(0, amount)
			else
				TokensFrame.Status:SetMinMaxValues(0, max)
			end
			TokensFrame.Status:SetValue(amount)
			TokensFrame.Status:SetStatusBarColor(1, 180 / 255, 0, 1)
			TokensFrame.Status:SetInside()
			
			TokensFrame.spark = TokensFrame.Status:CreateTexture(nil, "OVERLAY", nil);
			TokensFrame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
			TokensFrame.spark:SetSize(12, 6);
			TokensFrame.spark:SetBlendMode("ADD");
			TokensFrame.spark:SetPoint('CENTER', TokensFrame.Status:GetStatusBarTexture(), 'RIGHT')

			TokensFrame.Text = TokensFrame.Status:CreateFontString(nil, "OVERLAY")
			TokensFrame.Text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
			TokensFrame.Text:Point("CENTER", TokensFrame, "CENTER", -10, 1)
			TokensFrame.Text:Width(TokensFrame:GetWidth() - 20)
			TokensFrame.Text:SetWordWrap(false)
			TokensFrame.Text:SetShadowColor(0, 0, 0)
			TokensFrame.Text:SetShadowOffset(1.25, -1.25)
			if max == 0 then
				TokensFrame.Text:SetText(format("%s", amount))
			else
				TokensFrame.Text:SetText(format("%s / %s", amount, max))
			end

			TokensFrame.IconBG = CreateFrame("Frame", "TokensIconBG" .. id, TokensFrame)
			TokensFrame.IconBG:SetTemplate('Transparent')
			TokensFrame.IconBG:Size(18)
			TokensFrame.IconBG:Point("BOTTOMRIGHT", TokensFrame, "BOTTOMRIGHT", -SPACING*2, SPACING)

			TokensFrame.Icon = TokensFrame.IconBG:CreateTexture(nil, "ARTWORK")
			TokensFrame.Icon:Point("TOPLEFT", TokensFrame.IconBG, "TOPLEFT", SPACING, -SPACING)
			TokensFrame.Icon:Point("BOTTOMRIGHT", TokensFrame.IconBG, "BOTTOMRIGHT", -SPACING, SPACING)
			TokensFrame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			TokensFrame.Icon:SetTexture(icon)

			TokensFrame:SetScript("OnEnter", function(self)
				TokensFrame.Text:SetText(format("%s", name))
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 3, 0);
				GameTooltip:SetCurrencyByID(id)
			end)
				
			TokensFrame:SetScript("OnLeave", function(self)
				if max == 0 then
					TokensFrame.Text:SetText(format("%s", amount))
				else
					TokensFrame.Text:SetText(format("%s / %s", amount, max))
				end				
				GameTooltip:Hide()
			end)

			tinsert(Tokens, TokensFrame)
		end
	end

	for key, frame in ipairs(Tokens) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point( "TOPLEFT", tokenHolder, "TOPLEFT", 0, -SPACING)
		else
			frame:Point("TOP", Tokens[key - 1], "BOTTOM", 0, -SPACING)
		end
	end
end

function BUIT:TokenEvents()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", 'UpdateTokens')
	self:RegisterEvent("PLAYER_HONOR_GAIN", 'UpdateTokens')
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", 'UpdateTokens')
	self:SecureHook("BackpackTokenFrame_Update", 'UpdateTokens')
	self:SecureHook("TokenFrame_Update", 'UpdateTokens')
end


function BUIT:UpdateTHolderDimensions()
	if E.db.utils.sameWidth then
		tokenHolder:Width(E.db.utils.dwidth)
	else
		tokenHolder:Width(E.db.utils.twidth)
	end
	for key, frame in ipairs(Tokens) do
		if E.db.utils.sameWidth then
			frame:Width(E.db.utils.dwidth)
		else
			frame:Width(E.db.utils.twidth)
		end
	end
end

function BUIT:TokenDefaults()
	if E.db.utils.twidth == nil then E.db.utils.twidth = 150 end
end

function BUIT:Initialize()
	self:TokenDefaults()
	self:CreateTokensHolder()
	self:TokenEvents()
	self:UpdateTHolderDimensions()
end

E:RegisterModule(BUIT:GetName())