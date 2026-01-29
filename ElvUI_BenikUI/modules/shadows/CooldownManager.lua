local BUI, E, _, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Shadows')
local S = E:GetModule('Skins')

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc

function mod:CooldownManager_IconShadows(icon)
	icon.backdrop:CreateSoftShadow()
end

function mod:CooldownManager_BarShadows(frame, bar)
	if frame.Icon then
		mod:CooldownManager_IconShadows(frame.Icon.Icon)
	end

	for _, region in next, { bar:GetRegions() } do
		if region:IsObjectType('Texture') then
			if region.backdrop and not region.backdrop.shadow then
				region.backdrop:CreateSoftShadow()
			end
		end
	end
end

function mod:CooldownManager_FrameShadows(frame)
	if frame.Bar then
		mod:CooldownManager_BarShadows(frame, frame.Bar)
	elseif frame.Icon then
		mod:CooldownManager_IconShadows(frame.Icon)
	end
end

function mod:CooldownManager_AcquireItemFrame(frame)
	mod:CooldownManager_FrameShadows(frame)
end

function mod:CooldownManager_HandleViewer(element)
	hooksecurefunc(element, 'OnAcquireItemFrame', mod.CooldownManager_AcquireItemFrame)

	for frame in element.itemFramePool:EnumerateActive() do
		mod:CooldownManager_FrameShadows(frame)
	end
end

function mod:CooldownViewer_Shadows()
	if E.private.skins.blizzard.cooldownManager ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.benikuiStyle ~= true
	then
		return
	end

	mod:CooldownManager_HandleViewer(_G.UtilityCooldownViewer)
	mod:CooldownManager_HandleViewer(_G.BuffBarCooldownViewer)
	mod:CooldownManager_HandleViewer(_G.BuffIconCooldownViewer)
	mod:CooldownManager_HandleViewer(_G.EssentialCooldownViewer)

	local CooldownViewer = _G.CooldownViewerSettings
	if CooldownViewer then
		CooldownViewer:BuiStyle("Outside")
		for i, tab in next, { CooldownViewer.SpellsTab, CooldownViewer.AurasTab } do
			tab:CreateSoftShadow()
		end
	end
end
S:AddCallbackForAddon("Blizzard_CooldownViewer", "BenikUI_CooldownViewer", mod.CooldownViewer_Shadows)