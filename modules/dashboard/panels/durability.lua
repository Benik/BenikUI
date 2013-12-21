local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local id = 4
local displayString = ""
local tooltipString = "%d%%"
local totalDurability = 0
local current, max, lastPanel
local invDurability = {}

local function OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 5, 0)
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
	ToggleCharacter("PaperDollFrame")
end

local slots = {
	["SecondaryHandSlot"] = L['Offhand'],
	["MainHandSlot"] = L['Main Hand'],
	["FeetSlot"] = L['Feet'],
	["LegsSlot"] = L['Legs'],
	["HandsSlot"] = L['Hands'],
	["WristSlot"] = L['Wrist'],
	["WaistSlot"] = L['Waist'],
	["ChestSlot"] = L['Chest'],
	["ShoulderSlot"] = L['Shoulder'],
	["HeadSlot"] = L['Head'],
}

board[id].Status:SetScript("OnEvent", function( self, ...)

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
	
	board[id].Text:SetFormattedText(displayString, totalDurability)

	self:SetMinMaxValues(0, 100)
	self:SetValue(totalDurability)
	
	if( totalDurability >= 75 ) then
		self:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
	elseif totalDurability < 75 and totalDurability > 40 then
		self:SetStatusBarColor(1, 180 / 255, 0, .8)
	else
		self:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
	end
end)

local function ValueColorUpdate(hex, r, g, b)
	displayString = string.join("", DURABILITY, ": ", hex, "%d%%|r")
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

board[id]:EnableMouse(true)
board[id]:SetScript('OnEnter', OnEnter)
board[id]:SetScript('OnLeave', OnLeave)
board[id]:SetScript('OnMouseUp', Click)

board[id].Status:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
board[id].Status:RegisterEvent("MERCHANT_SHOW")
board[id].Status:RegisterEvent("PLAYER_ENTERING_WORLD")