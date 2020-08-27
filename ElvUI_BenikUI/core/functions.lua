local BUI, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

local CreateFrame = CreateFrame
local getmetatable = getmetatable

local classColor = E:ClassColor(E.myclass, true)

local function CreateWideShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local wideshadow = f.wideshadow or CreateFrame('Frame', nil, f, 'BackdropTemplate')
	wideshadow:SetFrameLevel(1)
	wideshadow:SetFrameStrata('BACKGROUND')
	wideshadow:SetOutside(f, 6, 6)
	wideshadow:SetBackdrop({edgeFile = E.Media.Textures.GlowTex, edgeSize = E:Scale(6)})
	wideshadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	wideshadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.5)
	f.wideshadow = wideshadow
end

local function CreateSoftShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0
	local db = E.db.benikui.general

	local shadow = f.shadow or CreateFrame('Frame', nil, f, 'BackdropTemplate') -- This way you can replace current shadows.
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetOutside(f, (db.shadowSize - 1) or 2, (db.shadowSize - 1) or 2)
	shadow:SetBackdrop({edgeFile = E.Media.Textures.GlowTex, edgeSize = E:Scale(db.shadowSize or 3)})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.6)
	f.shadow = shadow
	BUI["shadows"][shadow] = true
end

local function CreateStyleShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0
	local db = E.db.benikui.general

	local styleShadow = f.styleShadow or CreateFrame('Frame', nil, f, 'BackdropTemplate')
	styleShadow:SetFrameLevel(1)
	styleShadow:SetFrameStrata(f:GetFrameStrata())

	styleShadow:SetPoint('TOPLEFT', f, 'TOPLEFT', -2, 2)
	styleShadow:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 2, 0)

	styleShadow:SetBackdrop({edgeFile = E.Media.Textures.GlowTex, edgeSize = E:Scale(3)})
	styleShadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	styleShadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.6)
	f.styleShadow = styleShadow
end

local function CreateSoftGlow(f)
	if f.sglow then return end

	local r, g, b = BUI:unpackColor(E.db.general.valuecolor)
	local sglow = CreateFrame('Frame', nil, f, 'BackdropTemplate')

	sglow:SetFrameLevel(1)
	sglow:SetFrameStrata(f:GetFrameStrata())
	sglow:SetOutside(f, 3, 3)
	sglow:SetBackdrop({edgeFile = E.Media.Textures.GlowTex, edgeSize = E:Scale(3)})

	sglow:SetBackdropBorderColor(r, g, b, 0.6)

	f.sglow = sglow
	BUI["softGlow"][sglow] = true
end

local r, g, b = 0, 0, 0

local function Style(f, template, name, ignoreColor, ignoreVisibility)
	if f.style or E.db.benikui.general.benikuiStyle ~= true then return end

	local style = CreateFrame('Frame', name or nil, f, 'BackdropTemplate')
	if not template then
		style:CreateBackdrop('Transparent', true)
	else
		style:SetTemplate('Transparent', true)
	end

	style.ignoreUpdates = true

	if(ignoreColor) then
		style.ignoreColor = ignoreColor
	end

	if(ignoreVisibility) then
		style.ignoreVisibility = ignoreVisibility
	end

	style:SetFrameLevel(f:GetFrameLevel() + 2)

	local tlx, tly, brx, bry

	if template == 'Inside' then
		tlx, tly, brx, bry = 0, (E.PixelMode and 0 or 2), 0, (E.PixelMode and -5 or -4)
	elseif template == 'Outside' then
		tlx, tly, brx, bry = 0, (E.PixelMode and 4 or 7), 0, (E.PixelMode and -1 or 1)
	elseif template == 'Small' then
		tlx, tly, brx, bry = -(E.PixelMode and 1 or 2), (E.PixelMode and 4 or 9), (E.PixelMode and 1 or 2), (E.PixelMode and -1 or 3)
	elseif template == 'Under' then
		tlx, tly, brx, bry = 0, (E.PixelMode and 5 or 7), 0, (E.PixelMode and 0 or 1)
	end

	if template == 'Under' then
		style:SetPoint('TOPRIGHT', f, 'BOTTOMRIGHT', tlx, tly)
		style:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', brx, bry)
	else
		style:SetPoint('TOPLEFT', f, 'TOPLEFT', tlx, tly)
		style:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', brx, bry)
	end

	if not ignoreColor then
		if E.db.benikui.colors.StyleColor == 1 then
			r, g, b = classColor.r, classColor.g, classColor.b
		elseif E.db.benikui.colors.StyleColor == 2 then
			r, g, b = BUI:unpackColor(E.db.benikui.colors.customStyleColor)
		elseif E.db.benikui.colors.StyleColor == 3 then
			r, g, b = BUI:unpackColor(E.db.general.valuecolor)
		else
			r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
		end
		style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
	else
		style:SetBackdropColor(unpack(E["media"].backdropcolor))
	end

	if E.db.benikui.general.shadows then
		f:CreateSoftShadow()
		if template == 'Outside' or template == 'Small' then
			style:CreateStyleShadow()
		end
	end

	if E.db.benikui.general.hideStyle then
		style:Hide()
	else
		style:Show()
	end

	f.style = style

	if not style.ignoreColor then
		BUI["styles"][style] = true
	end
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateSoftShadow then mt.CreateSoftShadow = CreateSoftShadow end
	if not object.CreateWideShadow then mt.CreateWideShadow = CreateWideShadow end
	if not object.CreateSoftGlow then mt.CreateSoftGlow = CreateSoftGlow end
	if not object.CreateStyleShadow then mt.CreateStyleShadow = CreateStyleShadow end
	if not object.Style then mt.Style = Style end
end

local handled = {['Frame'] = true}
local object = CreateFrame('Frame')
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end