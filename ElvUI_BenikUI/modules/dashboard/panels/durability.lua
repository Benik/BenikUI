local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');

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

function mod:CreateDurability()
	local boardName = _G['BUI_Durability']
	local db = E.db.dashboards.system
	local holder = _G.BUI_SystemDashboard

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
	boardName:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 5, 0)
		GameTooltip:ClearAllPoints()

		GameTooltip:ClearLines()

		for slot, durability in pairs(invDurability) do
			GameTooltip:AddDoubleLine(slot, format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0, 0, 1, 1, 0, 0, 1, 0))
		end

		GameTooltip:Show()

		if db.mouseover then
			E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
		end
	end)
	boardName:SetScript('OnLeave', function(self)
		if db.mouseover then
			E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
		end
		GameTooltip:Hide()
	end)
	boardName:SetScript('OnMouseUp', Click)

	boardName.Status:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	boardName.Status:RegisterEvent('MERCHANT_SHOW')
	boardName.Status:RegisterEvent('PLAYER_ENTERING_WORLD')
end