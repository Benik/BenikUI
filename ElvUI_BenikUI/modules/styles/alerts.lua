local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')

local hooksecurefunc = hooksecurefunc

local function StyleAlert(frame)
	if frame.backdrop then
		if not frame.backdrop.style then
			frame.backdrop:BuiStyle()
		end
	end
end

function mod:styleAlertFrames()
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true or E.private.skins.blizzard.alertframes ~= true then return end

	-- Achievements
	hooksecurefunc(_G.AchievementAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.CriteriaAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.MonthlyActivityAlertSystem, 'setUpFunction', StyleAlert)

	-- Encounters
	hooksecurefunc(_G.DungeonCompletionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GuildChallengeAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.InvasionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.ScenarioAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.WorldQuestCompleteAlertSystem, "setUpFunction", StyleAlert)

	-- Garrisons
	hooksecurefunc(_G.GarrisonFollowerAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonTalentAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonBuildingAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonMissionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonShipMissionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", StyleAlert)

	-- Honor
	hooksecurefunc(_G.HonorAwardedAlertSystem, "setUpFunction", StyleAlert)

	-- Loot
	hooksecurefunc(_G.LegendaryItemAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.LootAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.LootUpgradeAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.MoneyWonAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.EntitlementDeliveredAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.RafRewardDeliveredAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.HousingItemEarnedAlertFrameSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.InitiativeTaskCompleteAlertFrameSystem, 'setUpFunction', StyleAlert)

	-- Professions
	hooksecurefunc(_G.DigsiteCompleteAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.NewRecipeLearnedAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.SkillLineSpecsUnlockedAlertSystem, 'setUpFunction', StyleAlert)

	-- Pets/Mounts/Toys
	hooksecurefunc(_G.NewPetAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.NewMountAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(_G.NewToyAlertSystem, "setUpFunction", StyleAlert)

	-- Cosmetics
	hooksecurefunc(_G.NewCosmeticAlertFrameSystem, "setUpFunction", StyleAlert)

	-- Warband
	hooksecurefunc(_G.NewWarbandSceneAlertSystem, 'setUpFunction', StyleAlert)

	local BonusRollMoneyWonFrame = _G.BonusRollMoneyWonFrame
	BonusRollMoneyWonFrame.backdrop:BuiStyle()

	local BonusRollLootWonFrame = _G.BonusRollLootWonFrame
	BonusRollLootWonFrame.backdrop:BuiStyle()
end