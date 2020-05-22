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

	local info = DT.LoadedInfo
	local font, fontSize, fontOutline = info.font, info.fontSize, info.fontOutline
	if db and db.fonts and db.fonts.enable then
		font, fontSize, fontOutline = LSM:Fetch('font', db.fonts.font), db.fonts.fontSize, db.fonts.fontOutline
	end

	local chatPanel = panelName == 'LeftChatDataPanel' or panelName == 'RightChatDataPanel' or panelName == 'BuiLeftChatDTPanel' or panelName == 'BuiRightChatDTPanel'
	local battlePanel = info.isInBattle and chatPanel and (not DT.ForceHideBGStats and E.db.datatexts.battleground)
	if battlePanel then
		DT:RegisterEvent('UPDATE_BATTLEFIELD_SCORE')
		DT.ShowingBattleStats = info.instanceType
	elseif chatPanel and DT.ShowingBattleStats then
		DT:UnregisterEvent('UPDATE_BATTLEFIELD_SCORE')
		DT.ShowingBattleStats = nil
	end
	
	-- don't mess with LocationPlus
	local locPanel = BUI.LP and panelName == 'LocPlusLeftDT' or panelName == 'LocPlusRightDT'

	if not locPanel then
		panel:Style('Outside')
		if panel.style and db.benikuiStyle then
			panel.style:Show()
		else
			panel.style:Hide()
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