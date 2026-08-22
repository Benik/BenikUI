local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local next = next
local ipairs = ipairs

local C_Timer_After = C_Timer.After

local function ClassCodex()
	if not (BUI:IsAddOnEnabled('ClassCodex') and E.db.benikui.skins.variousSkins.classCodex) then return end

	local shadowsEnabled = E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows
	local frame = _G.ClassCodexPanel
	if not frame then return end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	frame:BuiStyle()

	local loadoutDock = _G.ClassCodexLoadoutDock
	if loadoutDock then
		loadoutDock:StripTextures()
		loadoutDock:SetTemplate("Transparent")
		if shadowsEnabled then
			loadoutDock:CreateSoftShadow()
		end
	end

	-- Close button
	S:HandleCloseButton(_G.ClassCodexPanelCloseButton)

	local dropDowns = {
		_G.ClassCodexHeroDropdown,
		_G.ClassCodexRotCtxDropdown,
		_G.ClassCodexDockEnhancementsSourceDropdown,
		_G.ClassCodexStatTargetCtxDropdown,
		_G.ClassCodexTrinketCtxDropdown,
		_G.ClassCodexAllTalentSourceDropdown,
		_G.ClassCodexBisSourceDropdown,
	}
	for _, dropDown in next, dropDowns do
		if dropDown then
			S:HandleDropDownBox(dropDown)
		end
	end

	-- tabs
	-- not global

	local function ApplySkin()
		local compendium = _G["ClassCodexCompendium"]
		if not compendium then
			C_Timer_After(0.1, ApplySkin)
			return
		end

		if compendium.isSkinned then return end

		compendium:StripTextures()
		compendium:SetTemplate("Transparent")
		compendium:BuiStyle()

		_G.ClassCodexCompendiumPortrait:Hide()

		S:HandleCloseButton(_G.ClassCodexCompendiumCloseButton)

		local compendiumDropDowns = {
			_G.ClassCodexCompHeroDD,
			_G.ClassCodexCompClassDD,
			_G.ClassCodexCompSpecDD,
			_G.ClassCodexCompendiumTalentSourceDropdown,
			_G.ClassCodexCompEnhancementsSourceDD,
		}
		for _, dropDown in ipairs(compendiumDropDowns) do
			if dropDown then
				S:HandleDropDownBox(dropDown)
			end
		end

		for i = 1, 6 do
			local tab = _G["ClassCodexCompendiumTab"..i]
			if tab then
				S:HandleTab(tab)
				if shadowsEnabled then
					tab.backdrop:CreateSoftShadow()
				end
				if i == 1 then
					tab:Point("BOTTOMLEFT", compendium, "BOTTOMLEFT", 15, -32)
				end
			end
		end

		compendium.isSkinned = true
	end
	-- add another delay. The compendium is lazy
	C_Timer_After(0.1, ApplySkin)
end
S:AddCallbackForAddon("ClassCodex", "BenikUI_ClassCodex", ClassCodex)