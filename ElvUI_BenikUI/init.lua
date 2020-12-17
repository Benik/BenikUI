local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, Engine = ...

local BUI = E.Libs.AceAddon:NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

Engine[1] = BUI
Engine[2] = E
Engine[3] = L
Engine[4] = V
Engine[5] = P
Engine[6] = G
_G[addon] = Engine

BUI.Config = {}
BUI.Title = format('|cffffa500%s|r|cffffffff%s|r ', 'Benik', 'UI')
BUI["RegisteredModules"] = {}
BUI.Eversion = tonumber(E.version)
BUI.Erelease = tonumber(GetAddOnMetadata("ElvUI_BenikUI", "X-ElvuiVersion"))

BUI.Actionbars = BUI:NewModule('Actionbars', 'AceEvent-3.0')
BUI.Bags = BUI:NewModule('Bags', 'AceHook-3.0', 'AceEvent-3.0')
BUI.Chat = BUI:NewModule('Chat', 'AceHook-3.0', 'AceEvent-3.0')
BUI.CustomPanels = BUI:NewModule('CustomPanels', 'AceEvent-3.0')
BUI.Dashboards = BUI:NewModule('Dashboards', 'AceEvent-3.0', 'AceHook-3.0')
BUI.Databars = BUI:NewModule('Databars', 'AceHook-3.0', 'AceEvent-3.0')
BUI.DataTexts = BUI:NewModule('DataTexts', 'AceEvent-3.0')
BUI.FlightMode = BUI:NewModule('FlightMode', 'AceHook-3.0', 'AceTimer-3.0', 'AceEvent-3.0')
BUI.iLevel = BUI:NewModule('iLevel', 'AceEvent-3.0')
BUI.Layout = BUI:NewModule('Layout', 'AceHook-3.0', 'AceEvent-3.0')
BUI.Nameplates = BUI:NewModule('Nameplates', 'AceHook-3.0')
BUI.Shadows = BUI:NewModule('Shadows', 'AceHook-3.0', 'AceEvent-3.0')
BUI.Skins = BUI:NewModule('Skins', 'AceHook-3.0', 'AceEvent-3.0')
BUI.Styles = BUI:NewModule('Styles', 'AceHook-3.0', 'AceEvent-3.0')
BUI.Tooltip = BUI:NewModule('Tooltip', 'AceHook-3.0')
BUI.Units = BUI:NewModule('Units', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

function BUI:RegisterModule(name)
	if self.initialized then
		local mod = self:GetModule(name)
		if (mod and mod.Initialize) then
			mod:Initialize()
		end
	else
		self["RegisteredModules"][#self["RegisteredModules"] + 1] = name
	end
end

function BUI:InitializeModules()
	for _, moduleName in pairs(BUI["RegisteredModules"]) do
		local mod = self:GetModule(moduleName)
		if mod.Initialize then
			mod:Initialize()
		else
			BUI:Print("Module <" .. moduleName .. "> is not loaded.")
		end
	end
end

function BUI:AddOptions()
	for _, func in pairs(BUI.Config) do
		func()
	end
end

function BUI:Init()
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		E:Delay(2, function() E:StaticPopup_Show("BENIKUI_CLASSIC") end)
		return	
	end

	--ElvUI's version check
	if BUI.Eversion < 1 or (BUI.Eversion < BUI.Erelease) then
		E:Delay(2, function() E:StaticPopup_Show("BENIKUI_VERSION_MISMATCH") end)
		return
	end
	self.initialized = true
	self:Initialize()
	self:InitializeModules()
	EP:RegisterPlugin(addon, self.AddOptions)
end

E.Libs.EP:HookInitialize(BUI, BUI.Init)

-- BenikUI retail on classic
E.PopupDialogs["BENIKUI_CLASSIC"] = {
	button1 = CLOSE,
	OnAccept = E.noop,
	text = (format(L["|cffff0000BenikUI Error|r\n\nIt seems like BenikUI Retail version is installed on WoW Classic. Please install BenikUI Classic version.\n|cff00c0faTip: Usually happens with Twitch Client|r"])),
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

--Version check
E.PopupDialogs["BENIKUI_VERSION_MISMATCH"] = {
	text = format(L["%s\n\nYour ElvUI version %.2f is not compatible with BenikUI.\nMinimum ElvUI version needed is %.2f. Please download it from here:\n"], BUI.Title, BUI.Eversion, BUI.Erelease),
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hasEditBox = 1,
	OnShow = function(self)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox.temptxt = "https://www.tukui.org/download.php?ui=elvui"
		self.editBox:SetText("https://www.tukui.org/download.php?ui=elvui")
		self.editBox:HighlightText()
		self.editBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	EditBoxOnTextChanged = function(self)
		if(self:GetText() ~= self.temptxt) then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
}
