local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LSM = LibStub('LibSharedMedia-3.0')

local CreateFrame = CreateFrame
local getmetatable = getmetatable

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function CreateWideShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local wideshadow = f.wideshadow or CreateFrame('Frame', nil, f) -- This way you can replace current shadows.
	wideshadow:SetFrameLevel(1)
	wideshadow:SetFrameStrata(f:GetFrameStrata())
	wideshadow:SetOutside(f, 6, 6)
	wideshadow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(6),
		insets = {left = E:Scale(8), right = E:Scale(8), top = E:Scale(8), bottom = E:Scale(8)},
	})
	wideshadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	wideshadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.5)
	f.wideshadow = wideshadow
end

local function CreateSoftShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local softshadow = f.softshadow or CreateFrame('Frame', nil, f) -- This way you can replace current shadows.
	softshadow:SetFrameLevel(1)
	softshadow:SetFrameStrata(f:GetFrameStrata())
	softshadow:SetOutside(f, 2, 2)
	softshadow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(2),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	softshadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	softshadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.4)
	f.softshadow = softshadow
end

local function CreateSoftGlow(f)
	if f.sglow then return end

	local r, g, b = BUI:unpackColor(E.db.general.valuecolor)
	local sglow = CreateFrame('Frame', nil, f)

	sglow:SetFrameLevel(1)
	sglow:SetFrameStrata(f:GetFrameStrata())
	sglow:SetOutside(f, 3, 3)
	sglow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(3),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})

	sglow:SetBackdropBorderColor(r, g, b, 0.6)

	f.sglow = sglow
	BUI["softGlow"][sglow] = true
end

local r, g, b = 0, 0, 0

local function Style(f, template, name, ignoreColor, ignoreVisibility)
	if f.style or E.db.benikui.general.benikuiStyle ~= true then return end

	local style = CreateFrame('Frame', name or nil, f)
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
		tlx, tly, brx, bry = 0, 1, 0, (E.PixelMode and -4 or -7)
	end
	
	if template == 'Under' then
		style:Point('TOPLEFT', f, 'BOTTOMLEFT', tlx, tly)
		style:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT', brx, bry)
	else
		style:Point('TOPLEFT', f, 'TOPLEFT', tlx, tly)
		style:Point('BOTTOMRIGHT', f, 'TOPRIGHT', brx, bry)
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
		f:CreateShadow('Default')
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