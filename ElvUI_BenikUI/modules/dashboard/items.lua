local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards')
local DT = E:GetModule('DataTexts')

local _G = _G
local getn = getn
local tinsert, twipe, tsort = table.insert, table.wipe, table.sort

local GameTooltip = _G.GameTooltip
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Container_GetContainerItemID = C_Container.GetContainerItemID
local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local BreakUpLargeNumbers = BreakUpLargeNumbers

-- GLOBALS: hooksecurefunc

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1
local itemsDB = mod.ItemsDB

local position, Xoffset

mod.ItemsList = {}

local classColor = E:ClassColor(E.myclass, true)

local function OnMouseUp(self, btn)
	if InCombatLockdown() then return end

	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local id = self.id
			E.private.benikui.dashboards.items.chooseItems[id].enable = false
			mod:UpdateItems()
		else
			E:ToggleOptions()
			local ACD = E.Libs.AceConfigDialog
			if ACD then ACD:SelectGroup("ElvUI", "benikui", "dashboards", "items") end
		end
	end
end

local function OnEnter(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ItemsDashboard
	local id = self.id
	
	if db.items.tooltip then
		GameTooltip:SetOwner(self, position, Xoffset, 0)
		GameTooltip:SetItemByID(id)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(L['Shift+RightClick to remove'], format('|cffff0000%s |r%s','ID', id), 0.7, 0.7, 1)
		GameTooltip:Show()
	end

	self.Text:SetFormattedText('%s', self.name)
	if db.items.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function OnLeave(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ItemsDashboard
	local BreakAmount = BreakUpLargeNumbers(self.amount)
	local BreakMax = BreakUpLargeNumbers(self.maxValue)

	self.Text:SetFormattedText('%s / %s', BreakAmount, BreakMax)

	if db.items.tooltip then
		GameTooltip:Hide()
	end

	if db.items.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
end

local function sortFunction(a, b)
	return a.name < b.name
end

function mod:GetItemsInfo(id)
	local name, icon, amount, totalMax

    for bagID = 0, NUM_BAG_SLOTS do
		for slot = 1, C_Container_GetContainerNumSlots(bagID) do
            if id then
                name, _, _, _, _, _, _, totalMax = GetItemInfo(id)
				icon = C_Item_GetItemIconByID(id)
                amount = GetItemCount(id, true)
                return name, icon, amount, totalMax
            end
        end
    end
end

function mod:UpdateItems()
	local db = E.db.benikui.dashboards
	local vdb = E.private.benikui.dashboards.items.chooseItems
	local holder = _G.BUI_ItemsDashboard

	if not db.items.enable then holder:Hide() return end

	local inInstance = IsInInstance()
	local NotinInstance = not (db.items.instance and inInstance)

	if(itemsDB[1]) then
		for i = 1, getn(itemsDB) do
			itemsDB[i]:Kill()
		end
		twipe(itemsDB)
		holder:Hide()
	end

	if db.items.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end

	for id in pairs(mod.ItemsList) do
		local name, icon, amount, totalMax = mod:GetItemsInfo(tonumber(id))

		if id and name then
			if vdb[id] and vdb[id].enable == true then
				holder:SetShown(NotinInstance)

				if db.items.orientation == 'BOTTOM' then
					holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#itemsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					holder:Width(db.items.width)
				else
					holder:Height(DASH_HEIGHT + (DASH_SPACING))
					holder:Width(db.items.width * (#itemsDB + 1) + ((#itemsDB) *db.items.spacing))
				end

				local bar = mod:CreateDashboard(holder, 'items', true)
				local BarColor = (db.barColor == 1 and classColor) or db.customBarColor
				local TextColor = (db.textColor == 1 and classColor) or db.customTextColor
				local BarMaxValue = vdb[id].useCustomStack and vdb[id].customStack or totalMax or 0
				local BreakAmount = BreakUpLargeNumbers(amount) or 0
				local BreakMax = BreakUpLargeNumbers(BarMaxValue) or 0

				bar.Status:SetMinMaxValues(0, BarMaxValue)
				bar.Status:SetValue(amount)
				bar.Status:SetStatusBarColor(BarColor.r, BarColor.g, BarColor.b)

				bar.Text:SetText(format('%s / %s', BreakAmount, BreakMax))
				bar.Text:SetTextColor(TextColor.r, TextColor.g, TextColor.b)
				bar.IconBG.Icon:SetTexture(icon)

				bar:SetScript('OnEnter', OnEnter)
				bar:SetScript('OnLeave', OnLeave)
				bar:SetScript('OnMouseUp', OnMouseUp)

				bar.id = id
				bar.name = name
				bar.amount = amount
				bar.maxValue = BarMaxValue

				tinsert(itemsDB, bar)
			end
		end
	end

	tsort(itemsDB, sortFunction)

	for key, frame in pairs(itemsDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point('TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			if db.items.orientation == 'BOTTOM' then
				frame:Point('TOP', itemsDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
			else
				frame:Point('LEFT', itemsDB[key - 1], 'RIGHT', db.items.spacing +(E.PixelMode and 0 or 2), 0)
			end
		end
	end

	mod:FontStyle(itemsDB)
	mod:FontColor(itemsDB)
	mod:BarColor(itemsDB)
	mod:IconPosition(itemsDB, 'items')
end

function mod:GetUserItems()
	local db = E.private.benikui.dashboards.items.chooseItems
	for id in pairs(db) do
		mod.ItemsList[id] = id
	end
	mod:UpdateItems()
end

local function holderOnEnter(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ItemsDashboard

	if db.items.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function holderOnLeave(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ItemsDashboard

	if db.items.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
end

local function CheckItemsPosition()
	if E.db.benikui.dashboards.items.enable ~= true then return end

	local pos, Xoff = mod:CheckPositionForTooltip(BUI_ItemsDashboard)
	position, Xoffset = pos, Xoff
end

function mod:ToggleItems()
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ItemsDashboard

	if db.items.enable then
		E:EnableMover(holder.mover.name)
		mod:RegisterEvent('BAG_UPDATE', mod.GetUserItems)

		mod:ToggleStyle(holder, 'items')
		mod:ToggleTransparency(holder, 'items')
		
		holder:SetScript('OnEnter', holderOnEnter)
		holder:SetScript('OnLeave', holderOnLeave)
	else
		E:DisableMover(holder.mover.name)
		mod:UnregisterEvent('BAG_UPDATE')

		holder:SetScript('OnEnter', nil)
		holder:SetScript('OnLeave', nil)
	end

	mod:GetUserItems()
	CheckItemsPosition()
end

function mod:CreateItemsDashboard()
	local db = E.db.benikui.dashboards
	local holder = mod:CreateDashboardHolder('BUI_ItemsDashboard', 'items')
	holder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -523)
	holder:Width(db.items.width or 150)

	E:CreateMover(holder, 'itemsHolderMover', L['items'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,items')
	mod:ToggleItems()
end

function mod:LoadItems()
	mod:CreateItemsDashboard()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateItems)
	hooksecurefunc(E, 'ToggleMoveMode', CheckItemsPosition)
end