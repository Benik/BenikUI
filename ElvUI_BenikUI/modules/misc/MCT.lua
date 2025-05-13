--[[
    M's Cursor Tracker (MCT)
    Tracks the cursor whenever it becomes invisible (left-click looking or right-click turning).
    The arrow's orientation can point inwards (toward center), outwards (away from center), or fixed in one direction.
    "Lock Ratio" enforces a square arrow by using a single size slider.
--]]

local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('MCT')

local atan2 = math.atan2
local pi    = math.pi

-- Called by the BenikUI core to set up this module
function mod:Initialize()
    mod:ApplyDefaults()

    -- If the user has disabled this module, just return
    if E.db.benikui.misc.mct.enable == false then return end

    -- Create the main tracking frame and texture
    mod.frame = CreateFrame("Frame", "BUI_MCTFrame", UIParent)
    mod.frame.texture = mod.frame:CreateTexture(nil, "OVERLAY")
    mod.frame.texture:SetAllPoints()
    mod.frame.texture:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\arrowOutlined.tga')

    mod.frame:Hide()

    -- Track states for looking (left mouse) and turning (right mouse)
    mod.looking = false
    mod.turning = false

    -- Register relevant events
    mod:RegisterEvent("PLAYER_STARTED_LOOKING", "OnMouseLookStart")
    mod:RegisterEvent("PLAYER_STARTED_TURNING", "OnMouseLookStart")
    mod:RegisterEvent("PLAYER_STOPPED_LOOKING", "OnMouseLookStop")
    mod:RegisterEvent("PLAYER_STOPPED_TURNING", "OnMouseLookStop")

    mod:UpdateSettings()
end

--[[
Populates or validates the saved variables with defaults, ensuring
everything is initialized correctly even if the user doesn't have them in the config.
]]
function mod:ApplyDefaults()
    if E.db.benikui.misc.mct == nil then
        E.db.benikui.misc.mct = {}
    end

    local db = E.db.benikui.misc.mct
    if db.enable == nil then db.enable = false end
    if db.width == nil then db.width = 15 end
    if db.height == nil then db.height = 15 end
    if db.strata == nil then db.strata = "HIGH" end
    if db.level == nil then db.level = 10 end
    if db.color == nil then db.color = {r=1, g=1, b=1, a=1} end
    if db.inwardsRotation == nil then db.inwardsRotation = true end
    if db.outwardsRotation == nil then db.outwardsRotation = false end
    if db.direction == nil then db.direction = "Down" end
    if db.lockRatio == nil then db.lockRatio = true end
    if db.size == nil then db.size = 15 end
end

-- Applies the current database settings to the in-game tracker frame
function mod:UpdateSettings()
    local db = E.db.benikui.misc.mct
    mod.db = db

    -- Disable completely if 'enable' is false
    if not db.enable then
        mod:UnregisterAllEvents()
        mod.frame:Hide()
        return
    else
        -- Re-register events in case we previously unregistered
        mod:RegisterEvent("PLAYER_STARTED_LOOKING", "OnMouseLookStart")
        mod:RegisterEvent("PLAYER_STARTED_TURNING", "OnMouseLookStart")
        mod:RegisterEvent("PLAYER_STOPPED_LOOKING", "OnMouseLookStop")
        mod:RegisterEvent("PLAYER_STOPPED_TURNING", "OnMouseLookStop")
    end

    -- Adjust size based on lockRatio
    if db.lockRatio then
        mod.frame:SetSize(db.size, db.size)
    else
        mod.frame:SetSize(db.width, db.height)
    end

    mod.frame:SetFrameStrata(db.strata)
    mod.frame:SetFrameLevel(db.level)

    -- Update arrow color
    local c = db.color
    mod.frame.texture:SetVertexColor(c.r, c.g, c.b, c.a)

    -- If the cursor is not currently hidden, keep the arrow hidden
    if not mod.looking and not mod.turning then
        mod.frame:Hide()
    end
end

-- Called whenever the game hides the cursor (e.g., the player starts looking or turning)
function mod:OnMouseLookStart(event)
    if event == "PLAYER_STARTED_LOOKING" then
        mod.looking = true
    elseif event == "PLAYER_STARTED_TURNING" then
        mod.turning = true
    end
    mod:ShowArrowAtCursor()
end

-- Called when the cursor reappears
function mod:OnMouseLookStop(event)
    if event == "PLAYER_STOPPED_LOOKING" then
        mod.looking = false
    elseif event == "PLAYER_STOPPED_TURNING" then
        mod.turning = false
    end

    -- Hide the frame only if both looking and turning are false
    if not mod.looking and not mod.turning then
        mod.frame:Hide()
    end
end

-- Positions (and possibly rotates) the arrow so its tip is at the cursor's last known position
function mod:ShowArrowAtCursor()
    local db = mod.db
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()
    x, y = x / scale, y / scale

    -- Half the arrow's height, used for tip offset
    local hHalf
    if db.lockRatio then
        hHalf = E:Scale(db.size) / 2
    else
        hHalf = E:Scale(db.height) / 2
    end

    if db.inwardsRotation then
        -- Inwards: arrow points away from center
        local centerX = UIParent:GetWidth() / 2
        local centerY = UIParent:GetHeight() / 2
        local dx = x - centerX
        local dy = y - centerY
        local angle = atan2(dy, dx)
        local arrowAngle = angle - (pi / 2)
        mod.frame.texture:SetRotation(arrowAngle)

        -- Move arrow tip to the cursor
        local offsetX = hHalf * math.sin(arrowAngle)
        local offsetY = hHalf * math.cos(arrowAngle)
        x = x - offsetX
        y = y + offsetY

    elseif db.outwardsRotation then
        -- Outwards: arrow points toward center
        local centerX = UIParent:GetWidth() / 2
        local centerY = UIParent:GetHeight() / 2
        local dx = centerX - x
        local dy = centerY - y
        local angle = atan2(dy, dx)
        local arrowAngle = angle - (pi / 2)
        mod.frame.texture:SetRotation(arrowAngle)

        -- Move arrow tip to the cursor
        local offsetX = hHalf * math.sin(arrowAngle)
        local offsetY = hHalf * math.cos(arrowAngle)
        x = x - offsetX
        y = y + offsetY

    else
        -- No rotation toggles => fixed direction
        local wHalf = db.lockRatio and (E:Scale(db.size) / 2) or (E:Scale(db.width) / 2)

        -- Default arrow is down at rotation=0
        if db.direction == "Down" then
            y = y + hHalf
            mod.frame.texture:SetRotation(0)

        elseif db.direction == "Up" then
            y = y - hHalf
            mod.frame.texture:SetRotation(pi)

        elseif db.direction == "Left" then
            x = x + wHalf
            mod.frame.texture:SetRotation(-pi/2)

        elseif db.direction == "Right" then
            x = x - wHalf
            mod.frame.texture:SetRotation(pi/2)
        end
    end

    mod.frame:ClearAllPoints()
    mod.frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
    mod.frame:Show()
end

BUI:RegisterModule(mod:GetName())
