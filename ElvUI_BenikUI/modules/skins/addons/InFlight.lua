local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function StyleInFlight()
	local frame = _G.InFlightBar
	if frame then
		if E.db.benikui.misc.flightMode.enable then
			if not frame.isSkinned then
				frame:CreateBackdrop('Transparent', true, true)
				frame.backdrop:SetOutside(frame, 2, 2)
				frame.backdrop:SetBackdropBorderColor(.3, .3, .3, 1)
				frame.backdrop:CreateWideShadow()
				frame.isSkinned = true
			end
		else
			if not frame.isStyled then
				frame:CreateBackdrop("Transparent")
				frame.backdrop:BuiStyle()
				frame.isStyled = true
			end
		end
	end
end

local function LoadInFlight()
	if not (BUI:IsAddOnEnabled('InFlight') and E.db.benikui.skins.variousSkins.inflight) then return end

	hooksecurefunc(InFlight, 'StartTimer', StyleInFlight)
end
S:AddCallback("BenikUI_InFlight", LoadInFlight)