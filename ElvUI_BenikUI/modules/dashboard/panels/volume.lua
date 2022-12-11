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

local statusColors = {
	'cff0CD809',	-- green
	'cffE8DA0F',	-- yellow
	'cffFF9000',	-- orange
	'cffD80909',	-- red
}

local SOUND_MUTE_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-mute.blp:14:14|t')
local SOUND_LOW_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-low.blp:14:14|t')
local SOUND_MEDIUM_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-medium.blp:14:14|t')
local SOUND_MAX_ICON = ('|TInterface\\AddOns\\ElvUI_BenikUI\\media\\textures\\sound-max.blp:14:14|t')

local function GetVolumePercent(cat)
	local volume = tonumber(GetCVar(cat));
	volume = floor(volume * 100);
	return volume;
end

local function RoundVolume(cat)
	local digit
	if IsShiftKeyDown() then
		digit = 1
	else
		digit = 2
	end

	local volume = tonumber(GetCVar(cat))
	volume = E:Round(volume, digit)
	return volume;
end

local function Sound_MasterVolumeUp()
	local digit1, digit2
	if IsShiftKeyDown() then
		digit1 = 0.9
		digit2 = 0.1
	else
		digit1 = 0.99
		digit2 = 0.01
	end
	local volume = RoundVolume('Sound_MasterVolume')

	if (volume and volume <= digit1) then
		SetCVar('Sound_MasterVolume', volume + digit2);
	end
end

local function Sound_MasterVolumeDown()
	local digit
	if IsShiftKeyDown() then
		digit = 0.1
	else
		digit = 0.01
	end

	local volume = RoundVolume('Sound_MasterVolume')

	if (volume and volume >= digit) then
		SetCVar('Sound_MasterVolume', volume - digit);
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
		if IsShiftKeyDown() then
			_G.Settings.OpenToCategory(_G.Settings.AUDIO_CATEGORY_ID)
		else
			Sound_ToggleSound()
		end
	end

	if btn == 'RightButton' then
		Sound_ToggleMusic()
	end
end

local function IconOnEnter(self)
	local bar = self:GetParent()
	local db = bar.db
	local holder = bar:GetParent()

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
	GameTooltip:AddDoubleLine(L['ShiftClick :'], SOUND_OPTIONS, 0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:AddDoubleLine(L['MouseWheel :'], VOLUME..' +/-', 0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:AddDoubleLine(L['Shift+MouseWheel :'], L['Fast Volume +/-'], 0.7, 0.7, 1, 0.7, 0.7, 1)
	GameTooltip:Show()

	if db.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function IconOnLeave(self)
	local bar = self:GetParent()
	local db = bar.db
	local holder = bar:GetParent()

	if db.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
	GameTooltip:Hide()
end

local function OnEvent(self)
	local db = self.db
	local holder = self:GetParent()
	local volGet = GetCVar('Sound_MasterVolume') or 1
	local volumeValue = tonumber(E:Round(100 * volGet, 0))

	local max = 100
	local color
	local icon

	self.Status:SetValue(volumeValue)

	if (GetCVar('Sound_EnableSFX') == '0') then
		color = 4
		icon = SOUND_MUTE_ICON
	else
		if(volumeValue * 100 / max >= 75) then
			color = 2
			icon = SOUND_MAX_ICON
		elseif volumeValue * 100 / max < 75 and volumeValue * 100 / max > 30 then
			color = 1
			icon = SOUND_MEDIUM_ICON
		elseif volumeValue == 0 then
			icon = SOUND_MUTE_ICON
			color = 4
		else
			color = 3
			icon = SOUND_LOW_ICON
		end
	end

	if holder:GetAlpha() == 0 then
		self.iconBG.text:SetText('')
	else
		self.iconBG.text:SetText(icon)
	end

	local displayFormat = join('', VOLUME..':|', statusColors[color], ' %d%%|r')
	self.Text:SetFormattedText(displayFormat, volumeValue)

	if db.overrideColor then
		local r, g, b = E:HexToRGB(statusColors[color])
		self.Status:SetStatusBarColor(r/255, g/255, b/255)
	end
end

function mod:CreateVolume()
	local bar = _G['BUI_Volume']
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard
	bar:SetParent(holder)
	bar.db = db

	local iconBG = CreateFrame('Frame', nil, bar)
	iconBG:Size(16, 16)
	iconBG:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, (E.PixelMode and 4 or 6))
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

	bar.iconBG = iconBG

	iconBG:SetScript('OnEnter', IconOnEnter)
	iconBG:SetScript('OnLeave', IconOnLeave)
	iconBG:SetScript('OnMouseWheel', iconBG_OnMouseWheel)
	iconBG:SetScript('OnMouseUp', iconBG_OnClick)

	bar:SetScript('OnEvent', OnEvent)
	bar:RegisterEvent('VARIABLES_LOADED')
	bar:RegisterEvent('CVAR_UPDATE')
end