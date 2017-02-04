local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadAddOnSkinsProfile()
	local AS = unpack(AddOnSkins) or nil
	-- reset the embeds to defaults, in case of Skada/Recount/Details swap
	AS.db['DBMFont'] = 'Tukui'
	AS.db['DBMFontSize'] = 12
	AS.db['DBMRadarTrans'] = false
	AS.db['DBMSkinHalf'] = false
	AS.db['DetailsBackdrop'] = true
	AS.db['EmbedBelowTop'] = false
	AS.db['EmbedFrameStrata'] = "2-LOW"
	AS.db['EmbedLeft'] = 'Skada'
	AS.db['EmbedMain'] = 'Skada'
	AS.db['EmbedRight'] = 'Skada'
	AS.db['EmbedSystem'] = false
	AS.db['EmbedSystemDual'] = false
	AS.db['ParchmentRemover'] = false
	AS.db['RecountBackdrop'] = true
	AS.db['SkadaBackdrop'] = true
	AS.db['TransparentEmbed'] = false
	
	if IsAddOnLoaded('Recount') then
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedMain'] = 'Recount'
		AS.db['EmbedSystem'] = true
		AS.db['EmbedSystemDual'] = false
		AS.db['RecountBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end
	
	if IsAddOnLoaded('Skada') then
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedLeft'] = 'Skada'
		AS.db['EmbedMain'] = 'Skada'
		AS.db['EmbedRight'] = 'Skada'
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['SkadaBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end
	
	if IsAddOnLoaded('Details') then
		AS.db['DetailsBackdrop'] = false
		AS.db['EmbedBelowTop'] = false
		AS.db['EmbedLeft'] = 'Details'
		AS.db['EmbedMain'] = 'Details'
		AS.db['EmbedRight'] = 'Details'
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['TransparentEmbed'] = true
	end
	
	if IsAddOnLoaded('DBM-Core') then
		AS.db['DBMFont'] = 'Bui Prototype'
		AS.db['DBMFontSize'] = 10
		AS.db['DBMRadarTrans'] = true
	end
end