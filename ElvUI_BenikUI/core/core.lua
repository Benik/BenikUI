local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:NewModule('BenikUI', "AceConsole-3.0");
local ACD = LibStub("AceConfigDialog-3.0")

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

BUI.TexCoords = {.08, 0.92, -.04, 0.92}
BUI.Title = string.format('|cff00c0fa%s |r', 'BenikUI')
BUI.Version = GetAddOnMetadata('ElvUI_BenikUI', 'Version')
BUI.newsign = '|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t'

local function StyleTooltip()
	GameTooltipStatusBar:SetStatusBarTexture(E["media"].BuiFlat)
	if E.db.bui.buiStyle ~= true then return end
	GameTooltip:Style('Inside')

	if IsAddOnLoaded('FreebTip') then
		GameTooltip.style:ClearAllPoints()
		GameTooltip.style:Point('TOPLEFT', GameTooltip, 'TOPLEFT', (E.PixelMode and 1 or 0), (E.PixelMode and -1 or 7))
		GameTooltip.style:Point('BOTTOMRIGHT', GameTooltip, 'TOPRIGHT', (E.PixelMode and -1 or 0), (E.PixelMode and -6 or 1))
	end
end

function BUI:cOption(name)
	local BUI_COLOR = '|cff00c0fa%s |r'
	return (BUI_COLOR):format(name)
end

function BUI:PrintURL(url) -- Credit: Azilroka
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

function BUI:RegisterBuiMedia()
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

E.BuiConfig = {}

-- Like S&L did ;)
function BUI:AddOptions()
	for _, func in pairs(E.BuiConfig) do
		func()
	end	
end

function BUI:DasOptions()
	E:ToggleConfig(); ACD:SelectGroup("ElvUI", "bui")
end

function BUI:LoadCommands()
	self:RegisterChatCommand("bui", "DasOptions")
	self:RegisterChatCommand("buisetup", "SetupBui")
end

function BUI:Initialize()
	self:RegisterBuiMedia()
	self:LoadCommands()
	StyleTooltip()
	E:GetModule('DataTexts'):ToggleMailFrame()

	-- run install when ElvUI install finishes
	if E.private.install_complete == E.version and E.db.bui.installed == nil then self:SetupBui() end
	
	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then self:SetupBui() end

	if E.db.bui.LoginMsg then
		print(BUI.Title..format('v|cff00c0fa%s|r',BUI.Version)..L[' is loaded. For any issues or suggestions, please visit ']..BUI:PrintURL('http://www.tukui.org/forums/topic.php?id=30598'))
	end
	EP:RegisterPlugin(addon, self.AddOptions)
end

E:RegisterModule(BUI:GetName())