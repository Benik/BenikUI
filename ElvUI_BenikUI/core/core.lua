local E, L, V, P, G = unpack(ElvUI);
local BUI = E:NewModule('BenikUI', "AceConsole-3.0", "AceHook-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

local _G = _G
local pairs, print = pairs, print
local format = string.format
local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local GetAddOnEnableState = GetAddOnEnableState

-- GLOBALS: LibStub, ElvDB

BUI.Config = {}
BUI["styles"] = {}
BUI["softGlow"] = {}
BUI.TexCoords = {.08, 0.92, -.04, 0.92}
BUI.Title = format('|cff00c0fa%s |r', 'BenikUI')
BUI.Version = GetAddOnMetadata('ElvUI_BenikUI', 'Version')
BUI.ShadowMode = false;
BUI.AddonProfileKey = '';
BINDING_HEADER_BENIKUI = BUI.Title

function BUI:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

-- Check other addons
BUI.SLE = BUI:IsAddOnEnabled('ElvUI_SLE')
BUI.PA = BUI:IsAddOnEnabled('ProjectAzilroka')
BUI.LP = BUI:IsAddOnEnabled('ElvUI_LocPlus')
BUI.NB = BUI:IsAddOnEnabled('ElvUI_NutsAndBolts')
BUI.AS = BUI:IsAddOnEnabled('AddOnSkins')
BUI.IF = BUI:IsAddOnEnabled('InFlight_Load')

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function PrintURL(url) -- Credit: Azilroka
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

local function RegisterMedia()
	--Fonts
	E['media'].buiFont = LSM:Fetch('font', 'Bui Prototype')
	E['media'].buiVisitor = LSM:Fetch('font', 'Bui Visitor1')
	E['media'].buiVisitor2 = LSM:Fetch('font', 'Bui Visitor2')
	E['media'].buiTuk = LSM:Fetch('font', 'Bui Tukui')

	--Textures
	E['media'].BuiEmpty = LSM:Fetch('statusbar', 'BuiEmpty')
	E['media'].BuiFlat = LSM:Fetch('statusbar', 'BuiFlat')
	E['media'].BuiMelli = LSM:Fetch('statusbar', 'BuiMelli')
	E['media'].BuiMelliDark = LSM:Fetch('statusbar', 'BuiMelliDark')
	E['media'].BuiOnePixel = LSM:Fetch('statusbar', 'BuiOnePixel')
end

function BUI:cOption(name)
	local color = '|cff00c0fa%s |r'
	return (color):format(name)
end

local color = { r = 1, g = 1, b = 1, a = 1 }
function BUI:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

local r, g, b = 0, 0, 0
function BUI:UpdateStyleColors()
	for frame, _ in pairs(BUI["styles"]) do
		if frame and not frame.ignoreColor then
			if E.db.benikui.colors.StyleColor == 1 then
				r, g, b = classColor.r, classColor.g, classColor.b
			elseif E.db.benikui.colors.StyleColor == 2 then
				r, g, b = BUI:unpackColor(E.db.benikui.colors.customStyleColor)
			elseif E.db.benikui.colors.StyleColor == 3 then
				r, g, b = BUI:unpackColor(E.db.general.valuecolor)
			else
				r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
			end
			frame:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
		else
			BUI["styles"][frame] = nil;
		end
	end
end

function BUI:UpdateStyleVisibility()
	for frame, _ in pairs(BUI["styles"]) do
		if frame and not frame.ignoreVisibility then
			if E.db.benikui.general.hideStyle then
				frame:Hide()
			else
				frame:Show()
			end
		end
	end
end

function BUI:UpdateSoftGlowColor()
	if BUI["softGlow"] == nil then BUI["softGlow"] = {} end

	local sr, sg, sb = BUI:unpackColor(E.db.general.valuecolor)

	for glow, _ in pairs(BUI["softGlow"]) do
		if glow then
			glow:SetBackdropBorderColor(sr, sg, sb, 0.6)
		else
			BUI["softGlow"][glow] = nil;
		end
	end
end

function BUI:AddOptions()
	for _, func in pairs(BUI.Config) do
		func()
	end
end

function BUI:DasOptions()
	E:ToggleConfig(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui")
end

function BUI:LoadCommands()
	self:RegisterChatCommand("benikui", "DasOptions")
	self:RegisterChatCommand("benikuisetup", "SetupBenikUI")
end

function BUI:Initialize()
	RegisterMedia()
	self:LoadCommands()
	self:SplashScreen()

	E:GetModule('DataTexts'):ToggleMailFrame()

	-- run install when ElvUI install finishes
	if E.private.install_complete == E.version and E.db.benikui.installed == nil then
		E:GetModule("PluginInstaller"):Queue(BUI.installTable)
	end

	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then
		E:GetModule("PluginInstaller"):Queue(BUI.installTable)
	end

	if E.db.benikui.general.loginMessage then
		print(BUI.Title..format('v|cff00c0fa%s|r',BUI.Version)..L[' is loaded. For any issues or suggestions, please visit ']..PrintURL('http://git.tukui.org/Benik/ElvUI_BenikUI/issues'))
	end

	if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
		BUI.ShadowMode = true
	end

	BUI.AddonProfileKey = BUI.Title..E.myname.." - "..E.myrealm

	EP:RegisterPlugin(addon, self.AddOptions)

	hooksecurefunc(E, "UpdateMedia", BUI.UpdateSoftGlowColor)
	hooksecurefunc(BUI, "SetupColorThemes", BUI.UpdateStyleColors)
end

local function InitializeCallback()
	BUI:Initialize()
end

E:RegisterModule(BUI:GetName(), InitializeCallback)