local E, L, V, P, G = unpack(ElvUI);
local BUID = E:GetModule('BuiDashboard')

local _G = _G
local pairs = pairs
local format, join = string.format, string.join

local GameTooltip = _G["GameTooltip"]
local GetInventorySlotInfo = GetInventorySlotInfo
local GetInventoryItemDurability = GetInventoryItemDurability
local ToggleCharacter = ToggleCharacter

-- GLOBALS: Durability, DURABILITY

local displayString = ''
local tooltipString = '%d%%'
local totalDurability = 0
local current, max, lastPanel
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

function BUID:CreateDurability()
	local boardName = Durability
	
	boardName.Status:SetScript('OnEvent', function( self, ...)

		lastPanel = self
		totalDurability = 100
		
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

local function ValueColorUpdate(hex, r, g, b)
	displayString = join('', DURABILITY, ': ', hex, '%d%%|r')
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

