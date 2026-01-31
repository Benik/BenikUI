local BUI, E, L, V, P, G = unpack((select(2, ...)))
--[[local mod = BUI:NewModule('Dev','AceTimer-3.0','AceHook-3.0','AceEvent-3.0')



function mod:Initialize()

end

BUI:RegisterModule(mod:GetName())]]


function BUI:FixTags1()
    -- v1
    E.db.unitframe.units.player.customTexts = E.db.unitframe.units.player.customTexts or {}
    E.db.unitframe.units.target.customTexts = E.db.unitframe.units.target.customTexts or {}
    E.db.unitframe.units.party.customTexts = E.db.unitframe.units.party.customTexts or {}

    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] = nil
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] = nil
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] = nil
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] = nil
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] = nil

    E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 4
    E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
    E.db["unitframe"]["units"]["player"]["health"]["text_format"] = '[health:current:shortvalue] | [perhp<%]'
    E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = 'InfoPanel'

    E.db["unitframe"]["units"]["player"]["name"]["position"] = "LEFT"
    E.db["unitframe"]["units"]["player"]["name"]["text_format"] = '[name]'
    E.db["unitframe"]["units"]["player"]["name"]["xOffset"] = 8
    E.db["unitframe"]["units"]["player"]["name"]["yOffset"] = 0
    E.db["unitframe"]["units"]["player"]["name"]["attachTextTo"] = 'Health'

    E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
    E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
    E.db["unitframe"]["units"]["player"]["power"]["position"] = 'RIGHT'
    E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][curpp] | [perpp<%]"
    E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = 'InfoPanel'

    E.db["unitframe"]["units"]["target"]["health"]["text_format"] = '[perhp<%] | [health:current:shortvalue]'
    E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = -2
    E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
    E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = 'InfoPanel'

    E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
    E.db["unitframe"]["units"]["target"]["name"]["text_format"] = '[name:medium] [difficulty][smartlevel] [shortclassification]'
    E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 0
    E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = 0
    E.db["unitframe"]["units"]["target"]["name"]["attachTextTo"] = 'Health'

    E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][curpp] | [perpp<%]"
    E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 4
    E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
    E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = 'InfoPanel'

    E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:current:shortvalue] | [perhp<%]"
    E.db["unitframe"]["units"]["party"]["health"]["position"] = "LEFT"
    E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
    E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 0

    E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 4
    E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 0
    E.db["unitframe"]["units"]["party"]["name"]["position"] = "LEFT"
    E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "InfoPanel"

    E.db["unitframe"]["units"]["party"]["power"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
    E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = 0
    E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2

    E:StaggeredUpdateAll(nil, true)
end

function BUI:FixTags2()
	E.db.unitframe.units.player.customTexts = E.db.unitframe.units.player.customTexts or {}
	E.db.unitframe.units.target.customTexts = E.db.unitframe.units.target.customTexts or {}
	E.db.unitframe.units.party.customTexts = E.db.unitframe.units.party.customTexts or {}
	E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] or {}
	E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] or {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] or {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] or {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] = E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] or {}

    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["font"] = "Bui Tukui"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["justifyH"] = "RIGHT"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["size"] = 20
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["text_format"] = "[health:current:shortvalue] | [perhp<%]"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["xOffset"] = 0
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["yOffset"] = -2
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["font"] = "Bui Tukui"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["justifyH"] = "LEFT"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["size"] = 20
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["text_format"] = "[name]"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["xOffset"] = 2
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["yOffset"] = -2
    E.db["unitframe"]["units"]["player"]["name"]["text_format"] = ""
    E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
    E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][curpp] | [perpp<%]"
    E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = 'InfoPanel'
    E.db["unitframe"]["units"]["player"]["power"]["position"] = 'RIGHT'

    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["font"] = "Bui Tukui"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["justifyH"] = "LEFT"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["size"] = 20
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["text_format"] = "[perhp<%] | [health:current:shortvalue]"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["xOffset"] = 2
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["yOffset"] = -2
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["font"] = "Bui Tukui"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["justifyH"] = "RIGHT"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["size"] = 20
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["text_format"] = "[name:medium] [difficulty][smartlevel] [shortclassification]"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["xOffset"] = 5
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["yOffset"] = -2
    E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
    E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
    E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][curpp] | [perpp<%]"
    E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 4
    E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
    E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = 'InfoPanel'
    E.db["unitframe"]["units"]["target"]["power"]["position"] = 'LEFT'

    E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["party"]["health"]["position"] = "RIGHT"
    E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:current:shortvalue] | [perhp<%]"
    E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
    E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0

    E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["party"]["name"]["position"] = "TOPLEFT"
    E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 16
    E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 2

    E:StaggeredUpdateAll(nil, true)
end

function BUI:FixTags3()
	E.db.unitframe.units.player.customTexts = E.db.unitframe.units.player.customTexts or {}
	E.db.unitframe.units.target.customTexts = E.db.unitframe.units.target.customTexts or {}
	E.db.unitframe.units.party.customTexts = E.db.unitframe.units.party.customTexts or {}
	E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] or {}
	E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] or {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] or {}
	E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] or {}
	E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] = E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] or {}

    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["font"] = "Expressway"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["justifyH"] = "RIGHT"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["size"] = 20
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["text_format"] = "[health:current:shortvalue] | [perhp<%]"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["xOffset"] = -8
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["yOffset"] = -1
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["attachTextTo"] = "InfoPanel"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["font"] = "Expressway"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["justifyH"] = "RIGHT"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["size"] = 11
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["text_format"] = "[name]"
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["xOffset"] = -8
    E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["yOffset"] = 0
    E.db["unitframe"]["units"]["player"]["name"]["text_format"] = ""
    E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
    E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][curpp] | [perpp<%]"

    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["font"] = "Expressway"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["justifyH"] = "LEFT"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["size"] = 20
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["text_format"] = "[perhp<%] | [health:current:shortvalue]"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["xOffset"] = 8
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["yOffset"] = -1
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["attachTextTo"] = "InfoPanel"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["font"] = "Expressway"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["justifyH"] = "LEFT"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["size"] = 11
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["text_format"] = "[name:medium] [difficulty][smartlevel] [shortclassification]"
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["xOffset"] = 8
    E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["yOffset"] = 0
    E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
    E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
    E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][curpp] | [perpp<%]"
    E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 0
    E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
    E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = 'InfoPanel'
    E.db["unitframe"]["units"]["target"]["power"]["position"] = 'RIGHT'

    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["attachTextTo"] = "Health"
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["font"] = "Expressway"
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["fontOutline"] = "SHADOW"
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["justifyH"] = "RIGHT"
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["size"] = 12
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["text_format"] = "[health:current:shortvalue] | [perhp<%]"
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["xOffset"] = 0
    E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["yOffset"] = 0
    E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
    E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "InfoPanel"
    E.db["unitframe"]["units"]["party"]["name"]["position"] = "LEFT"
    E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:medium] [difficultycolor][smartlevel]"
    E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 4
    E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 0

    E:StaggeredUpdateAll(nil, true)
end