local E, L, V, P, G = unpack(ElvUI);
local BTH = E:NewModule('BuiThreat', 'AceHook-3.0');
local THREAT = E:GetModule('Threat');
local LO = E:GetModule('Layout');

local _G = _G

-- GLOBALS: hooksecurefunc

function BTH:UpdateThreatPosition()
	local bar = _G["ElvUI_ThreatBar"]
	bar:SetStatusBarTexture(E['media'].BuiFlat)
	if E.db.general.threat.position == 'RIGHTCHAT' then
		if E.db.datatexts.rightChatPanel then
			bar:SetInside(_G["RightChatDataPanel"])
			bar:SetParent(_G["RightChatDataPanel"])
		else
			bar:SetInside(_G["BuiDummyThreat"])
			bar:SetParent(_G["BuiDummyThreat"])
		end
	else
		if E.db.datatexts.leftChatPanel then
			bar:SetInside(_G["LeftChatDataPanel"])
			bar:SetParent(_G["LeftChatDataPanel"])
		else
			bar:SetInside(_G["BuiDummyChat"])
			bar:SetParent(_G["BuiDummyChat"])
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