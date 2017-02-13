local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadAddOnSkinsProfile()
	local AS = unpack(AddOnSkins) or nil

	if AddOnSkinsDB["profiles"]["BenikUI"] == nil then AddOnSkinsDB["profiles"]["BenikUI"] = {} end

	-- defaults
	AddOnSkinsDB["profiles"]["BenikUI"]['EmbedLeft'] = 'Skada'
	AddOnSkinsDB["profiles"]["BenikUI"]['EmbedLeft'] = 'Skada'
	AddOnSkinsDB["profiles"]["BenikUI"]['EmbedMain'] = 'Skada'
	AddOnSkinsDB["profiles"]["BenikUI"]['EmbedRight'] = 'Skada'
	AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystem'] = false
	AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystemDual'] = false
	AddOnSkinsDB["profiles"]["BenikUI"]['ParchmentRemover'] = false
	AddOnSkinsDB["profiles"]["BenikUI"]['TransparentEmbed'] = false

	if IsAddOnLoaded('Recount') then
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedFrameStrata'] = "2-LOW"
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedBelowTop'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedMain'] = 'Recount'
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystem'] = true
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystemDual'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['RecountBackdrop'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['TransparentEmbed'] = true
	end
	
	if IsAddOnLoaded('Skada') then
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedFrameStrata'] = "2-LOW"
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedBelowTop'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedLeft'] = 'Skada'
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedMain'] = 'Skada'
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedRight'] = 'Skada'
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystem'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystemDual'] = true
		AddOnSkinsDB["profiles"]["BenikUI"]['SkadaBackdrop'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['TransparentEmbed'] = true
	end
	
	if IsAddOnLoaded('Details') then
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedFrameStrata'] = "2-LOW"
		AddOnSkinsDB["profiles"]["BenikUI"]['DetailsBackdrop'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedBelowTop'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedLeft'] = 'Details'
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedMain'] = 'Details'
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedRight'] = 'Details'
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystem'] = false
		AddOnSkinsDB["profiles"]["BenikUI"]['EmbedSystemDual'] = true
		AddOnSkinsDB["profiles"]["BenikUI"]['TransparentEmbed'] = true
	end
	
	if IsAddOnLoaded('DBM-Core') then
		AddOnSkinsDB["profiles"]["BenikUI"]['DBMFont'] = 'Bui Prototype'
		AddOnSkinsDB["profiles"]["BenikUI"]['DBMFont'] = 'Bui Prototype'
		AddOnSkinsDB["profiles"]["BenikUI"]['DBMFontSize'] = 10
		AddOnSkinsDB["profiles"]["BenikUI"]['DBMRadarTrans'] = true
	end

	local db = LibStub("AceDB-3.0"):New(AddOnSkinsDB, nil, true)
	db:SetProfile("BenikUI")
end