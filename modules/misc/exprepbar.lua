local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local M = E:GetModule('Misc');
local BXR = E:NewModule('BUIExpRep')
local LSM = LibStub("LibSharedMedia-3.0")

function BXR:CreateXPStatus()
	if E.db.xprep.show == 'XP' and UnitLevel('player') ~= MAX_PLAYER_LEVEL and E.db.general.experience.enable and not IsXPUserDisabled() then
		local PlayerBar = BUI_PlayerBar
		
		local xp = ElvUI_ExperienceBar.statusBar
		xp:ClearAllPoints()
		xp:SetParent(PlayerBar)
		xp:SetInside(PlayerBar)
		xp:SetStatusBarTexture(E.media.BuiFlat)
		xp:SetAlpha(0.6)
		xp:Hide()
		
		local rested = ElvUI_ExperienceBar.rested
		rested:ClearAllPoints()
		rested:SetParent(PlayerBar)
		rested:SetInside(PlayerBar)
		rested:SetStatusBarTexture(E.media.BuiFlat)
		rested:Hide()
		
		BXR:ShowHideXpText()
		ElvUI_ExperienceBar:Hide()
		ElvUI_ExperienceBar:SetAlpha(0)
	end
end

function BXR:CreateRepStatus()
	local name = GetWatchedFactionInfo()
	if E.db.xprep.show == 'REP' and E.db.general.reputation.enable and name then
		local PlayerBar = BUI_PlayerBar
		
		local reps = ElvUI_ReputationBar.statusBar
		reps:ClearAllPoints()
		reps:SetParent(PlayerBar)
		reps:SetInside(PlayerBar)
		reps:SetStatusBarTexture(E.media.BuiFlat)
		reps:SetAlpha(0.6)
		reps:Hide()	
		
		BXR:ShowHideRepText()
		ElvUI_ReputationBar:Hide()
		ElvUI_ReputationBar:SetAlpha(0)
	end
end

function BXR:RevertXpRep()
	if E.db.xprep.show == 'NONE' then
		if UnitLevel('player') ~= MAX_PLAYER_LEVEL and E.db.general.experience.enable and not IsXPUserDisabled() then
			ElvUI_ExperienceBar:Show()
			ElvUI_ExperienceBar:SetAlpha(1)
			if E.db.general.experience.textFormat ~= 'NONE' then ElvUI_ExperienceBar.text:Show() end
			
			local xp = ElvUI_ExperienceBar.statusBar
			xp:ClearAllPoints()
			xp:SetParent(ElvUI_ExperienceBar)
			xp:SetInside(ElvUI_ExperienceBar)
			xp:SetAlpha(0.8)
			xp:Show()
			
			local rested = ElvUI_ExperienceBar.rested
			rested:ClearAllPoints()
			rested:SetParent(ElvUI_ExperienceBar)
			rested:SetInside(ElvUI_ExperienceBar)
			rested:Show()
			
			BXR:ShowHideXpText()
		end
		ElvUI_ReputationBar:Show()
		ElvUI_ReputationBar:SetAlpha(1)
		if E.db.general.reputation.textFormat ~= 'NONE' then ElvUI_ReputationBar.text:Show() end
		
		local reps = ElvUI_ReputationBar.statusBar
		reps:ClearAllPoints()
		reps:SetParent(ElvUI_ReputationBar)
		reps:SetInside(ElvUI_ReputationBar)
		reps:SetAlpha(1)
		reps:Show()
		
		BXR:ShowHideRepText()
		M:EnableDisable_ReputationBar()
		M:EnableDisable_ExperienceBar()
	end
end

function BXR:ShowHideXpText()
	if E.db.xprep.text then
		if E.db.xprep.show == 'XP' then
			ElvUI_ExperienceBar.text:Hide()
		else
			ElvUI_ExperienceBar.text:Show()
		end
	end
end

function BXR:ShowHideRepText()
	local name = GetWatchedFactionInfo()
	if E.db.xprep.text and name then
		if E.db.xprep.show == 'REP' then
			ElvUI_ReputationBar.text:Hide()
		else
			ElvUI_ReputationBar.text:Show()
		end
	end
end

function BXR:ChangeRepXpFont()
	if E.db.xprep.textStyle == 'DATA' then
		ElvUI_ReputationBar.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		ElvUI_ExperienceBar.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	elseif E.db.xprep.textStyle == 'UNIT' then
		ElvUI_ReputationBar.text:FontTemplate(LSM:Fetch("font", E.db.unitframe.font), E.db.unitframe.fontSize, E.db.unitframe.fontOutline)
		ElvUI_ExperienceBar.text:FontTemplate(LSM:Fetch("font", E.db.unitframe.font), E.db.unitframe.fontSize, E.db.unitframe.fontOutline)
	else
		ElvUI_ReputationBar.text:FontTemplate(nil, E.db.general.reputation.textSize)
		ElvUI_ExperienceBar.text:FontTemplate(nil, E.db.general.experience.textSize)
	end
end

local function CheckBars()
	if E.db.xprep.show == 'REP' then
		BXR:CreateRepStatus()
	elseif E.db.xprep.show == 'XP' then
		BXR:CreateXPStatus()
	else
		BXR:RevertXpRep()
	end
end

function BXR:Initialize()
	CheckBars()
	hooksecurefunc(M, 'EnableDisable_ExperienceBar', BXR.CreateXPStatus)
	hooksecurefunc(M, 'EnableDisable_ReputationBar', BXR.CreateRepStatus)
	self:ShowHideXpText()
	self:ShowHideRepText()
	self:ChangeRepXpFont()
end

E:RegisterModule(BXR:GetName())