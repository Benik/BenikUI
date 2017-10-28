local E, L, V, P, G = unpack(ElvUI);
local AB = E:GetModule('ActionBars');
local BAB = E:GetModule('BuiActionbars');

local unpack = unpack
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UIFrameFadeOut = UIFrameFadeOut

-- GLOBALS: CreateAnimationGroup, ElvUI_Bar1_Bui, ElvUI_Bar2_Bui

local function ab3_OnClick()
	if E.db.actionbar.bar3.enabled == true then
		E.db.actionbar.bar3.enabled = false
	elseif E.db.actionbar.bar3.enabled == false then
		E.db.actionbar.bar3.enabled = true
	end
	AB:UpdateButtonSettings('bar3');
end

local function ab5_OnClick()
	if E.db.actionbar.bar5.enabled == true then
		E.db.actionbar.bar5.enabled = false
	elseif E.db.actionbar.bar5.enabled == false then
		E.db.actionbar.bar5.enabled = true
	end
	AB:UpdateButtonSettings('bar5');
end

-- Switch ABs buttons
local abtn = {}
function BAB:CreateButtons()
	for i = 1, 2 do
		abtn[i] = CreateFrame('Button', nil, E.UIParent)
		abtn[i]:Size(12, 5)
		abtn[i]:SetTemplate('Default', true)
		abtn[i]:SetAlpha(0)
		abtn[i].tex = abtn[i]:CreateTexture(nil, 'OVERLAY')
		abtn[i].tex:SetInside()
		abtn[i].tex:SetTexture(E['media'].BuiFlat)
		abtn[i].tex:SetVertexColor(unpack(E['media'].rgbvaluecolor))

		abtn[i].anim = CreateAnimationGroup(abtn[i])
		abtn[i].anim.height = abtn[i].anim:CreateAnimation("Height")
		abtn[i].anim.height:SetDuration(.1)

		abtn[i]:SetScript('OnEnter', function(self)
			if InCombatLockdown() then return end
			self.anim.height:SetChange(12)
			self:SetAlpha(1)
			self.anim:Play()

			if i == 1 then
				self:SetScript('OnClick', ab3_OnClick)
			else
				self:SetScript('OnClick', ab5_OnClick)
			end
		end)

		abtn[i]:SetScript('OnLeave', function(self)
			self.anim.height:SetChange(5)
			self.anim:Play()
			UIFrameFadeOut(self, .5, 1, 0)
		end)
	end
	BAB:ShowButtons()
end

function BAB:ShowButtons()
	local bar1 = ElvUI_Bar1.backdrop.style
	local bar2 = ElvUI_Bar2.backdrop.style
	local db = E.db.benikui.actionbars.toggleButtons

	if bar1 or bar2 then
		for i = 1, 2 do
			abtn[i]:ClearAllPoints()
			if db.chooseAb == 'BAR2' then
				abtn[i]:SetParent(bar2)
				if i == 1 then
					abtn[i]:Point('RIGHT', bar2, 'RIGHT')
				else
					abtn[i]:Point('LEFT', bar2, 'LEFT')
				end
			else
				abtn[i]:SetParent(bar1)
				if i == 1 then
					abtn[i]:Point('RIGHT', bar1, 'RIGHT')
				else
					abtn[i]:Point('LEFT', bar1, 'LEFT')
				end
			end

			if db.enable then
				abtn[i]:Show()
			else
				abtn[i]:Hide()
			end
		end
	end
end

function BAB:LoadToggleButtons()
	if not E.db.benikui.general.benikuiStyle then return end
	BAB:CreateButtons()
end