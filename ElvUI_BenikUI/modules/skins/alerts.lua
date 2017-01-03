local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

local pairs = pairs

-- Alert Frames
local staticAlertFrames = {
	ScenarioLegionInvasionAlertFrame,
	BonusRollMoneyWonFrame,
	BonusRollLootWonFrame,
	GarrisonBuildingAlertFrame,
	GarrisonMissionAlertFrame,
	GarrisonShipMissionAlertFrame,
	GarrisonRandomMissionAlertFrame,
	WorldQuestCompleteAlertFrame,
	GarrisonFollowerAlertFrame,
	LegendaryItemAlertFrame,
	GarrisonTalentAlertFrame,
}

local function styleAlertFrames()
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true or E.private.skins.blizzard.alertframes ~= true then return end
	
	local function StyleAchievementAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(AchievementAlertSystem, "setUpFunction", StyleAchievementAlert)

	local function StyleCriteriaAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
				frame.Icon.Texture.b:Style('Outside')
			end
		end
	end
	hooksecurefunc(CriteriaAlertSystem, "setUpFunction", StyleCriteriaAlert)

	local function StyleDungeonCompletionAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(DungeonCompletionAlertSystem, "setUpFunction", StyleDungeonCompletionAlert)

	local function StyleGuildChallengeAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GuildChallengeAlertSystem, "setUpFunction", StyleGuildChallengeAlert)

	local function StyleInvasionAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(InvasionAlertSystem, "setUpFunction", StyleInvasionAlertSystem)

	local function StyleScenarioAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(ScenarioAlertSystem, "setUpFunction", StyleScenarioAlert)
	
	local function StyleWorldQuestCompleteAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(WorldQuestCompleteAlertSystem, "setUpFunction", StyleWorldQuestCompleteAlert)

	local function StyleGarrisonFollowerAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GarrisonFollowerAlertSystem, "setUpFunction", StyleGarrisonFollowerAlert)

	local function StyleGarrisonShipFollowerAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GarrisonShipFollowerAlertSystem, "setUpFunction", StyleGarrisonShipFollowerAlertSystem)

	local function StyleGarrisonTalentAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GarrisonTalentAlertSystem, "setUpFunction", StyleGarrisonTalentAlertSystem)

	local function StyleGarrisonBuildingAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GarrisonBuildingAlertSystem, "setUpFunction", StyleGarrisonBuildingAlertSystem)

	local function StyleGarrisonMissionAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GarrisonMissionAlertSystem, "setUpFunction", StyleGarrisonMissionAlertSystem)

	local function StyleGarrisonShipMissionAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GarrisonShipMissionAlertSystem, "setUpFunction", StyleGarrisonShipMissionAlertSystem)

	local function StyleGarrisonRandomMissionAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(GarrisonRandomMissionAlertSystem, "setUpFunction", StyleGarrisonRandomMissionAlertSystem)

	local function StyleLegendaryItemAlertSystem(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(LegendaryItemAlertSystem, "setUpFunction", StyleLegendaryItemAlertSystem)

	local function StyleLootWonAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(LootAlertSystem, "setUpFunction", StyleLootWonAlert)

	local function StyleLootUpgradeAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(LootUpgradeAlertSystem, "setUpFunction", StyleLootUpgradeAlert)

	local function StyleMoneyWonAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(MoneyWonAlertSystem, "setUpFunction", StyleMoneyWonAlert)

	local function StyleStorePurchaseAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(StorePurchaseAlertSystem, "setUpFunction", StyleStorePurchaseAlert)

	local function StyleDigsiteCompleteAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(DigsiteCompleteAlertSystem, "setUpFunction", StyleDigsiteCompleteAlert)

	local function StyleRecipeLearnedAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
	hooksecurefunc(NewRecipeLearnedAlertSystem, "setUpFunction", StyleRecipeLearnedAlert)

	for _, frame in pairs(staticAlertFrames) do
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
end

S:AddCallback("BenikUI_Alerts", styleAlertFrames)