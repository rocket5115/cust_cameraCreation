RegisterNetEvent('cust:save', function(data)
    if data:match('local cam = CreateCamWithParams') then
        SaveResourceFile(GetCurrentResourceName(), math.random(1,1000)..'.lua', data, -1)
    end
end)