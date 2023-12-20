-- Functions

local function GetOffsetFromCoordsAndHeading(coords, heading, offsetX, offsetY, offsetZ)
    local headingRad = math.rad(heading)
    local x = offsetX * math.cos(headingRad) - offsetY * math.sin(headingRad)
    local y = offsetX * math.sin(headingRad) + offsetY * math.cos(headingRad)
    local z = offsetZ

    local worldCoords = vector4(
        coords.x + x,
        coords.y + y,
        coords.z + z,
        heading
    )

    return worldCoords
end

local function CamCreate(npc)
	cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
	local coordsCam = GetOffsetFromCoordsAndHeading(npc, npc.w, 0.0, 0.6, 1.60)
	local coordsPly = npc
	SetCamCoord(cam, coordsCam)
	PointCamAtCoord(cam, coordsPly['x'], coordsPly['y'], coordsPly['z']+1.60)
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)

end

local function DestroyCamera()
    RenderScriptCams(false, true, 500, 1, 0)
    DestroyCam(cam, false)
end

local check = false
local function TalkNPC(npc)
    CreateThread(function()
        check = true
        while check do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:KeyPressed(38)
                TriggerEvent('npc-menu:showMenu', npc)
            end
            Wait(1)
        end
    end)
end

local function CreatePedPoly(npc, key)
    local v = npc.coords
    local TalkNPCPoly = {}
    TalkNPCPoly[#TalkNPCPoly + 1] = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 2, 2, {
        name = 'talkto' .. key,
        debugPoly = false,
        heading = -20,
        minZ = v.z - 2,
        maxZ = v.z + 2,
    })

    local TalkNPCCombo = ComboZone:Create(TalkNPCPoly, { name = 'signcombo', debugPoly = false })
    TalkNPCCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            exports['qb-core']:DrawText(Config.DrawText, 'left')
            TalkNPC(npc)
        else
            check = false
            exports['qb-core']:HideText()
        end
    end)

end

-- Events

RegisterNetEvent("npc-menu:showMenu", function(npc)
    SendNUIMessage({
        type = "dialog",
        options = npc.options,
        name = npc.name,
        text = npc.text,
        job = npc.job
    })
    CamCreate(npc.coords)
end)

-- NUI

RegisterNUICallback("npc-menu:hideMenu", function()
    SetNuiFocus(false, false)
    DestroyCamera()
end)

RegisterNUICallback("npc-menu:islem", function(data)

    SetNuiFocus(false, false)
    if data.type == 'client' then
        TriggerEvent(data.event, json.encode(data.args))
    elseif data.type == 'server' then
        TriggerServerEvent(data.event, json.encode(data.args))
    elseif data.type == 'command' then
        ExecuteCommand(data.event, json.encode(data.args))
    end
    DestroyCamera()
end)

-- Threads

CreateThread(function()
    for key, npc in ipairs(Config.npcs) do
        RequestModel(GetHashKey(npc.ped))
        while not HasModelLoaded(GetHashKey(npc.ped)) do
            Wait(500)
        end

        local npcPed = CreatePed(4, GetHashKey(npc.ped), npc.coords.x, npc.coords.y, npc.coords.z, npc.coords.w, false, false)
        FreezeEntityPosition(npcPed, true)
        SetEntityInvincible(npcPed, true)
        SetBlockingOfNonTemporaryEvents(npcPed, true)
        if Config.UseTarget then
            HD.Target.AddEntity(npcPed, {
                Distance = 2.5,
                Local = true,
                Options  = {
                    {
                        icon  = 'comment-dots',
                        label = 'Talk '..npc.name,
                        canInteract = function() return true end,
                        action = function() TriggerEvent('npc-menu:showMenu', npc) end,
                    },
                },
            })
        else
            CreatePedPoly(npc, key)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()

        for _, npc in ipairs(Config.npcs) do
            local coords = GetEntityCoords(playerPed, false)
            local distance = GetDistanceBetweenCoords(coords, npc.coords.x, npc.coords.y, npc.coords.z, true)

            if distance < 1.5 then
                DisplayHelpText("E tuşuna basarak etkileşime geç")
                if IsControlJustPressed(0, 38) then -- E tuşuna basıldığında
                    TriggerEvent("npc-menu:showMenu", npc)
                    SetNuiFocus(true, true)
                end
            end
        end
    end
end)

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
