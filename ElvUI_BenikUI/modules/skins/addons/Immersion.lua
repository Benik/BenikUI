local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local next = next
local ipairs = ipairs
local tinsert, tsort = table.insert, table.sort

local hooksecurefunc = hooksecurefunc

local function Immersion()
	if not (BUI:IsAddOnEnabled('Immersion') and E.db.benikui.skins.variousSkins.immersion) then return end

	local ImmersionFrame = _G.ImmersionFrame
	if not ImmersionFrame then return end

	local hasShadows = E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows
	local Talkbox = ImmersionFrame.TalkBox

	S:HandleFrame(Talkbox.BackgroundFrame)
	Talkbox.BackgroundFrame:BuiStyle("Inside")
	S:HandleFrame(Talkbox.Elements)

	if hasShadows then
		Talkbox.Elements:CreateSoftShadow()
	end

	S:HandleCloseButton(Talkbox.MainFrame.CloseButton)

	Talkbox.PortraitFrame:StripTextures()

	local area = {"TopEdge", "Center", "BottomEdge", "BottomLeftCorner", "BottomRightCorner", "LeftEdge", "RightEdge", "TopLeftCorner", "TopRightCorner", "HighlightTexture", "Overlay"}
	hooksecurefunc(ImmersionFrame.TitleButtons, "UpdateActive", function(self)
		for _, button in next, self.Buttons do
			if button:IsShown() and not button.isSkinned then
				for _, region in ipairs(area) do
					if button[region] then
						button[region]:Hide()
					end
				end

				if not button.backdrop then
					button:CreateBackdrop("Transparent")
				end
			end
		end

		if not hasShadows then return end

		local spacing = 4
		local lastButton = nil
		local activeButtons = {}

		for i, button in next, self.Buttons do
			if button and button:IsShown() then
				tinsert(activeButtons, { index = i, btn = button })
			end
		end
		tsort(activeButtons, function(a, b) return a.index < b.index end)

		for _, entry in ipairs(activeButtons) do
			local button = entry.btn

			button.backdrop:CreateSoftShadow()
			button:ClearAllPoints()

			if not lastButton then
				button:Point("TOP", 0, 0)
			else
				button:Point("TOP", lastButton, "BOTTOM", 0, -spacing)
			end

			lastButton = button
		end
	end)

	local pool = ImmersionFrame.Inspector.tooltipFramePool
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
S:AddCallbackForAddon("Immersion", "BenikUI_Immersion", Immersion)