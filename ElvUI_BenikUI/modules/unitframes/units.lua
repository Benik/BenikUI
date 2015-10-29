local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:NewModule('BuiUnits', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");
UF.LSM = LSM

if E.db.ufb == nil then E.db.ufb = {} end

local select, pairs, lower = select, pairs, string.lower

local unitfs = {"Player", "Target", "TargetTarget", "Pet", "Focus", "FocusTarget"}

function UFB:Update_PowerStatusBar(unit)
	-- Units
	for _, frame in pairs(unitfs) do 
		local self = _G["ElvUF_"..frame]
		local unit = lower(frame)
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

-- EmptyBars in Raid frames
function UFB:ConstructRaidBars()
	local header = _G['ElvUF_Raid']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if not unitbutton.EmptyBar then
				unitbutton.EmptyBar = UFB:CreateEmptyBar(unitbutton)
			end
		end
	end
end

-- EmptyBars in Party frames
function UFB:ConstructPartyBars()
	local header = _G['ElvUF_Party']
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())

		for j = 1, group:GetNumChildren() do
			local unitbutton = select(j, group:GetChildren())
			if not unitbutton.EmptyBar then
				unitbutton.EmptyBar = UFB:CreateEmptyBar(unitbutton)
			end
		end
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
	self:InitPet()
	self:InitTargetTarget()

	self:InitParty()
	self:InitRaid()
	
	hooksecurefunc(UF, 'Update_RaidHeader', UFB.ConstructRaidBars)
	hooksecurefunc(UF, 'Update_PartyHeader', UFB.ConstructPartyBars)
	hooksecurefunc(UF, 'Update_AllFrames', UFB.Update_PowerStatusBar)
	hooksecurefunc(UF, 'Update_StatusBars', UFB.Update_PowerStatusBar)
end

E:RegisterModule(UFB:GetName())