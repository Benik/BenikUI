local BUI, E, L, V, P, G = unpack((select(2, ...)))

local _G = _G
local unpack = unpack
local S = E:GetModule('Skins')

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local next = next

local CreateFrame = CreateFrame

local classColor = E:ClassColor(E.myclass, true)

local function SkadaDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.skada then return end
	hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(self, win)
		local skada = win.bargroup
		skada.backdrop:BuiStyle()
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
			_G["tdpsFrame"]:BuiStyle()
		end
	end
end

local function AtlasLootDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.atlasloot then return end
	local AtlasLootFrame = _G["AtlasLoot_GUI-Frame"]
	if AtlasLootFrame then
		if not AtlasLootFrame.style then
			AtlasLootFrame:BuiStyle()
		end
	end
end

local function AltoholicDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.altoholic then return end
	if _G["AltoholicFrame"] then
		if not _G["AltoholicFrame"].style then
			_G["AltoholicFrame"]:BuiStyle()
		end
	end
end

local function CliqueDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.clique then return end
	_G["CliqueConfig"].backdrop:BuiStyle()
	_G["CliqueDialog"].backdrop:BuiStyle()
	local tab = _G["CliqueSpellTab"]
	if not tab.style then
		tab:BuiStyle('Inside')
		tab.style:SetFrameLevel(5)
	end
	tab:GetNormalTexture():SetTexCoord(.08, 0.92, 0.08, 0.92)
end

local function oRA3Decor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.ora then return end
	hooksecurefunc(oRA3, "ToggleFrame", function() _G["oRA3Frame"].backdrop:BuiStyle(); end)

	local ReadyCheckModule = oRA3:GetModule("ReadyCheck")
	if (ReadyCheckModule) then
		hooksecurefunc(ReadyCheckModule, "READY_CHECK", function() _G["oRA3ReadyCheck"].backdrop:BuiStyle(); end)
	end
end

local function BugSack()
	local BugSack = _G.BugSack
	if not BugSack then return end

	hooksecurefunc(BugSack, "OpenSack", function()
		if _G.BugSackFrame.IsSkinned then return end

		local frame = _G.BugSackFrame
		S:HandleFrame(frame)

		local tabs = { _G.BugSackTabAll, _G.BugSackTabSession, _G.BugSackTabLast }
		for _, tab in next, tabs do
			S:HandleTab(tab)
			if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
				tab.backdrop:CreateSoftShadow()
			end
		end

		_G.BugSackTabAll:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")

		local buttons = { _G.BugSackNextButton, _G.BugSackSendButton, _G.BugSackPrevButton }
		for _, button in next, buttons do
			S:HandleButton(button)
		end

		S:HandleScrollBar(_G.BugSackScrollScrollBar)
			if not frame.style then
				frame:BuiStyle()
			end

		for _, child in pairs({frame:GetChildren()}) do
			if (child:IsObjectType('Button') and child:GetScript('OnClick') == BugSack.CloseSack) then
				S:HandleCloseButton(child)
				break
			end
		end
		_G.BugSackFrame.IsSkinned = true
	end)
end
S:AddCallback("BenikUI_BugSackSkin", BugSack)

local function LibDBIcon()
	if BUI:IsAddOnEnabled('TipTac') then return end

	local DBIcon = LibStub("LibDBIcon-1.0", true)
	if DBIcon and DBIcon.tooltip and DBIcon.tooltip:IsObjectType('GameTooltip') then
		DBIcon.tooltip:HookScript("OnShow", function(self)
			if not self.style then
				self:BuiStyle()
			end
		end)
	end
end
S:AddCallback("BenikUI_LibDBIcon", LibDBIcon)

local function ZygorDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.zygor then return end

	_G['ZygorGuidesViewerFrame_Border']:BuiStyle()
end

local function ImmersionDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.immersion then return end
	local frame = _G['ImmersionFrame']
	frame.TalkBox.BackgroundFrame.backdrop:BuiStyle('Inside')
	frame.TalkBox.Hilite:SetOutside(frame.TalkBox.BackgroundFrame.backdrop)
	frame.TalkBox.Elements.backdrop:BuiStyle('Inside')

	if E.db.benikui.general.shadows and AS:CheckOption('Shadows') then
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

local function TinyInspectDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.tinyinspect then return end
	TinyInspectRaidFrame:BuiStyle() -- not tested
	TinyInspectRaidFrame.panel:BuiStyle() -- not tested

	PaperDollFrame:HookScript("OnShow", function(self)
		if self.inspectFrame then
			if not self.inspectFrame.style then
				self.inspectFrame:BuiStyle()
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
			frame:BuiStyle()
		end
	end)
end

local function StorylineDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.storyline then return end
	_G.Storyline_NPCFrame:BuiStyle()
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
		CT.TalentsFrames:BuiStyle()
		CT.TalentsFrames.PvPTalents:BuiStyle()
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
			b.backdrop:BuiStyle()
		end
	end)
end

local function WoWProDecor()
	if not E.db.benikui.general.benikuiStyle or not E.db.benikui.skins.addonSkins.wowpro then return end
	local frame = _G['WoWPro.MainFrame']
	if not frame.style then
		frame:BuiStyle()
	end
end

--if AS:CheckAddOn('Skada') then AS:RegisterSkin('Skada', SkadaDecor, 2) end
--if AS:CheckAddOn('Recount') then AS:RegisterSkin('Recount', RecountDecor, 2) end
--if AS:CheckAddOn('TinyDPS') then AS:RegisterSkin('TinyDPS', TinyDPSDecor, 2) end
--if AS:CheckAddOn('AtlasLoot') then AS:RegisterSkin('AtlasLoot', AtlasLootDecor, 2) end
--if AS:CheckAddOn('Altoholic') then AS:RegisterSkin('Altoholic', AltoholicDecor, 2) end
--if AS:CheckAddOn('Clique') then AS:RegisterSkin('Clique', CliqueDecor, 2) end
--if AS:CheckAddOn('oRA3') then AS:RegisterSkin('oRA3', oRA3Decor, 2) end
--if AS:CheckAddOn('Pawn') then AS:RegisterSkin('Pawn', PawnDecor, 2) end

--if AS:CheckAddOn('ZygorGuidesViewer') then AS:RegisterSkin('Zygor', ZygorDecor, 2) end
--if AS:CheckAddOn('Immersion') then AS:RegisterSkin('Immersion', ImmersionDecor, 2) end

--if AS:CheckAddOn('TinyInspect') then AS:RegisterSkin('TinyInspect', TinyInspectDecor, 2) end
--if AS:CheckAddOn('ArkInventory') then AS:RegisterSkin('ArkInventory', ArkInventoryDecor, 2) end
--if AS:CheckAddOn('Storyline') then AS:RegisterSkin('Storyline', StorylineDecor, 2) end
--if AS:CheckAddOn('ClassTactics') then AS:RegisterSkin('ClassTactics', ClassTactics, 'ADDON_LOADED') end
--if AS:CheckAddOn('Hekili') then AS:RegisterSkin('Hekili', HekiliDecor, 2) end
--if AS:CheckAddOn('WoWPro') then AS:RegisterSkin('WoWPro', WoWProDecor, 2) end

--if BUI.CT then ClassTactics() end

