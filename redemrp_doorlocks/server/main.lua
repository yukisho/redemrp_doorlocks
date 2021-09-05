local DoorInfo	= {}

data = {}
TriggerEvent("redemrp_inventory:getData",function(call)
	data = call
end)

RegisterServerEvent('redemrp_doorlocks:updatedoorsv')
AddEventHandler('redemrp_doorlocks:updatedoorsv', function(doorID, state, cb)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        local _job = tostring(user.getJob())
        if not IsAuthorized(_job, Config.DoorList[tonumber(doorID)]) then
            return
        else
            local ItemData = data.getItem(_source, 'jailkey')
            if ItemData.ItemAmount >= 1 then
                TriggerClientEvent('redemrp_doorlocks:changedoor', _source, doorID, state)
            end
        end
	end)
end)

RegisterServerEvent('redemrp_doorlocks:updateState')
AddEventHandler('redemrp_doorlocks:updateState', function(doorID, state, cb)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if type(doorID) ~= 'number' then
			return
		end
        local _job = tostring(user.getJob())
		if not IsAuthorized(_job, Config.DoorList[tonumber(doorID)]) then
			return
		end
		DoorInfo[tonumber(doorID)] = {}
		TriggerClientEvent('redemrp_doorlocks:setState', -1, doorID, state)
    end)
end)

function IsAuthorized(jobName, doorID)
    local _doorID = doorID
	for _,job in pairs(_doorID.authorizedJobs) do
		if job == jobName then
			return true
		end
	end
	return false
end
