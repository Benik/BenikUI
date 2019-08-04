local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local LSM = E.LSM

local _G = _G
local join, tonumber, floor = string.join, tonumber, floor

local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local GetCVar, SetCVar = GetCVar, SetCVar
local Sound_ToggleSound = Sound_ToggleSound
local Sound_ToggleMusic = Sound_ToggleMusic

local MASTER_VOLUME, MUTED, ENABLE_SOUNDFX, MUSIC_VOLUME, VOICE_AMBIENCE, VOLUME = MASTER_VOLUME, MUTED, ENABLE_SOUNDFX, MUSIC_VOLUME, VOICE_AMBIENCE, VOLUME
local BINDING_NAME_TOGGLESOUND, BINDING_NAME_TOGGLEMUSIC = BINDING_NAME_TOGGLESOUND, BINDING_NAME_TOGGLEMUSIC

-- GLOBALS: selectioncolor

local function GetVolumePercent(cat)
	local volume = tonumber(GetCVar(cat));
	volume = floor(volume * 100);
	return volume;
end

local function iconBG_OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 5, -20)
	GameTooltip:ClearAllPoints()

	GameTooltip:ClearLines()
	local master = GetVolumePercent('Sound_MasterVolume');
	local effects = GetVolumePercent('Sound_SFXVolume');
	local music = GetVolumePercent('Sound_MusicVolume');
	local ambience = GetVolumePercent('Sound_AmbienceVolume');

	if (GetCVar('Sound_EnableAllSound') == '0') then
		GameTooltip:AddDoubleLine(MASTER_VOLUME, MUTED, 1, 1, 1, selectioncolor)
	else
		GameTooltip:AddDoubleLine(MASTER_VOLUME, master..'%', 1, 1, 1, selectioncolor)
	end
	GameTooltip:AddDoubleLine(ENABLE_SOUNDFX, effects..'%', 1, 1, 1, selectioncolor)
	GameTooltip:AddDoubleLine(MUSIC_VOLUME, music..'%', 1, 1, 1, selectioncolor)
	GameTooltip:AddDoubleLine(VOICE_AMBIENCE, ambience..'%', 1, 1, 1, selectioncolor)
	GameTooltip:AddLine(' ')
	GameTooltip:AddDoubleLine(L['Click :'], BINDING_NAME_TOGGLESOUND, 0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:AddDoubleLine(L['RightClick :'], BINDING_NAME_TOGGLEMUSIC, 0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:AddDoubleLine(L['MouseWheel :'], VOLUME..' +/-', 0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:Show()
end

local function iconBG_OnLeave(self)
	GameTooltip:Hide()
end

local function Sound_MasterVolumeUp()
	local volume = (GetCVar('Sound_MasterVolume'));

	volume = tonumber(E:Round(volume, 1));
	if (volume and volume <= 0.9) then
		SetCVar('Sound_MasterVolume', volume + 0.1);
	end
end

local function Sound_MasterVolumeDown()
	local volume = (GetCVar('Sound_MasterVolume'));

	volume = tonumber(E:Round(volume, 1));
	if (volume and volume >= 0.1) then
		SetCVar('Sound_MasterVolume', volume - 0.1);
	end
end

local function iconBG_OnMouseWheel(self, d)
	if (d > 0) then
		Sound_MasterVolumeUp()
	else
		Sound_MasterVolumeDown()
	end
end

-- Toggle all sounds
local function iconBG_OnClick(self, btn)
	if btn == 'LeftButton' then
		Sound_ToggleSound()
	end

	if btn == 'RightButton' then
		Sound_ToggleMusic()
	end
end

local statusColors = {
	'|cffee0000', -- red
	'|cfff6a01a', -- orange
	'|cff5eed2c', -- light green
}

local SOUND_MUTE_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-mute.blp:14:14|t')
local SOUND_LOW_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-low.blp:14:14|t')
local SOUND_MEDIUM_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-medium.blp:14:14|t')
local SOUND_MAX_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-max.blp:14:14|t')

function mod:CreateVolume()
	local boardName = _G['BUI_Volume']

	local iconBG = CreateFrame('Frame', nil, boardName)
	iconBG:Size(16,16)
	iconBG:Point('BOTTOMRIGHT', boardName, 'BOTTOMRIGHT', 0, (E.PixelMode and 4 or 6))
	iconBG:SetFrameStrata('LOW')
	iconBG.text = iconBG:CreateFontString(nil, 'OVERLAY')
	iconBG.text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	iconBG.text:Point('RIGHT', iconBG, 'RIGHT')
	iconBG.text:SetJustifyH('LEFT')
	iconBG.text:SetTextColor(1, 0.5, 0.1)
	iconBG.text:SetShadowColor(0, 0, 0)
	iconBG.text:SetShadowOffset(1.25, -1.25)
	iconBG:EnableMouse(true)
	iconBG:EnableMouseWheel(true)
	iconBG:SetScript('OnEnter', iconBG_OnEnter)
	iconBG:SetScript('OnLeave', iconBG_OnLeave)
	iconBG:SetScript('OnMouseWheel', iconBG_OnMouseWheel)
	iconBG:SetScript('OnMouseUp', iconBG_OnClick)

	boardName.Status:SetScript('OnUpdate', function(self)
		local volGet = GetCVar('Sound_MasterVolume')
		local volumeValue = tonumber(E:Round(100 * volGet, 0))

		local max = 100
		local color = 3
		local icon

		self:SetValue(volumeValue)

		if (GetCVar('Sound_EnableSFX') == '0') then
			color = 1
			iconBG:SetAlpha(1)
			icon = SOUND_MUTE_ICON
		else
			if(volumeValue * 100 / max >= 75) then
				color = 3
				icon = SOUND_MAX_ICON
			elseif volumeValue * 100 / max < 75 and volumeValue * 100 / max > 30 then
				color = 2
				icon = SOUND_MEDIUM_ICON
			elseif volumeValue == 0 then
				icon = SOUND_MUTE_ICON
				color = 1
			else
				color = 2
				icon = SOUND_LOW_ICON
			end
		end

		iconBG.text:SetText(icon)
		local displayFormat = join('', VOLUME..':', statusColors[color], ' %d%%|r')
		boardName.Text:SetFormattedText(displayFormat, volumeValue)
	end)
	boardName.Status:RegisterEvent('VARIABLES_LOADED')
	boardName.Status:RegisterEvent('CVAR_UPDATE')
end