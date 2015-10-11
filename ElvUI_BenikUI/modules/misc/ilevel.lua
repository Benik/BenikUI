local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

-- Based on iLevel addon by ahak. http://www.curse.com/addons/wow/ilevel

local BiL = E:NewModule('BUIiLevel', 'AceEvent-3.0')

local xo, yo = 0, 1
local equipped = {}
local strmatch = strmatch

local S_ITEM_LEVEL = "^" .. gsub(ITEM_LEVEL, "%%d", "(%%d+)")

local scantip = CreateFrame("GameTooltip", "iLvlScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local function getItemLevel(slotId)
	local hasItem = scantip:SetInventoryItem("player", slotId)
	if not hasItem then return nil end

	for i = 2, scantip:NumLines() do
		local text = _G["iLvlScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			local realItemLevel = strmatch(text, S_ITEM_LEVEL)
			if realItemLevel then
				return realItemLevel
			end
		end
	end
end

local function updateItems()
	for i = 1, 17 do
		local itemLink = GetInventoryItemLink("player", i)
		if i ~= 4 and (equipped[i] ~= itemLink or BuiSlot[i]:GetText() ~= nil) then
			equipped[i] = itemLink
			if (itemLink ~= nil) then
				BuiSlot[i]:SetText(getItemLevel(i))
				local _, _, ItemRarity = GetItemInfo(itemLink)
				if ItemRarity then
					local r, g, b = GetItemQualityColor(ItemRarity)
					BuiSlot[i]:SetTextColor(r, g, b)
				else
					BuiSlot[i]:SetTextColor(1, 1, 0)
				end
			else
				BuiSlot[i]:SetText("")
			end
		end
	end
end

function createString(parent, myPoint, parentPoint, x, y)
	local s = BuiSlot:CreateFontString(nil, "OVERLAY")
	s:FontTemplate(nil, 9, 'OUTLINE')
	s:SetPoint(myPoint, parent, parentPoint, x or 0, y or 0)
	return s
end

local function applyStrings()
	BuiSlot:SetFrameLevel(CharacterHeadSlot:GetFrameLevel())

	BuiSlot[1] = createString(CharacterHeadSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	BuiSlot[2] = createString(CharacterNeckSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	BuiSlot[3] = createString(CharacterShoulderSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	BuiSlot[15] = createString(CharacterBackSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	BuiSlot[5] = createString(CharacterChestSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)
	BuiSlot[9] = createString(CharacterWristSlot, "BOTTOMLEFT", "BOTTOMLEFT", xo, yo)

	BuiSlot[10] = createString(CharacterHandsSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	BuiSlot[6] = createString(CharacterWaistSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	BuiSlot[7] = createString(CharacterLegsSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	BuiSlot[8] = createString(CharacterFeetSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	BuiSlot[11] = createString(CharacterFinger0Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	BuiSlot[12] = createString(CharacterFinger1Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	BuiSlot[13] = createString(CharacterTrinket0Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)
	BuiSlot[14] = createString(CharacterTrinket1Slot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)

	BuiSlot[16] = createString(CharacterMainHandSlot, "BOTTOMLEFT", "BOTTOMLEFT", 0, yo)
	BuiSlot[17] = createString(CharacterSecondaryHandSlot, "BOTTOMRIGHT", "BOTTOMRIGHT", 3, yo)

	BuiSlot:Hide()
end

function BiL:EventHandler()

	applyStrings()
	
	PaperDollFrame:HookScript("OnShow", function(self)
		BuiSlot:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		if E.db.bui.ilvl then
			updateItems()
			BuiSlot:Show()
		else
			BuiSlot:Hide()
		end
	end)

	PaperDollFrame:HookScript("OnHide", function(self)
		BuiSlot:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
		BuiSlot:Hide()
	end)
	
	BuiSlot:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_EQUIPMENT_CHANGED" and E.db.bui.ilvl then
			updateItems()
		end		
	end)
	
	BuiSlot:SetScript("OnEvent", function(self, event)
		if event == "ACTIVE_TALENT_GROUP_CHANGED" and E.db.bui.ilvl then
			updateItems()
		end		
	end)
end

function BiL:PLAYER_ENTERING_WORLD(...)
	local f = CreateFrame("Frame", 'BuiSlot', PaperDollFrame)
	self:EventHandler()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function BiL:Initialize()
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

E:RegisterModule(BiL:GetName())