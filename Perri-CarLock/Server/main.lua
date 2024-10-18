local cache = {}

lib.callback.register('Perri_CarLock', function(source, plate)
    
    if not cache[source] then
        cache[source] = {}
    end

    if cache[source][plate] then
        return true
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE plate = ? and owner = ?', {plate, xPlayer.identifier})


    if result[1] then
        
        cache[source][plate] = true
        
        return true
    else
        return false
    end
end)

