local inGodMode = false
local activenames = false
local inGhostMode = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
    ESX.PlayerData.job = job
end)

--Main Menu
function MainMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'informazioni_personali',
	  {
		  title    = "Flavio - menu principale",
		  align = 'top-left',
		  elements = {	  			  
			{label = Lang["information"],			value = 'info_menu'}, 
			{label = Lang["wallet"],      			value = 'wallet_menu'}, 
			{label = Lang["sim"],               	value =  "sim"},
			{label = Lang["smontaarmi"],        	value =  "smontaarmi"},
			{label = Lang["billing"], 				value = 'billing_menu'},
			{label = Lang["thieft_menu"], 			value = 'thieft_menu'},
			{label = Lang["rockstar"], 				value = 'rockstar'},
			{label = Lang["administration"], 		value = 'administration'},
		  	}
	  },function(data, menu)

		if data.current.value == 'info_menu' then
			PlayerInfoMenu()
		elseif data.current.value == 'wallet_menu' then
			WalletMenu()
		elseif data.current.value == "sim" then
			TriggerEvent(Config.TriggerMenuSim)
		elseif data.current.value == "smontaarmi" then
			TriggerEvent(Config.TriggerSmontaArmi)
		elseif data.current.value == "thieft_menu" then
			ThiefMenu()
		elseif data.current.value == "billing_menu" then
			TriggerEvent(Config.TriggerMenuBilling)
		elseif data.current.value == 'rockstar' then
			RockstarEditor()
		elseif data.current.value == 'administration' then
			ESX.TriggerServerCallback("flavio:checkgroup", function(playerRank)
       		if playerRank == "admin" or playerRank == "superadmin" then
				OpenAdminMenu()
	  		else 
		 		ESX.ShowNotification(Lang['notify_administration'])
	  		end
		end)
        end
	end, function(data, menu)
		menu.close()
	end)
end

--Wallet
function WalletMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'gestione_documenti',
	  {
		  title    = "Flavio - Gestione Documenti",
		  align = 'top-left',
		  elements = {	  			  
			{label = Lang['show_document'],				value = 'show_document'}, 
			{label = Lang['view_document'],		    	value = 'view_document'},
			{label = Lang['show_driving_license'],		value = 'show_driving_license'},
			{label = Lang['view_driving_license'],		value = 'view_driving_license'},
			{label = Lang['show_weapon_license'],		value = 'show_weapon_license'},
			{label = Lang['view_weapon_license'],		value = 'view_weapon_license'},
		  	}
	  },function(data, menu)
		if data.current.value == 'show_document' then
			local playerVicino, playerDistanza = ESX.Game.GetClosestPlayer()
			if playerVicino ~= -1 and playerDistanza <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(playerVicino))
			else
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_godmode_off']})
				else
					ESX.ShowNotification(Lang['notify_search'])
				end
			end
		elseif data.current.value == 'view_document' then
			menu.close()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		elseif data.current.value == 'show_driving_license' then
			local playerVicino, playerDistanza = ESX.Game.GetClosestPlayer()
			if playerVicino ~= -1 and playerDistanza <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(playerVicino), 'driver')
			else
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_godmode_off']})
				else
					ESX.ShowNotification(Lang['notify_search'])
				end
			end
		elseif data.current.value == 'view_driving_license' then
			print('Patente Mostrata')
			menu.close()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
		elseif data.current.value == 'show_weapon_license' then
			local playerVicino, playerDistanza = ESX.Game.GetClosestPlayer()
			if playerVicino ~= -1 and playerDistanza <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(playerVicino), 'weapon')
			else
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_godmode_off']})
				else
					ESX.ShowNotification(Lang['notify_search'])
				end
			end
		elseif data.current.value == 'view_weapon_license' then
			menu.close()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
		end
	end, function(data, menu)
		menu.close()
		MainMenu()
	end)
end


--Player Info
function PlayerInfoMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'player_info',
	  {
		  title    = "Flavio - Informazioni personali",
		  align = 'top-left',
		  elements = {	  			  
			{label = Lang["id"]   		        .. GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))}, 
			{label = Lang["name"]		        .. GetPlayerName(NetworkGetEntityOwner(PlayerPedId()))},
			{label = Lang["job"]      			.. ESX.PlayerData.job.label}, 
			{label = Lang["job_grade"]			.. ESX.PlayerData.job.grade_label},
		  	}
	  },function(data, menu)
		menu.close()
		MainMenu()
	end, function(data, menu)
		menu.close()
		MainMenu()
	end)
end

--Thieft Menu
function ThiefMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'thief',
	  {
		  title    = "Flavio - Menu Illegale",
		  align = 'top-left',
		  elements = {	  			  
			{label = Lang["body_search"],      value = 'perquisizione'},
		  	}
	  },function(data, menu)

		local playerVicino, playerDistanza = ESX.Game.GetClosestPlayer()
			if playerVicino ~= -1 and playerDistanza <= 3.0 then
				if data.current.value == "perquisizione" then
					menu.close()
					OpenSearchMenu(playerVicino)
				end
			else
				ESX.ShowNotification("Nessun player vicino")
			end
		end, function(data, menu)
		menu.close()
		MainMenu()
	end)
end


function OpenSearchMenu(Player)
	exports.ox_inventory:openInventory('player', GetPlayerServerId(Player))
	return ESX.UI.Menu.CloseAll()
end

--Rockstar Editor
function RockstarEditor()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'rockstar_editor',
	  {
		  title    = "Flavio - Rockstar Editor",
		  align = 'top-left',
		  elements = {	  		  
			{label = Lang["openeditor"],	 	value = "open"},
			{label = Lang["startrec"],			value = "startrec"},
			{label = Lang["stoprec"],			value = "stoprec"},
		  	}
	  },function(data, menu)
		if data.current.value == 'open' then
			ActivateRockstarEditor()
		elseif data.current.value == 'rec' then
			StartRecording(1)
			menu.close()
        elseif data.current.value == 'stoprec' then
			StopRecordingAndSaveClip()
			menu.close()
		end
	end, function(data, menu)
		menu.close()
		MainMenu()
	end)
end


--Admin Menu
function OpenAdminMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menu_admin',
	  {
		  title    = "Flavio - menu amministrazione",
		  align = 'top-left',
		  elements = {	  			
			{label = Lang["noclip"],			value = 'noclip'},
			{label = Lang["tpm"],				value = "tpm"},
			{label = Lang["repair_vehicle"],    value = "rveicolo"},
			{label = Lang["flip_vehicle"],      value = "gveicolo"},
			{label = Lang["car"],       		value = "car"},
			{label = Lang["giub"],       		value = "giub"},
			{label = Lang["godmode"],       	value = "godmode"},
			{label = Lang["ghostmode"],       	value = "ghostmode"},
			{label = Lang["wipe"],       		value = "wipe"},
		  	}
	  },function(data, menu)

		local val = data.current.value
		if val == "noclip" then 
            	TriggerServerEvent("NoclipStatus")
            	if not inNoclip then
                	NoClip()
                	noclip_pos = GetEntityCoords(PlayerPedId(), false)
            	else
                	inNoclip = false
            	end
        elseif val == "rveicolo" then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                SetVehicleFixed(GetVehiclePedIsUsing(PlayerPedId()))	
                SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()),0)
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_repair_vehicle']})
				else
					ESX.ShowNotification(Lang['notify_repair_vehicle'])
				end
            else
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_no_vehicle']})
				else
					ESX.ShowNotification(Lang['notify_no_vehicle'])
				end
            end
        elseif val == "gveicolo" then
            local player = PlayerPedId()
            local posdepmenu = GetEntityCoords(player)
            local carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
            SetPedIntoVehicle(player , carTargetDep, -1)
            Citizen.Wait(200)
            ClearPedTasksImmediately(player)
            Citizen.Wait(100)
            local playerCoords = GetEntityCoords(PlayerPedId())
            playerCoords = playerCoords + vector3(0, 2, 0)
            SetEntityCoords(carTargetDep, playerCoords)
			if Config.pnpNotify then
				exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_flip_vehicle']})
			else
				ESX.ShowNotification(Lang['notify_flip_vehicle'])
			end
		elseif val == "car" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'spawna_veicolo', {
                title = "Inserisci il nome del veicolo",
                default = ""
            }, function(data, menu)
					local ModelHash = data.value
					if not IsModelInCdimage(ModelHash) then return end
					RequestModel(ModelHash)
					while not HasModelLoaded(ModelHash) do 
					Citizen.Wait(10)
					end
					local MyPed = PlayerPedId() 
					local Vehicle = CreateVehicle(ModelHash, GetEntityCoords(MyPed), GetEntityHeading(MyPed), true, false)
					SetModelAsNoLongerNeeded(ModelHash)
					TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
					ESX.UI.Menu.CloseAll()
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_spawn_vehicle']})
				else
					ESX.ShowNotification(Lang['notify_spawn_vehicle'])
				end
            end, function(data, menu)
                menu.close()
            end)
		elseif val == "tpm" then
			TriggerEvent(Config.TriggerTPM)
		elseif val == "wipe" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), "wipe_pg", {
                title = "Inserisci l'id del player che vuoi eliminare",
                default = ""
            }, function(data, menu)
				TriggerServerEvent("flavio:wipepg", data.value)
            end, function(data, menu)
                menu.close()
            end)
		elseif val == "giub" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dai_giu bbotto', {
                title = "Dai Giubbotto",
                default = ""
            }, function(data, menu)
                TriggerServerEvent("flavio:bullet", data.value)
				menu.close()
            end, function(data, menu)
                menu.close()
            end)
		elseif val == "godmode" then
			if inGodMode == false then
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_godmode_on']})
				else
					ESX.ShowNotification(Lang['notify_godmode_on'])
				end
				inGodMode = true
				GodMode()
			elseif inGodMode == true then
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_godmode_off']})
				else
					ESX.ShowNotification(Lang['notify_godmode_off'])
				end
				inGodMode = false
			end
		elseif val == "ghostmode" then
			if inGhostMode == false then
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_ghostmode_on']})
				else
					ESX.ShowNotification(Lang['notify_ghostmode_on'])
				end
				inGhostMode = true
				GhostMode()
			elseif inGhostMode == true then
				if Config.pnpNotify then
					exports["pnpNotify:send"]:TriggerNotification({['type'] = "success",['text'] = Lang['notify_ghostmode_off']})
				else
					ESX.ShowNotification(Lang['notify_ghostmode_off'])
				end
				inGhostMode = false
			end
        end
	end, function(data, menu)
		menu.close()
		MainMenu()
	end)
end

local heading = 0
local speed = 0.1
local up_down_speed = 0.1
NoClip = function()

    inNoclip = true
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()
            local targetVeh = GetVehiclePedIsUsing(ped)
            if IsPedInAnyVehicle(ped) then
                ped = targetVeh
            end

            if inNoclip then

                SetEntityInvincible(ped, true)
                SetEntityVisible(ped, false, false)

                SetEntityLocallyVisible(ped)
                SetEntityAlpha(ped, 100, false)
                SetBlockingOfNonTemporaryEvents(ped, true)
                ForcePedMotionState(ped, -1871534317, 0, 0, 0)

                SetLocalPlayerVisibleLocally(ped)
                SetEntityCollision(ped, false, false)
                
                SetEntityCoordsNoOffset(ped, noclip_pos.x, noclip_pos.y, noclip_pos.z, true, true, true)

                if IsControlPressed(1, 34) then
                    heading = heading + 2.0
                    if heading > 359.0 then
                        heading = 0.0
                    end

                    SetEntityHeading(ped, heading)
                end

                if IsControlPressed(1, 9) then
                    heading = heading - 2.0
                    if heading < 0.0 then
                        heading = 360.0
                    end

                    SetEntityHeading(ped, heading)
                end
                heading = GetEntityHeading(ped)

                if IsControlJustPressed(1, 21) then
                    if speed == 0.1 then
                        speed = 0.2
                        up_down_speed = 0.2
                    elseif speed == 0.2 then
                        speed = 0.3
                        up_down_speed = 0.3
                    elseif speed == 0.3 then
                        speed = 0.5
                        up_down_speed = 0.5
                    elseif speed == 0.5 then
                        speed = 1.5
                        up_down_speed = 0.5
                    elseif speed == 1.5 then
                        speed = 2.5
                        up_down_speed = 0.9
                    elseif speed == 2.5 then
                        speed = 3.5
                        up_down_speed = 1.3
                    elseif speed == 3.5 then
                        speed = 4.5
                        up_down_speed = 1.5
                    elseif speed == 4.5 then
                        speed = 0.1
                        up_down_speed = 0.1
                    end
                end

                if IsControlPressed(1, 8) then
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, -speed, 0.0)
                end

                if IsControlPressed(1, 44) and IsControlPressed(1, 32) then -- Q e W
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, up_down_speed)
                elseif IsControlPressed(1, 44) then -- Q
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, up_down_speed)
                elseif IsControlPressed(1, 32) then -- W
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, 0.0)
                end

                if IsControlPressed(1, 20) and IsControlPressed(1, 32) then -- Z e W
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, speed, -up_down_speed)
                elseif IsControlPressed(1, 20) then -- Z
                    noclip_pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, -up_down_speed)
                end
            else
                SetEntityInvincible(ped, false)
                ResetEntityAlpha(ped)
                SetEntityVisible(ped, true, false)
                SetEntityCollision(ped, true, false)
                SetBlockingOfNonTemporaryEvents(ped, false)

                return
            end
        end
    end)
end

function GodMode()
	local ped = PlayerPedId()

	Citizen.CreateThread(function()
    	while true do
    		Citizen.Wait(1)
			if inGodMode == true then
				SetEntityInvincible(ped, true)
			elseif inGodMode == false then
				SetEntityInvincible(ped, false)
			end
		end
	end)
end

function GhostMode()
    local ped = PlayerPedId()

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if inGhostMode == true then
                SetEntityInvincible(ped, true)
				SetEntityVisible(ped, false, false)
            elseif inGhostMode == false then
                SetEntityInvincible(ped, false)
				SetEntityVisible(ped, true, false)
            end
        end
    end)
end


function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(GetPlayerPed(-1), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end


RegisterKeyMapping("hxz-menu", "ApripersonalMenu", "keyboard", "F5")

RegisterCommand("hxz-menu", function()
	MainMenu()
end)