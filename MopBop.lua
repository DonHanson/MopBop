-- MopBop - Hunter DPS Optimizer for WoW Classic Mists of Pandaria
-- Analyzes spells, cooldowns, and talents to suggest optimal spell rotation

MopBop = {};
MopBop.fully_loaded = false;
MopBop.version = "1.0";

-- Hunter specializations
MopBop.specs = {
    "Survival",
    "Marksmanship", 
    "Beast Mastery"
};

-- Default configuration
MopBop.default_options = {
    -- UI positioning
    frameRef = "CENTER",
    frameX = 0,
    frameY = 0,
    hide = false,
    
    -- UI sizing
    frameW = 150,
    frameH = 50,
    
    -- Display options
    showCooldowns = true,
    showDamage = true,
    showTalents = true,
    showPetCommands = true,
    
    -- Spec selection
    selectedSpec = "Survival",
    
    -- Colors
    colorReady = {0, 1, 0, 1},      -- Green for ready spells
    colorCooldown = {1, 0.5, 0, 1}, -- Orange for cooldown spells
    colorUnavailable = {0.5, 0.5, 0.5, 1}, -- Gray for unavailable
    colorBackground = {0, 0, 0, 0.8}, -- Semi-transparent black
};

-- Hunter spell database with damage, cooldowns, and talent interactions
MopBop.spells = {
    -- Core abilities
    ["Steady Shot"] = {
        id = 56641,
        damage = 1000,
        castTime = 1.5,
        cooldown = 0,
        focus = 0,
        priority = 1,
        requires = {},
        talents = {},
        notes = "Basic filler shot",
        spec = "All"
    },
    
    ["Arcane Shot"] = {
        id = 3044,
        damage = 1200,
        castTime = 0,
        cooldown = 0,
        focus = 30,
        priority = 2,
        requires = {},
        talents = {"Improved Arcane Shot"},
        notes = "Instant shot, good focus dump",
        spec = "All"
    },
    
    ["Kill Shot"] = {
        id = 53351,
        damage = 2500,
        castTime = 0,
        cooldown = 0,
        focus = 0,
        priority = 10,
        requires = {"target_hp_below_20"},
        talents = {},
        notes = "Execute ability, use below 20% HP",
        spec = "All"
    },
    
    -- Marksmanship abilities
    ["Aimed Shot"] = {
        id = 19434,
        damage = 2000,
        castTime = 2.5,
        cooldown = 0,
        focus = 50,
        priority = 3,
        requires = {},
        talents = {"Improved Aimed Shot", "Careful Aim"},
        notes = "High damage, long cast time",
        spec = "Marksmanship"
    },
    
    ["Chimera Shot"] = {
        id = 53209,
        damage = 1800,
        castTime = 0,
        cooldown = 9,
        focus = 35,
        priority = 4,
        requires = {},
        talents = {"Improved Chimera Shot"},
        notes = "Strong instant shot with cooldown",
        spec = "Marksmanship"
    },
    
    ["Multi-Shot"] = {
        id = 2643,
        damage = 800,
        castTime = 0,
        cooldown = 0,
        focus = 40,
        priority = 5,
        requires = {"multiple_targets"},
        talents = {},
        notes = "AOE ability",
        spec = "Marksmanship"
    },
    
    -- Survival abilities
    ["Explosive Shot"] = {
        id = 53301,
        damage = 1500,
        castTime = 0,
        cooldown = 6,
        focus = 25,
        priority = 6,
        requires = {},
        talents = {"Improved Explosive Shot"},
        notes = "DoT ability with cooldown",
        spec = "Survival"
    },
    
    ["Black Arrow"] = {
        id = 3674,
        damage = 800,
        castTime = 0,
        cooldown = 30,
        focus = 35,
        priority = 7,
        requires = {},
        talents = {},
        notes = "DoT ability, long cooldown",
        spec = "Survival"
    },
    
    -- Beast Mastery abilities
    ["Kill Command"] = {
        id = 34026,
        damage = 1200,
        castTime = 0,
        cooldown = 60,
        focus = 0,
        priority = 8,
        requires = {"pet_alive"},
        talents = {"Improved Kill Command"},
        notes = "Pet damage ability",
        spec = "Beast Mastery"
    },
    
    ["Bestial Wrath"] = {
        id = 19574,
        damage = 0,
        castTime = 0,
        cooldown = 120,
        focus = 0,
        priority = 9,
        requires = {"pet_alive"},
        talents = {},
        notes = "Pet damage buff",
        spec = "Beast Mastery"
    },
    
    -- Utility abilities
    ["Rapid Fire"] = {
        id = 3045,
        damage = 0,
        castTime = 0,
        cooldown = 300,
        focus = 0,
        priority = 11,
        requires = {},
        talents = {},
        notes = "Haste buff",
        spec = "All"
    },
    
    ["Readiness"] = {
        id = 23989,
        damage = 0,
        castTime = 0,
        cooldown = 180,
        focus = 0,
        priority = 12,
        requires = {},
        talents = {},
        notes = "Reset cooldowns",
        spec = "All"
    }
};

-- Talent bonuses
MopBop.talent_bonuses = {
    ["Improved Arcane Shot"] = {damage_multiplier = 1.15},
    ["Improved Aimed Shot"] = {damage_multiplier = 1.1, cast_time_reduction = 0.5},
    ["Careful Aim"] = {damage_multiplier = 1.2},
    ["Improved Chimera Shot"] = {damage_multiplier = 1.1},
    ["Improved Explosive Shot"] = {damage_multiplier = 1.15},
    ["Improved Kill Command"] = {cooldown_reduction = 10}
};

function MopBop.OnReady()
    -- Set up default options
    _G.MopBopPrefs = _G.MopBopPrefs or {};
    
    for k, v in pairs(MopBop.default_options) do
        if (not _G.MopBopPrefs[k]) then
            _G.MopBopPrefs[k] = v;
        end
    end
    
    MopBop.CreateUIFrame();
    MopBop.CreateConfigFrame();
    MopBop.InitializeSpellTracking();
end

function MopBop.OnSaving()
    if (MopBop.UIFrame) then
        local point, relativeTo, relativePoint, xOfs, yOfs = MopBop.UIFrame:GetPoint()
        _G.MopBopPrefs.frameRef = relativePoint;
        _G.MopBopPrefs.frameX = xOfs;
        _G.MopBopPrefs.frameY = yOfs;
    end
end

function MopBop.OnUpdate()
    if (not MopBop.fully_loaded) then
        return;
    end
    
    if (MopBopPrefs.hide) then 
        return;
    end
    
    MopBop.UpdateFrame();
end

function MopBop.OnEvent(frame, event, ...)
    if (event == 'ADDON_LOADED') then
        local name = ...;
        if name == 'MopBop' then
            MopBop.OnReady();
        end
        return;
    end
    
    if (event == 'PLAYER_LOGIN') then
        MopBop.fully_loaded = true;
        return;
    end
    
    if (event == 'PLAYER_LOGOUT') then
        MopBop.OnSaving();
        return;
    end
    
    -- Combat events
    if (event == 'COMBAT_LOG_EVENT_UNFILTERED') then
        MopBop.HandleCombatEvent(...);
        return;
    end
    
    -- Spell events
    if (event == 'UNIT_SPELLCAST_SUCCEEDED') then
        local unit, _, spellId = ...;
        if unit == "player" then
            MopBop.HandleSpellCast(spellId);
        end
        return;
    end
end

function MopBop.InitializeSpellTracking()
    MopBop.spell_cooldowns = {};
    MopBop.last_cast_time = {};
    MopBop.player_focus = 0;
    MopBop.target_hp = 100;
    MopBop.pet_alive = true;
    MopBop.multiple_targets = false;
    
    -- Register for combat events
    MopBop.EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    MopBop.EventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    MopBop.EventFrame:RegisterEvent("UNIT_POWER_UPDATE");
    MopBop.EventFrame:RegisterEvent("UNIT_HEALTH");
    MopBop.EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
end

function MopBop.HandleCombatEvent(...)
    local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = ...;
    
    if sourceGUID == UnitGUID("player") then
        -- Player cast a spell
        if event == "SPELL_CAST_SUCCESS" then
            MopBop.HandleSpellCast(spellId);
        end
    end
    
    if destGUID == UnitGUID("target") then
        -- Target took damage
        if event == "SPELL_DAMAGE" or event == "RANGE_DAMAGE" then
            MopBop.UpdateTargetHealth();
        end
    end
end

function MopBop.HandleSpellCast(spellId)
    for spellName, spellData in pairs(MopBop.spells) do
        if spellData.id == spellId then
            MopBop.spell_cooldowns[spellName] = GetTime() + spellData.cooldown;
            MopBop.last_cast_time[spellName] = GetTime();
            break;
        end
    end
end

function MopBop.UpdateTargetHealth()
    if UnitExists("target") then
        local health = UnitHealth("target");
        local maxHealth = UnitHealthMax("target");
        MopBop.target_hp = (health / maxHealth) * 100;
    end
end

function MopBop.GetSpellPriority(spellName, spellData)
    local priority = spellData.priority;
    
    -- Check if spell is available for current spec
    if spellData.spec ~= "All" and spellData.spec ~= _G.MopBopPrefs.selectedSpec then
        return -1; -- Not available for current spec
    end
    
    -- Check if spell is available
    if not MopBop.IsSpellAvailable(spellName, spellData) then
        return -1; -- Not available
    end
    
    -- Apply talent bonuses
    local damage_multiplier = 1.0;
    local cooldown_reduction = 0;
    
    for talentName, bonus in pairs(MopBop.talent_bonuses) do
        if MopBop.HasTalent(talentName) then
            if bonus.damage_multiplier then
                damage_multiplier = damage_multiplier * bonus.damage_multiplier;
            end
            if bonus.cooldown_reduction then
                cooldown_reduction = cooldown_reduction + bonus.cooldown_reduction;
            end
        end
    end
    
    -- Calculate effective damage
    local effective_damage = spellData.damage * damage_multiplier;
    
    -- Adjust priority based on conditions
    if spellName == "Kill Shot" and MopBop.target_hp > 20 then
        priority = priority - 5; -- Lower priority if target not in execute range
    end
    
    if spellName == "Multi-Shot" and not MopBop.multiple_targets then
        priority = priority - 3; -- Lower priority for single target
    end
    
    -- Consider focus cost
    if MopBop.player_focus < spellData.focus then
        priority = priority - 2; -- Lower priority if not enough focus
    end
    
    return priority, effective_damage;
end

function MopBop.IsSpellAvailable(spellName, spellData)
    -- Check if spell is on cooldown
    if MopBop.spell_cooldowns[spellName] and GetTime() < MopBop.spell_cooldowns[spellName] then
        return false;
    end
    
    -- Check focus requirement
    if MopBop.player_focus < spellData.focus then
        return false;
    end
    
    -- Check special requirements
    for _, requirement in pairs(spellData.requires) do
        if requirement == "target_hp_below_20" and MopBop.target_hp > 20 then
            return false;
        elseif requirement == "pet_alive" and not MopBop.pet_alive then
            return false;
        elseif requirement == "multiple_targets" and not MopBop.multiple_targets then
            return false;
        end
    end
    
    return true;
end

function MopBop.HasTalent(talentName)
    -- Simplified talent checking - in a real implementation, you'd parse talent trees
    -- For now, return true for common talents
    return true;
end

function MopBop.GetOptimalSpells()
    local available_spells = {};
    
    for spellName, spellData in pairs(MopBop.spells) do
        local priority, effective_damage = MopBop.GetSpellPriority(spellName, spellData);
        if priority > 0 then
            table.insert(available_spells, {
                name = spellName,
                priority = priority,
                damage = effective_damage,
                cooldown = spellData.cooldown,
                focus = spellData.focus,
                notes = spellData.notes,
                id = spellData.id
            });
        end
    end
    
    -- Sort by priority (highest first)
    table.sort(available_spells, function(a, b) return a.priority > b.priority; end);
    
    -- Return top 3 spells
    return {available_spells[1], available_spells[2], available_spells[3]};
end

function MopBop.CreateUIFrame()
    -- Create the main frame
    MopBop.UIFrame = CreateFrame("Frame", nil, UIParent);
    MopBop.UIFrame:SetFrameStrata("MEDIUM");
    MopBop.UIFrame:SetWidth(_G.MopBopPrefs.frameW);
    MopBop.UIFrame:SetHeight(_G.MopBopPrefs.frameH);
    
    -- Background - make it more transparent to match the image
    MopBop.UIFrame.texture = MopBop.UIFrame:CreateTexture();
    MopBop.UIFrame.texture:SetAllPoints(MopBop.UIFrame);
    MopBop.UIFrame.texture:SetTexture(0, 0, 0, 0.3); -- More transparent background
    
    -- Remove border for cleaner look
    -- MopBop.UIFrame.border = MopBop.UIFrame:CreateTexture();
    -- MopBop.UIFrame.border:SetPoint("TOPLEFT", -1, 1);
    -- MopBop.UIFrame.border:SetPoint("BOTTOMRIGHT", 1, -1);
    -- MopBop.UIFrame.border:SetTexture(1, 1, 1, 0.3);
    
    -- Position
    MopBop.UIFrame:SetPoint(_G.MopBopPrefs.frameRef, _G.MopBopPrefs.frameX, _G.MopBopPrefs.frameY);
    
    -- Make draggable
    MopBop.UIFrame:SetMovable(true);
    MopBop.UIFrame:EnableMouse(true);
    
    -- Cover button for dragging
    MopBop.Cover = CreateFrame("Button", nil, MopBop.UIFrame);
    MopBop.Cover:SetFrameLevel(128);
    MopBop.Cover:SetPoint("TOPLEFT", 0, 0);
    MopBop.Cover:SetWidth(_G.MopBopPrefs.frameW);
    MopBop.Cover:SetHeight(_G.MopBopPrefs.frameH);
    MopBop.Cover:EnableMouse(true);
    MopBop.Cover:RegisterForClicks("AnyUp");
    MopBop.Cover:RegisterForDrag("LeftButton");
    MopBop.Cover:SetScript("OnDragStart", MopBop.OnDragStart);
    MopBop.Cover:SetScript("OnDragStop", MopBop.OnDragStop);
    MopBop.Cover:SetScript("OnClick", MopBop.OnClick);
    
    -- Remove title for cleaner look
    -- MopBop.Title = MopBop.Cover:CreateFontString(nil, "OVERLAY");
    -- MopBop.Title:SetPoint("TOP", MopBop.UIFrame, "TOP", 0, -5);
    -- MopBop.Title:SetFont([[Fonts\FRIZQT__.TTF]], 12, "OUTLINE");
    -- MopBop.Title:SetText("Hunter DPS Optimizer");
    -- MopBop.Title:SetTextColor(1, 1, 1, 1);
    
    -- Spell icon containers - center them vertically and horizontally
    MopBop.SpellIcons = {};
    local iconSize = 40;
    local spacing = 10;
    local totalWidth = (iconSize * 3) + (spacing * 2);
    local startX = (_G.MopBopPrefs.frameW - totalWidth) / 2;
    local startY = (_G.MopBopPrefs.frameH - iconSize) / 2; -- Center vertically
    
    for i = 1, 3 do
        -- Create icon frame
        MopBop.SpellIcons[i] = CreateFrame("Button", nil, MopBop.Cover);
        MopBop.SpellIcons[i]:SetSize(iconSize, iconSize);
        MopBop.SpellIcons[i]:SetPoint("CENTER", MopBop.UIFrame, "CENTER", startX + (i-1)*(iconSize + spacing) - totalWidth/2 + iconSize/2, 0);
        
        -- Icon texture
        MopBop.SpellIcons[i].icon = MopBop.SpellIcons[i]:CreateTexture(nil, "ARTWORK");
        MopBop.SpellIcons[i].icon:SetAllPoints();
        MopBop.SpellIcons[i].icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);
        
        -- Cooldown frame
        MopBop.SpellIcons[i].cooldown = CreateFrame("Cooldown", nil, MopBop.SpellIcons[i], "CooldownFrameTemplate");
        MopBop.SpellIcons[i].cooldown:SetAllPoints();
        
        -- Border - make it more subtle like in the image
        MopBop.SpellIcons[i].border = MopBop.SpellIcons[i]:CreateTexture(nil, "OVERLAY");
        MopBop.SpellIcons[i].border:SetPoint("TOPLEFT", -1, 1);
        MopBop.SpellIcons[i].border:SetPoint("BOTTOMRIGHT", 1, -1);
        MopBop.SpellIcons[i].border:SetTexture(1, 1, 1, 0.6); -- More subtle border
        
        -- Remove number labels for cleaner look
        -- MopBop.SpellIcons[i].number = MopBop.SpellIcons[i]:CreateFontString(nil, "OVERLAY");
        -- MopBop.SpellIcons[i].number:SetPoint("TOPLEFT", 2, -2);
        -- MopBop.SpellIcons[i].number:SetFont([[Fonts\FRIZQT__.TTF]], 10, "OUTLINE");
        -- MopBop.SpellIcons[i].number:SetText(tostring(i));
        -- MopBop.SpellIcons[i].number:SetTextColor(1, 1, 1, 1);
        
        -- Tooltip
        MopBop.SpellIcons[i]:SetScript("OnEnter", function(self)
            if self.spellName then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                GameTooltip:SetSpellByID(self.spellId);
                GameTooltip:Show();
            end
        end);
        
        MopBop.SpellIcons[i]:SetScript("OnLeave", function(self)
            GameTooltip:Hide();
        end);
    end
    
    -- Remove status info for cleaner look
    -- MopBop.StatusLabel = MopBop.Cover:CreateFontString(nil, "OVERLAY");
    -- MopBop.StatusLabel:SetPoint("BOTTOM", MopBop.UIFrame, "BOTTOM", 0, 5);
    -- MopBop.StatusLabel:SetFont([[Fonts\FRIZQT__.TTF]], 10, "OUTLINE");
    -- MopBop.StatusLabel:SetText("");
    -- MopBop.StatusLabel:SetTextColor(0.8, 0.8, 0.8, 1);
end

function MopBop.CreateConfigFrame()
    -- Create configuration frame
    MopBop.ConfigFrame = CreateFrame("Frame", "MopBopConfigFrame", UIParent, "BasicFrameTemplateWithInset");
    MopBop.ConfigFrame:SetSize(300, 200);
    MopBop.ConfigFrame:SetPoint("CENTER");
    MopBop.ConfigFrame:SetMovable(true);
    MopBop.ConfigFrame:EnableMouse(true);
    MopBop.ConfigFrame:RegisterForDrag("LeftButton");
    MopBop.ConfigFrame:SetScript("OnDragStart", MopBop.ConfigFrame.StartMoving);
    MopBop.ConfigFrame:SetScript("OnDragStop", MopBop.ConfigFrame.StopMovingOrSizing);
    MopBop.ConfigFrame:Hide();
    
    -- Title
    MopBop.ConfigFrame.title = MopBop.ConfigFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    MopBop.ConfigFrame.title:SetPoint("TOP", MopBop.ConfigFrame, "TOP", 0, -5);
    MopBop.ConfigFrame.title:SetText("MopBop Configuration");
    
    -- Spec selection label
    MopBop.ConfigFrame.specLabel = MopBop.ConfigFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    MopBop.ConfigFrame.specLabel:SetPoint("TOPLEFT", MopBop.ConfigFrame, "TOPLEFT", 20, -40);
    MopBop.ConfigFrame.specLabel:SetText("Hunter Specialization:");
    
    -- Spec dropdown
    MopBop.ConfigFrame.specDropdown = CreateFrame("Frame", "MopBopSpecDropdown", MopBop.ConfigFrame, "UIDropDownMenuTemplate");
    MopBop.ConfigFrame.specDropdown:SetPoint("TOPLEFT", MopBop.ConfigFrame.specLabel, "BOTTOMLEFT", -20, -5);
    
    UIDropDownMenu_SetWidth(MopBop.ConfigFrame.specDropdown, 150);
    UIDropDownMenu_Initialize(MopBop.ConfigFrame.specDropdown, MopBop.InitializeSpecDropdown);
    
    -- Close button
    MopBop.ConfigFrame.closeButton = CreateFrame("Button", nil, MopBop.ConfigFrame, "GameMenuButtonTemplate");
    MopBop.ConfigFrame.closeButton:SetSize(80, 25);
    MopBop.ConfigFrame.closeButton:SetPoint("BOTTOM", MopBop.ConfigFrame, "BOTTOM", 0, 15);
    MopBop.ConfigFrame.closeButton:SetText("Close");
    MopBop.ConfigFrame.closeButton:SetScript("OnClick", function()
        MopBop.ConfigFrame:Hide();
    end);
end

function MopBop.InitializeSpecDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo();
    
    for i, spec in ipairs(MopBop.specs) do
        info.text = spec;
        info.value = spec;
        info.func = MopBop.OnSpecSelected;
        info.checked = (_G.MopBopPrefs.selectedSpec == spec);
        UIDropDownMenu_AddButton(info);
    end
end

function MopBop.OnSpecSelected(self, arg1, arg2, checked)
    _G.MopBopPrefs.selectedSpec = self.value;
    UIDropDownMenu_SetSelectedValue(MopBop.ConfigFrame.specDropdown, self.value);
    UIDropDownMenu_SetText(MopBop.ConfigFrame.specDropdown, self.value);
end

function MopBop.OnDragStart(frame)
    MopBop.UIFrame:StartMoving();
    MopBop.UIFrame.isMoving = true;
    GameTooltip:Hide();
end

function MopBop.OnDragStop(frame)
    MopBop.UIFrame:StopMovingOrSizing();
    MopBop.UIFrame.isMoving = false;
end

function MopBop.OnClick(self, button)
    if (button == "RightButton") then
        MopBop.ToggleOptions();
    end
end

function MopBop.ToggleOptions()
    -- Simple options toggle
    if MopBopPrefs.hide then
        MopBopPrefs.hide = false;
        MopBop.UIFrame:Show();
    else
        MopBopPrefs.hide = true;
        MopBop.UIFrame:Hide();
    end
end

function MopBop.UpdateFrame()
    -- Update player focus
    MopBop.player_focus = UnitPower("player", 2); -- Focus is power type 2
    
    -- Update target health
    MopBop.UpdateTargetHealth();
    
    -- Update pet status
    MopBop.pet_alive = UnitExists("pet");
    
    -- Get optimal spells
    local optimal_spells = MopBop.GetOptimalSpells();
    
    -- Update spell icons
    for i = 1, 3 do
        if optimal_spells[i] then
            local spell = optimal_spells[i];
            local spellData = MopBop.spells[spell.name];
            
            -- Set icon texture
            local icon = GetSpellTexture(spell.id);
            MopBop.SpellIcons[i].icon:SetTexture(icon);
            
            -- Set spell info for tooltip
            MopBop.SpellIcons[i].spellName = spell.name;
            MopBop.SpellIcons[i].spellId = spell.id;
            
            -- Set cooldown
            if spellData.cooldown > 0 and MopBop.spell_cooldowns[spell.name] then
                local start, duration = MopBop.spell_cooldowns[spell.name] - spellData.cooldown, spellData.cooldown;
                MopBop.SpellIcons[i].cooldown:SetCooldown(start, duration);
            else
                MopBop.SpellIcons[i].cooldown:Hide();
            end
            
            -- Set border color based on availability
            local color = MopBop.GetSpellColor(spell.name);
            MopBop.SpellIcons[i].border:SetVertexColor(unpack(color));
            
            -- Show the icon
            MopBop.SpellIcons[i]:Show();
        else
            -- Hide the icon if no spell
            MopBop.SpellIcons[i]:Hide();
        end
    end
    
    -- Update status
    local status_text = string.format("Focus: %d | Target HP: %.1f%% | Spec: %s", 
        MopBop.player_focus, MopBop.target_hp, _G.MopBopPrefs.selectedSpec);
    
    if not MopBop.pet_alive then
        status_text = status_text .. " | Pet: Dead";
    end
    
    -- MopBop.StatusLabel:SetText(status_text); -- Removed status label
end

function MopBop.GetSpellColor(spellName)
    local spellData = MopBop.spells[spellName];
    if not spellData then
        return _G.MopBopPrefs.colorUnavailable;
    end
    
    if MopBop.IsSpellAvailable(spellName, spellData) then
        return _G.MopBopPrefs.colorReady;
    else
        return _G.MopBopPrefs.colorCooldown;
    end
end

-- Event frame setup
MopBop.EventFrame = CreateFrame("Frame");
MopBop.EventFrame:Show();
MopBop.EventFrame:SetScript("OnEvent", MopBop.OnEvent);
MopBop.EventFrame:SetScript("OnUpdate", MopBop.OnUpdate);
MopBop.EventFrame:RegisterEvent("ADDON_LOADED");
MopBop.EventFrame:RegisterEvent("PLAYER_LOGIN");
MopBop.EventFrame:RegisterEvent("PLAYER_LOGOUT");
MopBop.EventFrame:RegisterEvent("UNIT_POWER_UPDATE");
MopBop.EventFrame:RegisterEvent("UNIT_HEALTH");
MopBop.EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED");

-- Slash commands
SLASH_MOPBOP1 = "/mopbop";
SLASH_MOPBOP2 = "/hunterdps";

SlashCmdList["MOPBOP"] = function(msg)
    if msg == "hide" then
        MopBopPrefs.hide = true;
        MopBop.UIFrame:Hide();
    elseif msg == "show" then
        MopBopPrefs.hide = false;
        MopBop.UIFrame:Show();
    elseif msg == "config" then
        MopBop.ConfigFrame:Show();
        UIDropDownMenu_SetSelectedValue(MopBop.ConfigFrame.specDropdown, _G.MopBopPrefs.selectedSpec);
        UIDropDownMenu_SetText(MopBop.ConfigFrame.specDropdown, _G.MopBopPrefs.selectedSpec);
    elseif msg == "reset" then
        MopBop.UIFrame:SetPoint("CENTER", 0, 0);
    else
        print("MopBop - Hunter DPS Optimizer");
        print("/mopbop hide - Hide the addon");
        print("/mopbop show - Show the addon");
        print("/mopbop config - Open configuration");
        print("/mopbop reset - Reset position");
    end
end;
