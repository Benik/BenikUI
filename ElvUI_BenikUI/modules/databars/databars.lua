local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars')
local S = E:GetModule('Skins')
local LSM = E.LSM

local SPACING = (E.PixelMode and 1 or 3)

function mod:CreateNotifier(bar)
	bar.f = CreateFrame('Frame', nil, bar)
	bar.f:Size(2, 10)
	bar.f.txt = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow = bar.f:CreateTexture(nil, 'OVERLAY')
	bar.f.arrow:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\arrowOutlined.tga')
	bar.f.arrow:SetVertexColor(1, 1, 1)
	bar.f.arrow:Size(13, 13)
end

function mod:UpdateNotifierPositions(bar, option)
	local db = E.db.benikui.databars[option].notifiers

	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if E.db.databars[option].orientation == 'VERTICAL' then
		if db.position == 'LEFT' then
			if not E.db.databars[option].reverseFill then
				bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and -1 or 1, 0)
			else
				bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and -1 or 1, 0)
			end
			bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
			bar.f.txt:Point('RIGHT', bar.f, 'LEFT', 2, 1)
			bar.f.arrow:SetRotation(S.ArrowRotation.left)
		elseif db.position == 'RIGHT' then
			if not E.db.databars[option].reverseFill then
				bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'TOPRIGHT', E.PixelMode and 1 or 3, 0)
			else
				bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'BOTTOMRIGHT', E.PixelMode and 1 or 3, 0)
			end
			bar.f:Point('LEFT', bar.f.arrow, 'RIGHT')
			bar.f.txt:Point('LEFT', bar.f, 'RIGHT', -2, 1)
			bar.f.arrow:SetRotation(S.ArrowRotation.right)
		end
	else
		if db.position == 'ABOVE' then
			if not E.db.databars[option].reverseFill then
				bar.f.arrow:Point('BOTTOM', bar:GetStatusBarTexture(), 'TOPRIGHT')
			else
				bar.f.arrow:Point('BOTTOM', bar:GetStatusBarTexture(), 'TOPLEFT')
			end
			bar.f:Point('BOTTOM', bar.f.arrow, 'TOP')
			bar.f.txt:Point('BOTTOM', bar.f, 'TOP', 4, -10)
			bar.f.arrow:SetRotation(S.ArrowRotation.up)
		elseif db.position == 'BELOW' then
			if not E.db.databars[option].reverseFill then
				bar.f.arrow:Point('TOP', bar:GetStatusBarTexture(), 'BOTTOMRIGHT')
			else
				bar.f.arrow:Point('TOP', bar:GetStatusBarTexture(), 'BOTTOMLEFT')
			end
			bar.f:Point('TOP', bar.f.arrow, 'BOTTOM')
			bar.f.txt:Point('TOP', bar.f, 'BOTTOM', 4, 10)
			bar.f.arrow:SetRotation(S.ArrowRotation.down)
		end
	end
	
	local toggleCondition = not (E.db.databars[option].orientation == 'VERTICAL' and (db.position == 'ABOVE' or db.position == 'BELOW')) or
		(E.db.databars[option].orientation == 'HORIZONTAL' and (db.position == 'LEFT' or db.position == 'RIGHT'))
	bar.f.arrow:SetShown(toggleCondition)
	bar.f.txt:SetShown(toggleCondition)
	bar.f.txt:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
end

function mod:ToggleBackdrop(bar, option)
	local db = E.db.benikui.databars[option]
	
	if bar.fb then
		if db.buttonStyle == 'DEFAULT' then
			bar.fb:SetTemplate('Default', true)
			if bar.fb.shadow then
				bar.fb.shadow:Show()
			end
		elseif db.buttonStyle == 'TRANSPARENT' then
			bar.fb:SetTemplate('Transparent')
			if bar.fb.shadow then
				bar.fb.shadow:Show()
			end
		else
			bar.fb:SetTemplate('NoBackdrop')
			if bar.fb.shadow then
				bar.fb.shadow:Hide()
			end
		end
	end
end

function mod:ApplyStyle(bar, option)
	if E.db.databars[option].enable then
		if bar.fb then
			bar.fb:SetShown(E.db.databars[option].orientation == 'VERTICAL')
		end
	end

	if bar.holder.style then
		bar.holder.style:SetShown(E.db.benikui.databars[option].buiStyle)
	end
end

function mod:StyleBar(bar, onClick)
	bar.fb = CreateFrame('Button', nil, bar, 'BackdropTemplate')
	bar.fb:Point('TOPLEFT', bar.holder, 'BOTTOMLEFT', 0, -SPACING)
	bar.fb:Point('BOTTOMRIGHT', bar.holder, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))

	bar.fb:SetScript('OnClick', onClick)

	if BUI.ShadowMode then
		bar.fb:CreateSoftShadow()
	end

	if E.db.benikui.general.benikuiStyle ~= true then return end
	bar.holder:BuiStyle('Outside', nil, false, true)
end

function mod:Initialize()
	self:LoadXP()
	self:LoadRep()
	self:LoadAzerite()
	self:LoadHonor()
	self:LoadThreat()
end

BUI:RegisterModule(mod:GetName())
