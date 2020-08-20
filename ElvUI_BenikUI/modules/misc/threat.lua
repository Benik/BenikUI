local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('Threat', 'AceHook-3.0');
local T = E:GetModule('Threat');
local LO = E:GetModule('Layout');

-- GLOBALS: hooksecurefunc, ElvUI_ThreatBar, RightChatDataPanel, LeftChatDataPanel, BuiDummyChat, BuiDummyThreat

function mod:UpdateThreatPosition()
	local bar = ElvUI_ThreatBar
	bar:SetStatusBarTexture(E['media'].BuiFlat)
	if E.db.general.threat.position == 'RIGHTCHAT' then
		if E.db.datatexts.rightChatPanel then
			bar:SetInside(RightChatDataPanel)
			bar:SetParent(RightChatDataPanel)
		else
			bar:SetInside(BuiDummyThreat)
			bar:SetParent(BuiDummyThreat)
		end
	else
		if E.db.datatexts.leftChatPanel then
			bar:SetInside(LeftChatDataPanel)
			bar:SetParent(LeftChatDataPanel)
		else
			bar:SetInside(BuiDummyChat)
			bar:SetParent(BuiDummyChat)
		end
	end
	bar:SetFrameStrata('MEDIUM')
end

function mod:Initialize()
	self:UpdateThreatPosition()
	hooksecurefunc(LO, 'ToggleChatPanels', mod.UpdateThreatPosition)
	hooksecurefunc(T, 'UpdatePosition', mod.UpdateThreatPosition)
end

BUI:RegisterModule(mod:GetName())