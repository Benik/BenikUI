local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function BugSack()
	if not (BUI:IsAddOnEnabled('BugSack') and E.db.benikui.skins.variousSkins.bugSack) then return end

	local BugSack = _G.BugSack
	if not BugSack then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if _G.BugSackFrame.IsSkinned then return end

		local frame = _G.BugSackFrame
		S:HandleFrame(frame)

		local tabs = { _G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast }
		for _, tab in next, tabs do
			S:HandleTab(tab)
			if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
				tab.backdrop:CreateSoftShadow()
			end
		end

		_G.BugSackTabAll:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")

		local buttons = { _G.BugSackNextButton, _G.BugSackSendButton, _G.BugSackPrevButton }
		for _, button in next, buttons do
			S:HandleButton(button)
		end

		S:HandleScrollBar(_G.BugSackScrollScrollBar)
			if not frame.style then
				frame:BuiStyle()
			end

		for _, child in pairs({frame:GetChildren()}) do
			if (child:IsObjectType('Button') and child:GetScript('OnClick') == BugSack.CloseSack) then
				S:HandleCloseButton(child)
				break
			end
		end
		_G.BugSackFrame.IsSkinned = true
	end)
end
S:AddCallback("BenikUI_BugSackSkin", BugSack)