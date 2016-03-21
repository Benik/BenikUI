local E, L, V, P, G = unpack(ElvUI);
local BUID = E:GetModule('BuiDashboard')

local LastUpdate = 1
local format, select = string.format, select
local join = string.join
local _G = _G

local GetNetStats = GetNetStats

local statusColors = {
	'|cff0CD809',
	'|cffE8DA0F',
	'|cffFF9000',
	'|cffD80909'
}

function BUID:CreateMs()
	local boardName = _G['MS']
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