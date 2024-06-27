local WEAPON_LANTERN = `weapon_melee_davy_lantern`
local HORSE_LANTERN = {
    category = 0x1530BE1C, -- lantern category (component hash)
    hash = 0x635E387C, -- lantern hash
}

function isLanternOnHorse(horse)
    return IsMetapedUsingComponent(horse, HORSE_LANTERN.category)
end

local function equipLanternOnHorse(horse)
    ApplyShopItemToPed(horse, HORSE_LANTERN.hash, true, true)
    UpdatePedVariation(horse)
end

local function unequipLanternFromHorse(horse)
    RemoveTagFromMetaPed(horse, HORSE_LANTERN.category)
    UpdatePedVariation(horse)
end

function isLanternOnPlayer()
    local playerPed = PlayerPedId()
    local _, weaponHash1 = GetCurrentPedWeapon(playerPed, true, 0, true) -- main weapon slot (aka right hand)
    local _, weaponHash2 = GetCurrentPedWeapon(playerPed, true, 1, true) -- left hand
    local _, weaponHash3 = GetCurrentPedWeapon(playerPed, true, 11, true) -- hidden pocket
    local _, weaponHash4 = GetCurrentPedWeapon(playerPed, true, 12, true) -- belt

    return weaponHash1 == WEAPON_LANTERN 
        or weaponHash2 == WEAPON_LANTERN
        or weaponHash3 == WEAPON_LANTERN
        or weaponHash4 == WEAPON_LANTERN
end

local function equipLanternOnPlayer()
    local attachPoint = 12
    GiveWeaponToPed_2(PlayerPedId(), WEAPON_LANTERN, 0, true, true, 12, false, 0.5, 1.0, 752097756, false, 0, false)
end

local function equipLanternOnPlayerForceInHand()
    local attachPoint = 0
    GiveWeaponToPed_2(PlayerPedId(), WEAPON_LANTERN, 0, true, true, attachPoint, false, 0.5, 1.0, 752097756, false, 0, false)
end

local function unequipLanternFromPlayer()
    RemoveWeaponFromPed(PlayerPedId(), WEAPON_LANTERN, true, 0)
end

local function showNotification(text)
    ToolTip(text, 1500)
    -- BottomCenterNotify(text, 1500)
end

local function getLastPlayerHorse()
    local playerPed = PlayerPedId()
    local horse = GetLastMount(playerPed)
    return horse
end

local lastInteractionAt = GetGameTimer() - Config.InteractionCooldown
local function isCooldownExpired()
    return GetGameTimer() >= lastInteractionAt + Config.InteractionCooldown
end
local function activateCooldown()
    lastInteractionAt = GetGameTimer()
end
local function onHorseLanternInteraction(horse)
    if Config.EnableCooldown then
        if not isCooldownExpired() then
            showNotification(Locales.get('cooldown_active'))
            return
        end
    end

    local horse = horse or getLastPlayerHorse()
    if not DoesEntityExist(horse) then
        showNotification(Locales.get('horse_not_found'))
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local horseCoords = GetEntityCoords(horse)
    if #(horseCoords - playerCoords) > Config.LanternEqupingHorseDistance then
        showNotification(Locales.get('horse_too_far'))
        return
    end

    if isLanternOnHorse(horse) then
        unequipLanternFromHorse(horse)
        if IsPedOnMount(playerPed) then
            equipLanternOnPlayerForceInHand()
        else
            equipLanternOnPlayer()
        end
        showNotification(Locales.get('lantern_unequipped'))
    else
        if not isLanternOnPlayer() then
            showNotification(Locales.get('no_lantern'))
            return
        end
        unequipLanternFromPlayer()
        equipLanternOnHorse(horse)
        showNotification(Locales.get('lantern_equipped'))
    end

    if Config.EnableCooldown then
        activateCooldown()
    end
end

-- Inputs
if Config.EnabledCommands['horselantern'] then
    RegisterCommand('horselantern', function()
        onHorseLanternInteraction()
    end)
end

if Config.EnabledCommands['getlantern'] then
    RegisterCommand('getlantern', function()
        equipLanternOnPlayer()
    end)
end

-- UI Prompt
AddEventHandler('redm-lantern:onInputInteractionUsed', function(horse)
    onHorseLanternInteraction(horse)
end)