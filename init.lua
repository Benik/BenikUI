local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:NewModule('BenikUI');
local M = E:GetModule('Misc');
local LSM = LibStub("LibSharedMedia-3.0")
local SPACING = (E.PixelMode and 1 or 5)
local benikEdit = CreateFrame("frame")

local backdropr, backdropg, backdropb, backdropa, borderr, borderg, borderb = 0, 0, 0, 1, 0, 0, 0

LSM:Register("font", "ElvUI Prototype", [[Interface\AddOns\ElvUI_BenikUI\media\fonts\PROTOTYPE.TTF]])
function BUI:RegisterBenikMedia()
	--Fonts
	E["media"].benFont = LSM:Fetch("font", "ElvUI Prototype")

	--Textures
	E["media"].benSha = LSM:Fetch("statusbar", "BenikintShadow")
	E["media"].benFlat = LSM:Fetch("statusbar", "Flat")
end

local color = { r = 1, g = 0.5, b = 0 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

function E:BenikStyle(name, parent, ...)
	local frame = CreateFrame('Frame', name, E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent.backdrop)
	--frame:CreateSoftShadow('Default')
	frame:Point('TOPLEFT', parent, 'TOPLEFT', 0, 5)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, SPACING)
	
	return frame
end

function E:BenikStyleOnFrame(name, parent, ...)
	local frame = CreateFrame('Frame', name, E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', SPACING, 4)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', -SPACING, 0)
	
	return frame
end

function E:BenikUFStyle(name, parent, ...)
	local frame = CreateFrame('Frame', name, E.UIParent)
	frame:CreateBackdrop('Default', true)
	frame:SetParent(parent.backdrop)
	frame:Point('TOPLEFT', parent, 'TOPLEFT', 0, 0)
	frame:Point('BOTTOMRIGHT', parent, 'TOPRIGHT', 0, -5)
	
	return frame
end

function CreateSoftShadow(f)
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

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.CreateSoftShadow then mt.CreateSoftShadow = CreateSoftShadow end
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

function BUI:InitBenik()
-- local db = E.db.skins.phenox

-- Layout Init
	BenikPanels()
	--BenikAB()
	--M:BenikLoadExpRepBar()
	--UF:BenikAuraBars()
	--UF:BenikUF()
	--BenikAuras()
	--UF:BenikGroup()
	--B:BenikBags()
	--B:BenikBagBar()
	--UF:Construct_AuraIcon()
	--BenikPanelsRepos()
	--BenikPanelsReposTwo()
	
-- Chat
	--BenikChat()
	
	--[[if db.lowerpanel then
		if LowerPanel == nil then 
			CreateLowerPanel() end
	end

	if db.singleside then
		Phenox_DoWork_Unitframes('player')
		Phenox_DoWork_Unitframes('target')
	end

-- Module Init
	Phenox_DoWork_Actionbars()
	Phenox_DoWork_Auras()
	Phenox_DoWork_Chat()
	--Phenox_DoWork_Classtimers()
	Phenox_DoWork_Datatexts()
	Phenox_DoWork_Maps()
	Phenox_DoWork_Tooltip()
	Phenox_DoWork_Questtracker()
end

function E:SetupPhenoxMedia()
local db = E.db.skins.phenox

	--Fonts
	self["media"].abFont = LSM:Fetch("font", db.abfont)
	self["media"].aFont = LSM:Fetch("font", db.afont)
	self["media"].chFont = LSM:Fetch("font", db.chfont)
	self["media"].ctFont = LSM:Fetch("font", db.ctfont)
	self["media"].dtFont = LSM:Fetch("font", db.dtfont)
	self["media"].mFont = LSM:Fetch("font", db.mfont)
	self["media"].ttFont = LSM:Fetch("font", db.ttfont)
	self["media"].qtFont = LSM:Fetch("font", db.qtfont)

	--Textures
	self["media"].ctTex = LSM:Fetch("statusbar", db.cttex)
	self["media"].ttTex = LSM:Fetch("statusbar", db.tttex)]]
end

function BUI:Initialize()
	self:RegisterBenikMedia()
	self:InitBenik()
end

E:RegisterModule(BUI:GetName())
--[[benikEdit:RegisterEvent("PLAYER_ENTERING_WORLD")
benikEdit:SetScript("OnEvent",function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
		--if E.initialized then
			--local db = E.db.skins.phenox
				--if db.enable then
					--E:RegisterPhenoxMedia()
					--E:SetupPhenoxMedia()
					E:RegisterBenikMedia()
					E:InitBenik()
					--E:BenikPlayer()
					--E:CreateUnitShadow()
					--UF:CreateUnitShadow(frame, db)
					--E:CreateUnitShadow()
					print("Benik's ElvUI edit loaded")
				--end
			benikEdit:UnregisterEvent("PLAYER_ENTERING_WORLD")
		--end
	end
end)]]