local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local BUID = E:GetModule('BuiDashboard')

local join = string.join

local LastUpdate = 1

local statusColors = {
	'|cff0CD809',	-- green
	'|cffE8DA0F',	-- yellow
	'|cffFF9000',	-- orange
	'|cffD80909'	-- red
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

			if(value * 100 / max >= 45) then
				fpscolor = 1
			elseif value * 100 / max < 45 and value * 100 / max > 30 then
				fpscolor = 2
			else
				fpscolor = 3
			end

			local displayFormat = join('', 'FPS: ', statusColors[fpscolor], '%d|r')
			boardName.Text:SetFormattedText(displayFormat, value)
			LastUpdate = 1
		end
	end)
end