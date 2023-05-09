local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')
local mod = BUI:GetModule('Shadows')

-- AddonSkins tabs
function mod:TabShadowsAS(tab)
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:CreateSoftShadow()
	end
end

function mod:DBMShadows()
	if not BUI.AS then return end
	local AS = unpack(AddOnSkins) -- this is needed cause it's ADDON_LOADED

	local function SkinBars(s)
		for bar in s:GetBarIterator() do
			if not bar.injected then
				hooksecurefunc(bar, "Update", function()
					local sparkEnabled = DBT.Options.Spark
					if not (AS:CheckOption('DBMSkinHalf') and sparkEnabled) then return end
					local spark = _G[bar.frame:GetName().."BarSpark"]
					spark:SetSize(12, DBT.Options.Height*3/2 - 2)
					local a, b, c, d = spark:GetPoint()
					spark:SetPoint(a, b, c, d, 0)
				end)
				hooksecurefunc(bar, "ApplyStyle", function()
					local frame = bar.frame
					local tbar = _G[frame:GetName()..'Bar']
					local icon1 = _G[frame:GetName()..'BarIcon1']
					local icon2 = _G[frame:GetName()..'BarIcon2']
					local name = _G[frame:GetName()..'BarName']
					local timer = _G[frame:GetName()..'BarTimer']
					local iconSize = bar.enlarged and DBT.Options.HugeHeight or DBT.Options.Height
					if AS:CheckOption('DBMSkinHalf') then
						iconSize = iconSize * 2
					end

					AS:SkinTexture(icon1, true)
					icon1:ClearAllPoints()
					icon1:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMLEFT', AS:AdjustForTheme(-2), 1)
					icon1:SetSize(iconSize, iconSize)

					AS:SkinTexture(icon2, true)
					icon2:ClearAllPoints()
					icon2:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT', AS:AdjustForTheme(2), 1)
					icon2:SetSize(iconSize, iconSize)

					AS:SetInside(tbar, frame)

					AS:SetTemplate(frame)
					frame:CreateSoftShadow()

					name:ClearAllPoints()
					name:SetJustifyH('LEFT')

					timer:ClearAllPoints()
					timer:SetJustifyH('RIGHT')

					if AS:CheckOption('DBMSkinHalf') then
						name:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, 3)
						timer:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', -1, 1)
					else
						name:SetPoint('LEFT', frame, 'LEFT', 4, 0)
						timer:SetPoint('RIGHT', frame, 'RIGHT', -4, 0)
					end

					if DBT.Options.IconLeft then icon1.backdrop:Show() else icon1.backdrop:Hide() end
					if DBT.Options.IconRight then icon2.backdrop:Show() else icon2.backdrop:Hide() end
					
					icon1.backdrop:CreateSoftShadow()
					icon2.backdrop:CreateSoftShadow()
					
					bar.injected = true
				end)
				bar:ApplyStyle()
			end
		end
	end

	if DBM then -- We need this check, if DBM isnt loaded = error!
		hooksecurefunc(DBT, 'CreateBar', SkinBars)
	end
end

function mod:AddonSkins()
	if not BUI.AS then return end
	local AS = unpack(AddOnSkins)

	hooksecurefunc(AS, "SkinTab", mod.TabShadowsAS)

	if BUI.ShadowMode and E.db.benikui.skins.addonSkins.dbm then
		mod:DBMShadows()
	end
end
