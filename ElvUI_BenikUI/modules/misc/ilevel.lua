local E, L, V, P, G = unpack(ElvUI);
local BiLVL = E:NewModule('BUIiLevel', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');

local match, gsub = string.match, gsub
local LSM = LibStub('LibSharedMedia-3.0')

local CreateFrame = CreateFrame
local SetInventoryItem = SetInventoryItem
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor

local xo, yo = 0, 1
local equipped = {}

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

function BiLVL:UpdateSlots()
	local db = E.db.benikui.misc.ilevel
	for i = 1, 17 do
		local itemLink = GetInventoryItemLink("player", i)
		if i ~= 4 and (equipped[i] ~= itemLink or self.f[i]:GetText() ~= nil) then
			equipped[i] = itemLink
			if (itemLink ~= nil) then
				self.f[i]:SetFormattedText("%s", getItemLevel(i))
				local _, _, ItemRarity = GetItemInfo(itemLink)
				if ItemRarity and db.colorStyle == 'RARITY' then
					local r, g, b = GetItemQualityColor(ItemRarity)
					self.f[i]:SetTextColor(r, g, b)
				else
					self.f[i]:SetTextColor(BUI:unpackColor(db.color))
				end
			else
				self.f[i]:SetText("")
			end
			self.f[i]:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
		end
	end
end

function BiLVL:createString(parent, myPoint, parentPoint, x, y)
	local text = self.f:CreateFontString(nil, "OVERLAY")
	text:FontTemplate()
	text:SetPoint(myPoint, parent, parentPoint, x or 0, y or 0)
	return text
end

function BiLVL:applyStrings()
	self.f:SetFrameLevel(CharacterHeadSlot:GetFrameLevel())

	self.f[1] = self:createString(CharacterHeadSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	self.f[2] = self:createString(CharacterNeckSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	self.f[3] = self:createString(CharacterShoulderSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	self.f[15] = self:createString(CharacterBackSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	self.f[5] = self:createString(CharacterChestSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	self.f[9] = self:createString(CharacterWristSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)

	self.f[10] = self:createString(CharacterHandsSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	self.f[6] = self:createString(CharacterWaistSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	self.f[7] = self:createString(CharacterLegsSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	self.f[8] = self:createString(CharacterFeetSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	self.f[11] = self:createString(CharacterFinger0Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	self.f[12] = self:createString(CharacterFinger1Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	self.f[13] = self:createString(CharacterTrinket0Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	self.f[14] = self:createString(CharacterTrinket1Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)

	self.f[16] = self:createString(CharacterMainHandSlot, "BOTTOMLEFT", "BOTTOMLEFT", 0, yo)
	self.f[17] = self:createString(CharacterSecondaryHandSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)

	self.f:Hide()
end

function BiLVL:EnableDisable()
	if E.db.benikui.misc.ilevel.enable then
		self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', 'UpdateSlots')
		self:RegisterEvent('ITEM_UPGRADE_MASTER_UPDATE', 'UpdateSlots')
		self:UpdateSlots()
		self.f:Show()	
	else
		self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
		self:UnregisterEvent('ITEM_UPGRADE_MASTER_UPDATE')
		self.f:Hide()
	end
end

function BiLVL:Initialize()
	self.f = CreateFrame("Frame", nil, PaperDollFrame)
	self:applyStrings()
	self:EnableDisable()
end

E:RegisterModule(BiLVL:GetName())