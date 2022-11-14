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

local function OnEvent()
	local bar = _G['BUI_Durability']
	local db = E.db.benikui.dashboards.system

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
	bar.Text:SetFormattedText(displayString, totalDurability)

	bar.Status:SetMinMaxValues(0, 100)
	bar.Status:SetValue(totalDurability)

	bar.Text:Point(db.textAlign, bar, db.textAlign, ((db.textAlign == 'LEFT' and 4) or (db.textAlign == 'CENTER' and 0) or (db.textAlign == 'RIGHT' and -2)), (E.PixelMode and 1 or 3))
	bar.Text:SetJustifyH(db.textAlign)
end

function mod:ForceUpdateDurability()
	OnEvent()
end

function mod:CreateDurability()
	local bar = _G['BUI_Durability']
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard

	bar.Status:SetScript('OnEvent', OnEvent)

	bar:EnableMouse(true)
	bar:SetScript('OnEnter', function(self)
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

	bar:SetScript('OnLeave', function(self)
		if db.mouseover then
			E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
		end
		GameTooltip:Hide()
	end)

	bar:SetScript('OnMouseUp', Click)

	bar.Status:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	bar.Status:RegisterEvent('MERCHANT_SHOW')
	bar.Status:RegisterEvent('PLAYER_ENTERING_WORLD')
end
