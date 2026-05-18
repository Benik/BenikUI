local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
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

	local function HuntCloseButton(parent)
		for _, child in ipairs({parent:GetChildren()}) do
			if child:IsObjectType("Button") then
				local width, height = child:GetSize()
				if math.floor(width) == 20 and math.floor(height) == 20 then -- size is 20
					local point = child:GetPoint(1)
					if point == "RIGHT" then -- and pointed right
						return child
					end
				end
			end
			-- search deeper
			if child:GetNumChildren() > 0 then
				local found = HuntCloseButton(child)
				if found then return found end
			end
		end
		return nil
	end

	local closeBtn = HuntCloseButton(frame)
	if closeBtn then
		S:HandleCloseButton(closeBtn)
	end

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
	frame:HookScript("OnShow", function(self)
		for _, child in ipairs({self:GetChildren()}) do
			if child.IsObjectType and child:IsObjectType("Button") then
				child:SetTemplate("Transparent")
				child:Size(24)
				if child.border then print("hasborder") end
				S:HandleIcon(child.icon, false)
				if shadowsEnabled then
					child:CreateSoftShadow()
				end
			end
		end
	end)

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
			_G.ClassCodexCompStatCtxDD,
			_G.ClassCodexCompBisSourceDD,
			_G.ClassCodexCompBisTabDD,
			_G.ClassCodexCompTrinketCtxDD,
			_G.ClassCodexCompendiumTalentSourceDropdown,
			_G.ClassCodexCompEnhancementsSourceDD,
		}
		for _, dropDown in ipairs(compendiumDropDowns) do
			S:HandleDropDownBox(dropDown)
		end
		_G.ClassCodexCompHeroDD:Point("TOPRIGHT", compendium, "TOPRIGHT", -30, -28)

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

		S:HandleScrollBar(_G.ClassCodexCompendiumScrollScrollBar)
		compendium.isSkinned = true
	end
	-- add another delay. The compendium is lazy
	C_Timer_After(0.1, ApplySkin)
end
S:AddCallback("BenikUI_ClassCodex", ClassCodex)