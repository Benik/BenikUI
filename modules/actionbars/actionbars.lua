local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AB = E:GetModule('ActionBars');
local BAB = E:NewModule('BuiActionbars');
local BUI = E:GetModule('BenikUI');
local LSM = LibStub("LibSharedMedia-3.0")

if E.private.actionbar.enable ~= true then return; end

local SPACING = (E.PixelMode and 1 or 5)

local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

if E.db.bab == nil then E.db.bab = {} end

function BAB:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, 10 do
		local styleBacks = {_G["ElvUI_Bar"..i]}
		for _, frame in pairs(styleBacks) do
			if frame.backdrop then
				frame.backdrop:Style('Outside', frame:GetName().."_Bui")
			end
		end	
	end
	-- Other bar backdrops
	local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar, ElvUI_TotemBar, ElvUIBags}
	for _, frame in pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:Style('Outside', frame:GetName().."_Bui")
		end
	end
end

local function ab3_OnClick(self)
	if E.db.actionbar['bar3']['enabled'] == true then
		E.db.actionbar['bar3']['enabled'] = false
	elseif E.db.actionbar['bar3']['enabled'] == false then
		E.db.actionbar['bar3']['enabled'] = true
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
		abtn[i]:Size(10, 6)
		abtn[i].color = abtn[i]:CreateTexture(nil, 'OVERLAY')
		abtn[i].color:SetInside()
		abtn[i].color:SetTexture(E["media"].BuiFlat)
		abtn[i].color:SetVertexColor(1, 0.5, 0.1, 1)
		abtn[i]:SetAlpha(0)

		abtn[i]:SetScript('OnEnter', function(self)
			abtn[i]:SetAlpha(1)
			if i == 1 then
				abtn[i]:SetScript('OnClick', ab3_OnClick)
			else
				abtn[i]:SetScript('OnClick', ab5_OnClick)
			end
		end)

		abtn[i]:SetScript('OnLeave', function(self)
			abtn[i]:SetAlpha(0)
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

function BAB:Initialize()
	self:StyleBackdrops()
	self:CreateButtons()
end

E:RegisterModule(BAB:GetName())