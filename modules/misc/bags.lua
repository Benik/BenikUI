local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

--[[if E.private.bags.enable == true then return end
if E.db.bags.bagBar.enable then 
	
else return end
ElvUIBags.backdrop:Kill()
ElvUIBags:CreateBackdrop('Transparent')
local bagsbardec = E:BenikStyle('BenikBagsBarDecor', ElvUIBags)

local BenBags = {} -- todo: reposition bags on height
for i = 1, 5 do
	_G["ContainerFrame"..i]:StripTextures()
	--_G["ContainerFrame"..i]:CreateBackdrop('Transparent')
	BenBags[i] = E:BenikStyleOnFrame(_G['BenikContainerFrame_'..i], _G["ContainerFrame"..i])
end]]

