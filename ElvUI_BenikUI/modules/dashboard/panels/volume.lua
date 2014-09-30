local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub('LibSharedMedia-3.0')
local BUID = E:GetModule('BuiDashboard')

local SPACING = (E.PixelMode and 1 or 5)

local function GetVolumePercent(cat)
    local volume = tonumber(GetCVar(cat));
    volume = floor(volume * 100);
    return volume;
end

local function dummy_OnEnter(self)
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

local function dummy_OnLeave(self)
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

local function dummy_OnMouseWheel(self, d)
	if (d > 0) then
		Sound_MasterVolumeUp()
	else
		Sound_MasterVolumeDown()
	end
end

-- Toggle all sounds
function dummy_OnClick(self, btn)
	if btn == 'LeftButton' then
		--Sound_ToggleMusic()
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

function BUID:CreateVolume()
	local id = 5
	
	local dummy = CreateFrame('Frame', 'Voldummy', BuiDashboard)
	dummy:Size(16,16)
	dummy:Point('BOTTOMRIGHT', BUID.board[id], 'BOTTOMRIGHT', 2, 0)
	dummy:SetFrameStrata('LOW')
	dummy.text = dummy:CreateFontString(nil, 'OVERLAY')
	dummy.text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	dummy.text:Point('RIGHT', dummy, 'RIGHT')
	dummy.text:SetJustifyH('LEFT')
	dummy.text:SetTextColor(1, 0.5, 0.1)
	dummy.text:SetShadowColor(0, 0, 0)
	dummy.text:SetShadowOffset(1.25, -1.25)
	dummy:EnableMouse(true)
	dummy:EnableMouseWheel(true)
	dummy:SetScript('OnEnter', dummy_OnEnter)
	dummy:SetScript('OnLeave', dummy_OnLeave)
	dummy:SetScript('OnMouseWheel', dummy_OnMouseWheel)
	dummy:SetScript('OnMouseUp', dummy_OnClick)

	BUID.board[id].Status:SetScript('OnUpdate', function(self)
		local volGet = GetCVar('Sound_MasterVolume')
		local volume = tonumber(E:Round(100 * volGet, 0))

		local max = 100
		local color = 3
		local icon
		
		self:SetValue(volume)

		if (GetCVar('Sound_EnableSFX') == '0') then
			color = 1
			dummy:SetAlpha(1)
			icon = SOUND_MUTE_ICON
		else
			if(volume * 100 / max >= 75) then
				self:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
				color = 3
				icon = SOUND_MAX_ICON
			elseif volume * 100 / max < 75 and volume * 100 / max > 30 then
				self:SetStatusBarColor(1, 180 / 255, 0, .8)
				color = 2
				icon = SOUND_MEDIUM_ICON
			elseif volume == 0 then
				icon = SOUND_MUTE_ICON
				color = 1
			else
				self:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
				color = 2
				icon = SOUND_LOW_ICON
			end
		end
		
		dummy.text:SetText(icon)
		local displayFormat = string.join('', VOLUME..':', statusColors[color], ' %d%%|r')
		BUID.board[id].Text:SetFormattedText(displayFormat, volume)
	end)
	BUID.board[id].Status:RegisterEvent('VARIABLES_LOADED')
	BUID.board[id].Status:RegisterEvent('CVAR_UPDATE')
end


