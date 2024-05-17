local BUI, E, L, V, P, G = unpack((select(2, ...)))

local function CreateStatusFrame()
	local StatusFrame = ElvUIStatusReport

	-- style
	StatusFrame.backdrop:BuiStyle('Outside')
	StatusFrame.PluginFrame.backdrop:BuiStyle('Outside')
	-- hide the logo. Sorry Elv :P
	StatusFrame.TitleLogoFrame.LogoTop:SetTexture(nil)
	StatusFrame.TitleLogoFrame.LogoBottom:SetTexture(nil)

	-- create the report title
	StatusFrame.TitleLogoFrame.Title = StatusFrame.TitleLogoFrame:CreateFontString(nil, "ARTWORK")
	StatusFrame.TitleLogoFrame.Title:FontTemplate(nil, 18, "OUTLINE")
	StatusFrame.TitleLogoFrame.Title:Point("BOTTOM", 0, 7)
	StatusFrame.TitleLogoFrame.Title:SetJustifyH("CENTER")
	StatusFrame.TitleLogoFrame.Title:SetJustifyV("MIDDLE")
	StatusFrame.TitleLogoFrame.Title:SetFormattedText("|cfffe7b2c- ElvUI Status Report -|r")
end

hooksecurefunc(E, "UpdateStatusFrame", CreateStatusFrame)