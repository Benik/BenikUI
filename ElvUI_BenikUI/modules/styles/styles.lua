local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')



function mod:Initialize()
	mod:InitializeObjectiveTracker()

end

BUI:RegisterModule(mod:GetName())