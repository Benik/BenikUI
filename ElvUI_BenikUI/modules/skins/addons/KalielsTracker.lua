local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function KalielsTracker()
	if not (BUI:IsAddOnEnabled('!KalielsTracker') and E.db.benikui.skins.variousSkins.kt) then return end

	_G['!KalielsTrackerBackground']:BuiStyle()

	local ktButton = _G['!KalielsTrackerActiveButton']
	if ktButton then
		ktButton:StripTextures()
		ktButton:StyleButton()
		ktButton:SetTemplate()
		ktButton.icon:SetDrawLayer('ARTWORK', -1)
		ktButton.icon:SetTexCoords()
		ktButton.icon:SetInside()
		if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
			ktButton:CreateSoftShadow()
		end
	end

	-- Skin the EditMode
	local ACD = _G.LibStub("MSA-AceConfigDialog-3.0", true)
	if ACD then
		hooksecurefunc(ACD, "Open", function(self, appName)
			local widget = self.OpenFrames and self.OpenFrames[appName]

			if widget and widget.frame and not widget.frame.isSkinned then
				local f = widget.frame

				f:StripTextures()
				f:SetTemplate("Transparent")
				f:BuiStyle()

				if widget.closebutton then
					S:HandleButton(widget.closebutton)
				end

				if widget.titlebg then widget.titlebg:SetAlpha(0) end
				if widget.statbg then widget.statbg:SetAlpha(0) end

				f.isSkinned = true
			end
		end)
	end

	local GUI = _G.LibStub("AceGUI-3.0", true)
	if GUI then
		hooksecurefunc(GUI, "RegisterAsWidget", function(_, widget)
			local slider = widget.slider
			if slider and not slider.isSkinned then
				S:HandleSliderFrame(slider)
				slider.isSkinned = true
			end
		end)
	end
end
S:AddCallback("BenikUI_KalielsTracker", KalielsTracker)