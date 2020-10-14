local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')

local function LoadSkin()
	_G.Storyline_NPCFrame:StripTextures()
	_G.Storyline_NPCFrame:CreateBackdrop("Transparent")
	_G.Storyline_NPCFrame.backdrop:Style("Outside")
	S:HandleCloseButton(_G.Storyline_NPCFrameClose)
	_G.Storyline_NPCFrameChat:StripTextures()
	_G.Storyline_NPCFrameChat:CreateBackdrop("Transparent")
end

function mod:SkinStoryline()
	if not IsAddOnLoaded("Storyline") or E.db.benikuiSkins.variousSkins.storyline ~= true then
		return
	end
	LoadSkin()
end