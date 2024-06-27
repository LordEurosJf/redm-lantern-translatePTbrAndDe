-- https://github.com/aaron1a12/wild/blob/main/wild-interact/client/cl_speak.lua

if Config.EnableControlInteraction then

    local prompt = 0

    local function CreateUIPrompts(ped)
        if prompt ~= 0 then
            return
        end
    
        local greetStr = CreateVarString(10, 'LITERAL_STRING', Locales.get('lantern_interaction'))
    
        prompt = PromptRegisterBegin()
        PromptSetControlAction(prompt, Config.ControlName)
        PromptSetText(prompt, greetStr)
        PromptRegisterEnd(prompt)
    
        PromptSetPriority(prompt, 3)
    
        PromptSetEnabled(prompt, true)
    
        if DoesEntityExist(ped) then
            local group = PromptGetGroupIdForTargetEntity(ped)
            PromptSetGroup(prompt, group, 0)
        end
    end
    
    local function DestroyUIPrompts(ped)
        if prompt == 0 then
            return
        end

        if DoesEntityExist(ped) then
            local group = PromptGetGroupIdForTargetEntity(ped)
            PromptRemoveGroup(prompt, group)
        end
    
        PromptDelete(prompt)
    
        prompt = 0
    end

    local bIsFocusingOnHorse = false
    local focusedPed = 0
    local bIsPromptCreated = false

    CreateThread(function()
        while true do
            Wait(0)
    
            bIsFocusingOnHorse = false
            
            -- When player is holding button to focus
            if IsPlayerFreeFocusing(PlayerId()) then
                
                -- Player on horse
                if IsPedOnMount(PlayerPedId()) then
                    if IsControlPressed(0, `INPUT_INTERACT_LOCKON`) then
                        local entity = GetMount(PlayerPedId())
                        local hasLantern = isLanternOnPlayer() or isLanternOnHorse(entity)
                        if hasLantern then
                            PromptDisablePromptTypeThisFrame(7) -- disable emote prompt
            
                            if not bIsFocusingOnHorse then
                                CreateUIPrompts()
                                focusedPed = 0
                                bIsPromptCreated = true
                            end
                            bIsFocusingOnHorse = true
                            if IsControlJustPressed(0, Config.ControlName) then
                                TriggerEvent('redm-lantern:onInputInteractionUsed', entity)
                            end
                        end
                    end
                -- Player not on horse
                else
                    local _, entity = GetPlayerTargetEntity(PlayerId())
                    if IsEntityAPed(entity) and not IsPedHuman(entity) and IsThisModelAHorse(GetEntityModel(entity)) then
                        local hasLantern = isLanternOnPlayer() or isLanternOnHorse(entity)
                        if hasLantern then
                            if not bIsFocusingOnHorse then
                                CreateUIPrompts(entity)
                                focusedPed = entity
                                bIsPromptCreated = true
                            end
                            bIsFocusingOnHorse = true
                            if IsControlJustPressed(0, Config.ControlName) then
                                TriggerEvent('redm-lantern:onInputInteractionUsed', entity)
                            end
                        end
                    end
                end
            end
    
            if not bIsFocusingOnHorse and bIsPromptCreated then
                DestroyUIPrompts(focusedPed)
                focusedPed = 0
                bIsPromptCreated = false
            end
        end
    end)
    
end