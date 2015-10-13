local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local BUID = E:GetModule('BuiDashboard')

local LastUpdate = 1
local format = string.format
local join = string.join

local statusColors = {
	'|cff0CD809',
	'|cffE8DA0F',
	'|cffFF9000',
	'|cffD80909'
}

local homeLatencyString = "%d ms"
local worldLatencyString = "%d ms"

function BUID:CreateMs()
	local boardName = MS
	boardName.Status:SetScript('OnUpdate', function(self, elapsed)
		LastUpdate = LastUpdate - elapsed
		
		if(LastUpdate < 0) then
			self:SetMinMaxValues(0, 200)
			local value = (select(4, GetNetStats()))
			local max = 200
			local mscolor = 4
			self:SetValue(value)

			if( value * 100 / max <= 35) then
				mscolor = 1
			elseif value * 100 / max > 35 and value * 100 / max < 75 then
				mscolor = 2
			else
				mscolor = 3
			end

			local displayFormat = join('', 'MS: ', statusColors[mscolor], '%d|r')
			boardName.Text:SetFormattedText(displayFormat, value)
			LastUpdate = 1
		end
	end)
end