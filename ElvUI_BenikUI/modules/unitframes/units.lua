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

-- EmptyBar creation
function UFB:CreateEmptyBar(frame)
	local emptybar = CreateFrame('Frame', nil, frame)
	emptybar:SetFrameStrata('BACKGROUND')
	
	return emptybar
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
	self:InitParty()
	--if E.db.unitframe.units.party.portrait.rotation == nil then
		--E.db.unitframe.units.party.portrait.rotation = 0 -- temp
	--end

	hooksecurefunc(UF, 'Update_AllFrames', UFB.Update_PowerStatusBar)
	hooksecurefunc(UF, 'Update_StatusBars', UFB.Update_PowerStatusBar)
end

E:RegisterModule(UFB:GetName())

-- raid, raid40 mouseover classcolor
local function HoverClassColor(self, frame, db)
	if db.classHover ~= true then return; end
	if frame.isMouseOverHooked then return; end
	local health = frame.Health.backdrop
	frame:HookScript("OnEnter", function(self)
		local hover = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
		if (not hover) then return; end
		health:SetBackdropBorderColor( hover.r, hover.g, hover.b )
	end)
	frame:HookScript("OnLeave", function(self)
		health:SetBackdropBorderColor(unpack(E['media'].bordercolor))
	end)
	frame.isMouseOverHooked = true
end
hooksecurefunc(UF, 'Update_RaidFrames', HoverClassColor)
hooksecurefunc(UF, 'Update_Raid40Frames', HoverClassColor)