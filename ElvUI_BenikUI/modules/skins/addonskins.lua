local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

if not IsAddOnLoaded('AddOnSkins') then return end

local BUIS = E:GetModule('BuiSkins');
local BUI = E:GetModule('BenikUI');

local AS = unpack(AddOnSkins)

local function SkadaDecor()
	if not E.db.buiaddonskins.skada then return end
	hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(self, win)
		local skada = win.bargroup
		skada.Backdrop:Style('Outside')
		if win.db.enabletitle then
			skada.button:StripTextures()
		end
		if not skada.Backdrop.ishooked then
			hooksecurefunc(AS, 'Embed_Check', function(self, message)
				if skada.Backdrop.style then
					if E.private.addonskins.EmbedSystem and E.private.addonskins.EmbedSkada then
						skada.Backdrop.style:Hide()
					else
						skada.Backdrop.style:Show()
					end
				end
			end)
			skada.Backdrop.ishooked = true
		end
	end)
end

local function StyleRecount(name, parent, ...)
	if E.db.bui.buiStyle ~= true then return end
	local recountdecor = CreateFrame('Frame', name, E.UIParent)
	recountdecor:SetTemplate('Default', true)
	recountdecor:SetParent(parent)
	recountdecor:Point('TOPLEFT', parent, 'TOPLEFT', 0, -2)
	recountdecor:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, -7)

	return recountdecor
end

local function RecountDecor()
	if not E.db.buiaddonskins.recount then return end
	StyleRecount('recountMain', Recount_MainWindow)
	Recount_MainWindow.TitleBackground:StripTextures()
	Recount_ConfigWindow.TitleBackground:StripTextures()
	Recount_DetailWindow.TitleBackground:StripTextures()
	StyleRecount(nil, Recount_DetailWindow)
	StyleRecount(nil, Recount_ConfigWindow)
	hooksecurefunc(Recount, 'ShowReport', function(self)
		if Recount_ReportWindow.TitleBackground then
			Recount_ReportWindow.TitleBackground:StripTextures()
			StyleRecount(nil, Recount_ReportWindow)
		end
	end)

	hooksecurefunc(AS, 'Embed_Check', function(self, message)
		-- Fix for blurry pixel fonts
		Recount.db.profile.Scaling = 0.95
		if E.db.bui.buiStyle ~= true then return end
		if E.private.addonskins.EmbedSystem then
			recountMain:Hide()
		else
			recountMain:Show()
		end
	end)
end

local function TinyDPSDecor()
	if not E.db.buiaddonskins.tinydps then return end
	if tdpsFrame then
		tdpsFrame:Style('Outside')
	end
end

local function AtlasLootDecor()
	if not strfind(GetAddOnMetadata('AtlasLoot', 'Version'), 'v8') then return end -- As Azilroka did ;)
	if not E.db.buiaddonskins.atlasloot then return end
	local AtlasLootFrame = _G["AtlasLoot_GUI-Frame"]
	if AtlasLootFrame then
		AtlasLootFrame:Style('Outside')
	end
end

local function AltoholicDecor()
	if not E.db.buiaddonskins.altoholic then return end
	if AltoholicFrame then
		AltoholicFrame:Style('Outside')
	end
end

local function ZygorDecor()
	if not E.db.buiaddonskins.zg then return end
	local zgFrames = {ZygorGuidesViewerFrame_Border, ZygorGuidesViewer_CreatureViewer}
	for _, frame in pairs(zgFrames) do
		frame:Style('Outside', frame:GetName()..'Decor')
	end
end

local function RareCoordDecor()
	if not E.db.buiaddonskins.rc then return end
	local rcFrames = {RC, RC.opt, RCnotify, RCminimized}
	for _, frame in pairs(rcFrames) do
		frame:Style('Outside')
	end	
end

local function CliqueDecor()
	if not E.db.buiaddonskins.clique then return end
	CliqueConfig:Style('Small')
	local tab = CliqueSpellTab
	tab:Style('Inside')
	tab:GetNormalTexture():SetTexCoord(.08, 0.92, 0.08, 0.92)
end

if AS:CheckAddOn('Skada') then AS:RegisterSkin('Skada', SkadaDecor, 2) end
if AS:CheckAddOn('Recount') then AS:RegisterSkin('Recount', RecountDecor, 2) end
if AS:CheckAddOn('TinyDPS') then AS:RegisterSkin('TinyDPS', TinyDPSDecor, 2) end
if AS:CheckAddOn('AtlasLoot') then AS:RegisterSkin('AtlasLoot', AtlasLootDecor, 2) end
if AS:CheckAddOn('Altoholic') then AS:RegisterSkin('Altoholic', AltoholicDecor, 2) end
if AS:CheckAddOn('RareCoordinator') then AS:RegisterSkin('RareCoordinator', RareCoordDecor, 2) end
if AS:CheckAddOn('ZygorGuidesViewer') then AS:RegisterSkin('Zygor', ZygorDecor, 2) end
if AS:CheckAddOn('Clique') then AS:RegisterSkin('Clique', CliqueDecor, 2) end
