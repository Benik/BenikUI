local E, L, V, P, G, _ = unpack(ElvUI);
local S = E:GetModule('Skins');

local pairs = pairs

local _G = _G
local IsAddOnLoaded = IsAddOnLoaded

local SPACING = (E.PixelMode and 1 or 3)

local function skinDecursive()
	if not IsAddOnLoaded('Decursive') or not E.db.benikuiSkins.variousSkins.decursive then return end

	-- Main Buttons
	DecursiveMainBar:StripTextures()
	DecursiveMainBar:SetTemplate('Default', true)
	DecursiveMainBar:Height(20)
	
	local mainButtons = {DecursiveMainBarPriority, DecursiveMainBarSkip, DecursiveMainBarHide}
	for i, button in pairs(mainButtons) do
		S:HandleButton(button)
		button:SetTemplate('Default', true)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('LEFT', DecursiveMainBar, 'RIGHT', SPACING, 0)
		else
			button:Point('LEFT', mainButtons[i - 1], 'RIGHT', SPACING, 0)
		end		
	end
	
	-- Priority List Frame
	DecursivePriorityListFrame:StripTextures()
	DecursivePriorityListFrame:CreateBackdrop('Transparent')
	DecursivePriorityListFrame.backdrop:Style('Outside')
	
	local priorityButton = {DecursivePriorityListFrameAdd, DecursivePriorityListFramePopulate, DecursivePriorityListFrameClear, DecursivePriorityListFrameClose}
	for i, button in pairs(priorityButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('TOP', DecursivePriorityListFrame, 'TOPLEFT', 54, -20)
		else
			button:Point('LEFT', priorityButton[i - 1], 'RIGHT', SPACING, 0)
		end			
	end

	DecursivePopulateListFrame:StripTextures()
	DecursivePopulateListFrame:CreateBackdrop('Transparent')
	DecursivePopulateListFrame.backdrop:Style('Outside')
	
	for i = 1, 8 do
		local groupButton = _G["DecursivePopulateListFrameGroup"..i]
		S:HandleButton(groupButton)
	end
	
	local classPop = {'Warrior', 'Priest', 'Mage', 'Warlock', 'Hunter', 'Rogue', 'Druid', 'Shaman', 'Monk', 'Paladin', 'Deathknight', 'Close'}
	for _, classBtn in pairs(classPop) do
		local btnName = _G["DecursivePopulateListFrame"..classBtn]
		S:HandleButton(btnName)
	end

	-- Skip List Frame
	DecursiveSkipListFrame:StripTextures()
	DecursiveSkipListFrame:CreateBackdrop('Transparent')
	DecursiveSkipListFrame.backdrop:Style('Outside')	
	
	local skipButton = {DecursiveSkipListFrameAdd, DecursiveSkipListFramePopulate, DecursiveSkipListFrameClear, DecursiveSkipListFrameClose}
	for i, button in pairs(skipButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('TOP', DecursiveSkipListFrame, 'TOPLEFT', 54, -20)
		else
			button:Point('LEFT', skipButton[i - 1], 'RIGHT', SPACING, 0)
		end			
	end
	
	-- Tooltip
	DcrDisplay_Tooltip:StripTextures()
	DcrDisplay_Tooltip:CreateBackdrop('Transparent')
	DcrDisplay_Tooltip.backdrop:Style('Outside')

end

local function skinStoryline()
	if not IsAddOnLoaded('Storyline') or not E.db.benikuiSkins.variousSkins.storyline then return end
	Storyline_NPCFrame:StripTextures()
	Storyline_NPCFrame:CreateBackdrop('Transparent')
	Storyline_NPCFrame.backdrop:Style('Outside')
	S:HandleCloseButton(Storyline_NPCFrameClose)
	Storyline_NPCFrameChat:StripTextures()
	Storyline_NPCFrameChat:CreateBackdrop('Transparent')
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	skinDecursive()
	skinStoryline()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

if not IsAddOnLoaded('AddOnSkins') then return end
local AS = unpack(AddOnSkins)

local function SkadaDecor()
	if not E.db.benikuiSkins.addonSkins.skada then return end
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
	if E.db.benikui.general.benikuiStyle ~= true then return end
	local recountdecor = CreateFrame('Frame', name, E.UIParent)
	recountdecor:SetTemplate('Default', true)
	recountdecor:SetParent(parent)
	recountdecor:Point('TOPLEFT', parent, 'TOPLEFT', 0, -2)
	recountdecor:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, -7)

	return recountdecor
end

local function RecountDecor()
	if not E.db.benikuiSkins.addonSkins.recount then return end
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
		if E.db.benikui.general.benikuiStyle ~= true then return end
		if E.private.addonskins.EmbedSystem then
			recountMain:Hide()
		else
			recountMain:Show()
		end
	end)
end

local function TinyDPSDecor()
	if not E.db.benikuiSkins.addonSkins.tinydps then return end
	if tdpsFrame then
		if not tdpsFrame.style then
			tdpsFrame:Style('Outside')
		end
	end
end

local function AtlasLootDecor()
	if not strfind(GetAddOnMetadata('AtlasLoot', 'Version'), 'v8') then return end -- As Azilroka did ;)
	if not E.db.benikuiSkins.addonSkins.atlasloot then return end
	local AtlasLootFrame = _G["AtlasLoot_GUI-Frame"]
	if AtlasLootFrame then
		if not AtlasLootFrame.style then
			AtlasLootFrame:Style('Outside')
		end
	end
end

local function AltoholicDecor()
	if not E.db.benikuiSkins.addonSkins.altoholic then return end
	if AltoholicFrame then
		if not AltoholicFrame.style then
			AltoholicFrame:Style('Outside')
		end
	end
end

local function ZygorDecor()
	if not E.db.benikuiSkins.addonSkins.zg then return end

		if not ZygorGuidesViewerFrame_Border.style then
			ZygorGuidesViewerFrame_Border:Style('Outside')
		end

	hooksecurefunc(ZygorGuidesViewer.CreatureViewer, 'CreateFrame', function(self)
		if self.Frame then
			if not ZygorGuidesViewer_CreatureViewer.style then
				ZygorGuidesViewer_CreatureViewer:Style('Outside')
			end
		end
	end)
end

local function RareCoordDecor()
	if not E.db.benikuiSkins.addonSkins.rc then return end
	local rcFrames = {RC, RC.opt, RCnotify, RCminimized}
	for _, frame in pairs(rcFrames) do
		if not frame.style then
			frame:Style('Outside')
		end
	end	
end

local function CliqueDecor()
	if not E.db.benikuiSkins.addonSkins.clique then return end
	CliqueConfig:Style('Small')
	local tab = CliqueSpellTab
	if not tab.style then
		tab:Style('Inside')
	end
	tab:GetNormalTexture():SetTexCoord(.08, 0.92, 0.08, 0.92)
end

local function oRA3Decor()
	if not E.db.benikuiSkins.addonSkins.ora then return end
	hooksecurefunc(oRA3, "ToggleFrame", function() oRA3Frame:Style('Small'); end)
	
	local ReadyCheckModule = oRA3:GetModule("ReadyCheck")
	if (ReadyCheckModule) then
		hooksecurefunc(ReadyCheckModule, "READY_CHECK", function() oRA3ReadyCheck:Style('Small'); end)
	end
end

if AS:CheckAddOn('Skada') then AS:RegisterSkin('Skada', SkadaDecor, 2) end
if AS:CheckAddOn('Recount') then AS:RegisterSkin('Recount', RecountDecor, 2) end
if AS:CheckAddOn('TinyDPS') then AS:RegisterSkin('TinyDPS', TinyDPSDecor, 2) end
if AS:CheckAddOn('AtlasLoot') then AS:RegisterSkin('AtlasLoot', AtlasLootDecor, 2) end
if AS:CheckAddOn('Altoholic') then AS:RegisterSkin('Altoholic', AltoholicDecor, 2) end
if AS:CheckAddOn('RareCoordinator') then AS:RegisterSkin('RareCoordinator', RareCoordDecor, 2) end
if AS:CheckAddOn('ZygorGuidesViewer') then AS:RegisterSkin('Zygor', ZygorDecor, 2) end
if AS:CheckAddOn('Clique') then AS:RegisterSkin('Clique', CliqueDecor, 2) end
if AS:CheckAddOn('oRA3') then AS:RegisterSkin('oRA3', oRA3Decor, 2) end

hooksecurefunc(AS, 'AcceptFrame', function(self)
	if not AcceptFrame.style then
		AcceptFrame:Style('Outside')
	end
end)
