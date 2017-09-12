local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');
local BUIS = E:GetModule('BuiSkins')

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

function BUIS:styleAlertFrames()
	if E.private.skins.blizzard.enable ~= true or E.db.benikui.general.benikuiStyle ~= true or E.private.skins.blizzard.alertframes ~= true then return end
	
	local function StyleAlert(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end

	hooksecurefunc(AchievementAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(DungeonCompletionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GuildChallengeAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(InvasionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(ScenarioAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(WorldQuestCompleteAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GarrisonFollowerAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GarrisonShipFollowerAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GarrisonTalentAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GarrisonBuildingAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GarrisonMissionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GarrisonShipMissionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(GarrisonRandomMissionAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(LegendaryItemAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(LootAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(LootUpgradeAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(MoneyWonAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(StorePurchaseAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(DigsiteCompleteAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(NewRecipeLearnedAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(NewPetAlertSystem, "setUpFunction", StyleAlert)
	hooksecurefunc(NewMountAlertSystem, "setUpFunction", StyleAlert)
	
	local function StyleAlertWithIcon(frame)
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
				frame.Icon.Texture.b:Style('Outside')
			end
		end
	end
	hooksecurefunc(CriteriaAlertSystem, "setUpFunction", StyleAlertWithIcon)

	for _, frame in pairs(staticAlertFrames) do
		if frame.backdrop then
			if not frame.backdrop.style then
				frame.backdrop:Style('Outside')
			end
		end
	end
end