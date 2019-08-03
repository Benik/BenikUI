local BUI, E, L, V, P, G = unpack(select(2, ...))
local NP = E:GetModule('NamePlates')
local mod = BUI:NewModule('Nameplates', 'AceHook-3.0');

function mod:NameplateShadows(nameplate)
	if not nameplate.Health.backdrop.shadow then
		nameplate.Health.backdrop:CreateSoftShadow()
	end
	if not nameplate.Power.backdrop.shadow then
		nameplate.Power.backdrop:CreateSoftShadow()
	end
	if not nameplate.Castbar.backdrop.shadow then
		nameplate.Castbar.backdrop:CreateSoftShadow()
	end
	if not nameplate.Castbar.Button.shadow then
		nameplate.Castbar.Button:CreateSoftShadow()
	end
	if not nameplate.Portrait.backdrop.shadow then
		nameplate.Portrait.backdrop:CreateSoftShadow()
	end
end

function mod:Initialize()
	if not BUI.ShadowMode then return end
	hooksecurefunc(NP, 'StylePlate', mod.NameplateShadows)
end

BUI:RegisterModule(mod:GetName())