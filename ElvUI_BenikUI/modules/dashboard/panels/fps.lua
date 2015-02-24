local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local BUID = E:GetModule('BuiDashboard')

local LastUpdate = 1

local statusColors = {
	'|cff0CD809',
	'|cffE8DA0F',
	'|cffFF9000',
	'|cffD80909'
}

function BUID:CreateFps()
	local boardName = FPS
	boardName.Status:SetScript('OnUpdate', function(self, elapsed)
		LastUpdate = LastUpdate - elapsed

		if(LastUpdate < 0) then
			self:SetMinMaxValues(0, 200)
			local value = floor(GetFramerate())
			local max = 120
			local fpscolor = 4
			self:SetValue(value)

			if(value * 100 / max >= 75) then
				fpscolor = 1
			elseif value * 100 / max < 75 and value * 100 / max > 40 then
				fpscolor = 2
			else
				fpscolor = 3
			end

			local displayFormat = string.join('', 'FPS: ', statusColors[fpscolor], '%d|r')
			boardName.Text:SetFormattedText(displayFormat, value)
			LastUpdate = 1
		end
	end)
end