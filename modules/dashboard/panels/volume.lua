local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")
local id = 5

local function dummy_OnEnter(self,...)
	E:UIFrameFadeIn(self, 0.2, self:GetAlpha())
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 5, -20)
	GameTooltip:ClearAllPoints()
	
	GameTooltip:ClearLines()
	local master = GetVolumePercent("Sound_MasterVolume");
	local effects = GetVolumePercent("Sound_SFXVolume");
	local music = GetVolumePercent("Sound_MusicVolume");
	local ambience = GetVolumePercent("Sound_AmbienceVolume");
	
	if (GetCVar("Sound_EnableSFX") == "0") then
		GameTooltip:AddDoubleLine(MASTER_VOLUME, MUTED, 1, 1, 1, selectioncolor)
	else
		GameTooltip:AddDoubleLine(MASTER_VOLUME, master.."%", 1, 1, 1, selectioncolor)
	end
	GameTooltip:AddDoubleLine(ENABLE_SOUNDFX, effects.."%", 1, 1, 1, selectioncolor)
	GameTooltip:AddDoubleLine(MUSIC_VOLUME, music.."%", 1, 1, 1, selectioncolor)
	GameTooltip:AddDoubleLine(VOICE_AMBIENCE, ambience.."%", 1, 1, 1, selectioncolor)
	GameTooltip:Show()
end

local function dummy_OnLeave(self,...)
	E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0.4)
	GameTooltip:Hide()
end

local function dummy_OnMouseWheel(self, d)
	if (d > 0) then
		Sound_MasterVolumeUp()
	else
		Sound_MasterVolumeDown()
	end
end

function Sound_MasterVolumeUp()
    local volume = (GetCVar("Sound_MasterVolume"));

    volume = tonumber(E:Round(volume, 1));
	if (volume and volume <= 0.9) then
		SetCVar("Sound_MasterVolume", volume + 0.1);
	end
end

function Sound_MasterVolumeDown()
    local volume = (GetCVar("Sound_MasterVolume"));

    volume = tonumber(E:Round(volume, 1));
	if (volume and volume >= 0.1) then
		SetCVar("Sound_MasterVolume", volume - 0.1);
	end
end

function GetVolumePercent(cat)
    local volume = tonumber(GetCVar(cat));

    volume = floor(volume * 100);

    return volume;
end

local soundIcons = {
	"|TInterface\\AddOns\\ElvUI_Benik\\media\\textures\\sound-mute.blp:14:14|t",
	"|TInterface\\AddOns\\ElvUI_Benik\\media\\textures\\sound-low.blp:14:14|t",
	"|TInterface\\AddOns\\ElvUI_Benik\\media\\textures\\sound-medium.blp:14:14|t",
	"|TInterface\\AddOns\\ElvUI_Benik\\media\\textures\\sound-max.blp:14:14|t",
}

-- Toggle all sounds
function dummy_OnClick(self)
	if ( GetCVar("Sound_EnableAllSound") == "0" ) then
		ActionStatus_DisplayMessage(SOUND_DISABLED, true);
	else
        if ( GetCVar("Sound_EnableSFX") == "0" ) then
            SetCVar("Sound_EnableSFX", 1);
            SetCVar("Sound_EnableAmbience", 1);
            SetCVar("Sound_EnableMusic", 1);
            ActionStatus_DisplayMessage(SOUND_EFFECTS_ENABLED, true);
        else
            SetCVar("Sound_EnableSFX", 0);
            SetCVar("Sound_EnableAmbience", 0);
            SetCVar("Sound_EnableMusic", 0);
            ActionStatus_DisplayMessage(SOUND_EFFECTS_DISABLED, true);
        end
    end
end

local dummy = CreateFrame('Frame', 'Voldummy', BenikDashboard)
dummy:Size(20,20)
dummy:Point("BOTTOMRIGHT", board[id], "BOTTOMRIGHT")
dummy:SetFrameStrata('LOW')
dummy.text = dummy:CreateFontString(nil, "OVERLAY")
dummy.text:FontTemplate()
dummy:SetAlpha(0.3)
dummy.text:Point("RIGHT", dummy, "RIGHT")
dummy.text:SetJustifyH('LEFT')
dummy.text:SetTextColor(1, 0.5, 0.1)
dummy.text:SetShadowColor(0, 0, 0)
dummy.text:SetShadowOffset(1.25, -1.25)
dummy:EnableMouse(true)
dummy:EnableMouseWheel(true)
dummy:SetScript('OnEnter', dummy_OnEnter)
dummy:SetScript('OnLeave', dummy_OnLeave)
dummy:SetScript("OnMouseWheel", dummy_OnMouseWheel)
dummy:SetScript("OnMouseUp", dummy_OnClick)

local statusColors = {
	"|cffee0000", -- red
	"|cfff6a01a", -- orange
	"|cff5eed2c", -- light green
}

board[id].Status:SetScript("OnUpdate", function(self)
	local volGet = GetCVar("Sound_MasterVolume")
	local volume = tonumber(E:Round(100 * volGet, 0))

	local max = 100
	local color = 3
	local icon

	self:SetValue(volume)

	if (GetCVar("Sound_EnableSFX") == "0") then
		color = 1
		dummy:SetAlpha(1)
		dummy.text:SetText(MUTED..soundIcons[1])
	else
		if(volume * 100 / max >= 75) then
			self:SetStatusBarColor(30 / 255, 1, 30 / 255, .8)
			color = 3
			icon = 4
		elseif volume * 100 / max < 75 and volume * 100 / max > 30 then
			self:SetStatusBarColor(1, 180 / 255, 0, .8)
			color = 2
			icon = 3
		elseif volume == 0 then
			icon = 1
			color = 1
		else
			self:SetStatusBarColor(1, 75 / 255, 75 / 255, 0.5, .8)
			color = 2
			icon = 2
		end
		dummy.text:SetText(soundIcons[icon])
	end
	
	local displayFormat = string.join("", VOLUME..":", statusColors[color], " %d%%|r")
	board[id].Text:SetFormattedText(displayFormat, volume)
end)

board[id].Status:RegisterEvent("VARIABLES_LOADED")
board[id].Status:RegisterEvent("CVAR_UPDATE")