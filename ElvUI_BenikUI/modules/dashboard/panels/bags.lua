local E, L, V, P, G = unpack(ElvUI);
local BUID = E:GetModule('BuiDashboard')

local join = string.join

local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local ToggleAllBags = ToggleAllBags
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local displayString = ''
local lastPanel

local function OnEvent(self)
	local boardName = _G['Bags']

	lastPanel = self
	local free, total = 0, 0
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end

	boardName.Text:SetFormattedText(displayString, L["Bags"]..': ', total - free, total)
	boardName.Status:SetMinMaxValues(0, total)
	boardName.Status:SetValue(total - free)
end

local function OnClick()
	ToggleAllBags()
end

function BUID:CreateBags()
	local boardName = _G['Bags']

	boardName.Status:SetScript('OnEvent', OnEvent)
	boardName:SetScript('OnMouseDown', OnClick)

	boardName.Status:RegisterEvent('BAG_UPDATE')
	boardName.Status:RegisterEvent('PLAYER_ENTERING_WORLD')
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s", hex, "%d/%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true