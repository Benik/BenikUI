local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local next = next
local ipairs = ipairs
local hooksecurefunc = hooksecurefunc

local function RareScanner()
	if not (BUI:IsAddOnEnabled('RareScanner') and E.db.benikui.skins.variousSkins.rareScanner) then return end

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

	local Tooltips = {
		_G.LootBarToolTip,
		_G.StopTooltip,
		_G.GoTooltip,
		_G.RSMapItemToolTip,
		_G.RSMapItemToolTipComp1,
		_G.RSMapItemToolTipComp2,
		_G.RSMapInfoToolTip,
		_G.RSShoppingTooltip1,
		_G.RSShoppingTooltip2,
		_G.RareScanner_AddonCompartimentTooltip,
		_G.RSGameTooltip,
		_G.ExplorerTooltip,
	}

	for _, tt in next, Tooltips do
		if tt then
			tt:HookScript("OnShow", function(self)
				self:BuiStyle()
			end)
		end
	end

	-- Skin the WorldMap EditBox by searching for its position
	local editBoxSkinned = false

	_G.WorldMapFrame:HookScript("OnShow", function(self)
		if editBoxSkinned then return end

		local canvasContainer = self:GetCanvasContainer()
		if not canvasContainer then return end

		for _, child in ipairs({self:GetChildren()}) do
			if not child:GetName() and child:GetNumPoints() > 0 then
				local point, relativeTo, relativePoint = child:GetPoint(1)
				if point == "CENTER" and relativeTo == canvasContainer and relativePoint == "TOP" then
					for _, subChild in ipairs({child:GetChildren()}) do
						if subChild:IsObjectType("EditBox") then
							subChild:StripTextures()
							S:HandleEditBox(subChild)
							subChild.backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) -- grey border
							subChild:Height(20)

							editBoxSkinned = true
							return
						end
					end
				end
			end
		end
	end)

	-- Rare Popup Frame
	local RareScanner = _G.RARESCANNER_BUTTON
	if not RareScanner then return end

	S:HandleFrame(RareScanner)
	RareScanner:BuiStyle()

	local CloseButton = RareScanner.CloseButton
	S:HandleCloseButton(CloseButton)
	CloseButton:ClearAllPoints()
	CloseButton:Point("BOTTOMRIGHT", RareScanner, "BOTTOMRIGHT", -2, 2)
	CloseButton:Size(30)

	hooksecurefunc(RareScanner.LootBar.itemFramesPool, "Acquire", function(pool)
		for itemFrame in pool:EnumerateActive() do
			S:HandleIcon(itemFrame.Icon)
			if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
				itemFrame:CreateSoftShadow()
			end
		end
	end)

	if not E.db.benikui.general.benikuiStyle then return end

	RareScanner:HookScript("OnEnter", function(self)
		self.style:SetBackdropBorderColor(0.9, 0.9, 0.9)
	end)
	RareScanner:HookScript("OnLeave", function(self)
		self.style:SetBackdropBorderColor(0, 0, 0)
	end)
end
S:AddCallback("BenikUI_RareScanner", RareScanner)