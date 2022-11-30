local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Styles')

function mod:styleAlertFrames()
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true or E.private.skins.blizzard.alertframes ~= true then return end
	
	local function StyleAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:BuiStyle('Outside')
			end
		end
	end

	hooksecurefunc(_G.AchievementAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.CriteriaAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.DungeonCompletionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GuildChallengeAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.InvasionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.ScenarioAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.WorldQuestCompleteAlertSystem, "setUpFunction", StyleAlert)

	hooksecurefunc(_G.GarrisonFollowerAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonTalentAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonBuildingAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonMissionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonShipMissionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", StyleAlert)

	hooksecurefunc(_G.HonorAwardedAlertSystem, "setUpFunction", StyleAlert)

	hooksecurefunc(_G.LegendaryItemAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.LootAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.LootUpgradeAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.MoneyWonAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.EntitlementDeliveredAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.RafRewardDeliveredAlertSystem, "setUpFunction", StyleAlert)

	hooksecurefunc(_G.DigsiteCompleteAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.NewRecipeLearnedAlertSystem, "setUpFunction", StyleAlert)

	hooksecurefunc(_G.NewPetAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.NewMountAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.NewToyAlertSystem, "setUpFunction", StyleAlert)

	local BonusRollMoneyWonFrame = _G.BonusRollMoneyWonFrame
	BonusRollMoneyWonFrame.backdrop:BuiStyle('Outside')

	local BonusRollLootWonFrame = _G.BonusRollLootWonFrame
	BonusRollLootWonFrame.backdrop:BuiStyle('Outside')
end