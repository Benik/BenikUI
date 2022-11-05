local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')

local _G = _G
local pairs = pairs

function mod:stylePlugins()
	-- LocationPlus
	if BUI.LP and E.db.benikui.skins.elvuiAddons.locplus then
		local framestoskin = {
			_G.LocPlusLeftDT,
			_G.LocPlusRightDT,
			_G.LocationPlusPanel,
			_G.XCoordsPanel,
			_G.YCoordsPanel
		}
		for _, frame in pairs(framestoskin) do
			if frame then
				frame:BuiStyle("Outside")
			end
		end
	end

	-- Shadow & Light
	if BUI.SLE and E.db.benikui.skins.elvuiAddons.sle then
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
				frame:BuiStyle("Outside")
			end
		end

		-- fix shadow overlap
		if BUI.ShadowMode then
			_G.SLE_LocationPanel_X:Point('RIGHT', _G.SLE_LocationPanel, 'LEFT', -2, 0)
			_G.SLE_LocationPanel_Y:Point('LEFT', _G.SLE_LocationPanel, 'RIGHT', 2, 0)
		end
	end

	-- SquareMinimapButtons
	if BUI.PA and E.db.benikui.skins.elvuiAddons.pa then
		local smbFrame = _G.SquareMinimapButtonBar
		if smbFrame then
			smbFrame:BuiStyle("Outside")
		end
	end

	-- ElvUI_Enhanced
	if IsAddOnLoaded("ElvUI_Enhanced") and E.db.benikui.skins.elvuiAddons.enh then
		if _G.MinimapButtonBar then
			_G.MinimapButtonBar:BuiStyle("Outside")
		end

		if _G.RaidMarkerBar then
			_G.RaidMarkerBar:BuiStyle("Outside")
		end
	end

	-- stAddonManager
	if BUI.PA and E.db.benikui.skins.elvuiAddons.pa then
		local stFrame = _G.stAMFrame
		if stFrame then
			stFrame:BuiStyle("Outside")
			stAMAddOns:SetTemplate("Transparent")
		end

		local profileFrame = _G.stAMProfileMenu
		if profileFrame then
			profileFrame:BuiStyle("Outside")
		end
	end

	-- MerathilisUI
	if BUI.MER and E.db.benikui.skins.elvuiAddons.mer then
		local topPanel = _G.MER_TopPanel
		local bottomPanel = _G.MER_BottomPanel

		if topPanel then
			topPanel:BuiStyle('Under')
		end

		if bottomPanel then
			bottomPanel:BuiStyle('Outside')
		end
	end
end
