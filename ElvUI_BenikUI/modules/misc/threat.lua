local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BTH = E:NewModule('BuiThreat', 'AceHook-3.0');
local THREAT = E:GetModule('Threat');
local LO = E:GetModule('Layout');

function BTH:UpdateThreatPosition()
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

function BTH:Initialize()
	self:UpdateThreatPosition()
	hooksecurefunc(LO, 'ToggleChatPanels', BTH.UpdateThreatPosition)
	hooksecurefunc(THREAT, 'UpdatePosition', BTH.UpdateThreatPosition)
end

E:RegisterModule(BTH:GetName())