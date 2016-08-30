local E, L, V, P, G = unpack(ElvUI);
local BDB = E:GetModule('BenikUI_databars');
local BUI = E:GetModule('BenikUI');
local M = E:GetModule('DataBars');
local LO = E:GetModule('Layout');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');
local BUIL = E:GetModule('BuiLayout');

--local ArtifactFrame = _G["ArtifactFrame"]

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	self.sglow:Hide()
	GameTooltip:Hide()
end

local function ToggleBackdrop()
	local bar = ElvUI_ArtifactBar
	if E.db.benikuiDatabars.artifact.enable then
		if not E.db.benikui.datatexts.chat.backdrop then
			if bar.fb then
				bar.fb:SetTemplate('NoBackdrop')
			end
		else
			if E.db.benikui.datatexts.chat.transparent or E.db.datatexts.panelTransparency then
				if bar.fb then
					bar.fb:SetTemplate('Transparent')
				end
			else
				if bar.fb then
					bar.fb:SetTemplate('Default', true)
				end
			end
		end
	end
end

local function StyleBar()
	local bar = ElvUI_ArtifactBar
	
	-- bottom decor/button
	bar.fb = CreateFrame('Button', nil, bar)
	bar.fb:CreateSoftGlow()
	bar.fb.sglow:Hide()
	bar.fb:Point('TOPLEFT', bar, 'BOTTOMLEFT', 0, -SPACING)
	bar.fb:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))
	bar.fb:SetScript('OnEnter', function(self)
		self.sglow:Show()
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(ARTIFACT_POWER, selectioncolor)
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)
	
	bar.fb:SetScript('OnLeave', onLeave)
	
	bar.fb:SetScript('OnClick', function(self)
		if not ArtifactFrame or not ArtifactFrame:IsShown() then
			ShowUIPanel(SocketInventoryItem(16))
		elseif ArtifactFrame and ArtifactFrame:IsShown() then
			HideUIPanel(ArtifactFrame)
		end
	end)
	
	ToggleBackdrop()
	
	if E.db.benikui.general.benikuiStyle ~= true then return end
	bar:Style('Outside')
end

function BDB:ApplyAfStyling()
	local bar = ElvUI_ArtifactBar
	if E.db.databars.artifact.enable then
		if bar.fb then
			if E.db.databars.artifact.orientation == 'VERTICAL' then
				if E.db.benikui.datatexts.chat.enable then 
					bar.fb:Show()
				else
					bar.fb:Hide()
				end
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

function BDB:UpdateAfNotifierPositions()
	local bar = ElvUI_ArtifactBar.statusBar
	
	local db = E.db.benikuiDatabars.artifact.notifiers
	local arrow = ""
	
	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.databars.artifact.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.databars.artifact.reverseFill then
			bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'TOPRIGHT', E.PixelMode and 2 or 4, 1)
		else
			bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'BOTTOMRIGHT', E.PixelMode and 2 or 4, 1)
		end
		bar.f:Point('LEFT', bar.f.arrow, 'RIGHT')
		bar.f.txt:Point('LEFT', bar.f, 'RIGHT')
		arrow = "<"
	end
	
	bar.f.arrow:SetText(arrow)
	bar.f.txt:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	
	if E.db.databars.artifact.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function BDB:UpdateAfNotifier()
	local bar = ElvUI_ArtifactBar.statusBar
	local showArtifact = HasArtifactEquipped();
	if not showArtifact then
		bar.f:Hide()
	else
		bar.f:Show()
		local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo();
		local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP);
		bar.f.txt:SetFormattedText('%d%%', xp / xpForNextPoint * 100)
	end
end

function BDB:LoadAF()
	self:ChangeAFcolor()
	hooksecurefunc(M, 'UpdateArtifact', BDB.ChangeAFcolor)
	
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
	
	hooksecurefunc(BUIL, 'ToggleTransparency', ToggleBackdrop)
	hooksecurefunc(LO, 'ToggleChatPanels', BDB.ApplyAfStyling)
	hooksecurefunc(LO, 'SetDataPanelStyle', ToggleBackdrop)
	hooksecurefunc(M, 'UpdateArtifactDimensions', BDB.ApplyAfStyling)
end