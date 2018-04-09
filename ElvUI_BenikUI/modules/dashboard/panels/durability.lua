local E, L, V, P, G = unpack(ElvUI);
local BUID = E:GetModule('BuiDashboard')

local _G = _G
local pairs, format, join = pairs, string.format, string.join

local GameTooltip = _G["GameTooltip"]
local GetInventorySlotInfo = GetInventorySlotInfo
local GetInventoryItemDurability = GetInventoryItemDurability
local ToggleCharacter = ToggleCharacter

local DURABILITY = DURABILITY

local tooltipString = '%d%%'
local totalDurability = 0
local current, max
local invDurability = {}

local function OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 5, 0)
	GameTooltip:ClearAllPoints()

	GameTooltip:ClearLines()

	for slot, durability in pairs(invDurability) do
		GameTooltip:AddDoubleLine(slot, format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0, 0, 1, 1, 0, 0, 1, 0))
	end

	GameTooltip:Show()
end

local function OnLeave(self)
	GameTooltip:Hide()
end

local function Click()
	ToggleCharacter('PaperDollFrame')
end

local slots = {
	['SecondaryHandSlot'] = L['Offhand'],
	['MainHandSlot'] = L['Main Hand'],
	['FeetSlot'] = L['Feet'],
	['LegsSlot'] = L['Legs'],
	['HandsSlot'] = L['Hands'],
	['WristSlot'] = L['Wrist'],
	['WaistSlot'] = L['Waist'],
	['ChestSlot'] = L['Chest'],
	['ShoulderSlot'] = L['Shoulder'],
	['HeadSlot'] = L['Head'],
}

local statusColors = {
	'|cff0CD809',	-- green
	'|cffE8DA0F',	-- yellow
	'|cffD80909'	-- red
}

function BUID:CreateDurability()
	local boardName = _G['Durability']

	boardName.Status:SetScript('OnEvent', function(self)

		totalDurability = 100
		local textColor = 1

		for index, value in pairs(slots) do
			local slot = GetInventorySlotInfo(index)
			current, max = GetInventoryItemDurability(slot)

			if current then
				invDurability[value] = (current/max)*100

				if ((current/max) * 100) < totalDurability then
					totalDurability = (current/max) * 100
				end
			end
		end

		if totalDurability >= 90 then
			textColor = 1
		elseif totalDurability >= 70 and totalDurability < 90 then
			textColor = 2
		else
			textColor = 3
		end

		local displayString = join('', DURABILITY, ': ', statusColors[textColor], '%d%%|r')
		boardName.Text:SetFormattedText(displayString, totalDurability)

		self:SetMinMaxValues(0, 100)
		self:SetValue(totalDurability)
	end)

	boardName:EnableMouse(true)
	boardName:SetScript('OnEnter', OnEnter)
	boardName:SetScript('OnLeave', OnLeave)
	boardName:SetScript('OnMouseUp', Click)

	boardName.Status:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	boardName.Status:RegisterEvent('MERCHANT_SHOW')
	boardName.Status:RegisterEvent('PLAYER_ENTERING_WORLD')
end