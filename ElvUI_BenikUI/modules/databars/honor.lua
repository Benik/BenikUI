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
local HONOR = HONOR
local MAX_PLAYER_LEVEL = 110

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
	GameTooltip:AddLine(HONOR, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local bar = ElvUI_HonorBar
	
	-- bottom decor/button
	bar.fb = CreateFrame('Button', nil, bar)
	bar.fb:CreateSoftGlow()
	bar.fb.sglow:Hide()
	if E.db.benikui.general.shadows then
		bar.fb:CreateShadow('Default')
		bar.fb:Point('TOPLEFT', bar, 'BOTTOMLEFT', 0, (E.PixelMode and -SPACING -2 or -SPACING))
		bar.fb:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, -22)
	else
		bar.fb:Point('TOPLEFT', bar, 'BOTTOMLEFT', 0, -SPACING)
		bar.fb:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))
	end
	bar.fb:SetScript('OnEnter', onEnter)
	bar.fb:SetScript('OnLeave', onLeave)
	
	bar.fb:SetScript('OnClick', function(self)
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
			_G["PlayerTalentFrameTab"..PVP_TALENTS_TAB]:Click()
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end)
	
	BDB:ToggleHonorBackdrop()
	
	if E.db.benikui.general.benikuiStyle ~= true then return end
	bar:Style('Outside', nil, false, true)
end

function BDB:ApplyHonorStyling()
	local bar = ElvUI_HonorBar
	if E.db.databars.honor.enable then
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

function BDB:ChangeHonorColor()
	local bar = ElvUI_HonorBar
	local db = E.db.benikuiDatabars.honor.color
	
	if db.default then
		bar.statusBar:SetStatusBarColor(0.941, 0.447, 0.254, 0.8)
	else
		bar.statusBar:SetStatusBarColor(BUI:unpackColor(db.hn))
	end
end

function BDB:ToggleHonorBackdrop()
	if E.db.benikuiDatabars.honor.enable ~= true then return end
	local bar = ElvUI_HonorBar
	local db = E.db.benikuiDatabars.honor

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

function BDB:UpdateHonorNotifierPositions()
	local bar = ElvUI_HonorBar.statusBar
	
	local db = E.db.benikuiDatabars.honor.notifiers
	local arrow = ""
	
	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.databars.honor.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.databars.honor.reverseFill then
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
	
	if E.db.databars.honor.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function BDB:UpdateHonorNotifier()
	local bar = ElvUI_HonorBar.statusBar
	local showHonor = UnitLevel("player") >= MAX_PLAYER_LEVEL
	if not showHonor then
		bar.f:Hide()
	elseif showHonor and (not E.db.databars.honor.hideInCombat or not InCombatLockdown()) then
		bar.f:Show()
		local text = ''
		local current = UnitHonor("player");
		local max = UnitHonorMax("player");
		local level = UnitHonorLevel("player");
        local levelmax = GetMaxPlayerHonorLevel();

		if max == 0 then max = 1 end

		if (CanPrestige()) then
			text = 'P'
		elseif (level == levelmax) then
			text = 'Max'
		else
			text = format('%d%%', current / max * 100)
		end
		bar.f.txt:SetText(text)
	end
end

function BDB:HonorTextOffset()
	local text = ElvUI_ExperienceBar.text
	text:Point('CENTER', 0, E.db.databars.experience.textYoffset)
end

function BDB:LoadHonor()
	self:ChangeHonorColor()
	self:HonorTextOffset()
	hooksecurefunc(M, 'UpdateHonor', BDB.ChangeHonorColor)
	hooksecurefunc(M, 'UpdateHonor', BDB.HonorTextOffset)
	
	local db = E.db.benikuiDatabars.honor.notifiers
	
	if db.enable and E.db.databars.honor.orientation == 'VERTICAL' then
		self:CreateNotifier(ElvUI_HonorBar.statusBar)
		self:UpdateHonorNotifierPositions()
		self:UpdateHonorNotifier()
		hooksecurefunc(M, 'UpdateHonor', BDB.UpdateHonorNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BDB.UpdateHonorNotifierPositions)
		hooksecurefunc(M, 'UpdateHonorDimensions', BDB.UpdateHonorNotifierPositions)
	end
	
	if E.db.benikuiDatabars.honor.enable ~= true then return end
	
	StyleBar()
	self:ApplyHonorStyling()
	
	hooksecurefunc(M, 'UpdateHonorDimensions', BDB.ApplyHonorStyling)
end
