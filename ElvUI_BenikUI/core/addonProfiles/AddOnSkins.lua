local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadAddOnSkinsProfile()
	local AS = unpack(AddOnSkins)
	AS.data:SetProfile("BenikUI")

	local font
	if E.private.benikui.expressway == true then
		font = "Expressway"
	else
		font = "Bui Prototype"
	end

	AS.db['WeakAuraAuraBar'] = true

	AS.db['EmbedFrameStrata'] = "2-LOW"
	AS.db['EmbedBelowTop'] = false

	if BUI:IsAddOnEnabled('Recount') then
		AS.db['EmbedSystem'] = true
		AS.db['EmbedSystemDual'] = false
		AS.db['RecountBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end

	if BUI:IsAddOnEnabled('Skada') then
		AS.db['EmbedFrameStrata'] = "2-LOW"
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedLeft'] = 'Skada'
		AS.db['EmbedMain'] = 'Skada'
		AS.db['EmbedRight'] = 'Skada'
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['SkadaBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end

	if BUI:IsAddOnEnabled('Details') then
		AS.db['EmbedFrameStrata'] = "2-LOW"
		AS.db['DetailsBackdrop'] = false
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedLeft'] = 'Details'
		AS.db['EmbedMain'] = 'Details'
		AS.db['EmbedRight'] = 'Details'
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['TransparentEmbed'] = true
	end

	if BUI:IsAddOnEnabled('DBM-Core') then
		AS.db['DBMSkinHalf'] = true
		AS.db['DBMFont'] = font
		AS.db['DBMFontSize'] = 10
		AS.db['DBMRadarTrans'] = true
	end
end