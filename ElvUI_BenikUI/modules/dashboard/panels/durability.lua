local BUI, E, L, V, P, G = unpack((select(2, ...)))
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

local function OnMouseUp()
	ToggleCharacter('PaperDollFrame')
end

local function OnEvent(self)
	local db = self.db

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

	local r, g, b = E:ColorGradient(totalDurability * 0.01, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	local color = E:RGBToHex(r, g, b)
	self.Text:SetFormattedText('%s: %s%d%%|r', DURABILITY, color, totalDurability)

	self.Status:SetMinMaxValues(0, 100)
	self.Status:SetValue(totalDurability)

	if db.overrideColor then
		self.Status:SetStatusBarColor(r, g, b)
	end
end

local function OnEnter(self)
	local db = self.db
	local holder = self:GetParent()

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
end

local function OnLeave(self)
	local db = self.db
	local holder = self:GetParent()
	if db.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
	GameTooltip:Hide()
end

function mod:CreateDurability()
	local bar = _G['BUI_Durability']
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard
	bar:SetParent(holder)
	bar.db = db

	bar:SetScript('OnEvent', OnEvent)

	bar:EnableMouse(true)
	bar:SetScript('OnEnter', OnEnter)
	bar:SetScript('OnLeave', OnLeave)
	bar:SetScript('OnMouseUp', OnMouseUp)

	bar:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	bar:RegisterEvent('MERCHANT_SHOW')
	bar:RegisterEvent('PLAYER_ENTERING_WORLD')
end
