local BUI, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local mod = BUI:GetModule('DataTexts')

function mod:BuildPanelFrame(name)
	local Panel = DT:FetchFrame(name)
	Panel:BuiStyle('Outside')
end

function mod:UpdatePanelInfo(panelName, panel, ...)
	if not panel then panel = DT.RegisteredPanels[panelName] end
	local db = panel.db or P.datatexts.panels[panelName] and DT.db.panels[panelName]
	if not db then return end

	if not (panel == _G.LocPlusLeftDT or panel == _G.LocPlusRightDT or panel == _G.MinimapPanel or panel == _G.LeftChatDataPanel or panel == _G.RightChatDataPanel) then
		panel:BuiStyle('Outside')
		if panel.style then
			panel.style:SetShown(db.benikuiStyle)
		end

		if BUI.ShadowMode then
			panel.shadow:SetShown((db.border and db.backdrop or db.backdrop))
		end
	end
end

function mod:SetupTooltip()
	DT.tooltip:BuiStyle('Outside')
end

function mod:Initialize()
	hooksecurefunc(DT, "BuildPanelFrame", mod.BuildPanelFrame)
	hooksecurefunc(DT, "UpdatePanelInfo", mod.UpdatePanelInfo)
	hooksecurefunc(DT, "SetupTooltip", mod.SetupTooltip)
end

BUI:RegisterModule(mod:GetName())
