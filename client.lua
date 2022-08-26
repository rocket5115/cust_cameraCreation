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

local animations = {
    'none', --used to cancel animation
    'SwitchHUDIn',
    'SwitchHUDOut',
    'FocusIn',
    'FocusOut',
    'MinigameEndNeutral',
    'MinigameEndTrevor',
    'MinigameEndFranklin',
    'MinigameEndMichael',
    'MinigameTransitionOut',
    'MinigameTransitionIn',
    'SwitchShortNeutralIn',
    'SwitchShortFranklinIn',
    'SwitchShortTrevorIn',
    'SwitchShortMichaelIn',
    'SwitchOpenMichaelIn',
    'SwitchOpenFranklinIn',
    'SwitchOpenTrevorIn',
    'SwitchHUDMichaelOut',
    'SwitchHUDFranklinOut',
    'SwitchHUDTrevorOut',
    'SwitchShortFranklinMid',
    'SwitchShortMichaelMid',
    'SwitchShortTrevorMid',
    'DeathFailOut',
    'CamPushInNeutral',
    'CamPushInFranklin',
    'CamPushInMichael',
    'CamPushInTrevor',
    'SwitchOpenMichaelIn',
    'SwitchSceneFranklin',
    'SwitchSceneTrevor',
    'SwitchSceneMichael',
    'SwitchSceneNeutral',
    'MP_Celeb_Win',
    'MP_Celeb_Win_Out',
    'MP_Celeb_Lose',
    'MP_Celeb_Lose_Out',
    'DeathFailNeutralIn',
    'DeathFailMPDark',
    'DeathFailMPIn',
    'MP_Celeb_Preload_Fade',
    'PeyoteEndOut',
    'PeyoteEndIn',
    'PeyoteIn',
    'PeyoteOut',
    'MP_race_crash',
    'SuccessFranklin',
    'SuccessTrevor',
    'SuccessMichael',
    'DrugsMichaelAliensFightIn',
    'DrugsMichaelAliensFight',
    'DrugsMichaelAliensFightOut',
    'DrugsTrevorClownsFightIn',
    'DrugsTrevorClownsFight',
    'DrugsTrevorClownsFightOut',
    'HeistCelebPass',
    'HeistCelebPassBW',
    'HeistCelebEnd',
    'HeistCelebToast',
    'MenuMGHeistIn',
    'MenuMGTournamentIn',
    'MenuMGSelectionIn',
    'ChopVision',
    'DMT_flight_intro',
    'DMT_flight',
    'DrugsDrivingIn',
    'DrugsDrivingOut',
    'SwitchOpenNeutralFIB5',
    'HeistLocate',
    'MP_job_load',
    'RaceTurbo',
    'MP_intro_logo',
    'HeistTripSkipFade',
    'MenuMGHeistOut',
    'MP_corona_switch',
    'MenuMGSelectionTint',
    'SuccessNeutral',
    'ExplosionJosh3',
    'SniperOverlay',
    'RampageOut',
    'Rampage',
    'Dont_tazeme_bro',
    'DeathFailOut'
}

local show = false
local inpreview = false

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
                local x = 0.0
                SendNUIMessage({status = true,t='r',d={{r='x',v=0.0},{r='y',v=0.0},{r='z',v=0.0}}})
                SendNUIMessage({c='c',d={{r='x',v=coords.x},{r='y',v=coords.y},{r='z',v=coords.z}}})
                SetEntityAlpha(data['player'], 0, true)
                SetEntityCompletelyDisableCollision(data['player'], true, false)
                SetPlayerInvincible(data['playerID'], true)
                local x,y,z=0.0,0.0,0.0
                while true do
                    Citizen.Wait(10)
                    local camRot = GetCamRot(data['cam'], 2)
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
                        z = GetEntityHeading(data['player'])
                    elseif IsControlPressed(1, 9) then
                        heading = heading - types[enum[velocity]]
                        if heading > 360 then
                            heading = 0
                        end
                        SetEntityHeading(data['player'],heading)
                        z = GetEntityHeading(data['player'])
                    end
                    if IsControlPressed(1, 46) then
                        y=y+types[enum[velocity]]
                        if y > 180.0 then
                            y = -180.0
                        end
                    elseif IsControlPressed(1, 44) then
                        y=y-types[enum[velocity]]
                        if y < -180.0 then
                            y = 180.0
                        end
                    end
                    if IsControlPressed(1, 172) then
                        if not show then
                            x=x+types[enum[velocity]]
                        end
                        if x > 180.0 then
                            x = -180.0
                        end
                    elseif IsControlPressed(1, 173) then
                        if not show then
                            x=x-types[enum[velocity]]
                        end
                        if x < -180.0 then
                            x = 180.0
                        end
                    end
                    if (IsDisabledControlJustPressed(1, 177)) or not incam then
                        if not inpreview then
                            incam = false
                            SendNUIMessage({status = false})
                            DetachCam(data['cam'])
                            DestroyCam(data['cam'], true)
                            DestroyAllCams(true)
                            RenderScriptCams(false, false, 1, false, false)
                            ResetEntityAlpha(data['player'])
                            SetEntityCollision(data['player'], true, true)
                            SetPlayerInvincible(data['playerID'], false)
                            break
                        else
                            SetCamActive(data['cam'], true)
                            RenderScriptCams(true, false, 1, true, true)
                            inpreview = false
                        end
                    end
                    SetCamRot(data['cam'],x,y,z,2)
                    SendNUIMessage({t='r',d={{r='x',v=x},{r='y',v=y},{r='z',v=z}}})
                end
            end)
        end
    end
}

local cureffect = 1
local menu = false

Citizen.CreateThread(function()
    while true do
        if not incam then
            Citizen.Wait(100)
        else
            Citizen.Wait(1)
            DisableControlAction(1, 37, true)
            DisableControlAction(1, 177, true)
            if IsControlJustReleased(1, 191) then
                SendNUIMessage({t='c'})
            end
            if IsControlJustReleased(1, 178) then
                if not show then
                    SendNUIMessage({t='d'})
                else
                    SendNUIMessage({t='d2'})
                end
            end
            if IsControlJustReleased(1, 121) then
                SendNUIMessage({t='e'})
            end
            if not show then
                if IsControlJustReleased(1,174) then
                    SendNUIMessage({t='x',d='a'})
                elseif IsControlJustReleased(1, 175) then
                    SendNUIMessage({t='x',d='d'})
                end
            else
                if IsControlJustReleased(1,174) then
                    local last = cureffect
                    if not animations[cureffect-1] then
                        cureffect = #animations
                    else
                        cureffect = cureffect-1
                    end
                    AnimpostfxStop(animations[last])
                    AnimpostfxPlay(animations[cureffect], 1000, true)
                    SendNUIMessage({x='x',d=cureffect})
                elseif IsControlJustReleased(1, 175) then
                    local last = cureffect
                    if not animations[cureffect+1] then
                        cureffect = 1
                    else
                        cureffect = cureffect+1
                    end
                    AnimpostfxStop(animations[last])
                    AnimpostfxPlay(animations[cureffect], 1000, true)
                    SendNUIMessage({x='x',d=cureffect})
                end
            end
            if show then
                if IsControlJustPressed(1, 173) then
                    SendNUIMessage({u='d'})
                end
                if IsControlJustPressed(1, 172) then
                    SendNUIMessage({u='u'})
                end
                if IsControlJustPressed(1, 212) then
                    menu = not menu
                    if not menu then
                        SendNUIMessage({h=menu})
                    else
                        SendNUIMessage({h=menu})
                    end
                end
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
            if IsDisabledControlJustPressed(1, 37) then
                show = not show
                if show then
                    SendNUIMessage({t='s',r=1})
                else
                    SendNUIMessage({t='s',r=0})
                end
            end
        end
    end
end)

local initialized = false

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    AnimpostfxStopAll()
    ResetEntityAlpha(ped)
    SetEntityCollision(ped, true, true)
    SetEntityInvincible(ped, false)
    SetPlayerInvincible(PlayerId(), false)
    while not initialized do
        Citizen.Wait(10)
    end
    SendNUIMessage({i='i',d=animations})
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
--Execution of string
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
            retval = retval..a[i][4]..','..a[i][5]..','..a[i][6]..','..a[i][1]..','..a[i][2]..','..a[i][3]..',90.0,false,0)\n$Tlocal lasteffect=""\n$TSetCamActive(cam, true)\n$TRenderScriptCams(true, false, 1, true, true)'..(animations[a[i][9]]~='none' and '$TStartScreenEffect("'..animations[a[i][9]]..'")\n$Tlasteffect = "'..animations[a[i][9]]..'"\n' or '\n')
        else
            if a[i-1] and a[i] then
                local vec = vector3(a[i-1][1], a[i-1][2], a[i-1][3])
                local vec2 = vector3(a[i][1], a[i][2], a[i][3])
                local t = a[i][8]
                if a[i][7] == 1 then
                    local x,y,z
                    if vec.z < vec2.z then
                        z = (vec2.z-vec.z)
                    elseif vec2.z < vec.z then
                        z = ((360.0-vec.z)+vec2.z)
                    else
                        z = 0.0
                    end
                    if vec.y < vec2.y then
                        y = (vec2.y-vec.y)
                    elseif vec2.y < vec.y then
                        if (vec.y<=0.0) then
                            if vec.y < 0.0 and vec2.y > 0.0 then
                                y = (tonumber(string.sub(vec.y, 2, string.len(vec.y)))+tonumber(string.sub(vec2.y, 2, string.len(vec2.y))))
                            elseif vec.y < 0.0 and vec2.y < 0.0 then
                                y = (tonumber(string.sub(vec2.y, 2, string.len(vec2.y))))-tonumber(string.sub(vec.y, 2, string.len(vec.y)))
                            end
                        elseif (vec2.y<0.0) then
                            y = (tonumber(string.sub(vec2.y, 2, string.len(vec2.y)))+vec.y)
                        else
                            y = (vec2.y+vec.y)
                        end
                    else
                        y = 0.0
                    end
                    if string.sub(vec.y, 1, 5) == string.sub(vec2.y, 1, 5) then
                        y = 0.0
                    end
                    if vec.x < vec2.x then
                        x = (vec2.x-vec.x)
                    elseif vec2.x < vec.x then
                        if (vec.x<=0.0) then
                            if vec.x < 0.0 and vec2.x > 0.0 then
                                x = (tonumber(string.sub(vec.x, 2, string.len(vec.x)))+tonumber(string.sub(vec2.x, 2, string.len(vec2.x))))
                            elseif vec.x < 0.0 and vec.y < 0.0 then
                                x = (tonumber(string.sub(vec2.x, 2, string.len(vec2.x))))
                            end
                        elseif (vec2.x<0.0) then
                            x = (tonumber(string.sub(vec2.x, 2, string.len(vec2.x)))+vec.x)
                        else
                            x = (vec.x-vec2.x)
                        end
                    else
                        x = 0.0
                    end
                    if string.sub(vec.x, 1, 5) == string.sub(vec2.x, 1, 5) then
                        x = 0.0
                    end
                    if x ~= 0.0 or y ~= 0.0 or z ~= 0.0 then
                        retval = retval .. ('$Tlocal time=%s\n$Tlocal x,y,z=%s,%s,%s \n$Tlocal x2,y2,z2=$X,$Y,$Z\n$Tfor i=1,time do \n$T$TWait(1)\n$T$Tx=x%s y=y%s z=z%s\n$T$T%s %s %s \n$T$TSetCamRot(cam,x,y,z,2)\n'):format(t,vec.x,vec.y,vec.z,'+('..x..'/time)','+('..y..'/time)','+('..z..'/time)', (vec.x<vec2.x and templates['+']:format('x', 'x') or templates['-']:format('x', 'x')), (vec.y<vec2.y and templates['+']:format('y', 'y') or templates['-']:format('y', 'y')), templates['+']:format('z', 'z'))
                    else
                        retval = retval .. ('$Tlocal time=%s\n$Tlocal x2,y2,z2=$X,$Y,$Z\n$Tfor i=1,time do\n$T$TWait(1)\n'):format(t)
                    end
                    print(vec.x, vec2.x, x)
                elseif a[i][7] == 0 then
                    local x,y,z
                    if vec.z < vec2.z then
                        z = ((360.0-vec2.z)+vec.z)
                    elseif vec2.z < vec.z then
                        z = (vec.z-vec2.z)
                    else
                        z = 0.0
                    end
                    if vec.y < vec2.y then
                        y = (vec2.y-vec.y)
                    elseif vec2.y < vec.y then
                        if (vec.y<=0.0) then
                            if vec.y < 0.0 and vec2.y > 0.0 then
                                y = (tonumber(string.sub(vec.y, 2, string.len(vec.y)))+tonumber(string.sub(vec2.y, 2, string.len(vec2.y))))
                            elseif vec.y < 0.0 and vec2.y < 0.0 then
                                y = (tonumber(string.sub(vec2.y, 2, string.len(vec2.y))))-tonumber(string.sub(vec.y, 2, string.len(vec.y)))
                            end
                        elseif (vec2.y<0.0) then
                            y = (tonumber(string.sub(vec2.y, 2, string.len(vec2.y)))+vec.y)
                        else
                            y = (vec2.y+vec.y)
                        end
                    else
                        y = 0.0
                    end
                    if string.sub(vec.y, 1, 5) == string.sub(vec2.y, 1, 5) then
                        y = 0.0
                    end
                    if vec.x < vec2.x then
                        x = (vec2.x-vec.x)
                    elseif vec2.x < vec.x then
                        if (vec.x<=0.0) then
                            if vec.x < 0.0 and vec2.x > 0.0 then
                                x = (tonumber(string.sub(vec.x, 2, string.len(vec.x)))+tonumber(string.sub(vec2.x, 2, string.len(vec2.x))))
                            elseif vec.x < 0.0 and vec.y < 0.0 then
                                x = (tonumber(string.sub(vec2.x, 2, string.len(vec2.x))))
                            end
                        elseif (vec2.x<0.0) then
                            x = (tonumber(string.sub(vec2.x, 2, string.len(vec2.x)))+vec.x)
                        else
                            x = (vec.x-vec2.x)
                        end
                    else
                        x = 0.0
                    end
                    if string.sub(vec.x, 1, 5) == string.sub(vec2.x, 1, 5) then
                        x = 0.0
                    end
                    if x ~= 0.0 or y ~= 0.0 or z ~= 0.0 then
                        retval = retval .. ('$Tlocal time=%s\n$Tlocal x,y,z=%s,%s,%s \n$Tlocal x2,y2,z2=$X,$Y,$Z\n$Tfor i=1,time do \n$T$TWait(1)\n$T$Tx=x%s y=y%s z=z%s\n$T$T%s %s %s \n$T$TSetCamRot(cam,x,y,z,2)\n'):format(t,vec.x,vec.y,vec.z,'-('..x..'/time)','-('..y..'/time)','-('..z..'/time)', (vec.x<vec2.x and templates['+']:format('x', 'x') or templates['-']:format('x', 'x')), (vec.y<vec2.y and templates['+']:format('y', 'y') or templates['-']:format('y', 'y')), templates['-']:format('z', 'z'))
                    else
                        retval = retval .. ('$Tlocal time=%s\n$Tlocal x2,y2,z2=$X,$Y,$Z\n$Tfor i=1,time do\n$T$TWait(1)\n'):format(t)
                    end
                    print(vec.y, vec2.y, y)
                end
                local vec = vector3(a[i-1][4], a[i-1][5], a[i-1][6])
                local vec2 = vector3(a[i][4], a[i][5], a[i][6])
                local p1,p2,p3 = (string.sub(vec.x, 1, 1)=='-'),(string.sub(vec.y, 1, 1)=='-'),(string.sub(vec.z, 1, 1)=='-')
                local p4, p5, p6 = (string.sub(vec2.x, 1, 1)=='-'),(string.sub(vec2.y, 1, 1)=='-'),(string.sub(vec2.z, 1, 1)=='-')
                local x,y,z
                if p1 and p4 then
                    x = (tonumber(string.sub(vec.x, 2, string.len(vec.x)))-tonumber(string.sub(vec2.x, 2, string.len(vec2.x))))
                elseif p1 and not p4 then
                    x = ((tonumber(string.sub(vec.x, 2, string.len(vec.x))))+vec2.x)
                elseif not p1 and p4 then
                    x = tonumber('-'..(tonumber(string.sub(vec2.x, 2, string.len(vec2.x)))+vec.x))
                else
                    x = (vec2.x-vec.x)
                end
                if p2 and p5 then
                    y = (tonumber(string.sub(vec.y, 2, string.len(vec.y)))-tonumber(string.sub(vec2.y, 2, string.len(vec2.y))))
                elseif p2 and not p5 then
                    y = ((tonumber(string.sub(vec.y, 2, string.len(vec.y))))+vec2.y)
                elseif not p2 and p5 then
                    y = tonumber('-'..(tonumber(string.sub(vec2.y, 2, string.len(vec2.y)))+vec.y))
                else
                    y = (vec2.y-vec.y)
                end
                if p3 and p6 then
                    z = (tonumber(string.sub(vec.z, 2, string.len(vec.z)))-tonumber(string.sub(vec2.z, 2, string.len(vec2.z))))
                elseif p3 and not p6 then
                    z = ((tonumber(string.sub(vec.z, 2, string.len(vec.z))))+vec2.z)
                elseif not p3 and p6 then
                    z = tonumber('-'..(tonumber(string.sub(vec2.z, 2, string.len(vec2.z)))+vec.z))
                else
                    z = (vec2.z-vec.z)
                end
                if x ~= 0.0 or y ~= 0.0 or z ~= 0.0 then
                    retval = retval:gsub('$X', vec.x)
                    retval = retval:gsub('$Y', vec.y)
                    retval = retval:gsub('$Z', vec.z)
                    local an = ((a[i+1]~=nil and a[i+1][9]~=nil)and a[i+1][9]~=a[i][9])
                    retval = retval .. '$T$Tx2=x2+('..x..'/time) y2=y2+('..y..'/time) z2=z2+('..z..'/time)\n$T$TSetCamCoord(cam,x2,y2,z2)\n$Tend\n'..(an and '$TStartScreenEffect("'..animations[a[i+1][9]]..'")\n$TStopScreenEffect(lasteffect)\n$Tlasteffect="'..animations[a[i+1][9]]..'"\n' or '')
                else
                    retval = retval:gsub('$Tlocal x2,y2,z2=$X,$Y,$Z\n', '')
                    retval = retval .. '$Tend\n'
                end
            end
        end
    end
    retval = retval:gsub('$Tlocal x2,y2,z2=$X,$Y,$Z\n', '')
    retval = retval:gsub('if x>360.0 then x=0.0 end if y>360.0 then y=0.0 end', 'if x>180.0 then x=-180.0 end if y>180.0 then y=-180.0 end')
    retval = retval:gsub('if x<0.0 then x=360.0 end if y<0.0 then y=360.0 end', 'if x<-180.0 then x=180.0 end if y<-180.0 then y=-180.0 end')
    retval = retval .. '$TDetachCam(cam)\n$TDestroyCam(cam)\n$TRenderScriptCams(false, false, 1, false, false)\n$TStopAllScreenEffects()\nend)'
    retval = retval:gsub('$T', '    ')
    if save then
        TriggerServerEvent('cust:save', retval)
    end
    if exec then
        load(retval)()
    end
    return retval
end

RegisterNUICallback('execute', function(data)
    SendNUIMessage({exp='show',data='Creating and executing camera...',time=2000})
    local p1 = data.data[1]:gsub('cmp:', 'ccm:')
    p1 = '{'..p1..data.data[2]:gsub(';','')..'}'
    local name,scen = troc(p1)
    local ret = execute(name,scen,true,false)
    ret = ret:gsub('    RenderScriptCams%(false, false, 1, false, false%)', '')
    ret = ret:sub(1, ret:len()-4)
    ret = ret .. '    TriggerEvent(\'cust_cc:show\')\nend)'
    inpreview = true
    load(ret)()
end)

AddEventHandler('cust_cc:show', function()
    inpreview = false
    SetCamActive(data['cam'], true)
    RenderScriptCams(true, false, 1, true, true)
end)

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
