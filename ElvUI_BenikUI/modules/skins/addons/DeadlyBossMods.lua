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

					local frameName = bar.frame:GetName()
					if not frameName then return end

					local spark = _G[frameName.."BarSpark"]
					if spark then
						local baseHeight = bar.enlarged and DBT.Options.HugeHeight or DBT.Options.Height
						spark:Size(12, ((baseHeight / 2) * 3) - 2)
					end
				end)

				local function ApplySkin()
					if _G.DBM_UsedProfile ~= requiredProfile then return end

					local frame = bar.frame
					local frameName = frame:GetName()
					if not frameName then return end

					local isSecret = bar.isSecret
					local tbar = _G[frameName..'Bar']
					local icon1 = _G[frameName..'BarIcon1']
					local icon2 = _G[frameName..'BarIcon2']
					local jIcons = isSecret and _G[frameName.."BarSJIcons"] or _G[frameName.."BarIJIcons"]
					local jIcons2 = isSecret and _G[frameName.."BarSJIcons2"] or _G[frameName.."BarIJIcons2"]
					local jIcons3 = isSecret and _G[frameName.."BarSJIcons3"] or _G[frameName.."BarIJIcons3"]
					local jIcons4 = isSecret and _G[frameName.."BarSJIcons4"] or _G[frameName.."BarIJIcons4"]
					local name = _G[frameName..'BarName']
					local timer = _G[frameName..'BarTimer']
					local iconSize = bar.enlarged and DBT.Options.HugeHeight or DBT.Options.Height

					if E.db.benikui.skins.variousSkins.dbmHalfBar then
						frame:Height(iconSize / 2)
					else
						frame:Height(iconSize)
					end

					if not frame.backdrop then
						frame:CreateBackdrop("Transparent")

						if tbar then tbar:SetInside(frame.backdrop) end
						if icon1 then S:HandleIcon(icon1, true) end
						if icon2 then S:HandleIcon(icon2, true) end

						if E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
							frame.backdrop:CreateSoftShadow()
							if icon1 and icon1.backdrop then icon1.backdrop:CreateSoftShadow() end
							if icon2 and icon2.backdrop then icon2.backdrop:CreateSoftShadow() end
						end
					end

					if icon1 then
						icon1:ClearAllPoints()
						icon1:Point('BOTTOMRIGHT', frame, 'BOTTOMLEFT', -4, 0)
						icon1:Size(iconSize, iconSize)
						icon1.backdrop:SetShown(DBT.Options.IconLeft)
					end

					if icon2 then
						icon2:ClearAllPoints()
						icon2:Point('BOTTOMLEFT', frame, 'BOTTOMRIGHT', 4, 0)
						icon2:Size(iconSize, iconSize)
						icon2.backdrop:SetShown(DBT.Options.IconRight)
					end

					if jIcons then jIcons:Size(iconSize, iconSize) end
					if jIcons2 then jIcons2:Size(iconSize, iconSize) end
					if jIcons3 then jIcons3:Size(iconSize, iconSize) end
					if jIcons4 then jIcons4:Size(iconSize, iconSize) end

					if name then
						name:ClearAllPoints()
						name:SetJustifyH('LEFT')
						if E.db.benikui.skins.variousSkins.dbmHalfBar then
							name:Point('BOTTOMLEFT', frame, 'TOPLEFT', 0, 3)
						else
							name:Point('LEFT', frame, 'LEFT', 4, 0)
						end
					end

					if timer then
						timer:ClearAllPoints()
						timer:SetJustifyH('RIGHT')
						if E.db.benikui.skins.variousSkins.dbmHalfBar then
							timer:Point('BOTTOMRIGHT', frame, 'TOPRIGHT', -1, 3)
						else
							timer:Point('RIGHT', frame, 'RIGHT', -4, 0)
						end
					end
				end

				hooksecurefunc(bar, "ApplyStyle", ApplySkin)

				ApplySkin()

				bar.injected = true
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
	S:HandleCloseButton(_G.DBM_GUI_OptionsFrameClosePanelButton)
end

function mod:LoadDBMOptions()
	if not E.db.benikui.skins.variousSkins.dbmSkin then return end
	if not BUI:IsAddOnEnabled("DBM-GUI") then return end

	DBM_Options()
end
S:AddCallbackForAddon("DBM-GUI", "BenikUI_DBMOptions", mod.LoadDBMOptions)