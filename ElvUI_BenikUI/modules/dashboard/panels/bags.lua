local E, L, V, P, G = unpack(ElvUI);
local mod = E:GetModule('BuiDashboards');

local join = string.join

local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local ToggleAllBags = ToggleAllBags
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local statusColors = {
	'|cff0CD809',	-- green
	'|cffE8DA0F',	-- yellow
	'|cffD80909'	-- red
}

local function OnEvent(self)
	local boardName = _G['BUI_Bags']

	local free, total = 0, 0
	local textColor = 1
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end

	local percentage = ((total - free) * 100) / total

	if percentage >= 80 then
		textColor = 3
	elseif percentage >= 60 and percentage < 80 then
		textColor = 2
	else
		textColor = 1
	end

	local displayFormat = join("", "%s", statusColors[textColor], "%d/%d|r")
	boardName.Text:SetFormattedText(displayFormat, L["Bags"]..': ', total - free, total)
	boardName.Status:SetMinMaxValues(0, total)
	boardName.Status:SetValue(total - free)
end

local function OnClick()
	ToggleAllBags()
end

function mod:CreateBags()
	local boardName = _G['BUI_Bags']

	boardName.Status:SetScript('OnEvent', OnEvent)
	boardName:SetScript('OnMouseDown', OnClick)

	boardName.Status:RegisterEvent('BAG_UPDATE')
	boardName.Status:RegisterEvent('PLAYER_ENTERING_WORLD')
end