local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins')

local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function Immersion()
	if not (BUI:IsAddOnEnabled('Immersion') and E.db.benikui.skins.variousSkins.immersion) then return end

	local frame = _G.ImmersionFrame.TalkBox
	if not frame then return end

	local hasShadows = E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows

	S:HandleFrame(frame.BackgroundFrame)
	frame.BackgroundFrame:BuiStyle("Inside")
	frame.Hilite:Hide()
	S:HandleFrame(frame.Elements)

	if hasShadows then
		frame.Elements:CreateSoftShadow()
	end

	S:HandleCloseButton(frame.MainFrame.CloseButton)

	frame.PortraitFrame:StripTextures()

	local area = {"TopEdge", "Center", "BottomEdge", "BottomLeftCorner", "BottomRightCorner", "LeftEdge", "RightEdge", "TopLeftCorner", "TopRightCorner", "HighlightTexture", "Overlay", "Hilite"}
	hooksecurefunc(_G.ImmersionFrame.TitleButtons, "UpdateActive", function(self)
		for _, button in pairs(self.Buttons) do
			if button.isSkinned then return end

			if button:IsShown() then
				for _, region in ipairs(area) do
					button[region]:Hide()
				end
				S:HandleButton(button)
				button:CreateBackdrop("Transparent")
				button.isSkinned = true
			end
		end

		if not hasShadows then return end

		local spacing = 6
		local lastButton = nil

		for i, button in pairs(self.Buttons) do
			button.backdrop:CreateSoftShadow()
			button:ClearAllPoints()

			if i == 1 then
				button:Point("TOPLEFT", self, "TOPLEFT", 0, 0)
				button:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)
			else
				button:Point("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -spacing)
				button:Point("TOPRIGHT", lastButton, "BOTTOMRIGHT", 0, -spacing)
			end
			lastButton = button
		end
    end)

	local pool = _G.ImmersionFrame.Inspector.tooltipFramePool
	local original_Acquire = pool.Acquire

	pool.Acquire = function(self, ...)
		local tooltip = original_Acquire(self, ...)

		if tooltip then
			tooltip:HookScript("OnShow", function(self)
				self:BuiStyle()
			end)
		end

		return tooltip
	end
end
S:AddCallback("BenikUI_Immersion", Immersion)