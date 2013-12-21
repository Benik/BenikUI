local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

local id = 3

local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"

local kiloByteString = "|cfff6a01a %d|r".." kb"
local megaByteString = "|cfff6a01a %.2f|r".." mb"

local function formatMem( memory )
	local mult = 10^1
	if( memory > 999 ) then
		local mem = ( ( memory / 1024 ) * mult ) / mult
		return string.format( megaByteString, mem )
	else
		local mem = ( memory * mult ) / mult
		return string.format( kiloByteString, mem )
	end
end

local memoryTable = {}

local function RebuildAddonList( self )
	local addOnCount = GetNumAddOns()
	if( addOnCount == #memoryTable ) or self.tooltip == true then return end

	memoryTable = {}
	for i = 1, addOnCount do
		memoryTable[i] = { i, select( 2, GetAddOnInfo( i ) ), 0, IsAddOnLoaded( i ) }
	end
end

local function UpdateMemory()
	UpdateAddOnMemoryUsage()

	local addOnMem = 0
	local totalMemory = 0
	for i = 1, #memoryTable do
		addOnMem = GetAddOnMemoryUsage( memoryTable[i][1] )
		memoryTable[i][3] = addOnMem
		totalMemory = totalMemory + addOnMem
	end

	table.sort( memoryTable, function( a, b )
		if( a and b ) then
			return a[3] > b[3]
		end
	end )

	return totalMemory
end

local int = 10

local function Update( self, t )
	int = int - t

	if( int < 0 ) then
		RebuildAddonList( self )
		local total = UpdateMemory()
		board[id].Text:SetText( "Memory: "..formatMem( total ) )
		board[id].Status:SetMinMaxValues( 0, 100000 )
		board[id].Status:SetValue( total )
		int = 10
	end
end

board[id].Status:SetScript( "OnMouseDown", function ()
	collectgarbage( "collect" )
	Update( board[id].Status, 10 )
end )

board[id].Status:SetScript( "OnEnter", function( self )
	if( not InCombatLockdown() ) then
		self.tooltip = true
		local bandwidth = GetAvailableBandwidth()
		GameTooltip:SetOwner( board[id], "ANCHOR_RIGHT", 5, 0 )
		GameTooltip:ClearLines()
		if( bandwidth ~= 0 ) then
			GameTooltip:AddDoubleLine( L['Bandwidth'], string.format( bandwidthString, bandwidth ), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65 )
			GameTooltip:AddDoubleLine( L['Download'], string.format( percentageString, GetDownloadedPercentage() * 100 ), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65 )
			GameTooltip:AddLine( " " )
		end

		local totalMemory = UpdateMemory()
		for i = 1, #memoryTable do
			if( memoryTable[i][4] ) then
				local red = memoryTable[i][3] / totalMemory
				local green = 1 - red
				GameTooltip:AddDoubleLine( memoryTable[i][2], formatMem( memoryTable[i][3] ), 1, 1, 1, red, green + .5, 0 )
			end
		end
		GameTooltip:Show()
	end
end )
board[id].Status:SetScript( "OnLeave", function( self )
	self.tooltip = false
	GameTooltip:Hide()
end )
board[id].Status:SetScript( "OnUpdate", Update )
board[id].Status:SetScript( "OnEvent", function( self, event )
	collectgarbage( "collect" )
end )
Update( board[id].Status, 10 )