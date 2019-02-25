local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local NP = E:GetModule('NamePlates')
local mod = E:NewModule('BuiNameplates', 'AceHook-3.0');

function mod:NameplateShadows(frame)
	if not frame.Health.backdrop.shadow then
		frame.Health.backdrop:CreateSoftShadow()
	end
end


function mod:Initialize()
	if not BUI.ShadowMode then return end
	--hooksecurefunc(NP, 'UpdatePlate', mod.NameplateShadows)
end

local function InitializeCallback()
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)