local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')

function mod:stylePlugins()
	-- LocationPlus
	if BUI.LP and E.db.benikuiSkins.elvuiAddons.locplus then
		local framestoskin = {
			_G.LocPlusLeftDT,
			_G.LocPlusRightDT,
			_G.LocationPlusPanel,
			_G.XCoordsPanel,
			_G.YCoordsPanel
		}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:Style("Outside")
			end
		end
	end

	-- Shadow & Light
	if BUI.SLE and E.db.benikuiSkins.elvuiAddons.sle then
		local sleFrames = {
			_G.SLE_BG_1,
			_G.SLE_BG_2,
			_G.SLE_BG_3,
			_G.SLE_BG_4,
			_G.SLE_RaidMarkerBar,
			_G.SLE_SquareMinimapButtonBar,
			_G.SLE_LocationPanel,
			_G.SLE_LocationPanel_X,
			_G.SLE_LocationPanel_Y,
			_G.SLE_LocationPanel_RightClickMenu1,
			_G.SLE_LocationPanel_RightClickMenu2,
			_G.InspectArmory
		}
		for _, frame in pairs(sleFrames) do
			if frame then
				frame:Style("Outside")
			end
		end
	end

	-- SquareMinimapButtons
	if BUI.PA and E.db.benikuiSkins.elvuiAddons.pa then
		local smbFrame = _G.SquareMinimapButtonBar
		if smbFrame then
			smbFrame:Style("Outside")
		end
	end

	-- ElvUI_Enhanced
	if IsAddOnLoaded("ElvUI_Enhanced") and E.db.benikuiSkins.elvuiAddons.enh then
		if _G.MinimapButtonBar then
			_G.MinimapButtonBar:Style("Outside")
		end

		if _G.RaidMarkerBar then
			_G.RaidMarkerBar:Style("Outside")
		end
	end

	-- stAddonManager
	if BUI.PA and E.db.benikuiSkins.elvuiAddons.pa then
		local stFrame = _G.stAMFrame
		if stFrame then
			stFrame:Style("Outside")
			stAMAddOns:SetTemplate("Transparent")
		end
	end
end