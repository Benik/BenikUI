local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Widgetbars')
local B = E:GetModule('Blizzard')
local _G = _G

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

local function SetupTimer(container, timer)
	local bar = container:GetAvailableTimer(timer)
	if not bar then return end

	if E.private.skins.blizzard.enable and E.private.skins.blizzard.mirrorTimers then
		if E.db.benikui.widgetbars.halfBar.mirrorbar then
			bar:Height(8)
			bar.StatusBar:Height(10)
			bar.StatusBar:Point('BOTTOM', 0, -2)
			bar.Text:SetParent(bar)
			bar.Text:Point('BOTTOM', bar, 'TOP', 0, 2)
		else
			bar:Height(18)
			bar.StatusBar:Height(22)
			bar.StatusBar:Point('TOP', 0, 2)
			bar.Text:SetParent(bar.StatusBar)
			bar.Text:Point('CENTER', bar.StatusBar, 0, 1)
		end

		if not bar.shadow then
			bar:CreateSoftShadow()
		end
	end
end

function mod:Initialize()
	mod:LoadMaw()
	mod:AltPowerBar()
	hooksecurefunc(B, "UpdateAltPowerBarSettings", mod.AltPowerBar)
	hooksecurefunc(_G.MirrorTimerContainer, 'SetupTimer', SetupTimer)
end

BUI:RegisterModule(mod:GetName())
