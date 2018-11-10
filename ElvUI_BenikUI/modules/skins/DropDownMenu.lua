local E, L, V, P, G = unpack(ElvUI);
local BUIS = E:GetModule('BuiSkins')
local S = E:GetModule('Skins');

if tonumber(E.version) <= 10.82 then return end

local r, g, b = NORMAL_FONT_COLOR:GetRGB()
local arrow = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow'

local function CreateTempBackdrop(frame, texture)
	if frame.backdrop then return end

	local parent = frame.IsObjectType and frame:IsObjectType("Texture") and frame:GetParent() or frame

	local backdrop = CreateFrame("Frame", nil, parent)
	backdrop:SetOutside(frame)
	backdrop:SetTemplate("Transparent")

	if (parent:GetFrameLevel() - 1) >= 0 then
		backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		backdrop:SetFrameLevel(0)
	end

	frame.backdrop = backdrop
end

local function skinDropDownMenu()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc("UIDropDownMenu_CreateFrames", function()
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local listFrame = _G["DropDownList"..i];
			local listFrameName = listFrame:GetName();
			local index = listFrame and (listFrame.numButtons + 1) or 1;
			local expandArrow = _G[listFrameName.."Button"..index.."ExpandArrow"];
			if expandArrow then
				expandArrow:SetNormalTexture(arrow)
				expandArrow:SetSize(11, 11)
				expandArrow:GetNormalTexture():SetVertexColor(r, g, b)
				expandArrow:GetNormalTexture():SetRotation(BUIS.ArrowRotation['RIGHT'])
			end
		end
	end)

	hooksecurefunc("ToggleDropDownMenu", function(level)
		if not level then level = 1 end

		for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
			local button = _G["DropDownList"..level.."Button"..i]
			local check = _G["DropDownList"..level.."Button"..i.."Check"]
			local uncheck = _G["DropDownList"..level.."Button"..i.."UnCheck"]

			CreateTempBackdrop(check)
			if check.backdrop then
				check.backdrop:Hide()
			end

			if not button.notCheckable then
				uncheck:SetTexture("")
				local _, co = check:GetTexCoord()
				if co == 0 then
					check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
					check:SetVertexColor(r, g, b, 1)
					check:SetSize(20, 20)
					check:SetDesaturated(true)
					check.backdrop:SetInside(check, 4, 4)
				else
					check:SetTexture(E["media"].blankTex)
					check:SetVertexColor(r, g, b, .6)
					check:SetSize(10, 10)
					check:SetDesaturated(false)
					check.backdrop:SetOutside(check)
				end

				check.backdrop:Show()
				check:SetTexCoord(0, 1, 0, 1)
			else
				check:SetSize(16, 16)
			end
		end
	end)
end
S:AddCallback("BenikUI_skinDropDownMenu", skinDropDownMenu)