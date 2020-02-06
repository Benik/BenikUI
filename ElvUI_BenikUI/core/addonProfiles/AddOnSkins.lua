local BUI, E, L, V, P, G = unpack(select(2, ...))

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

	if BUI:IsAddOnEnabled('Recount') then
		AS.db['EmbedSystem'] = true
		AS.db['EmbedSystemDual'] = false
		AS.db['EmbedBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end

	if BUI:IsAddOnEnabled('Skada') then
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['EmbedBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end

	if BUI:IsAddOnEnabled('Details') then
		AS.db['EmbedBackdrop'] = false
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