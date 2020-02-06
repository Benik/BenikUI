local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins');

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local CloseButton = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Close.tga'

function mod:HandleCloseButton(f)
	if f.Texture then
		f.Texture:SetTexture(CloseButton)
		f.Texture:SetVertexColor(1, 1, 1)
	end

	f:HookScript('OnEnter', function(self)
		if E.myclass == 'PRIEST' then
			self.Texture:SetVertexColor(unpack(E["media"].rgbvaluecolor))
		else
			self.Texture:SetVertexColor(classColor.r, classColor.g, classColor.b)
		end
	end)

	f:HookScript('OnLeave', function(self)
		self.Texture:SetVertexColor(1, 1, 1)
	end)
end
hooksecurefunc(S, "HandleCloseButton", mod.HandleCloseButton)

function mod:HandleButton(button, _, isDeclineButton)
	if button.isEdited then return end
	assert(button, "doesn't exist!")

	-- replace the white X letter on decline buttons
	if isDeclineButton then
		if button.Icon then
			button.Icon:SetTexture(CloseButton)
			button.Icon:Size(12, 12)
			button.Icon:Point("CENTER")
		end
	end

	button.isEdited = true
end
hooksecurefunc(S, "HandleButton", mod.HandleButton)

local function Style_Ace3TabSelected(self, selected)
	local bd = self.backdrop
	if not bd then return end

	if selected then
		bd:SetBackdropBorderColor(0, 0, 0)
	else
		local r, g, b = unpack(E.media.bordercolor)
		bd:SetBackdropBorderColor(r, g, b, 1)
	end
end
hooksecurefunc(S, 'Ace3_TabSetSelected', Style_Ace3TabSelected)

local function Style_SetButtonColor(self, btn, disabled)
	if disabled then
		btn:Disable()
		btn:SetBackdropBorderColor(0, 0, 0)
		btn:SetBackdropColor(unpack(E.media.rgbvaluecolor))
		btn.Text:SetTextColor(1, 1, 1)
		E:Config_SetButtonText(btn, true)
	else
		btn:Enable()
		btn:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
		local r, g, b = unpack(E.media.bordercolor)
		btn:SetBackdropBorderColor(r, g, b, 1)
		btn.Text:SetTextColor(.9, .8, 0)
		E:Config_SetButtonText(btn)
	end
end
hooksecurefunc(E, 'Config_SetButtonColor', Style_SetButtonColor)
