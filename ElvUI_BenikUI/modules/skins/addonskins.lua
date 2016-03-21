local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

local pairs = pairs

local _G = _G
local strfind = strfind
local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: hooksecurefunc, Skada, Recount, oRA3, RC, RCnotify, RCminimized

local SPACING = (E.PixelMode and 1 or 3)

local function skinDecursive()
	if not IsAddOnLoaded('Decursive') or not E.db.benikuiSkins.variousSkins.decursive then return end

	-- Main Buttons
	_G["DecursiveMainBar"]:StripTextures()
	_G["DecursiveMainBar"]:SetTemplate('Default', true)
	_G["DecursiveMainBar"]:Height(20)
	
	local mainButtons = {_G["DecursiveMainBarPriority"], _G["DecursiveMainBarSkip"], _G["DecursiveMainBarHide"]}
	for i, button in pairs(mainButtons) do
		S:HandleButton(button)
		button:SetTemplate('Default', true)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('LEFT', _G["DecursiveMainBar"], 'RIGHT', SPACING, 0)
		else
			button:Point('LEFT', mainButtons[i - 1], 'RIGHT', SPACING, 0)
		end		
	end
	
	-- Priority List Frame
	_G["DecursivePriorityListFrame"]:StripTextures()
	_G["DecursivePriorityListFrame"]:CreateBackdrop('Transparent')
	_G["DecursivePriorityListFrame"].backdrop:Style('Outside')
	
	local priorityButton = {_G["DecursivePriorityListFrameAdd"], _G["DecursivePriorityListFramePopulate"], _G["DecursivePriorityListFrameClear"], _G["DecursivePriorityListFrameClose"]}
	for i, button in pairs(priorityButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('TOP', _G["DecursivePriorityListFrame"], 'TOPLEFT', 54, -20)
		else
			button:Point('LEFT', priorityButton[i - 1], 'RIGHT', SPACING, 0)
		end			
	end

	_G["DecursivePopulateListFrame"]:StripTextures()
	_G["DecursivePopulateListFrame"]:CreateBackdrop('Transparent')
	_G["DecursivePopulateListFrame"].backdrop:Style('Outside')
	
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
	_G["DecursiveSkipListFrame"]:StripTextures()
	_G["DecursiveSkipListFrame"]:CreateBackdrop('Transparent')
	_G["DecursiveSkipListFrame"].backdrop:Style('Outside')	
	
	local skipButton = {_G["DecursiveSkipListFrameAdd"], _G["DecursiveSkipListFramePopulate"], _G["DecursiveSkipListFrameClear"], _G["DecursiveSkipListFrameClose"]}
	for i, button in pairs(skipButton) do
		S:HandleButton(button)
		button:ClearAllPoints()
		if(i == 1) then
			button:Point('TOP', _G["DecursiveSkipListFrame"], 'TOPLEFT', 54, -20)
		else
			button:Point('LEFT', skipButton[i - 1], 'RIGHT', SPACING, 0)
		end			
	end
	
	-- Tooltip
	_G["DcrDisplay_Tooltip"]:StripTextures()
	_G["DcrDisplay_Tooltip"]:CreateBackdrop('Transparent')
	_G["DcrDisplay_Tooltip"].backdrop:Style('Outside')

end

local function skinStoryline()
	if not IsAddOnLoaded('Storyline') or not E.db.benikuiSkins.variousSkins.storyline then return end
	_G["Storyline_NPCFrame"]:StripTextures()
	_G["Storyline_NPCFrame"]:CreateBackdrop('Transparent')
	_G["Storyline_NPCFrame"].backdrop:Style('Outside')
	S:HandleCloseButton(_G["Storyline_NPCFrameClose"])
	_G["Storyline_NPCFrameChat"]:StripTextures()
	_G["Storyline_NPCFrameChat"]:CreateBackdrop('Transparent')
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
	StyleRecount('recountMain', _G["Recount_MainWindow"])
	_G["Recount_MainWindow"].TitleBackground:StripTextures()
	_G["Recount_ConfigWindow"].TitleBackground:StripTextures()
	_G["Recount_DetailWindow"].TitleBackground:StripTextures()
	StyleRecount(nil, _G["Recount_DetailWindow"])
	StyleRecount(nil, _G["Recount_ConfigWindow"])
	hooksecurefunc(Recount, 'ShowReport', function(self)
		if _G["Recount_ReportWindow"].TitleBackground then
			_G["Recount_ReportWindow"].TitleBackground:StripTextures()
			StyleRecount(nil, _G["Recount_ReportWindow"])
		end
	end)

	hooksecurefunc(AS, 'Embed_Check', function(self, message)
		-- Fix for blurry pixel fonts
		Recount.db.profile.Scaling = 0.95
		if E.db.benikui.general.benikuiStyle ~= true then return end
		if E.private.addonskins.EmbedSystem then
			_G["recountMain"]:Hide()
		else
			_G["recountMain"]:Show()
		end
	end)
end

local function TinyDPSDecor()
	if not E.db.benikuiSkins.addonSkins.tinydps then return end
	if _G["tdpsFrame"] then
		if not _G["tdpsFrame"].style then
			_G["tdpsFrame"]:Style('Outside')
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
	if _G["AltoholicFrame"] then
		if not _G["AltoholicFrame"].style then
			_G["AltoholicFrame"]:Style('Outside')
		end
	end
end

local function ZygorDecor()
	if not E.db.benikuiSkins.addonSkins.zg then return end

		if not _G["ZygorGuidesViewerFrame_Border"].style then
			_G["ZygorGuidesViewerFrame_Border"]:Style('Outside')
		end

	hooksecurefunc(_G["ZygorGuidesViewer"].CreatureViewer, 'CreateFrame', function(self)
		if self.Frame then
			if not _G["ZygorGuidesViewer_CreatureViewer"].style then
				_G["ZygorGuidesViewer_CreatureViewer"]:Style('Outside')
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
	_G["CliqueConfig"]:Style('Small')
	local tab = _G["CliqueSpellTab"]
	if not tab.style then
		tab:Style('Inside')
	end
	tab:GetNormalTexture():SetTexCoord(.08, 0.92, 0.08, 0.92)
end

local function oRA3Decor()
	if not E.db.benikuiSkins.addonSkins.ora then return end
	hooksecurefunc(oRA3, "ToggleFrame", function() _G["oRA3Frame"]:Style('Small'); end)
	
	local ReadyCheckModule = oRA3:GetModule("ReadyCheck")
	if (ReadyCheckModule) then
		hooksecurefunc(ReadyCheckModule, "READY_CHECK", function() _G["oRA3ReadyCheck"]:Style('Small'); end)
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
	if not _G["AcceptFrame"].style then
		_G["AcceptFrame"]:Style('Outside')
	end
end)
