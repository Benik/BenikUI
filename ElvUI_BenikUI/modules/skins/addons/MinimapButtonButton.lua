local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function MinimapButtonButton()
	if not (BUI:IsAddOnEnabled('MinimapButtonButton') and E.db.benikui.skins.variousSkins.minimapbb) then return end

	local mainButton = _G.MinimapButtonButtonButton
	if not mainButton then return end

	local children = { mainButton:GetChildren() }

	if not mainButton.style then
		mainButton:BuiStyle()
	end

	for _, child in ipairs(children) do
		if child:IsObjectType('Frame') and not child.style then
			child:BuiStyle()
			if not (E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows) then return end

			-- force move the child frame a bit to help the shadows
			child:ClearAllPoints()
			child:Point('RIGHT', mainButton, 'LEFT', -2, 0)

			local isMoving = false
			hooksecurefunc(child, "SetPoint", function(self)
				if isMoving then return end
				isMoving = true

				self:ClearAllPoints()
				self:Point('RIGHT', mainButton, 'LEFT', -2, 0)

				isMoving = false
			end)
		end
	end
end
S:AddCallback("BenikUI_MBB", MinimapButtonButton)