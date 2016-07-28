local E, L, V, P, G = unpack(ElvUI);

	--[[ Code you can use for alert testing
		--Queued Alerts:
		/run AchievementAlertSystem:AddAlert(5192)
		/run CriteriaAlertSystem:AddAlert(9023, "Doing great!")
		/run LootAlertSystem:AddAlert("\124cffa335ee\124Hitem:18832::::::::::\124h[Brutality Blade]\124h\124r", 1, 1, 1, 1, false, false, 0, false, false)
		/run LootUpgradeAlertSystem:AddAlert("\124cffa335ee\124Hitem:18832::::::::::\124h[Brutality Blade]\124h\124r", 1, 1, 1, nil, nil, false)
		/run MoneyWonAlertSystem:AddAlert(815)
		/run NewRecipeLearnedAlertSystem:AddAlert(204)
		
		--Simple Alerts
		/run GuildChallengeAlertSystem:AddAlert(3, 2, 5)
		/run InvasionAlertSystem:AddAlert(1)
		/run WorldQuestCompleteAlertSystem:AddAlert(112)
		/run GarrisonBuildingAlertSystem:AddAlert("Barracks")
		/run GarrisonFollowerAlertSystem:AddAlert(204, "Ben Stone", 90, 3, false)
		/run GarrisonMissionAlertSystem:AddAlert(681) (Requires a mission ID that is in your mission list.)
		/run GarrisonShipFollowerAlertSystem:AddAlert(592, "Test", "Transport", "GarrBuilding_Barracks_1_H", 3, 2, 1)
		/run LegendaryItemAlertSystem:AddAlert("\124cffa335ee\124Hitem:18832::::::::::\124h[Brutality Blade]\124h\124r")
		/run StorePurchaseAlertSystem:AddAlert("\124cffa335ee\124Hitem:180545::::::::::\124h[Mystic Runesaber]\124h\124r", "", "", 214)
		/run DigsiteCompleteAlertSystem:AddAlert(1)
	]]