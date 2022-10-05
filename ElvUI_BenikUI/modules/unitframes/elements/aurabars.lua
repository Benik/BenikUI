local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local mod = BUI:GetModule('Units');

function mod:ApplyAuraBarShadows(bar)
	if not BUI.ShadowMode then return end

	local bars = bar:GetParent()
	bar.db = bars.db

	bar.hasShadow = false
	if bar.hasShadow == false then
		bar.backdrop:CreateSoftShadow()
		bar.icon.backdrop:CreateSoftShadow()
		bar.hasShadow = true
		bar.icon:Point('RIGHT', bar, 'LEFT', -bars.barSpacing -3, 0)
	end
end
hooksecurefunc(UF, 'AuraBars_UpdateBar', mod.ApplyAuraBarShadows)

function mod:Configure_AuraBars(frame)
	local bars = frame.AuraBars
	local db = frame.db and frame.db.aurabar
	bars.db = db

	if db.enable then
		local detached = db.attachTo == 'DETACHED'
		local POWER_OFFSET, BAR_WIDTH = 0
		local BORDER = UF.BORDER + UF.SPACING

		if detached then
			BAR_WIDTH = db.detachedWidth -3
		else
			BAR_WIDTH = frame.UNIT_WIDTH -3
			if db.attachTo ~= 'FRAME' then
				POWER_OFFSET = frame.POWERBAR_OFFSET

				if frame.ORIENTATION == 'MIDDLE' then
					POWER_OFFSET = POWER_OFFSET * 2
				end
			end
		end

		bars.width = E:Scale(BAR_WIDTH - (BORDER * 4) - bars.height - POWER_OFFSET + 1)
	end
end