local BUI, E, L, V, P, G = unpack((select(2, ...)))
local CH = E:GetModule('Chat')
local BL = BUI:GetModule('Layout')
local mod = BUI:GetModule('Chat')

local _G = _G
local pairs, tinsert = pairs, table.insert
local hooksecurefunc = hooksecurefunc

function mod:UpdateEditboxAnchors()
	E.db.benikui = E.db.benikui or {}
	E.db.benikui.datatexts = E.db.benikui.datatexts or {}
	E.db.benikui.datatexts.chat = E.db.benikui.datatexts.chat or {}

	if E.db.benikui.datatexts.chat.enable ~= true then return end

	for _, frameName in pairs(_G.CHAT_FRAMES) do
		local frame = _G[frameName..'EditBox']
		if not frame then break; end
		frame:ClearAllPoints()
		if E.db.datatexts.leftChatPanel and E.db.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(_G.LeftChatDataPanel)
		elseif E.db.benikui.datatexts.chat.enable and _G.BuiDummyChat and E.db.benikui.datatexts.chat.editBoxPosition == 'BELOW_CHAT' then
			frame:SetAllPoints(_G.BuiDummyChat)
		elseif E.db.datatexts.panels.BuiMiddleDTPanel.enable and E.db.benikui.datatexts.chat.editBoxPosition == 'MIDDLE_DT' then
			local dt = E.DataTexts:FetchFrame("BuiMiddleDTPanel")
			frame:SetAllPoints(dt)
		elseif E.ActionBars.Initialized and E.db.actionbar.bar1.backdrop == true and E.db.benikui.datatexts.chat.editBoxPosition == 'EAB_1' then
			BL:PositionEditBoxHolder(_G.ElvUI_Bar1)
			frame:SetAllPoints(_G.BuiDummyEditBoxHolder)
		elseif E.ActionBars.Initialized and E.db.actionbar.bar2.backdrop == true and E.db.benikui.datatexts.chat.editBoxPosition == 'EAB_2' then
			BL:PositionEditBoxHolder(_G.ElvUI_Bar2)
			frame:SetAllPoints(_G.BuiDummyEditBoxHolder)
		else
			frame:SetAllPoints(_G.LeftChatTab)
		end
	end
end

function mod:ToggleChatStyle()
	if not E.db.benikui.general.benikuiStyle then return end
	local db = E.db.chat.benikuiStyle
	_G.LeftChatPanel.backdrop.style:SetShown(db)
	_G.RightChatPanel.backdrop.style:SetShown(db)
end

local function InjectChatPanelOption()
	E.Options.args.chat.args.panels.args.panels.args.benikuiStyle = {
		order = -1,
		type = "toggle",
		name = BUI:cOption(L['BenikUI Style'], "blue"),
		disabled = function() return not E.private.chat.enable or not E.db.benikui.general.benikuiStyle end,
		get = function() return E.db.chat.benikuiStyle end,
		set = function(_, value) E.db.chat.benikuiStyle = value; mod:ToggleChatStyle(); end,
	}
end
tinsert(BUI.Config, InjectChatPanelOption)

function mod:Initialize()
	mod:UpdateEditboxAnchors()
	mod:ToggleChatStyle()

	hooksecurefunc(CH, "UpdateEditboxAnchors", mod.UpdateEditboxAnchors)
end

BUI:RegisterModule(mod:GetName())