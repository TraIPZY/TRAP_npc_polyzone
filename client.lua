-- TRAP_npc_polyzone - client.lua

-- Fonction pour savoir si un point est dans un polygone
local function isPointInPolygon(x, y, polygon)
    local inside = false
    local j = #polygon
    for i = 1, #polygon do
        if ((polygon[i].y > y) ~= (polygon[j].y > y)) and
           (x < (polygon[j].x - polygon[i].x) * (y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x) then
            inside = not inside
        end
        j = i
    end
    return inside
end

-- Dessiner la polyzone en debug (mur vertical)
local function DrawPolyZone(zone)
    local points = zone.points
    local zMin = 0.0    -- base du mur
    local zMax = 12.0   -- hauteur du mur

    for i = 1, #points do
        local startPoint = points[i]
        local endPoint = points[i % #points + 1]

        -- Lignes verticales pour le mur
        for z = zMin, zMax, 1.0 do
            DrawLine(startPoint.x, startPoint.y, z, endPoint.x, endPoint.y, z, 0, 255, 0, 150)
        end

        -- Markers au sommet des coins
        DrawMarker(2, startPoint.x, startPoint.y, zMax, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 0, 255, 0, 150, false, true, 2, false, nil, nil, false)
    end
end

-- Fonction pour récupérer les occupants d'un véhicule
local function GetVehicleOccupants(vehicle)
    local occupants = {}
    for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        local ped = GetPedInVehicleSeat(vehicle, seat)
        if ped and ped ~= 0 then
            table.insert(occupants, ped)
        end
    end
    return occupants
end

-- Thread principal pour nettoyer les polyzones
CreateThread(function()
    while true do
        local sleep = 500
        if Config.Debug then sleep = 0 end

        for zoneName, zone in pairs(Config.PolyZones) do

            -- Supprimer véhicules NPC seulement
            if zone.clearVehicles then
                for _, veh in pairs(GetGamePool("CVehicle")) do
                    local driver = GetPedInVehicleSeat(veh, -1)
                    local owner = NetworkGetEntityOwner(veh)

                    -- Supprime uniquement si c'est un véhicule NPC / spawn random
                    if (driver == 0 or not IsPedAPlayer(driver)) and (not owner or owner == -1) then
                        local vx, vy, vz = table.unpack(GetEntityCoords(veh))
                        if isPointInPolygon(vx, vy, zone.points) then
                            DeleteEntity(veh)
                        end
                    end
                end
            end

            -- Supprimer peds NPC seulement
            if zone.clearPeds then
                for _, ped in pairs(GetGamePool("CPed")) do
                    if not IsPedAPlayer(ped) then
                        local px, py, pz = table.unpack(GetEntityCoords(ped))
                        if isPointInPolygon(px, py, zone.points) then
                            DeleteEntity(ped)
                        end
                    end
                end
            end

            -- Affichage debug
            if Config.Debug then
                DrawPolyZone(zone)
            end
        end

        Wait(sleep)
    end
end)
