local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LSM = LibStub('LibSharedMedia-3.0')
local mod = E:NewModule('BUIiLevel', 'AceEvent-3.0');
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
	"Shirt",
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

function mod:UpdateItemLevel()
	local db = E.db.benikui.misc.ilevel

	for i = 1, 17 do
		local itemLink = GetInventoryItemLink("player", i)
		local iLvl = getItemLevel(i)
		if i ~= 4 and (equipped[i] ~= itemLink or mod.f[i]:GetText() ~= nil) then
			equipped[i] = itemLink
			if (itemLink ~= nil) then
				mod.f[i]:SetText(iLvl)
				local _, _, ItemRarity = GetItemInfo(itemLink)
				if ItemRarity and db.colorStyle == 'RARITY' then
					local r, g, b = GetItemQualityColor(ItemRarity)
					mod.f[i]:SetTextColor(r, g, b)
				else
					mod.f[i]:SetTextColor(BUI:unpackColor(db.color))
				end
			else
				mod.f[i]:SetText("")
			end
			mod.f[i]:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
		end
	end
end

local function returnPoints(number)
	if E.db.benikui.misc.ilevel.position == 'INSIDE' then
		if number <= 5 or number == 15 or number == 9 then 	-- Left side
			return "BOTTOMLEFT", "BOTTOMLEFT", 0, 1
		elseif number <= 14 then 							-- Right side
			return "BOTTOMRIGHT", "BOTTOMRIGHT", 2, 1
		else 												-- Weapon slots
			return "BOTTOM", "BOTTOM", 2, 1
		end
	else
		if number <= 5 or number == 15 or number == 9 then 	-- Left side
			return "LEFT", "RIGHT", 0, 1
		elseif number <= 14 then 							-- Right side
			return "RIGHT", "LEFT", 2, 1
		else 												-- Weapon slots
			return "BOTTOM", "BOTTOM", 2, 1
		end
	end
end

function mod:UpdateItemLevelPosition()
	for i = 1, 17 do
		if i ~= 4 then
			local parent = _G["Character"..slotTable[i]]
			local myPoint, parentPoint, x, y = returnPoints(i)
			mod.f[i]:ClearAllPoints()
			mod.f[i]:Point(myPoint, parent, parentPoint, x or 0, y or 0)
		end
	end
end

function mod:CreateString()
	for i = 1, 17 do
		if i ~= 4 then
			mod.f[i] = mod.f:CreateFontString(nil, "OVERLAY")
			mod.f[i]:FontTemplate()
		end
	end

	mod:UpdateItemLevelPosition()
	mod.f:SetFrameLevel(CharacterHeadSlot:GetFrameLevel())
	mod.f:Hide()
end

function mod:Initialize()
	if E.db.benikui.misc.ilevel.enable == false or (IsAddOnLoaded("ElvUI_SLE") and E.db.sle.Armory.Character.Enable ~= false) then return end

	mod.f = CreateFrame("Frame", nil, PaperDollFrame)
	mod:CreateString()
	mod:UpdateItemLevel()

	PaperDollFrame:HookScript("OnShow", function(self)
		mod.f:Show()
	end)

	PaperDollFrame:HookScript("OnHide", function(self)
		mod.f:Hide()
	end)

	mod:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", mod.UpdateItemLevel)
	mod:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE", mod.UpdateItemLevel)
end

local function InitializeCallback()
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)