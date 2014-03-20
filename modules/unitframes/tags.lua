local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

ElvUF.Tags.Events['playergroup'] = 'GROUP_ROSTER_UPDATE'
ElvUF.Tags.Methods['playergroup'] = function(unit)
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if name == UnitName('player') then
				return format('G%d', subgroup)
			end
		end
	end
end

--[[ElvUF.Tags.Events['targetgroup'] = 'GROUP_ROSTER_UPDATE'
ElvUF.Tags.Methods['targetgroup'] = function(unit)
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if name == GetUnitName('target', nil) then--and UnitInRaid("target") then
				return format('G%d', subgroup)
			else
				return
			end
		end
	end
end]]

