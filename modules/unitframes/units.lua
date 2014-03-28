local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:NewModule('BuiUnits', "AceHook-3.0", 'AceEvent-3.0');
local UF = E:GetModule('UnitFrames');

if E.db.ufb == nil then E.db.ufb = {} end

function UFB:UnitDefaults()
	if E.db.ufb.barheight == nil then
		E.db.ufb.barheight = 20
	end
	if E.db.ufb.PlayerPortraitWidth == nil then
		E.db.ufb.PlayerPortraitWidth = 150
	end	
	if E.db.ufb.PlayerPortraitHeight == nil then
		E.db.ufb.PlayerPortraitHeight = 150
	end	
	if E.db.ufb.TargetPortraitWidth == nil then
		E.db.ufb.TargetPortraitWidth = 150
	end	
	if E.db.ufb.TargetPortraitHeight == nil then
		E.db.ufb.TargetPortraitHeight = 150
	end
end

function UFB:LoadTarget()
	self:InitTarget()
end

function UFB:Initialize()
	self:UnitDefaults()
	self:InitPlayer()
	self:InitTarget()
	--self:RegisterEvent('PLAYER_ENTERING_WORLD', 'InitTarget')
end

E:RegisterModule(UFB:GetName())