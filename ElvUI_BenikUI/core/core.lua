local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:NewModule('BenikUI');

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

BUI.TexCoords = {.08, 0.92, -.04, 0.92}
BUI.Title = string.format('|cff00c0fa%s |r', 'BenikUI')
BUI.Version = GetAddOnMetadata('ElvUI_BenikUI', 'Version')
BUI.newsign = '|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t'

local function StyleTooltip()
	if IsAddOnLoaded('FreebTip') then return end
	GameTooltip:Style('Inside')
	GameTooltipStatusBar:SetStatusBarTexture(E["media"].BuiFlat)
end

function BUI:cOption(name)
	local BUI_COLOR = '|cff00c0fa%s |r'
	return (BUI_COLOR):format(name)
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
end

E.BuiConfig = {}

-- Like S&L did ;)
function BUI:AddOptions()
	for _, func in pairs(E.BuiConfig) do
		func()
	end	
end

function BUI:InitBUI()
	StyleTooltip()
	E:GetModule('DataTexts'):ToggleMailFrame()
end

function BUI:Initialize()
	self:RegisterBuiMedia()
	self:InitBUI()
	if E.db.utils then E.db.utils = nil end -- delete the old Dashboards db.
	if E.private.install_complete == E.version and E.db.bui.installed == nil then E:SetupBui() end
	-- run the setup when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then E:SetupBui() end

	print(BUI.Title..format('v|cff00c0fa%s|r',BUI.Version)..L[' is loaded. For any issues or suggestions, please visit http://www.tukui.org/forums/topic.php?id=30598'])
	EP:RegisterPlugin(addon, self.AddOptions)
end

E:RegisterModule(BUI:GetName())