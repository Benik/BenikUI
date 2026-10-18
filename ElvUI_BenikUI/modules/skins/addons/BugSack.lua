local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local select = select

local function SkinBugSack()
	if _G.BugSackFrame.IsSkinned then return end

	local frame = _G.BugSackFrame
	S:HandleFrame(frame)
	
	local function BSOptions(options)
		for _, child in next, { options:GetChildren() } do
			if child:IsObjectType('CheckButton') then
				S:HandleCheckBox(child)
			else
				for _, dropdown in next, { child:GetChildren() } do
					if dropdown.SetupMenu then
						S:HandleDropDownBox(dropdown, dropdown:GetWidth())
					end
				end
			end
		end
	end

	local tabs = { _G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast, _G.BugSackTabOptions }

	for _, tab in next, tabs do
		S:HandleTab(tab)
		if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
			tab.backdrop:CreateSoftShadow()
		end
	end

	_G.BugSackTabAll:ClearAllPoints()
	_G.BugSackTabAll:Point("TOPLEFT", frame, "BOTTOMLEFT")

	local buttons = { _G.BugSackNextButton, _G.BugSackSendButton, _G.BugSackPrevButton, _G.BugSackWipeButton }
	for _, button in next, buttons do
		S:HandleButton(button, nil, nil, nil, true)
	end

	local scrollArea = _G.BugSackScrollText:GetParent()
	if E.Modern then
		S:HandleTrimScrollBar(scrollArea.ScrollBar)
 	else -- classics uses old template
 		S:HandleScollBar(scrollArea.ScrollBar)
 	end
	if not frame.style then
		frame:BuiStyle()
	end
	
	local BugSack = _G.BugSack
	for _, child in ipairs({ frame:GetChildren() }) do
		if child:IsObjectType('Button') and child:GetScript('OnClick') == BugSack.CloseSack then
			S:HandleCloseButton(child) -- skin close button for classic
		elseif select(2, child:GetPoint()) == scrollArea then
			BSOptions(child)
		end
	end
	_G.BugSackFrame.IsSkinned = true
end

local function BugSack()
	if not (BUI:IsAddOnEnabled('BugSack') and E.db.benikui.skins.variousSkins.bugSack) then
		return
	end

	local BugSack = _G.BugSack
	if BugSack then 
		hooksecurefunc(BugSack, 'OpenSack', SkinBugSack)
		if BugSack.OpenConfig then
			hooksecurefunc(BugSack, 'OpenConfig', SkinBugSack)
		end
	end
end

S:AddCallbackForAddon("BugSack", "BenikUI_BugSack", BugSack)