local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local next = next

local function SkinAllTheThings()
	local att = _G.AllTheThings

	local attFrames = {
		"MiniList",
		"Prime",
		"Tradeskills",
	}

	for _, frame in next, (attFrames) do
		local skinFrame = att:GetWindow(frame)
		if skinFrame and not skinFrame.IsSkinned then
			S:HandleFrame(skinFrame)
			S:HandleScrollBar(skinFrame.ScrollBar)
			skinFrame:BuiStyle()
			skinFrame.IsSkinned = true
		end
	end
end

local function AllTheThings()
	if not (BUI:IsAddOnEnabled('AllTheThings') and E.db.benikui.skins.variousSkins.alltheThings) then return end

	local att = _G.AllTheThings
	att.AddEventHandler("OnReady", SkinAllTheThings)
	att.AddEventHandler("OnWindowCreated", SkinAllTheThings)
end
S:AddCallbackForAddon("AllTheThings", "BenikUI_AllTheThings", AllTheThings)