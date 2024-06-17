local BUI, E, L, V, P, G = unpack((select(2, ...)))

local _G = _G
local unpack = unpack

local CreateFrame = CreateFrame

-- GLOBALS: hooksecurefunc, Skada, Recount, oRA3, RC, RCnotify, RCminimized

if not BUI.AS then return end
local AS = unpack(AddOnSkins)

local classColor = E:ClassColor(E.myclass, true)

local function SkadaDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.skada then return end
	hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(self, win)
		local skada = win.bargroup
		skada.backdrop:BuiStyle('Outside')
		if win.db.enabletitle then
			skada.button:StripTextures()
		end
		if not skada.backdrop.ishooked then
			hooksecurefunc(AS, 'CheckEmbed', function(self, message)
				if skada.backdrop.style then
					if AS.db.EmbedSystem and AS.db.EmbedSkada then
						skada.backdrop.style:Hide()
					else
						skada.backdrop.style:Show()
					end
				end
			end)
			skada.backdrop.ishooked = true
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
	if not E.db.benikui.skins.addonSkins.recount then return end
	StyleRecount('recountMain', _G["Recount_MainWindow"])
	_G["Recount_MainWindow"].TitleBackground:StripTextures()
	_G["Recount_ConfigWindow"].TitleBackground:StripTextures()
	StyleRecount(nil, _G["Recount_DetailWindow"])
	StyleRecount(nil, _G["Recount_ConfigWindow"])
	hooksecurefunc(Recount, 'ShowReport', function(self)
		if _G["Recount_ReportWindow"].TitleBackground then
			_G["Recount_ReportWindow"].TitleBackground:StripTextures()
			StyleRecount(nil, _G["Recount_ReportWindow"])
		end
	end)

	hooksecurefunc(AS, 'CheckEmbed', function(self, message)
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
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.tinydps then return end
	if _G["tdpsFrame"] then
		if not _G["tdpsFrame"].style then
			_G["tdpsFrame"]:BuiStyle('Outside')
		end
	end
end

local function AtlasLootDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.atlasloot then return end
	local AtlasLootFrame = _G["AtlasLoot_GUI-Frame"]
	if AtlasLootFrame then
		if not AtlasLootFrame.style then
			AtlasLootFrame:BuiStyle('Outside')
		end
	end
end

local function AltoholicDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.altoholic then return end
	if _G["AltoholicFrame"] then
		if not _G["AltoholicFrame"].style then
			_G["AltoholicFrame"]:BuiStyle('Outside')
		end
	end
end

local function CliqueDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.clique then return end
	_G["CliqueConfig"]:BuiStyle('Small')
	_G["CliqueDialog"]:BuiStyle('Small')
	local tab = _G["CliqueSpellTab"]
	if not tab.style then
		tab:BuiStyle('Inside')
		tab.style:SetFrameLevel(5)
	end
	tab:GetNormalTexture():SetTexCoord(.08, 0.92, 0.08, 0.92)
end

local function oRA3Decor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.ora then return end
	hooksecurefunc(oRA3, "ToggleFrame", function() _G["oRA3Frame"]:BuiStyle('Small'); end)

	local ReadyCheckModule = oRA3:GetModule("ReadyCheck")
	if (ReadyCheckModule) then
		hooksecurefunc(ReadyCheckModule, "READY_CHECK", function() _G["oRA3ReadyCheck"]:BuiStyle('Small'); end)
	end
end

local function PawnDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.pawn then return end
	local frame = PawnUIFrame

	if not frame.style then
		frame:BuiStyle('Outside')
	end
end

local function DbmDecor(_, event)
	if event ~= 'PLAYER_ENTERING_WORLD' then return end

	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.dbm then return end

	local function StyleRangeFrame(self, range, filter, forceshow, redCircleNumPlayers)
		if DBM.Options.DontShowRangeFrame and not forceshow then return end

		if DBMRangeCheckRadar then
			if not DBMRangeCheckRadar.style then
				DBMRangeCheckRadar:BuiStyle('Inside')
			end
		end

		if DBMRangeCheck then
			if not DBMRangeCheck.style then
				DBMRangeCheck:BuiStyle('Outside')
			end
		end
	end

	local function StyleInfoFrame(self, maxLines, event, ...)
		if DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end

		if DBMInfoFrame and not DBMInfoFrame.style then
			DBMInfoFrame:BuiStyle('Inside')
		end
	end

	hooksecurefunc(DBM.RangeCheck, 'Show', StyleRangeFrame)
	hooksecurefunc(DBM.InfoFrame, 'Show', StyleInfoFrame)
end

local function BugSackDecor()
	if not E.db.benikui.general.benikuiStyle then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if BugSackFrame.IsStyled then return end
		if not BugSackFrame.style then
			BugSackFrame:BuiStyle('Outside')
		end
		BugSackFrame.IsStyled = true
	end)
end

local function LibrariesDecor()
	if BUI:IsAddOnEnabled('TipTac') then return end
	local DBIcon = LibStub("LibDBIcon-1.0", true)
	if DBIcon and DBIcon.tooltip and DBIcon.tooltip:IsObjectType('GameTooltip') then
		DBIcon.tooltip:HookScript("OnShow", function(self)
			if not self.style then
				self:BuiStyle('Outside')
			end
		end)
	end
end

local function ZygorDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.zygor then return end

	_G['ZygorGuidesViewerFrame_Border']:BuiStyle('Outside')
end

local function ImmersionDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.immersion then return end
	local frame = _G['ImmersionFrame']
	frame.TalkBox.BackgroundFrame.backdrop:BuiStyle('Inside')
	frame.TalkBox.Hilite:SetOutside(frame.TalkBox.BackgroundFrame.backdrop)
	frame.TalkBox.Elements.backdrop:BuiStyle('Inside')

	if BUI.ShadowMode and AS:CheckOption('Shadows') then
		frame.TalkBox.BackgroundFrame.backdrop.Shadow:Hide()
		frame.TalkBox.Elements.backdrop.Shadow:Hide()
	end

	frame:HookScript('OnUpdate', function(self)
		for _, Button in ipairs(self.TitleButtons.Buttons) do
			if Button.backdrop and not Button.backdrop.isStyled then
				Button.backdrop:BuiStyle('Inside')
				Button.Hilite:SetOutside(Button.backdrop)
				if Button.backdrop.Shadow then
					Button.backdrop.Shadow:Hide()
				end
				Button.backdrop.isStyled = true
			end
		end
	end)
end

local function AllTheThingsDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.allthethings then return end
	for _, Instance in pairs({ 'Prime', 'CurrentInstance' }) do
		local Window = AllTheThings:GetWindow(Instance)
		Window:BuiStyle('Outside')
	end
end

local function TinyInspectDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.tinyinspect then return end
	TinyInspectRaidFrame:BuiStyle('Outside') -- not tested
	TinyInspectRaidFrame.panel:BuiStyle('Outside') -- not tested

	PaperDollFrame:HookScript("OnShow", function(self)
		if self.inspectFrame then
			if not self.inspectFrame.style then
				self.inspectFrame:BuiStyle('Outside')
			end
			self.inspectFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end)
end

local function ArkInventoryDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.arkinventory then return end
	hooksecurefunc(ArkInventory, 'Frame_Main_Paint', function(frame)
		if not ArkInventory.ValidFrame(frame, true) then return end
		if not frame.style then
			frame:BuiStyle('Outside')
		end
	end)
end

local function StorylineDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.storyline then return end
	_G.Storyline_NPCFrame:BuiStyle("Outside")
end

local function ClassTactics(event, addon)
	local CT = _G.ClassTactics[1]
	if not CT then return end

	hooksecurefunc(CT, 'TalentProfiles', function()
		if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.classTactics then return end
		
		AS:SkinBackdropFrame(CT.TalentsFrames)
		AS:SkinBackdropFrame(CT.TalentsFrames.PvPTalents)
		AS:SkinButton(CT.TalentsFrames.NewButton)
		AS:SkinButton(CT.TalentsFrames.PvPTalents.NewButton)
		AS:SkinButton(CT.TalentsFrames.ToggleButton)
		AS:SkinButton(CT.TalentsFrames.PvPTalents.ToggleButton)

		CT.TalentsFrames:SetPoint('TOPLEFT', _G.PlayerTalentFrame, 'TOPRIGHT', 2, 0)
		CT.TalentsFrames.TitleText:SetFont(CT.Libs.LSM:Fetch('font', 'Expressway'), 12, 'OUTLINE')
		CT.TalentsFrames.PvPTalents.TitleText:SetFont(CT.Libs.LSM:Fetch('font', 'Expressway'), 12, 'OUTLINE')
		CT.TalentsFrames:BuiStyle('Outside')
		CT.TalentsFrames.PvPTalents:BuiStyle('Outside')
	end)
	
end

local function HekiliDecor()
	local Hekili = _G.Hekili
	if not Hekili then return end

	hooksecurefunc(Hekili, "CreateButton", function(self, dispID, id)
		if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.hekili then return end
		local b = Hekili.DisplayPool[dispID].Buttons[id]
		if b and not b.backdrop then
			b:CreateBackdrop()
			b.backdrop:BuiStyle('Outside')
		end
	end)
end

local function WoWProDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.wowpro then return end
	local frame = _G['WoWPro.MainFrame']
	if not frame.style then
		frame:BuiStyle('Outside')
	end
end

-- Replace the close button
function AS:SkinCloseButton(Button, Reposition)
	if Button.backdrop then return end

	AS:SkinBackdropFrame(Button)

	Button.backdrop:Point('TOPLEFT', 7, -8)
	Button.backdrop:Point('BOTTOMRIGHT', -7, 8)
	Button.backdrop:SetTemplate('NoBackdrop')

	Button:SetHitRectInsets(6, 6, 7, 7)

	Button.backdrop.img = Button.backdrop:CreateTexture(nil, 'OVERLAY')
	Button.backdrop.img:Size(12, 12)
	Button.backdrop.img:Point("CENTER")
	Button.backdrop.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Close.tga')
	Button.backdrop.img:SetVertexColor(1, 1, 1)

	Button:HookScript('OnEnter', function(self)
		self.backdrop.img:SetVertexColor(1, .2, .2)
		if E.myclass == 'PRIEST' then
			self.backdrop.img:SetVertexColor(unpack(E["media"].rgbvaluecolor))
			self.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
		else
			self.backdrop.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
			self.backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b)
		end
	end)

	Button:HookScript('OnLeave', function(self)
		self.backdrop.img:SetVertexColor(1, 1, 1)
		self.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	end)

	if Reposition then
		Button:Point('TOPRIGHT', Reposition, 'TOPRIGHT', 2, 2)
	end
end

if AS:CheckAddOn('Skada') then AS:RegisterSkin('Skada', SkadaDecor, 2) end
if AS:CheckAddOn('Recount') then AS:RegisterSkin('Recount', RecountDecor, 2) end
if AS:CheckAddOn('TinyDPS') then AS:RegisterSkin('TinyDPS', TinyDPSDecor, 2) end
if AS:CheckAddOn('AtlasLoot') then AS:RegisterSkin('AtlasLoot', AtlasLootDecor, 2) end
if AS:CheckAddOn('Altoholic') then AS:RegisterSkin('Altoholic', AltoholicDecor, 2) end
if AS:CheckAddOn('Clique') then AS:RegisterSkin('Clique', CliqueDecor, 2) end
if AS:CheckAddOn('oRA3') then AS:RegisterSkin('oRA3', oRA3Decor, 2) end
if AS:CheckAddOn('Pawn') then AS:RegisterSkin('Pawn', PawnDecor, 2) end
if (AS:CheckAddOn('DBM-Core') and AS:CheckAddOn('DBM-StatusBarTimers')) then AS:RegisterSkin('DBM-Core', DbmDecor, 'ADDON_LOADED') end
if AS:CheckAddOn('BugSack') then AS:RegisterSkin('BugSack', BugSackDecor, 2) end
if AS:CheckAddOn('ZygorGuidesViewer') then AS:RegisterSkin('Zygor', ZygorDecor, 2) end
if AS:CheckAddOn('Immersion') then AS:RegisterSkin('Immersion', ImmersionDecor, 2) end
if AS:CheckAddOn('AllTheThings') then AS:RegisterSkin('AllTheThings', AllTheThingsDecor, 2) end
if AS:CheckAddOn('TinyInspect') then AS:RegisterSkin('TinyInspect', TinyInspectDecor, 2) end
if AS:CheckAddOn('ArkInventory') then AS:RegisterSkin('ArkInventory', ArkInventoryDecor, 2) end
if AS:CheckAddOn('Storyline') then AS:RegisterSkin('Storyline', StorylineDecor, 2) end
if AS:CheckAddOn('ClassTactics') then AS:RegisterSkin('ClassTactics', ClassTactics, 'ADDON_LOADED') end
if AS:CheckAddOn('Hekili') then AS:RegisterSkin('Hekili', HekiliDecor, 2) end
if AS:CheckAddOn('WoWPro') then AS:RegisterSkin('WoWPro', WoWProDecor, 2) end

--if BUI.CT then ClassTactics() end
LibrariesDecor()
