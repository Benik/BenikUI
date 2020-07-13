local BUI, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local mod = BUI:NewModule('DataTexts', 'AceEvent-3.0');

function mod:BuildPanelFrame(name, db)
	db = db or E.global.datatexts.customPanels[name] or DT:Panel_DefaultGlobalSettings(name)

	local Panel = DT:FetchFrame(name)
	Panel:Style('Outside')
end

function mod:UpdatePanelInfo(panelName, panel, ...)
	if not panel then panel = DT.RegisteredPanels[panelName] end
	local db = panel.db or P.datatexts.panels[panelName] and DT.db.panels[panelName]
	if not db then return end
	
	-- don't mess with LocationPlus
	local locPanel = BUI.LP and panelName == 'LocPlusLeftDT' or panelName == 'LocPlusRightDT'

	if not locPanel then
		panel:Style('Outside')
		if db.benikuiStyle then
			if panel.style then
				panel.style:Show()
			else
				panel.style:Hide()
			end
		end
		
		if BUI.ShadowMode then
			if not (db.border and db.backdrop or db.backdrop) then
				panel.shadow:Hide()
			else
				panel.shadow:Show()
			end
		end
	end
end

function mod:SetupTooltip(panel)
	DT.tooltip:Style('Outside')
end

function mod:Initialize()
	hooksecurefunc(DT, "BuildPanelFrame", mod.BuildPanelFrame)
	hooksecurefunc(DT, "UpdatePanelInfo", mod.UpdatePanelInfo)
	hooksecurefunc(DT, "SetupTooltip", mod.SetupTooltip)
end

BUI:RegisterModule(mod:GetName())