local notificationClosedCallbacks = {}
local isSoundPlaying = false
local notificationColor = '#007bff'

RegisterNUICallback('notificationClosed', function(data, cb)
    local notificationId = data.notificationId

    if notificationId and notificationClosedCallbacks[notificationId] then
        notificationClosedCallbacks[notificationId]()
        notificationClosedCallbacks[notificationId] = nil
    end

    cb({})
end)

function AddNotificationClosedCallback(notificationId, callback)
    notificationClosedCallbacks[notificationId] = callback
end

local currentNotificationId = 0

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(title, message, time, notificationType, playSound)
    currentNotificationId = currentNotificationId + 1
    local notificationId = currentNotificationId

    TriggerEvent('psNotify:ShowNotification', title, message, time, notificationType, playSound)

    if playSound then
        if not isSoundPlaying then
            isSoundPlaying = true
            TriggerEvent('psNotify:PlaySound')
            Citizen.Wait(time + 500) 
            isSoundPlaying = false
        end
    end

    AddNotificationClosedCallback(notificationId, function()
    end)
end)

RegisterNetEvent('psNotify:PlaySound')
AddEventHandler('psNotify:PlaySound', function()
    local sound = GetSoundId()
    PlaySoundFrontend(sound, 'MP3_LOBBY', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
    ReleaseSoundId(sound)
end)

RegisterNetEvent('psNotify:TriggerSound')
AddEventHandler('psNotify:TriggerSound', function()
    TriggerEvent('psNotify:PlaySound') 
end)

RegisterCommand('sendNotification', function(source, args)
    local title = args[1]
    local message = args[2]
    local time = tonumber(args[3])
    local notificationType = args[4]
    local playSound = args[5]

    TriggerEvent('esx:showNotification', title, message, time, notificationType, playSound)
    TriggerEvent('psNotify:TriggerSound') 
end, false)

RegisterCommand('testpsnotify', function(source, args)
    local title = 'Test Notification'
    local message = 'This is a test notification for psNotify!'
    local time = 5000 -- Set the desired duration for the test notification
    local notificationType = 'info' -- Set the desired notification type for the test notification
    local playSound = true -- Set whether the sound should be played for the test notification

    TriggerEvent('esx:showNotification', title, message, time, notificationType, playSound)
    TriggerEvent('psNotify:TriggerSound')
end, false)

RegisterNetEvent('psNotify:ShowNotification')
AddEventHandler('psNotify:ShowNotification', function(title, message, time, notificationType, playSound)
    local notificationTitle

    if notificationType == 'success' then
        notificationTitle = 'Success!'
    elseif notificationType == 'info' then
        notificationTitle = 'Info:'
    elseif notificationType == 'warning' then
        notificationTitle = 'Warning.'
    elseif notificationType == 'error' then
        notificationTitle = 'Error!'
    elseif notificationType == 'phonemessage' then
        notificationTitle = 'Phone'
    else
        notificationTitle = 'Notification'
    end

    SendNUIMessage({
        type = 'notification',
        title = notificationTitle,
        message = message,
        time = time,
        notificationType = notificationType,
        playSound = playSound,
        color = notificationColor
    })

    if playSound then
        if not isSoundPlaying then
            isSoundPlaying = true
            TriggerEvent('psNotify:PlaySound')
            Citizen.Wait(time + 500)
            isSoundPlaying = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not isSoundPlaying then
            Citizen.Wait(1000)
            isSoundPlaying = false
        end
    end
end)
