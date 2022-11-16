local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');

local LastUpdate = 1
local select = select
local join = string.join
local _G = _G

local GetNetStats = GetNetStats

local statusColors = {
	'|cff0CD809',
	'|cffE8DA0F',
	'|cffFF9000',
	'|cffD80909'
}

function mod:CreateMs()
	local bar = _G['BUI_MS']
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard

	bar:SetScript('OnEnter', function(self)
		if not InCombatLockdown() then
			local value = 0
			local text = ""
			GameTooltip:SetOwner(bar, 'ANCHOR_RIGHT', 5, 0)
			GameTooltip:ClearLines()
			if E.db.benikui.dashboards.system.latency == 2 then
				value = (select(3, GetNetStats())) -- Home
				text = "MS ("..HOME.."): "
			else
				value = (select(4, GetNetStats())) -- World
				text = "MS ("..WORLD.."): "
			end
			GameTooltip:AddDoubleLine(text, value, 0.7, 0.7, 1, 0.84, 0.75, 0.65)
			GameTooltip:Show()

			if db.mouseover then
				E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
			end
		end
	end)

	bar:SetScript('OnLeave', function(self)
		if db.mouseover then
			E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
		end
		GameTooltip:Hide()
	end)

	bar.Status:SetScript('OnUpdate', function(self, elapsed)
		if LastUpdate > 0 then
			LastUpdate = LastUpdate - elapsed
			return
		end

		if(LastUpdate < 0) then
			self:SetMinMaxValues(0, 200)
			local value = 0
			local displayFormat = ""

			if E.db.benikui.dashboards.system.latency == 1 then
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

			if E.db.benikui.dashboards.system.latency == 1 then
				displayFormat = join('', 'MS (', HOME, '): ', statusColors[mscolor], '%d|r')
			else
				displayFormat = join('', 'MS (', WORLD, '): ', statusColors[mscolor], '%d|r')
			end

			bar.Text:SetFormattedText(displayFormat, value)
			LastUpdate = 1
		end
	end)
end
