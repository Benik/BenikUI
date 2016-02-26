local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
-- Based on iLevel addon by ahak. http://www.curse.com/addons/wow/ilevel

if E.db.benikui.misc.ilevel == nil then E.db.benikui.misc.ilevel = {} end

if E.db.benikui.misc.ilevel.enable == false then return end

local match, gsub = string.match, gsub

local LSM = LibStub('LibSharedMedia-3.0')

local CreateFrame = CreateFrame
local SetInventoryItem = SetInventoryItem
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor

local xo, yo = 0, 1
local equipped = {}

local f = CreateFrame("Frame", nil, PaperDollFrame)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
local S_ITEM_LEVEL = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")

local scantip = CreateFrame("GameTooltip", "iLvlScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local function getItemLevel(slotId)
	local hasItem = scantip:SetInventoryItem("player", slotId)
	if not hasItem then return nil end

	for i = 2, scantip:NumLines() do
		local text = _G["iLvlScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			local realItemLevel = match(text, S_ITEM_LEVEL)
			if realItemLevel then
				return realItemLevel
			end
		end
	end
end

local function updateItems()
	local db = E.db.benikui.misc.ilevel
	for i = 1, 17 do
		local itemLink = GetInventoryItemLink("player", i)
		if i ~= 4 and (equipped[i] ~= itemLink or f[i]:GetText() ~= nil) then
			equipped[i] = itemLink
			if (itemLink ~= nil) then
				f[i]:SetFormattedText("%s", getItemLevel(i))
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

local function createString(parent, myPoint, parentPoint, x, y)
	local s = f:CreateFontString(nil, "OVERLAY")
	s:FontTemplate()
	s:SetPoint(myPoint, parent, parentPoint, x or 0, y or 0)
	return s
end

local function applyStrings()
	f:SetFrameLevel(CharacterHeadSlot:GetFrameLevel())

	f[1] = createString(CharacterHeadSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	f[2] = createString(CharacterNeckSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	f[3] = createString(CharacterShoulderSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	f[15] = createString(CharacterBackSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	f[5] = createString(CharacterChestSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	f[9] = createString(CharacterWristSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)

	f[10] = createString(CharacterHandsSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	f[6] = createString(CharacterWaistSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	f[7] = createString(CharacterLegsSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	f[8] = createString(CharacterFeetSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	f[11] = createString(CharacterFinger0Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	f[12] = createString(CharacterFinger1Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	f[13] = createString(CharacterTrinket0Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	f[14] = createString(CharacterTrinket1Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)

	f[16] = createString(CharacterMainHandSlot, "BOTTOMLEFT", "BOTTOMLEFT", 0, yo)
	f[17] = createString(CharacterSecondaryHandSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)

	f:Hide()
end

local function OnEvent(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent(event)

		applyStrings()

		PaperDollFrame:HookScript("OnShow", function(self)
			f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
			updateItems()
			f:Show()
		end)

		PaperDollFrame:HookScript("OnHide", function(self)
			f:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
			f:Hide()
		end)
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		updateItems()
	end
end
f:SetScript("OnEvent", OnEvent)