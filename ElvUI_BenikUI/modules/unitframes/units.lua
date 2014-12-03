local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:NewModule('BuiUnits', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
UF.LSM = LSM

if E.db.ufb == nil then E.db.ufb = {} end

local unitfs = {"Player", "Target", "TargetTarget", "Pet", "Focus", "FocusTarget"}

function UFB:Update_PowerStatusBar(unit)
	-- Units
	for _, frame in pairs(unitfs) do 
		local self = _G["ElvUF_"..frame]
		local unit = string.lower(frame)
		local power = self.Power
		
		power:SetStatusBarTexture(LSM:Fetch("statusbar", E.db.ufb.powerstatusbar))
	end
end

function UFB:UnitDefaults()
	if E.db.ufb.barheight == nil then
		E.db.ufb.barheight = 20
	end
	if E.db.ufb.PlayerPortraitWidth == nil then
		E.db.ufb.PlayerPortraitWidth = 110
	end	
	if E.db.ufb.PlayerPortraitHeight == nil then
		E.db.ufb.PlayerPortraitHeight = 85
	end	
	if E.db.ufb.TargetPortraitWidth == nil then
		E.db.ufb.TargetPortraitWidth = 110
	end	
	if E.db.ufb.TargetPortraitHeight == nil then
		E.db.ufb.TargetPortraitHeight = 85
	end
end

function UFB:Initialize()
	if E.private.unitframe.enable ~= true then return end
	self:UnitDefaults()
	self:InitPlayer()
	self:InitTarget()
	hooksecurefunc(UF, 'Update_AllFrames', UFB.Update_PowerStatusBar)
	hooksecurefunc(UF, 'Update_StatusBars', UFB.Update_PowerStatusBar)
end

E:RegisterModule(UFB:GetName())