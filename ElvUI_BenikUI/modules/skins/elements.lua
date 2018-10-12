local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local S = E:GetModule('Skins');

local assert, next = assert, next

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

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