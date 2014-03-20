local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local LSM = LibStub("LibSharedMedia-3.0")

local SPACING = (E.PixelMode and 1 or 5)

local color = { r = 1, g = 0.5, b = 0 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

local function CreateSoftShadow(f)
	if f.shadow then return end
	
	borderr, borderg, borderb = 0, 0, 0
	backdropr, backdropg, backdropb = 0, 0, 0

	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetOutside(f, 2, 2)
	shadow:SetBackdrop( { 
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(2),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.4)
	f.shadow = shadow
end

local function CreateSoftGlow(f)
	if f.sglow then return end
	
	borderr, borderg, borderb = 1, 1, .5
	backdropr, backdropg, backdropb = 1, 1, .5

	local sglow = CreateFrame("Frame", nil, f)
	sglow:SetFrameLevel(1)
	sglow:SetFrameStrata(f:GetFrameStrata())
	sglow:SetOutside(f, 2, 2)
	sglow:SetBackdrop( { 
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(3),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	sglow:SetBackdropColor(unpackColor(E.db.general.valuecolor), 0)
	sglow:SetBackdropBorderColor(unpackColor(E.db.general.valuecolor), 0.4)
	f.sglow = sglow
end

local function Style(f)
	if f.style then return end

	local style = CreateFrame('Frame', nil, f)
	style:CreateBackdrop('Default', true)
	style:SetParent(f.backdrop)
	style:Point('TOPLEFT', f, 'TOPLEFT', 0, 5)
	style:Point('BOTTOMRIGHT', f, 'TOPRIGHT', 0, SPACING)
	
	f.style = style
end

local function StyleOnFrame(f, name)
	if f.styleof then return end

	local styleof = CreateFrame('Frame', name, f)
	styleof:SetTemplate('Default', true)
	styleof:SetParent(f)
	styleof:Point('TOPLEFT', f, 'TOPLEFT', 0, 5) -- 4 or 5?.. that is the question :P
	styleof:Point('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -SPACING)

	f.styleof = styleof
end

local function StyleInFrame(f, name)
	if f.styleif then return end

	local styleif = CreateFrame('Frame', name, f)
	styleif:SetTemplate('Default', true)
	styleif:SetParent(f)
	styleif:Point('TOPLEFT', f, 'TOPLEFT', 0, SPACING)
	styleif:Point('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -5)

	f.styleif = styleif
end

local function StyleSkins(f)
	if f.stylesk then return end

	local stylesk = CreateFrame('Frame', name, f)
	stylesk:CreateBackdrop('Default', true)
	stylesk:SetParent(f)
	stylesk:Point('TOPLEFT', f, 'TOPLEFT', SPACING, 5)
	stylesk:Point('BOTTOMRIGHT', f, 'TOPRIGHT', -SPACING, 0)

	f.stylesk = stylesk
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateSoftShadow then mt.CreateSoftShadow = CreateSoftShadow end
	if not object.CreateSoftGlow then mt.CreateSoftGlow = CreateSoftGlow end
	if not object.Style then mt.Style = Style end
	if not object.StyleOnFrame then mt.StyleOnFrame = StyleOnFrame end
	if not object.StyleInFrame then mt.StyleInFrame = StyleInFrame end
	if not object.StyleSkins then mt.StyleSkins = StyleSkins end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
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

function BUI:StyleBlizSkins(name, parent, ...)
	local frame = CreateFrame('Frame', name, E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', SPACING, 5)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', -SPACING, 0)

	return frame
end
