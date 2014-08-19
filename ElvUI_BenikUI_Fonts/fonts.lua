
local benikUIfont = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"

local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()
	SetFont(QuestFont_Large, 		benikUIfont, 11, nil);
	QuestFont_Shadow_Huge:SetShadowOffset(0, 0)
	SetFont(QuestFont_Shadow_Huge, 	benikUIfont, 15, nil);
	

	DAMAGE_TEXT_FONT = benikUIfont;
	UNIT_NAME_FONT = benikUIfont;

end)