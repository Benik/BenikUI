local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local S = E:GetModule('Skins');

local assert, next = assert, next
local find = string.find

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

BUI.ArrowRotation = {
	['UP'] = 3.14,
	['DOWN'] = 0,
	['LEFT'] = -1.57,
	['RIGHT'] = 1.57,
}

function S:HandleMaxMinFrame(frame)
	assert(frame, "does not exist.")

	frame:StripTextures()

	for _, name in next, {"MaximizeButton", "MinimizeButton"} do
		local button = frame[name]
		if button then
			button:SetSize(20, 20)
			button:ClearAllPoints()
			button:SetPoint("CENTER")

			button:SetNormalTexture(nil)
			button:SetPushedTexture(nil)
			button:SetHighlightTexture(nil)

			if not button.backdrop then
				button:CreateBackdrop()
				button.backdrop:Point("TOPLEFT", button, 1, -1)
				button.backdrop:Point("BOTTOMRIGHT", button, -1, 1)
				button.backdrop:SetTemplate('NoBackdrop')
				button:SetHitRectInsets(1, 1, 1, 1)
			end

			button.backdrop.img = button.backdrop:CreateTexture(nil, 'OVERLAY')
			button.backdrop.img:SetInside()
			button.backdrop.img:Point("CENTER")
			button.backdrop.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow')
			button.backdrop.img:SetVertexColor(1, 1, 1)
			
			button:HookScript('OnEnter', function(self)
				if E.myclass == 'PRIEST' then
					self.backdrop.img:SetVertexColor(unpack(E["media"].rgbvaluecolor))
					self.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
				else
					self.backdrop.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
					self.backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b)
				end
			end)

			button:HookScript('OnLeave', function(self)
				self.backdrop.img:SetVertexColor(1, 1, 1)
				self.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			end)

			if name == "MaximizeButton" then
				button.backdrop.img:SetTexCoord(1, 1, 1, -1.2246467991474e-016, 1.1102230246252e-016, 1, 0, -1.144237745222e-017)
			end
		end
	end
end

function S:HandleNextPrevButton(btn, useVertical, inverseDirection)
	inverseDirection = inverseDirection or btn:GetName() and (find(btn:GetName():lower(), 'left') or find(btn:GetName():lower(), 'prev') or find(btn:GetName():lower(), 'decrement') or find(btn:GetName():lower(), 'back'))

	btn:StripTextures()
	btn:SetNormalTexture(nil)
	btn:SetPushedTexture(nil)
	btn:SetHighlightTexture(nil)
	btn:SetDisabledTexture(nil)
	if not btn.icon then
		btn.icon = btn:CreateTexture(nil, 'ARTWORK')
		btn.icon:Size(13)
		btn.icon:Point('CENTER')
		btn.icon:SetTexture(nil)
	end

	if not btn.img then
		btn.img = btn:CreateTexture(nil, 'ARTWORK')
		btn.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow')
		btn.img:SetSize(12, 12)
		btn.img:Point('CENTER')
		btn.img:SetVertexColor(NORMAL_FONT_COLOR:GetRGB())

		btn:HookScript('OnMouseDown', function(button)
			if button:IsEnabled() then
				button.img:Point("CENTER", -1, -1);
			end
		end)

		btn:HookScript('OnMouseUp', function(button)
			button.img:Point("CENTER", 0, 0);
		end)

		btn:HookScript('OnDisable', function(button)
			SetDesaturation(button.img, true);
			button.img:SetAlpha(0.5);
		end)

		btn:HookScript('OnEnable', function(button)
			SetDesaturation(button.img, false);
			button.img:SetAlpha(1.0);
		end)

		if not btn:IsEnabled() then
			btn:GetScript('OnDisable')(btn)
		end
	end

	if useVertical then
		if inverseDirection then
			btn.img:SetRotation(BUI.ArrowRotation['UP'])
		else
			btn.img:SetRotation(BUI.ArrowRotation['DOWN'])
		end
	else
		if inverseDirection then
			btn.img:SetRotation(BUI.ArrowRotation['LEFT'])
		else
			btn.img:SetRotation(BUI.ArrowRotation['RIGHT'])
		end
	end

	S:HandleButton(btn)
	btn:Size(btn:GetWidth() - 7, btn:GetHeight() - 7)
end

function S:HandleCloseButton(f, point, text)
	f:StripTextures()

	if not f.backdrop then
		f:CreateBackdrop()
		f.backdrop:Point('TOPLEFT', 7, -8)
		f.backdrop:Point('BOTTOMRIGHT', -8, 8)
		f.backdrop:SetTemplate('NoBackdrop')
		f:SetHitRectInsets(6, 6, 7, 7)
	end

	if not text then text = '' end
	
	f.backdrop.img = f.backdrop:CreateTexture(nil, 'OVERLAY')
	f.backdrop.img:SetSize(12, 12)
	f.backdrop.img:Point("CENTER")
	f.backdrop.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Close.tga')
	f.backdrop.img:SetVertexColor(1, 1, 1)
	
	f:HookScript('OnEnter', function(self)
		if E.myclass == 'PRIEST' then
			self.backdrop.img:SetVertexColor(unpack(E["media"].rgbvaluecolor))
			self.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
		else
			self.backdrop.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
			self.backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b)
		end
	end)

	f:HookScript('OnLeave', function(self)
		self.backdrop.img:SetVertexColor(1, 1, 1)
		self.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	end)

	if not f.text then
		f.text = f:CreateFontString(nil, 'OVERLAY')
		f.text:SetFont([[Interface\AddOns\ElvUI\media\fonts\PT_Sans_Narrow.ttf]], 16, 'OUTLINE')
		f.text:SetText(text)
		f.text:SetJustifyH('CENTER')
		f.text:Point('CENTER', f, 'CENTER')
	end

	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end