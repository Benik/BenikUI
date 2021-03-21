local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Widgetbars')

--[[function mod:AltPowerBar()
	if E.db.general.altPowerBar.enable ~= true or E.db.benikuiWidgetbars.altBar.enable ~= true then
		return
	end

	local bar = _G.ElvUI_AltPowerBar
	
	if bar.textures then
		bar:StripTextures(true)
	end

	if E.db.benikui.general.benikuiStyle then
		bar.backdrop:BuiStyle("Outside")
	end
end]]

function mod:MirrorBar()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mirrorTimers ~= true then return end

	for i = 1, _G.MIRRORTIMER_NUMTIMERS do
		local mirrorTimer = _G['MirrorTimer'..i]
		local statusBar = _G['MirrorTimer'..i..'StatusBar']

		mirrorTimer.TimerText:ClearAllPoints()
		if E.db.benikuiWidgetbars.halfBar.mirrorbar then
			mirrorTimer:Size(222, 24)
			statusBar:Size(222, 5)
			mirrorTimer.TimerText:Point('BOTTOM', statusBar, 'TOP', 0, 4)
		else
			mirrorTimer:Size(222, 18)
			statusBar:Size(222, 18)
			mirrorTimer.TimerText:Point('CENTER', statusBar, 'CENTER')
		end
	end
end

function mod:Initialize()
	mod:LoadMaw()
	--mod:AltPowerBar()
	mod:MirrorBar()
end

BUI:RegisterModule(mod:GetName())