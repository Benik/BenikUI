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
    self.frame = CreateFrame("Frame", "BUI_MCTFrame", UIParent)
    self.frame.texture = self.frame:CreateTexture(nil, "OVERLAY")
    self.frame.texture:SetAllPoints()
    self.frame.texture:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\arrowOutlined.tga')

    self.frame:Hide()

    -- Track states for looking (left mouse) and turning (right mouse)
    self.looking = false
    self.turning = false

    -- Register relevant events
    self:RegisterEvent("PLAYER_STARTED_LOOKING", "OnMouseLookStart")
    self:RegisterEvent("PLAYER_STARTED_TURNING", "OnMouseLookStart")
    self:RegisterEvent("PLAYER_STOPPED_LOOKING", "OnMouseLookStop")
    self:RegisterEvent("PLAYER_STOPPED_TURNING", "OnMouseLookStop")

    self:UpdateSettings()
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
    self.db = db

    -- Disable completely if 'enable' is false
    if not db.enable then
        self:UnregisterAllEvents()
        self.frame:Hide()
        return
    else
        -- Re-register events in case we previously unregistered
        self:RegisterEvent("PLAYER_STARTED_LOOKING", "OnMouseLookStart")
        self:RegisterEvent("PLAYER_STARTED_TURNING", "OnMouseLookStart")
        self:RegisterEvent("PLAYER_STOPPED_LOOKING", "OnMouseLookStop")
        self:RegisterEvent("PLAYER_STOPPED_TURNING", "OnMouseLookStop")
    end

    -- Adjust size based on lockRatio
    if db.lockRatio then
        self.frame:SetSize(db.size, db.size)
    else
        self.frame:SetSize(db.width, db.height)
    end

    self.frame:SetFrameStrata(db.strata)
    self.frame:SetFrameLevel(db.level)

    -- Update arrow color
    local c = db.color
    self.frame.texture:SetVertexColor(c.r, c.g, c.b, c.a)

    -- If the cursor is not currently hidden, keep the arrow hidden
    if not self.looking and not self.turning then
        self.frame:Hide()
    end
end

-- Called whenever the game hides the cursor (e.g., the player starts looking or turning)
function mod:OnMouseLookStart(event)
    if event == "PLAYER_STARTED_LOOKING" then
        self.looking = true
    elseif event == "PLAYER_STARTED_TURNING" then
        self.turning = true
    end
    self:ShowArrowAtCursor()
end

-- Called when the cursor reappears
function mod:OnMouseLookStop(event)
    if event == "PLAYER_STOPPED_LOOKING" then
        self.looking = false
    elseif event == "PLAYER_STOPPED_TURNING" then
        self.turning = false
    end

    -- Hide the frame only if both looking and turning are false
    if not self.looking and not self.turning then
        self.frame:Hide()
    end
end

-- Positions (and possibly rotates) the arrow so its tip is at the cursor's last known position
function mod:ShowArrowAtCursor()
    local db = self.db
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
        self.frame.texture:SetRotation(arrowAngle)

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
        self.frame.texture:SetRotation(arrowAngle)

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
            self.frame.texture:SetRotation(0)

        elseif db.direction == "Up" then
            y = y - hHalf
            self.frame.texture:SetRotation(pi)

        elseif db.direction == "Left" then
            x = x + wHalf
            self.frame.texture:SetRotation(-pi/2)

        elseif db.direction == "Right" then
            x = x - wHalf
            self.frame.texture:SetRotation(pi/2)
        end
    end

    self.frame:ClearAllPoints()
    self.frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
    self.frame:Show()
end

BUI:RegisterModule(mod:GetName())
