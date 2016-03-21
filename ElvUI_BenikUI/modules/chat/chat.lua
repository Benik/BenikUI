local E, L, V, P, G = unpack(ElvUI);
local CH = E:GetModule('Chat')

local _G = _G
local format = format
local pairs = pairs

local GetChatWindowSavedPosition = GetChatWindowSavedPosition
local InCombatLockdown = InCombatLockdown
local IsMouseButtonDown = IsMouseButtonDown

-- GLOBALS: CHAT_FRAMES, CreatedFrames, tab, NUM_CHAT_WINDOWS

-- Place the new chat frame
CH.BUIUpdateAnchors = CH.UpdateAnchors
function CH:UpdateAnchors()
	self:BUIUpdateAnchors()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName..'EditBox']
		if not frame then break; end
		if E.db.datatexts.leftChatPanel and E.db.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(_G["LeftChatDataPanel"])
		elseif E.db.benikui.datatexts.chat.enable and _G["BuiDummyChat"] and E.db.benikui.datatexts.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(_G["BuiDummyChat"])
		else
			frame:SetAllPoints(_G["LeftChatTab"])
		end
	
		frame:SetScript('OnShow', function(self)
			E:UIFrameFadeIn(self, .5, 0, 1)
		end)
	end

	CH:PositionChat(true)
end

-- Stolen from S&L :D
local function Style(self, frame)
	CreatedFrames = frame:GetID()
end

--Replacement of chat tab position and size function
local PixelOff = E.PixelMode and 33 or 27

local function PositionChat(self, override, noSave)
	if ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end
	if not _G["RightChatPanel"] or not _G["LeftChatPanel"] then return; end
	if not self.db.lockPositions or E.private.chat.enable ~= true then return end
	if not E.db.benikui.datatexts.chat.styled then return end
	
	local BASE_OFFSET = 60
	if E.PixelMode then
		BASE_OFFSET = BASE_OFFSET - 3
	end	
	local chat, id, isDocked, point
	for i=1, CreatedFrames do
		chat = _G[format("ChatFrame%d", i)]
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked

		if chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == CH.RightChatWindowID then
			chat:ClearAllPoints()
			if E.db.datatexts.rightChatPanel then
				chat:Point("BOTTOMRIGHT", _G["RightChatDataPanel"], "TOPRIGHT", 10, 3)
			else
				BASE_OFFSET = BASE_OFFSET - 24
				chat:SetPoint("BOTTOMLEFT", _G["RightChatPanel"], "BOTTOMLEFT", 4, 4)
			end
			if id ~= 2 then
				chat:Size((E.db.chat.separateSizes and E.db.chat.panelWidthRight or E.db.chat.panelWidth) - 10, ((E.db.chat.separateSizes and E.db.chat.panelHeightRight or E.db.chat.panelHeight) - PixelOff))
			end
		elseif not isDocked and chat:IsShown() then
		
		else
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				BASE_OFFSET = BASE_OFFSET - 24
				chat:SetPoint("BOTTOMLEFT", _G["LeftChatPanel"], "BOTTOMLEFT", 4, 4)
				chat:Size(E.db.chat.panelWidth - 10, E.db.chat.panelHeight - PixelOff)
			end
		end
	end
end

hooksecurefunc(CH, "PositionChat", PositionChat)
hooksecurefunc(CH, "StyleChat", Style)