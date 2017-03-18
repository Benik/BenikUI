local E, L, V, P, G = unpack(ElvUI);
local BDB = E:GetModule('BenikUI_databars');
local BUI = E:GetModule('BenikUI');
local M = E:GetModule('DataBars');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');

local _G = _G

local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local InCombatLockdown = InCombatLockdown
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel
local ARTIFACT_POWER = ARTIFACT_POWER

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ArtifactBar, ArtifactFrame

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	self.sglow:Hide()
	GameTooltip:Hide()
end

local function onEnter(self)
	if self.template == 'NoBackdrop' then return end
	self.sglow:Show()
	GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(ARTIFACT_POWER, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local bar = ElvUI_ArtifactBar
	
	-- bottom decor/button
	bar.fb = CreateFrame('Button', nil, bar)
	bar.fb:CreateSoftGlow()
	bar.fb.sglow:Hide()
	if E.db.benikui.general.shadows then
		bar.fb:CreateShadow('Default')
	end
	bar.fb:Point('TOPLEFT', bar, 'BOTTOMLEFT', 0, -SPACING)
	bar.fb:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))
	bar.fb:SetScript('OnEnter', onEnter)
	bar.fb:SetScript('OnLeave', onLeave)
	
	bar.fb:SetScript('OnClick', function(self)
		if not _G["ArtifactFrame"] or not _G["ArtifactFrame"]:IsShown() then
			ShowUIPanel(SocketInventoryItem(16))
		elseif _G["ArtifactFrame"] and _G["ArtifactFrame"]:IsShown() then
			HideUIPanel(ArtifactFrame)
		end
	end)
	
	BDB:ToggleAFBackdrop()
	
	if E.db.benikui.general.benikuiStyle ~= true then return end
	bar:Style('Outside', nil, false, true)
end

function BDB:ApplyAfStyling()
	local bar = ElvUI_ArtifactBar
	if E.db.databars.artifact.enable then
		if bar.fb then
			if E.db.databars.artifact.orientation == 'VERTICAL' then
				bar.fb:Show()
			else
				bar.fb:Hide()
			end
		end
	end	
	
	if E.db.benikuiDatabars.artifact.buiStyle then
		if bar.style then
			bar.style:Show()
		end
	else
		if bar.style then
			bar.style:Hide()	
		end
	end
end

function BDB:ChangeAFcolor()
	local bar = ElvUI_ArtifactBar
	local db = E.db.benikuiDatabars.artifact.color
	
	if db.default then
		bar.statusBar:SetStatusBarColor(.901, .8, .601, .8)
	else
		bar.statusBar:SetStatusBarColor(BUI:unpackColor(db.af))
	end
end

function BDB:ToggleAFBackdrop()
	if E.db.benikuiDatabars.artifact.enable ~= true then return end
	local bar = ElvUI_ArtifactBar
	local db = E.db.benikuiDatabars.artifact

	if bar.fb then
		if db.buttonStyle == 'DEFAULT' then
			bar.fb:SetTemplate('Default', true)
		elseif db.buttonStyle == 'TRANSPARENT' then
			bar.fb:SetTemplate('Transparent')
		else
			bar.fb:SetTemplate('NoBackdrop')
		end
	end
end

function BDB:UpdateAfNotifierPositions()
	local bar = ElvUI_ArtifactBar.statusBar
	local bagbar = ElvUI_ArtifactBar.bagValue
	
	local db = E.db.benikuiDatabars.artifact.notifiers
	local apInBags = ElvUI_ArtifactBar.BagArtifactPower
	local arrow = ""
	
	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.databars.artifact.reverseFill then
			if db.movetobagbar and apInBags > 0 then
				bar.f.arrow:Point('RIGHT', bagbar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
			else
				bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
			end
		else
			if db.movetobagbar and apInBags > 0 then
				bar.f.arrow:Point('RIGHT', bagbar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
			else
				bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
			end
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.databars.artifact.reverseFill then
			if db.movetobagbar and apInBags > 0 then
				bar.f.arrow:Point('LEFT', bagbar:GetStatusBarTexture(), 'TOPRIGHT', E.PixelMode and 2 or 4, 1)
			else
				bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'TOPRIGHT', E.PixelMode and 2 or 4, 1)
			end
		else
			if db.movetobagbar and apInBags > 0 then
				bar.f.arrow:Point('LEFT', bagbar:GetStatusBarTexture(), 'BOTTOMRIGHT', E.PixelMode and 2 or 4, 1)
			else
				bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'BOTTOMRIGHT', E.PixelMode and 2 or 4, 1)
			end
		end
		bar.f:Point('LEFT', bar.f.arrow, 'RIGHT')
		bar.f.txt:Point('LEFT', bar.f, 'RIGHT')
		arrow = "<"
	end
	
	bar.f.arrow:SetText(arrow)
	bar.f.txt:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)

	if db.movetobagbar and apInBags > 0 then
		bar.f.txt:SetTextColor(0, 0.75, 0.98)
	else
		bar.f.txt:SetTextColor(1, 1, 1)
	end

	if E.db.databars.artifact.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function BDB:UpdateAfNotifier()
	local bar = ElvUI_ArtifactBar.statusBar
	local db = E.db.benikuiDatabars.artifact.notifiers
	local showArtifact = HasArtifactEquipped();
	if not showArtifact then
		bar.f:Hide()
	else
		bar.f:Show()
		local _, _, _, _, totalXP, pointsSpent = C_ArtifactUI.GetEquippedArtifactInfo();
		local _, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP);
		local apInBags = ElvUI_ArtifactBar.BagArtifactPower
		
		if db.movetobagbar and apInBags > 0 then
			bar.f.txt:SetFormattedText('%d%%',(xp / xpForNextPoint * 100) + (apInBags / xpForNextPoint * 100))
		else
			bar.f.txt:SetFormattedText('%d%%', xp / xpForNextPoint * 100)
		end
		BDB.UpdateAfNotifierPositions()
	end
end

function BDB:AfTextOffset()
	local text = ElvUI_ArtifactBar.text
	text:Point('CENTER', 0, E.db.databars.artifact.textYoffset)
end

function BDB:LoadAF()
	self:ChangeAFcolor()
	self:AfTextOffset()
	hooksecurefunc(M, 'UpdateArtifact', BDB.ChangeAFcolor)
	hooksecurefunc(M, 'UpdateArtifact', BDB.AfTextOffset)
	
	local db = E.db.benikuiDatabars.artifact.notifiers
	
	if db.enable and E.db.databars.artifact.orientation == 'VERTICAL' then
		self:CreateNotifier(ElvUI_ArtifactBar.statusBar)
		self:UpdateAfNotifierPositions()
		self:UpdateAfNotifier()
		hooksecurefunc(M, 'UpdateArtifact', BDB.UpdateAfNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BDB.UpdateAfNotifierPositions)
		hooksecurefunc(M, 'UpdateArtifactDimensions', BDB.UpdateAfNotifierPositions)
	end
	
	if E.db.benikuiDatabars.artifact.enable ~= true then return end
	
	StyleBar()
	self:ApplyAfStyling()
	
	hooksecurefunc(M, 'UpdateArtifactDimensions', BDB.ApplyAfStyling)
end