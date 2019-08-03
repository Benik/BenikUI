local E, L, V, P, G = unpack(ElvUI);
local BTH = E:NewModule('BuiThreat', 'AceHook-3.0');
local THREAT = E:GetModule('Threat');
local LO = E:GetModule('Layout');

-- GLOBALS: hooksecurefunc, ElvUI_ThreatBar, RightChatDataPanel, LeftChatDataPanel, BuiDummyChat, BuiDummyThreat

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

local function InitializeCallback()
	BTH:Initialize()
end

E:RegisterModule(BTH:GetName(), InitializeCallback)