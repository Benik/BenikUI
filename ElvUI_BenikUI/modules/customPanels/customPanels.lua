local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('customPanels', 'AceEvent-3.0')

local tcopy = table.copy

local PanelDefault = {
	['enable'] = true,
	['width'] = 200,
	['height'] = 200,
	['point'] = "CENTER",
	['transparency'] = true,
	['style'] = true,
	['shadow'] = true,
	['clickThrough'] = false,
	['strata'] = "LOW",
	['combatHide'] = true,
	['petHide'] = true,
	['vehicleHide'] = true,
	['tooltip'] = true,
	['visibility'] = "",
}

local function OnEnter(self)
	if E.db.benikui.panels[self.Name].tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:AddLine(self.Name, 0.7, 0.7, 1)
		GameTooltip:Show()
	end
end

local function OnLeave(self)
	if E.db.benikui.panels[self.Name].tooltip then
		GameTooltip:Hide()
	end
end

function mod:InsertPanel(name)
	if name == "" then return end
	name = "BenikUI_"..name
	local db = E.db.benikui.panels
	if not db[name] then
		db[name] = PanelDefault
	else
		E:StaticPopup_Show("BUI_Panel_Name")
	end
end

function mod:CreatePanel()
	if not E.db.benikui.panels then E.db.benikui.panels = {} end
	for name in pairs(E.db.benikui.panels) do
		if name and not _G[name] then
			local panel = CreateFrame("Frame", name, E.UIParent)
			panel:Width(name.width or 200)
			panel:Height(name.height or 200)
			panel:SetTemplate('Transparent')
			panel:Point('CENTER', E.UIParent, 'CENTER', -600, 0)
			panel:Style('Outside')
			if BUI.ShadowMode then panel:CreateSoftShadow() end
			panel:SetScript("OnEnter", OnEnter)
			panel:SetScript("OnLeave", OnLeave)
			if not _G[name.."_Mover"] then
				E:CreateMover(_G[name], name.."_Mover", name, nil, nil, nil, "ALL,MISC,BENIKUI")
			end

			panel.Name = name
		end
	end
end

function mod:Resize()
	if not E.db.benikui.panels then E.db.benikui.panels = {} end
	for name in pairs(E.db.benikui.panels) do
		if name and _G[name] then
			local db = E.db.benikui.panels[name]
			if not db.width and not db.height then return end
			_G[name]:SetSize(db.width, db.height)
		end
	end
end

function mod:SetupPanels()
	for panel in pairs(E.db.benikui.panels) do
		if panel then
			local db = E.db.benikui.panels[panel]

			local visibility = db.visibility
			if visibility and visibility:match('[\n\r]') then
				visibility = visibility:gsub('[\n\r]','')
			end

			_G[panel]:EnableMouse(not db.clickThrough)

			if db.enable then
				_G[panel]:Show()
				E:EnableMover(_G[panel].mover:GetName())
				RegisterStateDriver(_G[panel], "visibility", visibility)
			else
				_G[panel]:Hide()
				E:DisableMover(_G[panel].mover:GetName())
				UnregisterStateDriver(_G[panel], "visibility")
			end

			_G[panel]:SetFrameStrata(db.strata or 'LOW')
			if db.transparency then
				_G[panel]:SetTemplate("Transparent")
			else
				_G[panel]:SetTemplate("Default", true)
			end

			if BUI.ShadowMode then
				if db.shadow then
					_G[panel].shadow:Show()
					_G[panel].style.styleShadow:Show()
				else
					_G[panel].shadow:Hide()
					_G[panel].style.styleShadow:Hide()
				end
			end

			if _G[panel].style then
				if db.style then
					_G[panel].style:Show()
				else
					_G[panel].style:Hide()
				end
			end

		end
	end
end

function mod:DeletePanel(name)
	if E.db.benikui.panels[name] then
		E.db.benikui.panels[name] = nil

		for _, data in pairs(ElvDB.profiles) do
			if data.movers and data.movers[name.."_Mover"] then data.movers[name.."_Mover"] = nil end
		end
	end
	ReloadUI()
end

function mod:OnEvent(event, unit)
	if unit and unit ~= "player" then return end
	local inCombat = (event == "PLAYER_REGEN_DISABLED" and true) or (event == "PLAYER_REGEN_ENABLED" and false) or InCombatLockdown()
	local inVehicle = (event == "UNIT_ENTERING_VEHICLE" and true) or (event == "UNIT_EXITING_VEHICLE" and false) or UnitInVehicle("player")
	for name in pairs(E.db.benikui.panels) do
		if name then
			local db = E.db.benikui.panels[name]
			if (db.enable ~= true) or (inCombat and db.combatHide) or (inVehicle and db.vehicleHide) then
				_G[name]:Hide()
			else
				_G[name]:Show()
			end
		end
	end
end

function mod:RegisterHide()
	for name in pairs(E.db.benikui.panels) do
		if name then
			local db = E.db.benikui.panels[name]
			if db.petHide then
				E.FrameLocks[name] = true
			else
				E.FrameLocks[name] = nil
			end
		end
	end
end

function mod:UpdatePanels()
	mod:CreatePanel()
	mod:SetupPanels()
	mod:Resize()
	mod:RegisterHide()
end

function mod:Initialize()
	mod:UpdatePanels()
	mod:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
	mod:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
	mod:RegisterEvent("UNIT_ENTERING_VEHICLE", "OnEvent")
	mod:RegisterEvent("UNIT_EXITING_VEHICLE", "OnEvent")
end

BUI:RegisterModule(mod:GetName())