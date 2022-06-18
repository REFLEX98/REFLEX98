RegisterServerEvent("NoclipStatus")
AddEventHandler("NoclipStatus",function (arg)
    Noclip = arg
end)

ESX.RegisterServerCallback("flavio:checkgroup", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

RegisterNetEvent("flavio:bullet")
AddEventHandler("flavio:bullet", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer == nil then
            TriggerClientEvent('esx:showNotification', source, 'Player non trovato')
        else
            SetPedArmour(xPlayer.source, 100)
        end
end)

RegisterServerEvent('flavio:wipepg')
AddEventHandler('flavio:wipepg', function(id)

    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer == nil then
        if Config.pnpNotify then
            exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_player_not_found']})
        else
            TriggerClientEvent('esx:showNotification', source, Lang['notify_player_not_found'])
        end
    else
        DropPlayer(id, 'flavio-menu: Il tuo personaggio è stato cancellato. Riavvia FiveM e puoi rientrare')

        MySQL.Sync.execute('DELETE FROM addon_account_data WHERE owner = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM addon_inventory_items WHERE owner = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM billing WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM datastore_data WHERE owner = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM owned_properties WHERE owner = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE owner = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM user_licenses WHERE owner = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM multicharacter_slots WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM gacha_peds WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
        MySQL.Sync.execute('DELETE FROM tattoos WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
    end
end)