local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');
local BUI = E:GetModule('BenikUI');
local mod = E:GetModule('BuiShadows');

-- AddonSkins WeakAuras
local function WeakAurasShadows()
	local function Skin_WeakAuras(frame, ftype)
		if not frame.Backdrop.shadow then
			frame.Backdrop:CreateSoftShadow()
		end
	end

	local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify

	WeakAuras.regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, 'icon')
		return region
	end

	WeakAuras.regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, 'aurabar')
		return region
	end

	WeakAuras.regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, 'icon')
	end

	WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, 'aurabar')
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == 'icon' or WeakAuras.regions[weakAura].regionType == 'aurabar' then
			Skin_WeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
		end
	end
end

-- AddonSkins tabs
function mod:TabShadowsAS(tab)
	if not tab then return end

	if tab.Backdrop then
		tab.Backdrop:CreateSoftShadow()
	end
end

function mod:AddonSkins()
	if not BUI.AS then return end
	local AS = unpack(AddOnSkins)

	hooksecurefunc(AS, "SkinTab", mod.TabShadowsAS)

	if AS:CheckAddOn('WeakAuras') then AS:RegisterSkin('WeakAuras', WeakAurasShadows, 2) end
end