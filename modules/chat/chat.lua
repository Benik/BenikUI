local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule('Chat')

-- Moar font sizes in chat
E.BenikUpdateBlizzardFonts = E.UpdateBlizzardFonts
function E:UpdateBlizzardFonts()
	self:BenikUpdateBlizzardFonts()
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 10
	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
end

-- Place the new chat frame
CH.BUIUpdateAnchors = CH.UpdateAnchors
function CH:UpdateAnchors()
	self:BUIUpdateAnchors()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName..'EditBox']
		if not frame then break; end
		if E.db.datatexts.leftChatPanel and E.db.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(LeftChatDataPanel)
		else
			if BuiDummyChat then
				frame:SetAllPoints(BuiDummyChat)
			else
				frame:SetAllPoints(LeftChatTab)
			end
		end
	end

	CH:PositionChat(true)
end