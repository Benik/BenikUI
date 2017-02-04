local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadVATProfile()
	E.db["VAT"]["enableStaticColor"] = true
	E.db["VAT"]["barHeight"] = 5
	E.db["VAT"]["spacing"] = -6
	E.db["VAT"]["staticColor"]["r"] = 1
	E.db["VAT"]["staticColor"]["g"] = 0.5
	E.db["VAT"]["staticColor"]["b"] = 0
	E.db["VAT"]["showText"] = true
	E.db["VAT"]["colors"]["minutesIndicator"]["r"] = 1
	E.db["VAT"]["colors"]["minutesIndicator"]["g"] = 0.5
	E.db["VAT"]["colors"]["minutesIndicator"]["b"] = 0
	E.db["VAT"]["colors"]["expireIndicator"]["r"] = 1
	E.db["VAT"]["colors"]["expireIndicator"]["g"] = 0.5
	E.db["VAT"]["colors"]["expireIndicator"]["b"] = 0
	E.db["VAT"]["colors"]["secondsIndicator"]["r"] = 1
	E.db["VAT"]["colors"]["secondsIndicator"]["g"] = 0.5
	E.db["VAT"]["colors"]["secondsIndicator"]["b"] = 0
	E.db["VAT"]["colors"]["daysIndicator"]["r"] = 1
	E.db["VAT"]["colors"]["daysIndicator"]["g"] = 0.5
	E.db["VAT"]["colors"]["daysIndicator"]["b"] = 0
	E.db["VAT"]["colors"]["hoursIndicator"]["r"] = 1
	E.db["VAT"]["colors"]["hoursIndicator"]["g"] = 0.5
	E.db["VAT"]["colors"]["hoursIndicator"]["b"] = 0
	E.db["VAT"]["statusbarTexture"] = 'BuiFlat'
	E.db["VAT"]["position"] = 'TOP'
end