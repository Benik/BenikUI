local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local BP = BUI:GetModule('customPanels');

local tinsert = table.insert

local PanelSetup = {
	['name'] = "",
}

local deleteName = ""

local strataValues = {
	["BACKGROUND"] = "BACKGROUND",
	["LOW"] = "LOW",
	["MEDIUM"] = "MEDIUM",
	["HIGH"] = "HIGH",
	["DIALOG"] = "DIALOG",
	["TOOLTIP"] = "TOOLTIP",
}

local function updateOptions()
	for panelname in pairs(E.db.benikui.panels) do
		E.Options.args.benikui.args.panels.args[panelname] = {
			order = 1,
			name = panelname,
			type = 'group',
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = ENABLE,
					width = 'full',
					get = function(info) return E.db.benikui.panels[panelname].enable end,
					set = function(info, value) E.db.benikui.panels[panelname].enable = value; BP:SetupPanels() end,
				},
				generalOptions = {
					order = 2,
					type = 'multiselect',
					name = '',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info, key) return E.db.benikui.panels[panelname][key] end,
					set = function(info, key, value) E.db.benikui.panels[panelname][key] = value; BP:SetupPanels() end,
					values = {
						transparency = L["Panel Transparency"],
						style = L["BenikUI Style"],
						shadow = L["Shadow"],
						clickThrough = L["Click Through"],
					}
				},
				width = {
					order = 11,
					type = "range",
					name = L['Width'],
					min = 50, max = E.screenwidth, step = 1,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info, value) return E.db.benikui.panels[panelname].width end,
					set = function(info, value) E.db.benikui.panels[panelname].width = value; BP:Resize() end,
				},
				height = {
					order = 12,
					type = "range",
					name = L['Height'],
					min = 10, max = E.screenheight, step = 1,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info, value) return E.db.benikui.panels[panelname].height end,
					set = function(info, value) E.db.benikui.panels[panelname].height = value; BP:Resize() end,
				},
				strata = {
					order = 13,
					type = 'select',
					name = L["Frame Strata"],
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info) return E.db.benikui.panels[panelname].strata end,
					set = function(info, value) E.db.benikui.panels[panelname].strata = value; BP:SetupPanels() end,
					values = strataValues,
				},
				spacer2 = {
					order = 20,
					type = 'description',
					name = '',
				},
				petHide = {
					order = 21,
					name = L["Hide in Pet Battle"],
					type = 'toggle',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function() return E.db.benikui.panels[panelname].petHide end,
					set = function(info, value) E.db.benikui.panels[panelname].petHide = value; BP:RegisterHide() end,
				},
				combatHide = {
					order = 22,
					name = L["Hide In Combat"],
					type = 'toggle',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function() return E.db.benikui.panels[panelname].combatHide end,
					set = function(info, value) E.db.benikui.panels[panelname].combatHide = value; end,
				},
				vehicleHide = {
					order = 23,
					name = L["Hide In Vehicle"],
					type = 'toggle',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function() return E.db.benikui.panels[panelname].vehicleHide end,
					set = function(info, value) E.db.benikui.panels[panelname].vehicleHide = value; end,
				},
				visibility = {
					type = 'input',
					order = 24,
					name = L["Visibility State"],
					desc = L["This works like a macro, you can run different situations to get the panel to show/hide differently.\n Example: '[combat] show;hide'"],
					width = 'full',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					multiline = true,
					get = function() return E.db.benikui.panels[panelname].visibility end,
					set = function(info, value)
						if value and value:match('[\n\r]') then
							value = value:gsub('[\n\r]','')
						end
						E.db.benikui.panels[panelname].visibility = value;
						BP:SetupPanels()
					end,
				},
				spacer3 = {
					order = 30,
					type = 'description',
					name = '',
				},
				tooltip = {
					order = 31,
					name = L["Name Tooltip"],
					desc = L["Enable tooltip to reveal the panel name"],
					type = 'toggle',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function() return E.db.benikui.panels[panelname].tooltip end,
					set = function(info, value) E.db.benikui.panels[panelname].tooltip = value; end,
				},
				spacer4 = {
					order = 40,
					type = 'header',
					name = '',
				},
				delete = {
					order = 41,
					name = DELETE,
					type = 'execute',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					func = function()
						deleteName = panelname
						E.PopupDialogs["BUI_Panel_Delete"].OnAccept = function() BP:DeletePanel(panelname) end
						E.PopupDialogs["BUI_Panel_Delete"].text = (format(L["This will delete the Custom Panel named |cff00c0fa%s|r. This action will require a reload.\nContinue?"], deleteName))
						E:StaticPopup_Show("BUI_Panel_Delete")
					end,
				},
			},
		}
	end
end

local function panelsTable()
	E.Options.args.benikui.args.panels = {
		type = "group",
		name = E.NewSign..L["Custom Panels"],
		order = 70,
		childGroups = "select",
		args = {
			createButton = {
				order = 1,
				name = L["Create"],
				type = 'execute',
				func = function()
					if E.global.benikui.CustomPanels.createButton == true then
						E.global.benikui.CustomPanels.createButton = false
					else
						E.global.benikui.CustomPanels.createButton = true
					end
				end,
			},
			spacer1 = {
				order = 2,
				type = 'description',
				name = '',
			},
			name = {
				order = 3,
				type = 'input',
				width = 'double',
				name = L["Name"],
				desc = L["Type a unique name for the new panel. \n|cff00c0faNote: 'BenikUI_' will be added at the beginning, to ensure uniqueness|r"],
				hidden = function() return not E.global.benikui.CustomPanels.createButton end,
				get = function(info) return PanelSetup.name end,
				set = function(info, textName)
					local name = 'BenikUI_'..textName
					for object in pairs(E.db.benikui.panels) do
						if object:lower() == name:lower() then
							E.PopupDialogs["BUI_Panel_Name"].text = (format(L["The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one."], name))
							E:StaticPopup_Show("BUI_Panel_Name")
							return
						end
					end
					PanelSetup.name = textName
				end,
			},
			spacer2 = {
				order = 4,
				type = 'description',
				name = '',
			},
			add = {
				order = 5,
				name = ADD,
				type = 'execute',
				disabled = function() return PanelSetup.name == "" end,
				hidden = function() return not E.global.benikui.CustomPanels.createButton end,
				func = function()
					BP:InsertPanel(PanelSetup.name)
					BP:UpdatePanels()
					updateOptions()
					E.global.benikui.CustomPanels.createButton = false;
				end,
			},
			spacer3 = {
				order = 6,
				type = 'description',
				name = '',
			},
		},
	}
	
	updateOptions()
end
tinsert(BUI.Config, panelsTable)

E.PopupDialogs["BUI_Panel_Delete"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["BUI_Panel_Name"] = {
	button1 = OKAY,
	OnAccept = E.noop,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}