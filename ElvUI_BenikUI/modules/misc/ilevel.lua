local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('iLevel')
local LSM = E.LSM

local _G = _G
local next, wipe = next, wipe

local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local GetItemQualityColor = C_Item.GetItemQualityColor or GetItemQualityColor
local C_Timer_After = C_Timer.After

-- GLOBALS: CharacterNeckSlot

local slotIDs = {
	[1] = "HeadSlot",
	[2] = "NeckSlot",
	[3] = "ShoulderSlot",
	[5] = "ChestSlot",
	[6] = "WaistSlot",
	[7] = "LegsSlot",
	[8] = "FeetSlot",
	[9] = "WristSlot",
	[10] = "HandsSlot",
	[11] = "Finger0Slot",
	[12] = "Finger1Slot",
	[13] = "Trinket0Slot",
	[14] = "Trinket1Slot",
	[15] = "BackSlot",
	[16] = "MainHandSlot",
	[17] = "SecondaryHandSlot"
}

local iLevelDB = {}

function mod:UpdateItemLevel()
	local db = E.db.benikui.misc.ilevel

	if next(iLevelDB) then wipe(iLevelDB) end

	for id, _ in pairs(slotIDs) do
		local itemLink = GetInventoryItemLink("player", id)
		local slotInfo = E:GetGearSlotInfo("player", id)
		if (itemLink ~= nil) then
			iLevelDB[id] = slotInfo.iLvl
			mod.f[id]:SetText(slotInfo.iLvl)

			local _, _, ItemRarity = GetItemInfo(itemLink)
			if ItemRarity and db.colorStyle == 'RARITY' then
				local r, g, b = GetItemQualityColor(ItemRarity)
				mod.f[id]:SetTextColor(r, g, b)
			else
				mod.f[id]:SetTextColor(BUI:unpackColor(db.color))
			end
		else
			mod.f[id]:SetText("")
		end
		mod.f[id]:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
	end
	CharacterNeckSlot.RankFrame.Label:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
end

local function returnPoints(id)
	if E.db.benikui.misc.ilevel.position == 'INSIDE' then
		if id <= 5 or id == 15 or id == 9 then 			-- Left side
			return "BOTTOMLEFT", "BOTTOMLEFT", 0, 1
		elseif id <= 14 then 							-- Right side
			return "BOTTOMRIGHT", "BOTTOMRIGHT", 2, 1
		else 											-- Weapon slots
			return "BOTTOM", "BOTTOM", 2, 1
		end
	else
		if id <= 5 or id == 15 or id == 9 then 			-- Left side
			return "LEFT", "RIGHT", 0, 1
		elseif id <= 14 then 							-- Right side
			return "RIGHT", "LEFT", 2, 1
		else 											-- Weapon slots
			return "BOTTOM", "BOTTOM", 2, 1
		end
	end
end

function mod:UpdateItemLevelPosition()
	for id, _ in pairs(slotIDs) do
		local parent = _G["Character"..slotIDs[id]]
		local myPoint, parentPoint, x, y = returnPoints(id)
		mod.f[id]:ClearAllPoints()
		mod.f[id]:Point(myPoint, parent, parentPoint, x or 0, y or 0)
	end

	CharacterNeckSlot.RankFrame:ClearAllPoints()
	CharacterNeckSlot.RankFrame.Label:ClearAllPoints()
	CharacterNeckSlot.RankFrame:Point('TOPRIGHT', CharacterNeckSlot, 'TOPRIGHT', 0, 4)
	CharacterNeckSlot.RankFrame.Label:Point('RIGHT')
end

function mod:CreateString()
	for id, _ in pairs(slotIDs) do
		mod.f[id] = mod.f:CreateFontString(nil, "OVERLAY")
		mod.f[id]:FontTemplate()
	end

	mod:UpdateItemLevelPosition()
	mod.f:SetFrameLevel(CharacterHeadSlot:GetFrameLevel())
	mod.f:Hide()
end

function mod:PLAYER_ENTERING_WORLD()
	C_Timer_After(.1, function() mod:UpdateItemLevel() end)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	if E.db.benikui.misc.ilevel.enable == false or (BUI.SLE and E.db.sle.armory.character.enable ~= false) then return end

	mod.f = CreateFrame("Frame", nil, PaperDollFrame)
	mod:CreateString()

	PaperDollFrame:HookScript("OnShow", function(self)
		mod.f:Show()
	end)

	PaperDollFrame:HookScript("OnHide", function(self)
		mod.f:Hide()
	end)

	mod:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", mod.UpdateItemLevel)
	mod:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE", mod.UpdateItemLevel)
	mod:RegisterEvent("PLAYER_ENTERING_WORLD")
end

BUI:RegisterModule(mod:GetName())