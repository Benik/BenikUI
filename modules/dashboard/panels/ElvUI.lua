
ElvDB = {
	["faction"] = {
		["Emerald Dream"] = {
			["Horde"] = {
			},
			["Alliance"] = {
				["Benibee"] = 225604383,
			},
		},
	},
	["profileKeys"] = {
		["Adonela - Mazrigos"] = "Adonela - Mazrigos",
		["Felinn - Mazrigos"] = "Felinn - Mazrigos",
		["Benibee - Emerald Dream"] = "Benibee - Emerald Dream",
		["Benikia - Emerald Dream"] = "Benikia - Emerald Dream",
		["Nitali - Emerald Dream"] = "Nitali - Emerald Dream",
		["Benica - Emerald Dream"] = "Benica - Emerald Dream",
		["Moli - Mazrigos"] = "Moli - Mazrigos",
		["Benicio - Emerald Dream"] = "Benicio - Emerald Dream",
		["Benik - Emerald Dream"] = "Benik - Emerald Dream",
		["Beniman - Emerald Dream"] = "Beniman - Emerald Dream",
		["Shaobin - Emerald Dream"] = "Bentium - Emerald Dream",
		["Lasi - Mazrigos"] = "Lasi - Mazrigos",
		["Jenei - Aerie Peak"] = "Jenei - Aerie Peak",
		["Benazir - Emerald Dream"] = "Benazir - Emerald Dream",
		["Bentium - Emerald Dream"] = "Bentium - Emerald Dream",
		["Poliana - Aerie Peak"] = "Poliana - Aerie Peak",
	},
	["gold"] = {
		["Emerald Dream"] = {
			["Benibee"] = 226447499,
			["Benica"] = 730521,
			["Benicio"] = 4549867,
			["Benikia"] = 1035747,
			["Shaobin"] = 10432,
			["Bentium"] = 27059389,
			["Nitali"] = 410,
			["Beniman"] = 1763,
			["Benik"] = 571420843,
			["Benazir"] = 186717317,
		},
		["Mazrigos"] = {
			["Moli"] = 12,
			["Lasi"] = 13,
			["Felinn"] = 57,
			["Adonela"] = 118,
		},
		["Aerie Peak"] = {
			["Jenei"] = 18,
			["Poliana"] = 0,
		},
	},
	["namespaces"] = {
		["LibDualSpec-1.0"] = {
		},
	},
	["class"] = {
		["Emerald Dream"] = {
			["Benibee"] = "ROGUE",
		},
	},
	["global"] = {
		["unitframe"] = {
			["aurafilters"] = {
				["Blacklist"] = {
					["spells"] = {
						["Deadly Poison"] = {
							["enable"] = true,
							["priority"] = 0,
						},
						["Food"] = {
							["enable"] = true,
							["priority"] = 0,
						},
						["Fishing"] = {
							["enable"] = true,
							["priority"] = 0,
						},
						["Well Fed"] = {
							["enable"] = true,
							["priority"] = 0,
						},
						["Alchemist Stone"] = {
							["enable"] = true,
							["priority"] = 0,
						},
						["Drink"] = {
							["enable"] = true,
							["priority"] = 0,
						},
						["Luck of the Lotus"] = {
							["enable"] = true,
							["priority"] = 0,
						},
						["Enhanced Agility"] = {
							["enable"] = true,
							["priority"] = 0,
						},
					},
				},
			},
		},
	},
	["profiles"] = {
		["Adonela - Mazrigos"] = {
			["general"] = {
				["valuecolor"] = {
					["b"] = 0.819,
					["g"] = 0.513,
					["r"] = 0.09,
				},
				["bordercolor"] = {
					["b"] = 0.31,
					["g"] = 0.31,
					["r"] = 0.31,
				},
			},
			["unitframe"] = {
				["units"] = {
					["player"] = {
						["castbar"] = {
							["height"] = 28,
							["width"] = 406,
						},
					},
				},
			},
			["locplus"] = {
				["dtwidth"] = 200,
			},
			["movers"] = {
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0110",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-278110",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM042",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0195",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0150",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM038",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM278110",
			},
			["layoutSet"] = "dpsMelee",
			["datatexts"] = {
				["panels"] = {
					["LeftMiniPanel"] = "Time",
					["LeftChatDataPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Haste",
					},
					["LeftCoordDtPanel"] = "Broker_Location",
					["RightCoordDtPanel"] = "iLocation",
				},
			},
			["hideTutorial"] = 1,
			["currentTutorial"] = 1,
		},
		["Felinn - Mazrigos"] = {
			["locplus"] = {
				["dtwidth"] = 200,
			},
			["currentTutorial"] = 1,
			["general"] = {
				["valuecolor"] = {
					["r"] = 0.09,
					["g"] = 0.513,
					["b"] = 0.819,
				},
				["bordercolor"] = {
					["r"] = 0.31,
					["g"] = 0.31,
					["b"] = 0.31,
				},
			},
			["movers"] = {
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM278110",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-278110",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0195",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM042",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0150",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM038",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0110",
			},
			["layoutSet"] = "dpsMelee",
			["datatexts"] = {
				["panels"] = {
					["LeftChatDataPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Haste",
					},
					["LeftCoordDtPanel"] = "Broker_Location",
					["RightCoordDtPanel"] = "iLocation",
				},
			},
			["hideTutorial"] = 1,
			["unitframe"] = {
				["units"] = {
					["player"] = {
						["castbar"] = {
							["height"] = 28,
							["width"] = 406,
						},
					},
				},
			},
		},
		["Benibee - Emerald Dream"] = {
			["bui"] = {
				["installed"] = true,
			},
			["currentTutorial"] = 1,
			["general"] = {
				["fontSize"] = 10,
				["stickyFrames"] = false,
				["reputation"] = {
					["textFormat"] = "CURPERC",
					["textSize"] = 8,
					["width"] = 180,
				},
				["minimap"] = {
					["locationText"] = "HIDE",
					["size"] = 150,
				},
				["font"] = "Bui Prototype",
				["bottomPanel"] = false,
				["backdropfadecolor"] = {
					["r"] = 0.054,
					["g"] = 0.054,
					["b"] = 0.054,
				},
				["valuecolor"] = {
					["a"] = 1,
					["r"] = 1,
					["g"] = 0.5019607843137255,
					["b"] = 0,
				},
				["topPanel"] = false,
				["experience"] = {
					["width"] = 412,
					["textFormat"] = "CURPERC",
				},
			},
			["movers"] = {
				["PetAB"] = "BOTTOMElvUIParentBOTTOM013",
				["LocationLiteMover"] = "TOPElvUIParentTOP0-7",
				["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT222",
				["GMMover"] = "TOPLEFTElvUIParentTOPLEFT155-4",
				["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-3",
				["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0283",
				["DigSiteProgressBarMover"] = "BOTTOMElvUIParentBOTTOM0315",
				["ElvUF_RaidpetMover"] = "TOPLEFTElvUIParentTOPLEFT4-444",
				["ElvUF_FocusMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-442178",
				["MicrobarMover"] = "TOPLEFTElvUIParentTOPLEFT4-4",
				["VehicleSeatMover"] = "TOPLEFTElvUIParentTOPLEFT155-81",
				["ExperienceBarMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4204",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM231182",
				["BuiDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4211",
				["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM092",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM058",
				["ElvUF_AssistMover"] = "TOPLEFTElvUIParentTOPLEFT4-392",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0164",
				["TargetPowerBarMover"] = "BOTTOMElvUIParentBOTTOM247215",
				["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["AltPowerBarMover"] = "TOPElvUIParentTOP0-66",
				["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM29558",
				["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-29558",
				["PlayerPowerBarMover"] = "BOTTOMElvUIParentBOTTOM-231215",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-231182",
				["BossHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT-56-397",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0191",
				["BNETMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-199",
				["ShiftAB"] = "TOPLEFTElvUIParentTOPLEFT407-39",
				["ElvUF_Raid25Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT2179",
				["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM231147",
				["ArenaHeaderMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-56346",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-231147",
				["ElvUF_TankMover"] = "TOPLEFTElvUIParentTOPLEFT4-292",
				["tokenHolderMover"] = "TOPLEFTElvUIParentTOPLEFT4-119",
				["WatchFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT-122-292",
				["ReputationBarMover"] = "TOPRIGHTElvUIParentTOPRIGHT-2-181",
				["RightChatMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-222",
				["AlertFrameMover"] = "TOPElvUIParentTOP0-140",
				["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-134",
				["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-6",
			},
			["ufb"] = {
				["TargetPortraitWidth"] = 150,
				["PlayerPortraitWidth"] = 150,
				["barheight"] = 15,
				["TargetPortraitHeight"] = 150,
				["PlayerPortraitHeight"] = 150,
			},
			["hideTutorial"] = 1,
			["auras"] = {
				["timeXOffset"] = -1,
				["debuffs"] = {
					["size"] = 30,
				},
				["fontSize"] = 9,
				["fontOutline"] = "MONOCROMEOUTLINE",
				["fadeThreshold"] = 10,
				["buffs"] = {
					["horizontalSpacing"] = 3,
					["size"] = 30,
				},
				["consolidatedBuffs"] = {
					["fontSize"] = 9,
					["font"] = "Bui Visitor1",
					["fontOutline"] = "MONOCROMEOUTLINE",
				},
				["font"] = "Bui Visitor1",
			},
			["unitframe"] = {
				["font"] = "Bui Visitor1",
				["colors"] = {
					["auraBarBuff"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["health"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["castColor"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["transparentCastbar"] = true,
					["transparentAurabars"] = true,
				},
				["fontOutline"] = "NONE",
				["statusbar"] = "BuiFlat",
				["units"] = {
					["player"] = {
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["debuffs"] = {
							["attachTo"] = "BUFFS",
							["sizeOverride"] = 32,
							["yOffset"] = 2,
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["power"] = {
							["detachedWidth"] = 298,
							["height"] = 5,
							["yOffset"] = -25,
						},
						["height"] = 33,
						["buffs"] = {
							["enable"] = true,
							["sizeOverride"] = 32,
							["attachTo"] = "FRAME",
							["yOffset"] = 8,
						},
						["threatStyle"] = "ICONTOPRIGHT",
						["width"] = 300,
					},
					["raid25"] = {
						["power"] = {
							["enable"] = false,
						},
					},
					["focus"] = {
						["power"] = {
							["height"] = 5,
						},
						["width"] = 122,
						["castbar"] = {
							["height"] = 6,
							["width"] = 122,
						},
					},
					["raid10"] = {
						["power"] = {
							["power"] = false,
						},
					},
					["pet"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["targettarget"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["target"] = {
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["debuffs"] = {
							["anchorPoint"] = "TOPLEFT",
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["power"] = {
							["height"] = 5,
							["xOffset"] = 2,
							["hideonnpc"] = false,
							["detachedWidth"] = 298,
							["yOffset"] = -25,
						},
						["height"] = 33,
						["buffs"] = {
							["anchorPoint"] = "TOPLEFT",
							["sizeOverride"] = 32,
							["yOffset"] = 8,
						},
						["threatStyle"] = "ICONTOPLEFT",
						["width"] = 300,
					},
				},
			},
			["datatexts"] = {
				["font"] = "Bui Visitor1",
				["fontOutline"] = "MONOCROMEOUTLINE",
				["panelTransparency"] = true,
				["leftChatPanel"] = false,
				["panels"] = {
					["BuiRightChatDTPanel"] = {
						["middle"] = "Bags",
						["left"] = "Mastery",
					},
					["BuiLeftChatDTPanel"] = {
						["middle"] = "Haste",
						["right"] = "Mail",
					},
					["LeftChatDataPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Haste",
					},
				},
				["rightChatPanel"] = false,
			},
			["actionbar"] = {
				["bar3"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["font"] = "Bui Visitor1",
				["bar2"] = {
					["enabled"] = true,
					["buttonspacing"] = 4,
					["backdrop"] = true,
					["buttonsize"] = 30,
					["heightMult"] = 2,
				},
				["fontOutline"] = "MONOCROMEOUTLINE",
				["bar1"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["barPet"] = {
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 10,
					["buttonsize"] = 27,
				},
				["bar5"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["bar4"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 26,
				},
			},
			["layoutSet"] = "dpsMelee",
			["loclite"] = {
				["lpfont"] = "Bui Visitor1",
				["lpwidth"] = 220,
				["trunc"] = true,
				["dtheight"] = 16,
				["lpfontsize"] = 10,
			},
			["tooltip"] = {
				["healthBar"] = {
					["font"] = "Bui Prototype",
					["fontSize"] = 9,
					["fontOutline"] = "OUTLINE",
				},
			},
			["chat"] = {
				["tabFont"] = "Bui Visitor1",
				["font"] = "Bui Prototype",
				["tabFontOutline"] = "MONOCROMEOUTLINE",
				["panelHeight"] = 150,
			},
		},
		["Benikia - Emerald Dream"] = {
			["nameplate"] = {
				["font"] = "Bui Prototype",
				["fontSize"] = 8,
				["fontOutline"] = "OUTLINE",
			},
			["currentTutorial"] = 2,
			["general"] = {
				["MANA"] = {
				},
				["fontSize"] = 10,
				["stickyFrames"] = 1,
				["taintLog"] = true,
				["reputation"] = {
					["textFormat"] = "CURPERC",
					["textSize"] = 8,
					["width"] = 180,
				},
				["minimap"] = {
					["locationText"] = "HIDE",
					["size"] = 150,
				},
				["font"] = "Bui Prototype",
				["bottomPanel"] = false,
				["backdropfadecolor"] = {
					["b"] = 0.054,
					["g"] = 0.054,
					["r"] = 0.054,
				},
				["valuecolor"] = {
					["a"] = 1,
					["b"] = 0,
					["g"] = 0.5019607843137255,
					["r"] = 1,
				},
				["experience"] = {
					["textFormat"] = "CURPERC",
					["textSize"] = 10,
					["width"] = 412,
				},
				["topPanel"] = false,
				["RUNIC_POWER"] = {
				},
			},
			["xprep"] = {
				["show"] = "XP",
			},
			["ufb"] = {
				["TargetPortraitWidth"] = 150,
				["portraitHeight"] = 111,
				["TargetPortraitHeight"] = 150,
				["portraitWidth"] = 138,
				["PlayerPortraitWidth"] = 150,
				["PlayerPortraitHeight"] = 150,
				["barhide"] = true,
				["barheight"] = 15,
			},
			["hideTutorial"] = 1,
			["auras"] = {
				["timeXOffset"] = -1,
				["debuffs"] = {
					["size"] = 30,
				},
				["font"] = "Bui Visitor1",
				["fadeThreshold"] = 10,
				["buffs"] = {
					["horizontalSpacing"] = 3,
					["size"] = 30,
				},
				["consolidatedBuffs"] = {
					["font"] = "Bui Visitor1",
				},
				["fontSize"] = 9,
			},
			["locplus"] = {
				["tthideraid"] = true,
				["ttrecinst"] = false,
				["lpfont"] = "Bui Visitor1",
				["tthidepvp"] = true,
				["ttreczones"] = false,
				["ttcoords"] = false,
				["ttinst"] = false,
				["userColor"] = {
					["g"] = 0.2352941176470588,
					["b"] = 0.1529411764705883,
				},
				["tthint"] = false,
				["lpfontsize"] = 10,
				["both"] = false,
				["ttlevel"] = true,
				["lpwidth"] = 220,
				["trunc"] = true,
				["lpauto"] = false,
				["dtwidth"] = 120,
			},
			["layoutSet"] = "dpsMelee",
			["movers"] = {
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-231147",
				["LocationLiteMover"] = "TOPElvUIParentTOP0-2",
				["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT222",
				["GMMover"] = "TOPLEFTElvUIParentTOPLEFT155-4",
				["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-3",
				["TargetPowerBarMover"] = "BOTTOMElvUIParentBOTTOM247215",
				["BossButton"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT513150",
				["DigSiteProgressBarMover"] = "BOTTOMElvUIParentBOTTOM0315",
				["ElvUF_RaidpetMover"] = "TOPLEFTElvUIParentTOPLEFT4-444",
				["PlayerPortraitMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT485182",
				["ElvUF_FocusMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-442178",
				["ClassBarMover"] = "BOTTOMElvUIParentBOTTOM0207",
				["MicrobarMover"] = "TOPLEFTElvUIParentTOPLEFT4-4",
				["ElvUF_Raid25Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT2179",
				["ElvUF_AssistMover"] = "TOPLEFTElvUIParentTOPLEFT4-392",
				["ExperienceBarMover"] = "BOTTOMElvUIParentBOTTOM047",
				["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0179",
				["ElvUF_PartyMover"] = "BOTTOMElvUIParentBOTTOM0218",
				["BuiDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4211",
				["BenikButtonsMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4204",
				["VehicleSeatMover"] = "TOPLEFTElvUIParentTOPLEFT155-81",
				["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM092",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM058",
				["WatchFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT-122-292",
				["BossHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT-56-397",
				["BenikDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["LocationMover"] = "TOPElvUIParentTOP0-7",
				["AltPowerBarMover"] = "TOPElvUIParentTOP0-66",
				["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM29558",
				["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-29558",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-231182",
				["ArenaHeaderMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-56346",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0149",
				["ElvAB_6"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4215",
				["BNETMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-199",
				["ShiftAB"] = "BOTTOMElvUIParentBOTTOM04",
				["TargetPortraitMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-483182",
				["ReputationBarMover"] = "TOPRIGHTElvUIParentTOPRIGHT-2-181",
				["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM231147",
				["PetAB"] = "BOTTOMElvUIParentBOTTOM013",
				["ElvUF_TankMover"] = "TOPLEFTElvUIParentTOPLEFT4-292",
				["tokenHolderMover"] = "TOPLEFTElvUIParentTOPLEFT4-119",
				["PlayerPowerBarMover"] = "BOTTOMElvUIParentBOTTOM-246215",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM231182",
				["RightChatMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-222",
				["AlertFrameMover"] = "TOPElvUIParentTOP0-260",
				["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-134",
				["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-6",
			},
			["tooltip"] = {
				["healthBar"] = {
					["font"] = "Bui Prototype",
					["fontSize"] = 9,
				},
			},
			["unitframe"] = {
				["font"] = "Bui Visitor1",
				["colors"] = {
					["auraBarBuff"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["transparentAurabars"] = true,
					["power"] = {
						["MANA"] = {
							["b"] = 0.6941176470588235,
							["g"] = 0.5686274509803921,
							["r"] = 0,
						},
						["RUNIC_POWER"] = {
							["g"] = 0.8196078431372549,
						},
					},
					["castColor"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["transparentCastbar"] = true,
					["health"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
				},
				["fontOutline"] = "NONE",
				["statusbar"] = "BuiFlat",
				["units"] = {
					["raid10"] = {
						["growthDirection"] = "DOWN_RIGHT",
						["power"] = {
							["enable"] = false,
						},
					},
					["pet"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["party"] = {
						["debuffs"] = {
							["sizeOverride"] = 23,
						},
						["power"] = {
							["enable"] = false,
						},
						["height"] = 25,
						["groupBy"] = "MTMA",
						["buffs"] = {
							["sizeOverride"] = 0,
						},
						["width"] = 141,
					},
					["player"] = {
						["debuffs"] = {
							["attachTo"] = "BUFFS",
							["sizeOverride"] = 36,
							["yOffset"] = 2,
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["power"] = {
							["detachedWidth"] = 268,
							["height"] = 5,
							["yOffset"] = -25,
						},
						["customTexts"] = {
							["group"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "RIGHT",
								["fontOutline"] = "OUTLINE",
								["xOffset"] = -128,
								["yOffset"] = 8,
								["text_format"] = "[playergroup]",
								["size"] = 10,
							},
							["[name] [level]"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "LEFT",
								["fontOutline"] = "NONE",
								["xOffset"] = -144,
								["yOffset"] = -22,
								["text_format"] = "[namecolor][name] || [healthcolor][health:current-percent]",
								["size"] = 10,
							},
						},
						["width"] = 300,
						["health"] = {
							["text_format"] = "",
						},
						["threatStyle"] = "ICONTOPRIGHT",
						["height"] = 33,
						["buffs"] = {
							["enable"] = true,
							["sizeOverride"] = 32,
							["attachTo"] = "FRAME",
							["yOffset"] = 8,
						},
						["classbar"] = {
							["detachFromFrame"] = true,
							["detachedWidth"] = 151,
						},
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
					},
					["target"] = {
						["debuffs"] = {
							["anchorPoint"] = "TOPLEFT",
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["power"] = {
							["xOffset"] = 2,
							["height"] = 5,
							["hideonnpc"] = false,
							["detachedWidth"] = 268,
							["yOffset"] = -25,
						},
						["customTexts"] = {
							["group"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "CENTER",
								["fontOutline"] = "MONOCHROMEOUTLINE",
								["xOffset"] = 139,
								["size"] = 10,
								["text_format"] = "",
								["yOffset"] = 8,
							},
						},
						["width"] = 300,
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["health"] = {
							["text_format"] = "",
						},
						["threatStyle"] = "ICONTOPLEFT",
						["height"] = 33,
						["buffs"] = {
							["anchorPoint"] = "TOPLEFT",
							["sizeOverride"] = 32,
							["yOffset"] = 8,
						},
						["name"] = {
							["yOffset"] = -25,
							["text_format"] = " [healthcolor][health:current-percent] || [namecolor][name]",
							["position"] = "RIGHT",
						},
						["aurabar"] = {
							["enable"] = false,
							["maxDuration"] = 120,
						},
					},
					["focus"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 122,
						},
						["width"] = 122,
						["power"] = {
							["height"] = 6,
						},
					},
					["raid25"] = {
						["power"] = {
							["enable"] = false,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 192.9999847412109,
						},
					},
					["targettarget"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["boss"] = {
						["growthDirection"] = "DOWN",
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 0,
						},
					},
				},
			},
			["datatexts"] = {
				["font"] = "Bui Visitor1",
				["fontOutline"] = "MONOCHROMEOUTLINE",
				["panelTransparency"] = true,
				["leftChatPanel"] = false,
				["panels"] = {
					["LeftChatDataPanel"] = {
						["right"] = "iMail",
						["left"] = "Spell/Heal Power",
						["middle"] = "Haste",
					},
					["LeftCoordDtPanel"] = "AtlasLoot",
					["RightChatDataPanel"] = {
						["middle"] = "Bags",
						["left"] = "Mastery",
					},
					["BenikLeftChatDTPanel"] = {
						["right"] = "Mail",
					},
					["BenikRightDTPanel"] = "Combat/Arena Time",
					["BuiLeftChatDTPanel"] = {
						["right"] = "Mail",
					},
					["BenikMiddleDTPanel"] = {
						["right"] = "Hit Rating",
						["left"] = "Crit Chance",
						["middle"] = "Haste",
					},
					["BenikLeftDTPanel"] = "Mastery",
				},
				["rightChatPanel"] = false,
			},
			["actionbar"] = {
				["bar3"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["font"] = "Bui Visitor1",
				["bar6"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["bar2"] = {
					["enabled"] = true,
					["buttonspacing"] = 4,
					["heightMult"] = 2,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["bar1"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["bar5"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["barPet"] = {
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 10,
					["buttonsize"] = 27,
				},
				["bar4"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 26,
				},
			},
			["chat"] = {
				["tabFont"] = "Bui Visitor1",
				["font"] = "Bui Prototype",
				["panelHeight"] = 150,
			},
			["loclite"] = {
				["timer"] = 0.2,
				["lpfontsize"] = 10,
				["locpanel"] = false,
				["userColor"] = {
					["g"] = 0.3568627450980392,
					["b"] = 0.1019607843137255,
				},
			},
			["dtc"] = {
				["customColor"] = 2,
				["userColor"] = {
					["b"] = 0.6901960784313725,
					["g"] = 0.8509803921568627,
					["r"] = 0.796078431372549,
				},
			},
		},
		["Nitali - Emerald Dream"] = {
			["currentTutorial"] = 1,
			["unitframe"] = {
				["units"] = {
					["player"] = {
						["castbar"] = {
							["height"] = 28,
							["width"] = 406,
						},
					},
				},
			},
			["general"] = {
				["valuecolor"] = {
					["r"] = 0.09,
					["g"] = 0.513,
					["b"] = 0.819,
				},
				["bordercolor"] = {
					["r"] = 0.31,
					["g"] = 0.31,
					["b"] = 0.31,
				},
			},
			["movers"] = {
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM278110",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-278110",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0195",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM042",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0150",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM038",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0110",
			},
			["layoutSet"] = "dpsMelee",
			["datatexts"] = {
				["panels"] = {
					["RightCoordDtPanel"] = "iLocation",
					["LeftCoordDtPanel"] = "Broker_Location",
					["LeftChatDataPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Haste",
					},
				},
			},
			["hideTutorial"] = 1,
			["locplus"] = {
				["dtwidth"] = 200,
			},
		},
		["Benica - Emerald Dream"] = {
			["unitframe"] = {
				["units"] = {
					["player"] = {
						["castbar"] = {
							["height"] = 28,
							["width"] = 406,
						},
					},
				},
			},
			["currentTutorial"] = 1,
			["locplus"] = {
				["dtwidth"] = 200,
			},
			["movers"] = {
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM278110",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-278110",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0195",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM042",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0150",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM038",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0110",
			},
			["layoutSet"] = "dpsCaster",
			["general"] = {
				["valuecolor"] = {
					["r"] = 0.09,
					["g"] = 0.513,
					["b"] = 0.819,
				},
				["bordercolor"] = {
					["r"] = 0.31,
					["g"] = 0.31,
					["b"] = 0.31,
				},
			},
			["hideTutorial"] = 1,
			["datatexts"] = {
				["panels"] = {
					["LeftChatDataPanel"] = {
						["left"] = "Spell/Heal Power",
						["right"] = "Haste",
					},
					["RightCoordDtPanel"] = "Broker_Location",
				},
			},
		},
		["Moli - Mazrigos"] = {
			["currentTutorial"] = 1,
			["general"] = {
				["valuecolor"] = {
					["b"] = 0.94,
					["g"] = 0.8,
					["r"] = 0.41,
				},
				["bordercolor"] = {
					["b"] = 0.31,
					["g"] = 0.31,
					["r"] = 0.31,
				},
			},
			["unitframe"] = {
				["colors"] = {
					["auraBarBuff"] = {
						["b"] = 0.94,
						["g"] = 0.8,
						["r"] = 0.41,
					},
					["castClassColor"] = true,
					["healthclass"] = true,
				},
				["units"] = {
					["boss"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 0,
						},
					},
					["focus"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 190.0000305175781,
						},
					},
					["target"] = {
						["castbar"] = {
							["height"] = 8.999997138977051,
							["width"] = 269.9999694824219,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 192.9999847412109,
						},
					},
					["player"] = {
						["castbar"] = {
							["height"] = 8.999997138977051,
							["width"] = 269.9999389648438,
						},
					},
				},
			},
		},
		["Benicio - Emerald Dream"] = {
			["bui"] = {
				["installed"] = true,
			},
			["currentTutorial"] = 2,
			["general"] = {
				["fontSize"] = 10,
				["stickyFrames"] = false,
				["reputation"] = {
					["textFormat"] = "CURPERC",
					["textSize"] = 8,
					["width"] = 180,
				},
				["minimap"] = {
					["locationText"] = "HIDE",
					["size"] = 150,
				},
				["font"] = "Bui Prototype",
				["bottomPanel"] = false,
				["backdropfadecolor"] = {
					["r"] = 0.054,
					["g"] = 0.054,
					["b"] = 0.054,
				},
				["valuecolor"] = {
					["a"] = 1,
					["r"] = 1,
					["g"] = 0.5019607843137255,
					["b"] = 0,
				},
				["topPanel"] = false,
				["experience"] = {
					["width"] = 412,
					["textFormat"] = "CURPERC",
				},
			},
			["movers"] = {
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-231147",
				["LocationLiteMover"] = "TOPElvUIParentTOP0-7",
				["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT222",
				["GMMover"] = "TOPLEFTElvUIParentTOPLEFT155-4",
				["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-3",
				["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0283",
				["DigSiteProgressBarMover"] = "BOTTOMElvUIParentBOTTOM0315",
				["ElvUF_RaidpetMover"] = "TOPLEFTElvUIParentTOPLEFT4-444",
				["ElvUF_FocusMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-442178",
				["MicrobarMover"] = "TOPLEFTElvUIParentTOPLEFT4-4",
				["VehicleSeatMover"] = "TOPLEFTElvUIParentTOPLEFT155-81",
				["ExperienceBarMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4204",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0164",
				["BuiDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4211",
				["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM092",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM058",
				["ElvUF_AssistMover"] = "TOPLEFTElvUIParentTOPLEFT4-392",
				["ElvUF_Raid25Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT2179",
				["TargetPowerBarMover"] = "BOTTOMElvUIParentBOTTOM247215",
				["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["AltPowerBarMover"] = "TOPElvUIParentTOP0-66",
				["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM29558",
				["ReputationBarMover"] = "TOPRIGHTElvUIParentTOPRIGHT-2-181",
				["PlayerPowerBarMover"] = "BOTTOMElvUIParentBOTTOM-231215",
				["WatchFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT-122-292",
				["tokenHolderMover"] = "TOPLEFTElvUIParentTOPLEFT4-119",
				["PetAB"] = "BOTTOMElvUIParentBOTTOM013",
				["BNETMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-199",
				["ShiftAB"] = "TOPLEFTElvUIParentTOPLEFT407-39",
				["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-29558",
				["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM231147",
				["ArenaHeaderMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-56346",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM231182",
				["ElvUF_TankMover"] = "TOPLEFTElvUIParentTOPLEFT4-292",
				["BossHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT-56-397",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0191",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-231182",
				["RightChatMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-222",
				["AlertFrameMover"] = "TOPElvUIParentTOP0-140",
				["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-134",
				["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-6",
			},
			["ufb"] = {
				["barheight"] = 15,
				["PlayerPortraitWidth"] = 150,
				["TargetPortraitWidth"] = 150,
				["TargetPortraitHeight"] = 150,
				["PlayerPortraitHeight"] = 150,
			},
			["hideTutorial"] = 1,
			["chat"] = {
				["tabFont"] = "Bui Visitor1",
				["font"] = "Bui Prototype",
				["tabFontOutline"] = "MONOCROMEOUTLINE",
				["panelHeight"] = 150,
			},
			["unitframe"] = {
				["font"] = "Bui Visitor1",
				["colors"] = {
					["auraBarBuff"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["health"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["castColor"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["transparentCastbar"] = true,
					["transparentAurabars"] = true,
				},
				["fontOutline"] = "NONE",
				["statusbar"] = "BuiFlat",
				["units"] = {
					["player"] = {
						["power"] = {
							["detachedWidth"] = 298,
							["height"] = 5,
							["yOffset"] = -25,
						},
						["debuffs"] = {
							["attachTo"] = "BUFFS",
							["sizeOverride"] = 32,
							["yOffset"] = 2,
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["castbar"] = {
							["height"] = 28,
							["icon"] = false,
							["width"] = 300,
						},
						["height"] = 33,
						["buffs"] = {
							["enable"] = true,
							["sizeOverride"] = 32,
							["attachTo"] = "FRAME",
							["yOffset"] = 8,
						},
						["threatStyle"] = "ICONTOPRIGHT",
						["width"] = 300,
					},
					["target"] = {
						["debuffs"] = {
							["enable"] = false,
							["anchorPoint"] = "TOPLEFT",
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
						["width"] = 300,
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["power"] = {
							["height"] = 5,
							["xOffset"] = 2,
							["hideonnpc"] = false,
							["detachedWidth"] = 298,
							["yOffset"] = -25,
						},
						["height"] = 33,
						["buffs"] = {
							["anchorPoint"] = "TOPLEFT",
							["sizeOverride"] = 32,
							["playerOnly"] = {
								["friendly"] = true,
							},
							["yOffset"] = 8,
						},
						["threatStyle"] = "ICONTOPLEFT",
						["aurabar"] = {
							["attachTo"] = "BUFFS",
						},
					},
					["focus"] = {
						["power"] = {
							["height"] = 5,
						},
						["width"] = 122,
						["castbar"] = {
							["height"] = 6,
							["width"] = 122,
						},
					},
					["raid25"] = {
						["power"] = {
							["enable"] = false,
						},
					},
					["pet"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["targettarget"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["raid10"] = {
						["power"] = {
							["power"] = false,
						},
					},
				},
			},
			["datatexts"] = {
				["font"] = "Bui Visitor1",
				["fontOutline"] = "MONOCROMEOUTLINE",
				["panelTransparency"] = true,
				["leftChatPanel"] = false,
				["panels"] = {
					["BuiRightChatDTPanel"] = {
						["middle"] = "Bags",
						["left"] = "Mastery",
					},
					["BuiLeftChatDTPanel"] = {
						["middle"] = "Haste",
						["right"] = "Mail",
					},
					["LeftChatDataPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Haste",
					},
				},
				["rightChatPanel"] = false,
			},
			["actionbar"] = {
				["bar3"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["font"] = "Bui Visitor1",
				["bar2"] = {
					["enabled"] = true,
					["buttonspacing"] = 4,
					["backdrop"] = true,
					["buttonsize"] = 30,
					["heightMult"] = 2,
				},
				["fontOutline"] = "MONOCROMEOUTLINE",
				["bar1"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["barPet"] = {
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 10,
					["buttonsize"] = 27,
				},
				["bar5"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["bar4"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 26,
				},
			},
			["layoutSet"] = "dpsMelee",
			["loclite"] = {
				["lpfont"] = "Bui Visitor1",
				["lpwidth"] = 220,
				["trunc"] = true,
				["dtheight"] = 16,
				["lpfontsize"] = 10,
			},
			["tooltip"] = {
				["healthBar"] = {
					["font"] = "Bui Prototype",
					["fontSize"] = 9,
					["fontOutline"] = "OUTLINE",
				},
			},
			["auras"] = {
				["timeXOffset"] = -1,
				["debuffs"] = {
					["size"] = 30,
				},
				["fontSize"] = 9,
				["fontOutline"] = "MONOCROMEOUTLINE",
				["fadeThreshold"] = 10,
				["buffs"] = {
					["horizontalSpacing"] = 3,
					["size"] = 30,
				},
				["consolidatedBuffs"] = {
					["fontSize"] = 9,
					["font"] = "Bui Visitor1",
					["fontOutline"] = "MONOCROMEOUTLINE",
				},
				["font"] = "Bui Visitor1",
			},
		},
		["Benik - Emerald Dream"] = {
			["nameplate"] = {
				["font"] = "Bui Prototype",
				["fontSize"] = 8,
				["fontOutline"] = "OUTLINE",
			},
			["currentTutorial"] = 2,
			["general"] = {
				["fontSize"] = 10,
				["taintLog"] = true,
				["minimap"] = {
					["locationText"] = "HIDE",
					["size"] = 150,
				},
				["bottomPanel"] = false,
				["backdropfadecolor"] = {
					["r"] = 0.054,
					["g"] = 0.054,
					["b"] = 0.054,
				},
				["valuecolor"] = {
					["a"] = 1,
					["r"] = 1,
					["g"] = 0.5019607843137255,
					["b"] = 0,
				},
				["MANA"] = {
				},
				["stickyFrames"] = 1,
				["topPanel"] = false,
				["font"] = "Bui Prototype",
				["experience"] = {
					["textFormat"] = "CURPERC",
					["width"] = 412,
				},
				["reputation"] = {
					["textFormat"] = "CURPERC",
					["textSize"] = 8,
					["width"] = 180,
				},
				["RUNIC_POWER"] = {
				},
			},
			["xprep"] = {
				["textStyle"] = "DAFAULT",
			},
			["ufb"] = {
				["barheight"] = 15,
				["portraitWidth"] = 138,
				["barhide"] = true,
				["portraitHeight"] = 111,
				["PlayerPortraitWidth"] = 150,
				["TargetPortraitWidth"] = 150,
				["PlayerPortraitHeight"] = 150,
				["TargetPortraitHeight"] = 150,
			},
			["hideTutorial"] = 1,
			["auras"] = {
				["timeXOffset"] = -1,
				["fontSize"] = 9,
				["fadeThreshold"] = 10,
				["font"] = "Bui Visitor1",
				["consolidatedBuffs"] = {
					["font"] = "Bui Visitor1",
				},
				["buffs"] = {
					["horizontalSpacing"] = 3,
					["size"] = 30,
				},
				["debuffs"] = {
					["size"] = 30,
				},
			},
			["locplus"] = {
				["tthideraid"] = true,
				["lpfont"] = "Bui Visitor1",
				["dtheight"] = 16,
				["both"] = false,
				["lpwidth"] = 220,
				["ttreczones"] = false,
				["userColor"] = {
					["g"] = 0.2352941176470588,
					["b"] = 0.1529411764705883,
				},
				["ttcoords"] = false,
				["ttinst"] = false,
				["lpfontsize"] = 10,
				["dtwidth"] = 120,
				["tthint"] = false,
				["ttlevel"] = true,
				["displayOther"] = "NONE",
				["lpauto"] = false,
				["ttrecinst"] = false,
				["trunc"] = true,
				["tthidepvp"] = true,
			},
			["layoutSet"] = "dpsMelee",
			["utils"] = {
				["twidth"] = 151,
			},
			["movers"] = {
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-231147",
				["LocationLiteMover"] = "TOPElvUIParentTOP0-2",
				["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT222",
				["GMMover"] = "TOPLEFTElvUIParentTOPLEFT155-4",
				["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-3",
				["LocationMover"] = "TOPElvUIParentTOP0-7",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0283",
				["LootFrameMover"] = "TOPLEFTElvUIParentTOPLEFT156-210",
				["DigSiteProgressBarMover"] = "BOTTOMElvUIParentBOTTOM0315",
				["ElvUF_RaidpetMover"] = "TOPLEFTElvUIParentTOPLEFT4-444",
				["PlayerPortraitMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT485182",
				["ElvUF_FocusMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-442178",
				["MicrobarMover"] = "TOPLEFTElvUIParentTOPLEFT4-4",
				["ElvUF_Raid25Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT2179",
				["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-6",
				["ExperienceBarMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4204",
				["TargetPowerBarMover"] = "BOTTOMElvUIParentBOTTOM247215",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0164",
				["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["BuiDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4211",
				["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM231182",
				["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM092",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM058",
				["PlayerPowerBarMover"] = "BOTTOMElvUIParentBOTTOM-231215",
				["tokenHolderMover"] = "TOPLEFTElvUIParentTOPLEFT4-119",
				["BenikDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["VehicleSeatMover"] = "TOPLEFTElvUIParentTOPLEFT155-81",
				["AltPowerBarMover"] = "TOPElvUIParentTOP0-66",
				["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM29558",
				["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-29558",
				["PetAB"] = "BOTTOMElvUIParentBOTTOM013",
				["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM231147",
				["ReputationBarMover"] = "TOPRIGHTElvUIParentTOPRIGHT-2-181",
				["ElvAB_6"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4215",
				["BNETMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-199",
				["ShiftAB"] = "TOPLEFTElvUIParentTOPLEFT407-39",
				["TargetPortraitMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-483182",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0191",
				["ArenaHeaderMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-56346",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-231182",
				["ElvUF_TankMover"] = "TOPLEFTElvUIParentTOPLEFT4-292",
				["BossHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT-56-397",
				["WatchFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT-122-292",
				["RightChatMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-222",
				["BenikButtonsMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4204",
				["AlertFrameMover"] = "TOPElvUIParentTOP0-140",
				["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-134",
				["ElvUF_AssistMover"] = "TOPLEFTElvUIParentTOPLEFT4-392",
			},
			["tooltip"] = {
				["healthBar"] = {
					["fontSize"] = 9,
					["font"] = "Bui Prototype",
				},
			},
			["unitframe"] = {
				["units"] = {
					["tank"] = {
						["enable"] = false,
					},
					["raid10"] = {
						["growthDirection"] = "DOWN_RIGHT",
						["power"] = {
							["enable"] = false,
						},
					},
					["boss"] = {
						["growthDirection"] = "DOWN",
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 0,
						},
					},
					["focus"] = {
						["power"] = {
							["height"] = 6,
						},
						["width"] = 122,
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 122,
						},
					},
					["target"] = {
						["debuffs"] = {
							["anchorPoint"] = "TOPLEFT",
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["aurabar"] = {
							["enable"] = false,
							["maxDuration"] = 120,
						},
						["threatStyle"] = "ICONTOPLEFT",
						["power"] = {
							["xOffset"] = 2,
							["yOffset"] = -25,
							["height"] = 5,
							["hideonnpc"] = false,
							["detachedWidth"] = 268,
						},
						["customTexts"] = {
							["group"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "CENTER",
								["fontOutline"] = "MONOCHROMEOUTLINE",
								["xOffset"] = 139,
								["yOffset"] = 8,
								["text_format"] = "",
								["size"] = 10,
							},
						},
						["width"] = 300,
						["name"] = {
							["yOffset"] = -25,
							["text_format"] = " [healthcolor][health:current-percent] || [namecolor][name]",
							["position"] = "RIGHT",
						},
						["health"] = {
							["text_format"] = "",
						},
						["height"] = 33,
						["buffs"] = {
							["sizeOverride"] = 32,
							["yOffset"] = 8,
							["anchorPoint"] = "TOPLEFT",
						},
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
					},
					["targettarget"] = {
						["power"] = {
							["height"] = 5,
						},
						["height"] = 24,
					},
					["player"] = {
						["debuffs"] = {
							["sizeOverride"] = 36,
							["yOffset"] = 2,
							["attachTo"] = "BUFFS",
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["threatStyle"] = "ICONTOPRIGHT",
						["castbar"] = {
							["width"] = 300,
							["icon"] = false,
						},
						["customTexts"] = {
							["group"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "RIGHT",
								["fontOutline"] = "OUTLINE",
								["xOffset"] = -128,
								["size"] = 10,
								["text_format"] = "[playergroup]",
								["yOffset"] = 8,
							},
							["[name] [level]"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "LEFT",
								["fontOutline"] = "NONE",
								["xOffset"] = -144,
								["size"] = 10,
								["text_format"] = "[namecolor][name] || [healthcolor][health:current-percent]",
								["yOffset"] = -22,
							},
						},
						["width"] = 300,
						["health"] = {
							["text_format"] = "",
						},
						["height"] = 33,
						["buffs"] = {
							["sizeOverride"] = 32,
							["enable"] = true,
							["yOffset"] = 8,
							["attachTo"] = "FRAME",
						},
						["power"] = {
							["yOffset"] = -25,
							["detachedWidth"] = 298,
							["height"] = 5,
						},
					},
					["raid25"] = {
						["power"] = {
							["enable"] = false,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 192.9999847412109,
						},
					},
					["pet"] = {
						["power"] = {
							["height"] = 5,
						},
						["height"] = 24,
					},
				},
				["font"] = "Bui Visitor1",
				["colors"] = {
					["auraBarBuff"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["power"] = {
						["MANA"] = {
							["b"] = 0,
							["g"] = 0.5019607843137255,
							["r"] = 1,
						},
						["RUNIC_POWER"] = {
							["g"] = 0.8196078431372549,
						},
					},
					["castColor"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["transparentAurabars"] = true,
					["transparentCastbar"] = true,
					["health"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
				},
				["fontOutline"] = "NONE",
				["statusbar"] = "BuiFlat",
			},
			["datatexts"] = {
				["panelTransparency"] = true,
				["panels"] = {
					["BuiLeftChatDTPanel"] = {
						["right"] = "Mail",
					},
					["BenikLeftChatDTPanel"] = {
						["right"] = "Mail",
					},
					["BenikLeftDTPanel"] = "Mastery",
					["LeftChatDataPanel"] = {
						["right"] = "iMail",
						["left"] = "Spell/Heal Power",
						["middle"] = "Haste",
					},
					["BenikRightDTPanel"] = "Combat/Arena Time",
					["LeftCoordDtPanel"] = "AtlasLoot",
					["BenikMiddleDTPanel"] = {
						["right"] = "Hit Rating",
						["left"] = "Crit Chance",
						["middle"] = "Haste",
					},
					["RightChatDataPanel"] = {
						["left"] = "Mastery",
						["middle"] = "Bags",
					},
				},
				["font"] = "Bui Visitor1",
				["fontOutline"] = "MONOCHROMEOUTLINE",
				["leftChatPanel"] = false,
				["rightChatPanel"] = false,
			},
			["loclite"] = {
				["timer"] = 0.2,
				["locpanel"] = false,
				["lpfontsize"] = 10,
				["userColor"] = {
					["g"] = 0.3568627450980392,
					["b"] = 0.1019607843137255,
				},
			},
			["dtc"] = {
				["customColor"] = 2,
				["userColor"] = {
					["b"] = 0.6901960784313725,
					["g"] = 0.8509803921568627,
					["r"] = 0.796078431372549,
				},
			},
			["chat"] = {
				["tabFont"] = "Bui Visitor1",
				["panelHeight"] = 150,
				["font"] = "Bui Prototype",
			},
			["actionbar"] = {
				["bar3"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["backdrop"] = true,
					["buttonsPerRow"] = 5,
					["buttonsize"] = 30,
				},
				["bar2"] = {
					["enabled"] = true,
					["buttonspacing"] = 4,
					["backdrop"] = true,
					["heightMult"] = 2,
					["buttonsize"] = 30,
				},
				["bar5"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["backdrop"] = true,
					["buttonsPerRow"] = 5,
					["buttonsize"] = 30,
				},
				["font"] = "Bui Visitor1",
				["bar1"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["bar6"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["barPet"] = {
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 10,
					["buttonsize"] = 27,
				},
				["bar4"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 26,
				},
			},
		},
		["Beniman - Emerald Dream"] = {
			["currentTutorial"] = 1,
			["general"] = {
				["valuecolor"] = {
					["b"] = 0.819,
					["g"] = 0.513,
					["r"] = 0.09,
				},
				["bordercolor"] = {
					["b"] = 0.31,
					["g"] = 0.31,
					["r"] = 0.31,
				},
			},
			["movers"] = {
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0110",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-278110",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM042",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0195",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0150",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM038",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM278110",
			},
			["layoutSet"] = "dpsCaster",
			["unitframe"] = {
				["units"] = {
					["player"] = {
						["castbar"] = {
							["height"] = 28,
							["width"] = 406,
						},
					},
				},
			},
			["hideTutorial"] = 1,
			["datatexts"] = {
				["panels"] = {
					["RightCoordDtPanel"] = "Broker_Location",
					["LeftChatDataPanel"] = {
						["left"] = "Spell/Heal Power",
						["right"] = "Haste",
					},
				},
			},
		},
		["Shaobin - Emerald Dream"] = {
			["currentTutorial"] = 1,
			["general"] = {
				["valuecolor"] = {
					["r"] = 0.09,
					["g"] = 0.513,
					["b"] = 0.819,
				},
				["experience"] = {
					["orientation"] = "VERTICAL",
				},
				["backdropfadecolor"] = {
					["r"] = 0.054,
					["g"] = 0.054,
					["b"] = 0.054,
				},
			},
			["movers"] = {
				["ClassBarMover"] = "BOTTOMElvUIParentBOTTOM0230",
				["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4195",
				["LocationMover"] = "TOPElvUIParentTOP0-91",
				["ElvUF_Raid25Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4195",
				["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4195",
				["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4195",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM038",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM28067",
			},
			["hideTutorial"] = 1,
			["unitframe"] = {
				["colors"] = {
					["auraBarBuff"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["health"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["castColor"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["transparentCastbar"] = true,
					["transparentPower"] = true,
					["transparentHealth"] = true,
				},
				["units"] = {
					["target"] = {
						["aurabar"] = {
							["attachTo"] = "BUFFS",
						},
						["buffs"] = {
							["playerOnly"] = {
								["friendly"] = true,
							},
						},
						["debuffs"] = {
							["enable"] = false,
						},
						["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
					},
					["player"] = {
						["classbar"] = {
							["DetachFromFrame"] = true,
						},
					},
				},
			},
			["locplus"] = {
				["xprep"] = "REP",
				["ht"] = true,
				["dtwidth"] = 200,
			},
			["actionbar"] = {
				["bar2"] = {
					["enabled"] = true,
				},
			},
			["layoutSet"] = "dpsMelee",
			["datatexts"] = {
				["panels"] = {
					["LeftChatDataPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Haste",
					},
					["LeftCoordDtPanel"] = "iLocation",
					["RightCoordDtPanel"] = "Broker_Location",
				},
			},
		},
		["Lasi - Mazrigos"] = {
			["unitframe"] = {
				["colors"] = {
					["auraBarBuff"] = {
						["b"] = 0.94,
						["g"] = 0.8,
						["r"] = 0.41,
					},
					["castClassColor"] = true,
					["healthclass"] = true,
				},
				["units"] = {
					["boss"] = {
						["castbar"] = {
							["height"] = 5.999979019165039,
							["width"] = 0,
						},
					},
					["focus"] = {
						["castbar"] = {
							["height"] = 5.999979019165039,
							["width"] = 189.9999847412109,
						},
					},
					["target"] = {
						["castbar"] = {
							["height"] = 9.000001907348633,
							["width"] = 270.0000305175781,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 5.999979019165039,
							["width"] = 193,
						},
					},
					["player"] = {
						["castbar"] = {
							["height"] = 9.000001907348633,
							["width"] = 270.0000305175781,
						},
					},
				},
			},
			["currentTutorial"] = 9,
			["hideTutorial"] = 1,
			["general"] = {
				["valuecolor"] = {
					["b"] = 0.94,
					["g"] = 0.8,
					["r"] = 0.41,
				},
				["bordercolor"] = {
					["b"] = 0.31,
					["g"] = 0.31,
					["r"] = 0.31,
				},
			},
		},
		["Jenei - Aerie Peak"] = {
			["unitframe"] = {
				["colors"] = {
					["auraBarBuff"] = {
						["b"] = 0.45,
						["g"] = 0.83,
						["r"] = 0.67,
					},
					["castClassColor"] = true,
					["castColor"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["health"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["healthclass"] = true,
				},
				["units"] = {
					["player"] = {
						["castbar"] = {
							["height"] = 9.000001907348633,
							["width"] = 270.0000305175781,
						},
					},
					["boss"] = {
						["castbar"] = {
							["height"] = 0.9999746084213257,
							["width"] = 0,
						},
					},
					["raid25"] = {
						["debuffs"] = {
							["sizeOverride"] = 16,
						},
						["buffs"] = {
							["sizeOverride"] = 22,
						},
					},
					["focus"] = {
						["castbar"] = {
							["height"] = 5.999979019165039,
							["width"] = 189.9999847412109,
						},
					},
					["raid10"] = {
						["positionOverride"] = "BOTTOMRIGHT",
						["debuffs"] = {
							["sizeOverride"] = 16,
						},
						["buffs"] = {
							["sizeOverride"] = 22,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 0.9999746084213257,
							["width"] = 192,
						},
					},
					["target"] = {
						["castbar"] = {
							["height"] = 9.000001907348633,
							["width"] = 270.0000305175781,
						},
					},
					["party"] = {
						["buffs"] = {
							["sizeOverride"] = 22,
						},
					},
				},
			},
			["general"] = {
				["valuecolor"] = {
					["b"] = 0.45,
					["g"] = 0.83,
					["r"] = 0.67,
				},
				["bordercolor"] = {
					["b"] = 0.31,
					["g"] = 0.31,
					["r"] = 0.31,
				},
			},
			["movers"] = {
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0110",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-278110",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM042",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0195",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0150",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM038",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM278110",
			},
			["layoutSet"] = "dpsMelee",
			["datatexts"] = {
				["panels"] = {
					["LeftChatDataPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Haste",
					},
				},
			},
		},
		["Benazir - Emerald Dream"] = {
			["nameplate"] = {
				["fontSize"] = 8,
				["font"] = "Bui Prototype",
				["fontOutline"] = "OUTLINE",
			},
			["currentTutorial"] = 2,
			["general"] = {
				["MANA"] = {
				},
				["fontSize"] = 10,
				["stickyFrames"] = false,
				["taintLog"] = true,
				["topPanel"] = false,
				["minimap"] = {
					["locationText"] = "HIDE",
					["size"] = 150,
				},
				["RUNIC_POWER"] = {
				},
				["bottomPanel"] = false,
				["backdropfadecolor"] = {
					["r"] = 0.054,
					["g"] = 0.054,
					["b"] = 0.054,
				},
				["valuecolor"] = {
					["a"] = 1,
					["r"] = 1,
					["g"] = 0.5019607843137255,
					["b"] = 0,
				},
				["font"] = "Bui Prototype",
				["reputation"] = {
					["textFormat"] = "CURPERC",
					["textSize"] = 8,
					["width"] = 180,
				},
				["experience"] = {
					["width"] = 412,
					["textFormat"] = "CURPERC",
				},
			},
			["xprep"] = {
				["textStyle"] = "DAFAULT",
			},
			["ufb"] = {
				["TargetPortraitWidth"] = 150,
				["TargetPortraitHeight"] = 150,
				["PlayerPortraitWidth"] = 150,
				["barheight"] = 15,
				["barhide"] = true,
				["PlayerPortraitHeight"] = 150,
			},
			["hideTutorial"] = 1,
			["chat"] = {
				["tabFont"] = "Bui Visitor1",
				["font"] = "Bui Prototype",
				["tabFontOutline"] = "MONOCROMEOUTLINE",
				["panelHeight"] = 150,
			},
			["locplus"] = {
				["tthideraid"] = true,
				["ttrecinst"] = false,
				["lpfont"] = "Bui Visitor1",
				["tthidepvp"] = true,
				["userColor"] = {
					["g"] = 0.2352941176470588,
					["b"] = 0.1529411764705883,
				},
				["dtheight"] = 16,
				["ttinst"] = false,
				["ttreczones"] = false,
				["tthint"] = false,
				["timer"] = 2,
				["lpfontsize"] = 10,
				["ttlevel"] = true,
				["lpwidth"] = 220,
				["trunc"] = true,
				["ttcoords"] = false,
				["dtwidth"] = 120,
			},
			["layoutSet"] = "dpsMelee",
			["movers"] = {
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-231147",
				["LocationLiteMover"] = "TOPElvUIParentTOP0-2",
				["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT222",
				["GMMover"] = "TOPLEFTElvUIParentTOPLEFT155-4",
				["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-3",
				["TargetPowerBarMover"] = "BOTTOMElvUIParentBOTTOM247215",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0283",
				["DigSiteProgressBarMover"] = "BOTTOMElvUIParentBOTTOM0315",
				["ElvUF_RaidpetMover"] = "TOPLEFTElvUIParentTOPLEFT4-444",
				["ElvUF_FocusMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-442178",
				["MicrobarMover"] = "TOPLEFTElvUIParentTOPLEFT4-4",
				["ElvUF_Raid25Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT2179",
				["ExperienceBarMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4204",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0164",
				["ElvUF_AssistMover"] = "TOPLEFTElvUIParentTOPLEFT4-392",
				["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4211",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM231182",
				["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM092",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM058",
				["RightChatMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-222",
				["VehicleSeatMover"] = "TOPLEFTElvUIParentTOPLEFT155-81",
				["BenikDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["WatchFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT-122-292",
				["AltPowerBarMover"] = "TOPElvUIParentTOP0-66",
				["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM29558",
				["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-29558",
				["LocationMover"] = "TOPElvUIParentTOP0-7",
				["PetAB"] = "BOTTOMElvUIParentBOTTOM013",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0191",
				["ArenaHeaderMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-56346",
				["BNETMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-199",
				["ShiftAB"] = "TOPLEFTElvUIParentTOPLEFT407-39",
				["ElvAB_6"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4215",
				["BenikButtonsMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4204",
				["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM231147",
				["ReputationBarMover"] = "TOPRIGHTElvUIParentTOPRIGHT-2-181",
				["ElvUF_TankMover"] = "TOPLEFTElvUIParentTOPLEFT4-292",
				["BossHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT-56-397",
				["PlayerPowerBarMover"] = "BOTTOMElvUIParentBOTTOM-231215",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-231182",
				["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["AlertFrameMover"] = "TOPElvUIParentTOP0-140",
				["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-134",
				["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-6",
			},
			["tooltip"] = {
				["healthBar"] = {
					["font"] = "Bui Prototype",
					["fontSize"] = 9,
					["fontOutline"] = "OUTLINE",
				},
			},
			["unitframe"] = {
				["statusbar"] = "BuiFlat",
				["colors"] = {
					["auraBarBuff"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["health"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["power"] = {
						["MANA"] = {
							["r"] = 0,
							["g"] = 0.5686274509803921,
							["b"] = 0.6941176470588235,
						},
						["RUNIC_POWER"] = {
							["g"] = 0.8196078431372549,
						},
					},
					["castColor"] = {
						["r"] = 0.1,
						["g"] = 0.1,
						["b"] = 0.1,
					},
					["transparentCastbar"] = true,
					["transparentAurabars"] = true,
				},
				["fontOutline"] = "NONE",
				["font"] = "Bui Visitor1",
				["units"] = {
					["raid10"] = {
						["power"] = {
							["enable"] = false,
							["power"] = false,
						},
						["growthDirection"] = "DOWN_RIGHT",
					},
					["targettarget"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["boss"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 0,
						},
						["growthDirection"] = "DOWN",
					},
					["pet"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["focus"] = {
						["power"] = {
							["height"] = 5,
						},
						["width"] = 122,
						["castbar"] = {
							["height"] = 6,
							["width"] = 122,
						},
					},
					["target"] = {
						["debuffs"] = {
							["anchorPoint"] = "TOPLEFT",
						},
						["portrait"] = {
							["enable"] = true,
							["overlay"] = true,
						},
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["customTexts"] = {
							["group"] = {
								["font"] = "Bui Prototype",
								["justifyH"] = "CENTER",
								["fontOutline"] = "OUTLINE",
								["xOffset"] = 0,
								["yOffset"] = 0,
								["text_format"] = "",
								["size"] = 10,
							},
						},
						["width"] = 300,
						["power"] = {
							["detachedWidth"] = 298,
							["xOffset"] = 2,
							["hideonnpc"] = false,
							["height"] = 5,
							["yOffset"] = -25,
						},
						["health"] = {
							["text_format"] = "",
						},
						["name"] = {
							["position"] = "RIGHT",
							["text_format"] = "[namecolor][name] || [healthcolor][health:current-percent]",
							["yOffset"] = -33,
						},
						["height"] = 33,
						["buffs"] = {
							["anchorPoint"] = "TOPLEFT",
							["sizeOverride"] = 32,
							["yOffset"] = 8,
						},
						["threatStyle"] = "ICONTOPLEFT",
						["aurabar"] = {
							["maxDuration"] = 120,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 192.9999847412109,
						},
					},
					["raid25"] = {
						["power"] = {
							["enable"] = false,
						},
					},
					["player"] = {
						["debuffs"] = {
							["attachTo"] = "BUFFS",
							["sizeOverride"] = 32,
							["yOffset"] = 2,
						},
						["portrait"] = {
							["overlay"] = true,
							["enable"] = true,
							["width"] = 68,
						},
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["customTexts"] = {
							["group"] = {
								["font"] = "Bui Prototype",
								["justifyH"] = "CENTER",
								["fontOutline"] = "OUTLINE",
								["xOffset"] = -122,
								["yOffset"] = 12,
								["text_format"] = "",
								["size"] = 10,
							},
							["[name] [level]"] = {
								["font"] = "Bui Prototype",
								["justifyH"] = "LEFT",
								["fontOutline"] = "NONE",
								["xOffset"] = -130,
								["yOffset"] = -30,
								["text_format"] = "[namecolor][name] || [healthcolor][health:current-percent]",
								["size"] = 10,
							},
						},
						["width"] = 300,
						["health"] = {
							["text_format"] = "",
						},
						["power"] = {
							["height"] = 5,
							["detachedWidth"] = 298,
							["yOffset"] = -25,
						},
						["height"] = 33,
						["buffs"] = {
							["enable"] = true,
							["sizeOverride"] = 32,
							["attachTo"] = "FRAME",
							["yOffset"] = 8,
						},
						["classbar"] = {
							["height"] = 7,
						},
						["threatStyle"] = "ICONTOPRIGHT",
					},
				},
			},
			["datatexts"] = {
				["font"] = "Bui Visitor1",
				["fontOutline"] = "MONOCROMEOUTLINE",
				["panelTransparency"] = true,
				["leftChatPanel"] = false,
				["panels"] = {
					["LeftChatDataPanel"] = {
						["right"] = "iMail",
						["left"] = "Spell/Heal Power",
						["middle"] = "Haste",
					},
					["RightChatDataPanel"] = {
						["left"] = "Mastery",
						["middle"] = "Bags",
					},
					["BuiLeftChatDTPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Mail",
					},
					["LeftCoordDtPanel"] = "AtlasLoot",
					["BenikRightDTPanel"] = "Combat/Arena Time",
					["BenikLeftChatDTPanel"] = {
						["right"] = "Mail",
					},
					["BenikMiddleDTPanel"] = {
						["right"] = "Hit Rating",
						["left"] = "Crit Chance",
						["middle"] = "Haste",
					},
					["BenikLeftDTPanel"] = "Mastery",
				},
				["rightChatPanel"] = false,
			},
			["actionbar"] = {
				["bar3"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["bar6"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["bar2"] = {
					["enabled"] = true,
					["buttonspacing"] = 4,
					["backdrop"] = true,
					["buttonsize"] = 30,
					["heightMult"] = 2,
				},
				["bar1"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["bar5"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["font"] = "Bui Visitor1",
				["fontOutline"] = "MONOCROMEOUTLINE",
				["barPet"] = {
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 10,
					["buttonsize"] = 27,
				},
				["bar4"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 26,
				},
			},
			["loclite"] = {
				["timer"] = 0.2,
				["locpanel"] = false,
				["lpfontsize"] = 10,
				["userColor"] = {
					["g"] = 0.3568627450980392,
					["b"] = 0.1019607843137255,
				},
			},
			["auras"] = {
				["timeXOffset"] = -1,
				["debuffs"] = {
					["size"] = 30,
				},
				["fontSize"] = 9,
				["fontOutline"] = "MONOCROMEOUTLINE",
				["fadeThreshold"] = 10,
				["buffs"] = {
					["horizontalSpacing"] = 3,
					["size"] = 30,
				},
				["consolidatedBuffs"] = {
					["fontSize"] = 9,
					["font"] = "Bui Visitor1",
					["fontOutline"] = "MONOCROMEOUTLINE",
				},
				["font"] = "Bui Visitor1",
			},
			["dtc"] = {
				["userColor"] = {
					["r"] = 0.796078431372549,
					["g"] = 0.8509803921568627,
					["b"] = 0.6901960784313725,
				},
				["customColor"] = 2,
			},
		},
		["Bentium - Emerald Dream"] = {
			["nameplate"] = {
				["fontSize"] = 8,
				["font"] = "ElvUI Prototype",
				["fontOutline"] = "OUTLINE",
			},
			["currentTutorial"] = 2,
			["general"] = {
				["MANA"] = {
				},
				["fontSize"] = 10,
				["stickyFrames"] = false,
				["topPanel"] = false,
				["minimap"] = {
					["locationText"] = "HIDE",
					["size"] = 150,
				},
				["RUNIC_POWER"] = {
				},
				["bottomPanel"] = false,
				["backdropfadecolor"] = {
					["b"] = 0.054,
					["g"] = 0.054,
					["r"] = 0.054,
				},
				["valuecolor"] = {
					["a"] = 1,
					["b"] = 0,
					["g"] = 0.5019607843137255,
					["r"] = 1,
				},
				["font"] = "Bui Prototype",
				["reputation"] = {
					["textFormat"] = "CURPERC",
					["textSize"] = 8,
					["width"] = 180,
				},
				["experience"] = {
					["width"] = 412,
					["textFormat"] = "CURPERC",
				},
			},
			["ufb"] = {
				["detachPlayerPortrait"] = true,
				["PlayerPortraitShadow"] = true,
				["barheight"] = 15,
				["detachTargetPortrait"] = true,
				["TargetPortraitShadow"] = true,
				["PlayerPortraitHeight"] = 181,
				["PlayerPortraitWidth"] = 220,
				["TargetPortraitHeight"] = 248,
				["TargetPortraitWidth"] = 202,
				["getPlayerPortraitSize"] = false,
			},
			["hideTutorial"] = 1,
			["chat"] = {
				["tabFont"] = "Bui Visitor1",
				["font"] = "Bui Prototype",
				["tabFontOutline"] = "MONOCROMEOUTLINE",
				["panelHeight"] = 150,
			},
			["locplus"] = {
				["tthideraid"] = true,
				["ttrecinst"] = false,
				["lpfont"] = "Bui Visitor2",
				["tthidepvp"] = true,
				["userColor"] = {
					["g"] = 0.2352941176470588,
					["b"] = 0.1529411764705883,
				},
				["dtheight"] = 19,
				["ttinst"] = false,
				["profcap"] = true,
				["showicon"] = false,
				["tthint"] = false,
				["lpfontsize"] = 14,
				["ttlevel"] = true,
				["displayOther"] = "NONE",
				["lpfontflags"] = "MONOCHROMEOUTLINE",
				["ttcoords"] = false,
				["ttreczones"] = false,
			},
			["layoutSet"] = "dpsMelee",
			["shadows"] = {
				["size"] = 2,
			},
			["movers"] = {
				["PetAB"] = "BOTTOMElvUIParentBOTTOM013",
				["LocationLiteMover"] = "TOPElvUIParentTOP0-2",
				["LeftChatMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT222",
				["GMMover"] = "TOPLEFTElvUIParentTOPLEFT155-4",
				["BuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-3",
				["LocationMover"] = "TOPElvUIParentTOP0-7",
				["BossButton"] = "BOTTOMElvUIParentBOTTOM0283",
				["DigSiteProgressBarMover"] = "BOTTOMElvUIParentBOTTOM0315",
				["ElvUF_RaidpetMover"] = "TOPLEFTElvUIParentTOPLEFT4-444",
				["PlayerPortraitMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT493215",
				["ElvUF_FocusMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-442178",
				["ClassBarMover"] = "BOTTOMElvUIParentBOTTOM-8230",
				["MicrobarMover"] = "TOPLEFTElvUIParentTOPLEFT4-4",
				["ElvUF_Raid25Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT2179",
				["MinimapMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-6",
				["ExperienceBarMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4204",
				["ElvUF_TargetTargetMover"] = "BOTTOMElvUIParentBOTTOM0164",
				["ElvUF_TargetMover"] = "BOTTOMElvUIParentBOTTOM231182",
				["ElvUF_PlayerCastbarMover"] = "BOTTOMElvUIParentBOTTOM-231147",
				["BuiDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["ElvUF_Raid40Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4211",
				["BenikButtonsMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4204",
				["ElvUF_Raid10Mover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["ElvAB_1"] = "BOTTOMElvUIParentBOTTOM092",
				["ElvAB_2"] = "BOTTOMElvUIParentBOTTOM058",
				["WatchFrameMover"] = "TOPRIGHTElvUIParentTOPRIGHT-122-292",
				["tokenHolderMover"] = "TOPLEFTElvUIParentTOPLEFT4-119",
				["BenikDashboardMover"] = "TOPLEFTElvUIParentTOPLEFT4-8",
				["TargetPowerBarMover"] = "BOTTOMElvUIParentBOTTOM247215",
				["AltPowerBarMover"] = "TOPElvUIParentTOP0-66",
				["ElvAB_3"] = "BOTTOMElvUIParentBOTTOM29558",
				["ReputationBarMover"] = "TOPRIGHTElvUIParentTOPRIGHT-2-181",
				["ElvUF_PetMover"] = "BOTTOMElvUIParentBOTTOM0191",
				["ArenaHeaderMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-56346",
				["ElvUF_PlayerMover"] = "BOTTOMElvUIParentBOTTOM-231182",
				["ElvAB_6"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-4215",
				["BNETMover"] = "TOPRIGHTElvUIParentTOPRIGHT-4-199",
				["ShiftAB"] = "TOPLEFTElvUIParentTOPLEFT407-39",
				["TargetPortraitMover"] = "BOTTOMElvUIParentBOTTOM312241",
				["ElvAB_5"] = "BOTTOMElvUIParentBOTTOM-29558",
				["ElvUF_TargetCastbarMover"] = "BOTTOMElvUIParentBOTTOM231147",
				["RightChatMover"] = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-222",
				["ElvUF_TankMover"] = "TOPLEFTElvUIParentTOPLEFT4-292",
				["BossHeaderMover"] = "TOPRIGHTElvUIParentTOPRIGHT-56-397",
				["PlayerPowerBarMover"] = "BOTTOMElvUIParentBOTTOM-231215",
				["VehicleSeatMover"] = "TOPLEFTElvUIParentTOPLEFT155-81",
				["ElvUF_PartyMover"] = "BOTTOMLEFTElvUIParentBOTTOMLEFT4210",
				["AlertFrameMover"] = "TOPElvUIParentTOP0-140",
				["DebuffsMover"] = "TOPRIGHTElvUIParentTOPRIGHT-189-134",
				["ElvUF_AssistMover"] = "TOPLEFTElvUIParentTOPLEFT4-392",
			},
			["tooltip"] = {
				["healthBar"] = {
					["fontSize"] = 9,
					["font"] = "Bui Prototype",
					["fontOutline"] = "OUTLINE",
				},
			},
			["unitframe"] = {
				["statusbar"] = "BuiFlat",
				["colors"] = {
					["auraBarBuff"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["health"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["power"] = {
						["MANA"] = {
							["b"] = 0.6941176470588235,
							["g"] = 0.5686274509803921,
							["r"] = 0,
						},
						["RUNIC_POWER"] = {
							["g"] = 0.8196078431372549,
						},
					},
					["castColor"] = {
						["b"] = 0.1,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["transparentCastbar"] = true,
					["transparentAurabars"] = true,
				},
				["fontOutline"] = "NONE",
				["font"] = "Bui Visitor1",
				["units"] = {
					["raid10"] = {
						["power"] = {
							["enable"] = false,
							["power"] = false,
						},
						["growthDirection"] = "DOWN_RIGHT",
					},
					["targettarget"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["boss"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 0,
						},
					},
					["pet"] = {
						["height"] = 24,
						["power"] = {
							["height"] = 5,
						},
					},
					["focus"] = {
						["castbar"] = {
							["height"] = 6,
							["width"] = 122,
						},
						["width"] = 122,
						["power"] = {
							["height"] = 5,
						},
					},
					["target"] = {
						["debuffs"] = {
							["anchorPoint"] = "TOPLEFT",
							["attachTo"] = "FRAME",
						},
						["portrait"] = {
							["overlay"] = true,
							["enable"] = true,
							["width"] = 56,
						},
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["customTexts"] = {
							["tarName"] = {
								["font"] = "Bui Tukui",
								["justifyH"] = "LEFT",
								["fontOutline"] = "OUTLINE",
								["xOffset"] = -170,
								["size"] = 21,
								["text_format"] = "[name] [difficultycolor][smartlevel]",
								["yOffset"] = -27,
							},
							["tarHealthPower"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "RIGHT",
								["fontOutline"] = "OUTLINE",
								["xOffset"] = 170,
								["size"] = 10,
								["text_format"] = " [powercolor][power:current] || ||cffFFFFFF[health:current] || [health:percent]||r",
								["yOffset"] = -26,
							},
						},
						["width"] = 300,
						["power"] = {
							["height"] = 5,
							["detachedWidth"] = 298,
							["xOffset"] = 2,
							["hideonnpc"] = false,
							["text_format"] = "",
							["yOffset"] = -25,
						},
						["health"] = {
							["text_format"] = "",
						},
						["name"] = {
							["text_format"] = "",
							["position"] = "RIGHT",
						},
						["height"] = 33,
						["buffs"] = {
							["anchorPoint"] = "TOPLEFT",
							["sizeOverride"] = 32,
							["enable"] = false,
							["attachTo"] = "DEBUFFS",
							["yOffset"] = 8,
						},
						["threatStyle"] = "ICONTOPLEFT",
						["aurabar"] = {
							["maxDuration"] = 120,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 5.999982833862305,
							["width"] = 192.9999847412109,
						},
					},
					["raid25"] = {
						["power"] = {
							["enable"] = false,
						},
					},
					["player"] = {
						["restIcon"] = false,
						["debuffs"] = {
							["attachTo"] = "BUFFS",
							["sizeOverride"] = 32,
							["yOffset"] = 2,
						},
						["portrait"] = {
							["overlay"] = true,
							["enable"] = true,
							["rotation"] = 130,
							["width"] = 56,
						},
						["castbar"] = {
							["icon"] = false,
							["width"] = 300,
						},
						["customTexts"] = {
							["HealthPower"] = {
								["font"] = "Bui Visitor1",
								["justifyH"] = "LEFT",
								["fontOutline"] = "MONOCHROMEOUTLINE",
								["xOffset"] = -170,
								["size"] = 10,
								["text_format"] = "[health:current] || [health:percent] || [powercolor][power:current]",
								["yOffset"] = -26,
							},
							["NewName"] = {
								["font"] = "Bui Tukui",
								["justifyH"] = "RIGHT",
								["fontOutline"] = "OUTLINE",
								["xOffset"] = 174,
								["yOffset"] = -27,
								["text_format"] = "[class]",
								["size"] = 21,
							},
						},
						["width"] = 300,
						["health"] = {
							["text_format"] = "",
						},
						["power"] = {
							["detachedWidth"] = 298,
							["height"] = 5,
							["text_format"] = "",
							["yOffset"] = -25,
						},
						["height"] = 33,
						["buffs"] = {
							["enable"] = true,
							["sizeOverride"] = 32,
							["attachTo"] = "FRAME",
							["yOffset"] = 8,
						},
						["classbar"] = {
							["fill"] = "spaced",
						},
						["threatStyle"] = "ICONTOPRIGHT",
					},
				},
			},
			["datatexts"] = {
				["font"] = "Bui Visitor1",
				["fontOutline"] = "MONOCROMEOUTLINE",
				["panelTransparency"] = true,
				["leftChatPanel"] = false,
				["panels"] = {
					["BenikLeftDTPanel"] = "Mastery",
					["RightChatDataPanel"] = {
						["left"] = "Mastery",
						["middle"] = "Bags",
					},
					["BenikRightDTPanel"] = "Combat/Arena Time",
					["BenikLeftChatDTPanel"] = {
						["right"] = "Mail",
					},
					["BuiLeftChatDTPanel"] = {
						["left"] = "Attack Power",
						["right"] = "Mail",
					},
					["BenikMiddleDTPanel"] = {
						["right"] = "Hit Rating",
						["left"] = "Crit Chance",
						["middle"] = "Haste",
					},
					["LeftChatDataPanel"] = {
						["right"] = "iMail",
						["left"] = "Spell/Heal Power",
						["middle"] = "Haste",
					},
				},
				["rightChatPanel"] = false,
			},
			["actionbar"] = {
				["bar3"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["font"] = "Bui Visitor1",
				["bar2"] = {
					["enabled"] = true,
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
					["backdrop"] = true,
					["heightMult"] = 2,
				},
				["fontOutline"] = "MONOCROMEOUTLINE",
				["bar1"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 30,
				},
				["barPet"] = {
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 10,
					["buttonsize"] = 27,
				},
				["bar5"] = {
					["buttons"] = 10,
					["buttonspacing"] = 4,
					["buttonsPerRow"] = 5,
					["backdrop"] = true,
					["buttonsize"] = 30,
				},
				["bar4"] = {
					["buttonspacing"] = 4,
					["buttonsize"] = 26,
				},
			},
			["auras"] = {
				["timeXOffset"] = -1,
				["fontSize"] = 9,
				["debuffs"] = {
					["size"] = 30,
				},
				["fontOutline"] = "MONOCROMEOUTLINE",
				["fadeThreshold"] = 10,
				["buffs"] = {
					["horizontalSpacing"] = 3,
					["size"] = 30,
				},
				["consolidatedBuffs"] = {
					["font"] = "Bui Visitor1",
					["fontSize"] = 9,
					["fontOutline"] = "MONOCROMEOUTLINE",
				},
				["font"] = "Bui Visitor1",
			},
			["dtc"] = {
				["customColor"] = 2,
				["userColor"] = {
					["b"] = 0.6901960784313725,
					["g"] = 0.8509803921568627,
					["r"] = 0.796078431372549,
				},
			},
			["loclite"] = {
				["dig"] = false,
				["lpfontsize"] = 10,
				["locpanel"] = false,
			},
			["utils"] = {
				["dwidth"] = 149,
				["twidth"] = 149,
			},
		},
		["Poliana - Aerie Peak"] = {
			["unitframe"] = {
				["units"] = {
					["boss"] = {
						["castbar"] = {
							["height"] = 0.9999746084213257,
							["width"] = 0,
						},
					},
					["focus"] = {
						["castbar"] = {
							["height"] = 5.999979019165039,
							["width"] = 189.9999847412109,
						},
					},
					["target"] = {
						["castbar"] = {
							["height"] = 9.000001907348633,
							["width"] = 270.0000305175781,
						},
					},
					["arena"] = {
						["castbar"] = {
							["height"] = 0.9999746084213257,
							["width"] = 192,
						},
					},
					["player"] = {
						["castbar"] = {
							["height"] = 9.000001907348633,
							["width"] = 270.0000305175781,
						},
					},
				},
			},
		},
	},
}
ElvPrivateDB = {
	["profileKeys"] = {
		["Adonela - Mazrigos"] = "Adonela - Mazrigos",
		["Felinn - Mazrigos"] = "Felinn - Mazrigos",
		["Benibee - Emerald Dream"] = "Benibee - Emerald Dream",
		["Benikia - Emerald Dream"] = "Benikia - Emerald Dream",
		["Nitali - Emerald Dream"] = "Nitali - Emerald Dream",
		["Benica - Emerald Dream"] = "Benica - Emerald Dream",
		["Moli - Mazrigos"] = "Moli - Mazrigos",
		["Benicio - Emerald Dream"] = "Benicio - Emerald Dream",
		["Benik - Emerald Dream"] = "Benik - Emerald Dream",
		["Beniman - Emerald Dream"] = "Beniman - Emerald Dream",
		["Shaobin - Emerald Dream"] = "Shaobin - Emerald Dream",
		["Lasi - Mazrigos"] = "Lasi - Mazrigos",
		["Jenei - Aerie Peak"] = "Jenei - Aerie Peak",
		["Benazir - Emerald Dream"] = "Benazir - Emerald Dream",
		["Bentium - Emerald Dream"] = "Bentium - Emerald Dream",
		["Poliana - Aerie Peak"] = "Poliana - Aerie Peak",
	},
	["profiles"] = {
		["Adonela - Mazrigos"] = {
			["theme"] = "classic",
			["install_complete"] = "6.03",
		},
		["Felinn - Mazrigos"] = {
			["theme"] = "classic",
			["install_complete"] = "6.03",
		},
		["Benibee - Emerald Dream"] = {
			["theme"] = "default",
			["install_complete"] = "6.994",
		},
		["Benikia - Emerald Dream"] = {
			["addonskins"] = {
				["RecountBackdrop"] = false,
				["EmbedSystem"] = true,
				["EmbedalDamageMeter"] = false,
				["EmbedRecount"] = true,
			},
			["theme"] = "class",
			["install_complete"] = "6.94",
		},
		["Moli - Mazrigos"] = {
			["theme"] = "class",
			["install_complete"] = "6.88",
		},
		["Benica - Emerald Dream"] = {
			["theme"] = "classic",
			["install_complete"] = "6.03",
		},
		["Nitali - Emerald Dream"] = {
			["theme"] = "classic",
			["install_complete"] = "6.03",
		},
		["Benicio - Emerald Dream"] = {
			["theme"] = "default",
			["install_complete"] = "6.994",
		},
		["Benik - Emerald Dream"] = {
			["addonskins"] = {
				["DBMFontSize"] = 11,
				["EmbedSystem"] = true,
				["TransparentEmbed"] = true,
				["RecountBackdrop"] = false,
				["EmbedalDamageMeter"] = false,
				["EmbedRecount"] = true,
				["DBMFont"] = "Bui Prototype",
			},
			["theme"] = "classic",
			["install_complete"] = "6.94",
		},
		["Beniman - Emerald Dream"] = {
			["theme"] = "classic",
			["install_complete"] = "6.03",
		},
		["Shaobin - Emerald Dream"] = {
			["addonskins"] = {
				["EmbedMain"] = "Skada",
				["EmbedalDamageMeter"] = false,
				["TransparentEmbed"] = true,
				["EmbedSystem"] = true,
				["EmbedSkada"] = true,
			},
			["theme"] = "default",
			["install_complete"] = "5.85",
		},
		["Lasi - Mazrigos"] = {
			["theme"] = "class",
			["install_complete"] = "6.88",
		},
		["Jenei - Aerie Peak"] = {
			["theme"] = "class",
			["install_complete"] = "6.94",
		},
		["Benazir - Emerald Dream"] = {
			["general"] = {
				["normTex"] = "BuiFlat",
			},
			["addonskins"] = {
				["RecountBackdrop"] = false,
				["SkadaBackdrop"] = false,
				["TransparentEmbed"] = true,
				["EmbedalDamageMeter"] = false,
				["EmbedSystem"] = true,
				["EmbedRecount"] = true,
			},
			["theme"] = "default",
			["install_complete"] = "6.991",
		},
		["Poliana - Aerie Peak"] = {
		},
		["Bentium - Emerald Dream"] = {
			["theme"] = "default",
			["addonskins"] = {
				["RecountBackdrop"] = false,
				["SkadaBackdrop"] = false,
				["TransparentEmbed"] = true,
				["EmbedalDamageMeter"] = false,
				["EmbedSystem"] = true,
				["EmbedRecount"] = true,
			},
			["install_complete"] = "6.991",
		},
	},
}
