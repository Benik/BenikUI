local E, L, V, P, G = unpack(ElvUI);
local upper = string.upper

ElvUF.Tags.Events['name:cap'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:cap'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and upper(name) or ''
end

ElvUF.Tags.Events['name:veryshort:cap'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:veryshort:cap'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and upper(E:ShortenString(name, 5)) or ''
end

ElvUF.Tags.Events['name:short:cap'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:short:cap'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and upper(E:ShortenString(name, 10)) or ''
end

ElvUF.Tags.Events['name:medium:cap'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:medium:cap'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and upper(E:ShortenString(name, 15)) or ''
end

ElvUF.Tags.Events['name:long:cap'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:long:cap'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and upper(E:ShortenString(name, 20)) or ''
end
