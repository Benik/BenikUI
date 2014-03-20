local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local THREAT = E:GetModule('Threat')

E.Threat = THREAT

THREAT.BuiUpdatePosition = THREAT.UpdatePosition
function THREAT:UpdatePosition()
	self:BuiUpdatePosition()
	if self.db.position == 'RIGHTCHAT' then
		self.bar:SetInside(BuiDummyThreat)
		self.bar:SetParent(BuiDummyThreat)
		self.bar:HookScript('OnShow', function(self)
			BuiRightChatDTPanel:Hide()
		end)
		self.bar:HookScript('OnHide', function(self)
			BuiRightChatDTPanel:Show()
		end)
	else
		self.bar:SetInside(BuiDummyChat)
		self.bar:SetParent(BuiDummyChat)	
	end
	
	self.bar.text:FontTemplate(nil, self.db.textSize)
	self.bar:SetFrameStrata('MEDIUM')
end
