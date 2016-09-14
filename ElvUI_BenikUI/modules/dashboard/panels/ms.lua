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
			local value = 0
			local displayFormat = ""
			
			if E.db.dashboards.system.latency == 1 then
				value = (select(3, GetNetStats())) -- Home
			else
				value = (select(4, GetNetStats())) -- World
			end
			
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

			if E.db.dashboards.system.latency == 1 then
				displayFormat = join('', 'MS (', HOME, '): ', statusColors[mscolor], '%d|r')
			else
				displayFormat = join('', 'MS (', WORLD, '): ', statusColors[mscolor], '%d|r')
			end

			boardName.Text:SetFormattedText(displayFormat, value)
			LastUpdate = 1
		end
	end)
end