local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')
local mod = BUI:GetModule('Skins')

function mod:BigWigs()
	if E.db.benikui.skins.variousSkins.bigwigsSkin ~= true then return end

	local barsPlugin = BigWigs:GetPlugin("Bars", true)
	if not barsPlugin then return end

	local function removeStyle(bar)
		local bd = bar.candyBarBackdrop
		bd:Hide()
		if bd.iborder then
			bd.iborder:Hide()
			bd.oborder:Hide()
		end

		local restore = bar:Get("bigwigs:restoreicon")
		if restore then
			local iconBd = bar.candyBarIconFrameBackdrop
			iconBd:Hide()
			if iconBd.iborder then
				iconBd.iborder:Hide()
				iconBd.oborder:Hide()
			end
		end
	end

	local function styleBar(bar)
		local shadowsEnabled = (E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows)
		local bd = bar.candyBarBackdrop
		bd:ClearAllPoints()

		bd:SetTemplate("Transparent")
		bd:SetOutside(bar)

		if not E.PixelMode and bd.iborder then
			bd.iborder:Show()
			bd.oborder:Show()
		end

		if shadowsEnabled then
			bd:CreateSoftShadow()
		end

		bd:Show()

		local iconTexture = bar:GetIcon()
		if iconTexture then
			local reApplyIcon = false
			local statusbar = bar.candyBarBar
			local iconFrame = bar.candyBarIconFrame
			local iconBd = bar.candyBarIconFrameBackdrop

			if iconFrame.IsAnchoringSecret and iconFrame:IsAnchoringSecret() then
				iconFrame:SetToDefaults()
				iconBd:SetToDefaults()
				iconBd:SetFrameLevel(0)
				reApplyIcon = true
			end

			statusbar:ClearAllPoints()
			iconFrame:ClearAllPoints()
			iconBd:ClearAllPoints()

			if bar:GetIconPosition() == "RIGHT" then
				statusbar:Point("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
				statusbar:Point("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)

				iconFrame:Point("TOPLEFT", statusbar, "TOPRIGHT", 4, 0)
				iconFrame:Point("BOTTOMLEFT", statusbar, "BOTTOMRIGHT", 4, 0)
			else
				statusbar:Point("TOPLEFT", bar, "TOPLEFT", 0, 0)
				statusbar:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

				iconFrame:Point("TOPRIGHT", statusbar, "TOPLEFT", -4, 0)
				iconFrame:Point("BOTTOMRIGHT", statusbar, "BOTTOMLEFT", -4, 0)
			end

			bar:Set("bigwigs:restoreicon", true)
			iconBd:SetTemplate("Transparent")
			iconBd:SetOutside(iconFrame)

			if not E.PixelMode and iconBd.iborder then
				iconBd.iborder:Show()
				iconBd.oborder:Show()
			end

			if shadowsEnabled then
				iconBd:CreateSoftShadow()
			end

			iconBd:Show()

			if reApplyIcon then
				iconFrame:SetTexture(iconTexture)
				iconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			end
		end
	end

	local function styleHalfBar(bar)
		local shadowsEnabled = (E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows)

		local statusbar = bar.candyBarBar
		local bd = bar.candyBarBackdrop
		local candyBarLabel = bar.candyBarLabel
		local candyBarDuration = bar.candyBarDuration
		local barHeight = bar:GetHeight()

		bar:Set("bigwigs:restoreheight", barHeight)
		bar:SetHeight(barHeight / 2)

		candyBarLabel:ClearAllPoints()
		candyBarDuration:ClearAllPoints()
		statusbar:ClearAllPoints()

		if bd.SetToDefaults then
			bd:SetToDefaults()
			bd:SetFrameLevel(0)
		end
		bd:ClearAllPoints()

		bd:SetTemplate("Transparent")
		bd:SetOutside(bar)

		if not E.PixelMode and bd.iborder then
			bd.iborder:Show()
			bd.oborder:Show()
		end

		if shadowsEnabled then
			bd:CreateSoftShadow()
		end

		bd:Show()

		local iconTexture = bar:GetIcon()
		if iconTexture then
			local reApplyIcon = false
			local iconFrame = bar.candyBarIconFrame
			local iconBd = bar.candyBarIconFrameBackdrop

			if iconFrame.IsAnchoringSecret and iconFrame:IsAnchoringSecret() then
				iconFrame:SetToDefaults()
				iconBd:SetToDefaults()
				iconBd:SetFrameLevel(0)
				reApplyIcon = true
			end

			iconFrame:ClearAllPoints()
			iconBd:ClearAllPoints()

			local iconSize = bar:GetHeight() * 2
			iconFrame:Size(iconSize+4, iconSize+4)

			if bar:GetIconPosition() == "RIGHT" then
				statusbar:Point("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
				statusbar:Point("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)

				iconFrame:Point("BOTTOMLEFT", statusbar, "BOTTOMRIGHT", 4, 0)

			else
				statusbar:Point("TOPLEFT", bar, "TOPLEFT", 0, 0)
				statusbar:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

				iconFrame:Point("BOTTOMRIGHT", statusbar, "BOTTOMLEFT", -4, 0)
			end

			bar:Set("bigwigs:restoreicon", true)
			iconBd:SetTemplate("Transparent")
			iconBd:SetOutside(iconFrame)

			if not E.PixelMode and iconBd.iborder then
				iconBd.iborder:Show()
				iconBd.oborder:Show()
			end

			if shadowsEnabled then
				iconBd:CreateSoftShadow()
			end

			iconBd:Show()

			if reApplyIcon then
				iconFrame:SetTexture(iconTexture)
				iconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			end
		end

		bar.candyBarLabel:Point("LEFT", bar, "LEFT", 2, 12)
		bar.candyBarLabel:Point("RIGHT", bar, "RIGHT", -2, 12)

		bar.candyBarDuration:Point("LEFT", bar, "LEFT", 2, 12)
		bar.candyBarDuration:Point("RIGHT", bar, "RIGHT", -2, 12)
	end

	_G.BigWigsAPI:RegisterBarStyle(BUI.Title, {
		apiVersion = 1,
		version = 10,
		barSpacing = (E.PixelMode and 4 or 8) or 4,
		barHeight = 20,
		fontSizeNormal = 12,
		fontSizeEmphasized = 12,
		spellIndicatorsOffset = 30,
		spellIndicatorsSize = 3,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return BUI.Title end,
	})

	_G.BigWigsAPI:RegisterBarStyle(BUI.Title..'Half Bar', {
		apiVersion = 1,
		version = 10,
		barSpacing = (E.PixelMode and 16 or 18) or 16,
		barHeight = 12,
		fontSizeNormal = 12,
		fontSizeEmphasized = 12,
		spellIndicatorsOffset = 30,
		spellIndicatorsSize = 3,
		ApplyStyle = styleHalfBar,
		BarStopped = removeStyle,
		GetStyleName = function() return BUI.Title..'Half Bar' end,
	})
end
S:AddCallbackForAddon("BigWigs_Plugins", "BenikUI_BigWigs", mod.BigWigs)