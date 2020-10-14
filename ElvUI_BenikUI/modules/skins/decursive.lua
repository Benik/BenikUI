local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins')

local SPACING = (E.PixelMode and 1 or 3)

local function LoadSkin()
	-- Main Buttons
	_G.DecursiveMainBar:StripTextures()
	_G.DecursiveMainBar:SetTemplate("Default", true)
	_G.DecursiveMainBar:Height(20)

	local mainButtons = {_G.DecursiveMainBarPriority, _G.DecursiveMainBarSkip, _G.DecursiveMainBarHide}
	for i, button in pairs(mainButtons) do
		S:HandleButton(button)
		button:SetTemplate("Default", true)
		button:ClearAllPoints()
		if (i == 1) then
			button:Point("LEFT", _G.DecursiveMainBar, "RIGHT", SPACING, 0)
		else
			button:Point("LEFT", mainButtons[i - 1], "RIGHT", SPACING, 0)
		end
	end

	-- Priority List Frame
	_G.DecursivePriorityListFrame:StripTextures()
	_G.DecursivePriorityListFrame:CreateBackdrop("Transparent")
	_G.DecursivePriorityListFrame.backdrop:Style("Outside")

	local priorityButton = {
		_G.DecursivePriorityListFrameAdd,
		_G.DecursivePriorityListFramePopulate,
		_G.DecursivePriorityListFrameClear,
		_G.DecursivePriorityListFrameClose
	}
	for i, button in pairs(priorityButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if (i == 1) then
			button:Point("TOP", _G.DecursivePriorityListFrame, "TOPLEFT", 54, -20)
		else
			button:Point("LEFT", priorityButton[i - 1], "RIGHT", SPACING, 0)
		end
	end

	_G.DecursivePopulateListFrame:StripTextures()
	_G.DecursivePopulateListFrame:CreateBackdrop("Transparent")
	_G.DecursivePopulateListFrame.backdrop:Style("Outside")

	for i = 1, 8 do
		local groupButton = _G['DecursivePopulateListFrameGroup'..i]
		S:HandleButton(groupButton)
	end

	local classPop = {
		"Warrior",
		"Priest",
		"Mage",
		"Warlock",
		"Hunter",
		"Rogue",
		"Druid",
		"Shaman",
		"Monk",
		"Paladin",
		"Deathknight",
		"Close"
	}
	for _, classBtn in pairs(classPop) do
		local btnName = _G['DecursivePopulateListFrame' .. classBtn]
		S:HandleButton(btnName)
	end

	-- Skip List Frame
	_G.DecursiveSkipListFrame:StripTextures()
	_G.DecursiveSkipListFrame:CreateBackdrop("Transparent")
	_G.DecursiveSkipListFrame.backdrop:Style("Outside")

	local skipButton = {
		_G.DecursiveSkipListFrameAdd,
		_G.DecursiveSkipListFramePopulate,
		_G.DecursiveSkipListFrameClear,
		_G.DecursiveSkipListFrameClose
	}
	for i, button in pairs(skipButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if (i == 1) then
			button:Point("TOP", _G.DecursiveSkipListFrame, "TOPLEFT", 54, -20)
		else
			button:Point("LEFT", skipButton[i - 1], "RIGHT", SPACING, 0)
		end
	end

	-- Tooltip
	if E.private.skins.blizzard.tooltip then
		_G.DcrDisplay_Tooltip:StripTextures()
		_G.DcrDisplay_Tooltip:CreateBackdrop("Transparent")
		_G.DcrDisplay_Tooltip.backdrop:Style("Outside")
	end
end

function mod:SkinDecursive()
	if not IsAddOnLoaded("Decursive") or E.db.benikuiSkins.variousSkins.decursive ~= true then
		return
	end
	LoadSkin()
end