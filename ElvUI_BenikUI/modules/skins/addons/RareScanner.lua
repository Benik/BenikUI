local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local hooksecurefunc = hooksecurefunc

local C_Timer_After = C_Timer.After

local function RareScanner()
	if not (BUI:IsAddOnEnabled('RareScanner') and E.db.benikui.skins.variousSkins.rareScanner) then return end

	local RareScanner = _G.RARESCANNER_BUTTON
	if not RareScanner then return end

	S:HandleFrame(RareScanner)
	RareScanner:BuiStyle()

	local LootBar = _G.LootBar
	LootBar:SetTemplate("Transparent")

	if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
		LootBar:CreateSoftShadow()
	end

	_G.LootBarToolTip:BuiStyle()

	hooksecurefunc(RareScanner.LootBar.itemFramesPool, "Acquire", function(pool)
		for itemFrame in pool:EnumerateActive() do
			S:HandleIcon(itemFrame.Icon)
		end
	end)

	-- Options
	local RSExplorerFrame = _G.RSExplorerFrame
	if not RSExplorerFrame then return end

	S:HandleFrame(RSExplorerFrame)
	RSExplorerFrame:BuiStyle()

	S:HandleFrame(RSExplorerFrame.RareInfo)

	local Control = RSExplorerFrame.Control
	S:HandleButton(Control.ApplyFiltersButton)
	Control.ApplyFiltersButton:CreateBackdrop()

	S:HandleCheckBox(Control.CreateProfilesBackupCheckButton)
	S:HandleCheckBox(Control.AutoFilterCheckButton)

	local Filters = _G.RSExplorerFrameFilters
	S:HandleDropDownBox(Filters.FilterDropDown)
	S:HandleDropDownBox(Filters.ContinentDropDown)
	S:HandleCheckBox(Filters.LockCurrentZoneCheckButton)
	S:HandleButton(Filters.RestartScanningButton)
	Filters.RestartScanningButton:CreateBackdrop()

	local RareList = _G.RSExplorerFrameRareList
	RareList:SetTemplate("Transparent")
	S:HandleTrimScrollBar(RareList.scrollBar)

	hooksecurefunc(RSExplorerFrame, "ShowCustomLootPanels", function(self)
		local customLootFrame = self.CustomLoot
		if customLootFrame.isSkinned then return end

		S:HandleFrame(customLootFrame)

		S:HandleDropDownBox(customLootFrame.ControlFrame.LootGroupDropDown)

		S:HandleButton(customLootFrame.GroupInfo.DeleteGroup)
		customLootFrame.GroupInfo.DeleteGroup:Height(20)
		customLootFrame.GroupInfo.DeleteGroup:Point("LEFT", customLootFrame.GroupInfo.EditGroupName, "RIGHT", 10, 0)

		S:HandleEditBox(customLootFrame.GroupInfo.EditGroupName)
		customLootFrame.GroupInfo.EditGroupName:Height(20)

		S:HandleEditBox(customLootFrame.ControlFrame.NewGroup)
		customLootFrame.ControlFrame.NewGroup:Height(20)
		customLootFrame.ControlFrame.NewGroup:Point("TOPLEFT", customLootFrame.ControlFrame.LootNewGroupLabel, "BOTTOMLEFT", 0, -4)

		S:HandleEditBox(customLootFrame.ControlFrame.ItemList)
		customLootFrame.ControlFrame.ItemList:Height(20)
		customLootFrame.ControlFrame.ItemList:Point("TOPLEFT", customLootFrame.ControlFrame.ItemListLabel, "BOTTOMLEFT", 0, -4)

		S:HandleButton(self.ScanRequired.StartScanningButton)
		self.ScanRequired.StartScanningButton:CreateBackdrop("Default")

		S:HandleTrimScrollBar(customLootFrame.GroupList.scrollBar)

		customLootFrame.isSkinned = true
	end)

end
S:AddCallback("BenikUI_RareScanner", RareScanner)