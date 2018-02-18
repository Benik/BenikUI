local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LSM = LibStub('LibSharedMedia-3.0')
-- Based on iLevel addon by ahak. http://www.curse.com/addons/wow/ilevel

local _G = _G
local match, gsub = string.match, gsub

local CreateFrame = CreateFrame
local SetInventoryItem = SetInventoryItem
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor

-- GLOBALS: CharacterHeadSlot, CharacterNeckSlot, CharacterShoulderSlot, CharacterBackSlot, CharacterChestSlot, CharacterWristSlot
-- GLOBALS: CharacterHandsSlot, CharacterWaistSlot, CharacterLegsSlot, CharacterFeetSlot, CharacterFinger0Slot, CharacterFinger1Slot
-- GLOBALS: CharacterTrinket0Slot, CharacterTrinket1Slot, CharacterMainHandSlot, CharacterSecondaryHandSlot, PaperDollFrame

local equipped = {}

local slotTable = {
	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"!Skip!", -- Shirt
	"ChestSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"WristSlot",
	"HandsSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
	"BackSlot",
	"MainHandSlot",
	"SecondaryHandSlot"
}

local f = CreateFrame("Frame", nil, PaperDollFrame)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
local S_ITEM_LEVEL = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")

local scantip = CreateFrame("GameTooltip", "BenikUIiLvlScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local function getItemLevel(slotId)
	local hasItem = scantip:SetInventoryItem("player", slotId)
	local realItemLevel
	if not hasItem then return nil end

	for i = 2, scantip:NumLines() do
		local text = _G["BenikUIiLvlScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			realItemLevel = realItemLevel or match(text, S_ITEM_LEVEL)
			if realItemLevel then
				return realItemLevel
			end
		end
	end
end

function BUI:update_iLevelItems()
	local db = E.db.benikui.misc.ilevel
	for i = 1, 17 do
		local itemLink = GetInventoryItemLink("player", i)
		local iLvl = getItemLevel(i)
		if i ~= 4 and (equipped[i] ~= itemLink or f[i]:GetText() ~= nil) then
			equipped[i] = itemLink
			if (itemLink ~= nil) then
				f[i]:SetText(iLvl)
				local _, _, ItemRarity = GetItemInfo(itemLink)
				if ItemRarity and db.colorStyle == 'RARITY' then
					local r, g, b = GetItemQualityColor(ItemRarity)
					f[i]:SetTextColor(r, g, b)
				else
					f[i]:SetTextColor(BUI:unpackColor(db.color))
				end
			else
				f[i]:SetText("")
			end
			f[i]:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
		end
	end
end

local function returnPoints(number)
	if number <= 5 or number == 15 or number == 9 then -- Left side
		return "BOTTOMLEFT", "BOTTOMLEFT", 0, 1
	elseif number <= 14 then -- Right side
		return "BOTTOMRIGHT", "BOTTOMRIGHT", 2, 1
	else -- Weapon slots
		return "BOTTOM", "BOTTOM", 2, 1
	end
end

local function anchorString()
	for i = 1, 17 do
		if i ~= 4 then
			local parent = _G["Character"..slotTable[i]]
			local myPoint, parentPoint, x, y = returnPoints(i)
			f[i]:ClearAllPoints()
			f[i]:Point(myPoint, parent, parentPoint, x or 0, y or 0)
		end
	end
end

local function createString()
	for i = 1, 17 do
		if i ~= 4 then
			f[i] = f:CreateFontString(nil, "OVERLAY")
			f[i]:FontTemplate()
		end
	end

	anchorString(f)
	f:SetFrameLevel(CharacterHeadSlot:GetFrameLevel())
	f:Hide()
end

local function OnEvent(self, event)
	if E.db.benikui.misc.ilevel.enable == false then return end
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)

		createString()

		PaperDollFrame:HookScript("OnShow", function(self)
			f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
			f:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE")
			BUI:update_iLevelItems()
			f:Show()
		end)

		PaperDollFrame:HookScript("OnHide", function(self)
			f:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
			f:UnregisterEvent("ITEM_UPGRADE_MASTER_UPDATE")
			f:Hide()
		end)
	elseif event == "PLAYER_EQUIPMENT_CHANGED" or event == "ITEM_UPGRADE_MASTER_UPDATE" then
		BUI:update_iLevelItems()
	end
end
f:SetScript("OnEvent", OnEvent)