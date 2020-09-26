local BUI, E, L, V, P, G = unpack(select(2, ...))
local CH = E:GetModule('Chat')
local BL = BUI:GetModule('Layout')
local FM = BUI:GetModule('FlightMode')
local mod = BUI:GetModule('Chat')

local _G = _G
local pairs = pairs
local format = string.format
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

local GetChatWindowSavedPosition = GetChatWindowSavedPosition
local InCombatLockdown = InCombatLockdown
local IsMouseButtonDown = IsMouseButtonDown

-- GLOBALS: CHAT_FRAMES, RightChatDataPanel, LeftChatDataPanel, BuiDummyChat, RightChatPanel, LeftChatPanel, LeftChatTab

-- Place the new chat frame
function mod:UpdateEditboxAnchors()
	if E.db.benikui.datatexts.chat.enable ~= true then return end
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName..'EditBox']
		if not frame then break; end
		frame:ClearAllPoints()
		if E.db.datatexts.leftChatPanel and E.db.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(LeftChatDataPanel)
		elseif E.db.benikui.datatexts.chat.enable and BuiDummyChat and E.db.benikui.datatexts.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(BuiDummyChat)
		elseif E.db.datatexts.panels.BuiMiddleDTPanel.enable and E.db.benikui.datatexts.chat.editBoxPosition == 'MIDDLE_DT' then
			local dt = E.DataTexts:FetchFrame("BuiMiddleDTPanel")
			frame:SetAllPoints(dt)
		elseif E.ActionBars.Initialized and E.db.actionbar.bar1.backdrop == true and E.db.benikui.datatexts.chat.editBoxPosition == 'EAB_1' then
			BL:PositionEditBoxHolder(ElvUI_Bar1)
			frame:SetAllPoints(BuiDummyEditBoxHolder)
		elseif E.ActionBars.Initialized and E.db.actionbar.bar2.backdrop == true and E.db.benikui.datatexts.chat.editBoxPosition == 'EAB_2' then
			BL:PositionEditBoxHolder(ElvUI_Bar2)
			frame:SetAllPoints(BuiDummyEditBoxHolder)
		else
			frame:SetAllPoints(LeftChatTab)
		end
	end
end

local CreatedFrames = 0;

local function Style(self, frame)
	CreatedFrames = frame:GetID()
end

--Replacement of chat tab position and size function
local PixelOff = E.PixelMode and 33 or 27

local function PositionChat(self, override)
	if ((InCombatLockdown() and not override and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then return end
	if not RightChatPanel or not LeftChatPanel then return; end
	if E.private.chat.enable ~= true then return end
	if not E.db.benikui.datatexts.chat.enable then return end

	local BASE_OFFSET = 60
	if E.PixelMode then
		BASE_OFFSET = BASE_OFFSET - 3
	end
	local chat, id, tab, isDocked, point
	for i=1, CreatedFrames do
		chat = _G[format("ChatFrame%d", i)]
		id = chat:GetID()
		tab = _G[format("ChatFrame%sTab", i)]
		point = GetChatWindowSavedPosition(id)
		isDocked = chat.isDocked
		tab.flashTab = true

		if chat:IsShown() and not (id > NUM_CHAT_WINDOWS) and id == CH.RightChatWindowID then
			chat:ClearAllPoints()
			if E.db.datatexts.rightChatPanel then
				chat:Point("BOTTOMRIGHT", RightChatDataPanel, "TOPRIGHT", 10, 3)
			else
				BASE_OFFSET = BASE_OFFSET - 24
				chat:Point("BOTTOMLEFT", RightChatPanel, "BOTTOMLEFT", 4, 4)
			end
			if id ~= 2 then
				chat:Size((E.db.chat.separateSizes and E.db.chat.panelWidthRight or E.db.chat.panelWidth) - 10, ((E.db.chat.separateSizes and E.db.chat.panelHeightRight or E.db.chat.panelHeight) - PixelOff))
			end
		elseif not isDocked and chat:IsShown() then
			if FM.inFlightMode == true then
				chat:SetAlpha(0)
			else
				chat:SetAlpha(1)
			end
		else
			if id ~= 2 and not (id > NUM_CHAT_WINDOWS) then
				BASE_OFFSET = BASE_OFFSET - 24
				chat:Point("BOTTOMLEFT", LeftChatPanel, "BOTTOMLEFT", 4, 4)
				chat:Size(E.db.chat.panelWidth - 10, E.db.chat.panelHeight - PixelOff)
			end
		end
	end
end

function mod:Initialize()
	mod.UpdateEditboxAnchors()
	hooksecurefunc(CH, "PositionChats", PositionChat)
	hooksecurefunc(CH, "UpdateEditboxAnchors", mod.UpdateEditboxAnchors)
	hooksecurefunc(CH, "StyleChat", Style)
	hooksecurefunc(FM, "SetFlightMode", PositionChat)
end

BUI:RegisterModule(mod:GetName())