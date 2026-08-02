local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')
local mod = BUI:GetModule('Shadows')

local _G = _G
local hooksecurefunc = hooksecurefunc

local ClearRealm = string.gsub(E.myrealm, "%s+", "")

-------------------------------------------------------
-- Based on Azilroka's DBM skin and Half bar feature --
-------------------------------------------------------

function mod:DbmHalfBarSkin()
	if not E.db.benikui.skins.variousSkins.dbmSkin then return end
	if not BUI:IsAddOnEnabled("DBM-Core") then return end

	local DBM = _G.DBM
	if not DBM then return end

	local DBT = _G.DBT
	local requiredProfile = "BenikUI"..E.myname.."-"..ClearRealm

	local function SkinBars(s)
		for bar in s:GetBarIterator() do
			if not bar.injected then
				hooksecurefunc(bar, "Update", function()
					if _G.DBM_UsedProfile ~= requiredProfile then return end

					local sparkEnabled = DBT.Options.Spark

					if not (E.db.benikui.skins.variousSkins.dbmHalfBar and sparkEnabled) then return end
					local spark = _G[bar.frame:GetName().."BarSpark"]

					local baseHeight = bar.enlarged and DBT.Options.HugeHeight or DBT.Options.Height
					spark:SetSize(12, ((baseHeight / 2) * 3) - 2)

					local a, b, c, d = spark:GetPoint()
					spark:SetPoint(a, b, c, d, 0)
				end)

				hooksecurefunc(bar, "ApplyStyle", function()
					if _G.DBM_UsedProfile ~= requiredProfile then return end

					local frame = bar.frame
					local isSecret = bar.isSecret
					local tbar = _G[frame:GetName()..'Bar']
					local icon1 = _G[frame:GetName()..'BarIcon1']
					local icon2 = _G[frame:GetName()..'BarIcon2']
					local jIcons = isSecret and _G[frame:GetName().."BarSJIcons"] or _G[frame:GetName().."BarIJIcons"]
					local jIcons2 = isSecret and _G[frame:GetName().."BarSJIcons2"] or _G[frame:GetName().."BarIJIcons2"]
					local jIcons3 = isSecret and _G[frame:GetName().."BarSJIcons3"] or _G[frame:GetName().."BarIJIcons3"]
					local jIcons4 = isSecret and _G[frame:GetName().."BarSJIcons4"] or _G[frame:GetName().."BarIJIcons4"]
					local name = _G[frame:GetName()..'BarName']
					local timer = _G[frame:GetName()..'BarTimer']
					local iconSize = bar.enlarged and DBT.Options.HugeHeight or DBT.Options.Height

					if E.db.benikui.skins.variousSkins.dbmHalfBar then
						frame:Height(iconSize / 2)
					else
						frame:Height(iconSize)
					end

					S:HandleIcon(icon1, true)
					icon1:ClearAllPoints()
					icon1:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMLEFT', -4, 0)
					icon1:SetSize(iconSize, iconSize)

					S:HandleIcon(icon2, true)
					icon2:ClearAllPoints()
					icon2:SetPoint('BOTTOMLEFT', frame, 'BOTTOMRIGHT', 4, 0)
					icon2:SetSize(iconSize, iconSize)

					jIcons:SetSize(iconSize, iconSize)
					jIcons2:SetSize(iconSize, iconSize)
					jIcons3:SetSize(iconSize, iconSize)
					jIcons4:SetSize(iconSize, iconSize)

					frame:CreateBackdrop("Transparent")
					tbar:SetInside(frame.backdrop)

					name:ClearAllPoints()
					name:SetJustifyH('LEFT')

					timer:ClearAllPoints()
					timer:SetJustifyH('RIGHT')

					if E.db.benikui.skins.variousSkins.dbmHalfBar then
						name:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, 3)
						timer:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', -1, 3)
					else
						name:SetPoint('LEFT', frame, 'LEFT', 4, 0)
						timer:SetPoint('RIGHT', frame, 'RIGHT', -4, 0)
					end

					if DBT.Options.IconLeft then icon1.backdrop:Show() else icon1.backdrop:Hide() end
					if DBT.Options.IconRight then icon2.backdrop:Show() else icon2.backdrop:Hide() end

					if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
						if not frame.backdrop.shadow then
							frame.backdrop:CreateSoftShadow()
						end
						if not icon1.backdrop.shadow then
							icon1.backdrop:CreateSoftShadow()
						end
						if not icon2.backdrop.shadow then
							icon2.backdrop:CreateSoftShadow()
						end
					end

					bar.injected = true
				end)

				bar:ApplyStyle()
			end
		end
	end

	hooksecurefunc(DBT, 'CreateBar', SkinBars)
end

function mod:DbmFrames()
	if not BUI:IsAddOnEnabled("DBM-Core") then return end

	local DBM = _G.DBM
	if not DBM then return end

	local function StyleRangeFrame(_, _, forceshow)
		if DBM.Options.DontShowRangeFrame and not forceshow then return end

		local rangeCheckFrame = _G.DBMRangeCheckRadar
		if rangeCheckFrame then
			if not rangeCheckFrame.style then
				rangeCheckFrame:BuiStyle()
			end
		end

		local rangeFrame = _G.DBMRangeCheck
		if rangeFrame then
			if not rangeFrame.style then
				rangeFrame:BuiStyle()
			end
		end
	end

	local function StyleInfoFrame(_, event, ...)
		if DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end

		local infoFrame = _G.DBMInfoFrame
		if infoFrame and not infoFrame.style then
			infoFrame:BuiStyle()
		end
	end

	hooksecurefunc(DBM.RangeCheck, 'Show', StyleRangeFrame)
	hooksecurefunc(DBM.InfoFrame, 'Show', StyleInfoFrame)
end

function mod:DBM()
	mod:DbmHalfBarSkin()
	mod:DbmFrames()
end
S:AddCallbackForAddon("DBM-Core", "BenikUI_DBM", mod.DBM)

local function DBM_Options()
	local DBM_GUI_OptionsFrame = _G.DBM_GUI_OptionsFrame
	DBM_GUI_OptionsFrame:StripTextures()
	DBM_GUI_OptionsFrame:SetTemplate("Transparent")
	DBM_GUI_OptionsFrame:BuiStyle()
	_G.DBM_GUI_OptionsFrameClosePanelButton:SetAlpha(0) -- it's not on the unskinned frame but shows up on the skinned one, so hide it
end

function mod:LoadDBMOptions()
	if not E.db.benikui.skins.variousSkins.dbmSkin then return end
	if not BUI:IsAddOnEnabled("DBM-GUI") then return end

	DBM_Options()
end
S:AddCallbackForAddon("DBM-GUI", "BenikUI_DBMOptions", mod.LoadDBMOptions)