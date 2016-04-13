local E, L, V, P, G = unpack(ElvUI);
local BUID = E:GetModule('BuiDashboard')

local select, collectgarbage = select, collectgarbage
local sort, wipe = table.sort, table.wipe
local format = string.format

local _G = _G
local GetNumAddOns = GetNumAddOns
local GetAddOnInfo = GetAddOnInfo
local IsAddOnLoaded = IsAddOnLoaded
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local InCombatLockdown, IsInInstance = InCombatLockdown, IsInInstance
local GameTooltip = _G["GameTooltip"]

-- GLOBALS: selectioncolor

local kiloByteString = '|cfff6a01a %d|r'..' kb'
local megaByteString = '|cfff6a01a %.2f|r'..' mb'

local totalMemory = 0

local function formatMem( memory )
	local mem
	local mult = 10^1
	if( memory > 999 ) then
		mem = ( ( memory / 1024 ) * mult ) / mult
		return format( megaByteString, mem )
	else
		mem = ( memory * mult ) / mult
		return format( kiloByteString, mem )
	end
end

local function sortByMemory(a, b)
	if a and b then
		return a[3] > b[3]
	end
end

local memoryTable = {}

local function RebuildAddonList()
	local addOnCount = GetNumAddOns()
	if( addOnCount == #memoryTable ) then return end

	wipe( memoryTable )
	for i = 1, addOnCount do
		memoryTable[i] = { i, select( 2, GetAddOnInfo( i ) ), 0, IsAddOnLoaded( i ) }
	end
end

local function UpdateMemory()
	UpdateAddOnMemoryUsage()

	local addOnMemory = 0
	totalMemory = 0
	for i = 1, #memoryTable do
		addOnMemory = GetAddOnMemoryUsage(memoryTable[i][1])
		memoryTable[i][3] = addOnMemory
		totalMemory = totalMemory + addOnMemory
	end
	
	if not InCombatLockdown() then
		sort( memoryTable, sortByMemory )
	end

end

local int = 10

local function Update( self, t )
	local boardName = _G['Memory']
	int = int - t
	
	if( int < 0 ) then
		local inInstance = IsInInstance()
		if (IsAddOnLoaded('ZygorGuidesViewer') and inInstance) then
			boardName.Text:SetFormattedText("%s|cffffa700%s|r", L['Memory: '], L['Disabled'])
			boardName.Status:SetMinMaxValues( 0, 100000 )
			boardName.Status:SetValue( 0 )
		else
			RebuildAddonList(self)
			UpdateMemory()
			boardName.Text:SetFormattedText("%s", (L['Memory: ']..formatMem(totalMemory)))
			boardName.Status:SetMinMaxValues( 0, 100000 )
			boardName.Status:SetValue( totalMemory )
		end
		int = 10
	end
end

function BUID:CreateMemory()
	local boardName = _G['Memory']
	boardName:SetScript( 'OnMouseDown', function (self)
		if( not InCombatLockdown() ) then
			collectgarbage( 'collect' )
			Update(boardName, 10)
		end
	end )

	boardName:SetScript( 'OnEnter', function( self )
		if( not InCombatLockdown() ) then
			
			GameTooltip:SetOwner( boardName, 'ANCHOR_RIGHT', 5, 0 )
			GameTooltip:ClearLines()
			
			local inInstance = IsInInstance()
			
			if (IsAddOnLoaded('ZygorGuidesViewer') and inInstance) then
				GameTooltip:AddLine(L['Framerate drop has been reported with Zygor Guides\nand the Memory module while in an instance.\nMemory module updates have been temporarily disabled.'], selectioncolor)
			else
				local red, green
				for i = 1, #memoryTable do
					if( memoryTable[i][4] ) then
						red = memoryTable[i][3] / totalMemory
						green = 1 - red
						GameTooltip:AddDoubleLine( memoryTable[i][2], formatMem( memoryTable[i][3] ), 1, 1, 1, red, green + .5, 0 )
					end
				end
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(L['Tip: Click to free memory'], 0.7, 0.7, 1)
			end

			GameTooltip:Show()
		end
	end )
	
	boardName:SetScript( 'OnLeave', function( self )
		GameTooltip:Hide()
	end )
	
	boardName.Status:SetScript( 'OnUpdate', Update )
end