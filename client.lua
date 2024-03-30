local WEAPON_LANTERN = 1247405313

function ApplyShopItemToPed(ped, shopItemHash, immediately, isMultiplayer)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, shopItemHash, immediately, isMultiplayer, false)
end

function UpdatePedVariation(ped)
    Citizen.InvokeNative(0xAAB86462966168CE, ped, true) -- UNKNOWN "Fixes outfit"- always paired with _UPDATE_PED_VARIATION
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false) -- _UPDATE_PED_VARIATION
end

function equip(currentMount, hash)
    ApplyShopItemToPed(currentMount, hash, true, true)
    UpdatePedVariation(currentMount)
end

function unequip(currentMount, category)
    Citizen.InvokeNative(0xD710A5007C2AC539, currentMount, category, 0)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, currentMount,  0, 1, 1, 1, 0)
end

function hasLanternInHands(playerPed)
    local _, weaponHash1 = GetCurrentPedWeapon(PlayerPedId(), true, 0, true) -- main weapon slot (aka right hand)
    local _, weaponHash2 = GetCurrentPedWeapon(PlayerPedId(), true, 1, true) -- left hand
    local _, weaponHash3 = GetCurrentPedWeapon(PlayerPedId(), true, 11, true) -- hidden pocket
    local _, weaponHash4 = GetCurrentPedWeapon(PlayerPedId(), true, 12, true) -- belt

    return weaponHash1 == WEAPON_LANTERN 
        or weaponHash2 == WEAPON_LANTERN
        or weaponHash3 == WEAPON_LANTERN
        or weaponHash4 == WEAPON_LANTERN
end

RegisterCommand('horselantern', function()
    local horseentity = GetMount(PlayerPedId())
    if not DoesEntityExist(horseentity) then
        horseentity = GetLastMount(PlayerPedId())
    end

    if not DoesEntityExist(horseentity) or #(GetEntityCoords(horseentity) - GetEntityCoords(PlayerPedId())) > 3.0 then
        print('horse is to far from you')
        return
    end

    local category = 0x1530BE1C -- lantern category (component hash)
    local hash = 0x635E387C -- lantern hash
    if not Citizen.InvokeNative(0xFB4891BD7578CDC1, horseentity, category) then -- IsMetapedUsingComponent
        if not hasLanternInHands(PlayerPedId()) then
            print('no lantern in hands')
            return
        end
        print('equip')
        RemoveWeaponFromPed(PlayerPedId(), WEAPON_LANTERN, true, 0)
        equip(horseentity, hash)
    else
        print('unequip')
        unequip(horseentity, category)
        GiveWeaponToPed_2(PlayerPedId(), WEAPON_LANTERN, 0, true, true, 12, false, 0.5, 1.0, 752097756, false, 0, false)
    end
end)
