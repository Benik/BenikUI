local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local LSM = E.LSM

local _G = _G
local pairs, print, tinsert, strjoin, lower, next, wipe = pairs, print, table.insert, strjoin, strlower, next, wipe
local format = string.format
local GetAddOnMetadata = GetAddOnMetadata
local GetAddOnEnableState = GetAddOnEnableState
local DisableAddOn = DisableAddOn
local EnableAddOn = EnableAddOn
local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns
local ReloadUI = ReloadUI
local SetCVar = SetCVar

-- GLOBALS: LibStub, ElvDB, test

BUI["styles"] = {}
BUI["softGlow"] = {}
BUI["shadows"] = {}
BUI.TexCoords = {.08, 0.92, -.04, 0.92}
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
BUI.ZG = BUI:IsAddOnEnabled('ZygorGuidesViewer')

local classColor = E:ClassColor(E.myclass, true)

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
	E['media'].BuiShadow = LSM:Fetch('statusbar', 'BuiKringelShadow')
end

function BUI:Print(...)
	(_G.DEFAULT_CHAT_FRAME):AddMessage(strjoin('', '|cff00c0fa', 'BenikUI:|r ', ...))
end

function BUI:cOption(name)
	local color = '|cff00c0fa%s |r'
	return (color):format(name)
end

local color = { r = 1, g = 1, b = 1, a = 1 }
function BUI:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

function BUI:LuaError(msg)
	local switch = lower(msg)
	if switch == 'on' or switch == '1' then
		for i=1, GetNumAddOns() do
			local name = GetAddOnInfo(i)
			if (name ~= 'ElvUI' and name ~= 'ElvUI_OptionsUI' and name ~= 'ElvUI_BenikUI') and E:IsAddOnEnabled(name) then
				DisableAddOn(name, E.myname)
				ElvDB.BuiErrorDisabledAddOns[name] = i
			end
		end

		SetCVar('scriptErrors', 1)
		ReloadUI()
	elseif switch == 'off' or switch == '0' then
		if switch == 'off' then
			SetCVar('scriptErrors', 0)
			BUI:Print('Lua errors off.')
		end

		if next(ElvDB.BuiErrorDisabledAddOns) then
			for name in pairs(ElvDB.BuiErrorDisabledAddOns) do
				EnableAddOn(name, E.myname)
			end

			wipe(ElvDB.BuiErrorDisabledAddOns)
			ReloadUI()
		end
	else
		BUI:Print('/buierror on - /buierror off')
	end
end

local r, g, b = 0, 0, 0
function BUI:UpdateStyleColors()
	local BTT = BUI:GetModule('Tooltip')
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
			frame:SetBackdropColor(r, g, b, E.db.benikui.colors.styleAlpha or 1)
		else
			BUI["styles"][frame] = nil;
		end
	end
	BTT:CheckTooltipStyleColor()
	BTT:RecolorTooltipStyle()
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

function BUI:UpdateShadowSize()
	if BUI["shadows"] == nil then BUI["shadows"] = {} end
	local db = E.db.benikui.general

	for shadow, _ in pairs(BUI["shadows"]) do
		if shadow then
			shadow:SetOutside(shadow:GetParent(), (db.shadowSize - 1) or 2, (db.shadowSize - 1) or 2)
			shadow:SetBackdrop({edgeFile = E.Media.Textures.GlowTex, edgeSize = E:Scale(db.shadowSize or 3)})
			shadow:SetBackdropColor(0, 0, 0, 0)
			shadow:SetBackdropBorderColor(0, 0, 0, 0.6)
		else
			BUI["shadows"][shadow] = nil;
		end
	end
end

function BUI:DasOptions()
	E:ToggleOptionsUI(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui")
end

function BUI:SetupBenikUI()
	E:GetModule("PluginInstaller"):Queue(BUI.installTable)
end

function BUI:LoadCommands()
	self:RegisterChatCommand("benikui", "DasOptions")
	self:RegisterChatCommand("benikuisetup", "SetupBenikUI")
	self:RegisterChatCommand("buierror", "LuaError")
end

function BUI:Initialize()
	RegisterMedia()
	self:LoadCommands()
	self:SplashScreen()

	E:GetModule('DataTexts'):ToggleMailFrame()
	
	hooksecurefunc(E, "PLAYER_ENTERING_WORLD", function(self, _, initLogin)
		if initLogin or not ElvDB.BuiErrorDisabledAddOns then
			ElvDB.BuiErrorDisabledAddOns = {}
		end
	end)

	local profileKey = ElvDB.profileKeys[E.mynameRealm]

	-- run install when ElvUI install finishes or run the setup again when a profile gets deleted.
	if (E.private.install_complete == E.version and E.db.benikui.installed == nil) or (ElvDB.profileKeys and profileKey == nil) then
		BUI:SetupBenikUI()
	end

	if E.db.benikui.general.loginMessage then
		print(BUI.Title..format('v|cff00c0fa%s|r',BUI.Version)..L[' is loaded. For any issues or suggestions, please visit ']..PrintURL('http://git.tukui.org/Benik/ElvUI_BenikUI/issues'))
	end

	if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
		BUI.ShadowMode = true
	end

	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts)+1, "BENIKUI")
	E.ConfigModeLocalizedStrings["BENIKUI"] = BUI.Title

	BUI.AddonProfileKey = BUI.Title..E.mynameRealm

	hooksecurefunc(E, "UpdateMedia", BUI.UpdateSoftGlowColor)
	hooksecurefunc(BUI, "SetupColorThemes", BUI.UpdateStyleColors)
end
