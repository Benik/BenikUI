local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')

-- Place the new chat frame
CH.BUIUpdateAnchors = CH.UpdateAnchors
function CH:UpdateAnchors()
	self:BUIUpdateAnchors()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName..'EditBox']
		if not frame then break; end
		if E.db.datatexts.leftChatPanel and E.db.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(LeftChatDataPanel)
		elseif E.db.bui.buiDts and BuiDummyChat and E.db.bui.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(BuiDummyChat)
		else
			frame:SetAllPoints(LeftChatTab)
		end
	end

	CH:PositionChat(true)
end