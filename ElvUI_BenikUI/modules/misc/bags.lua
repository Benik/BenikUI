local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Bags')
local B = E:GetModule('Bags')

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES

-- GLOBALS: hooksecurefunc

local SPACING = E.Spacing
local BORDER = E.Border

local function SellFrame()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	local elvuiVendorGraysFrame = _G.ElvUIVendorGraysFrame

	if elvuiVendorGraysFrame then
		elvuiVendorGraysFrame:BuiStyle('Outside')
	end
end
hooksecurefunc(B, "CreateSellFrame", SellFrame)

local function StyleBags()
	local elvuiContainerFrame = _G.ElvUI_ContainerFrame
	local elvuiContainerFrameContainerHolder = _G.ElvUI_ContainerFrameContainerHolder
	local elvuiBags = _G.ElvUIBags

	if elvuiContainerFrame then
		elvuiContainerFrame:BuiStyle('Outside')
	end

	if elvuiContainerFrameContainerHolder then
		elvuiContainerFrameContainerHolder:BuiStyle('Outside')
		elvuiContainerFrameContainerHolder:Point('BOTTOMLEFT', elvuiContainerFrame.style, 'TOPLEFT', 0, SPACING + BORDER)
	end

	if elvuiBags then
		elvuiBags.backdrop:BuiStyle('Outside')
		elvuiBags.backdrop:SetTemplate('Transparent')
	end
end

local function StyleBankBags()
	local elvuiBankContainerFrame = _G.ElvUI_BankContainerFrame
	if elvuiBankContainerFrame then
		elvuiBankContainerFrame:BuiStyle('Outside')
	end

	local elvuiBankContainerFrameBankTabs = _G.ElvUI_BankContainerFrameBankTabs
	if elvuiBankContainerFrameBankTabs then
		elvuiBankContainerFrameBankTabs:BuiStyle('Outside')
		elvuiBankContainerFrameBankTabs:Point('BOTTOMLEFT', elvuiBankContainerFrame.style, 'TOPLEFT', 0, SPACING + BORDER)
	end

	local elvuiBankContainerFrameWarbandTabs = _G.ElvUI_BankContainerFrameWarbandTabs
	if elvuiBankContainerFrameWarbandTabs then
		elvuiBankContainerFrameWarbandTabs:BuiStyle('Outside')
	end
end

function mod:StyleWarbandMenu(menu)
	if not menu.IsStyled then
		menu:BuiStyle('Outside')
		menu.IsStyled = true
	end
end

local function StyleAllBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i = 1, NUM_CONTAINER_FRAMES do
		local container = _G['ContainerFrame'..i]
		if container then
			container:BuiStyle('Inside')
		end
	end

	local bankFrame = _G.BankFrame
	if bankFrame then
		bankFrame:BuiStyle('Outside')
	end
end

local function StyleBagBar()
	if not E.private.bags.bagBar then return end

	local elvuiBagBar = _G.ElvUIBagBar
	elvuiBagBar.backdrop:BuiStyle('Outside')

	if not BUI.ShadowMode then return end

	local mainMenuBarBackpackButton = _G.MainMenuBarBackpackButton
	mainMenuBarBackpackButton:CreateSoftShadow()

	local buttons = B.BagBar.buttons
	for _, button in next, buttons do
		button:CreateSoftShadow()
	end
end

local function AllInOneBags()
	StyleBags()
	hooksecurefunc(B, "OpenBank", StyleBankBags)
	hooksecurefunc(B, "BankTabs_MenuSkin", mod.StyleWarbandMenu)
end

function mod:Initialize()
	if E.db.benikui.general.benikuiStyle ~= true then return end

	AllInOneBags()
	StyleAllBags()
	StyleBankBags()
	StyleBagBar()
end

BUI:RegisterModule(mod:GetName())