local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc

local function SkinAuctionator()

	-- from ElvUI AuctionHouse skin
	local function HandleHeaders(frame)
		local maxHeaders = frame.HeaderContainer:GetNumChildren()
		for i, header in next, { frame.HeaderContainer:GetChildren() } do
			if not header.IsSkinned then
				header:DisableDrawLayer('BACKGROUND')

				if not header.backdrop then
					header:CreateBackdrop('Transparent')
				end

				header.IsSkinned = true
			end

			if header.backdrop then
				header.backdrop:Point('BOTTOMRIGHT', i < maxHeaders and -5 or 0, -2)
			end
		end
	end

	local ShoppingFrame = _G.AuctionatorShoppingFrame
	S:HandleEditBox(ShoppingFrame.SearchOptions.SearchString)
	S:HandleButton(ShoppingFrame.SearchOptions.SearchButton)
	S:HandleButton(ShoppingFrame.SearchOptions.MoreButton)
	S:HandleButton(ShoppingFrame.SearchOptions.AddToListButton)

	S:HandleButton(ShoppingFrame.NewListButton)
	S:HandleButton(ShoppingFrame.ImportButton)
	S:HandleButton(ShoppingFrame.ExportButton)
	S:HandleButton(ShoppingFrame.ExportCSV)

	S:HandleFrame(ShoppingFrame.ListsContainer)
	local ListTab = ShoppingFrame.ContainerTabs.ListsTab
	S:HandleTab(ListTab)
	ListTab:Height(26)

	S:HandleFrame(ShoppingFrame.RecentsContainer)
	local RecentsTab = ShoppingFrame.ContainerTabs.RecentsTab
	S:HandleTab(RecentsTab)
	RecentsTab:Height(26)

	S:HandleScrollBar(ShoppingFrame.ListsContainer.ScrollBar)
	S:HandleScrollBar(ShoppingFrame.RecentsContainer.ScrollBar)

	S:HandleFrame(ShoppingFrame.ShoppingResultsInset)
	S:HandleScrollBar(ShoppingFrame.ResultsListing.ScrollArea.ScrollBar)

	HandleHeaders(ShoppingFrame.ResultsListing)

	-- Extended Search Options Frame
	local ExtendedSearchOptions = _G.AuctionatorShoppingTabItemFrame
	S:HandleFrame(ExtendedSearchOptions)
	ExtendedSearchOptions:BuiStyle()
	S:HandleEditBox(ExtendedSearchOptions.SearchContainer.SearchString)
	S:HandleCheckBox(ExtendedSearchOptions.SearchContainer.IsExact)

	S:HandleEditBox(ExtendedSearchOptions.LevelRange.MinBox)
	S:HandleEditBox(ExtendedSearchOptions.LevelRange.MaxBox)
	S:HandleEditBox(ExtendedSearchOptions.ItemLevelRange.MinBox)
	S:HandleEditBox(ExtendedSearchOptions.ItemLevelRange.MaxBox)
	S:HandleEditBox(ExtendedSearchOptions.PriceRange.MinBox)
	S:HandleEditBox(ExtendedSearchOptions.PriceRange.MaxBox)
	S:HandleEditBox(ExtendedSearchOptions.CraftedLevelRange.MinBox)
	S:HandleEditBox(ExtendedSearchOptions.CraftedLevelRange.MaxBox)
	S:HandleEditBox(ExtendedSearchOptions.PurchaseQuantity.InputBox)

	S:HandleDropDownBox(ExtendedSearchOptions.FilterKeySelector.DropDown)
	ExtendedSearchOptions.FilterKeySelector.DropDown:Width(280)
	S:HandleDropDownBox(ExtendedSearchOptions.QualityContainer.DropDown.DropDown)
	S:HandleDropDownBox(ExtendedSearchOptions.ExpansionContainer.DropDown.DropDown)
	S:HandleDropDownBox(ExtendedSearchOptions.TierContainer.DropDown.DropDown)

	S:HandleButton(ExtendedSearchOptions.Cancel)
	S:HandleButton(ExtendedSearchOptions.ResetAllButton)
	S:HandleButton(ExtendedSearchOptions.Finished)

	-- Import List Frame
	local ImportListFrame = _G.AuctionatorImportListFrame
	ImportListFrame:StripTextures()
	ImportListFrame:SetTemplate("Transparent")
	ImportListFrame.Inset:SetTemplate("Transparent")
	ImportListFrame:BuiStyle()
	S:HandleTrimScrollBar(ImportListFrame.ScrollBar)
	S:HandleButton(ImportListFrame.Import)
	S:HandleCloseButton(ImportListFrame.CloseDialog)

	-- Export List Frame
	local ExportListFrame = _G.AuctionatorExportListFrame
	ExportListFrame:StripTextures()
	ExportListFrame:SetTemplate("Transparent")
	ExportListFrame.Inset:SetTemplate("Transparent")
	ExportListFrame:BuiStyle()
	S:HandleTrimScrollBar(ExportListFrame.ScrollBar)
	S:HandleButton(ExportListFrame.Export)
	S:HandleButton(ExportListFrame.SelectAll)
	S:HandleButton(ExportListFrame.UnselectAll)
	S:HandleCloseButton(ExportListFrame.CloseDialog)

	-- ExportCSV List Frame
	local CSVFrame = ShoppingFrame.exportCSVDialog
	CSVFrame:StripTextures()
	CSVFrame:SetTemplate("Transparent")
	CSVFrame.Inset:SetTemplate("Transparent")
	CSVFrame:BuiStyle()
	S:HandleButton(CSVFrame.Close)
	S:HandleTrimScrollBar(CSVFrame.ScrollBar)

	hooksecurefunc(AuctionatorBuyCommodityFrameTemplateMixin, "UpdateView", function()
		local CommodityFrame = _G.AuctionatorBuyCommodityFrame
		S:HandleFrame(CommodityFrame.Inset)
		S:HandleButton(CommodityFrame.BackButton)
		S:HandleButton(CommodityFrame.DetailsContainer.BuyButton)
		S:HandleEditBox(CommodityFrame.DetailsContainer.Quantity)
		S:HandleScrollBar(CommodityFrame.ResultsListing.ScrollArea.ScrollBar)
		HandleHeaders(CommodityFrame.ResultsListing)
	end)

	local SellingFrame = _G.AuctionatorSellingFrame
	SellingFrame.BagInset:StripTextures()

	S:HandleTrimScrollBar(SellingFrame.BagListing.View.ScrollBar)
	S:HandleFrame(SellingFrame.HistoricalPriceInset)

	HandleHeaders(SellingFrame.CurrentPricesListing)
	HandleHeaders(SellingFrame.HistoricalPriceListing)
	HandleHeaders(SellingFrame.ResultsListing)

	S:HandleTrimScrollBar(SellingFrame.CurrentPricesListing.ScrollArea.ScrollBar)
	S:HandleScrollBar(SellingFrame.HistoricalPriceListing.ScrollArea.ScrollBar)
	S:HandleScrollBar(SellingFrame.ResultsListing.ScrollArea.ScrollBar)

	for i = 1, 3 do
		S:HandleTab(_G["AuctionatorSellingFramePricesTab"..i])
	end

	hooksecurefunc(AuctionatorGroupsViewGroupMixin, "SetName", function(self)
		if self.GroupTitle then
			S:HandleFrame(self.GroupTitle, true, 'Default')
		end
	end)

	for _, child in next, {SellingFrame.AuctionatorSaleItem:GetChildren()} do
		if child.iconAtlas == 'UI-RefreshButton' then
			S:HandleButton(child)
			child:Size(24)
		end
	end

	local SellingItemFrame = SellingFrame.SaleItemFrame
	S:HandleFrame(SellingItemFrame.Icon, true, 'Default')
	S:HandleEditBox(SellingItemFrame.Quantity.InputBox)
	S:HandleEditBox(SellingItemFrame.Price.MoneyInput.GoldBox)
	S:HandleEditBox(SellingItemFrame.Price.MoneyInput.SilverBox)
	S:HandleButton(SellingItemFrame.MaxButton)
	S:HandleButton(_G.AuctionatorPostButton)

	for _, duration in next, SellingItemFrame.Duration.radioButtons do
		if duration.RadioButton then
			S:HandleRadioButton(duration.RadioButton)
		end
	end

	local CancelFrame = _G.AuctionatorCancellingFrame
	S:HandleEditBox(CancelFrame.SearchFilter)

	HandleHeaders(CancelFrame.ResultsListing)
	S:HandleFrame(CancelFrame.HistoricalPriceInset)
	S:HandleScrollBar(CancelFrame.ResultsListing.ScrollArea.ScrollBar)

	S:HandleButton(CancelFrame.UndercutScanContainer.StartScanButton)
	S:HandleButton(_G.AuctionatorCancelUndercutButton)

	local ConfigFrame = _G.AuctionatorConfigFrame
	S:HandleFrame(ConfigFrame)

	S:HandleButton(ConfigFrame.OptionsButton)
	S:HandleButton(ConfigFrame.ScanButton)

	S:HandleEditBox(ConfigFrame.ContributeLink.InputBox)
	S:HandleEditBox(ConfigFrame.DiscordLink.InputBox)
	S:HandleEditBox(ConfigFrame.BugReportLink.InputBox)

	for _, child in next, {CancelFrame:GetChildren()} do
		if child.iconAtlas == 'UI-RefreshButton' then
			S:HandleButton(child)
			child:Size(24)
		end
	end

	-- Confirmation Dialogs
	local function SkinEditBoxDialog(dialog)
		S:HandleFrame(dialog)
		dialog:BuiStyle()

		if dialog.editBox then
			S:HandleEditBox(dialog.editBox)
		end

		if dialog.acceptButton then
			S:HandleButton(dialog.acceptButton)
		end

		if dialog.cancelButton then
			S:HandleButton(dialog.cancelButton)
		end
	end

	hooksecurefunc(NineSliceUtil, "ApplyLayoutByName", function(nineSlice)
		local parent = nineSlice:GetParent()
		if parent then
			local name = parent:GetName()
			if name and name:find("^AuctionatorDialog%d+$") then
				parent:HookScript("OnShow", SkinEditBoxDialog)
			end
		end
	end)

	local tabs = {
		_G.AuctionatorTabs_Auctionator,
		_G.AuctionatorTabs_Cancelling,
		_G.AuctionatorTabs_Shopping,
		_G.AuctionatorTabs_Selling,
	}

	for _, tab in next, tabs do
		S:HandleTab(tab)
	end
end

local function LoadAuctionator()
	if not (BUI:IsAddOnEnabled('Auctionator') and E.db.benikui.skins.variousSkins.auctionator) then return end

	hooksecurefunc(_G.AuctionatorTabContainerMixin, 'OnLoad', SkinAuctionator)

	-- Checkboxes
	hooksecurefunc(_G.AuctionatorListExportFrameMixin, "RefreshLists", function(self)
		if self.checkBoxPool then
			for frame in self.checkBoxPool:EnumerateActive() do
				S:HandleCheckBox(frame.CheckBox)
			end
		end
	end)

	-- Export Text frames
	hooksecurefunc(_G.AuctionatorExportTextFrameMixin, "OnLoad", function(self)
		self:StripTextures()
		self:SetTemplate("Transparent")
		self.Inset:SetTemplate("Transparent")
		self:BuiStyle()
		S:HandleButton(self.Close)
		S:HandleTrimScrollBar(self.ScrollBar)
	end)
end
S:AddCallback("BenikUI_Auctionator", LoadAuctionator)