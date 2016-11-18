local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIT = E:NewModule('BuiTokensDashboard', 'AceEvent-3.0', 'AceHook-3.0')
local LSM = LibStub('LibSharedMedia-3.0')
local DT = E:GetModule('DataTexts')

if E.db.dashboards == nil then E.db.dashboards = {} end
if E.db.dashboards.tokens == nil then E.db.dashboards.tokens = {} end

local getn = getn
local pairs, ipairs = pairs, ipairs
local tinsert, twipe = table.insert, table.wipe

local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local GetCurrencyInfo = GetCurrencyInfo
local IsShiftKeyDown = IsShiftKeyDown

-- GLOBALS: hooksecurefunc, tokenFrames, tokenHolder, tokenHolderMover, sysHolder

local DASH_HEIGHT = 20
local DASH_WIDTH = E.db.dashboards.tokens.width or 150
local DASH_SPACING = 3
local SPACING = 1

local tokenFrames = {}

local BUIcurrency = {
	241,	-- Champion's Seal
	361,	-- Illustrious Jewelcrafter's Token
	--390,	-- Conquest Points
	391,	-- Tol Barad Commendation
	--392,	-- Honor Points
	395,	-- Justice Points
	--396,	-- Valor Points (old)
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
	1172,	-- Highborne Archaeology Fragment
	1173,	-- Highmountain Tauren Archaeology Fragment
	1174,	-- Demonic Archaeology Fragment
	
	-- WoD
	821,	-- Draenor Clans Archaeology Fragment
	828,	-- Ogre Archaeology Fragment
	829,	-- Arakkoa Archaeology Fragment
	824,	-- Garrison Resources
	823,	-- Apexis Crystal (for gear, like the valors)
	994,	-- Seal of Tempered Fate (Raid loot roll)
	980,	-- Dingy Iron Coins (rogue only, from pickpocketing)
	944,	-- Artifact Fragment (PvP)
	1101,	-- Oil
	1129,	-- Seal of Inevitable Fate
	1166, 	-- Timewarped Badge (6.22)
	1191, 	-- Valor Points (6.23)
	
	-- Legion
	1155,	-- Ancient Mana
	1220,	-- Order Resources
	1275,	-- Curious Coin (Buy stuff :P)
	1226,	-- Nethershard (Invasion scenarios)
	1273,	-- Seal of Broken Fate (Raid)
	1154,	-- Shadowy Coins
	1149,	-- Sightless Eye (PvP)
	1268,	-- Timeworn Artifact (Honor Points?)
	1314,	-- Lingering Soul Fragment (Good luck with this one :D)
}

local function tholderOnFade()
	tokenHolder:Hide()
end

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

function BUIT:CreateTokensHolder()
	local db = E.db.dashboards.tokens
	local tholder
	if not tholder then
		tholder = CreateFrame('Frame', 'tokenHolder', E.UIParent)
		tholder:CreateBackdrop('Transparent')
		tholder:SetFrameStrata('BACKGROUND')
		tholder:SetFrameLevel(5)
		if E.db.dashboards.system.enableSystem then
			tholder:Point('TOPLEFT', sysHolder, 'BOTTOMLEFT', 0, -10)
		else
			tholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -30)
		end
		tholder.backdrop:Style('Outside')
		tholder:Hide()
	end
	
	if db.combat then
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
	if E.db.dashboards.tokens.combat then
		tokenHolder:RegisterEvent('PLAYER_REGEN_DISABLED')
		tokenHolder:RegisterEvent('PLAYER_REGEN_ENABLED')	
	else
		tokenHolder:UnregisterEvent('PLAYER_REGEN_DISABLED')
		tokenHolder:UnregisterEvent('PLAYER_REGEN_ENABLED')	
	end
end

local function Icon_OnMouseUp(self, btn)
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local id = self:GetParent().id
			local name = GetCurrencyInfo(id)
			E.db.dashboards.tokens.chooseTokens[name] = false
			BUIT:UpdateTokens()
		end
	end
end

local function Icon_OnEnter(self)
	local id = self:GetParent().id
	if E.db.dashboards.tokens.tooltip then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 3, 0);
		GameTooltip:SetCurrencyByID(id)
	end
end

function BUIT:UpdateTokens()
	local db = E.db.dashboards.tokens
	
	if( tokenFrames[1] ) then
		for i = 1, getn( tokenFrames ) do
			tokenFrames[i]:Kill()
		end
		twipe( tokenFrames )
		tokenHolder:Hide()
	end

	for i, id in ipairs(BUIcurrency) do
		local name, amount, icon, _, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(id)
		
		if name then
			
			if isDiscovered == false then db.chooseTokens[name] = false end
			
			if db.chooseTokens[name] == true then
				if db.zeroamount or amount > 0 then
					tokenHolder:Show()
					tokenHolder:Width(DASH_WIDTH)
					tokenHolder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#tokenFrames + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					if tokenHolderMover then
						tokenHolderMover:Size(tokenHolder:GetSize())
						tokenHolder:Point('TOPLEFT', tokenHolderMover, 'TOPLEFT')
					end
					
					local token = CreateFrame('Frame', nil, tokenHolder)
					token:Height(DASH_HEIGHT)
					token:Width(DASH_WIDTH)
					token:Point('TOPLEFT', tokenHolder, 'TOPLEFT', SPACING, -SPACING)
					token:EnableMouse(true)
					token.id = id

					token.dummy = CreateFrame('Frame', nil, token)
					token.dummy:Point('BOTTOMLEFT', token, 'BOTTOMLEFT', 2, (E.PixelMode and 2 or 0))
					token.dummy:Point('BOTTOMRIGHT', token, 'BOTTOMRIGHT', (E.PixelMode and -24 or -28), 0)
					token.dummy:Height(E.PixelMode and 3 or 5)

					token.dummy.dummyStatus = token.dummy:CreateTexture(nil, 'OVERLAY')
					token.dummy.dummyStatus:SetInside()
					token.dummy.dummyStatus:SetTexture(E['media'].BuiFlat)
					token.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

					token.Status = CreateFrame('StatusBar', nil, token.dummy)
					token.Status:SetStatusBarTexture(E['media'].BuiFlat)
					if totalMax == 0 then
						token.Status:SetMinMaxValues(0, amount)
					else
						if db.weekly and weeklyMax > 0 then
							token.Status:SetMinMaxValues(0, weeklyMax)
						else
							token.Status:SetMinMaxValues(0, totalMax)
						end
					end
					token.Status:SetValue(amount)
					token.Status:SetStatusBarColor(E.db.dashboards.barColor.r, E.db.dashboards.barColor.g, E.db.dashboards.barColor.b)
					token.Status:SetInside()
					
					token.spark = token.Status:CreateTexture(nil, 'OVERLAY', nil);
					token.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
					token.spark:Size(12, 6);
					token.spark:SetBlendMode('ADD');
					token.spark:SetPoint('CENTER', token.Status:GetStatusBarTexture(), 'RIGHT')

					token.Text = token.Status:CreateFontString(nil, 'OVERLAY')
					if E.db.dashboards.dashfont.useDTfont then
						token.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
					else
						token.Text:FontTemplate(LSM:Fetch('font', E.db.dashboards.dashfont.dbfont), E.db.dashboards.dashfont.dbfontsize, E.db.dashboards.dashfont.dbfontflags)
					end
					token.Text:Point('CENTER', token, 'CENTER', -10, (E.PixelMode and 1 or 3))
					token.Text:Width(token:GetWidth() - 20)
					token.Text:SetWordWrap(false)
					
					if E.db.dashboards.textColor == 1 then
						token.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						token.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
					end
					
					if totalMax == 0 then
						token.Text:SetFormattedText('%s', amount)
					else
						if db.weekly and weeklyMax > 0 then
							token.Text:SetFormattedText('%s / %s', amount, weeklyMax)
						else
							token.Text:SetFormattedText('%s / %s', amount, totalMax)
						end
					end

					token.IconBG = CreateFrame('Button', nil, token)
					token.IconBG:SetTemplate('Transparent')
					token.IconBG:Size(E.PixelMode and 18 or 20)
					token.IconBG:Point('BOTTOMRIGHT', token, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)
					token.IconBG:SetScript('OnMouseUp', Icon_OnMouseUp)
					token.IconBG:SetScript('OnEnter', Icon_OnEnter)

					token.IconBG.Icon = token.IconBG:CreateTexture(nil, 'ARTWORK')
					token.IconBG.Icon:SetInside()
					token.IconBG.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					token.IconBG.Icon:SetTexture(icon)

					token:SetScript('OnEnter', function(self)
						token.Text:SetFormattedText('%s', name)
					end)
					
					-- Flash
					if db.flash then
						E:Flash(token, 0.2)
					end
			
					token:SetScript('OnLeave', function(self)
						if totalMax == 0 then
							token.Text:SetFormattedText('%s', amount)
						else
							if db.weekly and weeklyMax > 0 then
								token.Text:SetFormattedText('%s / %s', amount, weeklyMax)
							else
								token.Text:SetFormattedText('%s / %s', amount, totalMax)
							end
						end				
						GameTooltip:Hide()
					end)

					tinsert(tokenFrames, token)
				end
			end
		end
	end

	for key, frame in ipairs(tokenFrames) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point('TOPLEFT', tokenHolder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:Point('TOP', tokenFrames[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end
end

function BUIT:TokenEvents()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateTokens')
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'UpdateTokens')
	self:SecureHook('BackpackTokenFrame_Update', 'UpdateTokens')
	self:SecureHook('TokenFrame_Update', 'UpdateTokens')
end

function BUIT:UpdateTHolderDimensions()
	local db = E.db.dashboards.tokens
	tokenHolder:Width(db.width)

	for _, frame in pairs(tokenFrames) do
		frame:Width(db.width)
	end
end

function BUIT:TokenDefaults()
	if E.db.dashboards.tokens.width == nil then E.db.dashboards.tokens.width = 150 end
end

function BUIT:Initialize()
	if E.db.dashboards.tokens.enableTokens ~= true then return end
	self:TokenDefaults()
	self:CreateTokensHolder()
	self:TokenEvents()
	self:UpdateTHolderDimensions()
	hooksecurefunc(DT, 'LoadDataTexts', BUIT.UpdateTokens)
end

E:RegisterModule(BUIT:GetName())