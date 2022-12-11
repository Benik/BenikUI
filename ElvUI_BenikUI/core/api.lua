local BUI, E, L, V, P, G = unpack(select(2, ...))

local format, lower, tonumber = string.format, string.lower, tonumber

local GetGameTime = GetGameTime
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime

local TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME = TIMEMANAGER_TOOLTIP_LOCALTIME, TIMEMANAGER_TOOLTIP_REALMTIME

local monthAbr = {
	[1] = L["Jan"],
	[2] = L["Feb"],
	[3] = L["Mar"],
	[4] = L["Apr"],
	[5] = L["May"],
	[6] = L["Jun"],
	[7] = L["Jul"],
	[8] = L["Aug"],
	[9] = L["Sep"],
	[10] = L["Oct"],
	[11] = L["Nov"],
	[12] = L["Dec"],
}

local daysAbr = {
	[1] = L["Sun"],
	[2] = L["Mon"],
	[3] = L["Tue"],
	[4] = L["Wed"],
	[5] = L["Thu"],
	[6] = L["Fri"],
	[7] = L["Sat"],
}

-- Create Date
function BUI:createDate()
	local date = C_DateAndTime_GetCurrentCalendarTime()
	local presentWeekday = date.weekday
	local presentMonth = date.month
	local presentDay = date.monthDay
	local presentYear = date.year
    local days = daysAbr[presentWeekday]
    local months = monthAbr[presentMonth]

    return days, months, presentDay, presentYear
end

-- Create Time
function BUI:createTime()
    local db = E.global.datatexts.settings.Time
	local hour, hour24, minute, ampm = tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = GetGameTime()

	local localTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

	if db.localTime then
        return db.time24 and localTime24 or localTime
	else
        return db.time24 and realmTime24 or realmTime
	end
end