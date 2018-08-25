local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');
local BUI = E:GetModule('BenikUI');

local pairs = pairs

local _G = _G
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: hooksecurefunc, Skada, Recount, oRA3, RC, RCnotify, RCminimized

if not BUI.AS then return end
local AS = unpack(AddOnSkins)

local function SkadaDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.skada then return end
	hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(self, win)
		local skada = win.bargroup
		skada.Backdrop:Style('Outside')
		if win.db.enabletitle then
			skada.button:StripTextures()
		end
		if not skada.Backdrop.ishooked then
			hooksecurefunc(AS, 'Embed_Check', function(self, message)
				if skada.Backdrop.style then
					if AS.db.EmbedSystem and AS.db.EmbedSkada then
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
		if AS.db.EmbedSystem then
			_G["recountMain"]:Hide()
		else
			_G["recountMain"]:Show()
		end
	end)
end

local function TinyDPSDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.tinydps then return end
	if _G["tdpsFrame"] then
		if not _G["tdpsFrame"].style then
			_G["tdpsFrame"]:Style('Outside')
		end
	end
end

local function AtlasLootDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.atlasloot then return end
	local AtlasLootFrame = _G["AtlasLoot_GUI-Frame"]
	if AtlasLootFrame then
		if not AtlasLootFrame.style then
			AtlasLootFrame:Style('Outside')
		end
	end
end

local function AltoholicDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.altoholic then return end
	if _G["AltoholicFrame"] then
		if not _G["AltoholicFrame"].style then
			_G["AltoholicFrame"]:Style('Outside')
		end
	end
end

local function CliqueDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.clique then return end
	_G["CliqueConfig"]:Style('Small')
	_G["CliqueDialog"]:Style('Small')
	local tab = _G["CliqueSpellTab"]
	if not tab.style then
		tab:Style('Inside')
		tab.style:SetFrameLevel(5)
	end
	tab:GetNormalTexture():SetTexCoord(.08, 0.92, 0.08, 0.92)
end

local function oRA3Decor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.ora then return end
	hooksecurefunc(oRA3, "ToggleFrame", function() _G["oRA3Frame"]:Style('Small'); end)

	local ReadyCheckModule = oRA3:GetModule("ReadyCheck")
	if (ReadyCheckModule) then
		hooksecurefunc(ReadyCheckModule, "READY_CHECK", function() _G["oRA3ReadyCheck"]:Style('Small'); end)
	end
end

local function PawnDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.pawn then return end
	local frame = PawnUIFrame

	if not frame.style then
		frame:Style('Outside')
	end
end

local function DbmDecor(event)
	if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.dbm then return end

	local function StyleRangeFrame(self, range, filter, forceshow, redCircleNumPlayers)
		if DBM.Options.DontShowRangeFrame and not forceshow then return end

		if DBMRangeCheckRadar then
			if not DBMRangeCheckRadar.style then
				DBMRangeCheckRadar:Style('Inside')
			end

			if AS:CheckOption('DBMRadarTrans') then
				if DBMRangeCheckRadar.style and E.db.benikui.general.benikuiStyle then
					DBMRangeCheckRadar.style:Hide()
				end

				if DBMRangeCheckRadar.shadow then
					DBMRangeCheckRadar.shadow:Hide()
				end
			else
				if DBMRangeCheckRadar.style and E.db.benikui.general.benikuiStyle then
					DBMRangeCheckRadar.style:Show()
				end

				if DBMRangeCheckRadar.shadow then
					DBMRangeCheckRadar.shadow:Show()
				end
			end
		end
		
		if DBMRangeCheck then
			DBMRangeCheck:SetTemplate('Transparent')
			if not DBMRangeCheck.style then
				DBMRangeCheck:Style('Outside')
			end
		end
	end

	local function StyleInfoFrame(self, maxLines, event, ...)
		if DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end

		if DBMInfoFrame and not DBMInfoFrame.style then
			DBMInfoFrame:Style('Inside')
		end
	end

	hooksecurefunc(DBM.RangeCheck, 'Show', StyleRangeFrame)
	hooksecurefunc(DBM.InfoFrame, 'Show', StyleInfoFrame)
end

if AS:CheckAddOn('Skada') then AS:RegisterSkin('Skada', SkadaDecor, 2) end
if AS:CheckAddOn('Recount') then AS:RegisterSkin('Recount', RecountDecor, 2) end
if AS:CheckAddOn('TinyDPS') then AS:RegisterSkin('TinyDPS', TinyDPSDecor, 2) end
if AS:CheckAddOn('AtlasLoot') then AS:RegisterSkin('AtlasLoot', AtlasLootDecor, 2) end
if AS:CheckAddOn('Altoholic') then AS:RegisterSkin('Altoholic', AltoholicDecor, 2) end
if AS:CheckAddOn('Clique') then AS:RegisterSkin('Clique', CliqueDecor, 2) end
if AS:CheckAddOn('oRA3') then AS:RegisterSkin('oRA3', oRA3Decor, 2) end
if AS:CheckAddOn('Pawn') then AS:RegisterSkin('Pawn', PawnDecor, 2) end
if AS:CheckAddOn('DBM-Core') then AS:RegisterSkin('DBM', DbmDecor, 2) end

hooksecurefunc(AS, 'AcceptFrame', function(self)
	if not _G["AcceptFrame"].style then
		_G["AcceptFrame"]:Style('Outside')
	end
end)