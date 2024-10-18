local inVehicle = false
local keybind = lib.addKeybind({
    name = 'openCar',
    description = 'press U to open car',
    defaultKey = Config.OpenKey,
    onPressed = function(self)
        checkCar()
    end
})


function checkCar()
    local currentCoords = GetEntityCoords(cache.ped)
    local ClosestVehicle = lib.getClosestVehicle(currentCoords, 20, true) 
    local doorStatus = GetVehicleDoorLockStatus(ClosestVehicle)

    if not ClosestVehicle then
        lib.notify({
            title = Config.NotifyTitle,
            position = 'center-right',
            description = Config.NoNearbyVehicleMessage,
            type = 'error'
        })
        return 
    end

    local plate = ESX.Game.GetVehicleProperties(ClosestVehicle).plate
    local response = lib.callback.await('Perri_CarLock', false, plate)
    if response then

        PlaySoundFromCoord(-1,"PIN_BUTTON",x,y,z,"ATM_SOUNDS", true, 5, false)
        animacion()
        
        if doorStatus == 2 then   

            lib.notify({
                title = Config.NotifyTitle,
                position = 'center-right',
                description = Config.OpenMessage,
                type = 'success'
            })

            SetVehicleDoorsLocked(ClosestVehicle, 1)
            sonido(ClosestVehicle)
            luz(ClosestVehicle)
        else 
            lib.notify({
                title = Config.NotifyTitle,
                position = 'center-right',
                description = Config.CloseMessage,
                type = 'success'
            })

            animacion()
            luz(ClosestVehicle)
            SetVehicleDoorsLocked(ClosestVehicle, 2)
        end

        if not Config.DisableLeave then
            return
        end

        if IsPedInVehicle(cache.ped, ClosestVehicle) and doorStatus == 1 then
            inVehicle = true
        else
            inVehicle = false
        end

    CreateThread(function()
        while inVehicle do
            if not IsPedInVehicle(cache.ped, ClosestVehicle) then
                return
            end
            DisableControlAction(0, 75)                
            Wait(0)
            end
        end)
    end
end



function animacion()
    local dict = 'anim@mp_player_intmenu@key_fob@'

    lib.requestAnimDict(dict, 1000)
    TaskPlayAnim(cache.ped, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
    RemoveAnimDict(dict)
end


function luz(ClosestVehicle)
	SetVehicleLights(ClosestVehicle, 2)
	Wait(200)
	SetVehicleLights(ClosestVehicle, 0)
	Wait(150)
	SetVehicleLights(ClosestVehicle, 2)
	Wait(500)
	SetVehicleLights(ClosestVehicle, 0)
end

function sonido(ClosestVehicle)
	StartVehicleHorn(ClosestVehicle, 200, "HELDDOWN", false)
	Wait(300)
	StartVehicleHorn(ClosestVehicle, 150, "HELDDOWN", false)
end
