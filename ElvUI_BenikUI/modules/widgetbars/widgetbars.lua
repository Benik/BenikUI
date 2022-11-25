local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Widgetbars')
local B = E:GetModule('Blizzard')

function mod:AltPowerBar()
	if E.db.general.altPowerBar.enable ~= true then return end

	local bar = _G.ElvUI_AltPowerBar
	local db = E.db.general.altPowerBar

	bar.text:ClearAllPoints()
	if E.db.benikui.widgetbars.halfBar.altbar then
		bar:Size(db.width or 250, 5)
		bar.text:Point('BOTTOM', statusBar, 'TOP', 0, 4)
	else
		bar:Size(db.width or 250, db.height or 20)
		bar.text:Point('CENTER', statusBar, 'CENTER')
	end
end

function mod:MirrorBar()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.mirrorTimers) then return end

	local i = 1
	local frame = _G.MirrorTimer1
	while frame do
		frame.Text:ClearAllPoints()
		frame.StatusBar:ClearAllPoints()
		if E.db.benikui.widgetbars.halfBar.mirrorbar then
			frame:Height(8)
			frame.StatusBar:Height(10)
			frame.StatusBar:Point('BOTTOM', 0, -2)
			frame.Text:SetParent(frame)
			frame.Text:Point('BOTTOM', frame, 'TOP', 0, 2)
		else
			frame:Height(18)
			frame.StatusBar:Height(22)
			frame.StatusBar:Point('TOP', 0, 2)
			frame.Text:SetParent(frame.StatusBar)
			frame.Text:Point('CENTER', frame.StatusBar, 0, 1)
		end

		i = i + 1
		frame = _G['MirrorTimer'..i]
	end
end

function mod:Initialize()
	mod:LoadMaw()
	mod:AltPowerBar()
	mod:MirrorBar()
	hooksecurefunc(B, "UpdateAltPowerBarSettings", mod.AltPowerBar)
	hooksecurefunc('MirrorTimer_Show', mod.MirrorBar)
end

BUI:RegisterModule(mod:GetName())
