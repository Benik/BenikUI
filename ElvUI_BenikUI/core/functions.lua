local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LSM = LibStub('LibSharedMedia-3.0')

local SPACING = (E.PixelMode and 1 or 3)

local color = { r = 1, g = 0.5, b = 0 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

local function CreateSoftShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local shadow = f.shadow or CreateFrame('Frame', nil, f) -- This way you can replace current shadows.
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetOutside(f, 2, 2)
	shadow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(2),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.4)
	f.shadow = shadow
end

local function CreateSoftGlow(f)
	if f.sglow then return end

	local borderr, borderg, borderb = 1, 1, .5
	local backdropr, backdropg, backdropb = 1, 1, .5

	local sglow = CreateFrame('Frame', nil, f)
	sglow:SetFrameLevel(1)
	sglow:SetFrameStrata(f:GetFrameStrata())
	sglow:SetOutside(f, 2, 2)
	sglow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(3),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	sglow:SetBackdropColor(unpackColor(E.db.general.valuecolor), 0)
	sglow:SetBackdropBorderColor(unpackColor(E.db.general.valuecolor), 0.4)
	f.sglow = sglow
end

local function Style(f, template, name)
	if f.style or E.db.bui.buiStyle ~= true then return end

	local style = CreateFrame('Frame', name or nil, f)
	if not template then
		style:CreateBackdrop('Default', true)
	else
		style:SetTemplate('Default', true)
	end
	local tlx, tly, brx, bry
	if template == 'Inside' then
		tlx, tly, brx, bry = 0, SPACING, 0, (E.PixelMode and -4 or -3)
	elseif template == 'Outside' then
		tlx, tly, brx, bry = 0, (E.PixelMode and 4 or 5), 0, -1
	elseif template == 'Skin' then
		tlx, tly, brx, bry = 0, (E.PixelMode and 4 or 7), 0, (E.PixelMode and -1 or 1)
	elseif template == 'Small' then
		tlx, tly, brx, bry = -(E.PixelMode and 1 or 2), (E.PixelMode and 4 or 9), (E.PixelMode and 1 or 2), (E.PixelMode and -1 or 3)
	end
	style:Point('TOPLEFT', f, 'TOPLEFT', tlx, tly)
	style:Point('BOTTOMRIGHT', f, 'TOPRIGHT', brx, bry)
	
	f.style = style
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateSoftShadow then mt.CreateSoftShadow = CreateSoftShadow end
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
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end
	
	object = EnumerateFrames(object)
end