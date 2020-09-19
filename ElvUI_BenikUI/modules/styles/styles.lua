local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

function mod:PLAYER_ENTERING_WORLD(...)
	--self:styleAlertFrames()
	mod:stylePlugins()
	--styleWorldMap()

	--self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	mod:InitializeObjectiveTracker()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

BUI:RegisterModule(mod:GetName())