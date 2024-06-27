function ApplyShopItemToPed(ped, shopItemHash, immediately, isMultiplayer)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, shopItemHash, immediately, isMultiplayer, false)
end

function UpdatePedVariation(ped)
    Citizen.InvokeNative(0xAAB86462966168CE, ped, true) -- UNKNOWN "Fixes outfit"- always paired with _UPDATE_PED_VARIATION
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false) -- _UPDATE_PED_VARIATION
end

function IsMetapedUsingComponent(ped, component)
    return Citizen.InvokeNative(0xFB4891BD7578CDC1, ped, component)
end

function RemoveTagFromMetaPed(ped, component)
    Citizen.InvokeNative(0xD710A5007C2AC539, ped, component, 0)
end

function BottomCenterNotify(text, duration)
    Citizen.InvokeNative("0xDD1232B332CBB9E7", 3, 1, 0)
    local vartext = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", text, Citizen.ResultAsLong())

    local optionscontent = DataView.ArrayBuffer(8 * 7)
    optionscontent:SetInt32(8 * 0, duration)

    local maincontent = DataView.ArrayBuffer(8 * 3)
    maincontent:SetInt64(8 * 1, DataView.BigInt(vartext))

    Citizen.InvokeNative(0xCEDBF17EFCC0E4A4, optionscontent:Buffer(), maincontent:Buffer(), 1)
end

function ToolTip(text, duration)
    local vartext = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    local optionscontent = DataView.ArrayBuffer(8 * 7)
    local inputtext = DataView.ArrayBuffer(8 * 3)

    optionscontent:SetUint32(8 * 0, duration)
    optionscontent:SetInt32(8 * 1, 0)
    optionscontent:SetInt32(8 * 2, 0)
    optionscontent:SetInt32(8 * 3, 0)
    inputtext:SetUint64(8 * 1, DataView.BigInt(vartext))

    Citizen.InvokeNative(0x049D5C615BD38BAD, optionscontent:Buffer(), inputtext:Buffer(), 1)
end