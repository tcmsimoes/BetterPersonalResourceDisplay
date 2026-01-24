local function ApplyStyle(bar, border)
    bar:SetStatusBarTexture("UI-HUD-CoolDownManager-Bar")
    local bg = bar:CreateTexture(nil, "BACKGROUND", nil, -8)
    bg:SetAtlas("UI-HUD-CoolDownManager-Bar-BG")
    bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -3, 3)
    bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 7, -7)
    border:Hide()
end

PersonalResourceDisplayFrame.HealthBarsContainer:SetHeight(25)
PersonalResourceDisplayFrame:SetScale(0.75)
hooksecurefunc(PersonalResourceDisplayFrame, "SetupAlternatePowerBar", function(self)
    local prdHealthBar = self.HealthBarsContainer.healthBar
    local prdPowerBar = self.PowerBar

    -- apply the bar style
    ApplyStyle(prdHealthBar, self.HealthBarsContainer.border)
    ApplyStyle(prdPowerBar, prdPowerBar.Border)

    -- apply the player class color
    local localizedClass, englishClass = UnitClass("player")
        local classColor = RAID_CLASS_COLORS[englishClass]
    prdHealthBar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
end)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

local function ApplyFading()
    local prd = PersonalResourceDisplayFrame
    local debuffs = DebuffFrame
    local cdbuffs = BuffIconCooldownViewer

    if not prd then
        print("no PersonalResourceDisplayFrame")
        return
    elseif not debuffs then
        print("no DebuffFrame")
        return
    elseif not cdbuffs then
        print("no BuffIconCooldownViewer")
        return
    end

    if UnitAffectingCombat("player") then
        -- Fade to 100% opacity over 0.2 seconds
        UIFrameFadeIn(prd, 0.2, prd:GetAlpha(), 1)
        UIFrameFadeIn(debuffs, 0.2, debuffs:GetAlpha(), 1)
        UIFrameFadeIn(cdbuffs, 0.2, cdbuffs:GetAlpha(), 1)
    else
        -- Fade to 10% opacity over 0.2 seconds
        UIFrameFadeOut(prd, 0.2, prd:GetAlpha(), 0.05)
        UIFrameFadeOut(debuffs, 0.2, debuffs:GetAlpha(), 0.1)
        UIFrameFadeOut(cdbuffs, 0.2, cdbuffs:GetAlpha(), 0.1)
    end
end

f:SetScript("OnEvent", function(self, event)
    -- Small delay to ensure frames exists
    C_Timer.After(0.1, ApplyFading)
end)