local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIS = E:GetModule('BuiSkins')
local S = E:GetModule('Skins');

local assert, next = assert, next
local find = string.find

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

BUIS.ArrowRotation = {
	['UP'] = 3.14,
	['DOWN'] = 0,
	['LEFT'] = -1.57,
	['RIGHT'] = 1.57,
}

local r, g, b = NORMAL_FONT_COLOR:GetRGB()
local arrow = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow'

function S:HandleMaxMinFrame(frame)
	assert(frame, "does not exist.")

	frame:StripTextures()

	for name, direction in pairs ({ ["MaximizeButton"] = 'UP', ["MinimizeButton"] = 'DOWN'}) do
		local button = frame[name]
		if button then
			button:SetSize(20, 20)
			button:ClearAllPoints()
			button:SetPoint("CENTER")

			button:SetNormalTexture(nil)
			button:SetPushedTexture(nil)
			button:SetHighlightTexture(nil)

			if not button.backdrop then
				button:CreateBackdrop()
				button.backdrop:Point("TOPLEFT", button, 1, -1)
				button.backdrop:Point("BOTTOMRIGHT", button, -1, 1)
				button.backdrop:SetTemplate('NoBackdrop')
				button:SetHitRectInsets(1, 1, 1, 1)
			end

			button.backdrop.img = button.backdrop:CreateTexture(nil, 'OVERLAY')
			button.backdrop.img:SetInside()
			button.backdrop.img:Point("CENTER")
			button.backdrop.img:SetTexture(arrow)
			button.backdrop.img:SetVertexColor(1, 1, 1)

			button.backdrop.img:SetRotation(BUIS.ArrowRotation[direction])

			button:HookScript('OnEnter', function(self)
				if E.myclass == 'PRIEST' then
					self.backdrop.img:SetVertexColor(unpack(E["media"].rgbvaluecolor))
					self.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
				else
					self.backdrop.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
					self.backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b)
				end
			end)

			button:HookScript('OnLeave', function(self)
				self.backdrop.img:SetVertexColor(1, 1, 1)
				self.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			end)
		end
	end
end

function S:HandleNextPrevButton(btn, useVertical, inverseDirection)
	inverseDirection = inverseDirection or btn:GetName() and (find(btn:GetName():lower(), 'left') or find(btn:GetName():lower(), 'prev') or find(btn:GetName():lower(), 'decrement') or find(btn:GetName():lower(), 'back'))

	btn:StripTextures()
	btn:SetNormalTexture(nil)
	btn:SetPushedTexture(nil)
	btn:SetHighlightTexture(nil)
	btn:SetDisabledTexture(nil)
	if not btn.icon then
		btn.icon = btn:CreateTexture(nil, 'ARTWORK')
		btn.icon:Size(13)
		btn.icon:Point('CENTER')
		btn.icon:SetTexture(nil)
	end

	if not btn.img then
		btn.img = btn:CreateTexture(nil, 'ARTWORK')
		btn.img:SetTexture(arrow)
		btn.img:SetSize(12, 12)
		btn.img:Point('CENTER')
		btn.img:SetVertexColor(r, g, b)

		btn:HookScript('OnMouseDown', function(button)
			if button:IsEnabled() then
				button.img:Point("CENTER", -1, -1);
			end
		end)

		btn:HookScript('OnMouseUp', function(button)
			button.img:Point("CENTER", 0, 0);
		end)

		btn:HookScript('OnDisable', function(button)
			SetDesaturation(button.img, true);
			button.img:SetAlpha(0.5);
		end)

		btn:HookScript('OnEnable', function(button)
			SetDesaturation(button.img, false);
			button.img:SetAlpha(1.0);
		end)

		if not btn:IsEnabled() then
			btn:GetScript('OnDisable')(btn)
		end
	end

	if useVertical then
		if inverseDirection then
			btn.img:SetRotation(BUIS.ArrowRotation['UP'])
		else
			btn.img:SetRotation(BUIS.ArrowRotation['DOWN'])
		end
	else
		if inverseDirection then
			btn.img:SetRotation(BUIS.ArrowRotation['LEFT'])
		else
			btn.img:SetRotation(BUIS.ArrowRotation['RIGHT'])
		end
	end

	S:HandleButton(btn)
	btn:Size(btn:GetWidth() - 7, btn:GetHeight() - 7)
end

function S:HandleCloseButton(f, point, text)
	f:StripTextures()

	if not f.backdrop then
		f:CreateBackdrop()
		f.backdrop:Point('TOPLEFT', 7, -8)
		f.backdrop:Point('BOTTOMRIGHT', -8, 8)
		f.backdrop:SetTemplate('NoBackdrop')
		f:SetHitRectInsets(6, 6, 7, 7)
	end

	if not text then text = '' end
	
	f.backdrop.img = f.backdrop:CreateTexture(nil, 'OVERLAY')
	f.backdrop.img:SetSize(12, 12)
	f.backdrop.img:Point("CENTER")
	f.backdrop.img:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Close.tga')
	f.backdrop.img:SetVertexColor(1, 1, 1)
	
	f:HookScript('OnEnter', function(self)
		if E.myclass == 'PRIEST' then
			self.backdrop.img:SetVertexColor(unpack(E["media"].rgbvaluecolor))
			self.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
		else
			self.backdrop.img:SetVertexColor(classColor.r, classColor.g, classColor.b)
			self.backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b)
		end
	end)

	f:HookScript('OnLeave', function(self)
		self.backdrop.img:SetVertexColor(1, 1, 1)
		self.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	end)

	if not f.text then
		f.text = f:CreateFontString(nil, 'OVERLAY')
		f.text:SetFont([[Interface\AddOns\ElvUI\media\fonts\PT_Sans_Narrow.ttf]], 16, 'OUTLINE')
		f.text:SetText(text)
		f.text:SetJustifyH('CENTER')
		f.text:Point('CENTER', f, 'CENTER')
	end

	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

local buttons = {
	"ElvUIMoverNudgeWindowUpButton",
	"ElvUIMoverNudgeWindowDownButton",
	"ElvUIMoverNudgeWindowLeftButton",
	"ElvUIMoverNudgeWindowRightButton",
}

local function replaceConfigArrows(button)
	-- remove the default icons
	local tex = _G[button:GetName().."Icon"]
	if tex then
		tex:SetTexture(nil)
	end

	-- add the new icon
	if not button.img then
		button.img = button:CreateTexture(nil, 'ARTWORK')
		button.img:SetTexture(arrow)
		button.img:SetSize(12, 12)
		button.img:Point('CENTER')
		button.img:SetVertexColor(r, g, b)

		button:HookScript('OnMouseDown', function(btn)
			if btn:IsEnabled() then
				btn.img:Point("CENTER", -1, -1);
			end
		end)

		button:HookScript('OnMouseUp', function(btn)
			btn.img:Point("CENTER", 0, 0);
		end)
	end
end

function BUIS:ApplyConfigArrows()
	for _, btn in pairs(buttons) do
		replaceConfigArrows(_G[btn])
	end

	-- Apply the rotation
	_G["ElvUIMoverNudgeWindowUpButton"].img:SetRotation(BUIS.ArrowRotation['UP'])
	_G["ElvUIMoverNudgeWindowDownButton"].img:SetRotation(BUIS.ArrowRotation['DOWN'])
	_G["ElvUIMoverNudgeWindowLeftButton"].img:SetRotation(BUIS.ArrowRotation['LEFT'])
	_G["ElvUIMoverNudgeWindowRightButton"].img:SetRotation(BUIS.ArrowRotation['RIGHT'])

end
hooksecurefunc(E, "CreateMoverPopup", BUIS.ApplyConfigArrows)

function BUIS:skinScrollBarThumb(frame)
	if E.private.skins.blizzard.enable ~= true then return end

	local texture = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\MelliDark.tga'

	if frame:GetName() then
		if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
			if frame.thumbbg and frame.thumbbg.backdropTexture then
				frame.thumbbg.backdropTexture.SetVertexColor = nil
				frame.thumbbg.backdropTexture:SetVertexColor(r, g, b)
				frame.thumbbg.backdropTexture:SetTexture(texture)
				frame.thumbbg.backdropTexture.SetVertexColor = E.noop
			end
		end
	elseif frame.ScrollUpButton and frame.ScrollDownButton then
		if frame.thumbbg and frame.thumbbg.backdropTexture then
			frame.thumbbg.backdropTexture.SetVertexColor = nil
			frame.thumbbg.backdropTexture:SetVertexColor(r, g, b)
			frame.thumbbg.backdropTexture:SetTexture(texture)
			frame.thumbbg.backdropTexture.SetVertexColor = E.noop
		end
	else
		if frame.thumbbg and frame.thumbbg.backdropTexture then
			frame.thumbbg.backdropTexture.SetVertexColor = nil
			frame.thumbbg.backdropTexture:SetVertexColor(r, g, b)
			frame.thumbbg.backdropTexture:SetTexture(texture)
			frame.thumbbg.backdropTexture.SetVertexColor = E.noop
		end
	end
end
hooksecurefunc(S, "HandleScrollBar", BUIS.skinScrollBarThumb)
hooksecurefunc(S, "HandleScrollSlider", BUIS.skinScrollBarThumb)

function BUIS:ReskinCheckBox(frame, noBackdrop, noReplaceTextures)
	assert(frame, "does not exist.")

	frame:StripTextures()

	if noBackdrop then
		frame:SetTemplate("Default")
		frame:Size(16)
	else
		frame:CreateBackdrop("Default")
		frame.backdrop:SetInside(nil, 4, 4)
	end

	if not noReplaceTextures then
		if frame.SetCheckedTexture then
			frame:SetCheckedTexture(E["media"].blankTex)
			frame:GetCheckedTexture():SetVertexColor(r, g, b)
			frame:GetCheckedTexture():SetInside(frame.backdrop)
		end

		if frame.SetDisabledTexture then
			frame:SetDisabledTexture(E["media"].blankTex)
			frame:GetDisabledTexture():SetVertexColor(r, g, b, 0.5)
			frame:GetDisabledTexture():SetInside(frame.backdrop)
		end

		frame:HookScript('OnDisable', function(checkbox)
			if not checkbox.SetDisabledTexture then return; end
			if checkbox:GetChecked() then
				checkbox:SetDisabledTexture(E["media"].blankTex)
				checkbox:GetDisabledTexture():SetVertexColor(r, g, b, 0.5)
				checkbox:GetDisabledTexture():SetInside(frame.backdrop)
			else
				checkbox:SetDisabledTexture("")
			end
		end)

		hooksecurefunc(frame, "SetNormalTexture", function(checkbox, texPath)
			if texPath ~= "" then checkbox:SetNormalTexture("") end
		end)
		hooksecurefunc(frame, "SetPushedTexture", function(checkbox, texPath)
			if texPath ~= "" then checkbox:SetPushedTexture("") end
		end)
		hooksecurefunc(frame, "SetHighlightTexture", function(checkbox, texPath)
			if texPath ~= "" then checkbox:SetHighlightTexture("") end
		end)
	end
end
hooksecurefunc(S, "HandleCheckBox", BUIS.ReskinCheckBox)

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

local function skinStackSplitArrows()
	if E.private.skins.blizzard.enable ~= true then return end

	local buttons = {_G["StackSplitLeftButton"], _G["StackSplitRightButton"]}
	for _, btn in pairs(buttons) do
		S:HandleNextPrevButton(btn)
		btn:Size(14, 18)

		btn:ClearAllPoints()
		if btn == _G["StackSplitLeftButton"] then
			btn:Point('LEFT', StackSplitFrame.bg1, 'LEFT', 4, 0)
		else
			btn:Point('RIGHT', StackSplitFrame.bg1, 'RIGHT', -4, 0)
		end
	end
	StackSplitText:ClearAllPoints()
	StackSplitText:Point('RIGHT', StackSplitRightButton, 'LEFT', -6, 0)
end
S:AddCallback("BenikUI_StackSplitArrows", skinStackSplitArrows)

-- Credit: Azilroka
function BUIS:skinButtonArrow(button)
	if button.Icon then
		local Texture = button.Icon:GetTexture()
		if Texture and strfind(Texture, [[Interface\ChatFrame\ChatFrameExpandArrow]]) then
			button.Icon:SetTexture(arrow)
			button.Icon:SetVertexColor(r, g, b)
			button.Icon:SetRotation(BUIS.ArrowRotation['RIGHT'])
		end
	end
end
hooksecurefunc(S, "HandleButton", BUIS.skinButtonArrow)