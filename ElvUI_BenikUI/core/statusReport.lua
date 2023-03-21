local BUI, E, L, V, P, G = unpack((select(2, ...)))

local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns

local function AreOtherAddOnsEnabled()
	local name
	for i = 1, GetNumAddOns() do
		name = GetAddOnInfo(i)
		if ((name ~= "ElvUI" and name ~= "ElvUI_Options" and name ~= 'ElvUI_Libraries' and name ~= "ElvUI_BenikUI") and E:IsAddOnEnabled(name)) then --Loaded or load on demand
			return "Yes"
		end
	end
	return "No"
end

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

	-- Content lines
	StatusFrame.Section1.Content.Line2.Text:SetFormattedText("Other AddOns Enabled: |cff4beb2c%s|r", AreOtherAddOnsEnabled())
end

hooksecurefunc(E, "UpdateStatusFrame", CreateStatusFrame)