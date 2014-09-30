local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local BUID = E:GetModule('BuiDashboard')

local LastUpdate = 1

local statusColors = {
	'|cff0CD809',
	'|cffE8DA0F',
	'|cffFF9000',
	'|cffD80909'
}

function BUID:CreateMs()
	local id = 2
	BUID.board[id].Status:SetScript('OnUpdate', function(self, elapsed)
		LastUpdate = LastUpdate - elapsed

		if(LastUpdate < 0) then
			self:SetMinMaxValues(0, 200)
			local value = (select(4, GetNetStats()))
			local max = 200
			local mscolor = 4
			self:SetValue(value)

			if( value * 100 / max <= 35) then
				self:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
				mscolor = 1
			elseif value * 100 / max > 35 and value * 100 / max < 75 then
				self:SetStatusBarColor(1, 180 / 255, 0, .8)
				mscolor = 2
			else
				self:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
				mscolor = 3
			end
			local displayFormat = string.join('', 'MS: ', statusColors[mscolor], '%d|r')
			BUID.board[id].Text:SetFormattedText(displayFormat, value)
			LastUpdate = 1
		end
	end)
end