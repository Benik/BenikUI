local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');

local _G = _G
local join, floor = string.join, floor
local select, collectgarbage = select, collectgarbage
local sort, wipe = table.sort, table.wipe
local format = string.format

local GetFramerate = GetFramerate
local GetNumAddOns = GetNumAddOns
local GetAddOnInfo = GetAddOnInfo
local IsAddOnLoaded = IsAddOnLoaded
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local InCombatLockdown = InCombatLockdown
local GameTooltip = _G["GameTooltip"]

local kiloByteString = '|cfff6a01a %d|r'..' kb'
local megaByteString = '|cfff6a01a %.2f|r'..' mb'

local totalMemory = 0
local LastUpdate = 1

local statusColors = {
	'|cff0CD809',	-- green
	'|cffE8DA0F',	-- yellow
	'|cffFF9000',	-- orange
	'|cffD80909'	-- red
}

local function formatMem(memory)
	local mem
	local mult = 10^1
	if( memory > 999 ) then
		mem = ((memory / 1024) * mult) / mult
		return format(megaByteString, mem)
	else
		mem = (memory * mult) / mult
		return format(kiloByteString, mem)
	end
end

local function sortByMemory(a, b)
	if a and b then
		return (a[3] == b[3] and a[2] < b[2]) or a[3] > b[3]
	end
end

local memoryTable = {}

local function RebuildAddonList()
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) then return end

	-- Number of loaded addons changed, create new memoryTable for all addons
	wipe(memoryTable)

	for i = 1, addOnCount do
		memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
	end
end

local function UpdateMemory()
	-- Update the memory usages of the addons
	UpdateAddOnMemoryUsage()
	-- Load memory usage in table
	totalMemory = 0
	for i = 1, #memoryTable do
		memoryTable[i][3] = GetAddOnMemoryUsage(memoryTable[i][1])
		totalMemory = totalMemory + memoryTable[i][3]
	end
	-- Sort the table to put the largest addon on top
	sort(memoryTable, sortByMemory)
end

local function OnMouseDown(self)
	if(not InCombatLockdown()) then
		collectgarbage('collect')
	end
end

local function OnEnter(self)
	local db = self.db
	local holder = self:GetParent()

	if(not InCombatLockdown()) then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 5, 0)
		GameTooltip:ClearLines()

		RebuildAddonList()
		UpdateMemory()

		GameTooltip:AddDoubleLine(L["Total Memory:"], formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:AddLine(' ')

		local red, green
		for i = 1, #memoryTable do
			if(memoryTable[i][4] ) then
				red = memoryTable[i][3] / totalMemory
				green = 1 - red
				GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3] ), 1, 1, 1, red, green + .5, 0)
			end
		end
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(L['Tip: Click to free memory'], 0.7, 0.7, 1)

		GameTooltip:Show()
		if db.mouseover then
			E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
		end
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

local function OnUpdate(self, elapsed)
	local db = self.db
	if db.instance and IsInInstance() then return end

	if LastUpdate > 0 then
		LastUpdate = LastUpdate - elapsed
		return
	end

	if(LastUpdate < 0) then
		self.Status:SetMinMaxValues(0, 200)
		local value = floor(GetFramerate())
		local max = 120
		local fpscolor = 4
		self.Status:SetValue(value)

		if(value * 100 / max >= 45) then
			fpscolor = 1
		elseif value * 100 / max < 45 and value * 100 / max > 30 then
			fpscolor = 2
		else
			fpscolor = 3
		end

		local displayFormat = join('', 'FPS: ', statusColors[fpscolor], '%d|r')
		self.Text:SetFormattedText(displayFormat, value)

		LastUpdate = 1
	end
end

function mod:CreateFps()
	local bar = _G['BUI_FPS']
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard
	bar:SetParent(holder)
	bar.db = db

	bar:SetScript('OnMouseDown', OnMouseDown)
	bar:SetScript('OnEnter', OnEnter)
	bar:SetScript('OnLeave', OnLeave)

	bar:SetScript('OnUpdate', OnUpdate)
end