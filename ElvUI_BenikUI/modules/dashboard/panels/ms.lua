local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');

local LastUpdate = 1
local select = select
local join = string.join
local _G = _G

local GetNetStats = GetNetStats

local statusColors = {
	'cff0CD809',	-- green
	'cffE8DA0F',	-- yellow
	'cffD80909',	-- red
}

local function OnEnter(self)
	local db = self.db
	if not InCombatLockdown() then
		local value = 0
		local text = ""

		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 5, 0)
		GameTooltip:ClearLines()

		if db.latency == 2 then
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
		local value = 0
		local displayFormat = ""
		local max = 100
		local mscolor

		if db.latency == 1 then
			value = (select(3, GetNetStats())) -- Home
		else
			value = (select(4, GetNetStats())) -- World
		end

		self.Status:SetValue(value)

		if( value * 100 / max <= 25) then
			mscolor = 1
		elseif value * 100 / max > 25 and value * 100 / max < 60 then
			mscolor = 2
		else
			mscolor = 3
		end

		if db.latency == 1 then
			displayFormat = join('', 'MS (', HOME, ') : |', statusColors[mscolor], '%d|r')
		else
			displayFormat = join('', 'MS (', WORLD, ') : |', statusColors[mscolor], '%d|r')
		end

		self.Text:SetFormattedText(displayFormat, value)

		if db.overrideColor then
			local r, g, b = E:HexToRGB(statusColors[mscolor])
			self.Status:SetStatusBarColor(r/255, g/255, b/255)
		end
		
		LastUpdate = db.updateThrottle or 1
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

function mod:CreateMs()
	local bar = _G['BUI_MS']
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard
	bar:SetParent(holder)
	bar.db = db

	bar:SetScript('OnEnter', OnEnter)
	bar:SetScript('OnLeave', OnLeave)
	bar:SetScript('OnUpdate', OnUpdate)
end
