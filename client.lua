local rc = RegisterCommand

local forward = false
local backward = false
local left = false
local right = false
local esc = false
local enter = false
local Rrotate = false
local Lrotate = false
local up = false
local down = false
local goUp = false
local goDown = false

local data = {
    ['player'] = PlayerPedId(),
    ['playerID'] = PlayerId(),
    ['cam'] = 0,
    ['playercoords'] = vector3(0.0,0.0,0.0),
    ['camcoords'] = vector3(0.0,0.0,0.0)
}

local templates = {
    ['+'] = "if %s>360.0 then %s=0.0 end",
    ['-'] = "if %s<0.0 then %s=360.0 end"
}

local types = {
    ['faster'] = 2.0,
    ['fast'] = 1.50,
    ['normal'] = 1.0,
    ['slow'] = 0.75,
    ['slower'] = 0.5
}

local enum = {
    [1] = 'faster',
    [2] = 'fast',
    [3] = 'normal',
    [4] = 'slow',
    [5] = 'slower'
}

local velocity = 3
local functions = {
    ['camera'] = function(s,args)
        incam = not incam
        data['playercoords'] = GetEntityCoords(data['player'])
        local coords = data['playercoords']
        data['cam'] = incam and CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 50.0, false, 0) or 0
        if incam then
            SetEntityHeading(data['player'], 0.0)
            AttachCamToEntity(data['cam'], data['player'], 0.0, 0.0, 1.0, true)
            SetCamActive(data['cam'], true)
            RenderScriptCams(true, false, 1, true, true)
            Citizen.CreateThread(function()
                local pos = data['playercoords']
                local heading = 0
                SendNUIMessage({status = true,t='r',d={{r='x',v=0.0},{r='y',v=0.0},{r='z',v=0.0}}})
                SendNUIMessage({c='c',d={{r='x',v=coords.x},{r='y',v=coords.y},{r='z',v=coords.z}}})
                SetEntityAlpha(data['player'], 0, true)
                SetEntityCompletelyDisableCollision(data['player'], true, false)
                SetPlayerInvincible(data['playerID'], true)
                while true do
                    Citizen.Wait(10)
                    SetEntityCoordsNoOffset(data['player'], pos.x, pos.y, pos.z, 0,0,0)
                    if IsControlPressed(1, 32) then
                        pos = GetOffsetFromEntityInWorldCoords(data['player'], 0.0, types[enum[velocity]], 0.0)
                        SendNUIMessage({c='c',d={{r='x',v=pos.x},{r='y',v=pos.y},{r='z',v=pos.z+1.0}}})
                    elseif IsControlPressed(1, 8) then
                        pos = GetOffsetFromEntityInWorldCoords(data['player'], 0.0, (types[enum[velocity]]-(types[enum[velocity]]*2)), 0.0)
                        SendNUIMessage({c='c',d={{r='x',v=pos.x},{r='y',v=pos.y},{r='z',v=pos.z+1.0}}})
                    elseif IsControlPressed(1, 20) then
                        pos = GetOffsetFromEntityInWorldCoords(data['player'], 0.0, 0.0, types[enum[velocity]])
                        SendNUIMessage({c='c',d={{r='x',v=pos.x},{r='y',v=pos.y},{r='z',v=pos.z+1.0}}})
                    elseif IsControlPressed(1, 73) then
                        pos = GetOffsetFromEntityInWorldCoords(data['player'], 0.0, 0.0, (types[enum[velocity]]-(types[enum[velocity]]*2)))
                        SendNUIMessage({c='c',d={{r='x',v=pos.x},{r='y',v=pos.y},{r='z',v=pos.z+1.0}}})
                    end
                    if IsControlPressed(1, 34) then
                        heading = heading + types[enum[velocity]]
                        if heading > 360 then
                            heading = 0
                        end
                        SetEntityHeading(data['player'],heading)
                        local camRot = GetCamRot(data['cam'], 2)
                        local rot = GetEntityHeading(data['player'])
                        SetCamRot(data['cam'], camRot.x, camRot.y, rot, 2)
                        SendNUIMessage({t='r',d={{r='x',v=camRot.x},{r='y',v=camRot.y},{r='z',v=rot}}})
                    elseif IsControlPressed(1, 9) then
                        heading = heading - types[enum[velocity]]
                        if heading > 360 then
                            heading = 0
                        end
                        SetEntityHeading(data['player'],heading)
                        local camRot = GetCamRot(data['cam'], 2)
                        local rot = GetEntityHeading(data['player'])
                        SetCamRot(data['cam'], camRot.x, camRot.y, rot, 2)
                        SendNUIMessage({t='r',d={{r='x',v=camRot.x},{r='y',v=camRot.y},{r='z',v=rot}}})
                    elseif IsControlPressed(1, 46) then
                        local camRot = GetCamRot(data['cam'], 2)
                        SetCamRot(data['cam'], camRot.x, camRot.y+types[enum[velocity]], camRot.z, 2)
                        SendNUIMessage({t='r',d={{r='x',v=camRot.x},{r='y',v=camRot.y+types[enum[velocity]]},{r='z',v=camRot.z}}})
                    elseif IsControlPressed(1, 44) then
                        local camRot = GetCamRot(data['cam'], 2)
                        SetCamRot(data['cam'], camRot.x, camRot.y-types[enum[velocity]], camRot.z, 2)
                        SendNUIMessage({t='r',d={{r='x',v=camRot.x},{r='y',v=camRot.y-types[enum[velocity]]},{r='z',v=camRot.z}}})
                    elseif IsControlPressed(1, 172) then
                        local camRot = GetCamRot(data['cam'], 2)
                        SetCamRot(data['cam'], camRot.x+types[enum[velocity]], camRot.y, camRot.z, 2)
                        SendNUIMessage({t='r',d={{r='x',v=camRot.x+types[enum[velocity]]},{r='y',v=camRot.y},{r='z',v=camRot.z}}})
                    elseif IsControlPressed(1, 173) then
                        local camRot = GetCamRot(data['cam'], 2)
                        SetCamRot(data['cam'], camRot.x-types[enum[velocity]], camRot.y, camRot.z, 2) 
                        SendNUIMessage({t='r',d={{r='x',v=camRot.x-types[enum[velocity]]},{r='y',v=camRot.y},{r='z',v=camRot.z}}})
                    end
                    if IsDisabledControlPressed(1, 37) then
                        SendNUIMessage({t='s',r=1})
                    else
                        SendNUIMessage({t='s',r=0})
                    end
                    if (IsControlPressed(1, 177) or IsControlPressed(1, 200)) or not incam then
                        SendNUIMessage({status = false})
                        DetachCam(data['cam'])
                        DestroyCam(data['cam'], true)
                        DestroyAllCams(true)
                        RenderScriptCams(false, false, 1, false, false)
                        ResetEntityAlpha(data['player'])
                        SetEntityCollision(data['player'], true, true)
                        SetPlayerInvincible(data['playerID'], false)
                        break
                    end
                end
            end)
        end
    end
}

Citizen.CreateThread(function()
    while true do
        if not incam then
            Citizen.Wait(100)
        else
            Citizen.Wait(1)
            DisableControlAction(1, 37, true)
            if IsControlJustReleased(1, 191) then
                SendNUIMessage({t='c'})
            end
            if IsControlJustReleased(1, 178) then
                SendNUIMessage({t='d'})
            end
            if IsControlJustReleased(1, 121) then
                SendNUIMessage({t='e'})
            end
            if IsControlJustReleased(1,174) then
                SendNUIMessage({t='x',d='a'})
            elseif IsControlJustReleased(1, 175) then
                SendNUIMessage({t='x',d='d'})
            end
            if IsControlPressed(1, 96) then
                SendNUIMessage({t='u'})
            elseif IsControlPressed(1, 97) then
                SendNUIMessage({t='i'})
            end
            if IsControlJustPressed(1, 83) then
                if velocity >= 5 then
                    velocity = 1
                else
                    velocity = velocity + 1
                end
                SendNUIMessage({s='s',d=enum[velocity]..' - '..velocity})
            end
            if IsControlJustPressed(1, 84) then
                if velocity <= 1 then
                    velocity = 5
                else
                    velocity = velocity - 1
                end
                SendNUIMessage({s='s',d=enum[velocity]..' - '..velocity})
            end
        end
    end
end)

local initialized = false

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    ResetEntityAlpha(ped)
    SetEntityCollision(ped, true, true)
    SetEntityInvincible(ped, false)
    SetPlayerInvincible(PlayerId(), false)
    while not initialized do
        Citizen.Wait(10)
    end
    rc('cam',functions['camera'])
end)

Citizen.CreateThread(function()
    local i = 0
    repeat
        Citizen.Wait(100)
        i=i+1
    until i==3
    initialized = true
end)

function troc(str)
    local res = {}
    str = string.sub(str, 2, string.len(str))
    local found = false
    local pos = 0
    local start_pos = 0
    for i=1, string.len(str), 1 do
        local sub = string.sub(str, i, i)
        local sub2 = string.sub(str, i, i+3)
        local hasStarted = (string.sub(sub2, 4, 4) == ":")
        local hasEnded = (sub==';' or sub=='}')
        if hasStarted then
            pos = i+4
            start_pos = i
        elseif hasEnded then
            table.insert(res, {
                name = string.sub(str, start_pos, start_pos+3),
                args = string.sub(str, pos, i-1)
            })
        end
    end
    local args = {}
    for i=1, #res, 1 do
        if not args[i] then
            args[i] = {}
        end
        local start_pos = 0
        for j=1, string.len(res[i].args), 1 do
            local sub = string.sub(res[i].args, j, j)
            if start_pos == 0 then
                start_pos = j
            end
            if sub == ',' or j == string.len(res[i].args) then
                isTrue = (j==string.len(res[i].args))
                local arg = string.gsub(string.sub(res[i].args, start_pos, isTrue and j or j-1), '++', ',')
                args[i][#args[i]+1] = arg
                start_pos = 0
            end
        end
    end
    return res,args
end

local function execute(...)
    local d={...}
    local n,a,save,exec = d[1],d[2],d[3],d[4]
    local retval = 'Citizen.CreateThread(function()\n$Tlocal cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",'
    for i=1, #a, 1 do
        for j=1, #a[i], 1 do
            a[i][j] = tonumber(a[i][j])
        end
    end
    for i=1, #n, 1 do
        if n[i].name == 'ccm:' then
            retval = retval..a[i][4]..','..a[i][5]..','..a[i][6]..','..a[i][1]..','..a[i][2]..','..a[i][3]..',90.0,false,0)\n$TSetCamActive(cam, true)\n    RenderScriptCams(true, false, 1, true, true)\n'
        else
            if a[i-1] and a[i] then
                local vec = vector3(a[i-1][1], a[i-1][2], a[i-1][3])
                local vec2 = vector3(a[i][1], a[i][2], a[i][3])
                local t = a[i][8]
                if a[i][7] == 1 then
                    local x,y,z
                    if vec.z < vec2.z then
                        z = (vec2.z-vec.z)/t
                    elseif vec2.z < vec.z then
                        z = ((360.0-vec.z)+vec2.z)/t
                    else
                        z = 0.0
                    end
                    if vec.y < vec2.y then
                        y = (vec2.y-vec.y)/t
                    elseif vec2.y < vec.y then
                        y = ((360.0-vec.y)+vec2.y)/t
                    else
                        y = 0.0
                    end
                    if vec.x < vec2.x then
                        x = (vec2.x-vec.x)/t
                    elseif vec2.x < vec.x then
                        x = ((360.0-vec.x)+vec2.x)/t
                    else
                        x = 0.0
                    end
                    retval = retval .. ('$Tlocal x,y,z=%s,%s,%s \n$Tlocal x2,y2,z2=$X,$Y,$Z \n$Tfor i=1,%s do \n$T$TWait(1)\n$T$Tx=x%s y=y%s z=z%s\n$T$T%s %s %s \n$T$TSetCamRot(cam,x,y,z,2)\n'):format(vec.x,vec.y,vec.z,t,'+'..x,'+'..y,'+'..z, templates['+']:format('x', 'x'), templates['+']:format('y', 'y'), templates['+']:format('z', 'z'))
                elseif a[i][7] == 0 then
                    local x,y,z
                    if vec.z < vec2.z then
                        z = ((360.0-vec2.z)+vec.z)/t
                    elseif vec2.z < vec.z then
                        z = (vec.z-vec2.z)/t
                    else
                        z = 0.0
                    end
                    if vec.y < vec2.y then
                        y = ((360.0-vec2.y)+vec.y)/t
                    elseif vec2.y < vec.y then
                        y = (vec.y-vec2.y)/t
                    else
                        y = 0.0
                    end
                    if vec.x < vec2.x then
                        x = ((360.0-vec2.x)+vec.x)/t
                    elseif vec2.x < vec.x then
                        x = (vec.x-vec2.x)/t
                    else
                        x = 0.0
                    end
                    retval = retval .. ('$Tlocal x,y,z=%s,%s,%s \n$Tlocal x2,y2,z2=$X,$Y,$Z $T\n$Tfor i=1,%s do \n$T$TWait(1)\n$T$Tx=x%s y=y%s z=z%s\n$T$T%s %s %s \n$T$TSetCamRot(cam,x,y,z,2)\n'):format(vec.x,vec.y,vec.z,t,'- '..x,'- '..y,'- '..z, templates['-']:format('x', 'x'), templates['-']:format('y', 'y'), templates['-']:format('z', 'z'))
                end
                local vec = vector3(a[i-1][4], a[i-1][5], a[i-1][6])
                local vec2 = vector3(a[i][4], a[i][5], a[i][6])
                local p1,p2,p3 = (string.sub(vec.x, 1, 1)=='-'),(string.sub(vec.y, 1, 1)=='-'),(string.sub(vec.z, 1, 1)=='-')
                local p4, p5, p6 = (string.sub(vec2.x, 1, 1)=='-'),(string.sub(vec2.y, 1, 1)=='-'),(string.sub(vec2.z, 1, 1)=='-')
                local x,y,z
                if p1 and p4 then
                    x = (tonumber(string.sub(vec.x, 2, string.len(vec.x)))-tonumber(string.sub(vec2.x, 2, string.len(vec2.x))))/t
                elseif p1 and not p4 then
                    x = ((tonumber(string.sub(vec.x, 2, string.len(vec.x))))+vec2.x)/t
                elseif not p1 and p4 then
                    x = tonumber('-'..(tonumber(string.sub(vec2.x, 2, string.len(vec2.x)))+vec.x))/t
                else
                    x = (vec2.x-vec.x)/t
                end
                if p2 and p5 then
                    y = (tonumber(string.sub(vec.y, 2, string.len(vec.y)))-tonumber(string.sub(vec2.y, 2, string.len(vec2.y))))/t
                elseif p2 and not p5 then
                    y = ((tonumber(string.sub(vec.y, 2, string.len(vec.y))))+vec2.y)/t
                elseif not p2 and p5 then
                    y = tonumber('-'..(tonumber(string.sub(vec2.y, 2, string.len(vec2.y)))+vec.y))/t
                else
                    y = (vec2.y-vec.y)/t
                end
                if p3 and p6 then
                    z = (tonumber(string.sub(vec.z, 2, string.len(vec.z)))-tonumber(string.sub(vec2.z, 2, string.len(vec2.z))))/t
                elseif p3 and not p6 then
                    z = ((tonumber(string.sub(vec.z, 2, string.len(vec.z))))+vec2.z)/t
                elseif not p3 and p6 then
                    z = tonumber('-'..(tonumber(string.sub(vec2.z, 2, string.len(vec2.z)))+vec.z))/t
                else
                    z = (vec2.z-vec.z)/t
                end
                retval = retval:gsub('$X', vec.x)
                retval = retval:gsub('$Y', vec.y)
                retval = retval:gsub('$Z', vec.z)
                retval = retval .. '$T$Tx2=x2+'..x..' y2=y2+'..y..' z2=z2+'..z..'\n$T$TSetCamCoord(cam,x2,y2,z2)\n$Tend\n'
            end
        end
    end
    retval = retval:gsub('$T', '    ')
    retval = retval .. 'end)'
    if save then
        TriggerServerEvent('cust:save', retval)
    end
    if exec then
        load(retval)()
    end
    return retval
end

exports('execute', function(name, scen, save, exec)
    if type(name) == 'string' then
        local p1,p2 = troc(name)
        name = p1
        scen = p2
        return execute(name,scen,save,exec)
    else
        return execute(name,scen,save,exec)
    end
end)

exports('translate', function(str)
    local name,scen = troc(str)
    return name,scen
end)